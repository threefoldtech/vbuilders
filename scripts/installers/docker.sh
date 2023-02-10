
apt-get remove docker docker-engine docker.io containerd runc -y 

set -ex

export OURHOME="$HOME"
export DIR_CODE="$OURHOME/code"
export OURHOME="$HOME/play"
mkdir -p $OURHOME

if [ -z "$TERM" ]; then
    export TERM=xterm
fi

function github_keyscan {
    mkdir -p ~/.ssh
    if ! grep github.com ~/.ssh/known_hosts > /dev/null
    then
        ssh-keyscan github.com >> ~/.ssh/known_hosts
    fi
}

export DEBIAN_FRONTEND=noninteractive

function os_package_install {
    apt -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" install $1 -q -y --allow-downgrades --allow-remove-essential 
}

function os_update {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then 
        export DEBIAN_FRONTEND=noninteractive
        apt update -y
        apt-mark hold grub-efi-amd64-signed
        apt-get -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" upgrade -q -y --allow-downgrades --allow-remove-essential --allow-change-held-packages
        apt-mark hold grub-efi-amd64-signed
        os_package_install "mc curl tmux net-tools git htop ca-certificates gnupg lsb-release"
        apt upgrade -y
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo 
    fi
}

function gridbuilder_get {
    mkdir -p $DIR_CODE/github/threefoldtech
    if [[ -d "$DIR_CODE/github/threefoldtech/builders" ]]
    then
        pushd $DIR_CODE/github/threefoldtech/builders 2>&1 >> /dev/null
        git pull
        popd 2>&1 >> /dev/null
    else
        pushd $DIR_CODE/github/threefoldtech 2>&1 >> /dev/null
        git clone --depth 1 --no-single-branch git@github.com:threefoldtech/builders.git
        popd 2>&1 >> /dev/null
    fi

}


function docker_install {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then 
        export DEBIAN_FRONTEND=noninteractive
        mkdir -p /etc/apt/keyrings

        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        chmod a+r /etc/apt/keyrings/docker.gpg
        apt-get update

        apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

        docker run hello-world
    fi
}

github_keyscan
docker_install
gridbuilder_get

echo "*** INSTALL DOCKER OK ***"