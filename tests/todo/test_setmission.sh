#!/usr/bin/env bash
set -e # Exit with nonzero exit code if anything fails

rm -rf "./lessons/*"
mv "./tests/test_testmission-allwaysok_test" "./lessons/"

./helper.sh input 1

if [ "$(crudini --get "./player/player.ini" "player" "mission_current")" ==  "TEST MISSION NAME" ]; then
            echo "ok"
            exit 0
        else
            echo "fail"
            exit 1
fi
