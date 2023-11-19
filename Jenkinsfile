pipeline {
  agent any
  triggers {
    pollSCM '* * * * *'
  }
  stages {
   stage('sonar scanner') {
      steps {
        sh '''
	dotnet tool install --global dotnet-sonarscanner
	export PATH="$PATH:/root/.dotnet/tools"
	dotnet sonarscanner begin /k:"sonar" /d:sonar.host.url="http://af92004913f324520ba8606446672f5d-467569492.us-east-2.elb.amazonaws.com:9000"  /d:sonar.login="4ae5b1280f09145d7da83688c18a4b4b4f6fbd38"
        dotnet build
        dotnet sonarscanner end /d:sonar.login="4ae5b1280f09145d7da83688c18a4b4b4f6fbd38"
          
	  '''
     }   
   } 	  
   stage('Docker build and push') {
      steps {
        sh '''
         whoami
         DOCKER_LOGIN_PASSWORD=$(aws ecr get-login-password  --region us-east-2)
         docker login -u AWS -p $DOCKER_LOGIN_PASSWORD https://971076122335.dkr.ecr.us-east-2.amazonaws.com
         docker build -t 971076122335.dkr.ecr.us-east-2.amazonaws.com/demo:SAMPLE-PROJECT-${BUILD_NUMBER} .
         docker push 971076122335.dkr.ecr.us-east-2.amazonaws.com/demo:SAMPLE-PROJECT-${BUILD_NUMBER}
          
	  '''
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
    // stage('eks deploy') {
    //   steps {
	      
    //     sh '''
    //        aws eks update-kubeconfig --name demo --regio ap-south-1
    //        sed "s/buildNumber/${BUILD_NUMBER}/g" deploy.yml > deploy-new.yml
	//    kubectl apply -f deploy-new.yml
	//    kubectl apply -f svc.yml
	// '''
    //   }   
    // }
       stage('ecs deploy') {
         steps {
           sh '''
             chmod +x changebuildnumber.sh
             ./changebuildnumber.sh $BUILD_NUMBER
	     sh -x ecs-auto.sh
             '''
        }    
       }
}
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
