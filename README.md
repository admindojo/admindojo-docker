# admindojo
> hands-on sysadmin training right in your terminal

[![Build Status](https://travis-ci.org/admindojo/admindojo.svg?branch=master)](https://travis-ci.org/admindojo/admindojo)

admondojo is a game that helps you to learn linux admin tasks like installing a webserver or updating the system.
You'll get lessons and tasks to solve and hints on how to solve your taks. 

## Installation

Requirements:
- Ubuntu
- sudo
- fresh VM

Note: Please use this game on a fresh VM, that you can delete later, only. Since you'll modify the system.

The setup adds the alias "admondojo" to your .bash_profile to let you run the game with just "admindojo"
```sh
git clone https://github.com/admondojo/admindojo.git
cd admondojo
sudo ./setup.sh
admindojo
```

## Usage
```
 admindojo

 Start the game
    start   (list, select and start lessons)

 In-game control
    tasks   (show tasks)
    end     (end game, show restult)

 Tutor mode:
 Guides you through your lesson. Checks every minute if you solved a task and shows hints.
    tutor   (start tutor)
```

Select your lesson:

![Select your lesson](./documentation/screenshot_input.png)

View your tasks:

![View your tasks](./documentation/screenshot_tasks.png)

## Interactive tutor mode
Starts a background tutor that checks your tasks and shows hints while playing.
![Get your result](./documentation/screenshot_result.png)


## Development setup

To run a test for all missions run `./admindojo.sh testing`. 
Run this on a fresh VM/CI only. Testing mode installs/executes all mission tasks.

generate documentation:
```sh
make doku
```

## Meta

Marvin Heimbrodt – [@6uhrmittag](https://twitter.com/6uhrmittag) – marvin@6uhrmittag.de

(***TODO***) Distributed under the XYZ license. See ``LICENSE`` for more information.

[https://slashlog.de/](slashlog.de)

## Contributing

1. Fork it (<https://github.com/admindojo/admindojo/fork>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

## Add missions

1. Fork it (<https://github.com/admindojo/admindojo/fork>)
2. Create your lesson branch (`git checkout -b lesson/fooBar`)
3. Add your lesson using the template
4. Please make sure all tasks are solvable! (Travis should be able to check the "test" sections)
5. Commit your changes (`git commit -am 'Add some fooBar'`)
6. Push to the branch (`git push origin lesson/fooBar`)
7. Create a new Pull Request

## Acknowledgments

* [Lynis - Security auditing tool](https://github.com/CISOfy/lynis) - inspired the game mode
* [shdoc - Documentation generator for shell scripts](https://github.com/reconquest/shdoc) - used for documentation