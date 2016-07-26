# Master script: determine basic centrality scores for tracks and cities
library(reshape2)
library(plyr)
library(dplyr)
library(magrittr)
library(igraph)
library(plotly)

source('fn_convert_df_graph_to_igraph.r')

long_city_adjacency_matrix <- 
  read.csv("long_city_adjacency_matrix.csv", stringsAsFactors = F)

city_graph <- long_city_adjacency_matrix %>% 
  select(city_1, city_2) %>%
  convert_df_graph_to_igraph(directed = F)


# Betweenness scores
city_betweenness <- city_graph %>% 
  betweenness %>% 
  {data.frame(city = names(.), betweenness.score = .)} %>% 
  mutate(betweenness.score = round(10*betweenness.score/max(betweenness.score),1)) %>%
  arrange(desc(betweenness.score))

track_betweenness <- city_graph %>% 
  {
    betweenness.score = edge_betweenness(.)
    vertex_names <- city_graph %>% 
      E %>% 
      attributes %>% 
      {.$vnames} %>% 
      strsplit("|", fixed = T) %>%
      ldply(
        .fun = function(v){
          data.frame(head = v[1], tail = v[2])
        }
      ) %>%
      cbind(betweenness.score) %>%
      return
  } %>%
  unique %>%
  mutate(betweenness.score = round(10*betweenness.score/max(betweenness.score),1)) %>%
  arrange(desc(betweenness.score))

# Eigenvector centrality
