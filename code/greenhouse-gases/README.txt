Generate CMIP7 Lower Boundary Conditions (LBC)

This repository contains a Python routine to generate lower boundary condition (LBC) files for CMIP7 simulations (e.g., CESM/WACCM). It reads greenhouse gas concentrations from the official input4MIPs CMIP7 forcing dataset, interpolates them to the model latitude grid, converts to mol/mol, and writes a consolidated NetCDF file ready for use in CMIP7 runs.

UPDATE by slevis 2026/6/1: I have also included a matlab script for getting the co2 file to work as a datm stream when running CLM6 I-cases. Additional information at the top of the matlab script.

---

Overview

The script:

1. Reads time-dependent GHG concentration files for multiple species.
2. Converts units from ppm/ppb/ppt to mol/mol.
3. Interpolates from 12 prescribed latitudes to 360 model latitudes.
4. Combines all species into a single NetCDF file.
5. Appends metadata consistent with CESM LBC conventions.

---

Input Data

Base input path:
/glade/campaign/cesm/cesmdata/input4MIPs_raw/input4MIPs/CMIP7/CMIP/CR/CR-CMIP-1-0-0/atmos/mon/

Reference file (for lat/lon and metadata):
/glade/campaign/acom/acom-climate/dkin/inputs/lbc/LBC_17500116-2501216_CMIP6_0p5degLat_1998EESC_c211115.nc

Each species subdirectory contains a file such as:
{species}_input4MIPs_GHGConcentrations_CMIP_CR-CMIP-1-0-0_gnz_175001-202212.nc

---

Output

Output file:
/glade/u/home/jzhan166/scripts/LBC/clean/LBC_17500116-20221216_CMIP7_0p5degLat_OCSupdate_c250523.nc

Each species is written as a variable in the form: <SPC>_LBC(time, lat)

with units of mol/mol.

Global metadata includes creation date, data source, and script reference.

---

Usage

Run as a standalone script or Jupyter notebook:
python gen_LBC_CMIP7_clean_lat_10092025.ipynb

Or open it interactively:
jupyter notebook gen_LBC_CMIP7_clean_lat_10092025.ipynb

Ensure the base_path, reference_file, and output_file variables are updated to your local or campaign directory structure.

---

Species List

The script processes over 40 species, including:
CFC11, CFC12, CH4, CO2, N2O, HFCs, PFCs, SF6, NF3, Halons, etc.

---

Author

Jun Zhang
Atmospheric Chemistry Observations and Modeling (ACOM)
National Center for Atmospheric Research (NCAR)
Email: (jzhan166@ucar.edu)

---

