pipeline {
    agent any
    environment {
        MAJOR_BUILD = 1
        MINOR_BUILD = 0
    }
    stages {
        stage('Prepering environment') {
            parallel {
                stage('Backend build') {
                    steps {
                        sh "docker build -t backend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID} ./server"
                        sh "docker tag backend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID} backend:latest"
                    }
                }
                stage('Frontend build') {
                    steps {
                        sh "docker build -t frontend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID} ./public"
                        sh "docker tag frontend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID} frontend:latest"
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
        stage('Clean up'){
            steps{
                sh "docker-compose down"
                sh "docker rmi -f backend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID}"
                sh "docker rmi -f frontend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID}"
            }
        }
    }
}
