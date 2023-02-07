# Creating Website Badge
pacman::p_load(
  "tidyverse",
  "hexSticker",
  "broom",
  install = FALSE
)

# Create Dummy Data
set.seed(1234)
y = rnorm(n = 100, mean = 0, sd = 2)
x1 = rnorm(n = 100, mean = 1, sd = 0.25)
x2 = rnorm(n = 100, mean = 2, sd = 0.001)
x3 = rnorm(n = 100, mean = 3, sd = 5)
x4 = rnorm(n = 100, mean = 4, sd = 6)
x5 = rnorm(n = 100, mean = 5, sd = 7)
merged <- cbind(y, x1, x2, x3, x4, x5)
merged <- data.frame(merged)

# Generate Dummy Models
m1 <- lm(y ~ x1, data = merged)
m2 <- lm(y ~ x1 + x2, data = merged)
m3 <- lm(y ~ x1 + x2 + x3, data = merged)
m4 <- lm(y ~ x1 + x2 + x3 + x4, data = merged)
m5 <- lm(y ~ x1 + x2 + x3 + x4 + x5, data = merged)

models <- tribble(
  ~model_name, ~model_results,
  "M1", m1,
  "M2", m2,
  "M3", m3,
  "M4", m4,
  "M5", m5
) %>%
  mutate(tidied = map(model_results, ~tidy(., conf.int = TRUE)),
         effect = map(tidied, ~filter(., term == "x1"))) %>%
  unnest(effect) %>%
  select(-model_results, -tidied) %>%
  mutate(method = fct_inorder(model_name))

# Plot the Effects
p <- ggplot(models, aes(x = estimate, y = fct_rev(model_name), color = model_name)) +
  geom_vline(xintercept = 0, size = 1, linetype = "dashed", color = "black") +
  scale_color_viridis_d(option = "mako", end = 0.9, guide = "none") +
  geom_pointrange(aes(xmin = conf.low, xmax = conf.high), size = 1) +
  labs(x = "", y = "") +
  theme_light() +
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid = element_blank(),
        panel.border = element_blank())

# Create and Save the Sticker
sticker(
  subplot = p,
  package = "",
  s_width = 1.5,
  s_height = 1.5,
  s_x = 1,
  s_y = 1,
  h_fill = "transparent",
  h_color = "black"
) %>%
  print()

ggsave(
  "sticker.png",
  width = 2,
  height = 2,
  path = "C:/Users/brian/Desktop/Job/website-brianlookabaugh/images"
)