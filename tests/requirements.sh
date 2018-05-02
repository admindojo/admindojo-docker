#!/usr/bin/env bash

install_requirements() {
    echo "Install testing requirements"
    echo ""
    apt-get update
    apt-get install make
    apt-get install crudini

    echo "Requirements installed"

    echo ""
    return 0

}
install_requirements