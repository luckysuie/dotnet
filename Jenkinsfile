pipeline {
    agent any

    environment {
        ACR_NAME = "luckyregistry11"
        ACR_LOGIN_SERVER = "luckyregistry11.azurecr.io"
        IMAGE_NAME = "luck"
        IMAGE_TAG = "v1"
        RESOURCE_GROUP = "demo11"
        CLUSTER_NAME = "lucky-aks-cluster11"
    }

    stages {
        stage('Azure Login') {
            steps {
                withCredentials([
                    string(credentialsId: 'azure-client-id', variable: 'AZURE_CLIENT_ID'),
                    string(credentialsId: 'azure-client-secret', variable: 'AZURE_CLIENT_SECRET'),
                    string(credentialsId: 'azure-tenant-id', variable: 'AZURE_TENANT_ID'),
                    string(credentialsId: 'azure-subscription-id', variable: 'AZURE_SUBSCRIPTION_ID')
                ]) {
                    sh '''
                    az login --service-principal \
                        -u "$AZURE_CLIENT_ID" \
                        -p "$AZURE_CLIENT_SECRET" \
                        --tenant "$AZURE_TENANT_ID"

                    az account set --subscription "$AZURE_SUBSCRIPTION_ID"
                    '''
                }
            }
        }

        stage('ACR Login') {
            steps {
                sh 'az acr login --name $ACR_NAME'
            }
        }

        stage('Docker Build and Tag') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME .
                docker tag $IMAGE_NAME $ACR_LOGIN_SERVER/$IMAGE_NAME:$IMAGE_TAG
                '''
            }
        }

        stage('Push to ACR') {
            steps {
                sh 'docker push $ACR_LOGIN_SERVER/$IMAGE_NAME:$IMAGE_TAG'
            }
        }

        stage('Get AKS Credentials') {
            steps {
                sh 'az aks get-credentials --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --overwrite-existing'
            }
        }

        stage('Deploy to AKS') {
            steps {
                sh '''
                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml
                '''
            }
        }
    }

    post {
        success {
            echo 'Successfully deployed to AKS!'
        }
        failure {
            echo 'Deployment failed. Check logs.'
        }
    }
}