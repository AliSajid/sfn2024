# Generate correlation plots from UKA scores

library(tidyverse)

create_correlation_plot <- function(file_a, file_b) {
  a <- read_tsv(file_a) |> mutate(dataset = basename(file_a) |> str_remove("_coral_input.csv"))
  b <- read_tsv(file_b) |> mutate(dataset = basename(file_b) |> str_remove("_coral_input.csv"))

  combined_data <- bind_rows(a, b) |>
    pivot_wider(names_from = dataset, values_from = Score)

  p <- ggscatter(combined_data,
    x = "Project", y = "Pamgene",
    color = "black", shape = 19,
    add = "reg.line",
    cor.coef = TRUE,
    cor.coeff.args = list(
      method = "pearson",
      aes(label = paste(..r.label.., ..p.label.., sep = "~`,`~")),
      label.x = 1.5, label.y = 0.75,
      label.sep = "\n", cor.coef.name = "R", p.accuracy = 0.01,
      r.accuracy = 0.01
    ),
    cor.coef.size = 5
  ) +
    scale_x_continuous(limits = c(0, 3)) +
    scale_y_continuous(limits = c(0, 3)) +
    theme_prism()
}

files <- list.files("results", pattern = "input", full.names = TRUE)

params <- expand_grid(file_a = files, file_b = files) |>
  filter(file_a != file_b) |>
  mutate(
    plot = map2(file_a, file_b, ~ create_correlation_plot(.x, .y)),
    plot_name = str_c(basename(file_a), "_", basename(file_b), ".svg"),
    saved = ggsave(plot = plot, path = figures, width = 4, height = 3, units = "in", path = "figures")
  )
