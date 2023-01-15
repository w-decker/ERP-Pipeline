#!/bin/bash

# The following code deletes extraneous lines of data from the bins file and converts the output
# into a .csv file

# Step 1: create a subject list as a .txt file:
# Example: 		eeg_001
#			eeg_002
#			etc...

# Step 2: run the following code

subjectlist=$(cat path_to_subject_list)

    for subject in $subjectlist;
    
          do
          
          sed '1,46d' ${subject}_bins.txt > ${subject}_bins.csv
            
          done
