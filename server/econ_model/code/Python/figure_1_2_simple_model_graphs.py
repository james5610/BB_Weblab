# -*- coding: utf-8 -*-
"""
Created on Mon May  1 13:14:24 2023

@author: Athiana.Tettaravou
"""

import pandas as pd
import matplotlib.pyplot as plt
import pickle
import os

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
weak_df = pd.read_excel('simple_model_irf_results.xls', sheet_name='Weak_Response', header=0)
strong_df = pd.read_excel('simple_model_irf_results.xls', sheet_name='Strong_Response', header=0)
weak_df = weak_df[weak_df["period"]<=16]
strong_df = strong_df[strong_df["period"]<=16]
# Rescale eta_u
weak_df["p_eta_u"] = weak_df["p_eta_u"]*3
strong_df["p_eta_u"] = strong_df["p_eta_u"]*3

           
# Make graphs
plt.rcParams['font.family'] = 'sans-serif'
# plt.rcParams['font.sans-serif'] = ['Calibri']
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

# Figure 1 
fig, ax = plt.subplots(figsize = universal_params['standard_size_PPT']) 
ax.plot(weak_df['period'], weak_df['p_eta_zp'], label='Weak feedback', color=universal_params['blue_1'], lw = 4)
ax.plot(strong_df['period'], strong_df['p_eta_zp'], label='Strong feedback', color=universal_params['red_1'], lw = 4)
ax.set_ylabel('Percent', labelpad=8.0, fontsize=16)
ax.set_xlabel('Quarter', labelpad=8.0, fontsize=16)
plt.grid(visible = True, axis = 'y', linestyle = 'dotted', linewidth = 1.5)
legend = plt.legend()
frame = legend.get_frame()
frame.set_edgecolor("black")
plt.xticks(range(1,17))
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)

#Save Figure
os.chdir(os.path.join(base_dir, '..', '..', 'figures', 'pngs'))
fig.savefig(os.path.basename('figure_1_price_shock_graph')+'.png', bbox_inches = 'tight', dpi = 1000)


# Figure 2  
os.chdir(base_dir)
os.chdir(os.path.join("..", "..", "data", "output_data"))


fig2, ax2 = plt.subplots(figsize = universal_params['standard_size_PPT']) #
ax2.plot(weak_df['period'], weak_df['p_eta_u'], label='Weak feedback', color=universal_params['blue_1'], lw = 4)
ax2.plot(strong_df['period'], strong_df['p_eta_u'], label='Strong feedback', color=universal_params['red_1'], lw = 4)
ax2.set_ylabel('Percent', labelpad=8.0, fontsize=16)
ax2.set_xlabel('Quarter', labelpad=8.0, fontsize=16)
plt.grid(visible = True, axis = 'y', linestyle = 'dotted', linewidth = 1.5)
plt.xticks(range(1,17))
legend = plt.legend()
frame = legend.get_frame()
frame.set_edgecolor("black")
ax2.spines['top'].set_visible(False)
ax2.spines['right'].set_visible(False)

#Save Figure
os.chdir(os.path.join(base_dir, '..', '..', 'figures', 'pngs'))
fig2.savefig(os.path.basename('figure_2_labor_market_graph')+'.png', bbox_inches = 'tight', dpi = 1000)
