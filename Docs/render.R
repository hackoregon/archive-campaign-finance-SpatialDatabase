for (file in list.files(pattern=glob2rx('*.Rmd'))) {
  rmarkdown::render(file, output_format='md_document')
}
