# UniqTag: Content-derived unique and stable identifiers for gene annotation
# Copyright 2014 Shaun Jackman

# Render the manuscript
all: README.md index.html UniqTag.pdf \
	UniqTag-supp.md UniqTag-supp.html UniqTag-supp.pdf

# Remove all generated files
clean:
	rm -f README.md index.html UniqTag.pdf \
		UniqTag-body-orig.tex UniqTag-body.tex UniqTag.tex \
		UniqTag-supp.md UniqTag-supp.html UniqTag-supp.pdf

# Install dependencies
install-deps: /usr/local/bin/brew
	$(MAKE) -C data $@
	brew install imagemagick r wget

# Check for Homebrew
/usr/local/bin/brew:
	@if brew --version >/dev/null 2>/dev/null; then \
		echo Install Homebrew http://brew.sh/ or Linuxbrew http://brew.sh/linuxbrew/; \
	fi

.PHONY: all clean install-deps
.DELETE_ON_ERROR:
.SECONDARY:

# Dependencies

# Render the figures by knitting the RMarkdown
figure/ensembl.png: UniqTag-supp.md

# Rendering the LaTeX manuscript requires figures and the LaTeX template
UniqTag-body.tex: figure/ensembl.png bioinfo/bioinfo.cls

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

# Supplementary material

# Run the analysis
data/UniqTag.tsv:
	$(MAKE) -C data

# Copy the results of the analysis to this directory
UniqTag-supp.tsv: data/UniqTag.tsv
	cp -a data/UniqTag.tsv $@

# Generate Markdown from RMarkdown
%.md: %.Rmd %.tsv
	Rscript -e 'knitr::knit("$<", "$@")'
	mogrify -units PixelsPerInch -density 300 figure/*.png

# Generate HTML from RMarkdown
%.html: %.Rmd %.tsv
	Rscript -e 'rmarkdown::render("$<", "html_document", "$@")'

# Generate PDF from RMarkdown
%.pdf: %.Rmd %.tsv
	Rscript -e 'rmarkdown::render("$<", "pdf_document", "$@")'
