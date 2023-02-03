#!bin/bash

# Title: Converting EEG data into BIDS format
# Author: Will Decker

## Load necessary libraries

import os
import os.path as op
import mne
from mne_bids import write_raw_bids, BIDSPath, print_dir_tree
from mne_bids.stats import count_events

## load data

rawdata = " "; # path to raw data

print_dir_tree(rawdata) # expand/display file tree

# create an empty list to store the raw data
raw_data = []

# loop through the files in the folder
for filename in os.listdir(rawdata):
    try:
        # check if the file is a BrainVision (.vhdr) file
        if filename.endswith(".vhdr"):
            # construct the full file path
            file_path = os.path.join(rawdata, filename)
            # load the data from the BrainVision file
            raw = mne.io.read_raw_brainvision(file_path)
            # add the raw data to the list
            raw_data.append(raw)
    except FileNotFoundError: # continue through loop
        print("Skipping file")
    continue

# combine the raw data into a single raw object
raw = mne.concatenate_raws(raw_data)

print(raw.info)

## Montage

get_montage = mne.channels.get_builtin_montages(descriptions = True) # get list of standard montages
for montage_name, montage_description in get_montage: 
    print(f'{montage_name}: {montage_description}')
    montage = montage_name
    break

standard_montage = mne.channels.make_standard_montage(montage)
raw.set_montage(standard_montage) # attribute montage to raw object

raw.plot_sensors() # display montage

# or 

montage_file = " " # path to montage file
montage = mne.channels.read_custom_montage(montage_file) # read in file

raw.set_montage(montage) # attribute montage to raw object

raw.plot_sensors() # dsiplay montage

## Convert EEG data to BIDS format

bids_root = "" # path to new BIDS output
task = " " # task
session = " " # session


subjectID = [ ] # subject ID number(s), e.g. ["028", "029", "030", etc.]

# or

# B = range(1,20) # Creates a vector, B,  of numbers, 1 through 20. Change this range to satsify participant ID requirements
# subjectID = [str(x) for x in B] # turns intigers in B into strings which are required for subject parameter in 'bids_path'

for ids in subjectID: # create BID compliant data based on subject ID numbers
    try:
        bids_path = BIDSPath(subject=ids, task=task, root=bids_root)
        write_raw_bids(raw, bids_path, overwrite=True, allow_preload= True, format = 'BrainVision')
    except FileNotFoundError: # continue through loop
        print("Skipping file")
        continue


## Display overview of new BIDS dataset 

counts = count_events(bids_root)
counts

## References

readme = op.join(bids_root, 'README')
with open(readme, 'r', encoding='utf-8-sig') as fid:
    text = fid.read()
print(text)

# Pernet, C.R., Appelhoff, S., Gorgolewski, K.J. et al. EEG-BIDS, an extension to the brain imaging data structure for electroencephalography. Sci Data 6, 103 (2019). https://doi.org/10.1038/s41597-019-0104-8