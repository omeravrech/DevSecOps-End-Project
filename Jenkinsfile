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
        stage("Build") {
            parallel {
                stage('Build | Create backend image') {
                    steps {
                        script {
                            docker.build("${env.BACK_IMAGE_NAME}", "--no-cache ./public")
                            def exitCode = sh(script: "docker inspect ${env.BACK_IMAGE_NAME} >/dev/null 2>&1", returnStatus: true)
                            if (exitCode != 0) {
                                error "Can't build backend image"
                            } else {
                                sh "docker run -p ${env.BACK_PORT}:5000 -d ${env.BACK_IMAGE_NAME}"
                            }
                        }
                    }
                }
                stage('Build | create frontend image') {
                    steps {
                        script {
                            docker.build("${env.FRONT_IMAGE_NAME}", "--no-cache ./public")
                            def exitCode = sh(script: "docker inspect ${env.FRONT_IMAGE_NAME} >/dev/null 2>&1", returnStatus: true)
                            if (exitCode != 0) {
                                error "Can't build fronend image"
                            } else {
                                sh "docker run -p ${env.FRONT_PORT}:3000 -d ${env.FRONT_IMAGE_NAME}"
                            }
                        }
                    }
                }
            }
        }
        
        stage("Test") {
            agent { docker "python:apline"}
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