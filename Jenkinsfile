pipeline {
    agent {
        docker {
            image "alpine"
        }
    }
    environment {
        MAJOR_BUILD = 1
        MINOR_BUILD = 0
        BACK_IMAGE_NAME = "${env.GIT_BRANCH.toLowerCase()}-backend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID}"
        BACK_PORT = 5000
        FRONT_IMAGE_NAME = "${env.GIT_BRANCH.toLowerCase()}-frontend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID}"
        FRONT_PORT = 3000
    }
    stages {stage('Development | Prepering environment - copy repo') {
            steps {
                sh 'apk add --update --no-cache git'
                sh 'printenv'
            }
        }
        stage('Development | Prepering environment - install python') {
            steps {
                sh 'apk add --update --no-cache python3'
                sh 'ln -sf python3 /usr/bin/python'
                sh 'python3 -m ensurepip'
            }
        }
        stage('Development | Prepering environment - install node') {
            steps {
                sh 'apk add --update --no-cache nodejs npm'
            }
        }
        stage('Development | Startup server') {
            steps {
                withEnv([
                    "PORT=${env.FRONT_PORT}"
                ]) {
                    sh 'npm install'
                    sh 'npm start -d'
                }
            }  
        }
        stage('Verify developing') {
            steps{
                sh 'pytest main.py'
            }
        }
    }
}