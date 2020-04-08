library(tidyverse)
library(readxl)

lista_funcoes <- c("Legislativa","Judiciária","Essencial à Justiça","Administração","Defesa Nacional","Segurança Pública","Relações Exteriores","Assistência Social","Previdência Social","Saúde","Trabalho","Educação","Cultura","Direitos da Cidadania","Urbanismo","Habitação","Saneamento","Gestão Ambiental","Ciência e Tecnologia","Agricultura","Organização Agrária","Indústria","Comércio e Serviços","Comunicações","Energia","Transporte","Desporto e Lazer","Encargos Especiais")
lista_funcoes_cod <- c("01 - Legislativa","02 - Judiciária","03 - Essencial à Justiça","04 - Administração","05 - Defesa Nacional","06 - Segurança Pública","07 - Relações Exteriores","08 - Assistência Social","09 - Previdência Social","10 - Saúde","11 - Trabalho","12 - Educação","13 - Cultura","14 - Direitos da Cidadania","15 - Urbanismo","16 - Habitação","17 - Saneamento","18 - Gestão Ambiental","19 - Ciência e Tecnologia","20 - Agricultura","21 - Organização Agrária","22 - Indústria","23 - Comércio e Serviços","24 - Comunicações","25 - Energia","26 - Transporte","27 - Desporto e Lazer","28 - Encargos Especiais")

tab_funcoes <- data.frame("nome_fun" = lista_funcoes,
                          "funcao" = lista_funcoes_cod)

setwd("~/GitHub/BSPN-2017")

mun <- read.csv2("./dados/finbraRREO_mun2019.csv", skip = 5)

levels(mun$Coluna)

mun_fun <- mun %>%
  filter(Conta %in% lista_funcoes,
         Coluna == "DESPESAS EMPENHADAS ATÉ O BIMESTRE (b)") %>%
  group_by(Conta) %>%
  summarise(valor = sum(Valor))

mun_fun_cod <- mun_fun %>%
  ungroup() %>%
  left_join(tab_funcoes, by = c("Conta" = "nome_fun")) %>%
  mutate(cod = as.numeric(str_sub(funcao, 1, 2))) %>%
  arrange(cod) %>%
  select(-Conta, -cod)

est <- read.csv2("./dados/finbraRREO_est2019.csv", skip = 5)

est_fun <- est %>%
  filter(Conta %in% lista_funcoes,
         Coluna == "DESPESAS EMPENHADAS ATÉ O BIMESTRE (b)") %>%
  group_by(Conta) %>%
  summarise(valor = sum(Valor)) %>%
  ungroup()

est_fun_cod <- tab_funcoes %>%
  left_join(est_fun, by = c("nome_fun" = "Conta")) %>%
  mutate(cod = as.numeric(str_sub(funcao, 1, 2))) %>%
  arrange(cod) %>%
  select(-cod)

write.csv2(mun_fun_cod, file = "mun2019.csv")
write.csv2(est_fun_cod, file = "est2019.csv")

  