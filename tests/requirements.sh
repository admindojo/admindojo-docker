#!/usr/bin/env bash

install_requirements() {
    echo ""
    echo "Install testing requirements"

    sudo apt-get -qq update
    sudo apt-get install -y crudini

    echo "Requirements installed"

    echo ""
}
install_requirements