all: README.html README.pdf

clean:
	rm -f README.html README.pdf

.PHONY: all clean
.DELETE_ON_ERROR:
.SECONDARY:

%.html: %.md
	pandoc -s --mathjax -o $@ $<

%.pdf: %.md
	pandoc --latex-engine=xelatex -o $@ $<
