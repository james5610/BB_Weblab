#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May 12 14:55:45 2023

@author: James Lee
"""

import pandas as pd
from datetime import datetime
import matplotlib.pyplot as plt
import pickle
import os
import matplotlib.colors as mcolors
import math

# Change Directory
base_dir = os.path.dirname(os.path.realpath(__file__))
os.chdir(base_dir)

# Import parameters
infile = open('universal_params', 'rb')
universal_params = pickle.load(infile)
infile.close

# Import data
os.chdir(os.path.join("..", "..", "data", "output_data"))
data = dict()
data["vu_1.8"] = pd.read_excel("conditional_forecast_output.xls",
                               sheet_name = "vu_1_8_qtr_8")
data["vu_star"] = pd.read_excel("conditional_forecast_output.xls",
                               sheet_name = "vu_1_2_qtr_8")
data["vu_0.8"] = pd.read_excel("conditional_forecast_output.xls",
                               sheet_name = "vu_0_8_qtr_8")

for key in data.keys():
    data[key] = data[key][data[key]["period"] >= datetime(2023,1,1)]
    data[key] = data[key][data[key]["period"] <= datetime(2027,1,1)]
    data[key]["x_label"] = ["Q" + str(itm.quarter) + " " + str(itm.year) for itm in data[key]["period"]]


# Graph
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['font.sans-serif'] = ['Calibri']

font_size = 18
plt.rcParams['font.size'] = font_size
font = font = {'family' : 'sans-serif',
        'weight' : 'normal',
        'size' : 18}
plt.rcParams['font.size'] = font_size
plt.rc('figure', titlesize = font_size)
plt.rc('axes', labelsize = font_size)
plt.rc('xtick', labelsize = font_size)
plt.rc('xtick', labelsize = font_size)
plt.rc('legend', fontsize = font_size)
plt.rc('axes', titlesize = font_size)

# Graph inflation
fig, ax = plt.subplots(figsize = universal_params['standard_size_PPT'])
color_cycle = {list(data.keys())[2]: mcolors.TABLEAU_COLORS["tab:green"], 
               list(data.keys())[1]: universal_params['blue_1'],
               list(data.keys())[0]: universal_params['red_1']}
label_crosswalk = {"vu_0.8": "vu = 0.8", "vu_star": "vu = vu$^*$ = 1.2",
                   "vu_1.8": "vu = 1.8"}

for key in data.keys():
    ax.plot(data[key]["x_label"], data[key]["gcpi_simul"],
            color = color_cycle[key], label = label_crosswalk[key], lw = 2)
    
# Show every other x label
xlabels = ax.get_xticklabels()
for i, label in enumerate(xlabels):
    if i%2 == 1:
        label.set_visible(False)
            
# Other formatting
ax.set_ylim(ax.get_ylim()[0], math.ceil(ax.get_ylim()[1]))
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.xaxis.grid(True, which = 'minor')
ax.set_axisbelow(True) # puts grid lines in the back
legend = plt.legend(frameon = True, labelspacing = 0.1, 
       bbox_to_anchor=(0.01, -0.12, 0.5, 0.5), loc = 'upper left')
frame = legend.get_frame()
frame.set_edgecolor("black")
plt.grid(visible = True, axis = 'y', linestyle = 'dotted', linewidth = 1.5)
ax.set_ylabel("Percent")

plt.axvline("Q2 2025", color = 'black', ls = "--")

#Save Figure
os.chdir(os.path.join(base_dir, '..', '..', 'figures', 'pngs'))
fig.savefig(os.path.basename(__file__[:-3])+'.png', bbox_inches = 'tight', dpi = 600)