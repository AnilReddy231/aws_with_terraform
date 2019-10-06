#!groovy

pipeline {
    agent any
    environment {
        PROJECT_NAME = "AWS With Terraform"
    }
    options {
        buildDiscarder(
            // Only keep the 3 most recent builds
            logRotator(numToKeepStr: '3')
        )
        skipDefaultCheckout()
        timestamps()
        retry(3)
        timeout time:10, unit: 'MINUTES'
    }
    parameters {
        string(name: "PACIFIC", description: "Sample Variable", defaultValue: "ATLANTIC")
        booleanParam(name:"DEPLOY_QA", description: "Deploy to QA Environment", defaultValue: true)
    }

    stages {
        stage("Initialize") {
            steps {
                notifyBuild('STARTED')
                echo "${BUILD_NUMBER} - ${env.BUILD_ID} on ${env.JENKINS_URL}"
                echo "Specifier :: ${params.PACIFIC}"
            }
            
        }
        stage("Checkout"){
            steps{
                echo "Checkout Repo"
                git url: "${GIT_URL}"
            }
        }
        stage("Analysis"){
            parallel {
                stage('Sonatype'){
                    steps {
                        echo "Sonatype Analysis"
                    }
                }
                stage('SonarQuebe'){
                    steps{
                        echo "SonarQuebe Analysis"
                    }
                }
            }
        }
        stage("Deploy - QA"){
            when{
                expression{
                    params.DEPLOY_QA == true
                }
            }
            steps{
                echo "Deploying to QA"
            }
        }
        stage("Deploy - PROD"){
            when{
                expression{
                    params.DEPLOY_PROD == true
                }
            }
            steps{
                echo "Deploying to PROD"
            }
        }
        stage("Deploy"){
            steps{

            }
        }
    }
    post{
        /*
         * These steps will run at the end of the pipeline based on the condition.
         * Post conditions run in order regardless of their place in pipeline
         * 1. always - always run
         * 2. changed - run if something changed from last run
         * 3. aborted, success, unstable or failure - depending on status
         */
         always{
             echo "I AM ALWAYS first"
         }
    }
}

def notifyBuild(string buildStatus = 'STARTED'){
    buildStatus = buildStatus ?: 'SUCCESS'
    echo "Started: Name: ${env.JOB_NAME}"
}