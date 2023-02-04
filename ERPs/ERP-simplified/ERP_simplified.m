%% ERP_simplified

% Author: Will Decker

%% Introduction

%{
This script is a simplified version of 'N400_ERP_script.m'. It takes you
through the standard steps of preprocessing, bad channel removal, ICA,
artifact detection, ERP analysis and ERP average. However, what makes this
code simpler, is that each compoenent of the pipeline has been condensed
down into one function. All functions are located in the 'functions' folder. To use
these, download the folder and add it to your MATLAB path. 

Note: the naming scheme is adapted from 'N400_ERP_script.m'
%}

%% Overview

% Step 1: Establish directories
% Step 2: Establish parameters
% Step 3: Establish subject list
% Step 4: Data preprocessing
% Step 5: ICA
% Step 6: Artifact removal
% Step 7: Creating a binlist
% Step 8: ERP analysis
% Step 9: Average ERPs

%%

clear
eeglab;

%%

%% Step 1: Establish directories

%{ 
NOTES:
-don't forget to set a path in the HOME tab of MATLAB
-Directories are set variables that identify locations of files/folders
that MATLAB either pulls data from or sends new data to.
-You will need to associate a file to each directory variable. Using these
directories is helpful and will make your data organized and easily
accessible as it is run through each step of this process.
%}

% Directories
% Type in the locations of these directories within the ''(quotes)
rawdir = ' '; % The 'maindir' is where MATLAB will pull raw EEG data from
workdir = ' '; % The 'workdir' is an active directory that MATLAB will send all working data to
txtdir = ' '; % 'txtdir' is for textfiles
erpdir = ' '; % The 'erpdir' is where ERPs will be sent

%% Step 2: Establish parameters

% Filters
lowpass = 30; % can be changed as needed
highpass = 0.1; % can be changed as needed

% Epochs
epoch_baseline = -200.00; % can be changed as needed
epoch_end = 800.00; % can be changed as needed

%% Step 3: Establish subject list

[d,s,r] = xlsread (' '); % Type the name of the .xlsx file within the ''(quotes). Note: it must be in the current directory.
subjects = r;
numsubjects = (length(s));

% Subjects to run
subject_start = 1; % subject in position 'x' in subjects variable
subject_end = 1; % subject in position 'x' in subjects variable


%% Step 4: Data preprocessing
% to read more about the function 'preprocessEEG' highlight it and press
% cmd + shift + D (on Mac)

preprocessEEG(subject_start, subject_end, subjects, workdir, rawdir, highpass, lowpass)

%% Step 5: ICA
% to read more about the function 'icaEEG' highlight it and press cmd +
% shift + D (on Mac)

icaEEG(subject_start, subject_end, subjects, workdir)

%% Step 6: Artifact Removal
% to read more about the function 'maraEEG' highlight it and press cmd +
% shift + D (on Mac)

maraEEG(subject_start, subject_end, subjects, workdir)

%% Step 7: Creating a binlist 

%{
A binlist is a .txt file that you will put in your 'txtdir'. This file is
what MATLAB uses to identify where ERPs will be extracted (i.e. the
stimulus locations indetified by trigger codes). 
Let's say I have two visual stimuli presented in an experiment and I want 
to extract the ERP from these stimuli. The trigger codes are 
101 and 102. The bin list will look something like this:

Example:        bin 1
                bin descriptor
                .{101}
                bin 2
                bin descriptor
                .{102}
%}
           
%% Step 8: ERP analysis
% to read more about the function 'erpanalysisEEG' highlight it and press
% cmd + shift + D (on Mac)

erpanalysis(subject_start, subject_end, subjects, workdir, txtdir, epoch_baseline, epoch_end)

%% Step 9: Average ERPs
% to read more about the function 'erpaverageEEG' highlight it and press
% cmd + shift + D (on Mac)

erpaverageEEG(subject_start, subject_end, subjects, workdir, erpdir)

