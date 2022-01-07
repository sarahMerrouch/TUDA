function [low_beta,high_beta,FCK_LOCKED_IC_JYOTIKA] = load_data_power()
%LOAD DATA POWER load high and low beta dataset
%                load FCK_LOCKED_IC_JYOTIKA dataset
%
clear all
%% Load low beta frequencies
load('/hpc/comco/Sarah.M/frequencies_lowbeta.mat');
low_beta = Frequencies;
clear Frequencies

%% Load high beta frequencies
load('/hpc/comco/Sarah.M/frequencies_highbeta.mat');
high_beta = Frequencies;
clear Frequencies

%% Load Jyotika file
load('/hpc/comco/malfait.n/TEMP_JYOTIKA/NIC_250819/FCK_LOCKED_IC_JYOTIKA_250819.mat')

end

