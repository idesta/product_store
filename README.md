#### React, Javascript, Node, Express, MongoDB (Atlas), CRUD Ops, Docker, CICD (Github Actions)

#### Simple Deployment Steps

- Launch an instance
- Install Docker and Git on it
  - `curl https://get.docker.com | bash`
- git clone https://github.com/idesta/product_store.git
- cd product_store/
- `ls` -> to check the docker file existed on it
- `docker build -t prd_str_cicd .`
- `docker images`
  - to list the build image
- `docker run -d --name prd_str_cicd_demo -p 5000:5000 prd_str_cicd`
  - to list the running containers
    - `docker ps` or `docker ps -a`
    - If there is no up containers folloe the next steps
      - Inside the product_store folder
        - `touch .env`
        - Copy and paste the `mongo url` and `port` from the local repo
        - Remove the running container if exists
          - `docker rm prd_str_cicd_demo`
        - Run by passing the `.env` manually
          - ``docker run -d --name prd_str_cicd_demo --env-file .env -p 5000:5000 prd_str_cicd
- Check on your browser

  - Instance_Public_IP:5000
  - Test the functionality

- On your local repo

  - `mkdir -p .github/workflows` or simply create `.github` folder and inside of it create `workflows` directory.
  - Create and put `ci_cd.yml` file on the .github/workflows directory

- Put the instance username (ubuntu) on the docker group

  - Be the super user (root) `sudo su`
  - `usermod -aG docker ubuntu`
  - Exit from the root and try to list the docker images
    - If not works disconnect and reconnect again

- Make sure the secrets are correct
- Remove the container from the Instance, Make an update and push to github and see the details
