#!/usr/bin/env bash

# VS Code creates .vscode-server as root, have to reset the owner
[[ -d ~/.vscode-server ]] && sudo chown -R $(whoami) ~/.vscode-server

sleep infinity
