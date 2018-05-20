#!/usr/bin/env bash

. ../../helper.sh

test_add() {
    actual=$(input 1)
    expected=13
    assertEquals "$expected" "$actual"
}

. shunit2