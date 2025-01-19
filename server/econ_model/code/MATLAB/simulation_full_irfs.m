% Created by James Lee and Athiana Tettaravou
% Runs each simulation seperately
% Coefficients from Stata .do files


% Note: sometimes the program fails to run because the "PNG library
% failed". If this is the case, try running the program again. This error
% occasionally occurs.

% In general:
% -variable names with no suffixes represent historical data, or in this
% case, an array of zeros
% -variable names ending in _simul represent simulated values. These are the series that represent each variabless response to a shock.
% -variable names ending in _shock represent series with one time shock
% values. Note that if these variables for some reason do not immediately
% return to zero that modificaiton of this variable may be needed
% variable names ending in _shock_series represent the time series of
% exogenous shocks. 

clear all
close all 
clc 

base_dir = pwd();
results = struct;

%% Get coefficients
cd("..\..\data\intermediate_data")
format long
gw_beta = readtable("eq_coefficients.xlsx", 'Sheet', "gw");
gcpi_beta = readtable("eq_coefficients.xlsx", 'Sheet', "gcpi");
cf1_beta = readtable("eq_coefficients.xlsx", 'Sheet', "cf1");
cf10_beta = readtable("eq_coefficients.xlsx", 'Sheet', "cf10");
cd(base_dir);

