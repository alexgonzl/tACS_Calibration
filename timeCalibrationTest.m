%function out = timeCalibrationTest(testNum)


% Test script to test how codes are stored and to see potential
% diffrences in the timing of the commands.
%
% To that end, I'll start a clock at same time than the command to
% record is sent to Starstim. Each code sent to starstim
% will also be stamped on the matlab time.
%
% input: testNum -> test ID
% saves output

%%
testNum = input('Please input the test number');
% Parameters
Nevents = 100;
T = 5*60; % duration of recording in seconds
Tol = 0.001; % timing tolerance in seconds
UpdateTime = 0.1; % don't check status or send new commands withing this time

% filename of test save data
fileName = sprintf('timeCallibrationTest%i',testNum);
% save path for local data
savePath = '/AG_MatlabData/CalibrationResults/';

% add path of MatNic tools
addpath('/_Developer_AG/NE_USB_Contents/Matlab Tools/')
addpath(genpath('/_Developer_AG/NE_USB_Contents/MatNIC_v2.3/'))

% Connect to Starstim
load StarStimIP
[ret, ~, socket] = MatNICConnect(StarStimIP);

% if connected, ret= 0
if ret<0
    disp('could not connect')
end

% out vector indicating event # and time when it was sent
out = zeros(Nevents,3);
out(:,1) = randi(9,[Nevents,1]); % event IDs
out(:,2) = round(linspace(10,T-10,Nevents)); % designed event times
% third column is the actual times

% open a streaming for sending codes
[ret, outlet] = MatNICMarkerConnectLSL('alexLSL');
if ret<0
    error('could not connect to streaming layer');
end
%%
% start EEG recording
ret = MatNICStartEEG (fileName, true, false, socket);
if ret<0
    error('could not start eeg recording');
else
    % start matlabclock
    tic;
end

% stop recording after T seconds
EventCnt = 1;
currentTime = toc;
lastTime = currentTime;
EventFlag = 0;
while T>currentTime
    currentTime = toc;
    
    % wait at least UpdateTime before running through commands again
    if (abs(currentTime-lastTime) > UpdateTime) && EventFlag
        EventFlag=0;
    end
    % send event code if it is time
    if EventCnt<=Nevents
        if (abs(out(EventCnt,2)-currentTime)<Tol) && ~EventFlag
            ret = MatNICMarkerSendLSL(out(EventCnt,1),outlet);
            out(EventCnt,3) = toc;
            if ret <0
                warning('Error when sending code %i',EventCnt)
            else
                fprintf('Event %i sent \n',EventCnt)
            end
            EventCnt = EventCnt+1;
            EventFlag = 1;
            lastTime    = currentTime;
        end
    end
    % check status every minute
    if (mod(currentTime,60)<Tol) && ~EventFlag
        [~,stat] = MatNICQueryStatus(socket);
        if ~strcmp(stat,'CODE_STATUS_EEG_ON')
            error('not in recording state')
        end
    end
end

ret = MatNICStopEEG(socket);
if ret<0
    disp('could not stop EEG recording')
end

save([savePath fileName],'out');