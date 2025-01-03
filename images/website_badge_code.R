# Creating Website Badge
pacman::p_load(
  "tidyverse",
  "hexSticker",
  "broom",
  "ggdag",
  "dagitty",
  install = FALSE
)

node_colors <- c(
  "Z[TIC]" = "#3d424d",  
  "X[t-1]" = "#6f032d",  
  "Y[t-1]" = "#a9994e", 
  "X[t]" = "#003a20",   
  "Y[t]" = "#111340"   
)

dgp1_dag <- dagitty('dag {
  "Z[TIC]" [pos="1.25,1"]
  "X[t-1]" [pos="0.5,0.5"]
  "Y[t-1]" [pos="1,0.75"]
  "X[t]" [pos="1.5,0.5"]
  "Y[t]" [pos="2,0.625"]
  "Z[TIC]" -> "X[t-1]"
  "Z[TIC]" -> "Y[t-1]"
  "Z[TIC]" -> "X[t]"
  "Z[TIC]" -> "Y[t]"
  "X[t-1]" -> "Y[t-1]"
  "Y[t-1]" -> "X[t]"
  "X[t]" -> "Y[t]"
  "X[t-1]" -> "X[t]"
  "Y[t-1]" -> "Y[t]"
}') %>%
  tidy_dagitty()

p <- ggplot(dgp1_dag, aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges() +
  geom_dag_point(aes(fill = name), color = "black", size = 16, shape = 21) +  
  scale_fill_manual(values = node_colors) +  
  theme_dag() +
  guides(fill = "none")

sticker(
  subplot = p,
  package = "",
  s_width = 1.65,
  s_height = 1.7,
  s_x = 1.05,
  s_y = 1.15,
  h_fill = "white",
  h_color = "black"
  ) %>%
 print()

ggsave(
  "stickerv2.png",
  width = 3,
  height = 3,
  path = "C:/Users/brian/Documents/website-brianlookabaugh/images"
)