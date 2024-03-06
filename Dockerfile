FROM openjdk:8
EXPOSE 8080
ADD home/ubuntu/devops-integration.jar devops-integration.jar
ENTRYPOINT ["java","-jar","/devops-integration.jar"]
