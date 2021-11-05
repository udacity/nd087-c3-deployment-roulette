# Deployment Roulette

## Getting Started

### Dependencies
- Udacity AWS Gateway
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [awscli](https://aws.amazon.com/cli/)
- [eksctl](https://eksctl.io/introduction/#installation)
- [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)
- [helm](https://www.eksworkshop.com/beginner/060_helm/helm_intro/install/)


### Installation

Step by step explanation of how to get a dev environment running.
----------
The AWS environment will be built in the `us-east-2` region of AWS

1. Set up your AWS credentials from Udacity AWS Gateway locally
   - `https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html`

2. From the AWS console manually create an S3 bucket in `us-east-2` called `udacity-tf-<your_name>` e.g `udacity-tf-emmanuel`
   - The click `create bucket`
   - Update `_config.tf` with your S3 bucket name

3. Deploy Terraform infrastructure
   - `terraform init`
   - `terraform apply`

4. Setup Kubernetes config so you can ping the EKS cluster
   - `aws eks --region us-east-2 update-kubeconfig --name udacity-cluster`
   - Change Kubernetes context to the new AWS cluster
     - `kubectl config use-context <cluster_name>`
       - e.g ` arn:aws:eks:us-east-2:139802095464:cluster/udacity-cluster`
   - Confirm with: `kubectl get pods --all-namespaces`
   - Change context to `udacity` namespace
     - `kubectl config set-context --current --namespace=udacity`

5. Run K8s initialization script
   - `./initialize_k8s.sh`

6. Done

### Project Tasks
*NOTE* All AWS infrastructure changes outside of the EKS cluster can be made in the project terraform code

1. [CI-CD to AWS] 
The previous team did not have time to implement a `CI/CD` Solution. You decide you need to automate this process to free your hands to work on other tasks
   1. Create a GitHub repository to house your solution.
   2. Students should set up a CI/CD pipeline with GitHub Actions that can access the AWS environment with your classroom `AWS Access Key ID`, `AWS Secret Access Key`, & `AWS Session Token`
2. [Deployment Troubleshooting]
A previously deployed microservice `hello-world` doesn't seem to be reachable at its public endpoint. The product teams need you to fix this asap!
   1. The `apps/hello-world` deployment is facing deployment issues. 
      - Assess, identify and resolve the problem with the deployment
      - Document your findings via screenshots or text files.
3. [Canary deployments]  
The product teams want a canary deployment for v2 of the `/apps/canary` microservice, so that they may safely test new features 
   1. Create a shell script `canary.sh` that will be executed by GitHub actions.
   2. Canary deploy `/apps/canary-v2` so they take up 50% of the client requests 
   3. Curl the service 10 times and save the results to `canary.txt`
      - Ensure that it is able to return results for both services
   4. Provide the output of `kubectl get pods --all-namespaces` to show deployed services
4. [Blue-green deployments]
The product teams want a blue-green deployment for the `green` version of the `/apps/blue-green` microservice because they heard it's even safer than canary deployments
   1. Create a shell script `blue-green.sh` that executes a `green` deployment for the service `apps/blue-green`
   2. mimic the blue deployment configuration and replace the `index.html` with the values in `green-config` config-map
   3. The bash script will wait for the new deployment to successfully roll out and the service to be reachable.
   4. Create a new weighted CNAME record `blue-green.udacityproject` in Route53 for the green environment
   5. Use the `curl` ec2 instance to curl the `blue-green.udacityproject` url and document that green & blue services are reachable
   6. Simulate a failover event to the `green` environment by destroying the blue environment
   7. Ensure the `blue-green.udacityproject` record now only returns the green environment
      - curl `blue-green.udacityproject` and save the results in `blue-green.txt` from the `curl` ec2 instance
5. [Node elasticity]
A microservice `bloaty-mcface` must be deployed for compliance reasons before the company can continue business. Ensure it is deployed successfully
   1. Deploy `apps/bloatware` microservice
   2. Identify if the application deployment was successful and if not resolve any issues found
   3. Provide the output of `kubectl get pods --all-namespaces` to show deployed services
6. [Observability with metrics]
You have realized there is no observability in the Kubernetes environment. You suspect there is a service unnecessarily consuming too much memory and needs to be removed
   1. Install a metrics server on the kubernetes cluster and identify the service using up the most memory 
      - Log the output of the metrics command used to a file called `before.txt` 
   2. Delete the service with the most memory usage from the cluster
      - Log the output of the same metrics command to a file called `after.txt`
7. [Diagramming the cloud landscape with Bob Ross]  
In order to improve the onboarding of future developers. You decide to create an architecture diagram so that they don't have to learn the lessons you have learnt the hard way.
   1. Create an architectural diagram that accurately describes the current status of your AWS environment.


## Project Clean Up
In an effort to reduce your cost footprint in the AWS environment. Feel free to tear down your aws environment when not in use.
Clean up the environment with the `nuke_everything.sh` script or run the steps individually
```
terraform state rm kubernetes_namespace.udacity && terraform state rm kubernetes_service.blue
eksctl delete iamserviceaccount --name cluster-autoscaler --namespace kube-system --cluster udacity-cluster --region us-east-2
kubectl delete all --all -n udacity
terraform destroy
```

## License
[License](../LICENSE.md)
