SHELL := zsh

.PHONY: all
all: dotfiles bins etcs

.PHONY: dotfiles
dotfiles: ## Installs the dotfiles.
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".vim" -not -name ".git" -not -name ".config" -not -name ".github" -not -name ".*.swp" -not -name ".gnupg"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done; \
	mkdir -p ~/.config
	ln -sfn $(CURDIR)/starship.toml $(HOME)/.config/starship.toml
	ln -sfn $(CURDIR)/ssh_config $(HOME)/.ssh/config

bins: ## Installs the binary scripts
	mkdir -p ~/bin
	for file in $(shell find $(CURDIR)/bin -type f); do \
		f=$$(basename $$file); \
	  ln -sfn $$file $(HOME)/bin/$$f; \
	done;

etcs: ## Installs etc config files
	for file in $(shell find etc -type f); do \
		mkdir -p /$$(dirname $$file); \
	  ln -sfn $(CURDIR)/$$file /$$file; \
	done;

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
