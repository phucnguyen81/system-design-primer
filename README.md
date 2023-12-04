# [System Design Primer in Jekyll](https://phucnguyen81.github.io/system-design-primer/)

This is a static site version of
[System Design Primer](https://github.com/donnemartin/system-design-primer)
built with Jekyll and
[hosted on GitHub Pages](https://phucnguyen81.github.io/system-design-primer/).

## Setup

- Install [ruby-install](https://github.com/postmodern/ruby-install)
- Run `ruby-install ruby "$(< .ruby-version)"` to install ruby into `~/.rubies/ruby-<version>`
- Install [direnv](https://direnv.net) tool
- Add the following function to `~/.config/direnv/direnvrc`:
```sh
use_ruby() {
    local ruby_dir=$HOME/.rubies/ruby-$1
    load_prefix $ruby_dir
    layout ruby
}
```
- cd into this folder to trigger direnv to load the project's environment
- Run `dev update` to install ruby dependencies into local `./.direnv/ruby` directory
- Run `dev serve` to start the Jekyll server

## Deploy to GitHub Pages

- Run `dev build` to build the site into `docs/` folder
- Push the `docs/` folder to GitHub

## Customize the site's theme

The site uses
[minima theme 2.5.1](https://github.com/jekyll/minima/tree/v2.5.1).
Take a look at the source code to know which files to override.
