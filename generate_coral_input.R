# Process the UKA results into a format appropriate for CORAL

library(tidyverse)


transform_data <- function(filepath) {
  read_csv(filepath) |>
    select(
      Kinase = `Kinase Name`,
      UniprotID = `Kinase Uniprot ID`,
      Score = `Median Kinase Statistic`
    ) |>
    mutate(
      Score = -log10(Score)
    )
}


uka_files <- list.files("results", "uka", full.names = TRUE) |>
  set_names(~ basename(.x) |> str_remove("-uka_table_full"))

uka_data <- uka_files |>
  map(transform_data) |>
  imap(~ write_csv(.x, file.path("results", str_glue("{.y}_coral_input.csv"))))
