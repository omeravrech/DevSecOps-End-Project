pipeline {
    agent any
    environment {
        FRONT_PORT = 3000
        BACK_PORT = 5000
        DB_PORT = 27107
        DOCKER_REPO_NAME="omeravrech/devsecops12"
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
                            docker.build("${env.DOCKER_REPO_NAME}/frontend-image:${env.BUILD_NUMBERE}", "./public")
                            docker.build("${env.DOCKER_REPO_NAME}/frontend-image:latest", "./public")
                        }
                    }
                }
            }
        }
        stage("Raise environment") {
            steps {
                script {
                    // Run database container
                    docker.image("mongo:slim").run("--name database-container -p ${env.DB_PORT}:27017 -d")

                    // Run backend container
                    docker.image("${env.DOCKER_REPO_NAME}/backend-image:${env.BUILD_NUMBERE}").run("--link database-container --name backend-container -p ${env.BACK_PORT}:5000 -d")

                    // Run frontend container
                    docker.image("${env.DOCKER_REPO_NAME}/frontend-image:${env.BUILD_NUMBERE}").run("--link backend-container --name frontend-container -p ${env.FRONT_PORT}:3000 -d")

                    // Enter to busy-wait mode until the last docker start to run.
                    while (sh(script: "[ \$(docker ps | grep frontend-container | wc -l) -ne 0 ]", returnStatus: true) != 0) {
                        sleep 2
                    }
                }
            }
        }
        stage('Verify Containers') {
            steps {
                script {
                    def backendStatus = docker.inside("--rm backend-container", 'sh', '-c', 'echo "Backend is running"')
                    def frontendStatus = docker.inside("--rm frontend-container", 'sh', '-c', 'echo "Frontend is running"')

                    if (backendStatus.trim() != "Backend is running" || frontendStatus.trim() != "Frontend is running") {
                        error "Container verification failed"
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
                withEnv([ "URL=http://localhost:${env.FRONT_PORT}" ]) {
                    sh 'pip3 install -r ./testing/requirements.txt'
                    sh 'pytest ./testing/main.py'
                }
            }
        }
        stage('Push Images to Docker Hub') {
            steps {
                script {
                    // Define the DockerHub Credentials
                    def dockerHubCredentials = credentials('DevSecOps-Token')

                    docker.withRegistry('https://registry.hub.docker.com', dockerHubCredentials) {
                        
                        // Push backend image
                        docker.image("${env.DOCKER_REPO_NAME}/backend-image:${env.BUILD_NUMBERE}").push()
                        
                        // Push backend latest image
                        docker.image("${env.DOCKER_REPO_NAME}/backend-image:${env.BUILD_NUMBERE}").push()

                        // Push frontend image
                        docker.image("${env.DOCKER_REPO_NAME}/frontend-image:${env.BUILD_NUMBERE}").push()

                        // Push frontend latest image
                        docker.image("${env.DOCKER_REPO_NAME}/frontend-image:${env.BUILD_NUMBERE}").push()
                    }
                }
            }
        }
    }
    post {
        cleanup {
            sh 'docker stop backend-container frontend-container database-container'
            sh 'docker rm backend-container frontend-container database-container'
            cleanWs()
        }
    }
}