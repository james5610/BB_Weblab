%
% Status : main Dynare file
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

if isoctave || matlab_ver_less_than('8.6')
    clear all
else
    clearvars -global
    clear_persistent_variables(fileparts(which('dynare')), false)
end
tic0 = tic;
% Define global variables.
global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info ys0_ ex0_
options_ = [];
M_.fname = 'Simple_Eq_simulations_strong';
M_.dynare_version = '5.3';
oo_.dynare_version = '5.3';
options_.dynare_version = '5.3';
%
% Some global variables initialization
%
global_initialization;
M_.exo_names = cell(3,1);
M_.exo_names_tex = cell(3,1);
M_.exo_names_long = cell(3,1);
M_.exo_names(1) = {'eta_zw'};
M_.exo_names_tex(1) = {'eta\_zw'};
M_.exo_names_long(1) = {'eta_zw'};
M_.exo_names(2) = {'eta_zp'};
M_.exo_names_tex(2) = {'eta\_zp'};
M_.exo_names_long(2) = {'eta_zp'};
M_.exo_names(3) = {'eta_u'};
M_.exo_names_tex(3) = {'eta\_u'};
M_.exo_names_long(3) = {'eta_u'};
M_.endo_names = cell(10,1);
M_.endo_names_tex = cell(10,1);
M_.endo_names_long = cell(10,1);
M_.endo_names(1) = {'w'};
M_.endo_names_tex(1) = {'w'};
M_.endo_names_long(1) = {'w'};
M_.endo_names(2) = {'pe'};
M_.endo_names_tex(2) = {'pe'};
M_.endo_names_long(2) = {'pe'};
M_.endo_names(3) = {'p'};
M_.endo_names_tex(3) = {'p'};
M_.endo_names_long(3) = {'p'};
M_.endo_names(4) = {'pistar'};
M_.endo_names_tex(4) = {'pistar'};
M_.endo_names_long(4) = {'pistar'};
M_.endo_names(5) = {'u'};
M_.endo_names_tex(5) = {'u'};
M_.endo_names_long(5) = {'u'};
M_.endo_names(6) = {'zw'};
M_.endo_names_tex(6) = {'zw'};
M_.endo_names_long(6) = {'zw'};
M_.endo_names(7) = {'zp'};
M_.endo_names_tex(7) = {'zp'};
M_.endo_names_long(7) = {'zp'};
M_.endo_names(8) = {'pip'};
M_.endo_names_tex(8) = {'pip'};
M_.endo_names_long(8) = {'pip'};
M_.endo_names(9) = {'piw'};
M_.endo_names_tex(9) = {'piw'};
M_.endo_names_long(9) = {'piw'};
M_.endo_names(10) = {'AUX_ENDO_LAG_2_1'};
M_.endo_names_tex(10) = {'AUX\_ENDO\_LAG\_2\_1'};
M_.endo_names_long(10) = {'AUX_ENDO_LAG_2_1'};
M_.endo_partitions = struct();
M_.param_names = cell(7,1);
M_.param_names_tex = cell(7,1);
M_.param_names_long = cell(7,1);
M_.param_names(1) = {'beta'};
M_.param_names_tex(1) = {'beta'};
M_.param_names_long(1) = {'beta'};
M_.param_names(2) = {'alphaa'};
M_.param_names_tex(2) = {'alphaa'};
M_.param_names_long(2) = {'alphaa'};
M_.param_names(3) = {'be'};
M_.param_names_tex(3) = {'be'};
M_.param_names_long(3) = {'be'};
M_.param_names(4) = {'gamma'};
M_.param_names_tex(4) = {'gamma'};
M_.param_names_long(4) = {'gamma'};
M_.param_names(5) = {'rho_zw'};
M_.param_names_tex(5) = {'rho\_zw'};
M_.param_names_long(5) = {'rho_zw'};
M_.param_names(6) = {'rho_zp'};
M_.param_names_tex(6) = {'rho\_zp'};
M_.param_names_long(6) = {'rho_zp'};
M_.param_names(7) = {'rho_u'};
M_.param_names_tex(7) = {'rho\_u'};
M_.param_names_long(7) = {'rho_u'};
M_.param_partitions = struct();
M_.exo_det_nbr = 0;
M_.exo_nbr = 3;
M_.endo_nbr = 10;
M_.param_nbr = 7;
M_.orig_endo_nbr = 9;
M_.aux_vars(1).endo_index = 10;
M_.aux_vars(1).type = 1;
M_.aux_vars(1).orig_index = 3;
M_.aux_vars(1).orig_lead_lag = -1;
M_.aux_vars(1).orig_expr = 'p(-1)';
M_ = setup_solvers(M_);
M_.Sigma_e = zeros(3, 3);
M_.Correlation_matrix = eye(3, 3);
M_.H = 0;
M_.Correlation_matrix_ME = 1;
M_.sigma_e_is_diagonal = true;
M_.det_shocks = [];
M_.surprise_shocks = [];
M_.heteroskedastic_shocks.Qvalue_orig = [];
M_.heteroskedastic_shocks.Qscale_orig = [];
options_.linear = true;
options_.block = false;
options_.bytecode = false;
options_.use_dll = false;
M_.nonzero_hessian_eqs = [];
M_.hessian_eq_zero = isempty(M_.nonzero_hessian_eqs);
M_.orig_eq_nbr = 9;
M_.eq_nbr = 10;
M_.ramsey_eq_nbr = 0;
M_.set_auxiliary_variables = exist(['./+' M_.fname '/set_auxiliary_variables.m'], 'file') == 2;
M_.epilogue_names = {};
M_.epilogue_var_list_ = {};
M_.orig_maximum_endo_lag = 2;
M_.orig_maximum_endo_lead = 0;
M_.orig_maximum_exo_lag = 0;
M_.orig_maximum_exo_lead = 0;
M_.orig_maximum_exo_det_lag = 0;
M_.orig_maximum_exo_det_lead = 0;
M_.orig_maximum_lag = 2;
M_.orig_maximum_lead = 0;
M_.orig_maximum_lag_with_diffs_expanded = 2;
M_.lead_lag_incidence = [
 1 9;
 2 10;
 3 11;
 4 12;
 5 13;
 6 14;
 7 15;
 0 16;
 0 17;
 8 18;]';
