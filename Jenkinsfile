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
        stage("Deployment") {
            parallel {
                stage("Frontend") {
                    agent { docker "node:alpine" }
                    steps {
                        withEnv(["PORT=${env.FRONT_PORT}"]) {
                            sh 'npm install --prefix "./public/"'
                            sh 'npm start --prefix "./public/" &'
                        }
                    }
                }
                stage("Backend") {
                    agent { docker "node:alpine" }
                    steps {
                        withEnv(["PORT=${env.BACK_PORT}"]) {
                            sh 'npm install --prefix "./server/"'
                            sh 'npm start --prefix "./server/" &'
                        }
                    }
                }
            }
        }
        stage("Test") {
            agent { docker "python:alpine" }
            steps {
                withEnv([ "URL=http://localhost:${env.FRONT_PORT}" ]) {
                    sh 'pip3 install -r requirements.txt'
                    sh 'pytest main.py'
                }
            }
        }
    }
    post {
        cleanup {
            script {
                try {
                    sh "docker-compose down"
                } finally {
                    sh 'echo docker-compose not running.'
                }
            }
            sh "docker rmi -f ${env.BACK_IMAGE_NAME}"
            sh "docker rmi -f ${env.FRONT_IMAGE_NAME}"
            cleanWs()
        }
    }
}