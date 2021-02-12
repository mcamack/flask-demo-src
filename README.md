# flask-demo-src
Source code to build a Python Flask app in Docker and deploy to Kubernetes

## Development Version
run `python3 app.py` to run a local Flask server, then visit `127.0.0.1:5000/`. 
Local mode will run with a debugger and automatically reload when changes are saved to the Python file.

Linting can be performed with: `python3 -m pylint app.py`

## Dockerized Version
The Docker version of this app contains a more production ready build instead of using the built in 
flask dev server. Build the Docker image with: `docker build -t flask-demo:v1.0 .`

The containerized version:
* runs a gunicorn server with multiple threads
* does a multi-stage build to reduce the final image size
* incorporates linting into the build process
* has gunicorn logs directed to stdout so k8s logging will pick it up
* runs as the app user instead of root

### Run in Docker
The docker image can be tested locally with: `docker run --rm -p 5000:5000 flask-demo:v1.0`

Use a web browser or curl to hit the endpoints:
* curl localhost:5000/
* curl localhost:5000/health
* curl localhost:5000/static/file.txt
* curl localhost:5000/static/binary.dat
* curl localhost:5000/static/3192.png

### Run in Kubernetes
The manifest can be used to create a flask-demo namespace, deployment, service, and the 
ingress object: `kubectl apply -f manifest.yaml`

If deploying to a local cluster (like docker desktop) the ingress may not do anything unless 
you have an ingress controller installed. The endpoints can still be tested by port forwarding 
the service: `kubectl port-forward service/service-flask-demo 5000`

Retrieve the logs across all of the flask-demo pods with: `kubectl logs -l app.kubernetes.io/name=flask-demo`

## Deployment Pipeline
I created 2 other repos for doing end-to-end CI/CD of this app on AWS infrastructure using Terraform:
* https://github.com/mcamack/flask-demo-infra
  * Creates an EKS cluster with 2 nodes
  * Installs ArgoCD
  * Creates a CodeBuild project w/webhook trigger (runs the buildspec.yaml file)
    * Builds this Docker Image and pushes to an ECR repo
* https://github.com/mcamack/flask-demo-deployment
  * create_argocd_app.sh would login to the argocd server, create a new flask-demo app, and sync the project
  * the app monitors the argocd folder for changes to the manifest files and deploys to the cluster

Unfortunately, I don't have enough time to fix the bugs present in the AWS Load Balancer Controller which 
is responsible for spinning up a load balancer for the ingress resource :(