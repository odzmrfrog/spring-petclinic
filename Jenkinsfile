node {
    def server
    def buildInfo
    def rtMaven
    

    stage ('Clone') {
        echo 'Clone'
        git url: 'https://github.com/odzmrfrog/spring-petclinic.git', branch: 'main'
        echo 'Done Cloning'
    }
 
    stage ('Artifactory configuration') {
        echo 'Config'
        // Obtain an Artifactory server instance, defined in Jenkins --> Manage Jenkins --> Configure System:
        server = Artifactory.server 'ohadrt'

        rtMaven = Artifactory.newMavenBuild()
        rtMaven.tool = 'maven' // Tool name from Jenkins configuration
        rtMaven.deployer releaseRepo: 'ohadz-ob-maven-libs-release-local', snapshotRepo: 'ohadz-ob-maven-libs-snapshot-local', server: server
        rtMaven.resolver releaseRepo: 'ohadz-ob-maven-libs-release', snapshotRepo: 'ohadz-ob-maven-libs-snapshot', server: server
        rtMaven.deployer.deployArtifacts = false // Disable artifacts deployment during Maven run

        buildInfo = Artifactory.newBuildInfo()
    }
 
    stage ('Test') {
        echo 'test'
        rtMaven.run pom: 'pom.xml' , goals: 'clean test'
    }
        
    stage ('Install') {
        echo 'install'
        rtMaven.run pom: 'pom.xml' , goals: 'install', buildInfo: buildInfo
    }
 
    stage ('Deploy') {
        echo 'Deploy'
        rtMaven.deployer.deployArtifacts buildInfo
    }
        
    stage ('Publish build info') {
        echo 'Publish build info'
        server.publishBuildInfo buildInfo
    }
}
