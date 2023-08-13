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
            image "ubuntu"
            args "-u root" 
        }
    }
    stages {
        stage('Development | Prepering environment') {
            steps {
                sh 'apt upgrade'
                sh 'apt install -y software-properties-common'
                sh 'add-apt-repository ppa:deadsnakes/ppa'
                sh 'apt upgrade'
                sh 'apt install -y python3.8 nodejs npm'
            }
        }
        stage('Development | Intall dependencies') {
            steps {
                sh 'pip3 install -r requirements.txt'
                sh 'npm install'
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