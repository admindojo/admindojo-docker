# admindojo
> hands-on sysadmin training right in your terminal

[![Build Status](https://travis-ci.org/admindojo/admindojo.svg?branch=master)](https://travis-ci.org/admindojo/admindojo)

admondojo is a game that helps you learning to become familiar with linux admin tasks like installing and configuring a database.

Each lesson contains tasks to solve. Once you're done your setup will get checked. 
In tutor-mode a backgrund tutor will check your work constantly and provides hints.


## Installation

Requirements:
- freshly installed Ubuntu VM/Container/Server
- sudo user

Note: Since you'll modify the system, please run admindojo on an unused system only. You should be able to reinstall/rebuild the system after each lesson.

To let you run the admindojo by just typing `admindojo` the setup adds an alias to your .bash_profile.
```sh
git clone https://github.com/admondojo/admindojo.git
cd admondojo
sudo ./setup.sh
admindojo
```

## Usage
type `admindojo`
```
 >admindojo

 Start the training
    admindojo start   (list, select and start lessons)

 In-game control
    admindojo tasks   (show tasks)
    admindojo end     (end game, show restult)

 Tutor mode:
 Guides you through your lesson. Checks every minute if you solved a task and shows hints.
    admindojo tutor   (start tutor)
```

Select your lesson:
`admindojo start`

![Select your lesson](./documentation/screenshot_input.png)

View your tasks:
`admindojo tasks`

![View your tasks](./documentation/screenshot_tasks.png)

## Interactive tutor mode
`admindojo tutor`
![Get your result](./documentation/screenshot_result.png)




## Meta

Initial work:
- Marvin Heimbrodt – [@6uhrmittag](https://twitter.com/6uhrmittag) – marvin@6uhrmittag.de

Distributed under the MIT license. See ``LICENSE`` for more information.

## Contributing

Feedback and contribution is highly appreciated! 

The project is in a very early stage and so is the contribution setup. Please get in touch via github issue.

### Development setup

To run a test for all lessons run `./admindojo.sh testing`. 
Run this on a fresh VM/CI only! ***Testing mode installs/executes all lesson tasks.***

#### generate documentation
Install [shdoc](https://github.com/reconquest/shdoc) first
```sh
make doku
```

## Acknowledgments
Following texts, tools insipred or helped the development:

* [Lynis - Security auditing tool](https://github.com/CISOfy/lynis) - inspired the game mode
* [shdoc - Documentation generator for shell scripts](https://github.com/reconquest/shdoc) - used for documentation
* [Google Shell Style Guide](https://google.github.io/styleguide/shell.xml#Function_Names) - helped to improve code
* [ShellCheck - finds bugs in your shell scripts](https://google.github.io/styleguide/shell.xml#Function_Names) - awesome shell linter
