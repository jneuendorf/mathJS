make:
	./js/build
	python3 py/macro_processing.py source.coffee macros.coffee
	coffee -c source.coffee
	python3 py/macro_processing.py source.js macros.js

doc: make
	coffee --output doc_base --compile js
	yuidoc -o doc doc_base

production: make
	uglifyjs source.js -o source.js -c drop_console=true -d DEBUG=false

cs:
	tar cfv coffee.tar *.coffee

js:
	tar cfv javascript.tar *.js
