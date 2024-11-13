<p align="center">
  <a href="" rel="noopener">
 <img width=200px height=200px src="https://keda.sh/img/logos/keda-icon-color.png" alt="Project logo"></a>
</p>

<h3 align="center">Using KEDA on EKS cluster</h3>

---

<p align="center">Deploy an EKS cluster and KEDA Event-driven Autoscaling.</p>

## 📝 Table of Contents

- [About](#about)
- [Techs](#techs)
- [Prerequisites](#prerequisites)
- [Deployment](#deployment)
- [Testing scaling with KEDA](#keda)
- [Authors](#authors)

## 🧐 About <a name = "about"></a>

In this repo you will be able to deploy your own infraestructure on AWS, cluster kubernetes using EKS (Elastic Kubernetes Service), SQS (Simple Queue Service) and KEDA (Event-driven Autoscaling) using HELM.

## ⛏️ Built Using <a name = "techs"></a>

- [AWS Cli](https://www.mongodb.com/) - AWS Cli for authenticate with your AWS Account.
- [Terraform](https://expressjs.com/) - IaC (Infra as Code) for automatic deployment in the AWS Cloud.
- [EKS](https://vuejs.org/) - Dedicated service for deploying a  Kubernetes cluster on AWS.
- [SQS](https://nodejs.org/en/) - Dedicated Service for Queue (Messaging) Deployment on AWS.
- [HELM](https://nodejs.org/en/) - A package manager for automatically deploying Kubernetes tools.
- [Makefile](https://nodejs.org/en/) - Simple tool to compose many CLI commands.

## 🏁 Prerequisites <a name = "prerequisites"></a>

We recommend you to use <b>Linux</b> or <b>WSL in windows.</b><br/>
We assume you already have these tools bellow before continue, if not, make sure you have done so before continuing:
 - kubectl CLI.
 - AWS CLI.
 - Terraform CLI.
 - make CLI installed and configured.

## 🚀 Deployment <a name = "deployment"></a>

Don't forget to <b>Configure your Terraform Variables (terraform.tfvars)</b> inside folders.<br/>
You need to deploy your Kubernetes cluster on AWS (EKS) first, this will take between 7 and 20 minutes, then you can continue deploying SQS and configuring KEDA.

### Deploy EKS

Inside the project enter the EKS folder and set up with terraform.

```
$ cd ./infra/EKS/
$ make exec
```

### Set EKS as default context for kubectl

Update your kubectl context.

```
$ aws eks update-kubeconfig --region us-east-1 --name eks-demo
```

### Deploy SQS

Inside the project enter the queue folder and set up with terraform.

```
$ cd ./infra/queue/
$ make exec
```

### Install KEDA on EKS

Inside the project enter the KEDA folder and set up with terraform.

```
$ cd ./infra/KEDA/
$ make exec
```

### Deploy KEDA on EKS

First we need configure the KEDA scaling on kubernetes.

```
kubectl apply -f ./kubernetes/KEDA-deploy.yaml
```

## 🎈 Testing KEDA <a name="keda"></a>

Fulfill your queue using bash script<br/>
<b>*Don't forget to substitute \<Queue URL\> with your Queue URL on AWS*</b>
```
$ chmod +777 ./kubernetes/fill-queue.sh
$ ./kubernetes/fill-queue.sh
```

Open another terminal tab and observe the scaling of the PODs in the default namespace
```
watch -n 1 kubectl get all --namespace default
```

## ✍️ Authors <a name = "authors"></a>

- [@paulopkl](https://github.com/paulopkl) - Idea & Initial work
