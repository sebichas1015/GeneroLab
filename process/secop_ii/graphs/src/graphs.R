
options(scipen = 999)

require(pacman)
p_load(arrow, dplyr, ggplot2, stringr, logger)

log_info("load functions")

plot_one = function(df, string_x) {
  
  df_X = df |> 
    filter(variable == string_x) |>
    ggplot(aes(x = genero_representante_legal, y = val)) +
    geom_col() +
    theme_minimal()
  
}

log_info("load data")
path_df = "/Users/sebas/OneDrive/Documentos/genero_lab/repositorio/process/secop_ii/stats/output/"

paths_all = list.files(path_df, full.names = TRUE)

for (i in paths_all) {
  
  names_obj = str_remove_all(i, path_df)
  
  names_obj = str_remove_all(names_obj, ".parquet")
  
  print(names_obj)
  
  df = read_parquet(i)
  
  assign(x = names_obj, value = df, envir = .GlobalEnv)
  
}

log_info("plot graphs")
n_contr = plot_one(exprt_gen, "total_n_dist_contratos")

plot(n_contr)

total_val = plot_one(exprt_gen, "total_value")

plot(total_val)

prom_val = plot_one(exprt_gen, "total_prom_value")

plot(prom_val)


