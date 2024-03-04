pipeline {
    agent any
    environment {
        KUBECONFIG = '/etc/kubernetes/kubeconfig' // Specify the path to your Kubernetes configuration file
    }
    stages{
        stage('Build Maven'){
            steps{
                git url:'https://github.com/manjugdr/cicd-with-K8S/', branch: "master"
               sh 'mvn clean install'
            }
        }
        stage('Build docker image'){
            steps{
                script{
                    sh 'docker build -t manjugdr/endtoendproject:v1 .'
                }
            }
        }
          stage('Docker login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-pwd', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh "echo $PASS | docker login -u $USER --password-stdin"
                    sh 'docker push manjugdr/endtoendproject:v1'
                }
            }
        }
        
        
        stage('Deploy to k8s'){
                       steps{
                script{
                     sh "kubectl --kubeconfig=$KUBECONFIG apply -f /var/lib/jenkins/workspace/k8s/deploymentservice.yaml"                   
                }
            }
        }
    }
}
