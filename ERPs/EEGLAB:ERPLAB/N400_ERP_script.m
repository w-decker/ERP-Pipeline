%% Introduction
%{ 
This script takes you through the standard data processing steps to
extract N400 ERPs from EEG data.

There are multiple components to this proces. Most are automated in the
script however there are some steps that must be completed manually.

This script assumes that the user already has some simple programming
skills and some experience with EEG and EEG data analysis.

Some of these steps may need to be run 'by section'. This means that EEGLAB may not have
saved certain variables if you are waiting multiple days in between running
sections of analysis. You may need to re-run these variables (directories, subject list, etc...).
%}


%% Overview

% Step 1: Establish directory variables
% Step 2: Establish subject list
% Step 3: Establish parameters
% Step 4: Data preprocessing
% Step 5: Automatically removing bad blocks
% Step 5a: Interpolating bad electrodes*
% Step 6: ICA (Independant Component Analysis)
% Step 7: Component identification and removal*
% Step 8: Creating a binlist
% Step 9: ERP analysis
% Step 10: Average ERPs

% * completed manually

%%
clear
eeglab;

%% Step 1: Establishing directories
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
maindir = ''; % The 'maindir' is where MATLAB will pull raw EEG data from
workdir = ''; % The 'workdir' is an active directory that MATLAB will send all working data to
txtdir = ''; % 'txtdir' os for textfiles
erpdir = ''; % The 'erpdir' is where ERPs will be sent

%% Step 2: Subject list

%{
NOTES:
-The subject list is a .xlsx file that MATLAB reads from. It's
like a roster of all the raw EEG data to be analyzed. It contains the
subject names of all the EEG data files.
-The .xlsx file should be located in the pathway
-It should be one column with the names of the EEG data
files. An example is below:

eeg_001
eeg_002
eeg_003
etc...
%}

% establish subject list
[d,s,r] = xlsread ('.xlsx'); % Type the name of the .xlsx file within the ''(quotes).
subject_list = r;
numsubjects = (length(s));

%% Step 3: Parameters

%parameters
lowpass = 30; % can be changed as needed
highpass = 0.1; % can be changed as needed
epoch_baseline = -200.0; % epoch baseline
epoch_end = 800.0; % epoch offset
condition = 'red'; %if you have an experiment where you are evaluating between conditions, use this variable. This is important when forming you bin list. 

%% Step 4: Data preprocessing
% Filtering and re-referencing the data

%{
NOTES:
-After each raw EEG data file has been run throguh this portion of the
script, it is saved as a new file in the 'workdir' with '_fl_rr' added to the end.
(fl=filter, rr=re-referenced). This is a specific naming scheme that has
been developed within the script. If you wish to change this, lines of code
will have comments indicating where this can be done.
%}


