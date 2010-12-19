
.SUFFIXES:

.SUFFIXES: .tex .pdf

.PHONEY : default pdf xpdf wpdf clean clobber

REPORT = mike_park_resume
SHOW = $(REPORT)

$(REPORT).pdf: $(REPORT).tex

default: pdf

pdf: $(REPORT:%=%.pdf)

.tex.pdf:
	pdflatex $*
	grep 'There were undefined references' $*.log > /dev/null && \
	   bibtex $* && pdflatex $* || true
	grep Rerun $*.log > /dev/null && pdflatex $* || true
	grep Rerun $*.log > /dev/null && pdflatex $* || true

xpdf: pdf
	xpdf -z page $(SHOW).pdf &

wpdf: pdf
	@echo watching \'$(SHOW).tex\' to run \'$(MAKE) pdf\'
	@ruby -e "file = '$(SHOW).tex'" \
	      -e "command = '$(MAKE) pdf'" \
	      -e "lm = File.mtime file" \
	      -e "while true do" \
	      -e " m = File.mtime file" \
	      -e " system command unless m==lm" \
	      -e " lm = m" \
	      -e " sleep 0.25" \
	      -e "end"

clean:
	rm -rf $(REPORT:%=%.aux) $(REPORT:%=%.bbl) $(REPORT:%=%.blg)
	rm -rf $(REPORT:%=%.log) $(REPORT:%=%.toc) $(REPORT:%=%.dvi)
	rm -rf $(REPORT:%=%.ind) $(REPORT:%=%.ilg) $(REPORT:%=%.nls)
	rm -rf $(REPORT:%=%.nlo) $(REPORT:%=%.out)

clobber: clean
	rm -rf $(REPORT:%=%.pdf)

