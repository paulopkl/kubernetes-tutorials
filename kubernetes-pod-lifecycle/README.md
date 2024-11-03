1. Init containers:
    1. initializes a container which must run and complete the lifecycle to then executes the main container
    2. for example, if the app need to have a connection to database, so initContainer will block acess til be ready 

2. Using only Pods, you cannot change resources requests or limits!

3. the default strategy of deployment is RollingUpdate, but you have Recreate
    RollingUpdate: Zero-downtime, gradually replaces old pods by new ones. 
    Recreate: The deployment controller will terminate all existing pods first and then create new ones
        usually used when you need to quicly deploy new version, and eliminate the old one.
    Canary:
    Blue/Green: 

    1. If you are using a PersistentVolumeClaim, be carefull because you cannot use RollingUpdate, you will need to use Recreate, 'cuz you cannot attach an existent volume to a second Pod

    2. always use PersistentVolumeClaim ReadWriteOnce with a deployment of unique replica

    3. In Wordpress + MySQL for example, you will need to share the same volume, you'll need to use ReadWriteMany in this case.

    4. ReadWriteMany allows many Pods to use the single Volume, but pay attention, because you can have a pod inside another cloud region, and it can be an issue.
        You cannot attach a volume to a node located in a different zone within cloud provider

    5. So if you want to scale your application, preffer to use StatefulSet:
        For example, if you have 3 replicas, it will create 3 volumes for each replica
            1 Pods = 1 PersistentVolumeClaims
            3 Pods = 3 PersistentVolumeClaims
            5 Pods = 5 PersistentVolumeClaims

    6. We don't acess Nodes by SSH to collect logs, we usually send them to a Logs centralized app like:
        - Grafana Loki
        - CloudWatch
        - ElasticSearch

    7. but we can make a Deployment of fluent-bit with node-affinity. But it is bad because we need to scale up or down our cluster. We should use "DaemonSet" for that.
        DaemonSet deploys a single Pod in one Node, for exaple:
            1 Node = 1 Pod
            2 Nodes = 2 Pods (1 per Node)
            5 Nodes = 5 Pods (1 per Node)

    8. A usecase for DaemonSet is Rook or ceph, that abstract local node's Disk and provides as object storage 
        - Othe usecase for DaemonSet is use Prometheus Node Exporter, which collects CPU memory, network. On top of
        "server metrics"
        - Use cadvisor agent on each node to collect container metrics

    9. A monitoring agent usually takes 1 vCPU, be careful use larger instances 1vCPU /16vCPU

    10. If you want to run a migration and wait it be sucessfully terminated, even if it takes 20 minutes and the node die. You will create Job, that kubernetes will handle it for you

    11. Airflow uses Jobs to run distributed data pipelines, you need to use Parallel Jobs

    12. If you want to backup a database every day, you will need to run CronJob
        or Generate a report every day.

    13. Operator extends Kubernetes funcionalities, for example Kakfa Operator, can easily the deployment of Kafka Agents
        - usecase of Prometheus Operator