for s=1:numsubjects %change number depending on the number of raw EEG data files
    
    subject = subject_list{s};

    [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
    eeglab('redraw');

    EEG = pop_loadbv (maindir, [subject '.vhdr'], [], []);
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',subject,'gui','off'); 
    EEG = eeg_checkset( EEG );

    EEG = pop_eegfilt ( EEG, highpass, lowpass, [], [0], 0, 0, 'fir1', 0);
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname',[subject '_fl'],'gui','off'); % If you wish to change the naming scheme, replace '_fl'
    EEG = eeg_checkset( EEG );

    EEG = pop_reref ( EEG, []);
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname',[subject '_fl_rr'],'gui','off'); % If you wish to change the naming scheme, replace '_fl_rr'
    EEG = eeg_checkset( EEG );

    EEG = pop_saveset( EEG, [workdir subject '_fl_rr']); % If you wish to change the naming scheme, replace '_fl_rr'
end

%% Step 5: Removing unncessary blocks of data
% this sections removes large chunks of unneeded data automaticall via a
% defined temporal threshold

for s=1 %change number of subjects as needed
    
    subject = subject_list{s};

    [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
    eeglab('redraw');

EEG = pop_loadset ([subject '_fl_rr.set'],workdir);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

EEG = erplab_deleteTimeSegments(EEG, 0, 3000, 3000); %preserves data 3000ms before and after any event code, all other data is removed.

EEG = pop_saveset( EEG, [workdir subject '_clean1']); %naming scheme chnaged during section development, it will need to be chagned back

end

%% Step 5a: Interpolating bad electrodes
% This step is done manually

% Interpolating bad electrodes
%{
Open EEGLAB gui. Click File >> Load existing data set and select the
[subjectname]_clean1.set file that you just saved. Next click Plots >>
Channel data(scroll) and scroll through the data taking note of any bad
electrodes. 

To interpolate bad electrodes click Tools >> Interpolate electrodes >>
Select from data channels. Select the electrodes you wish to interpolate.
(Make sure the interpolation method is set to 'Spherical').

Save this data set as [subjectname]_clean_interp* to your 'workdir'.

Example: eeg_001_clean_interp.set

*This is a specific naming scheme that has been developed within the
script. If you wish to change this, lines of code will have comments
indicating where this can be done.
%}
%% Step 6: ICA

%{
NOTES:
-After each [subjectname]_clean_interp.set file has been run through this portion of the
script, it is saved as a new file in the 'workdir'. the '_clean_inter' is
replaced with '_ICA'*.

Example: eeg_001_ICA.set

*This is a specific naming scheme that has been developed within the script. 
If you wish to change this, lines of code will have comments indicating where this can be done.
%}

for s=1:numsubjects %change number of subjects as needed
    
    subject = subject_list{s};

    [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
    eeglab('redraw');

EEG = pop_loadset ([subject '_clean_interp.set'],workdir); % If you wish to change the naming scheme, replace '_clean_interp' with your naming scheme that used to save the files which you have interpolated bad electrodes
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on');
[ALLEEG, EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

EEG = pop_saveset( EEG, [workdir subject '_ICA']); % If you wish to change the naming scheme, replace '_ICA'

end

%% Step 7: Identifying and removing bad components
%This step is done manually

%{
NOTES:-This step of the process requires MARA.
%}

% Loading MARA and identifying + removing bad components
%{
The ICA file must be loaded. Open EEGLAB gui. Click Tools >> IC Artifact
classification(MARA) >> MARA Classification >> Plot and select components
for removal >> Ok

Review components you wish to remove. An artifcact likelihood of 70% or higher is acceptable
for removal but this should be evaluated by your research team as you see fit.

Select and record artifacts you wish to remove. This is important and should be included in
analysis.

To remove artifacts open EEGLAB gui. Tools >> Remove components from data
>> Yes (Plot single trials). Evaluate the new plot to see if the data looks
cleaner. If so click Accept. If not review artifacts again.

Save file as [subjectname]_ICA_clean*

Example: eeg_001_ICA_clean.set

*This is a specific naming scheme that has been developed within the
script. If you wish to change this, lines of code will have comments
indicating where this can be done.
%}

%% Step 8: Creating a binlist

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
           

%% Step 9: ERP Analysis

%{
NOTES:
This portion of the scripts pulls from the binlist created in Step 8 found
in the 'txtdir'. This script assumes that the name of the binlist file is
'binlist.txt'. If this is not the name of your binlist, you will need to
change it in line 259 of this script.
%}

for s=1:numsubjects %change number of subjects as needed
    
    subject = subject_list{s};

     [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
     eeglab('redraw');

% Create eventlist, apply binlist, extract epochs
EEG = pop_loadset([subject '_ICA_clean.set'],workdir);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', [txtdir [subject '.txt']] ); 
EEG = eeg_checkset( EEG );
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'gui','off'); 
    
EEG  = pop_binlister( EEG , 'BDF', [txtdir 'binlist.txt'], 'ExportEL', [txtdir [subject '_binlist.txt']],'ImportEL', [txtdir [subject '.txt']], 'IndexEL',  1, 'SendEL2', 'EEG&Text', 'Voutput', 'EEG' );
[ALLEEG, EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    
EEG = pop_epochbin( EEG , [epoch_baseline  epoch_end],  'pre'); 
[ALLEEG, EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    
EEG  = pop_artmwppth( EEG , 'Channel',  [], 'Flag',  1, 'Threshold',  100, 'Twindow', [epoch_baseline epoch_end], 'Windowsize',  200, 'Windowstep',  100 ); 
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET ,'savenew',[workdir [subject '_epoch_ar.set']],'gui','off'); % This is a specific naming scheme that has been developed within the script. % If you wish to change the naming scheme, replace '_epoch_ar'

end

%% Editing binlist using terminal

% EEGLAB created an uneditable header in your binlist/eventlist which can make it
% difficult to analyize your behavioral data later on. This section of code removes that header
% using macOS terminal

% for this section of code, make sure you have downloaded
% "edit_bin_list.sh" and saved it to your txtdir (NOTE: there are minor
% instructions included within this file)

% Open terminal and cd into your txtdir where the binlists have been saved
% In terminal type sh edit_bin_list.sh

%% Step 10: Average ERP

EEG = pop_loadset([subject '_epoch_ar.set'],workdir); 
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
ERP = pop_averager( ALLEEG , 'Criterion', 'good', 'DSindex',1, 'ExcludeBoundary', 'on', 'SEM', 'on' );
ERP = pop_savemyerp(ERP, 'erpname', subject, 'filename', [subject '.erp'], 'filepath', erpdir, 'Warning', 'on'); 















