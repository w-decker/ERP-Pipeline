%% Mass Univariate Analysis Between-Subjects t-test

% Author: Will Decker 
% Date created: November 7, 2022

%% IMPORTANT NOTE

% binlists descriptors must be indentical
% Refer to documentation on how to properly build a binlist
% Using R to detect differences between binlists may be helpful
% see 'bin_diff.Rmd' for more instructions on how to detect differences

%% Converting [.erp] files to [.gnd] files

% estsablish list of .erp files 

data1 = readtext('condition1.txt'); % list of .erp filenames of subjects in one condition

data2 = readtext('condition2.txt');  % list of .erp filenames of subjects in one condition

% index cell arrays (list of .erp files)

% load .erp files, convert to .GND file, save file to directory
GND = erplab2GND(data1, 'out_fname', 'condition1.GND'); 
GND = erplab2GND(data2, 'out_fname', 'condition2.GND');


%% Converting [.gnd] files to [.grp] files

GRP = GNDs2GRP({'condition1', 'condition2.GND'}, ... % load the two .GND files created in the previous section
    'create_difs', 'yes', 'out_fname', 'eeg.GRP'); % save file as 'eeg.GRP'

%% Mean time window analysis
% tmax permutation test

GRP = tmaxGRP('eeg.GRP', 11, 'time_wind', [300 800]);
GRP = tmaxGRP('eeg.GRP', 12, 'time_wind', [300 800]);
 %%
