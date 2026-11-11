
options(scipen = 999)

require(pacman)
p_load(arrow, dplyr, janitor, assertr, logger, stringr, readr, purrr)

log_info("load functions")
as_float_s = function(var_x) {
  n_na = sum(is.na(var_x))
  
  var_x = as.double(var_x)
  
  n_na_2 = sum(is.na(var_x))
  
  stopifnot(n_na == n_na_2)
  
  return(var_x)
}

path_df = "/Users/sebas/OneDrive/Documentos/genero_lab/repositorio/process/secop_ii/process/output/secop.parquet"

path_df_out = "/Users/sebas/OneDrive/Documentos/genero_lab/repositorio/process/secop_ii/stats/output/"

df = read_parquet(path_df)

log_info("counts general")
count_n_contr <- df |> 
  group_by(genero_representante_legal) |> 
  summarise(val = n_distinct(id_contrato, na.rm = TRUE)) |>
  ungroup() |> 
  mutate(variable = "total_n_dist_contratos")

count_value = df |> 
  group_by(genero_representante_legal) |> 
  summarise(val = sum(valor_clean)) |> 
  ungroup() |> 
  mutate(variable = "total_value")

count_prom_value <- df |> 
  group_by(genero_representante_legal) |> 
  mutate(n_recs = n()) |> 
  mutate(val = sum(valor_clean)/n_recs) |> 
  ungroup() |> 
  distinct(genero_representante_legal, val) |> 
  mutate(variable = "total_prom_value")

exprt_gen = count_n_contr %>% 
  bind_rows(count_value) %>%
  bind_rows(count_prom_value) %>%
  verify(ncol(.) == 3)

log_info("counts general yy")
count_yy_n_contr = df |> 
  group_by(genero_representante_legal, yy_inicio_contrato) |> 
  summarise(val = n_distinct(id_contrato, na.rm = TRUE)) |>
  ungroup() %>%
  mutate(variable = "total_n_dist_contratos_yy")

count_yy_value = df |> 
  group_by(genero_representante_legal, yy_inicio_contrato) |> 
  summarise(val = sum(valor_clean)) |> 
  ungroup() %>%
  mutate(variable = "total_value_yy")

count_yy_prom_value = df |> 
  group_by(genero_representante_legal, yy_inicio_contrato) |> 
  summarise(val = sum(valor_clean)) |> 
  ungroup() %>%
  mutate(variable = "total_prom_value_yy")

exprt_gen_yy = count_yy_n_contr %>% 
  bind_rows(count_yy_value) %>% 
  bind_rows(count_yy_prom_value) %>%
  verify(ncol(.) == 4)

log_info("export")
names_obj = ls()

obj_exprt = keep(names_obj, ~str_detect(.x, "exprt"))

for (i in obj_exprt) {
  names_out = paste0(i, ".parquet")
  
  paths_out = paste0(path_df_out, names_out)
  
  print(paths_out)
  
  print(i)
  
  write_parquet(get(i), paths_out)
}

