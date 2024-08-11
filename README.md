
# Build the Docker Image out of Dockerfile

1. Clone the Git Repository
```bash
  git clone https://github.com/alokkavilkar/python-app.git
```
2. Change the directory to python-app
```bash
cd python-app
```

3. Build docker image
```bash
docker build -t <docker-username>/app:01 .
```
4. Login CLI docker
```bash
echo "your_password" | docker login -u "your_username" --password-stdin
```
5. Push to public docker registry
```bash
docker push <docker-username>/app:01
```

# Deployment of Application and MongoDB on Minikube

1. Start minikube cluster 

```bash
minikube start --memory=2200mb
```

2. Deployment of 2 replicas of Flask Application 

```bash
kubectl apply -f flask-deployment.yaml
```

3. NodePort Service for Flask deployment as its should be accessible to outside world.

```bash
kubectl apply -f flask-service.yaml
```

4. Horizonal Pod Autoscaler component / controller deployment as its should be there to monitor pod for cpu optimization and consumption reporting.

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

5. Attach HPA pod to Deployment for reporting cpu utilization

```bash
kubectl apply -f hpa-config.yaml
```

6. Storage Class provising for creating a Persistant Volumes dynamically and help with provisiong Volumes


```bash
kubectl apply -f storageclass.yaml
```


7. Deployment of Service (Headless) for MongoDB replicaset as Headless defines usage of application with static pod dns name.

```bash
kubectl apply -f mongo-service.yaml
```

8. Deployment of configmap for volumemount to pod of replicas to mongodb


```bash
kubectl apply -f mongo-config.yaml
```

9. Deployment for secret as MongoDB is administrated by Username and password


```bash
kubectl apply -f mongo-secret.yaml
```

10. Deployment of Persistant Volume claim for attach to pod which will interact with PV 


```bash
kubectl apply -f mongo-pvc.yaml
```


11. Deploying Stateful mongodb with headless service for provision static DNS name for attaching to URI ENV of flask deployment


```bash
kubectl apply -f mongo-stateful.yaml
```


Q.1 Include an explanation of how DNS resolution works within the Kubernetes cluster for inter-pod communication.

-> It allows pods to discover and communicate with each other using service names instead of IP addresses. As ips are ephimeral and can change as pod dies thus dns resolution helps comminucation of pod internally

With help of service we can achieve it, 

<service-name>: The name of the Service.
<namespace>: The Kubernetes namespace in which the Service is created.
svc.cluster.local: The default domain suffix for services within the cluster.

When a pod query a dns then it will reach to kube-dns then kube-dns will help resolving those dns query to service name and then absraction of service will resolves the IP of pod.


Q.2. Include an explanation of resource requests and limits in Kubernetes.

Resources in K8s can sometimes be memory exhaustive and thus can kill the pod which is important to us in cluster or node.

then requests and limits in deployment or statefulset help us achieve the capabilities of deployment with resource constraits

1. requests -> requests for minimal memoery and cpus to be allocated to pod while scheduling by default-scheduler

2. limits   -> limits are the pick memeory upto which pod can consume memoery cpu on node. when crossed that limit might get deloacted to antoher pod, thus help reosurce in one pod remain same or sustain thier lives into one node. 

Q.3 Design Choices: Describe why you chose the specific configurations and setups, including any alternatives(if any) you considered and why
you did not choose them

I uses volumemount as ConfigMap for mapping storage volume to help running configuration file. As pod exec start command is quiting exhaustive to pod lifecycle. Then With help of secret i did achieved authorization but the aternative way could be with network policy to remain unauthoized and only pods authorization can be acheivable

Q.4 Cookie point: Testing Scenarios: Detail how you tested autoscaling and database interactions, including simulating high traffic. Provide
results and any issues encountered during testing.

I did used sheel scripting knowledge of mine for developing a testing case. I did use a for loop for simulating a high traffic using curl and nodeport address for 100 times.

Then the cpu utilization overachieved but the pod component of minikibe hpa dies and thus not able to retrive the simulation of autoscaler. Then i have redeploy hpa and with shell scripting I did achieved auto scaling behaviour. 


