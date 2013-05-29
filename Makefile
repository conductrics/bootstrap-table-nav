COFFEE=node_modules/.bin/coffee

all: $(COFFEE) bootstrap-table-nav.js

$(COFFEE):
	npm install coffee-script

%.js: %.coffee
	$(COFFEE) -cm $<
