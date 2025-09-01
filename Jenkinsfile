pipeline {
    agent any

    environment {
        AWS_REGION   = "us-east-1"   
        ECR_REPO     = "presto-app"
        ECR_REGISTRY = "460928920964.dkr.ecr.us-east-1.amazonaws.com"
        IMAGE_TAG    = "latest"   // can also use BUILD_NUMBER or GIT_COMMIT
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Login to AWS ECR') {
            steps {
                script {
                    sh """
                    aws ecr get-login-password --region $AWS_REGION \
                    | docker login --username AWS --password-stdin $ECR_REGISTRY
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                    docker build -t $ECR_REPO:$IMAGE_TAG .
                    docker tag $ECR_REPO:$IMAGE_TAG $ECR_REGISTRY/$ECR_REPO:$IMAGE_TAG
                    """
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    sh "docker push $ECR_REGISTRY/$ECR_REPO:$IMAGE_TAG"
                }
            }
        }
    }

    post {
        success {
            echo "✅ Docker image pushed to: $ECR_REGISTRY/$ECR_REPO:$IMAGE_TAG"
        }
        failure {
            echo "❌ Build failed!"
        }
    }
}

