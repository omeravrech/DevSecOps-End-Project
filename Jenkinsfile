pipeline {
    agent any
    environment {
        MAJOR_BUILD = 1
        MINOR_BUILD = 0
        BACK_IMAGE_NAME = "${env.GIT_BRANCH.toLowerCase()}-backend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID}"
        FRONT_IMAGE_NAME = "${env.GIT_BRANCH.toLowerCase()}-frontend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID}"
        FRONT_PORT = 3000
        BACK_PORT = 5000
        DB_PORT = 27107
    }
    stages {
        stage("Build") {
            parallel {
                stage('Build | Create backend image') {
                    steps {
                        sh "docker build -t ${env.BACK_IMAGE_NAME} ./public"
                    }
                }
                stage('Build | create frontend image') {
                    steps {
                        sh "docker build -t ${env.FRONT_IMAGE_NAME} ./public"
                    }
                }
            }
        }
        stage("Raise environment") {
            steps {
                script {
                    sh "docker-compose up &"
                    def exitCode = 1
                    while (exitCode != 0) {
                        sleep 1
                        exitCode = sh(script: "[ \$(docker ps | grep ${env.FRONT_IMAGE_NAME} | wc -l) -ne 0 ]", returnStatus: true)
                    }
                    sh 'docker ps'
                }
                
            }
        }
        stage("Test") {
            agent { docker "python:slim"}
            steps {
                withEnv([ "URL=http://localhost:${env.FRONT_PORT}" ]) {
                    sh 'ip a'
                    sh 'pip3 install -r ./testing/requirements.txt'
                    sh 'pytest ./testing/main.py'
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
                    echo 'environment is stopped.'
                }
            }
            sh "docker rmi -f ${env.BACK_IMAGE_NAME}"
            sh "docker rmi -f ${env.FRONT_IMAGE_NAME}"
            cleanWs()
        }
    }
}