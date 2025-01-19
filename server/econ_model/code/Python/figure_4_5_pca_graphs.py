# -*- coding: utf-8 -*-
"""
Created on Thu May 25 14:57:05 2023

@author: Athiana.Tettaravou
"""
import pandas as pd
from datetime import datetime
import matplotlib.pyplot as plt
import pickle
import os
import numpy as np

# Change Directory
base_dir = os.path.dirname(os.path.realpath(__file__))
data_dir = os.path.join(base_dir, "..", "..", "data")

# Import parameters
infile = open('universal_params', 'rb')
universal_params = pickle.load(infile)
infile.close

# Import data
os.chdir(data_dir)
os.chdir("intermediate_data")
data = pd.read_excel('eq_simulations_data.xls', header  = 0)

# Import PC data
os.chdir(os.path.join(data_dir, "output_data"))
pc_data = pd.read_excel("Bloomberg_Commodity_Data_Cleaned_Quarterly.xlsx")
new_dates = [np.nan for row in pc_data["Date"]]

idx = 0
for row in pc_data.itertuples():
    new_dates[idx] = datetime(row.Date.year, row.Date.month-2, 1)
    idx += 1
pc_data["Date"] = new_dates

# Merge data
merged_df = pd.merge(data, pc_data, left_on = "period", right_on = "Date")
merged_df = merged_df.drop("Date", axis = 1)
merged_df = merged_df[merged_df["period"] >= datetime(2020, 1, 1)]

# Format x labels
x_labels = [np.nan for row in merged_df["period"]]
idx = 0
for row in merged_df.itertuples():
    x_labels[idx] = "Q" + str(row.period.quarter) + " " + str(row.period.year)
    idx += 1
merged_df["x_labels"] = x_labels

# Figure 4 
fig4, ax4 = plt.subplots(figsize = universal_params['standard_size_PPT']) # For the figure and axis object
ax4bis = ax4.twinx()

# Plot the PC variable on the left axis
p1, = ax4.plot(merged_df['x_labels'], merged_df['CRB_PC'], color=universal_params['blue_1'], lw=4, label='1st principal component')
ax4.set_ylabel('1st principal component', labelpad=6.0, fontsize=16)
ax4.tick_params(axis='y', labelsize=16)

# Plot the CPIENGSL variable on the right axis
p2, = ax4bis.plot(merged_df['x_labels'], merged_df['CPIENGSL'], color=universal_params['red_1'], lw=4, label='CPI energy index')
ax4bis.set_ylabel('CPI energy index', labelpad=8.0, fontsize=16)
ax4bis.tick_params(axis='y', labelsize=16)

ax4.set_xlabel('', fontsize=16)
ax4.tick_params(axis='x', labelsize=16)

ax4.grid(True, axis = 'y',linestyle='dotted', linewidth=1.5)
ax4.spines['top'].set_visible(False)
ax4bis.spines['top'].set_visible(False)

# Create a single legend box
lines = [p1, p2]
labels = [line.get_label() for line in lines]
legend = ax4.legend(lines, labels, loc='upper left', bbox_to_anchor=(0.0, 1.0),bbox_transform=ax4.transAxes, prop={'size': 16})
frame = legend.get_frame()
frame.set_edgecolor("black")

# Adjust the spacing between the subplots
plt.subplots_adjust(top=0.85, bottom=0.15)
#plt.show()

# Show every other x label
xlabels = ax4.get_xticklabels()
for i, label in enumerate(xlabels):
    if i%2 == 1:
        label.set_visible(False)

#Save Figure
os.chdir(os.path.join(base_dir, '..', '..', 'figures', 'pngs'))
fig4.savefig('figure_4_energy_PC_graph.png', bbox_inches = 'tight', dpi = 600)

# Figure 5 
fig5, ax5 = plt.subplots(figsize = universal_params['standard_size_PPT']) # For the figure and axis object
ax5bis = ax5.twinx()

# Plot the PC variable on the left axis
p1, = ax5.plot(merged_df['x_labels'], merged_df['CRB_PC'], color=universal_params['blue_1'], lw=4, label='1st principal component')
ax5.set_ylabel('1st principal component', labelpad=6.0, fontsize=16)
ax5.tick_params(axis='y', labelsize=16)

# Plot the CPIUFDSL variable on the right axis
p2, = ax5bis.plot(merged_df['x_labels'], merged_df['CPIUFDSL'], color=universal_params['red_1'], lw=4, label='CPI food index')
ax5bis.set_ylabel('CPI food index', labelpad=8.0, fontsize=16)
ax5bis.tick_params(axis='y', labelsize=16)

ax5.set_xlabel('', fontsize=16)
ax5.tick_params(axis='x', labelsize=16)

ax5.grid(True, axis ='y', linestyle='dotted', linewidth=1.5)
ax5.spines['top'].set_visible(False)
ax5bis.spines['top'].set_visible(False)

# Create a single legend box
lines = [p1, p2]
labels = [line.get_label() for line in lines]
legend = ax5.legend(lines, labels, loc='upper left', bbox_to_anchor=(0.0, 1.0),bbox_transform=ax5.transAxes, prop={'size': 16})
frame = legend.get_frame()
frame.set_edgecolor("black")

# Adjust the spacing between the subplots
plt.subplots_adjust(top=0.85, bottom=0.15)

# Show every other x label
xlabels = ax5.get_xticklabels()
for i, label in enumerate(xlabels):
    if i%2 == 1:
        label.set_visible(False)

#Save Figure
os.chdir(os.path.join(base_dir, '..', '..', 'figures', 'pngs'))
fig5.savefig('figure_5_food_PC_graph.png', bbox_inches = 'tight', dpi = 600)