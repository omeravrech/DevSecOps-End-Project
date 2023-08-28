pipeline {
    agent {
        docker {
            image "alpine"
        }
    }
    environment {
        MAJOR_BUILD = 1
        MINOR_BUILD = 0
        BACK_IMAGE_NAME = "${env.GIT_BRANCH.toLowerCase()}-backend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID}"
        BACK_PORT = 5000
        FRONT_IMAGE_NAME = "${env.GIT_BRANCH.toLowerCase()}-frontend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID}"
        FRONT_PORT = 3000
    }
    stages {
        stage('Development | Prepering environment - install python') {
            steps {
                sh 'apk add --update --no-cache python3'
                sh 'ln -sf python3 /usr/bin/python'
                sh 'python3 -m ensurepip'
            }
        }
        stage('Development | Prepering environment - install node') {
            steps {
                sh 'apk add --update --no-cache nodejs npm'
            }
        }
        stage('Development | Startup server') {
            steps {
                withEnv([
                    "PORT=${env.FRONT_PORT}"
                ]) {
                    sh 'npm install --prefix "./public/"'
                    sh 'npm start --prefix "./public/" &'
                    sleep(time:10, unit:"SECONDS")
                }
            }  
        }
        stage('Development | Verify server') {
            steps{
                withEnv([
                    "URL=http://localhost:${env.FRONT_PORT}"
                ]) {
                    sh 'pip3 install -r requirements.txt'
                    sh 'pytest main.py'
                }
            }
        }
	stage('Build | Prepering environment') {
            parallel {
                stage('Create backend image') {
                    steps {
                        script {
                            docker.build("${env.BACK_IMAGE_NAME}", "--no-cache ./server")
                        }
                    }
                }
                stage('Create frontend image') {
                    steps {
                        script {
                            docker.build("${env.FRONT_IMAGE_NAME}", "--no-cache ./public")
                        }
                    }
                }
            }
        }
	stage('Build | Verify images') {
            steps {
                script {
                    def exitCode1 = sh(script: "docker inspect ${env.BACK_IMAGE_NAME} >/dev/null 2>&1", returnStatus: true)
                    def exitCode2 = sh(script: "docker inspect ${env.FRONT_IMAGE_NAME} >/dev/null 2>&1", returnStatus: true)
                    if (exitCode1 != 0 || exitCode2 != 0) {
                        error "One or more builds failed."
                    }
                }
            }
        }
        stage('Build | Push to dockerhub') {
            steps {
                scripts {
                    def exitCode1 = sh(script: "docker image push --all-tags ${env.GIT_BRANCH.toLowerCase()}-backend >/dev/null 2>&1", returnStatus: true)
                    def exitCode1 = sh(script: "docker image push --all-tags ${env.GIT_BRANCH.toLowerCase()}-frontend >/dev/null 2>&1", returnStatus: true)
                    if (exitCode1 != 0 || exitCode2 != 0) {
                        error "One or more images doesn't succeed to be push."
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