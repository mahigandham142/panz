pipeline {
    agent any

    triggers {
        pollSCM '* * * * *'
    }

    stages {
        stage('sonar scanner') {
            steps {
                script {
                    def sonarLogin = "4ae5b1280f09145d7da83688c18a4b4b4f6fbd38"
                    def sonarHostUrl = "http://af92004913f324520ba8606446672f5d-467569492.us-east-2.elb.amazonaws.com:9000"

                    sh """
                        export PATH="\$PATH:/var/lib/jenkins/.dotnet/tools"
                        dotnet sonarscanner begin /k:'sonar' /d:sonar.host.url='${sonarHostUrl}' /d:sonar.login='${sonarLogin}'
                        dotnet build
                        dotnet sonarscanner end /d:sonar.login='${sonarLogin}'
                    """
                }
            }
        }

        stage('Sonar Quality Gate Check') {
            steps {
                sh '''
                    sleep 20
                    chmod +x sonar_scan.sh
                    bash sonar_scan.sh
                '''
            }
        }

        stage('Docker build and push') {
            steps {
                script {
                    def awsRegion = 'us-east-2'
                    def ecrRegistry = "971076122335.dkr.ecr.${awsRegion}.amazonaws.com"
                    def imageName = "${ecrRegistry}/demo:SAMPLE-PROJECT-${BUILD_NUMBER}"

                    withCredentials([usernamePassword(credentialsId: 'aws-ecr-credentials', passwordVariable: 'DOCKER_LOGIN_PASSWORD', usernameVariable: 'DOCKER_LOGIN_USERNAME')]) {
                        sh """
                            docker login -u '\${DOCKER_LOGIN_USERNAME}' -p '\${DOCKER_LOGIN_PASSWORD}' ${ecrRegistry}
                            docker build -t ${imageName} .
                            docker push ${imageName}
                        """
                    }
                }
            }
        }

        stage('Image Scan') {
            steps {
                sh '''
                    sleep 20
                    chmod +x image_scan.sh
                    bash image_scan.sh
                '''
            }
        }

        stage('eks deploy') {
            steps {
                sh '''
                    aws eks update-kubeconfig --name demo --region us-east-2
                    kubectl apply -f deploy.yml
                    kubectl apply -f svc.yml
                '''
            }
        }
    }
//       stage('ecs deploy') {
//       steps {
//           sh '''
//           chmod +x changebuildnumber.sh
//             ./changebuildnumber.sh $BUILD_NUMBER
//	     sh -x ecs-auto.sh
//             '''
//        }    
//       }
// }
// post {
//     failure {
//         mail to: 'unsolveddevops@gmail.com',
//              subject: "Failed Pipeline: ${BUILD_NUMBER}",
//              body: "Something is wrong with ${env.BUILD_URL}"
//     }
//      success {
//         mail to: 'unsolveddevops@gmail.com',
//              subject: "successful Pipeline:  ${env.BUILD_NUMBER}",
//              body: "Your pipeline is success ${env.BUILD_URL}"
//     }
// }

}
