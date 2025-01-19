%% Description
% This script runs various combinations of removing various shocks and adding
% or leaving out residuals. The main model is defined in the file
% dynamic_simul.m
%
% This script is used to derive the contribution each shock contributes to
% overall inflation.
%
% If running into an error where "PNG library failed", please pause syncing 
% for all cloud-based storage systems (e.g. Dropbox, OneDrive) and try
% again.
%
% Set update_graphs to false if you don't wish to produce all the graphs
% (takes some time to produce).
%
% Please contact James Lee (Brookings Institution) or Athiana Tettaravou
% (Peterson Institute) for further questions.

clear all
close all 
clc

%% Import data
base_dir = pwd();
cd("..\..\data\intermediate_data")
data = readtable("eq_simulations_data.xls");
cd(base_dir);

%% Initialize structure to store results
results = struct;

%% Delete old all data file
% We do this to make sure no old data is somehow left in from previous
% runs. Since we are saving sheet by sheet, it's not always the case that
% old data gets deleted
cd(base_dir)
cd("..\..\data\output_data")
delete("all_data_decompositions.xls")
cd(base_dir)

%% Run simulations for each option (12 combinations total)
for option = 1:12

    %% Options for simulation.
    update_graphs = true;

    % Option 1
    if option == 1
        add_residuals = false;
        remove_grpe = false;
        remove_grpf = false;
        remove_vu = false;
        remove_shortage = false;
    
    % Option 2
    elseif option == 2
        remove_grpe = true;
        remove_grpf = false;
        remove_vu = false;
        remove_shortage = false;
    
    % Option 3
    elseif option == 3
        add_residuals = false;
        remove_grpe = false;
        remove_grpf = true;
        remove_vu = false;
        remove_shortage = false;
    
    % Option 4
    elseif option == 4
        add_residuals = false;
        remove_grpe = false;
        remove_grpf = false;
        remove_vu = true;
        remove_shortage = false;
    
    % Option 5
    elseif option == 5
        add_residuals = false;
        remove_grpe = false;
        remove_grpf = false;
        remove_vu = false;
        remove_shortage = true;
    
    % Option 6
    elseif option == 6
        add_residuals = false;
        remove_grpe = true;
        remove_grpf = true;
        remove_vu = true;
        remove_shortage = true;
    
    % Option 7
    elseif option == 7
        add_residuals = true;
        remove_grpe = false;
        remove_grpf = false;
        remove_vu = false;
        remove_shortage = false;
    
    % Option 8
    elseif option == 8
        add_residuals = true;
        remove_grpe = true;
        remove_grpf = false;
        remove_vu = false;
        remove_shortage = false;
    
    % Option 9
    elseif option == 9
        add_residuals = true;
        remove_grpe = false;
        remove_grpf = true;
        remove_vu = false;
        remove_shortage = false;
    
    % Option 10
    elseif option == 10
        add_residuals = true;
        remove_grpe = false;
        remove_grpf = false;
        remove_vu = true;
        remove_shortage = false;
    
    % Option 11
    elseif option == 11
        add_residuals = true;
        remove_grpe = false;
        remove_grpf = false;
        remove_vu = false;
        remove_shortage = true;

    % Option 12
    elseif option == 12
        add_residuals = true;
        remove_grpe = true;
        remove_grpf = true;
        remove_vu = true;
        remove_shortage = true;
    end
    
    %% Format residual and shock strings
    % Initializes string to show what shocks have been added and whether
    % residuals were added. Used to store results in an organized manner.

    if add_residuals
        residuals_added_text = "w_residuals";
    else
        residuals_added_text = "wo_residuals";
    end

    shocks_removed_text = "";
    is_first = true;
    if remove_grpe
        if ~is_first
            shocks_removed_text = shocks_removed_text + "_";
        end
        shocks_removed_text  = shocks_removed_text + "grpe";
        is_first = false;
    end
    
    if remove_grpf
        if ~is_first
            shocks_removed_text = shocks_removed_text + "_";
        end
        shocks_removed_text  = shocks_removed_text + "grpf";
        is_first = false;
    end
    
    if remove_vu
        if ~is_first
            shocks_removed_text = shocks_removed_text + "_";
        end
        shocks_removed_text  = shocks_removed_text + "vu";
        is_first = false;
    end
    
    if remove_shortage
        if ~is_first
            shocks_removed_text = shocks_removed_text + "_";
        end
        shocks_removed_text  = shocks_removed_text + "shortage";
        is_first = false;
    end
    
    if shocks_removed_text == ""
        shocks_removed_text = "no_shocks_removed";
    end

    %% Run simulation and store data
    cd(base_dir)
    results.(residuals_added_text).(shocks_removed_text) =...
    dynamic_simul(data, add_residuals, remove_grpe,...
    remove_grpf, remove_vu, remove_shortage, update_graphs);
    
    cd(base_dir)
    cd("..\..\data\output_data")
    sheet_data = struct2table(...
        results.(residuals_added_text).(shocks_removed_text));
    sheet_name = residuals_added_text + "_" + shocks_removed_text;
    if strlength(sheet_name) > 31
        sheet_name = extractBefore(sheet_name, 31); % Excel tabs support max length of 31
    end
    writetable(sheet_data, "all_data_decompositions.xls", "Sheet",...
    sheet_name, 'WriteVariableNames', true)
end

cd(base_dir);