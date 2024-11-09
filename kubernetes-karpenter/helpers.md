# You will need to use metrics-server to collects metrics from your cluster

# Verify AWS User Permissions

1. aws sts get-caller-identity

# Set environment variables to create EKS Cluster

1.
  export KARPENTER_NAMESPACE="kube-system"
  export KARPENTER_VERSION="1.0.7"
  export K8S_VERSION="1.31"
  export AWS_PARTITION="aws" # if you are not using standard partitions, you may need to configure to aws-cn / aws-us-gov
  export CLUSTER_NAME="${USER}-karpenter-demo"
  export AWS_DEFAULT_REGION="us-west-2"
  export AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
  export TEMPOUT="$(mktemp)"
  export ARM_AMI_ID="$(aws ssm get-parameter --name /aws/service/eks/optimized-ami/${K8S_VERSION}/amazon-linux-2-arm64/recommended/image_id --query Parameter.Value --output text)"
  export AMD_AMI_ID="$(aws ssm get-parameter --name /aws/service/eks/optimized-ami/${K8S_VERSION}/amazon-linux-2/recommended/image_id --query Parameter.Value --output text)"
  export GPU_AMI_ID="$(aws ssm get-parameter --name /aws/service/eks/optimized-ami/${K8S_VERSION}/amazon-linux-2-gpu/recommended/image_id --query Parameter.Value --output text)"

2.
  curl -fsSL https://raw.githubusercontent.com/aws/karpenter-provider-aws/v"${KARPENTER_VERSION}"/website/content/en/preview/getting-started/getting-started-with-karpenter/cloudformation.yaml  > "${TEMPOUT}" \
&& aws cloudformation deploy \
  --stack-name "Karpenter-${CLUSTER_NAME}" \
  --template-file "${TEMPOUT}" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides "ClusterName=${CLUSTER_NAME}"

  eksctl create cluster -f - <<EOF
  ---
  apiVersion: eksctl.io/v1alpha5
  kind: ClusterConfig
  metadata:
    name: ${CLUSTER_NAME}
    region: ${AWS_DEFAULT_REGION}
    version: "${K8S_VERSION}"
    tags:
      karpenter.sh/discovery: ${CLUSTER_NAME}

  iam:
    withOIDC: true
    podIdentityAssociations:
    - namespace: "${KARPENTER_NAMESPACE}"
      serviceAccountName: karpenter
      roleName: ${CLUSTER_NAME}-karpenter
      permissionPolicyARNs:
      - arn:${AWS_PARTITION}:iam::${AWS_ACCOUNT_ID}:policy/KarpenterControllerPolicy-${CLUSTER_NAME}

  iamIdentityMappings:
  - arn: "arn:${AWS_PARTITION}:iam::${AWS_ACCOUNT_ID}:role/KarpenterNodeRole-${CLUSTER_NAME}"
    username: system:node:{{EC2PrivateDNSName}}
    groups:
    - system:bootstrappers
    - system:nodes
    ## If you intend to run Windows workloads, the kube-proxy group should be specified.
    # For more information, see https://github.com/aws/karpenter/issues/5099.
    # - eks:kube-proxy-windows

  managedNodeGroups:
  - instanceType: m5.large
    amiFamily: AmazonLinux2
    name: ${CLUSTER_NAME}-ng
    desiredCapacity: 2
    minSize: 1
    maxSize: 10

  addons:
  - name: eks-pod-identity-agent
  EOF

  export CLUSTER_ENDPOINT="$(aws eks describe-cluster --name "${CLUSTER_NAME}" --query "cluster.endpoint" --output text)"
  export KARPENTER_IAM_ROLE_ARN="arn:${AWS_PARTITION}:iam::${AWS_ACCOUNT_ID}:role/${CLUSTER_NAME}-karpenter"

  echo "${CLUSTER_ENDPOINT} ${KARPENTER_IAM_ROLE_ARN}"

3. Unless your AWS account has already onboarded to EC2 Spot, you will need to create the service linked role to avoid the ServiceLinkedRoleCreationNotPermitted error.

  $ aws iam create-service-linked-role --aws-service-name spot.amazonaws.com || true

  # If the role has already been successfully created, you will see:
  # An error occurred (InvalidInput) when calling the CreateServiceLinkedRole operation: Service role name AWSServiceRoleForEC2Spot has been taken in this account, please try a different suffix.

