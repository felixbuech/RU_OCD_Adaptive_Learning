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
    config.practTrialsVis = 5; 
    config.practTrialsHid = 10; 
    config.practTrialsConf = 5; % for Confidence extra number for trials
    config.cannonPractCriterion = 2; % criterion cannon practice
    config.cannonPractNumOutcomes = 5; % number of trials cannon practice 
    config.cannonPractFailCrit = 1; 
    config.passiveViewing = false;
    config.baselineFixLength = 0.25;
    config.blockIndices = [1 51 101 151];
    config.runIntro = true;
    config.baselineArousal = false;
    config.language = 'German';
    config.sentenceLength = 100;
    config.textSize = 35;
    config.headerSize = 50;
    config.vSpacing = 1;
    config.screenSize = [0           0        1920        1200];
    config.globalScreenBorder = 0;
    config.screenNumber = 1;
    config.s = 83;
    config.five = 53;
    config.enter = 13;
    config.defaultParticles = false; 
    config.debug = false;
    config.showConfettiThreshold = false;
    config.printTiming = true;
    config.hidePtbCursor = true;
    config.dataDirectory = 'C:\Users\fb74loha\Desktop\GitHub_Clone_Adaptive_Learning\AdaptiveLearning\pilot_data\helicopter';
    config.meg = false;
    config.scanner = false;
    config.eyeTracker = false;
    config.onlineSaccades = false;
    config.saccThres = 0.7;
    config.useDegreesVisualAngle = true;
    config.distance2screen = 500;
    config.screenWidthInMM = 309.40;
    config.screenHeightInMM = 210;
    config.sendTrigger = false;
    config.sampleRate = 500;
    config.port = hex2dec('0378'); % if Exp run in Hamburg: ('E050');
    config.rotationRadPixel = 140;
    config.rotationRadDeg = 3.16;
    config.customInstructions = true;
    config.instructionText = al_HelicopterInstructionsDefaultText();
    config.noPtbWarnings = false;
    config.predSpotCircleTolerance = 2;
    config.P9location = 'Leipzig';

    if config.sendTrigger && strcmpi(config.P9location,'Hamburg')
        [config.session, ~] = IOPort( 'OpenSerialPort', 'COM1' );
    else 
        config.session = nan;
    end

% Run task with config input
RunHelicopterVersion(config);