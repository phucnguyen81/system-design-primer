# [System Design Primer in Jekyll](https://phucnguyen81.github.io/system-design-primer/)

This is a static site version of
[System Design Primer](https://github.com/donnemartin/system-design-primer)
built with Jekyll and
[hosted on GitHub Pages](https://phucnguyen81.github.io/system-design-primer/).

## Development

- Install docker, docker-compose and [direnv](https://direnv.net) tool
- cd into this folder to trigger direnv to load environment variables
- Run `dev` to see available commands
- Run `dev up` to run the service in in detach mode
- Run `dev serve` to start the Jekyll server
- Go to `localhost:4000` to see the generated site
- Run `dev attach` to attach to the service container (or attach with VS
  Code's Dev Container)
- Run `dev down` to stop the service
- Run `dev <command>` in inplace of `docker compose <command>`

## Deploy to GitHub Pages

- Run `dev up` to run the service
- Run `dev buildsite` to build the site into `docs/` folder
- Push the `docs/` folder to GitHub

## Customize the site's theme

The site uses
[minima theme 2.5.1](https://github.com/jekyll/minima/tree/v2.5.1).
Take a look at the source code to know which files to override.
