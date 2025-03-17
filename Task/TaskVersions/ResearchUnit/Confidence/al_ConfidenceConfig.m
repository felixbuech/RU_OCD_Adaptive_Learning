function config = al_ConfidenceConfig(isFirstTask)
% SETUPCONFIDDENCECONFIG Configures settings for the CommonConfidence version.
%
% This function dynamically adjusts the number of practice trials depending
% on whether the Helicopter task is the first or second task in the experiment.
%
% Input:
%   isFirstTask - Boolean (true = Helicopter is first, false = Helicopter is second)
%
% Output:
%   config - Struct containing task configuration parameters

    
    config = struct();

    
    config.trialsExp = 1;
    config.nBlocks = 6;
  
    if isFirstTask
        config.practTrialsVis = 5; % More practice trials if Helicopter is first
        config.practTrialsHid = 5;
        config.practTrialsConf = 5; % for Confidence extra number for trials
        config.cannonPractCriterion = 3; % Criterion for successful practice
        config.cannonPractNumOutcomes = 5; % Number of cannon shots per practice round
        config.cannonPractFailCrit = 1; % Maximum allowed failures before continuing
    
    else
        config.practTrialsVis = 5;  % Fewer practice trials if Helicopter is second
        config.practTrialsHid = 5;
        config.practTrialsConf = 3; % for Confidence extra number for trials
        config.cannonPractCriterion = 2; % Criterion for successful practice
        config.cannonPractNumOutcomes = 5; % Number of cannon shots per practice round
        config.cannonPractFailCrit = 1; % Maximum allowed failures before continuing
    end

    
    config.passiveViewingPractTrials = 10;
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
    config.dataDirectory = 'C:\Users\fb74loha\Desktop\GitHub_Clone_Adaptive_Learning\AdaptiveLearning\test_data_confidence';
    config.meg = false;
    config.scanner = false;
    config.eyeTracker = false;
    config.onlineSaccades = true;
    config.saccThres = 0.7;
    config.useDegreesVisualAngle = true;
    config.distance2screen = 700;
    config.screenWidthInMM = 309.40;
    config.screenHeightInMM = 210;
    config.sendTrigger = false;
    config.sampleRate = 500;
    config.port = hex2dec('E050');
    config.rotationRadPixel = 140;
    config.rotationRadDeg = 2.5;
    config.customInstructions = true;
    config.instructionText = al_commonConfidenceInstructionsDefaultText();
    config.noPtbWarnings = false;
    config.predSpotCircleTolerance = 2;

  
    if config.sendTrigger
        [config.session, ~] = IOPort('OpenSerialPort', 'COM3');
    else
        config.session = nan;
    end
end

