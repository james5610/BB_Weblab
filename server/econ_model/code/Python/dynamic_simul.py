# -*- coding: utf-8 -*-
"""
Created on Wed Jan 15 20:50:06 2025

@author: james
"""
import pandas as pd
import numpy as np
import os
import matplotlib.pyplot as plt
import sys

if __name__ == "__main__":

    # Import Data
    try:
        add_residuals = sys.argv[1]
        remove_grpe = sys.argv[2]
        remove_grpf = sys.argv[3]
        remove_vu = sys.argv[4]
        remove_shortage = sys.argv[5]
    except Exception as e:
        print("Error in importing sys.argv:", e)
    
    # add_residuals = 'false'
    # remove_grpe = 'false'
    # remove_grpf = 'false'
    # remove_vu = 'false'
    # remove_shortage = 'false'

    # Convert String arguments to Booleans
    string_to_bool = {
        "true": True,
        "false": False,
        True: True,
        False: False
    }
    
    # Convert Parameters to Bools
    try:
        add_residuals = string_to_bool.get(add_residuals)
        remove_grpe = string_to_bool.get(remove_grpe)
        remove_grpf = string_to_bool.get(remove_grpf)
        remove_vu = string_to_bool.get(remove_vu)
        remove_shortage = string_to_bool.get(remove_shortage)
    except Exception as e:
        print(f"Input parameter not properly formatted. Error: {e}")
        sys.exit(1)

    base_dir = os.getcwd()

    # Load coefficients
    # First if block occurs when script is run by itself
    # Second runs if script is run off the webpage
    if base_dir == "C:\\Users\\james\\Dropbox\\Code_Dropbox\\Weblab\\Bernanke_Blanchard_Weblab\\server\\econ_model\\code\\Python":
        # used when running standalone
        coefficients_path = os.path.join(
            base_dir, "../../data/intermediate_data")
    else:
        coefficients_path = os.path.join(
            # used when running on website
            base_dir, "server/econ_model/data/intermediate_data")

    data = pd.read_excel(os.path.join(
        coefficients_path, "eq_simulations_data.xls"))
    gw_beta = pd.read_excel(os.path.join(
        coefficients_path, "eq_coefficients.xlsx"), sheet_name="gw", index_col=0).beta
    gcpi_beta = pd.read_excel(os.path.join(
        coefficients_path, "eq_coefficients.xlsx"), sheet_name="gcpi", index_col=0).beta
    cf1_beta = pd.read_excel(os.path.join(
        coefficients_path, "eq_coefficients.xlsx"), sheet_name="cf1", index_col=0).beta
    cf10_beta = pd.read_excel(os.path.join(
        coefficients_path, "eq_coefficients.xlsx"), sheet_name="cf10", index_col=0).beta

    # Filter data from a specific date
    data = data[data["period"] >= pd.Timestamp(2018, 10, 1)]
    timesteps = len(data)
    period = data["period"].values

    # Extract historical data
    gw = data["gw"].values
    gcpi = data["gcpi"].values
    cf1 = data["cf1"].values
    cf10 = data["cf10"].values
    diffcpicf = data["diffcpicf"].values

    gw_residuals = data["gw_residuals"].values
    gcpi_residuals = data["gcpi_residuals"].values
    cf1_residuals = data["cf1_residuals"].values
    cf10_residuals = data["cf10_residuals"].values

    grpe = data["grpe"].values
    grpf = data["grpf"].values
    vu = data["vu"].values
    shortage = data["shortage"].values
    magpty = data["magpty"].values

    # Initialize endogenous simulation variables
    gw_simul = gw[:4].tolist()
    gcpi_simul = gcpi[:4].tolist()
    cf1_simul = cf1[:4].tolist()
    cf10_simul = cf10[:4].tolist()
    diffcpicf_simul = diffcpicf[:4].tolist()
    
    # Initialize exogenous simulation variables
    grpe_simul = grpe.copy()
    grpf_simul = grpf.copy()
    vu_simul = vu.copy()
    shortage_simul = shortage.copy()

    #  Initialize list of shocks added
    shocks_removed = []
    if remove_grpe:
        shocks_removed.append("grpe")
    if remove_grpf:
        shocks_removed.append("grpf")
    if remove_vu:
        shocks_removed.append("vu")
    if remove_shortage:
        shocks_removed.append("shortage")

    # Run simulation with exogenous variables removed
    for t in range(4, timesteps):
        # Modify exogenous variables based on whether they are removed
        grpe_shock = grpe[t] if "grpe" not in shocks_removed else 0
        grpf_shock = grpf[t] if "grpf" not in shocks_removed else 0
        vu_shock = vu[t] if "vu" not in shocks_removed else vu[4]
        shortage_shock = shortage[t] if "shortage" not in shocks_removed else 5

        # Compute gw equation
        gw_simul_t = (np.dot(gw_beta.values, [
            gw_simul[t-1], gw_simul[t-2], gw_simul[t-3], gw_simul[t-4],
            cf1_simul[t-1], cf1_simul[t-2], cf1_simul[t-3], cf1_simul[t-4],
            magpty[t-1],
            vu_simul[t-1], vu_simul[t-2], vu_simul[t-3], vu_simul[t-4],
            diffcpicf_simul[t-1], diffcpicf_simul[t -
                2], diffcpicf_simul[t-3], diffcpicf_simul[t-4],
            1]) + (gw_residuals[t] if add_residuals else 0))
        gw_simul.append(gw_simul_t)

        # Compute gcpi equation
        gcpi_simul_t = np.dot(gcpi_beta.values, [
            magpty[t],
            gcpi_simul[t-1], gcpi_simul[t-2], gcpi_simul[t-3], gcpi_simul[t-4],
            gw_simul[t], gw_simul[t-1], gw_simul[t -
                                                 2], gw_simul[t-3], gw_simul[t-4],
            grpe_simul[t], grpe_simul[t-1], grpe_simul[t -
                                                       2], grpe_simul[t-3], grpe_simul[t-4],
            grpf_simul[t], grpf_simul[t-1], grpf_simul[t -
                                                       2], grpf_simul[t-3], grpf_simul[t-4],
            shortage_simul[t], shortage_simul[t-1], shortage_simul[t -
                                                                   2], shortage_simul[t-3], shortage_simul[t-4],
            1]) + (gcpi_residuals[t] if add_residuals else 0)
        gcpi_simul.append(gcpi_simul_t)

        # Compute diffcpicf equation
        diffcpicf_simul_t = 0.25 * \
            (gcpi_simul[t] + gcpi_simul[t-1] +
             gcpi_simul[t-2] + gcpi_simul[t-3])-cf1_simul[t-4]
        diffcpicf_simul.append(diffcpicf_simul_t)

        # Compute cf10 equation
        cf10_simul_t = np.dot(cf10_beta.values, [
            cf10_simul[t-1], cf10_simul[t-2], cf10_simul[t-3], cf10_simul[t-4],
            gcpi_simul[t], gcpi_simul[t-1], gcpi_simul[t-2], gcpi_simul[t-3], gcpi_simul[t-4]
        ]) + (cf10_residuals[t] if add_residuals else 0)
        cf10_simul.append(cf10_simul_t)

        # Compute cf1 equation
        cf1_simul_t = np.dot(cf1_beta.values, [
            cf1_simul[t-1], cf1_simul[t-2], cf1_simul[t-3], cf1_simul[t-4],
            cf10_simul[t], cf10_simul[t-1], cf10_simul[t-2], cf10_simul[t-3], cf10_simul[t-4],
            gcpi_simul[t], gcpi_simul[t-1], gcpi_simul[t-2], gcpi_simul[t-3], gcpi_simul[t-4],
        ]) + (cf1_residuals[t] if add_residuals else 0)
        cf1_simul.append(cf1_simul_t)
        
        
    # *************** Run simulation with all exogenous variables included (as original historical values) *****************
    # Initialize endogenous simulation variables
    gw_simul_orig = gw[:4].tolist()
    gcpi_simul_orig = gcpi[:4].tolist()
    cf1_simul_orig = cf1[:4].tolist()
    cf10_simul_orig = cf10[:4].tolist()
    diffcpicf_simul_orig = diffcpicf[:4].tolist()
    
    for t in range(4, timesteps):
        # Compute gw equation
        gw_simul_orig_t = (np.dot(gw_beta.values, [
            gw_simul_orig[t-1], gw_simul_orig[t-2], gw_simul_orig[t-3], gw_simul_orig[t-4],
            cf1_simul_orig[t-1], cf1_simul_orig[t-2], cf1_simul_orig[t-3], cf1_simul_orig[t-4],
            magpty[t-1],
            vu[t-1], vu[t-2], vu[t-3], vu[t-4],
            diffcpicf_simul_orig[t-1], diffcpicf_simul_orig[t-2], 
            diffcpicf_simul_orig[t-3], diffcpicf_simul_orig[t-4],
            1]) + (gw_residuals[t] if add_residuals else 0))
        gw_simul_orig.append(gw_simul_orig_t)

        # Compute gcpi equation
        gcpi_simul_orig_t = np.dot(gcpi_beta.values, [
            magpty[t],
            gcpi_simul_orig[t-1], gcpi_simul_orig[t-2], gcpi_simul_orig[t-3], gcpi_simul_orig[t-4],
            gw_simul_orig[t], gw_simul_orig[t-1], gw_simul_orig[t-2], gw_simul_orig[t-3], gw_simul_orig[t-4],
            grpe[t], grpe[t-1], grpe[t-2], grpe[t-3], grpe[t-4],
            grpf[t], grpf[t-1], grpf[t-2], grpf[t-3], grpf[t-4],
            shortage[t], shortage[t-1], shortage[t-2], shortage[t-3], shortage[t-4],
            1]) + (gcpi_residuals[t] if add_residuals else 0)
        gcpi_simul_orig.append(gcpi_simul_orig_t)

        # Compute diffcpicf equation
        diffcpicf_simul_orig_t = 0.25 * \
            (gcpi_simul_orig[t] + gcpi_simul_orig[t-1] +
             gcpi_simul_orig[t-2] + gcpi_simul_orig[t-3])-cf1_simul_orig[t-4]
        diffcpicf_simul_orig.append(diffcpicf_simul_orig_t)

        # Compute cf10 equation
        cf10_simul_orig_t = np.dot(cf10_beta.values, [
            cf10_simul_orig[t-1], cf10_simul_orig[t-2], cf10_simul_orig[t-3], cf10_simul_orig[t-4],
            gcpi_simul_orig[t], gcpi_simul_orig[t-1], gcpi_simul_orig[t-2], gcpi_simul_orig[t-3], gcpi_simul_orig[t-4]
        ]) + (cf10_residuals[t] if add_residuals else 0)
        cf10_simul_orig.append(cf10_simul_orig_t)

        # Compute cf1 equation
        cf1_simul_orig_t = np.dot(cf1_beta.values, [
            cf1_simul_orig[t-1], cf1_simul_orig[t-2], cf1_simul_orig[t-3], cf1_simul_orig[t-4],
            cf10_simul_orig[t], cf10_simul_orig[t-1], cf10_simul_orig[t-2], cf10_simul_orig[t-3], cf10_simul_orig[t-4],
            gcpi_simul_orig[t], gcpi_simul_orig[t-1], gcpi_simul_orig[t-2], gcpi_simul_orig[t-3], gcpi_simul_orig[t-4],
        ]) + (cf1_residuals[t] if add_residuals else 0)
        cf1_simul_orig.append(cf1_simul_orig_t)
    
    
    
    
    # ************************* Calculate Contribution of Shocks *******************************
    contr_gw = [a-b for a, b in zip(gw_simul_orig, gw_simul)]
    contr_gcpi = [a-b for a, b in zip(gcpi_simul_orig, gcpi_simul)]
    contr_cf1 = [a-b for a, b in zip(cf1_simul_orig, cf1_simul)]
    contr_cf10 = [a-b for a, b in zip(cf10_simul_orig, cf10_simul)]
    
    # Convert results into format to be used in webpage
    dates = list(data["period"])
    grpe_simul = list(grpe_simul)
    gw_simul = list(gw_simul)
    gcpi_simul = list(gcpi_simul)
    diffcpicf_simul = list(diffcpicf_simul)
    cf10_simul = list(cf10_simul)
    cf1_simul = list(cf1_simul)


    # ********************* Export Data *************************************
    # Save data to Excel
    results_df = pd.DataFrame({
        "Dates": dates,
        "gw_simul": gw_simul,
        "gcpi_simul": gcpi_simul,
        "cf1_simul": cf1_simul,
        "cf10_simul": cf10_simul,
        "grpe_simul": grpe_simul,
        "grpf_simul": grpf_simul,
        "vu_simul": vu_simul,
        "shortage_simul": shortage_simul,
        "gw_simul_orig": gw_simul_orig,
        "gcpi_simul_orig": gcpi_simul_orig,
        "cf1_simul_orig": cf1_simul_orig,
        "cf10_simul_orig": cf10_simul_orig,
        "grpe_": grpe,
        "grpf": grpf,
        "vu": vu,
        "shortage": shortage,
        "contr_gw": contr_gw,
        "contr_gcpi": contr_gcpi,
        "contr_cf1": contr_cf1,
        "contr_cf10": contr_cf10
    })

    # Export Data
    # First if block occurs when script is run by itself
    # Second runs if script is run off the webpage
    if base_dir == "C:\\Users\\james\\Dropbox\\Code_Dropbox\\Weblab\\Bernanke_Blanchard_Weblab\\server\\econ_model\\code\\Python":
        # used when running standalone
        output_path = os.path.join(
            base_dir, "../../data/output_data/dynamic_simul_results_weblab.xlsx")
    else:
        # used when running on website
        output_path = os.path.join(
            base_dir, "server/econ_model/data/output_data/dynamic_simul_results_weblab.xlsx")
    results_df.to_excel(output_path, index=False)

    print("Simulation complete!")
    print(list(results_df))
    print([add_residuals, remove_grpe, remove_grpf,
          remove_vu, remove_shortage])

    
