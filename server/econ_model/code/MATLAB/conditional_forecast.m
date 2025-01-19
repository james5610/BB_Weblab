%% Readme
% This script defines the model off of which we produce conditional
% forecasts. To run the actual model, please run the file
% "run_conditional_forecasts.m"
%
% A quick introduction on naming conventions:
% Variables with no suffixes, e.g. gw, gcpi, represent vars
% that are equal to the actual historical value. 
%
% Variables ending in _simul are those produced by the model.The first four 
% values are initialized to equal actual historical data (since we are
% working with 4 lags). After that, we run our model under the assumption
% that grpe and grpf are 0 and that our shortage variable is 5.
%
% Please contact James Lee (Brookings Institution) or Athiana Tettaravou
% (Peterson Institute) for further questions.

function results = conditional_forecast(data, vu_decline_val,...
    vu_quarters_decline, update_graphs)

base_dir = pwd();
png_dir = pwd() + "\..\..\figures\pngs\cond_forecast";

%% Format data
data_orig = data;
data = data(data.period >= datetime(2022,4,1), :);
period = data.period.';

%% Define length of forecast model
% This represents the number of years to run the forecast over. 
forecast_num_years = 10;
timesteps = size(data,1) + 4*forecast_num_years;

%% Get coefficients
cd("..\..\data\intermediate_data")
format long
gw_beta = readtable("eq_coefficients", 'Sheet', "gw");
gcpi_beta = readtable("eq_coefficients", 'Sheet', "gcpi");
cf1_beta = readtable("eq_coefficients", 'Sheet', "cf1");
cf10_beta = readtable("eq_coefficients", 'Sheet', "cf10");
cd(base_dir);

%% Initialize data
gw = data.gw.';
gcpi = data.gcpi.';
cf1 = data.cf1.';
cf10 = data.cf10.';
diffcpicf = data.diffcpicf.';

grpe = data.grpe.';
grpf = data.grpf.';
vu = data.vu.';
shortage = data.shortage.';
magpty = data.magpty.';

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

% Initialize shock variables for simulation.
grpe_simul = grpe;
grpf_simul = grpf;
vu_simul = vu;
shortage_simul = shortage;

%% Run forecast
vu_slope = (vu_decline_val-vu(4))/vu_quarters_decline;

