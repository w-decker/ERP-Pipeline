# EEG-Pipeline

## About

This repository contains code for a variety of analysis methods for electroencephalography (EEG). Please see the table below for a more detailed description of each folder and its current status of completion.

| Filename/Folder | Description | Status |
| -------- | ----------- | ------ |
| EEGLAB/ERPLAB | MATLAB script for preprocessing and extracting ERPs from BrainVision EEG data. Can be easily modified for other hardware types (e.g., BioSemi) and bin counts. Also includes documentation/notes for operating within the EEGLAB GUI. | Complete ✅ | 
| MUT/FMUT | MATLAB scripts for statistically analyzing ERPs using the Mass Univariate Toolbox and the Factorial Mass Univariate Toolbox. | Complete ✅ |
| MNE | Python/Jupyter Notebook scripts for analyzing and extracting ERPs from BrainVision EEG data. Can be easily modified for other hardware types (e.g., BioSemi) and number of conditions. | In progress 🛑 |
| bin_diff.Rmd | R Markdown file for detecting differences in binlists. This task can also be done with simple bash code as well, but I just felt like doing it in R. | Complete ✅ |
| edit_eventlist.sh | Shell script that removes erroneous lines of data from eventlist output from ERPLAB. | Complete ✅ |



#### Please reach out if you have any questions.
