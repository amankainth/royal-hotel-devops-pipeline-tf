pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        TMPDIR            = '/var/tmp'
        JAVA_TOOL_OPTIONS = '-Djava.io.tmpdir=/var/tmp'
        // Enable detailed logging for Terraform
        TF_LOG            = 'INFO' 
        // Force non-interactive mode so Terraform fails instead of hanging on input prompts
        TF_INPUT          = '0' 
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
                    // Using -input=false explicitly
                    sh 'terraform plan -input=false'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    echo 'Provisioning Server 2 (dev-instance)...'
                    sh 'terraform apply -input=false -auto-approve'
                }
            }
        }
    }

    post {
        always {
            cleanWs deleteDirs: true, notFailBuild: true
        }
    }
}
