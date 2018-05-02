#!/usr/bin/env bash

install_requirements() {
    echo "Install testing requirements"
    echo ""
    sudo apt-get -qq update
    sudo apt-get install -y crudini

    echo "Requirements installed"

    echo ""
}
install_requirements