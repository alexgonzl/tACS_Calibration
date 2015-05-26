function timeCalibrationTest(testNum)
% Test script to test how codes are stored and to see potential
% diffrences in the timing of the commands.
% 
% To that end, I'll start a clock at same time than the command to
% record is sent to Starstim. Each code sent to starstim 
% will also be stamped on the matlab time.
%
% input: testNum -> test ID
% saves outputs to 

% add path of MatNic tools

addpath('/_Developer_AG/NE_USB_Contents/Matlab Tools/')
addpath(genpath('/_Developer_AG/NE_USB_Contents/MatNIC_v2.3/'))

% Connect to Starstim
load StarStimIP
[ret, status, socket] = MatNICConnect(StarStimIP);

% if connected, ret= 0
if ret~=0
    disp('could not connect')
end

% filename for Starstim to save data
fileName = sprintf('timeCallibrationTest%i',testNum);


% start matlabclock
tic;
% start EEG recordinf
