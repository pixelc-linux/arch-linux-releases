node {
  stage('Checkout'){
    checkout scm
    sh 'git clone https://github.com/pixelc-linux/rootfs-builder' rootfs-builder  
  }
  
  stage('Build'){
    sh 'cd rootfs-builder'
    sh 'mkdir -p out/{arch,ubuntu}/rootfs'
    sh 'UID=0 GID=0 DISTRO=arch SYSROOT=$(pwd)/out/arch/rootfs TOP=$(pwd) ./build.sh'
  }
}
