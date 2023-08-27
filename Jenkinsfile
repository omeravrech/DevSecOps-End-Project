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
        stage('General | Prepering environment') {
            parallel {
                stage('Backend | Build') {
                    steps {
                        script {
                            docker.build("${env.BACK_IMAGE_NAME}", "--no-cache ./server")
                        }
                    }
                }
                stage('Frontend | Build') {
                    steps {
                        script {
                            docker.build("${env.FRONT_IMAGE_NAME}", "--no-cache ./public")
                        }
                    }
                }
            }
        }
        stage('General | Verify images') {
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
        stage('General | Raise dockers environment'){
            steps{
                withEnv([
                    "BACK_IMAGE_NAME=${env.BACK_IMAGE_NAME}",
                    "BACK_PORT=${env.BACK_PORT}",
                    "FRONT_IMAGE_NAME=${env.FRONT_IMAGE_NAME}",
                    "FRONT_PORT=${env.FRONT_PORT}"
                ]) {
                    sh 'docker-compose up -d'
                }

            }
        }
        stage('General | Integrity checks'){
            parallel {
                stage("Frontend | Integrity checks") {
                    steps {
                        script {
                            def response = null
                            retry(3) {
                                sleep 10
                                response = httpRequest "http://localhost:${env.FRONT_PORT}"
                            }
                            if ((response == null) || (response.status != 200)) {
                                error "Failed to get a successful response"
                            }
                        }
                    }
                }
                // stage("Backend | Integrity checks") {
                //     steps {
                //         script {
                //             def response = null
                //             retry(3) {
                //                 sleep 10
                //                 response = httpRequest(
                //                     url: "http://localhost:${env.BACK_PORT}/api/auth/register",
                //                     httpMode: 'POST',
                //                     requestBody: '{ "username": "test-user", "email": "test@email.com", "password": "some-test-password"}',
                //                     customHeaders: [[name: 'Content-Type', value: 'application/json'], [name: 'Origin', value: "http://localhost:${env.FRONT_PORT}"]]
                //                 )
                //             }
                //             if ((response == null) || (response.status != 200)) {
                //                 error "Failed to get a successful response"
                //             }
                //         }
                //     }
                // }
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