# Kubectl apply Manifests

1. kubectl apply -f "https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml"

# Helm Installation

1. helm search repo bitnami/rabbitmq --versions

helm show values bitnami/rabbitmq

2. helm repo add bitnami https://charts.bitnami.com/bitnami --force-update

3. Logout of helm registry to perform an unauthenticated pull against the public ECR
  - helm registry logout public.ecr.aws

4. HELM login to AWS
  - aws ecr-public get-login-password --region us-east-1 | helm registry login -u AWS --password-stdin public.ecr.aws

5. helm upgrade --install karpenter oci://public.ecr.aws/karpenter/karpenter \
  --set "settings.clusterName=test-karpenter-demo" \
  --set "settings.interruptionQueue=test-karpenter-demo" \
  --set controller.resources.requests.cpu=1 \
  --set controller.resources.requests.memory=1Gi \
  --set controller.resources.limits.cpu=1 \
  --set controller.resources.limits.memory=1Gi \
  --version "1.0.7" \
  --namespace "kube-system" \
  --create-namespace \
  --wait

6. As the OCI Helm chart is signed by Cosign as part of the release process you can verify the chart before installing it by running the following command.
  - cosign verify public.ecr.aws/karpenter/karpenter:1.0.7 \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com \
  --certificate-identity-regexp='https://github\.com/aws/karpenter-provider-aws/\.github/workflows/release\.yaml@.+' \
  --certificate-github-workflow-repository=aws/karpenter-provider-aws \
  --certificate-github-workflow-name=Release \
  --certificate-github-workflow-ref=refs/tags/v1.0.7 \
  --annotations version=1.0.7

  if you don't have DNS services running (DNS pods ) by default add this config bellow to allow karpenter (kubectl get deploy/coredns -n kube-system)
  --

# Helm Uninstallation

1. helm uninstall rabbitmq -n rabbitmq

2. kubectl delete ns rabbitmq

# Kubectl apply Output YAML

1. helm template rabbitmq bitnami/rabbitmq \
  --set auth.username=admin \
  --set auth.password=#R00t \
  --set auth.erlangCookie=AQ5GuKmX1FZnQ2LeTbbpoBQgaB2E9qlz \
  --set metrics.enabled=true \
  --version 15.0.5 \
  --namespace rabbitmq \
  --create-namespace \
  > ./rabbitmq-15.0.5.yaml

2. kubectl apply -f ./rabbitmq-15.0.5.yaml

# Forward ports

1. UI:
  - kubectl port-forward --namespace rabbitmq svc/my-rabbitmq 15672:15672

2. Broker:
  - kubectl port-forward --namespace rabbitmq svc/rabbitmq 5672:5672

3. Prometheus:
  - kubectl port-forward --namespace rabbitmq svc/rabbitmq 9419:9419

# Verify installation

1. kubectl get all -o wide -n rabbitmq-system

Persistent Storage:
  --set persistence.enabled=true \
  --set persistence.size=8Gi

username and password:
  --set auth.username=myuser \  
  --set auth.password=mypassword

TLS/SSL:
  --set auth.tls.enabled=true \
  --set auth.tls.existingSecret=my-tls-secret


High Availability:
  --set replicaCount=3

Monitoring:
  --set metrics.enabled=true

Scaling RabbitMQ Horizontally:
  --set replicaCount=3 \
  --set clustering.enabled=true \
  --set clustering.forceBoot=true

Load Balancing with Ingress:
  --set ingress.enabled=true \
  --set ingress.hostname=my-rabbitmq.example.com \
  --set ingress.tls=true \
  --set ingress.annotations."kubernetes\.io/ingress\.class"=nginx

# Managing Updates

With Helm, you can easily update your RabbitMQ installation by adjusting values and reapplying them. For example, to change resource limits or add a new plugin, you can update the Helm release:

  --set resources.requests.memory=512Mi \
  --set plugins="rabbitmq_management,rabbitmq_shovel,rabbitmq_federation"

# Credentials

Credentials:
    echo -e "Username      : admin"
    echo -e "Password      : $(kubectl get secret --namespace rabbitmq rabbitmq -o jsonpath="{.data.rabbitmq-password}" | base64 -d)"
    echo -e "ErLang Cookie : $(kubectl get secret --namespace rabbitmq rabbitmq -o jsonpath="{.data.rabbitmq-erlang-cookie}" | base64 -d)"
