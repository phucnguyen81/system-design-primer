# [System Design Primer in Jekyll](https://phucnguyen81.github.io/system-design-primer/)

This is a static site version of
[System Design Primer](https://github.com/donnemartin/system-design-primer)
built with Jekyll and
[hosted on GitHub Pages](https://phucnguyen81.github.io/system-design-primer/).

## Development

- Install docker and docker-compose
- Run `./run up` to run the service
- Run `./run serve` to start the Jekyll server
- Go to `localhost:4000` to see the generated site
- Run `./dev attach` to attach to the service container (or attach with VS
  Code's Dev Container)

## Deploy to GitHub Pages

- Run `./run up` to run the service
- Run `./run build-site` to build the site into `docs/` folder
- Push the `docs/` folder to GitHub

## Customize the site's theme

The site uses
[minima theme 2.5.1](https://github.com/jekyll/minima/tree/v2.5.1).
Take a look at the source code to know which files to override.

## TODO

- [x] Apply custom style to mermaid diagrams
- [x] Run the service as a non-root user matching host user
- [x] Can attach to the container with VS Code Dev Container
- [ ] Summarize scaling aws in a post
- [Learn Jekyll](https://jekyllrb.com/docs/)
