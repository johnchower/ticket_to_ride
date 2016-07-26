# Master Script: load destination tickets
library(dplyr)

destination_tickets <- 
  read.csv("destination_tickets.csv", stringsAsFactors = F) %>%
  filter(card != "") %>%
  select(ticket = card) %>%
  mutate(ticket = gsub(" ", "_", ticket)) %>%
  mutate(ticket = gsub("\\(", "to_", ticket)) %>% 
  mutate(ticket = gsub("\\)", "", ticket)) %>% 
  mutate(ticket = gsub("_Ste_", "_St_", ticket)) %>% 
  mutate(ticket = gsub("_Ste._", "_St_", ticket)) %>% 
  mutate(ticket = gsub("New_York_City", "New_York", ticket)) %>% 
  {
    ticketvec <- .$ticket
    spliticket <- strsplit(ticketvec, "_to_", fixed = T)
    spliticket <- 
      ldply(
        .data =spliticket
        , .fun = function(v){
            v_first2 <- v[1:2]
            v_first2 <- v_first2[order(v_first2)]
            newrow <- c(v_first2, v[3])
            data.frame(
              city_1 = newrow[1]
              , city_2 = newrow[2]
              , points = as.numeric(newrow[3])
            ) %>%
              return
          }
      )
  }
