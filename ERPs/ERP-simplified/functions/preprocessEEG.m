%% Function: preprocessEEG(subject_start, subject_end, subjects, workdir, rawdir, highpass, lowpass)
% Author: Will Decker
% Usage: preproccess raw EEG data

%% Inputs 

%{ 
    subject_start: subject file to start loading (the position of the file name in subject_names
     
    subject_end: last subject file to load (the position of the file name in subject_names
    
    subjects: a str list of subject names to be loaded into the EEG object
    
    workdir: path to working directory

    rawdir: path to raw data

    highpass: highpass filter (in Hz)

    lowpass: lowpass filter (in Hz)

%}

%% Notes:

%{
Notes: This function requires that a subject list be loaded with the string
names of all the files. The format of this must be .xlsx. An example of how
to correctly load the subject list and how to use this function is below.

[d,s,r] = xlsread ('.xlsx'); % Type the name of the .xlsx file within the ''(quotes).
subjects = r;

%}
%%

function [EEG, com] = preprocessEEG(subject_start, subject_end, subjects, workdir, rawdir, highpass,lowpass)

com = ' ';
EEG = [];

for s = subject_start : subject_end
    subject = subjects{s};

    % establish data objects
   [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
    eeglab('redraw');
    
    % load in raw files
    EEG = pop_loadbv(rawdir, [subject '.vhdr']);
    [ALLEEG, EEG, CURRENTSET] = pop_newset( ALLEEG, EEG, 0,'setname',subject,'gui','off'); 
    EEG = eeg_checkset( EEG );

    % remove extraneous data 
    EEG = erplab_deleteTimeSegments(EEG, 0, 3000, 3000);
   [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname',[subject '_time'],'gui','off');
    EEG = eeg_checkset( EEG );
    
    % filter data based on highpass and lowpass filters
    EEG = pop_eegfilt ( EEG, highpass, lowpass, [], [0], 0, 0, 'fir1', 0);
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname',[subject '_time_fl'],'gui','off'); 
    EEG = eeg_checkset( EEG );
    
    % rereferenece raw data
    EEG = pop_reref ( EEG, []);
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname',[subject '_time_fl_rr'],'gui','off');
    EEG = eeg_checkset( EEG );

    % save new dataset
    EEG = pop_saveset (EEG, [subject '_time_fl_rr'], workdir);

    % load and identify bad channels to reject
    EEG = pop_loadset([subject '_fl_rr.set'],workdir);
   [EEG, EEG.reject.indelec] = pop_rejchan(EEG,'elec',[1:EEG.nbchan],'threshold',5,'norm', 'on');
     
   % interpolate bad electrodes
    EEG = eeg_interp(EEG,EEG.reject.indelec);
   
   % create new set
   [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname',[subject '_time_fl_rr_interp'],'gui','off');
    EEG = eeg_checkset( EEG );

    % save preprocessed dataset
    EEG = pop_saveset( EEG, [subject '_time_fl_rr_interp'], workdir);
end
