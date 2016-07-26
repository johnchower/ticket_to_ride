

library(dplyr)
library(magrittr)

city_df <- read.csv("city_graph.csv", stringsAsFactors = F) %>%
  select(city_1)

city_df %<>%
  {
    matrix(
      0
      , nrow = nrow(.), ncol = length(.$city_1)
      , dimnames = list(1:length(.$city_1), .$city_1)
    ) %>%
      as.data.frame
  } %>%
  {
    cbind(data.frame(city_1 = city_df$city_1,.))
  }

city_df %<>%
  edit

write.csv(city_df, "city_adjacency_matrix.csv")
