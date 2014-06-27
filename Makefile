all: README.html README.pdf

clean:
	rm -f README.html README.pdf

.PHONY: all clean
.DELETE_ON_ERROR:
.SECONDARY:

%.html: %.md
	pandoc -s --mathjax -o $@ $<

%.pdf: %.md
	pandoc -o $@ $<

%.pdf: %.tex bioinfo/bioinfo.cls
	TEXINPUTS=.:bioinfo: pdflatex $<

bioinfo01.zip:
	wget http://www.oxfordjournals.org/our_journals/bioinformatics/for_authors/bioinfo01.zip

bioinfo/bioinfo.cls: bioinfo01.zip
	unzip -d bioinfo $<
