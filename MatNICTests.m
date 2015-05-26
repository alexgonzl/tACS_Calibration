% Run various MatNic Commands to understand their ussage
% AG 5/14/15
% this script follows the steps from the MatNic 2.3 user manual

% Load StarStimIP address. In this case it is the NIC host computer. The
% IP addresss is stored in the StarStimIP file
load StarStimIP

% Connect to NIC
[ret, status, socket] = MatNICConnect(StarStimIP);

% if connected, ret= 0
if ret~=0
    disp('could not connect')
end

% start fake EEG recording.
% First input -> string, subjectID (name of the file to be saved)
% Second input -> bool, save in .easy format
% Third input -> bool, save in .edf format
% Fourth input -> socket info as the output from MatNicConnect

ret = MatNICStartEEG ('startEEG-test', true, false, socket);

% Query EEG recording state:
[ret, status] = MatNICQueryStatus(socket);
if ret~=0
    disp('something is wrong, EEG status is not what expected')
end

% get some of the data being recorded for inspection
% first input: double, time in secs for query
% second input: number (int,double,etc), # of channels on the device (8 for
% starstim)
% third input: NIC computer IP
[eeg] = MatNICEEGRecord(10, 8, StarStimIP);
% note that the eeg will be a period*sampling rate X # of channels matrix
% the units are not in micro volts. Conversion needed.


