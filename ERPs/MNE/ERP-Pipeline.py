#!/usr/bin/env python

# ERPs using MNE
# Author: Will Decker
# Note: Adapted from MNE Documentation: mne.tools/stable/overview/index.html#

## load dependancies 

import mne
import numpy as np
import os
import matplotlib as plt

## Loading and plotting raw data

# Set the folder path
folder_path = '/Users/lendlab/Desktop/MNE/rawdata'

# create an empty list to store the raw data
raw_data = []

# loop through the files in the folder
for filename in os.listdir(folder_path):
    # check if the file is a BrainVision (.vhdr) file
    if filename.endswith(".vhdr"):
        # construct the full file path
        file_path = os.path.join(folder_path, filename)
        # load the data from the BrainVision file
        raw = mne.io.read_raw_brainvision(file_path)
        # add the raw data to the list
        raw_data.append(raw)

# combine the raw data into a single raw object
raw = mne.concatenate_raws(raw_data)

print(raw.info)
raw.plot_psd(fmax = 50)
raw.plot(duration=5, n_channels=len(raw.ch_names))

# convert data to numpy array

data = raw.get_data()
print(type(data))  # <class 'numpy.ndarray'>
print(data.shape)  # (n_channels, n_samples)


## Identifying Trigger Codes and Epoching data

events,_ = mne.events_from_annotations(raw)
print(events[:]) # check events
print(type(events)) # check data structure class

### Preprocessing

## Filter data

# filter data through low pass and high pass filters

filtered_data = mne.filter.filter_data(data, raw.info['sfreq'], 30, 0.1)


## Epoching data

epochs = mne.Epochs(raw, events, tmin=-0.2, tmax=0.8, preload = True)

print(epochs)
print(epochs.event_id)

epochs.plot(n_epochs=len(epochs))


## ERPs

raw.plot_sensors(show_names=True)
fig = raw.plot_sensors('3d')

for proj in (False, True):
    with mne.viz.use_browser_backend('matplotlib'):
        fig = raw.plot(n_channels=5, proj=proj, scalings=dict(eeg=50e-6),
                       show_scrollbars=False)
    fig.subplots_adjust(top=0.9)  # make room for title
    ref = 'Average' if proj else 'No'
    fig.suptitle(f'{ref} reference', size='xx-large', weight='bold')



