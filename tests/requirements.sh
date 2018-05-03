#!/usr/bin/env bash
set -e # Exit with nonzero exit code if anything fails

install_requirements() {
    echo ""
    echo "------------------   INSTALL REQUIREMENTS START   ------------------"
    echo ""

    sudo apt-get -qq update
    sudo apt-get install -y crudini
    sudo apt-get install -y curl
    sudo apt-get install -y wget

    echo ""
    echo "------------------   INSTALL REQUIREMENTS DONE   ------------------"
    echo ""

    return $?
}




install_requirements