#!/usr/bin/env bash

install_requirements() {
    echo ""
    echo "------------------   INSTALL REQUIREMENTS START   ------------------"
    echo ""

    sudo apt-get -qq update
    sudo apt-get install -y crudini

    echo ""
    echo "------------------   INSTALL REQUIREMENTS DONE   ------------------"
    echo ""
}
install_requirements