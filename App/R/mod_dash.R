#' dash UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for.
#'
#' @noRd
mod_dash_ui <- function(id){
  ns <- shiny::NS(id)
  
  shiny::tagList(
    shiny::fluidRow(
      shiny::column(offset = 1, width = 2,shiny::numericInput(inputId = ns('mercadoria'),label = 'Valor da mercadoria',value = 0,min = 0)),
      shiny::column(width = 2,shiny::numericInput(inputId = ns('custas'),label = 'Custas de importação',value = 0,min = 0)),
      shiny::column(width = 2,shiny::numericInput(inputId = ns('icms_custas'),label = 'ICMS das custas de importação (presente na nota de entrada)',value = 0,min = 0)),
      shiny::column(width = 2,shiny::numericInput(inputId = ns('n_notas'),label = 'Número de notas a serem emitidas',value = 1,min = 1)),
      shiny::column(width = 2,shiny::numericInput(inputId = ns('lucro'),label = 'Lucro desejado',value = 0,min = 0))
    ),
    
    
    
    shiny::fluidRow(
      shiny::column(width = 2,shiny::checkboxInput(inputId = ns('mesmo_valor'),label = 'Notas com o mesmo valor?',value = TRUE))
    ),
    
    
    
    shinydashboard::box(title = 'Resumo',width = 6,
                        reactable::reactableOutput(outputId = ns('react_calc'),height = '400px')),
    
    shinydashboard::box(title = 'Notas',width = 6,
                        reactable::reactableOutput(outputId = ns('notas'),height = '400px'))
    
  )
  
}

#' dash Server Functions
#'
#' @noRd
mod_dash_server <- function(input, output, session){
  ns <- session$ns
  
  output$react_calc <- reactable::renderReactable({
    shiny::validate(shiny::need(expr = input$mercadoria != 0,message = 'Insira o valor da mercadoria'),
                    shiny::need(expr = input$custas != 0,message = 'Insira o valor das custas de importação'),
                    shiny::need(expr = input$icms_custas != 0,message = 'Insira o valor do ICMS das custas, presente na nota de entrada'),
                    shiny::need(expr = input$n_notas != 0,message = 'Insira o número de notas desejadas'))
    
    tibble::tibble(
      `Valor da mercadoria` = input$mercadoria,
      `Custas de importação` = input$custas,
      `ICMS das custas de importação` = input$icms_custas,
      # n_notas = input$n_notas,
      `Lucro líquido desejado` = input$lucro
    ) %>% 
      tidyr::pivot_longer(cols = dplyr::everything()) %>%
      reactable::reactable(
        columns = list(
          name = reactable::colDef(name = ''),
          value = reactable::colDef(name = '', format = reactable::colFormat(currency = "BRL",separators = TRUE))
        )
      )
  })
  
  output$notas <- reactable::renderReactable({
    pis = 0.0065
    cofins = 0.03
    irpj = 0.012
    csll = 0.0108
    icms = 0.18
    
    total_impostos_por_nota = pis + cofins + irpj + csll + icms
    total = input$custas + input$mercadoria + input$lucro - input$icms_custas
    total_por_nota_ = total/input$n_notas
    total_por_nota = (1+total_impostos_por_nota)*total_por_nota_
    
    if(!input$mesmo_valor){ 
      
      t <- total_por_nota*input$n_notas
      
      set.seed(42)
      id = runif(input$n_notas-1,0.8,1)
      valor_notas <- id*total_por_nota
      valor_notas[length(valor_notas)+1] <- t-sum(total_por_nota*id)
      
    } else{
      valor_notas = rep(total_por_nota,input$n_notas)
    } 
    
    
    tibble::tibble(
      nota = paste0("Nota: ",1:input$n_notas),
      valor_nota = valor_notas,
      pis = valor_notas*pis,
      cofins = valor_notas*cofins,
      irpj = valor_notas*irpj,
      csll = valor_notas*csll,
      icms = valor_notas*icms,
    ) %>%
      reactable::reactable(
        columns = list(
          nota = reactable::colDef(name = 'Nota'),
          valor_nota = reactable::colDef(name = 'Valor total da nota', format = reactable::colFormat(currency = "BRL",separators = TRUE)),
          pis = reactable::colDef(name = 'PIS', format = reactable::colFormat(currency = "BRL",separators = TRUE)),
          cofins = reactable::colDef(name = 'COFINS', format = reactable::colFormat(currency = "BRL",separators = TRUE)),
          irpj = reactable::colDef(name = 'IRPJ', format = reactable::colFormat(currency = "BRL",separators = TRUE)),
          csll = reactable::colDef(name = 'CSLL', format = reactable::colFormat(currency = "BRL",separators = TRUE)),
          icms = reactable::colDef(name = 'ICMS', format = reactable::colFormat(currency = "BRL",separators = TRUE))
        )
      )
  })
  
}
