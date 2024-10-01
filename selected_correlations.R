# Do selected correlation analysis

library(tidyverse)
library(ggpubr)
library(ggprism)
library(plotrix)

scz_region_data <- read_csv("results/scz_region-dpp_SCZ_CTL-STK.csv") |>
  mutate(dataset = "scz_region", totalMeanLFC = rescale(totalMeanLFC, c(-5, 5))) |>
  select(Peptide, totalMeanLFC, dataset) |>
  distinct()

scz_ipsc_data <- read_csv("results/scz_ipsc-dpp_CTL_SCZ-STK.csv") |>
  mutate(dataset = "scz_ipsc", totalMeanLFC = rescale(totalMeanLFC, c(-5, 5))) |>
  select(Peptide, totalMeanLFC, dataset) |>
  distinct()

ad_ipsc <- read_csv("results/ad_ipsc-dpp_F020A-N_03-N-STK.csv") |>
  mutate(dataset = "ad_ipsc", totalMeanLFC = rescale(totalMeanLFC, c(-5, 5))) |>
  select(Peptide, totalMeanLFC, dataset) |>
  distinct()


scz_v_scz <- bind_rows(scz_region_data, scz_ipsc_data) |> pivot_wider(names_from = dataset, values_from = totalMeanLFC)
scz_ipsc_v_ad_ipsc <- bind_rows(scz_ipsc_data, ad_ipsc) |> pivot_wider(names_from = dataset, values_from = totalMeanLFC)
scz_region_v_ad_ipsc <- bind_rows(scz_region_data, ad_ipsc) |> pivot_wider(names_from = dataset, values_from = totalMeanLFC)


p <- ggscatter(scz_v_scz,
  x = "scz_region", y = "scz_ipsc",
  color = "black", shape = 19,
  add = "reg.line",
  cor.coef = TRUE,
  cor.coeff.args = list(
    method = "pearson",
    aes(label = paste(..r.label.., ..p.label.., sep = "~`,`~")),
    label.x = 0, label.y = 4,
    label.sep = "\n", cor.coef.name = "R", p.accuracy = 0.01,
    r.accuracy = 0.01
  ),
  cor.coef.size = 5
) +
  xlab("Region-level SCZ vs CTL") + ylab("iPSC SCZ vs CTL") +
  scale_x_continuous(limits = c(-5, 5)) +
  scale_y_continuous(limits = c(-5, 5)) +
  theme_prism()

ggsave("scz_region_v_scz_ipsc_correlation.png", plot = p, path = "figures", width = 6, height = 6, units = "in")
ggsave("scz_region_v_scz_ipsc_correlation.svg", plot = p, path = "figures", width = 6, height = 6, units = "in")


p <- ggscatter(scz_ipsc_v_ad_ipsc,
  x = "ad_ipsc", y = "scz_ipsc",
  color = "black", shape = 19,
  add = "reg.line",
  cor.coef = TRUE,
  cor.coeff.args = list(
    method = "pearson",
    aes(label = paste(..r.label.., ..p.label.., sep = "~`,`~")),
    label.x = 0, label.y = 4,
    label.sep = "\n", cor.coef.name = "R", p.accuracy = 0.01,
    r.accuracy = 0.01
  ),
  cor.coef.size = 5
) +
  xlab("iPSC AD vs CTL") + ylab("iPSC SCZ vs CTL") +
  scale_x_continuous(limits = c(-5, 5)) +
  scale_y_continuous(limits = c(-5, 5)) +
  theme_prism()

ggsave("scz_ipsc_v_ad_ipsc_correlation.png", plot = p, path = "figures", width = 6, height = 6, units = "in")
ggsave("scz_ipsc_v_ad_ipsc_correlation.svg", plot = p, path = "figures", width = 6, height = 6, units = "in")


p <- ggscatter(scz_region_v_ad_ipsc,
  x = "scz_region", y = "ad_ipsc",
  color = "black", shape = 19,
  add = "reg.line",
  cor.coef = TRUE,
  cor.coeff.args = list(
    method = "pearson",
    aes(label = paste(..r.label.., ..p.label.., sep = "~`,`~")),
    label.x = 0, label.y = 4,
    label.sep = "\n", cor.coef.name = "R", p.accuracy = 0.01,
    r.accuracy = 0.01
  ),
  cor.coef.size = 5
) +
  xlab("Region-level SCZ vs CTL") + ylab("iPSC AD vs CTL") +
  scale_x_continuous(limits = c(-5, 5)) +
  scale_y_continuous(limits = c(-5, 5)) +
  theme_prism()

ggsave("scz_region_v_ad_ipsc_correlation.png", plot = p, path = "figures", width = 6, height = 6, units = "in")
ggsave("scz_region_v_ad_ipsc_correlation.svg", plot = p, path = "figures", width = 6, height = 6, units = "in")

