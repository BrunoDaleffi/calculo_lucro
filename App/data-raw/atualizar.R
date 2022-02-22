library(googlesheets4)
library(tidyverse)

sheet <- 'https://docs.google.com/spreadsheets/d/1towWmoMSSZgHKKdHCWcwjaeSnrMdx1qRYaD7c6U8n9Y/edit#gid'
googlesheets4::gs4_auth(email = 'brunodaleffi@gmail.com')

fluxo_bruno <- googlesheets4::read_sheet(ss = sheet,sheet = 'fluxo_bruno') %>%
  dplyr::mutate(quem = 'Bruno')

futuro <- googlesheets4::read_sheet(ss = sheet,sheet = 'futuro')

falta <- googlesheets4::read_sheet(ss = sheet,sheet = 'falta')

usethis::use_data(fluxo_bruno,overwrite = TRUE)
usethis::use_data(futuro,overwrite = TRUE)
usethis::use_data(falta,overwrite = TRUE)
