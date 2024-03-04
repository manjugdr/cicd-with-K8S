pipeline {
    agent any
    stages{
        stage('Build Maven'){
            steps{
                git url:'https://github.com/manjugdr/cicd-with-k8s/', branch: "master"
               sh 'mvn clean install'
            }
        }
        stage('Build docker image'){
            steps{
                script{
                       sh 'cd /var/lib/jenkins/workspace/k8s'
                       def dockerImage = docker.build('manjugdr/endtoendproject:v1', '-f /var/lib/jenkins/workspace/k8s/Dockerfile .')
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
                    sh 'cd /var/lib/jenkins/workspace/k8s/'
                    sh 'kubectl apply -f deploymentservice.yaml'
                   
                }
            }
        }
    }
}
