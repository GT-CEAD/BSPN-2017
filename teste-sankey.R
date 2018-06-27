# a ideia aqui era testar se seria possível ter mais de um link igual (mesmo source e mesmo target),
# para aplicar cores diferentes a cada link. funcionou.

library(plotly)

origens <- c(0,0)
target <- c(1,1)
value <- c(6,4)
rotulos <- c("Nó 1", "Nó 2")
cores <- c("#004a93","#ffd500")
cores_nos <- c("#329c32","#dd3127")

dados <- data.frame(origens, target, value, cores)


p <- plot_ly(
    type = "sankey",
    orientation = "v",
    opacity = 0.6,
    textfont = list(
      family = "Source Sans Pro",
      color = "#444444",
      size = 12),
    
    node = list(
      label = rotulos,
      color = cores_nos,
      pad = 10,
      thickness = 25,
      line = list(
        color = "",
        width = 0)),
    
    hoverlabel = list(
      font = list(
        family = "Source Sans Pro")),
    
    link = list(
      source = dados$origens,
      target = dados$target,
      value =  dados$value,
      color = dados$cores)) %>% 
  
    layout(
      title = "",
      font = list(
        family = "Source Sans Pro",
        size = 11,
        color = "#004a93"))

p