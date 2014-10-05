make:
	./js/build
	coffee -c source.coffee

doc: make
	coffee --output doc_base --compile js
	yuidoc -o doc doc_base

production: make
	uglifyjs source.js -o source.js -c drop_console=true

cs:
	tar cfv coffee.tar *.coffee

js:
	tar cfv javascript.tar *.js