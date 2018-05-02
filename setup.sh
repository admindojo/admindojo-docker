#!/usr/bin/env bash

#Install required software

install_requirements() {
    echo ""
    echo "------------------   INSTALL REQUIREMENTS START   ------------------"
    echo ""

    sudo apt-get update
    sudo apt-get install -y crudini

    echo ""
    echo "------------------   INSTALL REQUIREMENTS DONE   ------------------"
    echo ""
}
install_requirements