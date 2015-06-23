JQUERY = "includes/jquery-2.1.1.min.js"
NUMERAL = "includes/numeraljs/numeral.min.js"

INCLUDES = $(JQUERY) $(NUMERAL)

make:
	./js/build
	python3 py/macro_processing.py source.coffee macros.coffee
	coffee -c source.coffee
	python3 py/macro_processing.py source.js macros.js

doc: make
	coffee --output doc_base --compile js
	yuidoc -o doc doc_base

test: make
	sh tests/build.sh

production: make
	uglifyjs source.js -o source.js -c drop_console=true -d DEBUG=false

production_with_libs: production
	cat $(INCLUDES) source.js > source.js.tmp
	mv source.js.tmp source.js

cs:
	tar cfv coffee.tar *.coffee

js:
	tar cfv javascript.tar *.js
