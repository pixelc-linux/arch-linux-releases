pipeline {
 agent any
 options {
    ansiColor('xterm')
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
          withDockerContainer(image: 'dvitali/pixelc-build-container:5', args: '--privileged') {
            sh 'bash -c "mkdir -p out/{arch,ubuntu}/rootfs"'
            sh 'UID=0 GID=0 DISTRO=arch SYSROOT=$(pwd)/out/$DISTRO/rootfs TOP=$(pwd) ./build.sh'
            sh 'UID=0 GID=0 DISTRO=ubuntu SYSROOT=$(pwd)/out/$DISTRO/rootfs TOP=$(pwd) ./build.sh'
          }
        }
      }
    }

    stage('Publish') {
      archiveArtifacts 'out/*_rootfs.tar.gz'
    }
 }
 post {
    always { 
        cleanWs()
    }
 }
}
