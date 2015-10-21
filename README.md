# Gitcopier
  Help developers to integrate between multiple repositories.

[![Gem Version](https://badge.fury.io/rb/gitcopier.svg)](https://badge.fury.io/rb/gitcopier)
[![Circle CI](https://circleci.com/gh/tranvictor/gitcopier.svg?style=svg)](https://circleci.com/gh/tranvictor/gitcopier)
[![Code Climate](https://codeclimate.com/repos/5627b7d16956804408002f46/badges/0959a12fd889b6a43f40/gpa.svg)](https://codeclimate.com/repos/5627b7d16956804408002f46/feed)
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gitcopier'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gitcopier

## Motivation
Imagine you are a Rails developer, your expertise is designing and developing
backend logic so you have one or more front end developers to help you with
design, javascript, stylesheet ... However, they are working in Nodejs environment
which is pretty different to Rails environment thus they have different repository.
In order to apply (integrate) changes from that repository, you might have to see 
what files were changed, copy them to appropriate places in your Rails repository.
Doing so is really annoying. You should have a better way of doing it.

## How `Gitcopier` work
`Gitcopier` helps you in intergrating those changes. Whenever you pull from front-end
repository, `Gitcopier` will ask you to decide where to copy changed file
(modified, added). It remembers your dicisions to automatically copy or not copy
in the future without asking you. This way, if front-end developers commit a
change to existing files, you just have to pull that repository and `Gitcopier` will
do all copying works.

## Usage
### Tell `Gitcopier` your repositories
```
gitcopier --from <path_to_external_repo> --to <path_to_main_repo>
```
where:
  1. `<path_to_external_repo>`: is absolute path to the repository that you
  want `Gitcopier` to copy files from. This repo must be under git control.
  2. `<path_to_main_repo>`: is absolute path to the repository that you want
  `Gitcopier` to copy files to.

> Note: `gitcopier -h` for help
```
gitcopier -h
Usage: gitcopier [options]
        --from [path]                Absolute path to your local repository that you want to copy from. This option must go with --to.
        --to [path]                  Absolute path to your local repository that you want to copy to. This option must go with --from.
    -v, --version
        --showall                    Show all integration information. This option ignore any other options.
```

### Working with git merge
After you `git pull` in external repository, `Gitcopier` will prompt your decision
where to copy the changed files.

## Contributing

1. Fork it ( https://github.com/tranvictor/gitcopier/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
