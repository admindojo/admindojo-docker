#!/usr/bin/env bash
set -e # Exit with nonzero exit code if anything fails

# Test each mission
# Test only tasks that contain "test" commands

source ../game.sh


echo "------------------   TEST MISSIONS START  ------------------"
source test_missions.sh
echo "------------------   TEST MISSIONS DONE  ------------------"

echo "------------------   TEST MISSIONS START  ------------------"
source ../helper.sh input 1
echo "------------------   TEST MISSIONS DONE  ------------------"

echo "------------------   TEST MISSIONS START  ------------------"
source test_setmission.sh
echo "------------------   TEST MISSIONS DONE  ------------------"