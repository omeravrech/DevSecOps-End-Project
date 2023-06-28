pipeline {
    agent any
    environment {
        MAJOR_BUILD = 1
        MINOR_BUILD = 0
        BACK_IMAGE_NAME = "${env.GIT_BRANCH.toLowerCase()}-backend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID}"
        FRONT_IMAGE_NAME = "${env.GIT_BRANCH.toLowerCase()}-frontend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID}"
        COMPOSE_STATUS = false
    }
    stages {
        stage('Prepering environment') {
            parallel {
                stage('Backend build') {
                    steps {
                        script {
                            docker.build("${env.BACK_IMAGE_NAME}", "--no-cache ./server")
                        }
                    }
                }
                stage('Frontend build') {
                    steps {
                        script {
                            docker.build("${env.FRONT_IMAGE_NAME}", "--no-cache ./public")
                        }
                    }
                }
            }
        }
        stage('Verify images') {
            steps {
                script {
                    def exitCode1 = sh(script: "docker inspect ${env.BACK_IMAGE_NAME} >/dev/null 2>&1", returnStatus: true)
                    def exitCode2 = sh(script: "docker inspect ${env.FRONT_IMAGE_NAME} >/dev/null 2>&1", returnStatus: true)
                    if (exitCode1 != 0 || exitCode2 != 0) {
                        error "One or more builds failed"
                    }
                }
            }
        }
        stage('Raise dockers environment'){
            steps{
                withEnv(["BACK_IMAGE_NAME=${env.BACK_IMAGE_NAME}", "FRONT_IMAGE_NAME=${env.FRONT_IMAGE_NAME}"]) {
                    sh 'docker-compose up -d'
                }
                env.COMPOSE_STATUS = true
                
            }
        }
        stage('Post environment stage checks'){
            steps {
                script {
                    def response = httpRequest "http://localhost:3000"
                    sh "echo ${response}"
                    if (response.status != 200) {
                        error "Failed to get a successful response"
                    }
                }
            }
        }
    }
    post {
        cleanup {
            script {
                if (env.COMPOSE_STATUS) {
                    sh "docker-compose down"
                }
            }
            sh "docker rmi -f ${env.BACK_IMAGE_NAME}"
            sh "docker rmi -f ${env.FRONT_IMAGE_NAME}"
            cleanWs()
        }
    }
}
