#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 14 15:09:46 2023

@author: James Lee
"""

import pandas as pd
import numpy as np
import pandas_datareader as pdr
from datetime import datetime
import matplotlib.pyplot as plt
import pickle
from dateutil.relativedelta import relativedelta
import os
import matplotlib
import matplotlib.dates as dates

# Change Directory
base_dir = os.path.dirname(os.path.realpath(__file__))
os.chdir(base_dir)

# Import parameters
infile = open('universal_params', 'rb')
universal_params = pickle.load(infile)
infile.close

# Import data
'''
AB67RG3Q086SBEA are Personal consumption expenditures: New motor vehicles (chain-type price index)
MVATOTASSS are Total Motor Vehicle Assemblies
AUINSA are domestic auto inventories
'''

fred_series = ["AB67RG3Q086SBEA", "MVATOTASSS", "AUINSA"]
fred_df = pdr.get_data_fred(fred_series, start = datetime(2012, 1, 1),
                            freq = 'M')
fred_df["Date"] = fred_df.index.to_pydatetime()
fred_df["AB67RG3Q086SBEA"] = fred_df["AB67RG3Q086SBEA"].shift(2) # lines up quarterly data with end of quarter monthly data
fred_df["MVATOTASSS"] = fred_df["MVATOTASSS"].rolling(window=3).mean() # The average of each quarter will be the 3 month moving average at the end of each quarter
fred_df["AUINSA"] = fred_df["AUINSA"].rolling(3).mean() # lines up quarterly data with end of quarter monthly data

fred_df = fred_df[fred_df.index.month%3 == 0]
fred_df = fred_df.set_index("Date")

fred_df["NV_Change_Annualized"] = (
    (fred_df["AB67RG3Q086SBEA"]/fred_df["AB67RG3Q086SBEA"].shift(1))
    .apply(lambda x: x**4)-1)*100 #NV stands for New Vehicle

# Use Google data
os.chdir(os.path.join(base_dir, "..", "..", "data", "input_data", "public"))

google_df1 = pd.read_excel("googletrends_quarterly.xls", sheet_name = "chipshortage")
google_df2 = pd.read_excel("googletrends_quarterly.xls", sheet_name = "carshortage")
google_df1.columns = ["Date", "chipshortage"]
google_df2.columns = ["Date", "carshortage"]
google_df = pd.merge(google_df1, google_df2, left_on = "Date", right_on = "Date")
google_df["Date"] = [date + relativedelta(months = 2) for date in google_df["Date"]] # lines up quarterly data with end of quarter monthly data
google_df = google_df.set_index("Date")
google_df["chipshortage"] = 100*google_df["chipshortage"]/google_df["chipshortage"].loc[datetime(2021,9,1)]
google_df["carshortage"] = 100*google_df["carshortage"]/google_df["carshortage"].loc[datetime(2021,9,1)]


merged_df = pd.merge(fred_df, google_df, left_index = True, right_index = True, how = 'outer')
merged_df = merged_df[merged_df.index > datetime(2018,1,1)]

# Make new x labels
merged_df["x_label"] = ["Q" + str(itm.quarter) + " " + str(itm.year) for itm in merged_df.index]


# Make Graphs
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['font.sans-serif'] = ['Calibri']

font_size = 12
plt.rcParams['font.size'] = font_size
font = font = {'family' : 'sans-serif',
        'weight' : 'normal',
        'size' : 12}
plt.rcParams['font.size'] = font_size
plt.rc('figure', titlesize = font_size)
plt.rc('axes', labelsize = font_size)
plt.rc('xtick', labelsize = font_size)
plt.rc('xtick', labelsize = font_size)
plt.rc('legend', fontsize = font_size)
plt.rc('axes', titlesize = font_size)


fig, axs = plt.subplots(4, 1, figsize = (10,10))
plt.subplots_adjust(hspace = 0.4)

# Plot 1: New Vehicle Assemblies
'''
Note: numbers are percent annualized from previous quarter (i.e. three months ago)
'''
axs[0].plot(merged_df.index, merged_df['MVATOTASSS'].values, color = universal_params['blue_1'])
axs[0].axvline(x=datetime(2021,9,1), color = universal_params['grey_3'], ls = '--')

axs[0].grid(visible = True, axis = 'y', linestyle = 'dotted', linewidth = 1.5)
axs[0].set_yticks(np.arange(3,13,3))

axs[0].set_ylabel('Millions of units')
axs[0].set_title('Motor Vehicle Assemblies')
axs[0].spines['right'].set_visible(False)
axs[0].spines['top'].set_visible(False)

# Create another axis to add tick marks at end of each quarter
ax0 = axs[0].twiny()
ax0.xaxis.set_ticks_position('bottom')

# Create a fake set of x such that 3 tick marks appear between each year
x2 = [datetime(year,month,1) for year in range(2018,2023) for month in range(3,13,3)]
plt.gca().set_xticks(x2)
plt.gca().set_xticklabels([])
ax0.set_xlim(datetime(2018,1,1), datetime(2023,3,1))
ax0.spines['right'].set_visible(False)
ax0.spines['top'].set_visible(False)

# Format ticks so year appears between ticks
axs[0].tick_params(which='minor', length=10, color = 'black')
axs[0].tick_params(axis = 'x', which = 'major', bottom = False)

axs[0].xaxis.set_minor_locator(dates.MonthLocator(bymonth = 12))
axs[0].xaxis.set_major_locator(dates.MonthLocator(bymonth = 6))

axs[0].xaxis.set_major_formatter(dates.DateFormatter('%Y'))

# offset tick labels
dx = 0
dy = -2/72 # matplotlib uses 72 points per inch, so divide by 72
offset = matplotlib.transforms.ScaledTranslation(dx, dy, fig.dpi_scale_trans)

for label in axs[0].xaxis.get_majorticklabels():
    label.set_transform(label.get_transform() + offset)

# Set x axis limits
axs[0].set_xlim(datetime(2018,1,1), datetime(2023,3,1))

# Plot 2: Domestic Auto Inventories (BEA)
axs[1].plot(merged_df.index, merged_df['AUINSA'].values, color = universal_params['blue_1'])
axs[1].axvline(x=datetime(2021,9,1), color = universal_params['grey_3'], ls = '--')

axs[1].legend
axs[1].grid(visible = True, axis = 'y', linestyle = 'dotted', linewidth = 1.5)
axs[1].set_yticks(np.arange(0,1001,250))

axs[1].set_ylabel('Thousands of Units')
axs[1].set_title('Auto Inventories')
axs[1].spines['right'].set_visible(False)
axs[1].spines['top'].set_visible(False)

# Create another axis to add tick marks at end of each quarter
ax1 = axs[1].twiny()
ax1.xaxis.set_ticks_position('bottom')

# Create a fake set of x such that 3 tick marks appear between each year
x2 = [datetime(year,month,1) for year in range(2018,2023) for month in range(3,13,3)]
plt.gca().set_xticks(x2)
plt.gca().set_xticklabels([])
ax1.set_xlim(datetime(2018,1,1), datetime(2023,3,1))
ax1.spines['right'].set_visible(False)
ax1.spines['top'].set_visible(False)

# Format ticks so year appears between ticks
axs[1].tick_params(which='minor', length=10, color = 'black')
axs[1].tick_params(axis = 'x', which = 'major', bottom = False)

axs[1].xaxis.set_minor_locator(dates.MonthLocator(bymonth = 12))
axs[1].xaxis.set_major_locator(dates.MonthLocator(bymonth = 6))

axs[1].xaxis.set_major_formatter(dates.DateFormatter('%Y'))

# offset tick labels
dx = 0
dy = -2/72 # matplotlib uses 72 points per inch, so divide by 72
offset = matplotlib.transforms.ScaledTranslation(dx, dy, fig.dpi_scale_trans)

for label in axs[1].xaxis.get_majorticklabels():
    label.set_transform(label.get_transform() + offset)

# Set x axis limits
axs[1].set_xlim(datetime(2018,1,1), datetime(2023,3,1))



# Plot 3: New Vehicle Prices
'''
Note: numbers are percent annualized from previous quarter (i.e. three months ago)
'''
axs[2].plot(merged_df.index, merged_df['NV_Change_Annualized'].values, color = universal_params['blue_1'])
axs[2].axvline(x=datetime(2021,9,1), color = universal_params['grey_3'], ls = '--')

axs[2].grid(visible = True, axis = 'y', linestyle = 'dotted', linewidth = 1.5)
axs[2].set_yticks(np.arange(0,21,5))

axs[2].set_ylabel('Percent (annualized)')
axs[2].set_title('Inflation in New Vehicles Prices (PCE)')
axs[2].spines['right'].set_visible(False)
axs[2].spines['top'].set_visible(False)

# Create another axis to add tick marks at end of each quarter
ax2 = axs[2].twiny()
ax2.xaxis.set_ticks_position('bottom')

# Create a fake set of x such that 3 tick marks appear between each year
x2 = [datetime(year,month,1) for year in range(2018,2023) for month in range(3,13,3)]
plt.gca().set_xticks(x2)
plt.gca().set_xticklabels([])
ax2.set_xlim(datetime(2018,1,1), datetime(2023,3,1))
ax2.spines['right'].set_visible(False)
ax2.spines['top'].set_visible(False)

# Format ticks so year appears between ticks
axs[2].tick_params(which='minor', length=10, color = 'black')
axs[2].tick_params(axis = 'x', which = 'major', bottom = False)

axs[2].xaxis.set_minor_locator(dates.MonthLocator(bymonth = 12))
axs[2].xaxis.set_major_locator(dates.MonthLocator(bymonth = 6))

axs[2].xaxis.set_major_formatter(dates.DateFormatter('%Y'))

# offset tick labels
dx = 0
dy = -2/72 # matplotlib uses 72 points per inch, so divide by 72
offset = matplotlib.transforms.ScaledTranslation(dx, dy, fig.dpi_scale_trans)

for label in axs[2].xaxis.get_majorticklabels():
    label.set_transform(label.get_transform() + offset)


# Set x axis limits
axs[2].set_xlim(datetime(2018,1,1), datetime(2023,3,1))

# Plot 4: Car and Chip Shortage (Google Trend)
'''
Note: Numbers represent search interest relative to the highest point on the chart for the given region and time. A value of 100 is the peak popularity for the term. A value of 50 means that the term is half as popular. A score of 0 means there was not enough data for this term.
'''
axs[3].plot(merged_df.index, merged_df['chipshortage'].values, color = universal_params['blue_1'], label = "Chip shortage")
axs[3].plot(merged_df.index, merged_df['carshortage'].values, color = universal_params['red_1'], label = "Car shortage")
axs[3].axvline(x=datetime(2021,9,1), color = universal_params['grey_3'], ls = '--')

axs[3].legend
axs[3].grid(visible = True, axis = 'y', linestyle = 'dotted', linewidth = 1.5)

axs[3].set_yticks(np.arange(0,126,25))
axs[3].set_ylabel('Index (2021 Q3=100)')
axs[3].set_title('Google Searches')
axs[3].spines['right'].set_visible(False)
axs[3].spines['top'].set_visible(False)

# Create another axis to add tick marks at end of each quarter
ax3 = axs[3].twiny()
ax3.xaxis.set_ticks_position('bottom')

# Create a fake set of x such that 3 tick marks appear between each year
x2 = [datetime(year,month,1) for year in range(2018,2023) for month in range(3,13,3)]
plt.gca().set_xticks(x2)
plt.gca().set_xticklabels([])
ax3.set_xlim(datetime(2018,1,1), datetime(2023,3,1))
ax3.spines['right'].set_visible(False)
ax3.spines['top'].set_visible(False)

# Format ticks so year appears between ticks
axs[3].tick_params(which='minor', length=10, color = 'black')
axs[3].tick_params(axis = 'x', which = 'major', bottom = False)

axs[3].xaxis.set_minor_locator(dates.MonthLocator(bymonth = 12))
axs[3].xaxis.set_major_locator(dates.MonthLocator(bymonth = 6))

axs[3].xaxis.set_major_formatter(dates.DateFormatter('%Y'))

# Format ticks so year appears between ticks
axs[3].tick_params(which='minor', length=10, color = 'black')
axs[3].tick_params(axis = 'x', which = 'major', bottom = False)

axs[3].xaxis.set_minor_locator(dates.MonthLocator(bymonth = 12))
axs[3].xaxis.set_major_locator(dates.MonthLocator(bymonth = 6))

axs[3].xaxis.set_major_formatter(dates.DateFormatter('%Y'))

# offset tick labels
dx = 0
dy = -2/72 # matplotlib uses 72 points per inch, so divide by 72
offset = matplotlib.transforms.ScaledTranslation(dx, dy, fig.dpi_scale_trans)

for label in axs[3].xaxis.get_majorticklabels():
    label.set_transform(label.get_transform() + offset)

# Set x axis limits
axs[3].set_xlim(datetime(2018,1,1), datetime(2023,3,1))

# Add Legend to Plot 2
handles, labels = axs[3].get_legend_handles_labels()
legend = axs[3].legend(handles, labels, loc = 'upper right',
                         bbox_to_anchor = (0.34, 1.04), frameon = True,
                         ncol = 1)
frame = legend.get_frame()
frame.set_edgecolor("black")
 
#Save Figure
os.chdir(os.path.join(base_dir, '..', '..', 'figures', 'pngs'))
fig.savefig(os.path.basename(__file__[:-3]) + '.png', bbox_inches = 'tight', dpi = 1000)

# Save Data
os.chdir(base_dir)
os.chdir(os.path.join('..', '..', 'data', 'output_data'))
merged_df.to_excel(os.path.basename(__file__[:-3]) + "_output_data.xlsx")