pipeline {
    agent any
    environment {
        MAJOR_BUILD = 1
        MINOR_BUILD = 0
        FRONT_IMAGE_NAME = "${env.GIT_BRANCH}-frontend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID}"
        BACK_IMAGE_NAME = "${env.GIT_BRANCH}-backend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID}"
        backendImage = ""
        frontendImage = ""
    }
    stages {
        stage('Prepering environment') {
            parallel {
                stage('Backend build') {
                    steps {
                        script {
                            env.backendImage = docker.build(env.BACK_IMAGE_NAME, "./server")
                        }
                    }
                }
                stage('Frontend build') {
                    steps {
                        script {
                            env.frontendImage = docker.build(env.BACK_IMAGE_NAME, "./server")
                        }
                    }
                }
            }
        }
        stage('Raise dockers environment') {
            steps {
                sh 'docker-compose up -d'
            }
        }
        stage('Post environment stage checks'){
            steps {
                script {
                    def response = httpRequest "http://localhost:3000"
                    if (response.status != 200) {
                        error "Failed to get a successful response"
                    }
                }
            }
        }
    }
    post {
        failure {
            sh "docker-compose down"
            sh "docker rmi -f ${env.backendImage.imageName()}"
            sh "docker rmi -f ${env.frontendImage.imageName()}"
        }
        cleanup {
            cleanWs()
        }
    }
}
