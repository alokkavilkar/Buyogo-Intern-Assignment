#Build the Docker Image out of Dockerfile

1. Clone the Git Repository
git clone https://github.com/alokkavilkar/python-app.git

2. Change the directory to python-app
cd python-app

3. Build docker image
docker build -t <docker-username>/app:01 .

4. Login CLI docker
echo "your_password" | docker login -u "your_username" --password-stdin

5. Push to public docker registry
docker push <docker-username>/app:01



