pipeline {
  agent any
  triggers {
    pollSCM '* * * * *'
  }
  environment {
    DOCKER_REGISTRY = 607780497941.dkr.ecr.ap-south-1.amazonaws.com
    AWS_DEFAULT_REGION = ap-south-1
    REPO_DEV_NAME = alesund/airavat-remote
    IMAGE_TAG = $BUILD_NUMBER
    AWS_SNS_TOPIC_ARN = arn:aws:sns:ap-south-1:607780497941:topspin-automation
    ARGOCD_API_SERVER = "https://argocd.topspingame.com"
    APPLICATION_NAME = "alesund-topspin-dev-sf"
  }
  stages {
   stage('ConfigCheck') {
      steps {
        sh '''
         trivy config .
  
	  '''
     }   
   }
   stage('docker') {
      steps {
        sh '''
	      docker build -t $DOCKER_REGISTRY/$REPO_DEV_NAME:$IMAGE_TAG .
          
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
     stage('argocd deploy') {
      steps {
        sh '''
        aws eks update-kubeconfig --name demo --region us-east-2
  	    sed "s/changebuildnumber/${BUILD_NUMBER}/g" kubernetes/deploy.yml
            git clone https://github.com/mahigandham142/panz.git
	    git add kubernetes/deploy.yml
            git commit "eks deployment"
	    git push -u origin master
  
  	  '''
     }   
   }
} 
	  
  //  stage('eks deploy') {
  //    steps {
  //      sh '''
  //      aws eks update-kubeconfig --name demo --region us-east-2
  //	    sed "s/changebuildnumber/${BUILD_NUMBER}/g" deploy.yml > deploy-new.yml
  //	    kubectl apply -f deploy-new.yml
  //	    kubectl apply -f svc.yml
  //
  //	  '''
  //   }   
  // }
// }
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
