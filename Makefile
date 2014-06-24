all: README.html

clean:
	rm -f README.html

.PHONY: all clean
.DELETE_ON_ERROR:
.SECONDARY:

%.html: %.md
	pandoc -s --mathjax $< >$@
