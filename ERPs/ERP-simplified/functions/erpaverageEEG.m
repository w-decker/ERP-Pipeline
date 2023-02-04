%% Function: erpaverageEEG(subject_start, subject_end, subjects, workdir, erpdir)
% Author: Will Decker
% Usage: average ERPs across participants

%% Inputs 

%{ 
    subject_start: subject file to start loading (the position of the file name in subject_names
     
    subject_end: last subject file to load (the position of the file name in subject_names
    
    subjects: a str list of subject names to be loaded into the EEG object
    
    workdir: path to working directory

    erpdir: path to ERP directory

%}

function [EEG, com] = erpaverageEEG(subject_start, subject_end, subjects, workdir, erpdir)

EEG = [];
com = ' ';

for s = subject_start : subject_end
    subject = subjects{s};

    % establish data objects
   [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
    eeglab('redraw');

    % load dataset
    EEG = pop_loadset([subject '_epoch_ar.set'],workdir); 
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

    % average ERPs
    ERP = pop_averager( ALLEEG , 'Criterion', 'good', 'DSindex',1, 'ExcludeBoundary', 'on', 'SEM', 'on' );
    ERP = pop_savemyerp(ERP, 'erpname', subject, 'filename', [subject '.erp'], 'filepath', erpdir, 'Warning', 'on'); 

end
