make:
	./js/build
	# -I is search path
	# m4 -I js js/jSVG-main.m4 > $(TARGET)
	m4 source.coffee > source_temp.coffee
	mv source_temp.coffee source.coffee
	coffee -c source.coffee

doc: make
	coffee --output doc_base --compile js
	yuidoc -o doc doc_base

production: make
	uglifyjs source.js -o source.js -c drop_console=true -d DEBUG=false

cs:
	tar cfv coffee.tar *.coffee

js:
	tar cfv javascript.tar *.js
