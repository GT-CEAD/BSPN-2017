### Tentativa de fazer um connected scatterplot das receitas e despesas totais dos entes.
### Tirei do bspn.Rmd por não ter dado sequência

```{r import}
rec_mun <- read_excel("consol_serie.xls", sheet="Receita Municipios",skip=11,trim_ws=FALSE)
rec_est <- read_excel("consol_serie.xls", sheet="Receita Estados",skip=11,trim_ws=FALSE)
rec_uni <- read_excel("consol_serie.xls", sheet="Receita Uniao",skip=11,trim_ws=FALSE)

des_mun <- read_excel("consol_serie.xls", sheet="Despesa Municipios Emp",skip=11,trim_ws=FALSE)
des_est <- read_excel("consol_serie.xls", sheet="Despesa Estados Emp",skip=11,trim_ws=FALSE)
des_uni <- read_excel("consol_serie.xls", sheet="Despesa Uniao Emp",skip=11,trim_ws=FALSE)


rec_total_mun <- rec_mun[which(rec_mun$RECEITA=="TOTAL"),]
rec_total_mun[1,1] <- "Municipios"
rec_total_est <- rec_est[which(rec_est$RECEITA=="TOTAL"),]
rec_total_est[1,1] <- "Estados"
rec_total_uni <- rec_uni[which(rec_uni$RECEITA=="TOTAL"),]
rec_total_uni[1,1] <- "Uniao"

totais <- rbind(rec_total_mun[,1:14],rec_total_est,rec_total_uni[1:14])
totais$tipo <- "Receita"
colnames(totais)[1]<-"Ente"

des_total_mun <- des_mun[which(des_mun$`DESPESAS EMPENHADAS`=="TOTAL"),]
des_total_mun[1,1] <- "Municipios"
des_total_est <- des_est[which(des_est$`DESPESAS EMPENHADAS`=="TOTAL"),]
des_total_est[1,1] <- "Estados"
des_total_uni <- des_uni[which(des_uni$`DESPESAS EMPENHADAS`=="TOTAL"),]
des_total_uni[1,1] <- "Uniao"

totais_desp <- rbind(des_total_est,des_total_mun,des_total_uni)
totais_desp$tipo <- "Despesa"
colnames(totais_desp)[1]<-"Ente"

totais <- rbind(totais,totais_desp)

totais_bk <- totais

colnames(totais)

library(ipeaData)
pibs <- ipeadata("BM12_PIBAC12")
pibs <- pibs[MES=="12" & ANO %in% (2000:2012)]$VALVALOR


for (i in 1:13){
  totais[,i+1] <- totais_bk[,i+1]/(pibs[i]*1000000)
}

totais <- totais[,c(1,15,2:14)]

totais <- totais %>% gather(3:15, key = "Ano", value = "Valor") 
totais <- totais %>% spread(key = "tipo", value = "Valor")

devtools::install_github("dgrtwo/gganimate")
devtools::install_github("yihui/animation") 
install.packages("magick")
library(gganimate)
library(animation)
library(magick)

p <- ggplot(totais, aes(x = Receita, y = Despesa, group = Ente, frame = Ano)) + 
  geom_point(aes(color = Ente), size = 2)
#  geom_path(aes(color = Ente))+

# o código seguinte dá um resultado diferente...
# rec_total_mun <- rec_mun[rec_mun$RECEITA=="TOTAL",]
```

```{r, fig.show = "animate"}
gganimate(p)
```

```{r}
theme_slope <- function(){
  theme_minimal() +
    theme(
      plot.background = element_rect(colour = "grey20"),
      text = element_text(family = "Roboto Condensed Light", colour = "white"), #Cambria? #"Source Sans Pro"
      title = element_text(colour = "gray25", face = "bold", family = "Roboto", size = 14),
      plot.subtitle = element_text(face = "bold", family = "Roboto", color = "#B90000", size = 12),
      plot.caption = element_text(colour = "gray40", face = "plain", family = "Roboto Condensed", size = 10),
      strip.background = element_rect(fill = "gray95", color = "gray95"),
      panel.background = element_blank(),
      panel.grid=element_blank(),
      axis.ticks=element_blank(),
      axis.text=element_blank(),
      panel.border=element_blank(),
      legend.position = "none"
    )
}

p + theme_slope()
```


```{r}
# Conta a quantidade de zeros na frente
ws <- NULL
for (texto in rec_mun$RECEITA){
  if (is.na(texto)) {ws<-c(ws,NA)}
  else {
    conta_ws <- 0
    for (i in 1:nchar(texto)){
      if (substr(texto,i,i) == " "){
        conta_ws <- conta_ws+1
      }
      else break
    }
    ws <- c(ws,conta_ws)
  }
}

rec_mun$nivel <- ws/4 + 1

```