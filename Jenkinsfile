pipeline {
    agent any
    
    tools{
        maven 'M3'
        jdk 'jdk17'
    }

    environment {
        SONAR_SCANNER= tool 'sonar-scanner'
        KUBECONFIG = credentials('kube-config')
        NO_PROXY = "192.0.0.100,127.0.0.1,localhost"

        DOCKER_REPO='rayhubli'
        IMAGE_NAME='maven_app'
        TAG="${env.BUILD_NUMBER}"
    }

    stages {
        stage('clone') {
            steps {
              git 'https://github.com/nagarajAI/maven-web-app.git'
            }
        }
        stage('build'){
            steps{
                 sh 'mvn clean package'
            }
        }
        stage('sonarqube'){
            steps{
                withSonarQubeEnv('sonarqube') {
                    sh ''' 
                        $SONAR_SCANNER/bin/sonar-scanner -Dsonar.projectName=maven-app \
                        -Dsonar.projectKey=maven-app -Dsonar.java.binaries=target
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('docker image'){
            steps {
                script{
                    echo "Building docker image..."
                    def IMAGE_OBJ= docker.build("$DOCKER_REPO/$IMAGE_NAME:$TAG")
                    echo "Pushing to dockerHub repo..."
                    withDockerRegistry(credentialsId: 'docker_cred') {
                        IMAGE_OBJ.push()
                        IMAGE_OBJ.push('latest') //push image with tag="latest"
                    }
                }
            }
        }
       
        // stage('k8s deploy'){
        //     steps{
        //        sh 'kubectl apply -f k8s-deploy.yml'
        //     }
        // }
    }
}