% Delete old data (Matlab doesn't automatically do this)
cd(base_dir)
cd("..\..\data\output_data")
delete("empirical_model_irf_results.xls"); % deletes old data

for option = 1:9
    cd(base_dir)
    cd("..\..\data\output_data")
    %% Options for simulation. Note: the shocks below add shocks to actual data.
    update_graphs = true;

    if option == 1
        add_grpe_shock = false;
        add_grpf_shock = false;
        add_vu_shock = false;
        add_shortage_shock = false;
        add_gw_shock = false;
        add_gcpi_shock = false;
        add_cf1_shock = false;
        add_cf10_shock = false;
    elseif option == 2
        add_grpe_shock = true;
        add_grpf_shock = false;
        add_vu_shock = false;
        add_shortage_shock = false;
        add_gw_shock = false;
        add_gcpi_shock = false;
        add_cf1_shock = false;
        add_cf10_shock = false;
    elseif option == 3
        add_grpe_shock = false;
        add_grpf_shock = true;
        add_vu_shock = false;
        add_shortage_shock = false;
        add_gw_shock = false;
        add_gcpi_shock = false;
        add_cf1_shock = false;
        add_cf10_shock = false;
    elseif option == 4
        add_grpe_shock = false;
        add_grpf_shock = false;
        add_vu_shock = true;
        add_shortage_shock = false;
        add_gw_shock = false;
        add_gcpi_shock = false;
        add_cf1_shock = false;
        add_cf10_shock = false;
    elseif option == 5
        add_grpe_shock = false;
        add_grpf_shock = false;
        add_vu_shock = false;
        add_shortage_shock = true;
        add_gw_shock = false;
        add_gcpi_shock = false;
        add_cf1_shock = false;
        add_cf10_shock = false;
    elseif option == 6
        add_grpe_shock = false;
        add_grpf_shock = false;
        add_vu_shock = false;
        add_shortage_shock = false;
        add_gw_shock = true;
        add_gcpi_shock = false;
        add_cf1_shock = false;
        add_cf10_shock = false;
    elseif option == 7
        add_grpe_shock = false;
        add_grpf_shock = false;
        add_vu_shock = false;
        add_shortage_shock = false;
        add_gw_shock = false;
        add_gcpi_shock = true;
        add_cf1_shock = false;
        add_cf10_shock = false;
    elseif option == 8
        add_grpe_shock = false;
        add_grpf_shock = false;
        add_vu_shock = false;
        add_shortage_shock = false;
        add_gw_shock = false;
        add_gcpi_shock = false;
        add_cf1_shock = true;
        add_cf10_shock = false;
    elseif option == 9
        add_grpe_shock = false;
        add_grpf_shock = false;
        add_vu_shock = false;
        add_shortage_shock = false;
        add_gw_shock = false;
        add_gcpi_shock = false;
        add_cf1_shock = false;
        add_cf10_shock = true;
    else
        continue
    end
    
    % Import data
    % All data is initialized to zero to reflect that they are in steady state
    cd(base_dir)
    cd("..\..\data\intermediate_data")
    data = readtable("eq_simulations_data.xls");
    table_q4_data = data(data.period >= datetime(2020,01,1), :);
    data = data(data.period >= datetime(2018,10,1), :);
    timesteps = 32;
    period = data.period.';
    gw = zeros(1,timesteps);
    cf1 = zeros(1,timesteps);
    magpty = zeros(1,timesteps);
    diffcpicf = zeros(1,timesteps);
    vu = zeros(1,timesteps);
    dummygw = zeros(1,timesteps);
    gcpi = zeros(1,timesteps);
    grpe = zeros(1,timesteps);
    grpf = zeros(1,timesteps);
    shortage = zeros(1,timesteps);
    cf10 = zeros(1,timesteps);
    gw_residuals = data.gw_residuals.';
    gcpi_residuals = data.gcpi_residuals.';
    cf1_residuals = data.cf1_residuals.';
    cf10_residuals = data.cf10_residuals.';
    
    % Since we need 4 values before we can run the simulation (because we have
    % 4 lags), we need to initialize the first 4 values of cf1_simul to the
    % actual data
    gw_simul = gw(1:4);
    gcpi_simul(1:4) = gcpi(1:4);
    cf1_simul(1:4) = cf1(1:4);
    cf10_simul(1:4) = cf10(1:4);
    
    % Initialize diffcpicf (we simulate this as well since gcpi and cf1 are
    % endogenous)
    diffcpicf_simul = diffcpicf(1:4);

    % Also define 4 lags for exogenous variables
    grpe_shock_series = grpe(1:4);
    grpf_shock_series(1:4) = grpf(1:4);
    vu_shock_series(1:4) = vu(1:4);
    shortage_shock_series(1:4) = shortage(1:4);
    
    % Initialize shocks and how fast they return to steady state. Rho denotes
    % how fast they return (0 indicates a 1-period shock, 1 denotes a
    % persistent shock)
    shock_grpe = zeros(1,4);
    shock_grpf = zeros(1,4);
    shock_vu = zeros(1,4);
    shock_shortage = zeros(1,4);
    shock_gw = zeros(1,4);
    shock_gcpi = zeros(1,4);
    shock_cf1 = zeros(1,4);
    shock_cf10 = zeros(1,4);
    
    rho_grpe = 0.0;
    rho_grpf = 0.0;
    rho_vu = 1.0;
    rho_shortage = 0.0;
    rho_gw = 0.0;
    rho_gcpi = 0.0;
    rho_cf1 = 0.0;
    rho_cf10 = 0.0;
    
    % Initialize cell array of shocks added
    shocks_added = {};
    step = 1;
    if add_grpe_shock
        shocks_added{step} = "grpe";
        step = step + 1;
    end
    
    if add_grpf_shock
        shocks_added{step} = "grpf";
        step = step + 1;
    end
    
    if add_vu_shock
        shocks_added{step} = "vu";
        step = step + 1;
    end
    
    if add_shortage_shock
        shocks_added{step} = "shortage";
        step = step + 1;
    end
    
    if add_gw_shock
        shocks_added{step} = "gw";
        step = step + 1;
    end
    
    if add_gcpi_shock
        shocks_added{step} = "gcpi";
        step = step + 1;
    end
    
    if add_cf1_shock
        shocks_added{step} = "cf1";
        step = step + 1;
    end
    
    if add_cf10_shock
        shocks_added{step} = "cf10";
        step = step + 1;
    end

    % Get text of all shocks added
    shocks_added_text = "";
    is_first = true;
    if add_grpe_shock
        if ~is_first
            shocks_added_text = shocks_added_text + "_";
        end
        shocks_added_text  = shocks_added_text + "grpe";
        is_first = false;
    end
    
    if add_grpf_shock
        if ~is_first
            shocks_added_text = shocks_added_text + "_";
        end
        shocks_added_text  = shocks_added_text + "grpf";
        is_first = false;
    end
    
    if add_vu_shock
        if ~is_first
            shocks_added_text = shocks_added_text + "_";
        end
        shocks_added_text  = shocks_added_text + "vu";
        is_first = false;
    end
    
    if add_shortage_shock
        if ~is_first
            shocks_added_text = shocks_added_text + "_";
        end
        shocks_added_text  = shocks_added_text + "shortage";
        is_first = false;
    end

    if add_gw_shock
        if ~is_first
            shocks_added_text = shocks_added_text + "_";
        end
        shocks_added_text  = shocks_added_text + "gw";
        is_first = false;
    end

    if add_gcpi_shock
        if ~is_first
            shocks_added_text = shocks_added_text + "_";
        end
        shocks_added_text  = shocks_added_text + "gcpi";
        is_first = false;
    end

    if add_cf1_shock
        if ~is_first
            shocks_added_text = shocks_added_text + "_";
        end
        shocks_added_text  = shocks_added_text + "cf1";
        is_first = false;
    end

    if add_cf10_shock
        if ~is_first
            shocks_added_text = shocks_added_text + "_";
        end
        shocks_added_text  = shocks_added_text + "cf10";
        is_first = false;
    end

    if shocks_added_text == ""
        shocks_added_text = "no_shocks_added";
    end
    
    % Initialize shock value
    shock_val_grpe = 1*std(table_q4_data.grpe, "omitnan");
    shock_val_grpf = 1*std(table_q4_data.grpf, "omitnan");
    shock_val_vu = 1*std(table_q4_data.vu, "omitnan");
    shock_val_shortage = 1*std(table_q4_data.shortage, "omitnan");
    shock_val_gw_residual = 1*std(table_q4_data.gw_residuals, "omitnan");
    shock_val_gcpi_residual = 1*std(table_q4_data.gcpi_residuals, "omitnan");
    shock_val_cf1_residual = 1*std(table_q4_data.cf1_residuals, "omitnan");
    shock_val_cf10_residual = 1*std(table_q4_data.cf10_residuals, "omitnan");
    
    % Run simulation
    for t = 5:timesteps
        % Equation adding shocks. It equals zero unless the specified
        % conditions are met.
        
        shock_grpe(t) = 0;
        shock_grpf(t) = 0;
        shock_vu(t) = 0;
        shock_shortage(t) = 0;
        shock_gw(t) = 0;
        shock_gcpi(t) = 0;
        shock_cf1(t) = 0;
        shock_cf10(t) = 0;
    
        if add_grpe_shock & t == 5 % one time increase to rate, i.e. permanent incrase in level
            shock_grpe(t) = shock_val_grpe;
        end
    
        if add_grpf_shock & t == 5 % one time increase to rate, i.e. permanent incrase in level
            shock_grpf(t) = shock_val_grpf;
        end
    
        if add_vu_shock & t == 5 % permanent increase in level (due to rho)
            shock_vu(t) = shock_val_vu;
        end
    
        if add_shortage_shock & t == 5 % one time increase
            shock_shortage(t) = shock_val_shortage;
        end
    
        if add_gw_shock & t == 5 % one time increase
            shock_gw(t) = shock_val_gw_residual;
        end
    
        if add_gcpi_shock & t == 5 % one time increase
            shock_gcpi(t) = shock_val_gcpi_residual;
        end
    
        if add_cf1_shock & t == 5 % one time increase
            shock_cf1(t) = shock_val_cf1_residual;
        end
    
        if add_cf10_shock & t == 5 % one time increase
            shock_cf10(t) = shock_val_cf10_residual;
        end
    
        grpe_shock_series(t) = rho_grpe*grpe_shock_series(t-1) + shock_grpe(t);
        grpf_shock_series(t) = rho_grpf*grpf_shock_series(t-1) + shock_grpf(t);
        vu_shock_series(t) = rho_vu*vu_shock_series(t-1) + shock_vu(t);
        shortage_shock_series(t) = rho_shortage*shortage_shock_series(t-1) + shock_shortage(t);
    
        % Equations
    
        if add_gw_shock & t == 5
            gw_simul(t) = rho_gw*gw_simul(t-1) + shock_gw(t);
        else
            gw_simul(t) = gw_beta.beta(1)*gw_simul(t-1)+...
            gw_beta.beta(2)*gw_simul(t-2)+...
            gw_beta.beta(3)*gw_simul(t-3) + gw_beta.beta(4)*gw_simul(t-4)+...
            gw_beta.beta(5)*cf1_simul(t-1) + gw_beta.beta(6)*cf1_simul(t-2) +...
            gw_beta.beta(7)*cf1_simul(t-3) + gw_beta.beta(8)*cf1_simul(t-4)+...
            gw_beta.beta(9)*magpty(t-1) + gw_beta.beta(10)*vu_shock_series(t-1) + gw_beta.beta(11)*vu_shock_series(t-2)+...
            gw_beta.beta(12)*vu_shock_series(t-3) + gw_beta.beta(13)*vu_shock_series(t-4) +...
            gw_beta.beta(14)*diffcpicf_simul(t-1) + gw_beta.beta(15)*diffcpicf_simul(t-2)+...
            gw_beta.beta(16)*diffcpicf_simul(t-3)+...
            gw_beta.beta(17)*diffcpicf_simul(t-4);
        end
    
        if add_gcpi_shock & t == 5
            gcpi_simul(t) = rho_gcpi*gcpi_simul(t-1) + shock_gcpi(t);
        else
            gcpi_simul(t) =  gcpi_beta.beta(1)*magpty(t) +...
            gcpi_beta.beta(2)*gcpi_simul(t-1) + gcpi_beta.beta(3)*gcpi_simul(t-2) +...
            gcpi_beta.beta(4)*gcpi_simul(t-3) + gcpi_beta.beta(5)*gcpi_simul(t-4) + ...
            gcpi_beta.beta(6)*gw_simul(t) + gcpi_beta.beta(7)*gw_simul(t-1)+...
            gcpi_beta.beta(8)*gw_simul(t-2) +...
            gcpi_beta.beta(9)*gw_simul(t-3) + gcpi_beta.beta(10)*gw_simul(t-4) +...
            gcpi_beta.beta(11)*grpe_shock_series(t) + gcpi_beta.beta(12)*grpe_shock_series(t-1) +...
            gcpi_beta.beta(13)*grpe_shock_series(t-2) + gcpi_beta.beta(14)*grpe_shock_series(t-3) + gcpi_beta.beta(15)*grpe_shock_series(t-4) +...
            gcpi_beta.beta(16)*grpf_shock_series(t) + gcpi_beta.beta(17)*grpf_shock_series(t-1) + gcpi_beta.beta(18)*grpf_shock_series(t-2) +...
            gcpi_beta.beta(19)*grpf_shock_series(t-3) + gcpi_beta.beta(20)*grpf_shock_series(t-4) +...
            gcpi_beta.beta(21)*shortage_shock_series(t) + gcpi_beta.beta(22)*shortage_shock_series(t-1) +...
            gcpi_beta.beta(23)*shortage_shock_series(t-2) + gcpi_beta.beta(24)*shortage_shock_series(t-3) +...
            gcpi_beta.beta(25)*shortage_shock_series(t-4);
        end
    
        diffcpicf_simul(t) = 0.25*(gcpi_simul(t) + gcpi_simul(t-1) +...
            gcpi_simul(t-2) + gcpi_simul(t-3)) - cf1_simul(t-4);
    
        if add_cf10_shock & t == 5
            cf10_simul(t) = rho_cf10*cf10_simul(t-1) + shock_cf10(t);
        else
            cf10_simul(t) = cf10_beta.beta(1)*cf10_simul(t-1) +...
            cf10_beta.beta(2)*cf10_simul(t-2) +...
            cf10_beta.beta(3)*cf10_simul(t-3) + cf10_beta.beta(4)*cf10_simul(t-4) +...
            cf10_beta.beta(5)*gcpi_simul(t) + cf10_beta.beta(6)*gcpi_simul(t-1) +...
            cf10_beta.beta(7)*gcpi_simul(t-2) +...
            cf10_beta.beta(8)*gcpi_simul(t-3) + cf10_beta.beta(9)*gcpi_simul(t-4);
        end
        
        if add_cf1_shock & t == 5
            cf1_simul(t) = rho_cf1*cf1_simul(t-1) + shock_cf1(t);
        else
            cf1_simul(t) = cf1_beta.beta(1)*cf1_simul(t-1)+...
            cf1_beta.beta(2)*cf1_simul(t-2)+...
            cf1_beta.beta(3)*cf1_simul(t-3)+ cf1_beta.beta(4)*cf1_simul(t-4)+...
            cf1_beta.beta(5)*cf10_simul(t)+ cf1_beta.beta(6)*cf10_simul(t-1)+...
            cf1_beta.beta(7)*cf10_simul(t-2)+...
            cf1_beta.beta(8)*cf10_simul(t-3) + cf1_beta.beta(9)*cf10_simul(t-4)+...
            cf1_beta.beta(10)*gcpi_simul(t) + cf1_beta.beta(11)*gcpi_simul(t-1)+...
            cf1_beta.beta(12)*gcpi_simul(t-2)+...
            cf1_beta.beta(13)*gcpi_simul(t-3) + cf1_beta.beta(14)*gcpi_simul(t-4);
        end
    end
    
    %% Save data
    results.(shocks_added_text).timestep = (1:timesteps).';
    results.(shocks_added_text).gw = gw.';
    results.(shocks_added_text).gcpi = gcpi.';
    results.(shocks_added_text).cf1 = cf1.';
    results.(shocks_added_text).cf10 = cf10.';
    results.(shocks_added_text).magpty = magpty.';
    results.(shocks_added_text).diffcpicf = diffcpicf.';
    results.(shocks_added_text).grpe = grpe.';
    results.(shocks_added_text).grpf = grpf.';
    results.(shocks_added_text).vu = vu.';
    results.(shocks_added_text).shortage = shortage.';

    results.(shocks_added_text).gw_simul = gw_simul.';
    results.(shocks_added_text).gcpi_simul = gcpi_simul.';
    results.(shocks_added_text).cf1_simul = cf1_simul.';
    results.(shocks_added_text).cf10_simul = cf10_simul.';
    results.(shocks_added_text).diffcpicf_simul =  diffcpicf_simul.';
    results.(shocks_added_text).grpe_shock_series = grpe_shock_series.';
    results.(shocks_added_text).grpf_shock_series = grpf_shock_series.';
    results.(shocks_added_text).vu_shock_series = vu_shock_series.';
    results.(shocks_added_text).shortage_shock_series = shortage_shock_series.';
    
    % Note: shock_gw and shock_{endogenous_var} only represent one-time
    % shocks. It doesn't capture the dynamics of rho (which as of now,
    % don't matter since rho = 0 for these vars). But if rho ever does not
    % equal 0, make sure that this is fixed.
    results.(shocks_added_text).shock_gw = shock_gw.';
    results.(shocks_added_text).shock_gcpi = shock_gcpi.';
    results.(shocks_added_text).shock_cf1 = shock_cf1.';
    results.(shocks_added_text).shock_cf10 = shock_cf10.';

    cd(base_dir)
    cd("..\..\data/output_data")

    sheet_data = struct2table(results.(shocks_added_text));
    sheet_name = shocks_added_text;
    if strlength(sheet_name) > 31
        sheet_name = extractBefore(sheet_name, 31); % Excel tabs support max length of 31
    end
    writetable(sheet_data, "empirical_model_irf_results.xls", "Sheet", sheet_name,...
        'WriteVariableNames', true)

    if update_graphs
    %% Graph gw
    plot(1:timesteps, gw, 'LineWidth', 1.5)
    hold on
    plot(1:timesteps, gw_simul, 'LineWidth', 1.5)
    
    legend({'Steady State','Shock Introduced'}, 'FontSize', 12, 'Location', 'northeast')
    set(legend,'color','none');
    xlabel('Period', 'FontSize', 12)
    ylabel('Percent', 'FontSize', 12)
    grid on

    % Add text denoting what shocks were introduced:
    shock_text = "Shocks added: ";
    
    for step = 1:size(shocks_added,2)
        shock_text = shock_text + shocks_added(step) + "  ";
    end
    
    annotation('textbox',[.9 .75 .1 .2], ...
        'String', shock_text,'EdgeColor','none');
    
    % Save figure
    cd(base_dir);
    cd("..\..\figures\pngs\simulation_full_irfs");
    
    shock_folder = "";
    if size(shocks_added, 2) ~= 0
        for step = 1:size(shocks_added, 2)
            if step ==1
    
                shock_folder = shock_folder + shocks_added{step};
            else
                shock_folder = shock_folder + "_" + shocks_added{step};
            end
        end
        cd(shock_folder);
    end
    
    if shock_folder == ""
        cd("no_shocks")
    end
   
    title("gw IRF", 'FontSize', 14)
    print("gw", "-dpng", "-r150")

    clf
    
    %% Graph gcpi
    plot(1:timesteps, gcpi, 'LineWidth', 1.5)
    hold on
    plot(1:timesteps, gcpi_simul, 'LineWidth', 1.5)
    
    legend({'Steady State','Shock Introduced'}, 'FontSize', 12, 'Location', 'northeast')
    set(legend,'color','none');
    xlabel('Period', 'FontSize', 12)
    ylabel('Percent', 'FontSize', 12)
    grid on
    
    % Add text denoting what shocks were introduced:
    shock_text = "Shocks added: ";
    
    for step = 1:size(shocks_added,2)
        shock_text = shock_text + shocks_added(step) + "  ";
    end
    
    annotation('textbox',[.9 .75 .1 .2], ...
        'String', shock_text,'EdgeColor','none');
    
    % Save figure
    cd(base_dir);
    cd("..\..\figures\pngs\simulation_full_irfs");
    
    shock_folder = "";
    if size(shocks_added, 2) ~= 0
        for step = 1:size(shocks_added, 2)
            if step ==1
    
                shock_folder = shock_folder + shocks_added{step};
            else
                shock_folder = shock_folder + "_" + shocks_added{step};
            end
        end
        cd(shock_folder);
    end
    
    if shock_folder == ""
        cd("no_shocks")
    end

    title("gcpi IRF", 'FontSize', 14)
    print("gcpi", "-dpng", "-r150")

    clf
    
    %% Graph cf10
    plot(1:timesteps, cf10, 'LineWidth', 1.5)
    hold on
    plot(1:timesteps, cf10_simul, 'LineWidth', 1.5)
    
    legend({'Steady State','Shock Introduced'}, 'FontSize', 12, 'Location', 'northeast')
    set(legend,'color','none');
    xlabel('Period', 'FontSize', 12)
    ylabel('Percent', 'FontSize', 12)
    grid on
    
    % Add text denoting what shocks were introduced:
    shock_text = "Shocks added: ";
    
    for step = 1:size(shocks_added,2)
        shock_text = shock_text + shocks_added(step) + "  ";
    end
    
    annotation('textbox',[.9 .75 .1 .2], ...
        'String', shock_text,'EdgeColor','none');
    
    % Save figure
    cd(base_dir);
    cd("..\..\figures\pngs\simulation_full_irfs");
    
    shock_folder = "";
    if size(shocks_added, 2) ~= 0
        for step = 1:size(shocks_added, 2)
            if step ==1
    
                shock_folder = shock_folder + shocks_added{step};
            else
                shock_folder = shock_folder + "_" + shocks_added{step};
            end
        end
        cd(shock_folder);
    end
    
    if shock_folder == ""
        cd("no_shocks")
    end

    title("cf10 IRF", 'FontSize', 14)
    print("cf10", "-dpng", "-r150")

    clf
    
    %% Graph cf1
    plot(1:timesteps, cf1, 'LineWidth', 1.5)
    hold on
    plot(1:timesteps, cf1_simul, 'LineWidth', 1.5)
    
    legend({'Steady State','Shock Introduced'}, 'FontSize', 12, 'Location', 'northeast')
    set(legend,'color','none');
    xlabel('Period', 'FontSize', 12)
    ylabel('Percent', 'FontSize', 12)
    grid on
    
    % Add text denoting what shocks were introduced:
    shock_text = "Shocks added: ";
    
    for step = 1:size(shocks_added,2)
        shock_text = shock_text + shocks_added(step) + "  ";
    end
    
    annotation('textbox',[.9 .75 .1 .2], ...
        'String', shock_text,'EdgeColor','none');
    
    annotation('textbox',[.9 .75 .1 .2], ...
        'String', shock_text,'EdgeColor','none');
    
    % Save figure
    cd(base_dir);
    cd("..\..\figures\pngs\simulation_full_irfs");
    
    shock_folder = "";
    if size(shocks_added, 2) ~= 0
        for step = 1:size(shocks_added, 2)
            if step ==1
    
                shock_folder = shock_folder + shocks_added{step};
            else
                shock_folder = shock_folder + "_" + shocks_added{step};
            end
        end
        cd(shock_folder);
    end
    
    if shock_folder == ""
        cd("no_shocks")
    end

    title("cf1 IRF", 'FontSize', 14)
    print("cf1", "-dpng", "-r150")

    clf
    
    %% Graph diffcpicf (note that this is purely endogenous and not an outcome
    % variable)
    plot(1:timesteps, diffcpicf, 'LineWidth', 1.5)
    hold on
    plot(1:timesteps, diffcpicf_simul, 'LineWidth', 1.5)
    
    legend({'Steady State','Shock Introduced'}, 'FontSize', 12, 'Location', 'northeast')
    set(legend,'color','none');
    xlabel('Period', 'FontSize', 12)
    ylabel('Percent', 'FontSize', 12)
    grid on
    
    % Add text denoting what shocks were introduced:
    shock_text = "Shocks added: ";
    
    for step = 1:size(shocks_added,2)
        shock_text = shock_text + shocks_added(step) + "  ";
    end
    
    annotation('textbox',[.9 .75 .1 .2], ...
        'String', shock_text,'EdgeColor','none');
    
    % Save figure
    cd(base_dir);
    cd("..\..\figures\pngs\simulation_full_irfs");
    
    shock_folder = "";
    if size(shocks_added, 2) ~= 0
        for step = 1:size(shocks_added, 2)
            if step ==1
    
                shock_folder = shock_folder + shocks_added{step};
            else
                shock_folder = shock_folder + "_" + shocks_added{step};
            end
        end
        cd(shock_folder);
    end
    
    if shock_folder == ""
        cd("no_shocks")
    end
    
    title("diffcpicf IRF", 'FontSize', 14)
    print("diffcpicf", "-dpng", "-r150")

    clf
    
    %% Graph shock_gw
%     steady_state_gw_array = zeros(timesteps, 1).';
    plot(1:timesteps, gw, 'LineWidth', 1.5)
    hold on
    plot(1:timesteps, shock_gw, 'LineWidth', 1.5)
    
    legend({'Steady State Value','Shock Value'}, 'FontSize', 12, 'Location', 'northeast')
    set(legend,'color','none');
    xlabel('Period', 'FontSize', 12)
    ylabel('Percent', 'FontSize', 12)
    grid on
    
    % Add text denoting what shocks were introduced:
    shock_text = "Shocks added: ";
    
    for step = 1:size(shocks_added,2)
        shock_text = shock_text + shocks_added(step) + "  ";
    end
    
    annotation('textbox',[.9 .75 .1 .2], ...
        'String', shock_text,'EdgeColor','none');
    
    % Save figure
    cd(base_dir);
    cd("..\..\figures\pngs\simulation_full_irfs");
    
    shock_folder = "";
    if size(shocks_added, 2) ~= 0
        for step = 1:size(shocks_added, 2)
            if step ==1
    
                shock_folder = shock_folder + shocks_added{step};
            else
                shock_folder = shock_folder + "_" + shocks_added{step};
            end
        end
        cd(shock_folder);
    end
    
    if shock_folder == ""
        cd("no_shocks")
    end

    title("gw shock", 'FontSize', 14)
    print("gw_shock", "-dpng", "-r150")
   
    clf
    
    %% Graph shock_gcpi
%     steady_state_gcpi_array = zeros(timesteps, 1).';
    plot(1:timesteps, gcpi, 'LineWidth', 1.5)
    hold on
    plot(1:timesteps, shock_gcpi, 'LineWidth', 1.5)
    
    legend({'Steady State Value','Shock Value'}, 'FontSize', 12, 'Location', 'northeast')
    set(legend,'color','none');
    xlabel('Period', 'FontSize', 12)
    ylabel('Percent', 'FontSize', 12)
    grid on
    
    % Add text denoting what shocks were introduced:
    shock_text = "Shocks added: ";
    
    for step = 1:size(shocks_added,2)
        shock_text = shock_text + shocks_added(step) + "  ";
    end
    
    annotation('textbox',[.9 .75 .1 .2], ...
        'String', shock_text,'EdgeColor','none');
    
    % Save figure
    cd(base_dir);
    cd("..\..\figures\pngs\simulation_full_irfs");
    
    shock_folder = "";
    if size(shocks_added, 2) ~= 0
        for step = 1:size(shocks_added, 2)
            if step ==1
    
                shock_folder = shock_folder + shocks_added{step};
            else
                shock_folder = shock_folder + "_" + shocks_added{step};
            end
        end
        cd(shock_folder);
    end
    
    if shock_folder == ""
        cd("no_shocks")
    end

    title("gcpi shock", 'FontSize', 14)     
    print("gcpi_shock", "-dpng", "-r150")
       
    clf
    
    %% Graph shock_cf10
%     steady_state_cf10_array = zeros(timesteps, 1).';
    plot(1:timesteps, cf10, 'LineWidth', 1.5)
    hold on
    plot(1:timesteps, shock_cf10, 'LineWidth', 1.5)
    
    legend({'Steady State Value','Shock Value'}, 'FontSize', 12, 'Location', 'northeast')
    set(legend,'color','none');
    xlabel('Period', 'FontSize', 12)
    ylabel('Percent', 'FontSize', 12)
    grid on
    
    % Add text denoting what shocks were introduced:
    shock_text = "Shocks added: ";
    
    for step = 1:size(shocks_added,2)
        shock_text = shock_text + shocks_added(step) + "  ";
    end
    
    annotation('textbox',[.9 .75 .1 .2], ...
        'String', shock_text,'EdgeColor','none');
    
    % Save figure
    cd(base_dir);
    cd("..\..\figures\pngs\simulation_full_irfs");
    
    shock_folder = "";
    if size(shocks_added, 2) ~= 0
        for step = 1:size(shocks_added, 2)
            if step ==1
    
                shock_folder = shock_folder + shocks_added{step};
            else
                shock_folder = shock_folder + "_" + shocks_added{step};
            end
        end
        cd(shock_folder);
    end
    
    if shock_folder == ""
        cd("no_shocks")
    end  

    title("cf10 shock", 'FontSize', 14)  
    print("cf10_shock", "-dpng", "-r150")
       
    clf
    
    %% Graph shock_cf1
%     steady_state_cf1_array = zeros(timesteps, 1).';
    plot(1:timesteps, cf1, 'LineWidth', 1.5)
    hold on
    plot(1:timesteps, shock_cf1, 'LineWidth', 1.5)
    
    legend({'Steady State Value','Shock Value'}, 'FontSize', 12, 'Location', 'northeast')
    set(legend,'color','none');
    xlabel('Period', 'FontSize', 12)
    ylabel('Percent', 'FontSize', 12)
    grid on
    
    % Add text denoting what shocks were introduced:
    shock_text = "Shocks added: ";
    
    for step = 1:size(shocks_added,2)
        shock_text = shock_text + shocks_added(step) + "  ";
    end
    
    annotation('textbox',[.9 .75 .1 .2], ...
        'String', shock_text,'EdgeColor','none');
    
    % Save figure
    cd(base_dir);
    cd("..\..\figures\pngs\simulation_full_irfs");
    
    shock_folder = "";
    if size(shocks_added, 2) ~= 0
        for step = 1:size(shocks_added, 2)
            if step ==1
    
                shock_folder = shock_folder + shocks_added{step};
            else
                shock_folder = shock_folder + "_" + shocks_added{step};
            end
        end
        cd(shock_folder);
    end
    
    if shock_folder == ""
        cd("no_shocks")
    end

    title("cf1 shock", 'FontSize', 14)       
    print("cf1_shock", "-dpng", "-r150")
       
    clf
    
    %% Graph shock_grpe
    steady_state_grpe_array = zeros(timesteps, 1).';
    plot(1:timesteps, grpe, 'LineWidth', 1.5)
    hold on
    plot(1:timesteps, grpe_shock_series, 'LineWidth', 1.5)
    
    legend({'Steady State Value','Shock Value'}, 'FontSize', 12, 'Location', 'northeast')
    set(legend,'color','none');
    xlabel('Period', 'FontSize', 12)
    ylabel('Percent', 'FontSize', 12)
    grid on
    
    % Add text denoting what shocks were introduced:
    shock_text = "Shocks added: ";
    
    for step = 1:size(shocks_added,2)
        shock_text = shock_text + shocks_added(step) + "  ";
    end
    
    annotation('textbox',[.9 .75 .1 .2], ...
        'String', shock_text,'EdgeColor','none');
    
    % Save figure
    cd(base_dir);
    cd("..\..\figures\pngs\simulation_full_irfs");
    
    shock_folder = "";
    if size(shocks_added, 2) ~= 0
        for step = 1:size(shocks_added, 2)
            if step ==1
    
                shock_folder = shock_folder + shocks_added{step};
            else
                shock_folder = shock_folder + "_" + shocks_added{step};
            end
        end
        cd(shock_folder);
    end
    
    if shock_folder == ""
        cd("no_shocks")
    end

    title("grpe shock", 'FontSize', 14)          
    print("grpe_shock", "-dpng", "-r150")
    
    clf
    
    %% Graph shock_grpf
%     steady_state_grpf_array = zeros(timesteps, 1).';
    plot(1:timesteps, grpf, 'LineWidth', 1.5)
    hold on
    plot(1:timesteps, grpf_shock_series, 'LineWidth', 1.5)
    
    legend({'Steady State Value','Shock Value'}, 'FontSize', 12, 'Location', 'northeast')
    set(legend,'color','none');
    xlabel('Period', 'FontSize', 12)
    ylabel('Percent', 'FontSize', 12)
    grid on
    
    % Add text denoting what shocks were introduced:
    shock_text = "Shocks added: ";
    
    for step = 1:size(shocks_added,2)
        shock_text = shock_text + shocks_added(step) + "  ";
    end
    
    annotation('textbox',[.9 .75 .1 .2], ...
        'String', shock_text,'EdgeColor','none');
    
    % Save figure
    cd(base_dir);
    cd("..\..\figures\pngs\simulation_full_irfs");
    
    shock_folder = "";
    if size(shocks_added, 2) ~= 0
        for step = 1:size(shocks_added, 2)
            if step ==1
    
                shock_folder = shock_folder + shocks_added{step};
            else
                shock_folder = shock_folder + "_" + shocks_added{step};
            end
        end
        cd(shock_folder);
    end
    
    if shock_folder == ""
        cd("no_shocks")
    end

    title("grpf shock", 'FontSize', 14)  
    print("grpf_shock", "-dpng", "-r150")
   
    clf
    
    %% Graph shock_vu
%     steady_state_vu_array = zeros(timesteps, 1).';
    plot(1:timesteps, vu, 'LineWidth', 1.5)
    hold on
    plot(1:timesteps, vu_shock_series, 'LineWidth', 1.5)
    
    legend({'Steady State Value','Shock Value'}, 'FontSize', 12, 'Location', 'northeast')
    set(legend,'color','none');
    xlabel('Period', 'FontSize', 12)
    ylabel('Percent', 'FontSize', 12)
    grid on
    
    % Add text denoting what shocks were introduced:
    shock_text = "Shocks added: ";
    
    for step = 1:size(shocks_added,2)
        shock_text = shock_text + shocks_added(step) + "  ";
    end
    
    annotation('textbox',[.9 .75 .1 .2], ...
        'String', shock_text,'EdgeColor','none');
    
    % Save figure
    cd(base_dir);
    cd("..\..\figures\pngs\simulation_full_irfs");
    
    shock_folder = "";
    if size(shocks_added, 2) ~= 0
        for step = 1:size(shocks_added, 2)
            if step ==1
    
                shock_folder = shock_folder + shocks_added{step};
            else
                shock_folder = shock_folder + "_" + shocks_added{step};
            end
        end
        cd(shock_folder);
    end
    
    if shock_folder == ""
        cd("no_shocks")
    end

    title("vu shock", 'FontSize', 14)  
    print("vu_shock", "-dpng", "-r150")
   
    clf
    
    %% Graph shock_shortage
%     steady_state_shortage_array = zeros(timesteps, 1).';
    plot(1:timesteps, shortage, 'LineWidth', 1.5)
    hold on
    plot(1:timesteps, shortage_shock_series, 'LineWidth', 1.5)
    
    legend({'Steady State Value','Shock Value'}, 'FontSize', 12, 'Location', 'northeast')
    xlabel('Period', 'FontSize', 12)
    ylabel('Percent', 'FontSize', 12)
    grid on
    
    % Add text denoting what shocks were introduced:
    shock_text = "Shocks added: ";
    
    for step = 1:size(shocks_added,2)
        shock_text = shock_text + shocks_added(step) + "  ";
    end
    
    annotation('textbox',[.9 .75 .1 .2], ...
        'String', shock_text,'EdgeColor','none');
    
    % Save figure
    cd(base_dir);
    cd("..\..\figures\pngs\simulation_full_irfs");
    
    shock_folder = "";
    if size(shocks_added, 2) ~= 0
        for step = 1:size(shocks_added, 2)
            if step ==1
    
                shock_folder = shock_folder + shocks_added{step};
            else
                shock_folder = shock_folder + "_" + shocks_added{step};
            end
        end
        cd(shock_folder);
    end
    
    if shock_folder == ""
    cd("no_shocks")
    end
    
    title("shortage shock", 'FontSize', 14)   
    print("shortage_shock", "-dpng", "-r150")
       
    clf
    end
end
cd(base_dir)