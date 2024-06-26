node {
    def server
    def buildInfo
    def rtMaven
    def rtDocker

    stage ('Clone') {
        echo 'Clone'
        git url: 'https://github.com/odzmrfrog/spring-petclinic.git', branch: 'main'
        echo 'Done Cloning'
    }
 
    stage ('Artifactory configuration') {
        echo 'Config'
        server = Artifactory.server 'ohadzrt'

        rtMaven = Artifactory.newMavenBuild()
        rtMaven.tool = 'maven' // Tool name from Jenkins configuration
        rtMaven.deployer releaseRepo: 'ohadz-ob-maven-libs-release-local', snapshotRepo: 'ohadz-ob-maven-libs-snapshot-local', server: server
        rtMaven.resolver releaseRepo: 'ohadz-ob-maven-libs-release', snapshotRepo: 'ohadz-ob-maven-libs-snapshot', server: server
        rtMaven.deployer.deployArtifacts = true 
        rtDocker = Artifactory.docker server: server
        buildInfo = Artifactory.newBuildInfo()
    }
    
    stage ('Purge Cache') {
        echo 'purge cache'
        rtMaven.run pom: 'pom.xml' , goals: 'dependency:purge-local-repository'
    }

    stage ('Test') {
        echo 'test'
        sh 'java -version'
        rtMaven.run pom: 'pom.xml' , goals: 'clean test -T 4'
    }
        
    stage ('Install') {
        echo 'install'
        rtMaven.run pom: 'pom.xml' , goals: 'install -DskipTests', buildInfo: buildInfo
    }
 
    stage ('Deploy') {
        echo 'Deploy'
        rtMaven.deployer.deployArtifacts buildInfo
    }
    
    stage ('Add properties') {
        rtDocker.addProperty("project-name", "ohad-pet-clinic").addProperty("status", "stable")
    }

    stage ('Build docker image') {
        echo 'Building Docker image'
        docker.build('ohadz.jfrog.io/docker'+ '/ohad-pet-clinic:latest', '.')
    }

    stage ('Push image to Artifactory') {
        echo 'Push to RT'
        rtDocker.push 'ohadz.jfrog.io/docker' + '/ohad-pet-clinic:latest', 'docker-local', buildInfo
    }

    stage ('Publish build info') {
        echo 'Publish build info'
        server.publishBuildInfo buildInfo
    }
}
