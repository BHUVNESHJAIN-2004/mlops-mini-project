#!/bin/bash
# Login to AWS ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 825370131926.dkr.ecr.us-east-1.amazonaws.com
docker push 825370131926.dkr.ecr.us-east-1.amazonaws.com/mlops-ecr:v2

if [ "$(docker ps -q -f name=my-app)" ]; then
    docker stop my-app
fi

if [ "$(docker ps -aq -f name=my-app)" ]; then
    docker rm my-app
fi

docker run -d  -p 80:5000  -e DAGSHUB_PAT=91248af580630e2cce3a1d80cb822139ffb40c32  --name my-app  825370131926.dkr.ecr.us-east-1.amazonaws.com/mlops-ecr:v2
