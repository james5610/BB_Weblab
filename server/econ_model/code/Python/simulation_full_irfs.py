# -*- coding: utf-8 -*-
"""
Created on Thu Jan 23 14:52:46 2025

@author: james
"""

# Created by James Lee and Athiana Tettaravou
# Runs each simulation seperately
# Coefficients from Stata .do files


# Note: sometimes the program fails to run because the "PNG library
# failed". If this is the case, try running the program again. This error
# occasionally occurs.

# In general:
# -variable names with no suffixes represent historical data, or in this
# case, an array of zeros
# -variable names ending in _simul represent simulated values. These are the series that represent each variabless response to a shock.
# -variable names ending in _shock represent series with one time shock
# values. Note that if these variables for some reason do not immediately
# return to zero that modificaiton of this variable may be needed
# variable names ending in _shock_series represent the time series of
# exogenous shocks. 
'''
Notes to self:
Note that in future iterations, it would be nice to have these become sliders with dynamic values
You can also change rho and shock values in website settings.
'''


import pandas as pd
import numpy as np
import os
import matplotlib.pyplot as plt
import sys
from datetime import datetime

if __name__ == "__main__":
    
    base_dir = os.getcwd()
    
    ## Get coefficients
    if base_dir == "C:\\Users\\james\\Dropbox\\Code_Dropbox\\Weblab\\Bernanke_Blanchard_Weblab\\server\\econ_model\\code\\Python":
        coefficients_path = os.path.join(base_dir, "../../data/intermediate_data") # used when running standalone
    else:
        coefficients_path = os.path.join(base_dir, "server/econ_model/data/intermediate_data") # used when running on website

    gw_beta = pd.read_excel(os.path.join(
        coefficients_path, "eq_coefficients.xlsx"), sheet_name="gw", index_col=0).beta
    gcpi_beta = pd.read_excel(os.path.join(
        coefficients_path, "eq_coefficients.xlsx"), sheet_name="gcpi", index_col=0).beta
    cf1_beta = pd.read_excel(os.path.join(
        coefficients_path, "eq_coefficients.xlsx"), sheet_name="cf1", index_col=0).beta
    cf10_beta = pd.read_excel(os.path.join(
        coefficients_path, "eq_coefficients.xlsx"), sheet_name="cf10", index_col=0).beta
    
    # Options for running model. 
    try: 
        add_grpe_shock = sys.argv[1]
        add_grpf_shock = sys.argv[2]
        add_vu_shock = sys.argv[3]
        add_shortage_shock = sys.argv[4]
        add_gw_shock = False
        add_gcpi_shock = False
        add_cf1_shock = False
        add_cf10_shock = False
    except Exception as e:
        print("Error in importing sys.argv:", e)
        
        
    # Convert String arguments to Booleans
    string_to_bool = {
        "true": True,
        "false": False,
        True: True,
        False: False
    }
    
    # Convert Parameters to Bools
    try:
        add_grpe_shock = string_to_bool.get(add_grpe_shock)
        add_grpf_shock = string_to_bool.get(add_grpf_shock)
        add_vu_shock = string_to_bool.get(add_vu_shock)
        add_shortage_shock = string_to_bool.get(add_shortage_shock)
    except Exception as e:
        print(f"Input parameter not properly formatted. Error: {e}")
        sys.exit(1)
            
    # Import data
    # All data is initialized to zero to reflect that they are in steady state
    data = pd.read_excel(os.path.join(coefficients_path, "eq_simulations_data.xls"))
    table_q4_data = data[data["period"] >= datetime(2020,1,1)]
    data = data[data["period"] >= datetime(2018, 10, 1)]
    
    
    
    
    timesteps = 32
    period = data["period"].values
    gw = np.zeros(timesteps)
    cf1 = np.zeros(timesteps)
    magpty = np.zeros(timesteps)
    diffcpicf = np.zeros(timesteps)
    vu = np.zeros(timesteps)
    dummygw = np.zeros(timesteps)
    gcpi = np.zeros(timesteps)
    grpe = np.zeros(timesteps)
    grpf = np.zeros(timesteps)
    shortage = np.zeros(timesteps)
    cf10 = np.zeros(timesteps)
    
    gw_residuals = data["gw_residuals"].values
    gcpi_residuals = data['gcpi_residuals'].values
    cf1_residuals = data['cf1_residuals'].values
    cf10_residuals = data['cf10_residuals'].values
   
    # Since we need 4 values before we can run the simulation (because we have
    # 4 lags), we need to initialize the first 4 values of cf1_simul to the
    # actual data
    gw_simul = gw[0:4]
    gcpi_simul = gcpi[0:4]
    cf1_simul = cf1[0:4]
    cf10_simul = cf10[0:4]
    
    # Initialize diffcpicf (we simulate this as well since gcpi and cf1 are
    # endogenous)
    diffcpicf_simul = diffcpicf[1:4]

    # Also define 4 lags for exogenous variables
    grpe_shock_series = grpe[1:4]
    grpf_shock_series = grpf[1:4]
    vu_shock_series = vu[1:4]
    shortage_shock_series = shortage[1:4]
    

    
       
    # Initialize shocks and how fast they return to steady state. Rho denotes
    # how fast they return (0 indicates a 1-period shock, 1 denotes a
    # persistent shock)
    shock_grpe = np.zeros(4)
    shock_grpf = np.zeros(4)
    shock_vu = np.zeros(4)
    shock_shortage = np.zeros(4)
    shock_gw = np.zeros(4)
    shock_gcpi = np.zeros(4)
    shock_cf1 = np.zeros(4)
    shock_cf10 = np.zeros(4)
       
    rho_grpe = 0.0
    rho_grpf = 0.0
    rho_vu = 1.0
    rho_shortage = 0.0
    rho_gw = 0.0
    rho_gcpi = 0.0
    rho_cf1 = 0.0
    rho_cf10 = 0.0
    
    # We'll resize the variables here so that they have as many elements as timestep.
    # Since this isn't MATLAB, we have to declare array size first
    gw_simul = np.resize(gw_simul, timesteps)
    gcpi_simul = np.resize(gcpi_simul, timesteps)
    cf1_simul = np.resize(cf1_simul, timesteps)
    cf10_simul = np.resize(cf10_simul, timesteps)
    diffcpicf_simul = np.resize(diffcpicf_simul, timesteps)
    grpe_shock_series = np.resize(grpe_shock_series, timesteps)
    grpf_shock_series = np.resize(grpf_shock_series, timesteps)
    vu_shock_series = np.resize(vu_shock_series, timesteps)
    shortage_shock_series = np.resize(shortage_shock_series, timesteps)
    shock_grpe = np.resize(shock_grpe, timesteps)
    shock_grpf = np.resize(shock_grpf, timesteps)
    shock_vu = np.resize(shock_vu, timesteps)
    shock_shortage = np.resize(shock_shortage, timesteps)
    shock_gw = np.resize(shock_gw, timesteps)
    shock_gcpi = np.resize(shock_gcpi, timesteps)
    shock_cf1 = np.resize(shock_cf1, timesteps)
    shock_cf10 = np.resize(shock_cf10, timesteps)
       
    # Initialize shock value
    shock_val_grpe = np.nanstd(table_q4_data.grpe)
    shock_val_grpf = np.nanstd(table_q4_data.grpf)
    shock_val_vu = np.nanstd(table_q4_data.vu)
    shock_val_shortage = np.nanstd(table_q4_data.shortage)
    shock_val_gw_residual = np.nanstd(table_q4_data.gw_residuals)
    shock_val_gcpi_residual = np.nanstd(table_q4_data.gcpi_residuals)
    shock_val_cf1_residual = np.nanstd(table_q4_data.cf1_residuals)
    shock_val_cf10_residual = np.nanstd(table_q4_data.cf10_residuals)
       
    # Run simulation
    for t in range(4, timesteps):
        # Equation adding shocks. It equals zero unless the specified
        # conditions are met.
        
        shock_grpe[t] = 0
        shock_grpf[t] = 0
        shock_vu[t] = 0
        shock_shortage[t] = 0
        shock_gw[t] = 0
        shock_gcpi[t] = 0
        shock_cf1[t] = 0
        shock_cf10[t] = 0
       
        if add_grpe_shock and t == 4: # one time increase to rate, i.e. permanent incrase in level
            shock_grpe[t] = shock_val_grpe
    
        if add_grpf_shock and t == 4: # one time increase to rate, i.e. permanent incrase in level
            shock_grpf[t] = shock_val_grpf
    
        if add_vu_shock and t == 4: # permanent increase in level (due to rho)
            shock_vu[t] = shock_val_vu
    
        if add_shortage_shock and t == 4: # one time increase
            shock_shortage[t] = shock_val_shortage
    
        if add_gw_shock and t == 4: # one time increase
            shock_gw[t] = shock_val_gw_residual
    
        if add_gcpi_shock and t == 4: # one time increase
            shock_gcpi[t] = shock_val_gcpi_residual
    
        if add_cf1_shock and t == 4: # one time increase
            shock_cf1[t] = shock_val_cf1_residual
    
        if add_cf10_shock and t == 4: # one time increase
            shock_cf10[t] = shock_val_cf10_residual
       
        grpe_shock_series[t] = rho_grpe*grpe_shock_series[t-1] + shock_grpe[t]
        grpf_shock_series[t] = rho_grpf*grpf_shock_series[t-1] + shock_grpf[t]
        vu_shock_series[t] = rho_vu*vu_shock_series[t-1] + shock_vu[t]
        shortage_shock_series[t] = rho_shortage*shortage_shock_series[t-1] + shock_shortage[t]
       
        # Equations
    
        if add_gw_shock and t == 4:
            gw_simul[t] = rho_gw*gw_simul[t-1] + shock_gw[t]
        else:
            gw_simul[t] = np.dot(gw_beta.values[0:17], [            
                gw_simul[t-1], gw_simul[t-2],
                gw_simul[t-3], gw_simul[t-4],
                cf1_simul[t-1], cf1_simul[t-2],
                cf1_simul[t-3], cf1_simul[t-4],
                magpty[t-1], vu_shock_series[t-1], vu_shock_series[t-2],
                vu_shock_series[t-3], vu_shock_series[t-4],
                diffcpicf_simul[t-1], diffcpicf_simul[t-2],
                diffcpicf_simul[t-3],
                diffcpicf_simul[t-4]])


        if add_gcpi_shock and t == 4:
            gcpi_simul[t] = rho_gcpi*gcpi_simul[t-1] + shock_gcpi[t]
        else:
            gcpi_simul[t] =  np.dot(gcpi_beta.values[0:25], [magpty[t],
            gcpi_simul[t-1], gcpi_simul[t-2],
            gcpi_simul[t-3], gcpi_simul[t-4],
            gw_simul[t], gw_simul[t-1],
            gw_simul[t-2],
            gw_simul[t-3], gw_simul[t-4],
            grpe_shock_series[t], grpe_shock_series[t-1],
            grpe_shock_series[t-2], grpe_shock_series[t-3], grpe_shock_series[t-4],
            grpf_shock_series[t], grpf_shock_series[t-1], grpf_shock_series[t-2],
            grpf_shock_series[t-3], grpf_shock_series[t-4],
            shortage_shock_series[t], shortage_shock_series[t-1],
            shortage_shock_series[t-2], shortage_shock_series[t-3],
            shortage_shock_series[t-4]])

        diffcpicf_simul[t] = 0.25*(gcpi_simul[t] + gcpi_simul[t-1] +
            gcpi_simul[t-2] + gcpi_simul[t-3]) - cf1_simul[t-4]
    
        if add_cf10_shock and t == 4:
            cf10_simul[t] = rho_cf10*cf10_simul[t-1] + shock_cf10[t]
        else:
            cf10_simul[t] = np.dot(cf10_beta.values,[cf10_simul[t-1],
            cf10_simul[t-2],
            cf10_simul[t-3], cf10_simul[t-4],
            gcpi_simul[t], gcpi_simul[t-1],
            gcpi_simul[t-2],
            gcpi_simul[t-3], gcpi_simul[t-4]])
 
        
        if add_cf1_shock and t == 4:
            cf1_simul[t] = rho_cf1*cf1_simul[t-1] + shock_cf1[t]
        else:
            cf1_simul[t] = np.dot(cf1_beta.values, [cf1_simul[t-1],
            cf1_simul[t-2],
            cf1_simul[t-3], cf1_simul[t-4],
            cf10_simul[t], cf10_simul[t-1],
            cf10_simul[t-2],
            cf10_simul[t-3], cf10_simul[t-4],
            gcpi_simul[t], gcpi_simul[t-1],
            gcpi_simul[t-2],
            gcpi_simul[t-3], gcpi_simul[t-4]])
            
    # ********************* Export Data *************************************
    
    # Make period consistent for exporting
    month_to_quarter = {
        "1": 1,
        "4": 2,
        "7": 3,
        "10": 4}
    quarter = month_to_quarter[str(period[0].astype('datetime64[M]').astype(int) % 12 + 1)] # First quarter
    year = period[0].astype('datetime64[Y]').astype(int) +1970 #First year
    new_period = np.array([])
    
    for step in range(timesteps):
        lbl = f"Q{quarter} {year}$"
        new_period = np.append(new_period, lbl)
        if quarter == 4:
            quarter = 1
            year += 1
        else:
            quarter += 1
    
    # Save data to Excel
    results_df = pd.DataFrame({
        "Period": new_period,
        "gw_simul": gw_simul,
        "gcpi_simul": gcpi_simul,
        "cf1_simul": cf1_simul,
        "cf10_simul": cf10_simul,
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
            base_dir, "server/econ_model/data/output_data/simulation_full_irfs_weblab.xlsx")
    results_df.to_excel(output_path, index=False)

    print("Simulation complete!")
    print(list(results_df.values))
