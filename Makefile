
doc.css:
	wget https://raw.githubusercontent.com/keplerproject/kepler/master/css/doc.css

check:
	xmllint --noout --valid index.html
	xmllint --noout --valid testmore.html
	xmllint --noout --valid testbuilder.html
	xmllint --noout --valid socketoutput.html

