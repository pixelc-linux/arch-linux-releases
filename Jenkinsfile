pipeline {
 agent any
 options {
    ansiColor('xterm')
 }

  environment {
      GITHUB_TOKEN = credentials('github-token-pixelc-linux')
      GITHUB_ORGANIZATION = "pixelc-linux"
      GITHUB_REPO = "arch-linux-releases"
      DISTRO = "Arch"
      DISTRO_D = "arch"
  }

 stages {
    stage('Checkout') {
      steps {
        sh 'git clone https://github.com/pixelc-linux/rootfs-builder rootfs-builder'
      }
    }
    
    stage('Build') {
      steps {
        dir('rootfs-builder') {
          withDockerContainer(image: 'dvitali/pixelc-build-container:7', args: '--privileged') {
            sh 'bash -c "mkdir -p out/${DISTRO_D}/rootfs"'
            sh 'UID=0 GID=0 DISTRO=${DISTRO_D} SYSROOT=$(pwd)/out/$DISTRO/rootfs TOP=$(pwd) ./build.sh'
          }
        }
      }
    }

    stage('Publish') {
      steps {
        script {
           env.VERSION_NAME = sh(returnStdout: true, script: 'cat VERSION_NAME').trim()
        }
        archiveArtifacts 'rootfs-builder/out/*_rootfs.tar.gz'
        withDockerContainer(image: 'dvitali/pixelc-build-container:7'){
          sh ". /etc/environment"
          sh "echo $PATH"
          echo "Deleting release from github before creating new one"
          sh "/opt/go/bin/github-release delete --user ${GITHUB_ORGANIZATION} --repo ${GITHUB_REPO} --tag ${env.VERSION_NAME}"

          echo "Creating a new release in github"
          sh "/opt/go/bin/github-release release --user ${GITHUB_ORGANIZATION} --repo ${GITHUB_REPO} --tag ${env.VERSION_NAME} --name ${VERSION_NAME}"

          echo "Uploading the artifacts into github"
          sh "/opt/go/bin/github-release upload --user ${GITHUB_ORGANIZATION} --repo ${GITHUB_REPO} --tag ${env.VERSION_NAME} --name ${DISTRO}-${VERSION_NAME}_rootfs.tar.gz --file rootfs-builder/out/${DISTRO_D}_rootfs.tar.gz"
        }
      }
    }
 }
 post {
    always { 
        cleanWs()
    }
 }
}
