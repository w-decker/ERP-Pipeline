%% Function: erpanalysisEEG(subject_start, subject_end, subjects, workdir, txtdir, epoch_baseline, epoch_end)
% Author: Will Decker
% Usage: epoch data

%% Inputs 

%{ 
    subject_start: subject file to start loading (the position of the file name in subject_names
     
    subject_end: last subject file to load (the position of the file name in subject_names
    
    subjects: a str list of subject names to be loaded into the EEG object
    
    workdir: path to working directory

    txtdir: path to binlists

    epoch_baselime: time (in ms) to start epoch

    epoch_end: time (in ms) to end epoch

%}

function [EEG, com] = erpanalysisEEG(subject_start, subject_end, subjects, workdir, txtdir, epoch_baseline, epoch_end)

EEG = [];
com = ' ';

for s = subject_start : subject_end
    subject = subjects{s};

    % establish data objects
   [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
    eeglab('redraw');

    % Create eventlist, apply binlist, extract epochs
    EEG = pop_loadset([subject '_ICA_clean.set'],workdir);
    
    % create eventlist 
    EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', [txtdir [subject '.txt']] ); 
    EEG = eeg_checkset( EEG );
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'gui','off'); 
        
    % apply binlister
    EEG  = pop_binlister( EEG , 'BDF', [txtdir 'binlist.txt'], 'ExportEL', ...
        [txtdir [subject '_binlist.txt']],'ImportEL', [txtdir [subject '.txt']], ...
        'IndexEL',  1, 'SendEL2', 'EEG&Text', 'Voutput', 'EEG' );
    [ALLEEG, EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
     
    % extract epochs
    EEG = pop_epochbin( EEG , [epoch_baseline  epoch_end],  'pre'); 
    [ALLEEG, EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
        
    % make epochs with peak activity within window
    EEG  = pop_artmwppth( EEG , 'Channel',  [], 'Flag',  1, 'Threshold',  100, 'Twindow', [epoch_baseline epoch_end], 'Windowsize',  200, 'Windowstep',  100 ); 
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET ,'savenew',[workdir [subject '_epoch_ar.set']],'gui','off');

end

%%