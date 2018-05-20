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



    apt-get install -y "curl"
    apt-get install -y "wget"
    apt-get install -y "crudini"

    echo ""
    echo "------------------   INSTALL REQUIREMENTS DONE   ------------------"
    echo ""

    return $?
}



install_requirements

exit $?