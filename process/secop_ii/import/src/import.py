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
                        default="~/genero_lab/data_orgn/secop_ii_electronico/SECOP_II_-_Contratos_Electrónicos_20261027.csv")
    parser.add_argument("--output_df",
                        default="~/genero_lab/process/secop_ii/import/output/secop_2.parquet")

    return parser.parse_args()

args = getargs()

logging.info("load data")
df = pl.read_csv(args.input_df)






