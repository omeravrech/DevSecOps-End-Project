pipeline {
    agent any
    environment {
        FRONT_PORT = 3000
        BACK_PORT = 5000
        DB_PORT = 27107
        DOCKER_REPO_NAME="omeravrech"
    }
    stages {
        stage('Build Docker Images') {
            parallel {
                stage('Build Backend Image') {
                    steps {
                        script {
                            // Build backend Docker image
                            docker.build("${env.DOCKER_REPO_NAME}/backend-image:${env.BUILD_NUMBER}", "./server")
                            docker.build("${env.DOCKER_REPO_NAME}/backend-image:latest", "./server")
                        }
                    }
                }
                stage('Build Frontend Image') {
                    steps {
                        script {
                            // Build frontend Docker image
                            docker.build("${env.DOCKER_REPO_NAME}/frontend-image:${env.BUILD_ID}", "./public")
                            docker.build("${env.DOCKER_REPO_NAME}/frontend-image:latest", "./public")
                        }
                    }
                }
            }
        }
        stage("Raise environment") {
            options {
                timeout(time: 5, unit: 'MINUTES') 
            }
            steps {
                script {
                    // Run database container
                    docker.image("mongodb/mongodb-community-server:latest").run("--name database-container -p ${env.DB_PORT}:27017 -e MONGO_INITDB_DATABASE=chat -d")

                    // Run backend container
                    docker.image("${env.DOCKER_REPO_NAME}/backend-image:${env.BUILD_ID}").run("--link database-container --name backend-container -p ${env.BACK_PORT}:5000 -d")

                    // Run frontend container
                    docker.image("${env.DOCKER_REPO_NAME}/frontend-image:${env.BUILD_ID}").run("--link backend-container --name frontend-container -p ${env.FRONT_PORT}:3000 -d")

                    // Enter to busy-wait mode until the last docker start to run.
                    while (sh(script: "[ \$(docker ps | grep frontend-container | wc -l) -ne 0 ]", returnStatus: true) != 0) {
                        sleep(time: 2, unit: 'SECONDS')
                    }
                }
            }
        }
        stage("Run tests") {
            agent {
                docker {
                    image "python:slim"
                    args "--net=host"
                }
            }
            steps {
                sleep(time: 5, unit: 'SECONDS')
                withEnv([ "URL=http://localhost:${env.FRONT_PORT}" ]) {
                    sh 'pip3 install -r ./testing/requirements.txt'
                    sh 'pytest ./testing/main.py'
                }
            }
        }
        stage('Push Images to Docker Hub') {
            steps {
                // Define the DockerHub Credentials
                withCredentials([string(credentialsId: "DevSecOps-Token", variable: 'DOCKER_HUB_TOKEN')]) {
                    script {
                        sh "docker logout" // Logout first to clear any previous credentials
                        sh "echo $DOCKER_HUB_TOKEN | docker login --username omeravrech@gmail.com --password-stdin"
                        // Push backend image
                        echo "Pushing images for ${env.DOCKER_REPO_NAME}/backend-image"
                        sh "docker push ${env.DOCKER_REPO_NAME}/backend-image:${env.BUILD_ID}"
                        sh "docker push ${env.DOCKER_REPO_NAME}/backend-image:${env.BUILD_ID}"
                        echo "Succeed to push images for ${env.DOCKER_REPO_NAME}/backend-image"
                        // Push frontend image
                        echo "Pushing images for ${env.DOCKER_REPO_NAME}/frontend-image"
                        sh " docker push ${env.DOCKER_REPO_NAME}/frontend-image:${env.BUILD_ID}"
                        sh "docker push ${env.DOCKER_REPO_NAME}/frontend-image:${env.BUILD_ID}"
                        echo "Succeed to push images for ${env.DOCKER_REPO_NAME}/frontend-image"
                    }
               }
           }
        }
    }
    post {
        cleanup {
            sh 'docker rm -f database-container backend-container frontend-container'
            cleanWs()
        }
    }
}