%% Load dataset %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[low_beta,high_beta,FCK_LOCKED_IC_JYOTIKA] = load_data_power();

addpath('/home/INT/merrouch.s/Documents')
%addpath('/hpc/comco/malfait.n/Quinn2019_BurstHMM-master')
%% Subjects with 4 ICs
subjects = [2 3 4 6 7 8 10 11 13 14 15 16 18 19 22];

sub_ind = subjects(5);

clearvars -except FCK_LOCKED_IC_JYOTIKA low_beta high_beta subjects sub_ind

%% Data treatment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% baseline idxs, targets and nb trials
tp = num2str(FCK_LOCKED_IC_JYOTIKA{sub_ind,1}.trialinfo);
[Y, nb_trials, baseline_trials_idxs] = target_baseline(tp, sub_ind);

%% balanced dataset : idx of trials to keep
%[balanced_idxs, nb_trials] = balanced_target(Y);

%{
Y_balanced = Y(balanced_idxs);
balanced_success = find(Y_balanced(:,1) == 1);
balanced_failure = find(Y_balanced(:,1) == 2);
%}

%% frequance band : low and high 
window = 4;
time = FCK_LOCKED_IC_JYOTIKA{sub_ind,1}.time_20Hz;
%% power 
[data,nb_pts_trial] = power_freq_data(FCK_LOCKED_IC_JYOTIKA, high_beta, low_beta, sub_ind, window, baseline_trials_idxs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T = ones(nb_trials,1)*nb_pts_trial;
Y = reshape(repmat(Y,[1, nb_pts_trial])',nb_trials*nb_pts_trial,1);
success = find(Y(:,1) == 1);
failure = find(Y(:,1) == 2);
Y(success) = 1;
Y(failure) =-1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                   TUDA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
options = struct();
options.K = 4;                  % number of states / decoder
options.pca = 0;

%options.decoding = 'fixedsequential';
%options.decoding = 'regression';


options.detrend = 0;            % detrend the data
options.standardise = 0;        % don't standardize the data for each trial
options.parallel_trials = 1;    % we assume same experimental paradigm for all trials

% the following are parameters affecting the inference process - not crucial
options.tol = 1e-5;
options.initcyc = 10;
options.initrep = 3;
options.verbose = 1;
options.cyc = 100;

options.sequential = 0;         % clustering type : sequential or regression
%options.classifier='logistic';  %:  trains a logistic regression classifier
%options.classifier='LDA';      %: trains a linear discriminant analysis classifier
options.classifier='SVM';      %: trains a linear support vector machine
%options.classifier = 'regression';
%options.classifier= '';

twin = [0 2];
t = linspace(twin(1) , twin(end), T(1)); % time index

%% Run the model
[tuda,Gamma] = tudatrain(data,Y,T,options);

%% Test the model using cross-validation
options_cv = options; options.NCV = 10;
[accuracy,accuracy_star, Ypred, Ypred_star] = tudacv(data,Y,T,options_cv);