for t = 5:timesteps
    % Set exogenous variables to desired values
    grpe_simul(t) = 0;
    grpf_simul(t) = 0;
    shortage_simul(t) = 10;

    if vu_slope >= 0
        vu_simul(t) = min(vu_decline_val, vu_simul(t-1) +...
        vu_slope);
    else
        vu_simul(t) = max(vu_decline_val, vu_simul(t-1) +...
        vu_slope);
    end

    % How labor productivity evolves
    magpty(t) = 1;

    % Update period 
    period(t) = period(t-1) +calmonths(3);
    
    %% Forecast equations
    gw_simul(t) = gw_beta.beta(1)*gw_simul(t-1)+...
    gw_beta.beta(2)*gw_simul(t-2)+...
    gw_beta.beta(3)*gw_simul(t-3) + gw_beta.beta(4)*gw_simul(t-4)+...
    gw_beta.beta(5)*cf1_simul(t-1) + gw_beta.beta(6)*cf1_simul(t-2) +...
    gw_beta.beta(7)*cf1_simul(t-3) + gw_beta.beta(8)*cf1_simul(t-4)+...
    gw_beta.beta(9)*magpty(t-1) + gw_beta.beta(10)*vu_simul(t-1) +...
    gw_beta.beta(11)*vu_simul(t-2)+...
    gw_beta.beta(12)*vu_simul(t-3) + gw_beta.beta(13)*vu_simul(t-4) +...
    gw_beta.beta(14)*diffcpicf_simul(t-1) +...
    gw_beta.beta(15)*diffcpicf_simul(t-2)+...
    gw_beta.beta(16)*diffcpicf_simul(t-3)+...
    gw_beta.beta(17)*diffcpicf_simul(t-4) +...
    -0.809701260051568; % Note: constant comes from wage_constant_calculations.xlsx for this equation only

    gcpi_simul(t) =  gcpi_beta.beta(1)*magpty(t) +...
    gcpi_beta.beta(2)*gcpi_simul(t-1) +...
    gcpi_beta.beta(3)*gcpi_simul(t-2) +...
    gcpi_beta.beta(4)*gcpi_simul(t-3) +...
    gcpi_beta.beta(5)*gcpi_simul(t-4) + ...
    gcpi_beta.beta(6)*gw_simul(t)+ gcpi_beta.beta(7)*gw_simul(t-1)+...
    gcpi_beta.beta(8)*gw_simul(t-2) +...
    gcpi_beta.beta(9)*gw_simul(t-3) + gcpi_beta.beta(10)*gw_simul(t-4) +...
    gcpi_beta.beta(11)*grpe_simul(t) +...
    gcpi_beta.beta(12)*grpe_simul(t-1) +...
    gcpi_beta.beta(13)*grpe_simul(t-2) + gcpi_beta.beta(14)*grpe_simul(t-3) +...
    gcpi_beta.beta(15)*grpe_simul(t-4) +...
    gcpi_beta.beta(16)*grpf_simul(t) +...
    gcpi_beta.beta(17)*grpf_simul(t-1) +...
    gcpi_beta.beta(18)*grpf_simul(t-2) +...
    gcpi_beta.beta(19)*grpf_simul(t-3) +...
    gcpi_beta.beta(20)*grpf_simul(t-4) +...
    gcpi_beta.beta(21)*shortage_simul(t) +...
    gcpi_beta.beta(22)*shortage_simul(t-1) +...
    gcpi_beta.beta(23)*shortage_simul(t-2) +...
    gcpi_beta.beta(24)*shortage_simul(t-3) +...
    gcpi_beta.beta(25)*shortage_simul(t-4) + gcpi_beta.beta(26);

    diffcpicf_simul(t) = 0.25*(gcpi_simul(t) + gcpi_simul(t-1) +...
    gcpi_simul(t-2) + gcpi_simul(t-3)) - cf1_simul(t-4);

    cf10_simul(t) = cf10_beta.beta(1)*cf10_simul(t-1) +...
    cf10_beta.beta(2)*cf10_simul(t-2) +...
    cf10_beta.beta(3)*cf10_simul(t-3) +...
    cf10_beta.beta(4)*cf10_simul(t-4) +...
    cf10_beta.beta(5)*gcpi_simul(t) +...
    cf10_beta.beta(6)*gcpi_simul(t-1) +...
    cf10_beta.beta(7)*gcpi_simul(t-2) +...
    cf10_beta.beta(8)*gcpi_simul(t-3) +...
    cf10_beta.beta(9)*gcpi_simul(t-4);

    cf1_simul(t) = cf1_beta.beta(1)*cf1_simul(t-1)+...
    cf1_beta.beta(2)*cf1_simul(t-2)+...
    cf1_beta.beta(3)*cf1_simul(t-3) +...
    cf1_beta.beta(4)*cf1_simul(t-4)+...
    cf1_beta.beta(5)*cf10_simul(t) +...
    cf1_beta.beta(6)*cf10_simul(t-1)+...
    cf1_beta.beta(7)*cf10_simul(t-2)+...
    cf1_beta.beta(8)*cf10_simul(t-3) +...
    cf1_beta.beta(9)*cf10_simul(t-4)+...
    cf1_beta.beta(10)*gcpi_simul(t) +...
    cf1_beta.beta(11)*gcpi_simul(t-1) +...
    cf1_beta.beta(12)*gcpi_simul(t-2) +...
    cf1_beta.beta(13)*gcpi_simul(t-3) +...
    cf1_beta.beta(14)*gcpi_simul(t-4);

end

%% Create a new variable to make plotting neater
qtr_lbls = string.empty;
% crosswalk = containers.Map([1, 2, 3, 4], ["Jan", "Apr", "Jul", "Oct"]);
for step = 1:timesteps
    lbl = period(step);
    lbl_year = num2str(year(lbl));
    lbl_quarter = num2str(quarter(lbl));
    qtr_lbls(step) = lbl_year + " Q" + lbl_quarter;
end

%% Export data
out_data = table(period.', qtr_lbls.', gw_simul.',...
    gcpi_simul.',...
    cf1_simul.',...
    cf10_simul.',...
    grpe_simul',...
    grpf_simul.',...
    vu_simul.',...
    shortage_simul.', ...
    'VariableNames',["period", "qtr_lbls", "gw_simul",...
    "gcpi_simul",...
    "cf1_simul",...
    "cf10_simul",...
    "grpe_simul",...
    "grpf_simul",...
    "vu_simul",...
    "shortage_simul"]);

%% Save data
cd(base_dir)
cd("..\..\data\output_data")


%% Store variables to results
% We transpose from rows to columns so that we can save more easily when
% exporting data
results.period = period.';
results.qtr_lbls = qtr_lbls.';
results.magpty = magpty.';
results.diffcpicf = diffcpicf.';
results.grpe = grpe_simul.';
results.grpf = grpf_simul.';
results.vu = vu_simul.';
results.shortage = shortage_simul.';
results.gw_simul = gw_simul.';
results.gcpi_simul = gcpi_simul.';
results.cf1_simul = cf1_simul.';
results.cf10_simul = cf10_simul.';
results.diffcpicf = diffcpicf_simul.';
results.grpe_simul = grpe_simul.';
results.grpf_simul = grpf_simul.';
results.vu_simul = vu_simul.';
results.shortage_simul = shortage_simul.';

if update_graphs
%% Graph gw
plot(period, gw_simul, 'LineWidth', 1.5)

legend({'Forecasted Series'}, 'FontSize', 12, 'Location', 'northwest')
set(legend,'color','none');
xlabel('Period', 'FontSize', 12)
ylabel('Percent', 'FontSize', 12)
grid on

% Save figure
cd(png_dir)

