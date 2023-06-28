pipeline {
    agent any
    environment {
        MAJOR_BUILD = 1
        MINOR_BUILD = 0
        BACK_IMAGE_NAME = "${env.GIT_BRANCH.toLowerCase()}-backend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID}"
        FRONT_IMAGE_NAME = "${env.GIT_BRANCH.toLowerCase()}-frontend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID}"
        BACK_IMAGE = null
        FRONT_IMAGE = null
    }
    stages {
        stage('Prepering environment') {
            parallel {
                stage('Backend build') {
                    steps {
                        script {
                            env.BACK_IMAGE = docker.build("${env.BACK_IMAGE_NAME}", "-f ./server --no-cache")
                        }
                    }
                }
                stage('Frontend build') {
                    steps {
                        script {
                            env.FRONT_IMAGE = docker.build("${env.FRONT_IMAGE_NAME}", "-f ./public --no-cache")
                            sh "echo ${env.FRONT_IMAGE}=${env.FRONT_IMAGE_NAME}"
                        }
                    }
                }
            }
        }
        stage('Raise dockers environment'){
            steps{
                sh "echo ${env.BACK_IMAGE_NAME}=${env.BACK_IMAGE}\n\n${env.FRONT_IMAGE_NAME}=${env.FRONT_IMAGE}"
            }
        }
        // stage('Raise dockers environment') {
        //     steps{
        //         sh "echo BACK_IMAGE_NAME=${env.backendImage.imageName()}"
        //         // sh "echo 'BACK_IMAGE_NAME=${env.backendImage.imageName()} FRONT_IMAGE_NAME=${env.frontendImage.imageName()}'"
        //         // sh "docker-compose build --build-arg BACK_IMAGE_NAME=${env.backendImage.imageName()} FRONT_IMAGE_NAME=${env.frontendImage.imageName()}"
        //         // sh 'docker-compose up -d'
        //     }
        // }
        // stage('Post environment stage checks'){
        //     steps {
        //         script {
        //             def response = httpRequest "http://localhost:3000"
        //             if (response.status != 200) {
        //                 error "Failed to get a successful response"
        //             }
        //         }
        //     }
        // }
    }
    // post {
    //     failure {
    //         sh "docker-compose down"
    //         sh "docker rmi -f ${env.backendImage.imageName()}"
    //         sh "docker rmi -f ${env.frontendImage.imageName()}"
    //     }
    //     cleanup {
    //         cleanWs()
    //     }
    // }
}
