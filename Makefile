.DEFAULT_GOAL := help

.PHONY: update
update: # Update tables and figures in the submodule by coping from ./figs and ./tabs
update:
	@echo "+ $@"
	@echo "+ Updating tables..."
	cp -a tabs/. overleaf-partisan-gap/tabs/.
	@echo "+ Updating figures..."
	cp -a figs/. overleaf-partisan-gap/figs/.

.PHONY: help
help: # Show Help
	@egrep -h '\s#\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?# "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'	