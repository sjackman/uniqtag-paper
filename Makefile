# UniqTag: Content-derived unique and stable identifiers for gene annotation
# Copyright 2014 Shaun Jackman

# Render the manuscript
all: README.md index.html UniqTag.pdf

# Remove all generated files
clean:
	rm -f README.md index.html UniqTag.pdf \
		UniqTag-body-orig.tex UniqTag-body.tex UniqTag.tex

.PHONY: all clean
.DELETE_ON_ERROR:
.SECONDARY:

# Dependencies

# Rendering the LaTeX manuscript requires the LaTeX template and figures
UniqTag-body.tex: bioinfo/bioinfo.cls ensembl.png

# Rules

# Generate GitHub Flavored Markdown from Markdown
README.md: UniqTag.md
	pandoc -t markdown_github -o $@ $<

# Generate HTML from Markdown
index.html: UniqTag.md
	pandoc -s --mathjax -o $@ $<

# Generate TeX from Markdown
%-body-orig.tex: %.md
	pandoc -o $@ $<

# Munge the TeX
%-body.tex: %-body-orig.tex
	sed -e 's/\\section{Introduction}/\\end{abstract}&/' \
		-e 's/\\begin{longtable}/\\begin{table}[!b]\\centering\\begin{tabular}/' \
		-e 's/\\end{longtable}/\\end{tabular}\\end{table}/' \
		-e 's/\\endhead//' $< >$@

# Add the TeX header and footer
%.tex: %-header.tex %-body.tex %-footer.tex
	cat $^ >$@

# Render the PDF from the TeX
%.pdf: %.tex
	TEXINPUTS=.:bioinfo: pdflatex $<

# Download the Bioinformatics journal LaTeX template
bioinfo01.zip:
	wget http://www.oxfordjournals.org/our_journals/bioinformatics/for_authors/bioinfo01.zip

# Unzip the Bioinformatics journal LaTeX template
bioinfo/bioinfo.cls: bioinfo01.zip
	unzip -od bioinfo $<
	touch $@
