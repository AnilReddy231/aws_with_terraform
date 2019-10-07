#!groovy

pipeline {
    agent any
    // executes on an executor with the label 'some-label' or 'docker'
    // label "some-label || docker"
    environment {
        PROJECT_NAME = "AWS With Terraform"
        BUILD_NUM_ENV = currentBuild.getNumber()
        // this assumes that "cred1" has been created on Jenkins Credentials
        USER1 = credentials("Jenkins")
    }
    triggers {
    issueCommentTrigger('.*')
    }
    options {
        buildDiscarder(
            // Only keep the 3 most recent builds
            logRotator(numToKeepStr: '3')
        )
        timestamps()
        retry(3)
        timeout time:10, unit: 'MINUTES'
        disableConcurrentBuilds()
    }
    // use the 'tools' section to use specific tool versions already defined in Jenkins config 
    // tools {
    //     maven "apache-maven-3.1.0"
    //     jdk "default"
    // }
    parameters {
        string(name: "PACIFIC", description: "Sample Variable", defaultValue: "ATLANTIC")
        booleanParam(name:"DEPLOY_QA", description: "Deploy to QA Environment", defaultValue: true)
    }

    stages {
        stage("Initialize") {
            steps {
                // Script blocks can run any Groovy script or
                script {
                    notifyBuild('STARTED')
                    echo "${BUILD_NUMBER} - ${env.BUILD_ID} on ${env.JENKINS_URL}"
                    echo "Specifier :: ${params.PACIFIC}"
                }
            }
            
        }
        stage("Analysis"){
            environment {
            // BAR will only be available in this stage
                BAR = "STAGE"
            }
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
            // variable assignment (other than environment variables) can only be done in a script block
            // complex global variables (with properties or methods) can only be run in a script block
            // env variables can also be set within a script block
            script{
                String res = env.MAKE_RESULT
                if (res != null) {
                    echo "Setting build result ${res}"
                    currentBuild.result = res
                } else {
                    echo "All is well"
                    }
                }
            }
        }
        stage("Deploy - PROD"){
            when {
                // skip this stage unless on Master branch
                branch "master"
            }
            steps{
                echo "Deploying to PROD"
            }
        }
        stage("Recursive"){
            when {
                expression{
                    currentBuild.getNumber() % 2 == 1  
                }
            }
            steps{
                // create a directory called "tmp" and cd into that directory
                dir("tmp") {
                build job: currentBuild.getProjectName(), parameters: [
                booleanParam(name:"DEPLOY_QA", value: true)
                ]
                }
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
             echo 'One way or another, Pipeline had finished executing'
             archive "target/**/*"
         }
         changed {
            echo "CHANGED from last run"
        }
         success {
          echo "The pipeline ${currentBuild.fullDisplayName} completed successfully."
         }
         aborted {
            echo "Build had been Aborted"
        }
         failure {
          echo "Failed Pipeline: ${currentBuild.fullDisplayName} Something is wrong with ${env.BUILD_URL}"
         }
         unstable {
          echo 'Build is Unstable'
         }
    }
}

def notifyBuild(String buildStatus = 'STARTED'){
    buildStatus = buildStatus ?: 'SUCCESS'
    echo "Started: Name: ${env.JOB_NAME}"
}