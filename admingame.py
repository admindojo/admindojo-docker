#!/usr/bin/python3


import subprocess

cmd = "date"

# returns output as byte string
returned_output = subprocess.check_output(cmd).decode("utf-8")

# using decode() function to convert byte string to string
print('Current date is:', returned_output)
