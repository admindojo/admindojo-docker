#!/usr/bin/env bash
set -e # Exit with nonzero exit code if anything fails

#Install required software

install(){

    echo  "Install: $1"
    if [ -x  "$(command -v "$1")" ]; then
        printf " (skipped, already installed)\n"
    else

        sudo apt-get install -y "$1" > /dev/null
        printf " (installed)\n"
        # Check if error
        if [[ $? != 0 ]]; then
          printf "\n${RED}Failed to install: $1 (pls let us know!)${NORMAL}\n"
        fi
    fi
}

install_requirements() {
    echo ""
    echo "------------------   INSTALL REQUIREMENTS START   ------------------"
    echo ""

    sudo apt-get -qq update

    install "curl"
    install "wget"
    install "crudini"

    echo ""
    echo "------------------   INSTALL REQUIREMENTS DONE   ------------------"
    echo ""

    return $?
}



install_requirements

exit $?