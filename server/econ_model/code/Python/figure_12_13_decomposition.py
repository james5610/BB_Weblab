#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May 11 15:28:01 2023

@author: James Lee
"""

import pandas as pd
from datetime import datetime
import matplotlib.pyplot as plt
import pickle
import os
import copy
import math

# Change Directory
base_dir = os.path.dirname(os.path.realpath(__file__))
os.chdir(base_dir)

# Import parameters
infile = open('universal_params', 'rb')
universal_params = pickle.load(infile)
infile.close

# Import data
decomp_results_dir = os.path.join("..","..","data","output_data")
os.chdir(decomp_results_dir)
data = {}
data["no_shocks_removed"] = pd.read_excel("all_data_decompositions.xls", sheet_name = "wo_residuals_no_shocks_removed")
data["all_shocks_removed"] = pd.read_excel("all_data_decompositions.xls", sheet_name = "wo_residuals_grpe_grpf_vu_shor")

data["grpe"] = pd.read_excel("all_data_decompositions.xls", sheet_name = "wo_residuals_grpe")
data["grpf"] = pd.read_excel("all_data_decompositions.xls", sheet_name = "wo_residuals_grpf")
data["vu"] = pd.read_excel("all_data_decompositions.xls", sheet_name = "wo_residuals_vu")
data["shortage"] = pd.read_excel("all_data_decompositions.xls", sheet_name = "wo_residuals_shortage")

# Keep if date <= Q4 2019
for shock in data.keys():
    data[shock] = data[shock][data[shock]["period"] >= datetime(2019,10,1)]

# Format x labels
for shock in data.keys():
    data[shock]["x_label"] = ["Q" + str(itm.quarter) + " " + str(itm.year) for itm in data[shock]["period"]]

# Graph
plt.rcParams['font.family'] = 'sans-serif'
# plt.rcParams['font.sans-serif'] = ['Calibri']


font_size = 14
plt.rcParams['font.size'] = font_size
font = font = {'family' : 'sans-serif',
        'weight' : 'normal',
        'size' : 14}
plt.rc('font', **font)
plt.rc('figure', titlesize = font_size)
plt.rc('axes', labelsize = font_size)
plt.rc('xtick', labelsize = font_size)
plt.rc('xtick', labelsize = font_size)
plt.rc('legend', fontsize = 12)
plt.rc('axes', titlesize = font_size)

to_graph = ["gw", "gcpi", "cf1", "cf10"]
figure_dict = {"gw": "figure_13", "gcpi": "figure_12", "cf1": "", "cf10": ""}

'''
baseline denotes the start of where we want to start the bars from. If bars
are negative, we start from the bottom. If bars are positive, we start from
the top.

Top denotes position of top of stacked bars; and bottom denotes the bottom
value of the stacked bars
'''

for itm in to_graph:
    fig, ax = plt.subplots(figsize = universal_params['standard_size_PPT'])
    top = [0 for itm in data["all_shocks_removed"]["period"]]
    bottom = [0 for itm in data["all_shocks_removed"]["period"]]
    baseline = [0 for itm in data["all_shocks_removed"]["period"]]
    
    # Plot initial conditions
    series = data["all_shocks_removed"][itm + "_simul"]
    for idx in range(len(series)):
        if series.iloc[idx] >= 0:
            baseline[idx] = top[idx]
        else:
            baseline[idx] = bottom[idx]
    ax.bar(data["all_shocks_removed"]["x_label"], series, 
        width = 0.4, color = [127/255.0, 127/255.0, 127/255.0], 
        bottom = baseline,label = "Initial conditions")
    temp = copy.deepcopy(top)
    for idx in range(len(series)):
        if series.iloc[idx] >= 0:
            top[idx] += series.iloc[idx]
            bottom[idx] += 0
        else:
            top[idx] += 0
            bottom[idx] += series.iloc[idx]
            
    # Plot contribution of vu
    series = data["vu"]["contr_" + itm]
    for idx in range(len(series)):
        if series.iloc[idx] >= 0:
            baseline[idx] = top[idx]
        else:
            baseline[idx] = bottom[idx]
    ax.bar(data["vu"]["x_label"], series, 
       width = 0.4, color = [192/255.0, 0/255.0, 0/255.0], 
       bottom = baseline,label = "v/u")
    temp = copy.deepcopy(top)
    for idx in range(len(series)):
        if series.iloc[idx] >= 0:
            top[idx] += series.iloc[idx]
            bottom[idx] += 0
        else:
            top[idx] += 0
            bottom[idx] += series.iloc[idx]

    # Plot contribution of grpe
    series = data["grpe"]["contr_" + itm]
    for idx in range(len(series)):
        if series.iloc[idx] >= 0:
            baseline[idx] = top[idx]
        else:
            baseline[idx] = bottom[idx]
    ax.bar(data["grpe"]["x_label"], series, 
        width = 0.4, color = [46/255.0, 117/255.0, 182/255.0], 
        bottom = baseline,label = "Energy Prices")
    temp = copy.deepcopy(top)
    for idx in range(len(series)):
        if series.iloc[idx] >= 0:
            top[idx] += series.iloc[idx]
            bottom[idx] += 0
        else:
            top[idx] += 0
            bottom[idx] += series.iloc[idx]
            
    # Plot contribution of grpf
    series = data["grpf"]["contr_" + itm]
    for idx in range(len(series)):
        if series.iloc[idx] >= 0:
            baseline[idx] = top[idx]
        else:
            baseline[idx] = bottom[idx]
    ax.bar(data["grpf"]["x_label"], series, 
       width = 0.4, color = [157/255.0, 195/255.0, 230/255.0], 
       bottom = baseline,label = "Food Prices")
    temp = copy.deepcopy(top)
    for idx in range(len(series)):
        if series.iloc[idx] >= 0:
            top[idx] += series.iloc[idx]
            bottom[idx] += 0
        else:
            top[idx] += 0
            bottom[idx] += series.iloc[idx]

    # Plot contribution of shortages
    series = data["shortage"]["contr_" + itm]
    for idx in range(len(series)):
        if series.iloc[idx] >= 0:
            baseline[idx] = top[idx]
        else:
            baseline[idx] = bottom[idx]
    ax.bar(data["shortage"]["x_label"], series, 
       width = 0.4, color = [255/255.0, 217/255.0, 102/255.0], 
       bottom = baseline,label = "Shortages")
    temp = copy.deepcopy(top)
    for idx in range(len(series)):
        if series.iloc[idx] >= 0:
            top[idx] += series.iloc[idx]
            bottom[idx] += 0
        else:
            top[idx] += 0
            bottom[idx] += series.iloc[idx]

    # Plot Actual Data Series
    if itm == "gw":
        ax.plot(data["no_shocks_removed"]["x_label"], data["no_shocks_removed"][itm], 
            lw = 3, color = [0/255.0, 0/255.0, 0/255.0], label = "Actual Wage Growth")
    elif itm == "gcpi":
        ax.plot(data["no_shocks_removed"]["x_label"], data["no_shocks_removed"][itm], 
            lw = 3, color = [0/255.0, 0/255.0, 0/255.0], label = "Actual Price Inflation")
    elif itm == "cf1":
        ax.plot(data["no_shocks_removed"]["x_label"], data["no_shocks_removed"][itm], 
            lw = 3, color = [0/255.0, 0/255.0, 0/255.0], label = "Actual 1-Year Expectations")
    elif itm == "cf10":
        ax.plot(data["no_shocks_removed"]["x_label"], data["no_shocks_removed"][itm], 
            lw = 3, color = [0/255.0, 0/255.0, 0/255.0], label = "Actual 10-Year Expectations")
            
    # Show every other x label
    xlabels = ax.get_xticklabels()
    for i, label in enumerate(xlabels):
        if i%2 == 0:
            label.set_visible(False)
    
    # Other formatting
    ax.set_ylim(ax.get_ylim()[0], math.ceil(ax.get_ylim()[1]))
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.xaxis.grid(True, which = 'minor')
    ax.set_axisbelow(True) # puts grid lines in the back
    ax.set_ylabel("Percent")
    
    if itm == "gw":
        legend = plt.legend(frameon = True, labelspacing = 0.1, 
           bbox_to_anchor=(0.01, 0.6, 0.5, 0.5), loc = 'upper left')
        frame = legend.get_frame()
        frame.set_edgecolor("black")
    elif itm == "gcpi":
        legend = plt.legend(frameon = True, labelspacing = 0.1, 
           bbox_to_anchor=(0.01, 0.50, 0.45, 0.5), loc = 'upper left')
        frame = legend.get_frame()
        frame.set_edgecolor("black")
    else:
        legend = plt.legend(frameon = True, labelspacing = 0.1, 
           bbox_to_anchor=(0.01, 0.53, 0.5, 0.5), loc = 'upper left')
        frame = legend.get_frame()
        frame.set_edgecolor("black")
    plt.grid(visible = True, axis = 'y', linestyle = 'dotted', linewidth = 1.5)

    #Save Figure
    os.chdir(os.path.join(base_dir, '..', '..', 'figures', 'pngs'))
    fig.savefig(f"{figure_dict[itm]}_{itm}_decomp.png", bbox_inches = 'tight', dpi = 600)