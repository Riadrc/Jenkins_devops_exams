pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'riadriri'
        DOCKERHUB_PASSWORD = credentials('DOCKER_HUB_PASS') // Secret Jenkins
    }

    parameters {
        string(name: 'TAG', defaultValue: 'dev', description: 'Tag de l’image Docker à utiliser')
    }

    stages {

        stage('Build Images') {
            steps {
                script {
                    def services = ['movie-service', 'cast-service']
                    for (service in services) {
                        sh """
                            echo "🚧 Building image for ${service}"
                            docker build -t $DOCKERHUB_USER/${service}:${params.TAG} ./charts/${service}
                        """
                    }
                }
            }
        }

        stage('Push Images to DockerHub') {
            steps {
                script {
                    def services = ['movie-service', 'cast-service']
                    sh "echo '$DOCKERHUB_PASSWORD' | docker login -u '$DOCKERHUB_USER' --password-stdin"
                    for (service in services) {
                        sh """
                            echo "🚀 Pushing image for ${service}"
                            docker push $DOCKERHUB_USER/${service}:${params.TAG}
                        """
                    }
                }
            }
        }

        stage('Deploy to DEV') {
            when { branch 'dev' }
            steps {
                script {
                    def services = ['movie-service', 'cast-service']
                    for (service in services) {
                        sh """
                            echo "🔧 Deploying ${service} to DEV"
                            helm upgrade --install ${service} charts/${service} \
                                --namespace dev \
                                --set image.repository=$DOCKERHUB_USER/${service} \
                                --set image.tag=${params.TAG}
                        """
                    }
                }
            }
        }

        stage('Deploy to QA') {
            when { branch 'qa' }
            steps {
                script {
                    def services = ['movie-service', 'cast-service']
                    for (service in services) {
                        sh """
                            echo "🧪 Deploying ${service} to QA"
                            helm upgrade --install ${service} charts/${service} \
                                --namespace qa \
                                --set image.repository=$DOCKERHUB_USER/${service} \
                                --set image.tag=${params.TAG}
                        """
                    }
                }
            }
        }

        stage('Deploy to STAGING') {
            when { branch 'staging' }
            steps {
                script {
                    def services = ['movie-service', 'cast-service']
                    for (service in services) {
                        sh """
                            echo "🚦 Deploying ${service} to STAGING"
                            helm upgrade --install ${service} charts/${service} \
                                --namespace staging \
                                --set image.repository=$DOCKERHUB_USER/${service} \
                                --set image.tag=${params.TAG}
                        """
                    }
                }
            }
        }

        stage('Deploy to PROD') {
            when { branch 'master' }
            steps {
                input message: "⚠️ Valider le déploiement en PROD ?", ok: 'Déployer'
                script {
                    def services = ['movie-service', 'cast-service']
                    for (service in services) {
                        sh """
                            echo "🚨 Deploying ${service} to PROD"
                            helm upgrade --install ${service} charts/${service} \
                                --namespace prod \
                                --set image.repository=$DOCKERHUB_USER/${service} \
                                --set image.tag=${params.TAG}
                        """
                    }
                }
            }
        }
    }
}

