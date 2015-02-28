make:
	whoami
	./js/build
	m4 source.coffee > source_temp.coffee
	mv source_temp.coffee source.coffee
	coffee -c source.coffee
	# chmod 777 source.js
	# echo adf
	replace "child.__super__ = parent.prototype;" "child.__super__ = parent.prototype; child.__superClass__ = parent;" -- source.js

doc: make
	coffee --output doc_base --compile js
	yuidoc -o doc doc_base

production: make
	uglifyjs source.js -o source.js -c drop_console=true -d DEBUG=false

cs:
	tar cfv coffee.tar *.coffee

js:
	tar cfv javascript.tar *.js
