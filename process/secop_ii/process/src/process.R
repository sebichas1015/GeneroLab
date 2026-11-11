
options(scipen = 999)

require(pacman)
p_load(arrow, dplyr, janitor, assertr, logger, stringr, readr, lubridate)

log_info("load functions")
as_numeric_s = function(var_x) {
  n_na = sum(is.na(var_x))
  
  var_x = as.numeric(var_x)
  
  n_na_2 = sum(is.na(var_x))
  
  stopifnot(n_na == n_na_2)
  
  return(var_x)
}


as_year_s = function(var_x) {
  n_na = sum(is.na(var_x))
  
  var_x = as.integer(year(var_x))
  
  n_na_2 = sum(is.na(var_x))
  
  stopifnot(n_na == n_na_2)
  
  return(var_x)
}

path_df = "/Users/sebas/OneDrive/Documentos/genero_lab/repositorio/process/secop_ii/import/output/secop.parquet"

path_df_export = "/Users/sebas/OneDrive/Documentos/genero_lab/repositorio/process/secop_ii/process/output/secop.parquet"

df = read_parquet(path_df)

log_info("process")
df = df |> 
  clean_names()

log_info("clean value")
df = df |>
  mutate(
    valor_clean = str_remove_all(valor_del_contrato, "[\\$\\s]"),
    valor_clean = str_remove_all(valor_clean, "\\."),
    valor_clean = str_replace(valor_clean, ",", ".")
  ) |>
  mutate(valor_clean = as_numeric_s(valor_clean))

log_info("clean date")
df = df |> 
  mutate(fecha_de_inicio_contrato_clean = mdy_hms(fecha_de_inicio_del_contrato, tz = "America/Bogota")) |> 
  mutate(yy_inicio_contrato = as.integer(as_year_s(fecha_de_inicio_contrato_clean)))

df = df |> 
  mutate(yy_inicio_contrato = case_when(
    yy_inicio_contrato > 2027 | yy_inicio_contrato < 1990 ~ NA,
    TRUE ~ yy_inicio_contrato))

df = df |> 
  filter(!(tipo_doc_proveedor %in% c("NIT", "No Definido", "Otro")))

log_info("export")
write_parquet(df, path_df_export)

log_info("done process.R")
