% Common Confetti Version Configuration Example
%
% Example of how to add local parameter settings as config input to the
% function that runs the task.
%
% It is recommended that you create your own script with the local 
% parameter settings so that you can re-use your settings.


% Create config structure
config = struct();

% Add desired parameters
config.trialsExp = 60; 
config.nBlocks = 6;
config.practTrialsVis = 10; %5 for short practice
config.practTrialsHid = 15; %5 for short practice
config.practTrialsConf = 5; % for Confidence extra number for trials
config.cannonPractCriterion = 3; % criterion cannon practice
config.cannonPractNumOutcomes = 5; % number of trials cannon practice %2 for short practice
config.cannonPractFailCrit = 2; %1 for short practice
config.passiveViewing = false;
config.passiveViewingPractTrials = 10;
config.baselineFixLength = 0.25;
config.blockIndices = [1 999 999 999]; % we don't have breaks within each block
config.runIntro = false; % false;
config.baselineArousal = false; %false; % true;
config.language = 'German'; % 'English';
config.sentenceLength = 100;
config.textSize = 35;
config.vSpacing = 1;
config.headerSize = 50;
config.screenSize = [0           0        1920        1200]; % get(0,'MonitorPositions')*1.0;
config.globalScreenBorder = 0; %1920; % default is 0
config.screenNumber = 1;
config.s = 83;
config.five = 53;
config.enter = 13;
config.defaultParticles = true;
config.debug = false;
config.showConfettiThreshold = false;
config.printTiming = true;
config.hidePtbCursor = true;
config.dataDirectory = 'C:\Users\fb74loha\Desktop\GitHub_Clone_Adaptive_Learning\AdaptiveLearning\pilot_data\helicopter';
config.meg = false;
config.scanner = false;
config.eyeTracker = false; %true;
config.onlineSaccades = true;
config.saccThres = 1;
config.useDegreesVisualAngle = true;
config.distance2screen = 700;
config.screenWidthInMM = 530;
config.screenHeightInMM = 330;
config.sendTrigger = false;
config.sampleRate = 500; % Sampling rate for EEG
config.port = hex2dec('E050');
config.rotationRadPixel = 140; % 170
config.rotationRadDeg = 3.16; % 2.5
config.customInstructions = true;
config.instructionText = al_HelicopterInstructionsDefaultText();
config.noPtbWarnings = false;
config.predSpotCircleTolerance = 2;

if config.sendTrigger
    [config.session, ~] = IOPort( 'OpenSerialPort', 'COM3' );
else
    config.session = nan;
end

% Run task with config input
RunHelicopterVersion(config);