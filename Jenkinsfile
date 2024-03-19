pipeline {
    agent any
    environment {
        KUBECONFIG = '/var/lib/jenkins/workspace/k8s/' // Specify the path to your Kubernetes configuration file
    }
    stages{
        stage('Project Clone from GIT'){
            steps{
                git url:'https://github.com/manjugdr/cicd-with-K8S/', branch: "master"
                }
        }
        stage('SonarQube Analysis') {
            steps{
                withSonarQubeEnv(credentialsId: 'sonarqube', installationName: 'sonarqube') {
                    sh "mvn clean verify sonar:sonar -Dsonar.projectKey=tes-project-k8s"
                }
            }
        }
         stage("Quality gate"){
            steps{
                waitForQualityGate abortPipeline: true
            }
         }
     stage('Build Maven'){
            steps{
                    sh 'mvn clean install'
            }
        }
    stage('Publish to Nexus') {
            steps{
              nexusArtifactUploader artifacts: [[artifactId: 'devops-integration', classifier: '', file: 'target/devops-integration.jar', type: 'jar']], credentialsId: 'nexus3.1', groupId: 'com.truelearning', nexusUrl: '172.31.22.62:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'entpoint/', version: '0.0.1-SNAPSHOT' 
            }
        }
          stage('Build docker image'){
            steps{
                    script{
                       sshagent(['sshkeypair']) {
                       sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.29.59"
                       sh 'scp -i chaithra.pem -r /var/lib/jenkins/workspace/tes-project-k8s/ ubuntu@172.31.29.59:/home/ubuntu/tes-project-k8s'
                       sh 'docker build -t manjugdr/endtoendproject:v1 .'
                }
            }
        }
         }
       
        stage('Docker Image Push to Docker Hub') {
            steps {
                sshagent(['sshkeypair']) {
                sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.29.59"
                withCredentials([usernamePassword(credentialsId: 'dockerhub-pwd', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh "echo $PASS | docker login -u $USER --password-stdin"
                    sh 'docker push manjugdr/endtoendproject:v1'
                }
            }
        }
          }
       stage('Deploying App to Kubernetes') {
      steps {
        script {
            sshagent(['sshkeypair']) {
                       sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.24.37"
                sh 'scp -i chaithra.pem  /var/lib/jenkins/workspace/tes-project-k8s/deploymentservice.yaml  ubuntu@172.31.24.37:/home/ubuntu/'
          kubernetesDeploy(configs: "deploymentservice.yaml", kubeconfigId: "kubernetes")               
            }
        }
      }
       }
    }
}
