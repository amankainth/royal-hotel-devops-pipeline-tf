pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Pulling code from GitHub...'
                checkout scm
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                dir('terraform') {
                    echo 'Initializing Terraform...'
                    sh 'terraform init'
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    echo 'Provisioning Server 2 (dev-instance)...'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

    }
}