The Brain Imaging Data Structure (BIDS) is a standard that has been adopted to ensure that the dissemination of imaging data is consistent and standardized
to improve replication efforts, transparency and literacy. Resources for BIDS can be found [here](https://bids.neuroimaging.io/).

Details

**_rename-brainvision.ipynb_** -> This code renames all three BrainVision files (.vhdr, .vmrk, .eeg) while keeping them and the metadata intact.
This is important to BIDS as some naming schemes may not include subjectIDs or subject numbers. This code allows one to rename BrainVision files to inserts
a subjectID/number and any other important information. If you do not need to rename you BrainVision files, ignore this code.

**_bids-eeg.ipynb/bids-eeg.py_** -> This code coverts raw EEG data into the BIDS standard using MNE-Python and MNE-BIDS. Documentation can be found [here](https://mne.tools/mne-bids/dev/use.html).
