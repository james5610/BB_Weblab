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

    
    
    # add_residuals = sys.argv[1]
    # remove_grpe = sys.argv[2]
    # remove_grpf = sys.argv[3]
    # remove_vu = sys.argv[4]
    # remove_shortage = sys.argv[5]
    # update_graphs = sys.argv[6]
    
    base_dir = os.getcwd()
    
    # #Options
    add_residuals = False
    remove_grpe = False
    remove_grpf = False
    remove_vu = False
    remove_shortage = False
    update_graphs = False
    
    # Load coefficients
    # First if block occurs when script is run by itself
    # Second runs if script is run off the webpage
    if base_dir == "C:\\Users\\james\\Dropbox\\Code_Dropbox\\Weblab\\Bernanke_Blanchard_Weblab\\server\\econ_model\\code\\Python":
        coefficients_path = os.path.join(base_dir, "../../data/intermediate_data") # used when running standalone
    else:
        coefficients_path = os.path.join(base_dir, "server/econ_model/data/intermediate_data") # used when running on website
    
    data = pd.read_excel(os.path.join(coefficients_path, "eq_simulations_data.xls"))
    gw_beta = pd.read_excel(os.path.join(coefficients_path, "eq_coefficients.xlsx"), sheet_name="gw", index_col = 0).beta
    gcpi_beta = pd.read_excel(os.path.join(coefficients_path, "eq_coefficients.xlsx"), sheet_name="gcpi", index_col = 0).beta
    cf1_beta = pd.read_excel(os.path.join(coefficients_path, "eq_coefficients.xlsx"), sheet_name="cf1", index_col = 0).beta
    cf10_beta = pd.read_excel(os.path.join(coefficients_path, "eq_coefficients.xlsx"), sheet_name="cf10", index_col = 0).beta
    
    
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
    
    # Initialize simulation variables
    gw_simul = gw[:4].tolist()
    gcpi_simul = gcpi[:4].tolist()
    cf1_simul = cf1[:4].tolist()
    cf10_simul = cf10[:4].tolist()
    diffcpicf_simul = diffcpicf[:4].tolist()
    
    grpe_simul = grpe.copy()
    grpf_simul = grpf.copy()
    vu_simul = vu.copy()
    shortage_simul = shortage.copy()
    
    #  Initialize cell array of shocks added
    shocks_removed = []
    if remove_grpe:
        shocks_removed.append("grpe")
    if remove_grpf:
        shocks_removed.append("grpf")
    if remove_vu:
        shocks_removed.append("vu")
    if remove_shortage:
        shocks_removed.append("shortage")
    
    # Equation loop
    for t in range(4, timesteps):
        # Compute shocks for this timestep
        grpe_shock = grpe[t] if "grpe" not in shocks_removed else 0
        grpf_shock = grpf[t] if "grpf" not in shocks_removed else 0
        vu_shock = vu[t] if "vu" not in shocks_removed else 0
        shortage_shock = shortage[t] if "shortage" not in shocks_removed else 0
    
        # Compute gw equation
        gw_t = (np.dot(gw_beta.values, [
            gw_simul[t-1], gw_simul[t-2], gw_simul[t-3], gw_simul[t-4],
            cf1_simul[t-1], cf1_simul[t-2], cf1_simul[t-3], cf1_simul[t-4],
            magpty[t-1],
            vu_simul[t-1], vu_simul[t-2], vu_simul[t-3], vu_simul[t-4],
            diffcpicf_simul[t-1], diffcpicf_simul[t-2], diffcpicf_simul[t-3], diffcpicf_simul[t-4],
            1]) + (gw_residuals[t] if add_residuals else 0))
        gw_simul.append(gw_t)
    
        # Compute gcpi equation
        gcpi_t = np.dot(gcpi_beta.values, [
            magpty[t],
            gcpi_simul[t-1], gcpi_simul[t-2], gcpi_simul[t-3], gcpi_simul[t-4],
            gw_simul[t], gw_simul[t-1], gw_simul[t-2], gw_simul[t-3], gw_simul[t-4],
            grpe_simul[t], grpe_simul[t-1], grpe_simul[t-2], grpe_simul[t-3], grpe_simul[t-4],
            grpf_simul[t], grpf_simul[t-1], grpf_simul[t-2], grpf_simul[t-3], grpf_simul[t-4],
            shortage_simul[t], shortage_simul[t-1], shortage_simul[t-2], shortage_simul[t-3], shortage_simul[t-4],
            1]) + (gcpi_residuals[t] if add_residuals else 0)
        gcpi_simul.append(gcpi_t)
        
        # Compute diffcpicf equation
        diffcpicf_simul_t = 0.25*(gcpi_simul[t] + gcpi_simul[t-1] + gcpi_simul[t-2] + gcpi_simul[t-3])-cf1_simul[t-4]
        diffcpicf_simul.append(diffcpicf_simul_t)
        
        # Compute cf10 equation
        cf10_t = np.dot(cf10_beta.values, [
            cf10[t-1], cf10[t-2], cf10[t-3], cf10[t-4],
            gcpi_simul[t], gcpi_simul[t-1], gcpi_simul[t-2], gcpi_simul[t-3], gcpi_simul[t-4]
            ]) + (cf10_residuals[t] if add_residuals else 0)
        cf10_simul.append(cf10_t)
        
        # Compute cf1 equation
        cf1_t = np.dot(cf1_beta.values, [
            cf1_simul[t-1], cf1_simul[t-2], cf1_simul[t-3], cf1_simul[t-4],
            cf10[t], cf10[t-1], cf10[t-2], cf10[t-3], cf10[t-4],
            gcpi_simul[t], gcpi_simul[t-1], gcpi_simul[t-2], gcpi_simul[t-3], gcpi_simul[t-4],
        ]) + (cf1_residuals[t] if add_residuals else 0)
        cf1_simul.append(cf1_t)
    
    # Plot the results if update_graphs is True
    if update_graphs:
        plt.figure(figsize=(10, 6))
        
        # GW Simulation
        plt.plot(period, gw, label="Actual GW")
        plt.plot(period[4:], gw_simul[4:], label="Simulated GW", linestyle="--")
        plt.title("GW Simulation")
        plt.xlabel("Time Period")
        plt.ylabel("GW")
        plt.legend()
        plt.show()
        
        # GCPI Simulation
        plt.figure(figsize=(10, 6))
        plt.plot(period, gcpi, label="Actual GCPI")
        plt.plot(period[4:], gcpi_simul[4:], label="Simulated GCPI", linestyle="--")
        plt.title("GCPI Simulation")
        plt.xlabel("Time Period")
        plt.ylabel("GCPI")
        plt.legend()
        plt.show()
        
        # CF1 Simulation
        plt.figure(figsize=(10, 6))
        plt.plot(period, cf1, label="Actual CF1")
        plt.plot(period[4:], cf1_simul[4:], label="Simulated CF1", linestyle="--")
        plt.title("CF1 Simulation")
        plt.xlabel("Time Period")
        plt.ylabel("CF1")
        plt.legend()
        plt.show()
    
        # CF10 Simulation
        plt.figure(figsize=(10, 6))
        plt.plot(period, cf10, label="Actual CF10")
        plt.plot(period[4:], cf10_simul[4:], label="Simulated CF10", linestyle="--")
        plt.title("CF10 Simulation")
        plt.xlabel("Time Period")
        plt.ylabel("CF10")
        plt.legend()
        plt.show()
    
    # Convert results into format to be used in webpage
    dates = list(data["period"])
    grpe_simul = list(grpe_simul)
    gw_simul = list(gw_simul)
    gcpi_simul = list(gcpi_simul)
    diffcpicf_simul = list(diffcpicf_simul)
    cf10_simul = list(cf10_simul)
    cf1_simul = list(cf1_simul)

    results = [dates, grpe_simul, gw_simul, gcpi_simul, diffcpicf_simul, cf10_simul, cf1_simul]
    
    # Save data to Excel
    results_df = pd.DataFrame({
        "Dates": dates,
        "grpe_simul": grpe_simul,
        "gw_simul": gw_simul,
        "gcpi_simul": gcpi_simul,
        "diffcpicf_simul": diffcpicf_simul,
        "cf10_simul": cf10_simul,
        "cf1_simul": cf1_simul
        })
    
    # Export Data
    # First if block occurs when script is run by itself
    # Second runs if script is run off the webpage
    if base_dir == "C:\\Users\\james\\Dropbox\\Code_Dropbox\\Weblab\\Bernanke_Blanchard_Weblab\\server\\econ_model\\code\\Python":
        output_path = os.path.join(base_dir, "../../data/output_data/dynamic_simul_results_weblab.xlsx") # used when running standalone
    else:
        output_path = os.path.join(base_dir, "server/econ_model/data/output_data/dynamic_simul_results_weblab.xlsx") # used when running on website
    results_df.to_excel(output_path, index = False)
    
    print("Simulation complete!")
    print(results)
    
    
    