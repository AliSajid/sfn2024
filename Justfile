alias a: all

render:
  quarto render ad_ipsc.Rmd
  quarto render scz_ipsc.Rmd
  quarto render scz_region.Rmd

uka:
  Rscript uka_analysis.R
  Rscript uka_analysis_single_sample.R

creeden:
  Rscript creedenzymatic_analysis.R
  Rscript generate_quartile_plots.R

all: render uka creeden
