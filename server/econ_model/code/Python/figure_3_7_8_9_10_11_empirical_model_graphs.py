# -*- coding: utf-8 -*-
"""
Created on Thu May 19 14:57:05 2023

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
os.chdir(os.path.join(base_dir, "..", "..", "data", "intermediate_data"))
data = dict()
data = pd.read_excel("eq_simulations_data.xls",  header  = 0)

data["period"] = pd.to_datetime(data["period"])

start_period = '2020q1' 
end_period = '2023q1'
data = data[data['period'] >= start_period]
data = data[data['period'] <= end_period]

# Figure 3
data["x_label"] = ["Q" + str(itm.quarter) + " " + str(itm.year) for itm in data["period"]]
fig3, ax3 = plt.subplots(figsize = universal_params['standard_size_PPT']) # For the figure and axis object
ax3.plot(data['x_label'], data['gw'], label='Actual', color=universal_params['blue_1'], lw = 4)
ax3.plot(data['x_label'], data['gwf1'], label='Simulated', color=universal_params['red_1'], lw = 4)
ax3.set_ylabel('Percent', labelpad=8.0, fontsize=16)
ax3.set_xlabel('', labelpad=8.0, fontsize=16)
ax3.tick_params(axis='x', labelsize=16) 
plt.grid(visible = True, axis = 'y', linestyle = 'dotted', linewidth = 1.5)
legend = plt.legend()
frame = legend.get_frame()
frame.set_edgecolor("black")
ax3.spines['top'].set_visible(False)
ax3.spines['right'].set_visible(False)

# Show every other x label
xlabels = ax3.get_xticklabels()
for i, label in enumerate(xlabels):
    if i%2 == 1:
        label.set_visible(False)

#Save Figure
os.chdir(os.path.join(base_dir, '..', '..', 'figures', 'pngs'))
fig3.savefig(os.path.basename('figure_3_gw_graph')+'.png', bbox_inches = 'tight', dpi = 600)

# Figure 7  
fig7, ax7 = plt.subplots(figsize = universal_params['standard_size_PPT']) # For the figure and axis object
ax7.plot(data['x_label'], data['gcpi'], label='Actual', color=universal_params['blue_1'], lw = 4)
ax7.plot(data['x_label'], data['gcpif'], label='Simulated', color=universal_params['red_1'], lw = 4)
ax7.set_ylabel('Percent', labelpad=8.0, fontsize=16)
ax7.set_xlabel('', labelpad=8.0, fontsize=16)
ax7.tick_params(axis='x', labelsize=16) 
plt.grid(visible = True, axis = 'y', linestyle = 'dotted', linewidth = 1.5)
legend = plt.legend()
frame = legend.get_frame()
frame.set_edgecolor("black")
ax7.spines['top'].set_visible(False)
ax7.spines['right'].set_visible(False)

# Show every other x label
xlabels = ax7.get_xticklabels()
for i, label in enumerate(xlabels):
    if i%2 == 1:
        label.set_visible(False)
        
#Save Figure
os.chdir(os.path.join(base_dir, '..', '..', 'figures', 'pngs'))
fig7.savefig(os.path.basename('figure_7_gcpi_graph')+'.png', bbox_inches = 'tight', dpi = 600)

# Figure 8 
fig8, ax8 = plt.subplots(figsize = universal_params['standard_size_PPT']) # For the figure and axis object
ax8.plot(data['x_label'], data['cf1'], label='Actual', color=universal_params['blue_1'], lw = 4)
ax8.plot(data['x_label'], data['cf1f'], label='Simulated', color=universal_params['red_1'], lw = 4)
ax8.set_ylabel('Percent', labelpad=8.0, fontsize=16)
ax8.set_xlabel('', labelpad=8.0, fontsize=16)
ax8.tick_params(axis='x', labelsize=16) 
plt.grid(visible = True, axis = 'y', linestyle = 'dotted', linewidth = 1.5)
legend = plt.legend()
frame = legend.get_frame()
frame.set_edgecolor("black")
ax8.spines['top'].set_visible(False)
ax8.spines['right'].set_visible(False)

# Show every other x label
xlabels = ax8.get_xticklabels()
for i, label in enumerate(xlabels):
    if i%2 == 1:
        label.set_visible(False)
        
#Save Figure
os.chdir(os.path.join(base_dir, '..', '..', 'figures', 'pngs'))
fig8.savefig(os.path.basename('figure_8_cf1_graph')+'.png', bbox_inches = 'tight', dpi = 600)

# Figure 9 
fig9, ax9 = plt.subplots(figsize = universal_params['standard_size_PPT']) # For the figure and axis object
ax9.plot(data['x_label'], data['cf10'], label='Actual', color=universal_params['blue_1'], lw = 4)
ax9.plot(data['x_label'], data['cf10f'], label='Simulated', color=universal_params['red_1'], lw = 4)
ax9.set_ylabel('Percent', labelpad=8.0, fontsize=16)
ax9.set_xlabel('', labelpad=8.0, fontsize=16)
ax9.tick_params(axis='x', labelsize=16) 
plt.grid(visible = True, axis = 'y', linestyle = 'dotted', linewidth = 1.5)
legend = plt.legend()
frame = legend.get_frame()
frame.set_edgecolor("black")
ax9.spines['top'].set_visible(False)
ax9.spines['right'].set_visible(False)

# Show every other x label
xlabels = ax9.get_xticklabels()
for i, label in enumerate(xlabels):
    if i%2 == 1:
        label.set_visible(False)
        
#Save Figure
os.chdir(os.path.join(base_dir, '..', '..', 'figures', 'pngs'))
fig9.savefig(os.path.basename('figure_9_cf10_graph')+'.png', bbox_inches = 'tight', dpi = 600)

# Import data 
os.chdir(os.path.join(base_dir, "..", "..", "data", "output_data"))
data1 = pd.read_excel('empirical_model_irf_results.xls', sheet_name='grpe', usecols=['timestep', 'gcpi_simul'], header=0)[4:20]
data1.rename(columns={'gcpi_simul': 'grpe_gcpi'}, inplace=True)
data2 = pd.read_excel('empirical_model_irf_results.xls', sheet_name='grpf', usecols=['timestep', 'gcpi_simul'], header=0)[4:20]
data2.rename(columns={'gcpi_simul': 'grpf_gcpi'}, inplace=True)
data3 = pd.read_excel('empirical_model_irf_results.xls', sheet_name='shortage', usecols=['timestep', 'gcpi_simul'], header=0)[4:20]
data3.rename(columns={'gcpi_simul': 'shortage_gcpi'}, inplace=True)
data4 = pd.read_excel('empirical_model_irf_results.xls', sheet_name='vu', usecols=['timestep', 'gcpi_simul'], header=0)[4:20]
data4.rename(columns={'gcpi_simul': 'vu_gcpi'}, inplace=True)

merged_data = pd.merge(data1, data2, on='timestep', how='inner')
merged_data = pd.merge(merged_data, data3, on='timestep', how='inner')
merged_data = pd.merge(merged_data, data4, on='timestep', how='inner')
merged_data.timestep = merged_data.timestep - 4

# Figure 10 
fig10, ax10 = plt.subplots(figsize = universal_params['standard_size_PPT']) # For the figure and axis object
ax10.plot(merged_data['timestep'], merged_data['grpe_gcpi'], label='Energy price', color=universal_params['blue_1'], lw = 4)
ax10.plot(merged_data['timestep'], merged_data['grpf_gcpi'], label='Food price', color=universal_params['red_1'], lw = 4)
ax10.plot(merged_data['timestep'], merged_data['shortage_gcpi'], label='Shortage', color=universal_params['orange_1'], lw = 4)
ax10.set_ylabel('Percent', labelpad=8.0, fontsize=16)
ax10.set_xlabel('Quarter', labelpad=8.0, fontsize=16)
plt.grid(visible = True, axis = 'y', linestyle = 'dotted', linewidth = 1.5)
ax10.spines['top'].set_visible(False)
ax10.spines['right'].set_visible(False)
plt.xticks(range(1,17))
legend = plt.legend()
frame = legend.get_frame()
frame.set_edgecolor("black")

#Save Figure
os.chdir(os.path.join(base_dir, '..', '..', 'figures', 'pngs'))
fig10.savefig(os.path.basename('figure_10_energy_food_shortage_graph')+'.png', bbox_inches = 'tight', dpi = 600)


# Figure 11 
fig11, ax11 = plt.subplots(figsize = universal_params['standard_size_PPT']) # For the figure and axis object
ax11.plot(merged_data['timestep'], merged_data['vu_gcpi'], label='Vacancy unemployment ratio', color=universal_params['blue_1'], lw = 4)
ax11.set_ylabel('Percent', labelpad=8.0, fontsize=16)
ax11.set_xlabel('Quarter', labelpad=8.0, fontsize=16)
plt.grid(visible = True, axis = 'y', linestyle = 'dotted', linewidth = 1.5)
ax11.spines['top'].set_visible(False)
ax11.spines['right'].set_visible(False)
plt.xticks(range(1,17))
legend = plt.legend()
frame = legend.get_frame()
frame.set_edgecolor("black")

#Save Figure
os.chdir(os.path.join(base_dir, '..', '..', 'figures', 'pngs'))
fig11.savefig(os.path.basename('figure_11_vu_shock_graph')+'.png', bbox_inches = 'tight', dpi = 600)
