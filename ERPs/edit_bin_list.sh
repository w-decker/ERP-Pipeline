#!/bin/bash

# The following code deletes extraneous lines of data from the bins file and converts the output
# into a .csv file

# Step 1: create a subject list as a .txt file:
# Example: 		eeg_001
#			eeg_002
#			etc...

# Step 2: run the following code

        # To run the codeL (1) cd into this file's directory (2) type: 'sh file_name.sh' (3) The previous command will exectue the code within this bash file

subjectlist=$(cat path_to_subject_list)

    for subject in $subjectlist;
    
          do
          
          sed '1,46d' ${subject}_bins.txt > ${subject}_bins.csv
            
          done
