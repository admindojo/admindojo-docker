#!/usr/bin/env bash
set -e # Exit with nonzero exit code if anything fails

rm -rf "./missions/*"
mv "test_testmission-allwaysok_test" "./missions/"

./helper.sh input 1

if [ "$(crudini --get "./player/player.ini" "player" "mission_current")" ==  "TEST MISSION NAME" ]; then
            echo "ok"
            exit 0
        else
            echo "fail"
            exit 1
fi