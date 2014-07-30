all: README.md index.html UniqTag.pdf

clean:
	rm -f README.md index.html UniqTag.pdf \
		UniqTag-body-orig.tex UniqTag-body.tex UniqTag.tex

.PHONY: all clean
.DELETE_ON_ERROR:
.SECONDARY:

# Dependencies

UniqTag-body.tex: bioinfo/bioinfo.cls ensembl.png

# Rules

README.md: UniqTag.md
	pandoc -t markdown_github -o $@ $<

index.html: UniqTag.md
	pandoc -s --mathjax -o $@ $<

%-body-orig.tex: %.md
	pandoc -o $@ $<

%-body.tex: %-body-orig.tex
	sed -e 's/\\section{Introduction}/\\end{abstract}&/' \
		-e 's/\\begin{longtable}/\\begin{table}[!b]\\centering\\begin{tabular}/' \
		-e 's/\\end{longtable}/\\end{tabular}\\end{table}/' \
		-e 's/\\endhead//' $< >$@

%.tex: %-header.tex %-body.tex %-footer.tex
	cat $^ >$@

%.pdf: %.tex
	TEXINPUTS=.:bioinfo: pdflatex $<

bioinfo01.zip:
	wget http://www.oxfordjournals.org/our_journals/bioinformatics/for_authors/bioinfo01.zip

bioinfo/bioinfo.cls: bioinfo01.zip
	unzip -od bioinfo $<
	touch $@
