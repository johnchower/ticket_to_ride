# Function: convert_df_graph_to_igraph
# Requires packages igraph and magrittr

convert_df_graph_to_igraph <- function(df,...){
  
  df %>%
    apply(
      1
      , function(e){e}
    ) %>% 
    c %>%
    make_graph(...) %>%
    return
}