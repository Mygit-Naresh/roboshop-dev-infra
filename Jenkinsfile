pipeline {
   agent {
     node {
        label 'jenkins-agent-2'
        }
}
options {
                timeout(time: 1, unit: 'HOURS') 
                ansiColor('xterm')
                disableConcurrentBuilds()
            }
parameters { choice(name: 'TERRAFORMACTION', choices: ['deploy', 'destroy'], description: 'terraform infra creation') }
    stages {
stage('vpc-provision'){

        steps {
          script {
           sh """
           cd 01-vpc
           terraform init -reconfigure
           terraform apply -auto-approve
           """
          }
      }
}
 stage('SG-provision'){

        steps {
          script {
           sh """
           cd 02-sg
           terraform init -reconfigure
           terraform apply -auto-approve
           """
          }
      }
}
 stage('vpn-provision'){

        steps {
          script {
           sh """
           cd 03-vpn
           terraform init -reconfigure
           terraform apply -auto-approve
           """
          }
      }
}
stage('parallel running databses-appLB-ACM') {
parallel {
    
  stage('databases-provision'){

        steps {
          script {
           sh """
           cd 04-databases
           terraform init -reconfigure
           terraform apply -auto-approve
           """
          }
      }
}
  stage('app-lb-provision'){

        steps {
          script {
           sh """
           cd 05-app-lb-internal
           terraform init -reconfigure
           terraform apply -auto-approve
           """
          }
      }
}
  stage('acm-provision'){

        steps {
          script {
           sh """
           cd 06-acm
           terraform init -reconfigure
           terraform apply -auto-approve
           """
          }
      }
}
}
}
stage('web_alb_external-provision'){

        steps {
          script {
           sh """
           cd 07-web_alb-external
           terraform init -reconfigure
           terraform apply -auto-approve
           """
          }
      }
}
stage('cdn-provision'){

        steps {
          script {
           sh """
           cd 08-cdn
           terraform init -reconfigure
           terraform apply -auto-approve
           """
          }
      }
}
    }


}