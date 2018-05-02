# linux admin tutor
> Learn linux while solving interactive tutorials.

[![Build Status](https://travis-ci.org/6uhrmittag/linux-admin-tutor.svg?branch=master)](https://travis-ci.org/6uhrmittag/linux-admin-tutor)

Linux admin tutor is a tool to learn how to solve linux admin tasks like installing an webserver. You'll get tasks, hints 
on how to solve your mission and points for every solved task.

## Installation

Requirements:
- Ubuntu
- sudo

```sh
git clone https://github.com/6uhrmittag/linux-admin-tutor.git
cd linux-admin-tutor
sudo ./setup.sh
./tutor.sh list
```

## Usage example

(***TODO***) 

## Development setup

To run a test for all missions run `./tutor.sh testing`. 
Run this on a fresh VM/CI only. testing mode installs/executes all mission tasks.

generate documentation:
```sh
make doku
```

## Meta

Marvin Heimbrodt – [@6uhrmittag](https://twitter.com/6uhrmittag) – marvin@6uhrmittag.de

(***TODO***) Distributed under the XYZ license. See ``LICENSE`` for more information.

[https://slashlog.de/](slashlog.de)

## Contributing

1. Fork it (<https://github.com/6uhrmittag/linux-admin-tutor/fork>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

## Add missions

1. Fork it (<https://github.com/6uhrmittag/linux-admin-tutor/fork>)
2. Create your mission branch (`git checkout -b mission/fooBar`)
3. Add your mission using the template
4. Please make sure all tasks are solvable! (Travis should be able to check the "test" sections)
5. Commit your changes (`git commit -am 'Add some fooBar'`)
6. Push to the branch (`git push origin mission/fooBar`)
7. Create a new Pull Request

## Acknowledgments

* [Lynis - Security auditing tool](https://github.com/CISOfy/lynis) - inspired the game mode
* [shdoc - Documentation generator for shell scripts](https://github.com/reconquest/shdoc) - used for documentation