title('gw', 'FontSize', 14)
file_name = "vu_" + num2str(vu_decline_val) + "_" + "qtr_" +...
    vu_quarters_decline + "_gw_graph.png";
print(file_name, "-dpng", "-r150")

clf

%% Graph gcpi
plot(period, gcpi_simul, 'LineWidth', 1.5)

legend({'Forecasted Series'}, 'FontSize', 12, 'Location', 'northwest')
set(legend,'color','none');
xlabel('Period', 'FontSize', 12)
ylabel('Percent', 'FontSize', 12)
grid on

% Save figure
cd(png_dir)

title('gcpi', 'FontSize', 14)
file_name = "vu_" + num2str(vu_decline_val) + "_" + "qtr_" +...
    vu_quarters_decline + "_gcpi_graph.png";
print(file_name, "-dpng", "-r150")

clf

%% Graph cf10
plot(period, cf10_simul, 'LineWidth', 1.5)

legend({'Forecasted Series'}, 'FontSize', 12, 'Location', 'northwest')
set(legend,'color','none');
xlabel('Period', 'FontSize', 12)
ylabel('Percent', 'FontSize', 12)
grid on

% Save figure
cd(png_dir)

title('cf10', 'FontSize', 14)
file_name = "vu_" + num2str(vu_decline_val) + "_" + "qtr_" +...
    vu_quarters_decline + "_cf10_graph.png";
print(file_name, "-dpng", "-r150")

clf

%% Graph cf1
plot(period, cf1_simul, 'LineWidth', 1.5)

legend({'Forecasted Series'}, 'FontSize', 12, 'Location', 'northwest')
set(legend,'color','none');
xlabel('Period', 'FontSize', 12)
ylabel('Percent', 'FontSize', 12)
grid on

% Save figure
cd(png_dir)

title('cf1', 'FontSize', 14)
file_name = "vu_" + num2str(vu_decline_val) + "_" + "qtr_" +...
    vu_quarters_decline + "_cf1_graph.png";
print(file_name, "-dpng", "-r150")

clf

%% Graph diffcpicf
plot(period, diffcpicf_simul, 'LineWidth', 1.5)

legend({'Forecasted Series'}, 'FontSize', 12, 'Location', 'northwest')
set(legend,'color','none');
xlabel('Period', 'FontSize', 12)
ylabel('Percent', 'FontSize', 12)
grid on

% Save figure
cd(png_dir)

title('diffcpicf', 'FontSize', 14)
file_name = "vu_" + num2str(vu_decline_val) + "_" + "qtr_" +...
    vu_quarters_decline + "_diffcpicf_graph.png";
print(file_name, "-dpng", "-r150")

clf

%% Plot grpe
plot(period, grpe_simul, 'LineWidth', 1.5)

legend({'Forecasted Series'}, 'FontSize', 12, 'Location', 'northwest')
set(legend,'color','none');
xlabel('Period', 'FontSize', 12)
ylabel('Percent', 'FontSize', 12)
grid on

% Save figure
cd(png_dir)

title('grpe', 'FontSize', 14)
file_name = "vu_" + num2str(vu_decline_val) + "_" + "qtr_" +...
    vu_quarters_decline + "_grpe_graph.png";
print(file_name, "-dpng", "-r150")

clf

%% Plot grpf
plot(period, grpf_simul, 'LineWidth', 1.5)

legend({'Forecasted Series'}, 'FontSize', 12, 'Location', 'northwest')
set(legend,'color','none');
xlabel('Period', 'FontSize', 12)
ylabel('Percent', 'FontSize', 12)
grid on

% Save figure
cd(png_dir)

title('grpf', 'FontSize', 14)
file_name = "vu_" + num2str(vu_decline_val) + "_" + "qtr_" +...
    vu_quarters_decline + "_grpf_graph.png";
print(file_name, "-dpng", "-r150")

clf

%% Plot vu
plot(period, vu_simul, 'LineWidth', 1.5)

legend({'Forecasted Series'}, 'FontSize', 12, 'Location', 'northwest')
set(legend,'color','none');
xlabel('Period', 'FontSize', 12)
ylabel('Percent', 'FontSize', 12)
grid on

% Save figure
cd(png_dir)

title('vu', 'FontSize', 14)
file_name = "vu_" + num2str(vu_decline_val) + "_" + "qtr_" +...
    vu_quarters_decline + "_vu_graph.png";
print(file_name, "-dpng", "-r150")

clf

%% Plot shortage
plot(period, shortage_simul, 'LineWidth', 1.5)

legend({'Forecasted Series'}, 'FontSize', 12, 'Location', 'northwest')
set(legend,'color','none');
xlabel('Period', 'FontSize', 12)
ylabel('Percent', 'FontSize', 12)
grid on

% Save figure
cd(png_dir)

title('shortage', 'FontSize', 14)
file_name = "vu_" + num2str(vu_decline_val) + "_" + "qtr_" +...
    vu_quarters_decline + "_shortage_graph.png";
print(file_name, "-dpng", "-r150")
end
cd(base_dir)
end
