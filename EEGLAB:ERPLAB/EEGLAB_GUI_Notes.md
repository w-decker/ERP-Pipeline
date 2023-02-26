### Notes for navigating EEGLAB GUI

## Using Clean Rawdata and ASR

Note: Resouce: https://eeglab.org/tutorials/06_RejectArtifacts/cleanrawdata.html

Clean Rawdata is a default plugin
ASR: Artifact Subspace Reconstruction

Opening it:
      Tools >> Reject data using Clean Rawdata and ASR
      
You can (1) Remove bad channels (2) Perform ASR bad burst correction and (3) Additional removal of bad data periods

  (1) Flat channels can be removed, channels with excessive noise can be removed.
  (2) ASR is an algorithm. It corrects data instead of rejecting it.

## Averaging ERPs and Grandaveraging ERPs

Note: the following steps require ERPLAB to be installed

Open ERPLAB>>Load Existing ERP Set(s)>>Plot ERP(s)>>Plot ERP Waveform(s)

You will now be prompted with a pop-up gui. Here you can edit the bins to extract ERPs from, orientation of the plot (plot positive up!!!)

Once you have selected the relevant parameters, click Plot. Now you have your waveforms! The next step is creating a grandaverage. 
To create a grandaverage, click ERPLAB>>Average Across ERP Sets (Grand Average)

You are now prompted with a gui in which you will load all of the ERP sets you wish to average across. Select the appropriate sets and click run. You now have created a grandaverage!


