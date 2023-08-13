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
    stages {
        stage('Development | Prepering environment') {
            steps {
                sh 'apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python'
                sh 'python3 -m ensurepip'
                sh 'pip3 install --no-cache --upgrade pip setuptools'
                sh 'echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories'
                sh 'apk add --no-cache nodejs-current  --repository="http://dl-cdn.alpinelinux.org/alpine/edge/community"'
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