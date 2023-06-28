pipeline {
    agent any
    environment {
        MAJOR_BUILD = 1
        MINOR_BUILD = 0
        BACK_IMAGE_NAME = "${env.GIT_BRANCH.toLowerCase()}-backend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID}"
        FRONT_IMAGE_NAME = "${env.GIT_BRANCH.toLowerCase()}-frontend:${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID}"
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
                sh """
                    if [ "$(docker images | grep ${env.MAJOR_BUILD}.${env.MINOR_BUILD}.${env.BUILD_ID} | wc -l )" == "2" ]; then
                        echo "Images are ready to impliment."
                    else
                        error "Failed to build images."
                    fi
                """
            }
        }
        stage('Raise dockers environment'){
            steps{
                sh "docker-compose build --build-arg BACK_IMAGE_NAME=${BACK_IMAGE_NAME} FRONT_IMAGE_NAME=${FRONT_IMAGE_NAME}"
                sh 'docker-compose up -d'
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
