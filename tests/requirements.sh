#!/usr/bin/env bash

install_requirements() {
    echo "Install testing requirements"
    echo ""
    sudo apt-get -qq update
    sudo apt-get install -y crudini

    echo "Requirements installed"

    echo ""
    return 0

}
install_requirements