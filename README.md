# flask-demo-src
Source code to build a Python app in Docker

## Test Locally
run `python3 app.py` to run a local Flask server, then visit `127.0.0.1:5000/`. 
Local mode will run with a debugger and automatically reload when changes are saved to the Python file.

## Linting
`python3 -m pylint app.py`

# Docker
The Docker version of this app will run a gunicorn server instead of the 
Build Docker image with: `docker build -t flask-demo:v0.1 .`

Run locally with: `docker run --rm -p 5000:5000 flask-demo:v0.1`

curl to hit the endpoints:
* curl localhost:5000/
* curl localhost:5000/health