M_.nstatic = 2;
M_.nfwrd   = 0;
M_.npred   = 8;
M_.nboth   = 0;
M_.nsfwrd   = 0;
M_.nspred   = 8;
M_.ndynamic   = 8;
M_.dynamic_tmp_nbr = [0; 0; 0; 0; ];
M_.model_local_variables_dynamic_tt_idxs = {
};
M_.equations_tags = {
  1 , 'name' , 'w' ;
  2 , 'name' , 'p' ;
  3 , 'name' , 'pe' ;
  4 , 'name' , 'pistar' ;
  5 , 'name' , 'zw' ;
  6 , 'name' , 'zp' ;
  7 , 'name' , 'u' ;
  8 , 'name' , 'pip' ;
  9 , 'name' , 'piw' ;
};
M_.mapping.w.eqidx = [1 2 9 ];
M_.mapping.pe.eqidx = [1 3 ];
M_.mapping.p.eqidx = [1 2 3 4 8 ];
M_.mapping.pistar.eqidx = [3 4 ];
M_.mapping.u.eqidx = [1 7 ];
M_.mapping.zw.eqidx = [1 5 ];
M_.mapping.zp.eqidx = [2 6 ];
M_.mapping.pip.eqidx = [8 ];
M_.mapping.piw.eqidx = [9 ];
M_.mapping.eta_zw.eqidx = [5 ];
M_.mapping.eta_zp.eqidx = [6 ];
M_.mapping.eta_u.eqidx = [7 ];
M_.static_and_dynamic_models_differ = false;
M_.has_external_function = false;
M_.state_var = [1 2 3 4 5 6 7 10 ];
M_.exo_names_orig_ord = [1:3];
M_.maximum_lag = 1;
M_.maximum_lead = 0;
M_.maximum_endo_lag = 1;
M_.maximum_endo_lead = 0;
oo_.steady_state = zeros(10, 1);
M_.maximum_exo_lag = 0;
M_.maximum_exo_lead = 0;
oo_.exo_steady_state = zeros(3, 1);
M_.params = NaN(7, 1);
M_.endo_trends = struct('deflator', cell(10, 1), 'log_deflator', cell(10, 1), 'growth_factor', cell(10, 1), 'log_growth_factor', cell(10, 1));
M_.NNZDerivatives = [36; 0; -1; ];
M_.static_tmp_nbr = [0; 0; 0; 0; ];
M_.model_local_variables_static_tt_idxs = {
};
close all;
M_.params(1) = 0.7;
beta = M_.params(1);
M_.params(2) = 0.6;
alphaa = M_.params(2);
M_.params(3) = 0.2;
be = M_.params(3);
M_.params(4) = 0.9;
gamma = M_.params(4);
M_.params(5) = 0.00;
rho_zw = M_.params(5);
M_.params(6) = 0.00;
rho_zp = M_.params(6);
M_.params(7) = 0.00;
rho_u = M_.params(7);
%
% SHOCKS instructions
%
M_.exo_det_length = 0;
M_.Sigma_e(1, 1) = (1.00)^2;
M_.Sigma_e(2, 2) = (1.00)^2;
M_.Sigma_e(3, 3) = (1.00)^2;
options_.irf = 20;
options_.order = 1;
var_list_ = {'w';'p'};
[info, oo_, options_, M_] = stoch_simul(M_, options_, oo_, var_list_);


oo_.time = toc(tic0);
disp(['Total computing time : ' dynsec2hms(oo_.time) ]);
if ~exist([M_.dname filesep 'Output'],'dir')
    mkdir(M_.dname,'Output');
end
save([M_.dname filesep 'Output' filesep 'Simple_Eq_simulations_strong_results.mat'], 'oo_', 'M_', 'options_');
if exist('estim_params_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'Simple_Eq_simulations_strong_results.mat'], 'estim_params_', '-append');
end
if exist('bayestopt_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'Simple_Eq_simulations_strong_results.mat'], 'bayestopt_', '-append');
end
if exist('dataset_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'Simple_Eq_simulations_strong_results.mat'], 'dataset_', '-append');
end
if exist('estimation_info', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'Simple_Eq_simulations_strong_results.mat'], 'estimation_info', '-append');
end
if exist('dataset_info', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'Simple_Eq_simulations_strong_results.mat'], 'dataset_info', '-append');
end
if exist('oo_recursive_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'Simple_Eq_simulations_strong_results.mat'], 'oo_recursive_', '-append');
end
if ~isempty(lastwarn)
  disp('Note: warning(s) encountered in MATLAB/Octave code')
end
