all: README.html README.pdf uniqtag.pdf

clean:
	rm -f README.html README.pdf uniqtag-body-orig.tex uniqtag-body.tex uniqtag.tex uniqtag.pdf

.PHONY: all clean
.DELETE_ON_ERROR:
.SECONDARY:

%.html: %.md
	pandoc -s --mathjax -o $@ $<

%.pdf: %.md
	pandoc -o $@ $<

uniqtag-body-orig.tex: README.md
	pandoc -o $@ $<

%-body.tex: %-body-orig.tex
	sed -e 's/\\section{Introduction}/\\end{abstract}&/' \
		-e 's/\\begin{longtable}/\\begin{table}[!h]\\centering\\begin{tabular}/' \
		-e 's/\\end{longtable}/\\end{tabular}\\end{table}/' \
		-e 's/\\endhead//' $< >$@

%.tex: %-header.tex %-body.tex %-footer.tex
	cat $^ >$@

uniqtag-body.tex: bioinfo/bioinfo.cls

%.pdf: %.tex
	TEXINPUTS=.:bioinfo: pdflatex $<

bioinfo01.zip:
	wget http://www.oxfordjournals.org/our_journals/bioinformatics/for_authors/bioinfo01.zip

bioinfo/bioinfo.cls: bioinfo01.zip
	unzip -od bioinfo $<
	touch $@
