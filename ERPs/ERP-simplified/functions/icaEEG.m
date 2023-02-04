%% Function: icaEEG(subject_start, subject_end, subjects, workdir)
% Author: Will Decker
% Usage: running ICA on preprocessed data

%% Inputs 

%{ 
    subject_start: subject file to start loading (the position of the file name in subject_names
     
    subject_end: last subject file to load (the position of the file name in subject_names
    
    subjects: a str list of subject names to be loaded into the EEG object
    
    workdir: path to working directory

%}

%%

function [EEG, com] = icaEEG(subject_start, subject_end, subjects, workdir)

EEG = [];    
com = ' ';

for s=subject_start : subject_end
    subject = subjects{s};

    % establish data objects
   [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
    eeglab('redraw');

    % load preprocessed set
    EEG = pop_loadset ([subject '_time_fl_rr_interp.set'], workdir);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    
    % run ICA
    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on');
    [ALLEEG, EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    
    % save new dataset
    EEG = pop_saveset( EEG, [subject '_ICA'], workdir);
    
end
