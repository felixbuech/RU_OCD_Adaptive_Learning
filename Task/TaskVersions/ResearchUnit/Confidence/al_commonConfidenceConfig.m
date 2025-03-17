function config = al_setupCommonConfidenceConfig(isFirstTask)
% SETUPCOMMONCONFIDENCECONFIG Configures settings for the Confidence version.
%
% This function dynamically adjusts the number of practice trials depending
% on whether the Confidence task is the first or second task in the experiment.
%
% Input:
%   isFirstTask - Boolean (true = Helicopter is first, false = Helicopter is second)
%
% Output:
%   config - Struct containing task configuration parameters

    
    config = struct();

    
    config.trialsExp = 2; % Number of experimental trials per block
    config.nBlocks = 4; % Number of blocks
    config.language = 'German'; % 'English' also possible
    config.passiveViewing = false;
    config.passiveViewingPractTrials = 10; % Number of passive viewing trials
    config.customInstructions = true; % Use customized instructions
    config.instructionText = al_HelicopterInstructionsDefaultText(); % Load instruction text class

  
    if isFirstTask
        config.practTrialsVis = 10; % More practice trials if Helicopter is first
        config.practTrialsHid = 20;
        config.cannonPractCriterion = 4; % Criterion for successful practice
        config.cannonPractNumOutcomes = 5; % Number of cannon shots per practice round
        config.cannonPractFailCrit = 3; % Maximum allowed failures before continuing
    
    else
        config.practTrialsVis = 5;  % Fewer practice trials if Helicopter is second
        config.practTrialsHid = 10;
        config.cannonPractCriterion = 2; % Criterion for successful practice
        config.cannonPractNumOutcomes = 5; % Number of cannon shots per practice round
        config.cannonPractFailCrit = 1; % Maximum allowed failures before continuing
    end

    
    config.baselineFixLength = 0.25; % Baseline fixation duration (seconds)
    config.blockIndices = [1 999 999 999]; % No breaks within each block
    config.runIntro = true; % Show introduction 
    config.baselineArousal = false; % Pupil measurement baseline

   
    config.screenSize = [0 0 1920 1200]; % Screen resolution (width, height)
    config.globalScreenBorder = 0; % Screen border
    config.screenNumber = 1; % Monitor to use

   
    config.s = 83; 
    config.five = 53; 
    config.enter = 13; 

    
    config.sentenceLength = 100; % Max length of text on screen
    config.textSize = 35; % Text size
    config.vSpacing = 1; % Vertical spacing for text
    config.headerSize = 50; % Header text size

   
    config.debug = false; % Enable debugging mode?
    config.showConfettiThreshold = false; % Display confetti threshold?
    config.printTiming = true; % Print timing information?
    config.hidePtbCursor = true; % Hide PsychToolbox cursor?
    config.noPtbWarnings = false; % Disable PTB warnings?

  
    config.dataDirectory = 'C:\Users\fb74loha\Desktop\GitHub_Clone_Adaptive_Learning\AdaptiveLearning\test_data_confidence'; 
    
   
    config.meg = false; % Use MEG scanner?
    config.scanner = false; % Use MRI scanner?
    config.eyeTracker = false; % Use Eyelink eye tracker?
    config.onlineSaccades = true; % Detect online saccades?
    config.saccThres = 0.7; % Saccade threshold

   
    config.useDegreesVisualAngle = true;
    config.distance2screen = 700; % Distance to screen in mm
    config.screenWidthInMM = 309.40; % Screen width in mm
    config.screenHeightInMM = 210; % Screen height in mm

   
    config.sendTrigger = false;
    config.sampleRate = 500; % Sample rate for EEG/MEG
    config.port = hex2dec('E050'); % Hexadecimal port for triggers

   
    config.rotationRadPixel = 140; % Radius in pixels
    config.rotationRadDeg = 2.5; % Radius in degrees of visual angle

  
    if config.sendTrigger
        [config.session, ~] = IOPort('OpenSerialPort', 'COM3');
    else
        config.session = nan;
    end
end

% Run task with config input
RunConfidenceVersion(config);