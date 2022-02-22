#' Formato de numero
#' @param num numero a ser convertido
format_num <- function(num) {
  scales::number_format(big.mark = ".", decimal.mark = ",", accuracy = 1)(num)
}

#' Formato de porcentagem
#' @param pct numero a ser convertido
format_pct <- function(pct) {
  scales::percent_format(accuracy = 0.1)(pct)
}

#' Formato de dinheiro
#' @param num numero a ser convertido
format_dinhero <- function(num) {
  scales::dollar_format(prefix = "R$ ", big.mark = ".", decimal.mark = ",", accuracy = 0.01)(num)
}