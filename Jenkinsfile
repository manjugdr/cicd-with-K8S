pipeline {
    agent any
    environment {
        KUBECONFIG = '/var/lib/jenkins/workspace/k8s/' // Specify the path to your Kubernetes configuration file
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
                        sshagent(['sshkeypair']) {
                       sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.29.59"
                       sh 'docker build -t manjugdr/endtoendproject:v1 .'
                }
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
        stage('K8S login'){
            steps {
            sshagent(['sshkeypair']) {
                       sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.24.37"
            }
        }
        }    
           stage('Deploying App to Kubernetes') {
      steps {
        script {
          kubernetesDeploy(configs: "deploymentservice.yaml", kubeconfigId: "kubernetes")               
                }
            }
        }
    }
}
