# [System Design Primer in Jekyll](https://phucnguyen81.github.io/system-design-primer/)

This is a static site version of
[System Design Primer](https://github.com/donnemartin/system-design-primer)
built with Jekyll and
[hosted on GitHub Pages](https://phucnguyen81.github.io/system-design-primer/).

## Development

- Install docker and docker-compose
- Run `./dev up` to run the service
- Run `./dev serve` to start the jekyll server
- Run `./dev attach` to attach to the service container (or use VS Code's Remote Container)
- Go to `localhost:4000` to see the generated site

## Deploy to GitHub Pages

- Run `./dev up` to run the service
- Run `./dev build` to build the site into `docs/` folder
- Commit the `docs/` folder and push to GitHub

## TODO

- [Learn Jekyll](https://jekyllrb.com/docs/)
- [Learn Jekyll theme from minimal-mistakes repo](https://github.com/mmistakes/minimal-mistakes)