
require(pacman)

p_load(readr, dplyr, assertr, logger, arrow)

path_import = "/Users/sebas/OneDrive/Documentos/genero_lab/repositorio/data_orgn/secop_ii_electronico/SECOP_II_-_Contratos_Electrónicos_20261027.csv"

path_export = "/Users/sebas/OneDrive/Documentos/genero_lab/repositorio/process/secop_ii/import/output/secop.parquet"

df = read_csv(path_import)

write_parquet(df, path_export)
