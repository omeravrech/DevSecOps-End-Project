pipeline {
    environment {
        MAJOR_BUILD = 1
        MINOR_BUILD = 0
        BACK_IMAGE_NAME = "${env.GIT_BRANCH.toLowerCase()}-backend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID}"
        BACK_PORT = 5000
        FRONT_IMAGE_NAME = "${env.GIT_BRANCH.toLowerCase()}-frontend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID}"
        FRONT_PORT = 3000
    }
    
    agent {
        docker {
            image "alpine:latest"
            args "-u root" 
        }
    }
    stages {
        stage('Development | Prepering environment') {
            steps {
                sh 'apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python'
                sh 'python3 -m ensurepip'
                sh 'apk add --update nodejs npm'
                sh 'pip install -r requirements.txt'
            }
        }
        stage('Development | Startup server') {
            steps {
                withEnv([
                    "PORT=${env.FRONT_PORT}"
                ]) { sh 'npm start -d' }
            }  
        }
        stage('Verify developing') {
            steps{
                sh 'pytest main.py'
            }
        }
    }
}