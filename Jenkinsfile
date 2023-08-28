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
                stages {
                    stage("Frontend") {
                        agent {
                            docker { image: "node:alpine"}
                        }
                        steps {
                            sh 'ls -la'
                        }
                    }
                    stage("Backend") {
                        agent {
                            docker { image: "python:alpine"}
                        }
                        steps {
                            sh 'ls -la'
                        }
                    }
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