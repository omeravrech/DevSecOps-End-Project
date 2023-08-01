pipeline {
    agent any
    environment {
        MAJOR_BUILD = 1
        MINOR_BUILD = 0
        BACK_IMAGE_NAME = "${env.GIT_BRANCH.toLowerCase()}-backend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID}"
        BACK_PORT = 5000
        FRONT_IMAGE_NAME = "${env.GIT_BRANCH.toLowerCase()}-frontend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID}"
        FRONT_PORT = 3000
    }
    stages {
        stage('Development | Prepering environment') {
            steps {
                sh 'pip install -r requirements.txt'
                sh 'npm install'
            }
        }
        stage('Development | Startup server') {
            withEnv([
                "PORT=${env.FRONT_PORT}"
            ]) {
                steps {
                    'npm start -d'
                }
            }
        }
        stage('Verify developing') {
            sh 'pytest main.py'
        }
    }
}