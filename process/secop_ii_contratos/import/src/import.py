#
# Authors: SCB
# Maintainers: SCB
# Copyright: 2026, GeneroLab
# ===============================
# /GeneroLab/process/import

# --- Config ---

import argparse
import polars as pl
import pyarrow.parquet as pq
import logging

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%H:%M:%S",
)

pl.Config.set_tbl_rows(20)

logging.info("define arguments")
def getargs():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input_df",
                        default="~/genero_lab/data_orgn/secop_ii_contratos/SECOP_II_-_Procesos_de_Contratación_20261112.csv")
    parser.add_argument("--output_df",
                        default="~/genero_lab/process/secop_ii_contratos/import/output/secop_ii_contratos.parquet")

    args, _ = parser.parse_known_args()
    return args

args = getargs()

logging.info("load data")
df = pl.read_csv(args.input_df, infer_schema=False)

logging.info("export")
df.write_parquet(args.output_df)

logging.info("done import.py")


