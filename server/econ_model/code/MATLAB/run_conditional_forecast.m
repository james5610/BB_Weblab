%% Readme
% This script runs conditional_forecast_ojb_spec.m, which defines the model
% through which we produce forecasts. We run our conditional forecast on
% three assumptions: that v/u declines to 0.8 after 8 quarters, that v/u
% declines to 1.2 after 8 quarters, and that v/u remains about steady at
% 1.8 (it technically slightly increases over 8 quarters). There are three
% arguments of interest that can be changed in the "Options for Simulation"
% section below:
%
%   1) vu_decline_val, which is the value to which v/u will decline to,
%   after which it stays put.
%
%   2) vu_quarters_decline, which specifies over what period v/u declines
%   to the value specified in vu_decline_val
%
%   3) update_graphs, which specifies whether MATLAB graphs should be
%   produced and updated when the code is run. This is a good option if you
%   want to see results immediately, but they take time to produce and look
%   less nice than what the Python scripts produce
%
% Final results are stored in the "results" variable and are outputted to
% the corresponding Excel sheet defined below.
%
% If running into an error where "PNG library failed", please stop syncing 
% for all cloud-based storage systems (e.g. Dropbox, OneDrive) and try
% again.
%
% Please contact James Lee (Brookings Institution) or Athiana Tettaravou
% (Peterson Institute) for further questions.

clear all
close all 
clc

%% Import data
base_dir = pwd();
cd("..\..\data\intermediate_data\")
data = readtable("eq_simulations_data.xls");
cd(base_dir);

%% Initialize structure to store results
results = struct;

%% Delete old data file
% We do this to make sure no old data is somehow left in from previous
% runs. Since we are saving sheet by sheet, it's not always the case that
% old data gets deleted
cd(base_dir)
cd("..\..\data\output_data")
delete("conditional_forecast_output.xls")
cd(base_dir)

%% Delete old image files
cd("..\..\figures\pngs\cond_forecast")
delete("*png")
cd(base_dir)

%% Run simulations for each option
for option = 1:3

    %% Options for simulation.
    update_graphs = true;

    % Option 1
    if option == 1
        vu_decline_val = 0.8;
        vu_quarters_decline = 8;

    % Option 2
    elseif option == 2
        vu_decline_val = 1.2;
        vu_quarters_decline = 8;
    
    % Option 3
    elseif option == 3
        vu_decline_val = 1.8;
        vu_quarters_decline = 8;
    else
        continue;
    end
 
    %% Run simulation and store data
    cd(base_dir)
    sheet_name = "vu_" + num2str(vu_decline_val) + "_" + "qtr_" + vu_quarters_decline;
    sheet_name = sheet_name.replace(".","_");
    results.(sheet_name) = conditional_forecast(data,...
        vu_decline_val, vu_quarters_decline, update_graphs);
    sheet_data = struct2table(results.(sheet_name));
    cd("..\..\data\output_data")
    writetable(sheet_data, "conditional_forecast_output.xls",...
        "Sheet", sheet_name, 'WriteVariableNames', true)
end

cd(base_dir);