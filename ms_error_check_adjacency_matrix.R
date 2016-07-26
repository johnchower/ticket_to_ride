# Master script: error check adjacency matrix
library(reshape2)
library(plyr)
library(dplyr)
library(magrittr)
library(igraph)

source('fn_convert_df_graph_to_igraph.r')

city_adjacency_matrix <- read.csv("city_adjacency_matrix.csv", stringsAsFactors = F) %>%
  select(-X)

long_city_adjacency_matrix <- city_adjacency_matrix %>%
  melt(variable.name = "city_2", value.name = "is.connected") 

connections_1 <- long_city_adjacency_matrix %>% 
  group_by(city_1) %>%
  summarise(number_of_connections = sum(is.connected))

connections_2 <- long_city_adjacency_matrix %>% 
  group_by(city_2) %>%
  summarise(number_of_connections = sum(is.connected))

connections_1_vs_2 <- merge(connections_1, connections_2, by.x = "city_1", by.y = "city_2")

# Does any city have a different number of connections in its row than in its column?
connections_1_vs_2 %>%
  filter(number_of_connections.x != number_of_connections.y)

# Is the matrix symmetric?

city_adjacency_matrix %>%
  select(-city_1) %>%
  as.matrix %>%
  {. - t(.)} %>%
  sum %>%
  {
    ifelse(. == 0, "Symmetric", "Asymmetric")
  }

# Is any city connected to itself?
long_city_adjacency_matrix %>%
  filter(city_1 == city_2, is.connected == 1)

# Does each city have the right number of connections (have to look at the map for this one)

connections_1_vs_2 %>% View

# Write out long_city_adjacency_matrix

long_city_adjacency_matrix %>%
  filter(is.connected == 1) %>%
  select(city_1, city_2) %>%
  mutate(city_2 = as.character(city_2)) %>% 
  group_by(city_1, city_2) %>% 
  mutate(city_a = min(city_1, city_2), city_b = max(city_1, city_2)) %>% 
  ungroup %>%
  distinct(city_a, city_b) %>%
  select(city_1 = city_a, city_2 = city_b) %>%
  write.csv("long_city_adjacency_matrix.csv", row.names = F)

rm(list = ls())



