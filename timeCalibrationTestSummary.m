% Function to summarize the performance of timeCalibrationTests

matlabDataPath = '/AG_MatlabData/CalibrationResults/';
% make sure this computer is logged into the starstim computer to be able
% to load this data
starStimDataPath = '/Volumes/Starstim_HD/_StarStim_Data/AG/CalibrationTests/';

nTests = 4;
starStimFileNames = [];
starStimFileNames{1}='20150526174337_timeCallibrationTest1.easy';
starStimFileNames{2}='20150526180300_timeCallibrationTest2.easy';
starStimFileNames{3}='20150526182250_timeCallibrationTest3.easy';
starStimFileNames{4}='20150526183935_timeCallibrationTest4.easy';

X=[]; % matlab data
Y=[]; % starstim data
for ii = 1:nTests
    fileName = sprintf('timeCallibrationTest%i.mat',ii);
    load([matlabDataPath fileName]);
    X(:,ii) = out(:,3);    
    x=load([starStimDataPath starStimFileNames{ii}]);
    t=(x(:,10)-x(1,10))/1000;
    Y(:,ii) =t(x(:,9)~=0);
end

