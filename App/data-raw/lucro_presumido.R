produto = 270613.48
custas = 300534.71
icms_custas = 92333.24


pis = 0.0065
cofins = 0.03
irpj = 0.012
csll = 0.0108
icms = 0.18

total_impostos_por_nota = pis + cofins + irpj + csll + icms
n_nota = 6
lucro_desejado = 30000

total = custas + produto + lucro_desejado - icms_custas
total_por_nota_ = total/n_nota
total_por_nota = (1+total_impostos_por_nota)*total_por_nota_

pis_nota= total_por_nota*pis
cofins_nota = total_por_nota*cofins
irpj_nota = total_por_nota*irpj
csll_nota = total_por_nota*csll
icms_nota = total_por_nota*icms 


input <- list(mercadoria =270613.48,
              custas =300534.71,
              icms_custas = 92333.24,
              n_notas = 6,
              lucro = 30000)
