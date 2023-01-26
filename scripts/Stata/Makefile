.DEFAULT_GOAL := help

STATA_PATH="C:\Program Files (x86)\Stata13\StataMP-64"
EXECSTATA := $(STATA_PATH) -e do
SRC_DO := $(wildcard mturk/*.do mturk_hk/*.do survey-exp/*.do tx-lyceum/*.do)
SRC_ADO := $(wildcard ado/*.ado)

partisan-gaps-log.txt: partisan-gaps.do $(SRC_ADO) $(SRC_DO)
	@echo "+ $@"
	$(EXECSTATA) $<

.PHONY: all
all: # Run all do files
all: partisan-gaps-log.txt

.PHONY: check
check: # Print & check source do files
check: 
	@echo "+ test"
	@echo "+ $(SRC_DO)"
	@echo "+ $(SRC_ADO)"

.PHONY: help
help: # Show Help
	@egrep -h '\s#\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?# "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'	