# [System Design Primer in Jekyll](https://phucnguyen81.github.io/system-design-primer/)

This is a static site version of
[System Design Primer](https://github.com/donnemartin/system-design-primer)
built with Jekyll and
[hosted on GitHub Pages](https://phucnguyen81.github.io/system-design-primer/).

## Development

- Install docker and docker-compose
- Run `./dev up` to run the service
- Run `./dev serve` to start the jekyll server
- Go to `localhost:4000` to see the generated site
- Run `./dev attach` to attach to the service container (or use VS Code's Remote Container)

## Deploy to GitHub Pages

- Run `./dev up` to run the service
- Run `./dev build` to build the site into `docs/` folder
- Commit the `docs/` folder and push to GitHub

## Customize the site's theme

The site uses
[minima theme 2.5.1](https://github.com/jekyll/minima/tree/v2.5.1).
Take a look at the source code to know which files to override.

## TODO

- [x] Apply custom style to mermaid diagrams
- [ ] Summarize scaling aws in a post
- [Learn Jekyll](https://jekyllrb.com/docs/)
