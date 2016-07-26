# Master script: determine basic centrality scores for tracks and cities
library(reshape2)
library(dplyr)
library(magrittr)
library(igraph)

source('fn_convert_df_graph_to_igraph.r')

long_city_adjacency_matrix <- 
  read.csv("long_city_adjacency_matrix.csv", stringsAsFactors = F)

city_graph <- long_city_adjacency_matrix %>% 
  convert_df_graph_to_igraph(directed = F)


# Betweenness scores
city_betweenness <- city_graph %>% 
  betweenness %>% 
  {data.frame(city = names(.), betweenness.score = .)} %>% 
  arrange(desc(betweenness.score))

# 
