function Data = AdaptiveLearning(unitTest)
%ADAPTIVELEARNING   Master function for the cannon task
%   AdaptiveLearning(false) or AdaptiveLearning runs the cannon task.
%   AdaptiveLearning(true) is part of a unit test to control task
%   output after task changes. Scripts for unit test:
%   ~/AdaptiveLearning/DataScripts
%
%   You can choose between four task types:
%   "Dresden version":      Change point task with two control conditions
%                               - optimal learning rate = 1
%                               - optimal learning rate = 0
%   "Oddball version":      Change point task with oddball condition
%   "Reversal version":     Change point task with occasional reversals to
%                           previous change point location
%   "Chinese restaurant":   Change point task with multiple contexts
%
%  Current task conditions:
%   - shield
%       - oddballPractice
%       - oddballPractice_NoOddball
%       - main
%       - mainPractice
%   - followOutcome
%       - followOutcomePractice
%   - followCannon
%       - followCannonPractice
%
%   Current practice conditions (whichPractice):
%       - oddballPractice
%       - cpPractice
%       - followOutcomePractice
%       - followCannonPractice
%
%   Changes in the task (relative to first data collection at Brown):
%   renamed variables:
%       - boatType -> shieldType
%       - sigma -> concentration
%       - vola -> haz
%   added trialsS1 = XX, trialsS2S3 = XX
%
%   29.06.16
%   reversal task
%       - added "initialTendency": inital angle when orange dot is moved
%       - added "RT": reaction time when prediction is made

if nargin == 0
    unitTest = false;
end

if ~unitTest
    clear all
    unitTest = false;
end

% -------------------------------------------------------------------------
% Initialize task
% -------------------------------------------------------------------------

% indentifies your machine; if you have internet!
%computer = identifyPC;
computer = 'Macbook';

% Choose task type:
%   - 'oddball'
%   - 'dresden'
%   - 'reversal'
%   - 'chinese'
taskType = 'chinese';

% version specific parameters
if strcmp(taskType, 'dresden')
    
    trials              = 2; % 240
    controlTrials       = 1; % 120
    concentration       = [12 12 99999999];
    DataFollowOutcome   = nan;
    DataFollowCannon    = nan;
    textSize            = 19;
    
    % Check number of trials in each condition
    if  (trials > 1 && mod(trials, 2)) == 1 || (controlTrials >...
            1 && mod(controlTrials, 2) == 1)
        msgbox('All trials must be even or equal to 1!');
        return
    end
    
elseif strcmp(taskType, 'oddball')
    
    % trials first session
    trialsS1      = 50; % 40
    % trials second session
    trialsS2S3    = 50; % 240
    controlTrials = nan;
    concentration = [10 12 99999999];
    DataOddball   = nan;
    textSize      = 30;
    
elseif strcmp(taskType, 'reversal')
    
    trials          = 20;
    controlTrials   = nan;
    concentration   = [10 12 99999999];
    DataOddball     = nan;
    textSize        = 19;
    
elseif strcmp(taskType, 'chinese')
    
    trials          = 40;
    controlTrials   = nan;
    concentration   = [10 12 99999999];
    DataOddball     = nan;
    textSize        = 19;
    
end

% version independent parameters
runIntro                = false;
askSubjInfo             = true;
sendTrigger             = false;
randomize               = true;
shieldTrials            = 1; % 4
practTrials             = 20; % 20 in reversal muliplied by 2!
blockIndices            = [1 60 120 180];
haz                     = [.25 1 0];
oddballProb             = [.25 0];
reversalProb            = [.5 1];
driftConc               = [30 99999999];
safe                    = [3 0];
rewMag                  = 0.1;
jitter                  = 0.2;
practiceTrialCriterion  = 10;
debug                   = false;

% savedirectory
if isequal(computer, 'Macbook')
    cd('/Users/Bruckner/Dropbox/MATLAB/AdaptiveLearning/DataDirectory');
elseif isequal(computer, 'Dresden')
    cd(['C:\\Users\\TU-Dresden\\Documents\\MATLAB\\AdaptiveLearning'...
        '\\DataDirectory']);
elseif isequal(computer, 'Brown')
    cd('C:\Users\lncc\Dropbox\ReversalTask\data');
end

% -------------------------------------------------------------------------
% User Input
% -------------------------------------------------------------------------

a = clock;
rand('twister', a(6).*10000);

if askSubjInfo == false
    
    ID = '99999';
    age = '99';
    sex = 'm/w';
    cBal = 1;
    reward = 1;
    
    if ~oddball...
            || strcmp(taskType, 'dresden')
        group = '1';
        Subject = struct('ID', ID, 'age', age, 'sex', sex, 'group',...
            group, 'cBal', cBal, 'rew', reward, 'date', date,...
            'session', '1');
    elseif oddball...
            || strcmp(taskType, 'oddball')
        session = '1';
        Subject = struct('ID', ID, 'age', age, 'sex', sex, 'session',...
            session, 'cBal', cBal, 'rew', reward, 'date', date);
    end
    
elseif askSubjInfo == true
    
    if strcmp(taskType, 'dresden')
        prompt = {'ID:','Age:', 'Group:', 'Sex:', 'cBal', 'Reward'};
    elseif strcmp(taskType, 'oddball')
        prompt = {'ID:','Age:', 'Session:', 'Sex:', 'cBal', 'Reward'};
    elseif isequal(taskType, 'reversal')...
            || isequal(taskType, 'chinese')
        prompt = {'ID:','Age:', 'Sex:', 'Reward'};
    end
    
    name = 'SubjInfo';
    numlines = 1;
    
    if randomize
        
        if strcmp(taskType, 'dresden')
            cBal = num2str(round(unifrnd(1,6)));
        elseif strcmp(taskType, 'oddball')
            cBal = num2str(round(unifrnd(1,2)));
        end
        
        reward = num2str(round(unifrnd(1,2)));
        
    else
        cBal = '1';
        reward = '1';
    end
    
    % checken, dass das f�r alle bedingungen stimmt
    if strcmp(taskType, 'dresden')...
            || strcmp(taskType, 'oddball')
        defaultanswer = {'99999','99', '1', 'm', cBal, reward};
    elseif strcmp(taskType, 'reversal') || strcmp(taskType, 'chinese')
        defaultanswer = {'99999','99', 'm', reward};
    else
        defaultanswer = {'99999','99', 'm', cBal, reward};
    end
    
    subjInfo = inputdlg(prompt,name,numlines,defaultanswer);
    if strcmp(taskType, 'dresden') || strcmp(taskType, 'oddball')
        subjInfo{7} = date;
    elseif strcmp(taskType, 'reversal')
        subjInfo{5} = date;
    else
        subjInfo{6} = date;
    end
    
    if numel(subjInfo{1}) < 5 ...
        || numel(subjInfo{1}) > 5
        msgbox('ID: must consist of five numbers!');
        return
    end
    
    if strcmp(taskType, 'dresden')
        if subjInfo{3} ~= '1'...
                && subjInfo{3} ~= '2'
            msgbox('Group: "1" or "2"?');
            return
        end
    elseif strcmp(taskType, 'oddball')
        if subjInfo{3} ~= '1'...
                && subjInfo{3} ~= '2' && subjInfo{3} ~= '3'
            msgbox('Session: "1", "2" or "3"?');
            return
        end
        
    end
    
    if strcmp(taskType, 'dresden')...
            || strcmp(taskType, 'oddball')
        if subjInfo{4} ~= 'm'...
                && subjInfo{4} ~= 'f'
            msgbox('Sex: "m" or "f"?');
            return
            
        end
    else
        if subjInfo{3} ~= 'm'...
                && subjInfo{4} ~= 'f'
            msgbox('Sex: "m" or "f"?');
            return
            
        end
    end
    
    if strcmp(taskType, 'dresden')
        if subjInfo{5} ~= '1'...
                && subjInfo{5} ~= '2'...
                && subjInfo{5} ~= '3'...
                && subjInfo{5} ~= '4'...
                && subjInfo{5} ~= '5'...
                && subjInfo{5} ~= '6'
            msgbox('cBal: 1, 2, 3, 4, 5 or 6?');
            return
        end
    elseif strcmp(taskType, 'oddball')
        if subjInfo{5} ~= '1'...
                && subjInfo{5} ~= '2'
            msgbox('cBal: 1 or 2 ?');
            return
        end
%     elseif strcmp(taskType, 'reversal')
%         if subjInfo{4} ~= '1'...
%                 && subjInfo{4} ~= '2'
%             msgbox('cBal: 1 or 2 ?');
%             return
%         end
    end
    
    if strcmp(taskType, 'dresden') || strcmp(taskType, 'oddball')
        if subjInfo{6} ~= '1'...
                && subjInfo{6} ~= '2'
            msgbox('Reward: 1 or 2?');
            return
        end
    elseif strcmp(taskType, 'reversal')
        if subjInfo{4} ~= '1'...
                && subjInfo{4} ~= '2'
            msgbox('Reward: 1 or 2?');
            return
        end
    end
    
    if strcmp(taskType, 'dresden')
        
        Subject = struct('ID', subjInfo(1), 'age', subjInfo(2), 'sex',...
            subjInfo(4), 'group', subjInfo(3), 'cBal',...
            str2double(cell2mat(subjInfo(5))), 'rew',...
            str2double(cell2mat(subjInfo(6))), 'date',...
            subjInfo(7), 'session', '1');
        
    elseif strcmp(taskType, 'oddball')
        
        Subject = struct('ID', subjInfo(1), 'age', subjInfo(2), 'sex',...
            subjInfo(4), 'session', subjInfo(3), 'cBal',...
            str2double(cell2mat(subjInfo(5))), 'rew',...
            str2double(cell2mat(subjInfo(6))), 'date', subjInfo(7));
        
    elseif strcmp(taskType, 'reversal') || strcmp(taskType, 'chinese')
        
        Subject = struct('ID', subjInfo(1), 'age', subjInfo(2), 'sex',...
            subjInfo(3), 'rew', str2double(cell2mat(subjInfo(4))),...
            'date',subjInfo(5), 'session', '1', 'cBal', nan);
        
    end
    
    if strcmp(taskType, 'dresden')...
            || strcmp(taskType, 'reversal')...
            || strcmp(taskType, 'chinese')
        checkIdInData = dir(sprintf('*%s*',...
            num2str(cell2mat((subjInfo(1))))));
    elseif strcmp(taskType, 'oddball')
        checkIdInData = dir(sprintf('*%s_session%s*',...
            num2str(cell2mat((subjInfo(1)))),...
            num2str(cell2mat((subjInfo(3))))));
    end
    
    fileNames = {checkIdInData.name};
    
    if  ~isempty(fileNames);
        if strcmp(taskType, 'dresden')
            msgbox('Diese ID wird bereits verwendet!');
        elseif strcmp(taskType, 'oddball') ||...
                strcmp(taskType, 'reversal') || strcmp(taskType, 'chinese')
            msgbox('ID and session have already been used!');
        end
        return
    end
end

if isequal(taskType, 'oddball') && isequal(Subject.session, '1')
    trials = trialsS1;
elseif isequal(taskType, 'oddball') && isequal(Subject.session, '3')
    trials = trialsS2S3;
end

% -------------------------------------------------------------------------
% Initialize task
% -------------------------------------------------------------------------

% deal with psychtoolbox warnings
Screen('Preference', 'VisualDebugLevel', 3);
Screen('Preference', 'SuppressAllWarnings', 1);
Screen('Preference', 'SkipSyncTests', 2);

% get screen properties
screensize = get(0,'MonitorPositions');
screensizePart = (screensize(3:4));
zero = screensizePart / 2;
[window.onScreen, windowRect, textures] = OpenWindow;
[window.screenX, window.screenY] = Screen('WindowSize',...
    window.onScreen);
window.centerX      = window.screenX * 0.5; % center of screen in X direction
window.centerY      = window.screenY * 0.5; % center of screen in Y direction
window.centerXL     = floor(mean([0 window.centerX])); % center of left half
% of screen in X direction
window.centerXR     = floor(mean([window.centerX window.screenX])); % center
%of right half of screen in X direction

% define variable names
fieldNames = struct('actJitter', 'actJitter', 'block', 'block',...
    'initiationRTs', 'initiationRTs', 'timestampOnset', 'timestampOnset',...
    'timestampPrediction', 'timestampPrediction', 'timestampOffset',...
    'timestampOffset', 'oddBall', 'oddBall', 'oddballProb',...
    'oddballProb', 'driftConc', 'driftConc', 'allASS', 'allASS', 'ID',...
    'ID', 'concentration', 'concentration', 'age', 'age', 'sex', 'sex',...
    'rew', 'rew', 'actRew', 'actRew', 'date','Date', 'cond', 'cond',...
    'trial', 'trial', 'outcome', 'outcome','distMean', 'distMean', 'cp',...
    'cp', 'haz', 'haz', 'TAC', 'TAC', 'shieldType','shieldType',...
    'catchTrial', 'catchTrial', 'triggers', 'triggers', 'pred',...
    'pred','predErr', 'predErr', 'memErr', 'memErr', 'UP', 'UP',...
    'hit', 'hit', 'cBal', 'cBal', 'perf', 'perf', 'accPerf', 'accPerf',...
    'reversalProb', 'reversalProb');

% set sentence length for text printed on screen
if isequal(computer, 'Dresden')
    sentenceLength = 70;
elseif isequal(computer, 'Brown')
    sentenceLength = 75;
else
    sentenceLength = 85;
end

% wof�r?
startTime = GetSecs;
ref = GetSecs;

% general task parameters
gParam = struct('taskType', taskType ,'jitter', jitter,...
    'blockIndices', blockIndices, 'ref', ref, 'sentenceLength',...
    sentenceLength, 'driftConc', driftConc,...
    'oddballProb', oddballProb, 'reversalProb', reversalProb,...
    'concentration', concentration, 'haz', haz,...
    'sendTrigger', sendTrigger, 'computer', computer, 'trials',...
    trials, 'shieldTrials', shieldTrials, 'practTrials', practTrials,...
    'controlTrials', controlTrials, 'safe', safe, 'rewMag', rewMag,...
    'screensize', screensize, 'zero', zero,'window', window,...
    'windowRect', windowRect, 'practiceTrialCriterion',...
    practiceTrialCriterion, 'askSubjInfo', askSubjInfo);

predSpotRad         = 10;
shieldAngle         = 30;
outcSize            = 10;
cannonEnd           = 5;
meanPoint           = 1;
rotationRad         = 150;
tendencyThreshold   = 15;
predSpotDiam        = predSpotRad * 2;
outcDiam            = outcSize * 2;
spotDiamMean        = meanPoint * 2;
cannonEndDiam       = cannonEnd * 2;
predSpotRect        = [0 0 predSpotDiam predSpotDiam];
outcRect            = [0 0 outcDiam outcDiam];
cannonEndRect       = [0 0 cannonEndDiam cannonEndDiam];
spotRectMean        = [0 0 spotDiamMean spotDiamMean];
boatRect            = [0 0 50 50];
centBoatRect        = CenterRect(boatRect, windowRect);
predCentSpotRect    = CenterRect(predSpotRect, windowRect);
outcCentRect        = CenterRect(outcRect, windowRect);
outcCentSpotRect    = CenterRect(outcRect, windowRect);
cannonEndCent       = CenterRect(cannonEndRect, windowRect);
centSpotRectMean    = CenterRect(spotRectMean,windowRect);
unit                = 2*pi/360;
initialRotAngle     = 0*unit;
rotAngle            = initialRotAngle;

% parameters related to the circle
circle = struct('shieldAngle', shieldAngle, 'cannonEndCent',...
    cannonEndCent, 'outcCentSpotRect', outcCentSpotRect,...
    'predSpotRad', predSpotRad, 'outcSize', outcSize, 'meanRad',...
    meanPoint, 'rotationRad', rotationRad, 'tendencyThreshold',...
    tendencyThreshold, 'predSpotDiam', predSpotDiam, 'outcDiam',...
    outcDiam, 'spotDiamMean', spotDiamMean, 'predSpotRect',...
    predSpotRect, 'outcRect', outcRect, 'spotRectMean',...
    spotRectMean, 'boatRect', boatRect, 'centBoatRect', centBoatRect,...
    'predCentSpotRect', predCentSpotRect, 'outcCentRect', outcCentRect,...
    'centSpotRectMean', centSpotRectMean, 'unit', unit,...
    'initialRotAngle', initialRotAngle, 'rotAngle', rotAngle);

% parameters related to color
gold    = [255 215 0];
blue    = [0 0 255];
silver  = [160 160 160];
green   = [0 255 0];
colors  = struct('gold', gold, 'blue', blue, 'silver', silver,...
    'green', green);

% parameters related to keyboard
KbName('UnifyKeyNames')
rightKey = KbName('j');
leftKey = KbName('f');
delete = KbName('DELETE');
rightArrow = KbName('RightArrow');
leftArrow = KbName('LeftArrow');
rightSlowKey = KbName('h');
leftSlowKey = KbName('g');
space = KbName('Space');

if isequal(computer, 'Macbook')
    enter = 40;
    s = 22;
    t = 23;
    z = 28;
elseif isequal(computer, 'Dresden')
    enter = 13;
    s = 83;
elseif isequal(computer, 'Brown')
    enter = 13;
    s = 83;
end

keys = struct('delete', delete, 'rightKey', rightKey, 'rightArrow',...
    rightArrow, 'leftArrow', leftArrow, 'rightSlowKey', rightSlowKey,...
    'leftKey', leftKey, 'leftSlowKey', leftSlowKey, 'space', space,...
    'enter', enter, 's', s, 't', t, 'z', z);

% parameters related to triggers
if sendTrigger == true
    config_io;
end

% matt fragen ob es nicht 500 war
sampleRate = 512; % sample rate
%fPort = 'port'; port = 53328; % LPT port (Dresden)
%LPT1address = hex2dec('E050'); %standard location of LPT1 port % copied
%from heliEEG_main
%fPort = 'port';
port = hex2dec('E050'); % LPT port
triggers = struct('sampleRate', sampleRate, 'port', port);

% -------------------------------------------------------------------------
% Start task
% -------------------------------------------------------------------------

IndicateFollowCannon = 'Follow Cannon Task';
IndicateFollowOutcome = 'Follow Outcome Task';
fTxtPressEnter = 'txtPressEnter';

if isequal(taskType, 'oddball')
    
    header = 'Real Task!';
    txtPressEnter = 'Press Enter to continue';
    if Subject.cBal == 1
        txtStartTask = ['This is the beginning of the real task. '...
            'During this block you will earn real money for your '...
            'performance. The trials will be exactly the same as those '...
            'in the previous practice block. On each trial a cannon '...
            'will aim at a location on the circle. On most trials the '...
            'cannon will fire a ball somewhere near the point of aim. '...
            'However, on a few trials a ball will be shot from a '...
            'different cannon that is equally likely to hit any '...
            'location on the circle. Like in the previous block you '...
            'will not see the cannon, but still have to infer its '...
            'aim in order to catch balls and earn money.'];
    else
        txtStartTask = ['This is the beginning of the real task. '...
            'During this block you will earn real money for your '...
            'performance. The trials will be exactly the same as '...
            'those in the previous practice block. On each trial a '...
            'cannon will aim at a location on the circle. On all '...
            'trials the cannon will fire a ball somewhere near the '...
            'point of aim. Most of the time the cannon will remain '...
            'aimed at the same location, but occasionally the cannon '...
            'will be reaimed. Like in the previous block you will not '...
            'see the cannon, but still have to infer its aim in order '...
            'to catch balls and earn money.'];
    end
    
elseif isequal(taskType, 'dresden')
    
    txtPressEnter = 'Weiter mit Enter';
    header = 'Anfang der Studie';
    if Subject.cBal == 1
        txtStartTask = ['Du hast die �bungsphase abgeschlossen. Kurz '...
            'zusammengefasst f�ngst du also die meisten '...
            'Kugeln, wenn du den orangenen Punkt auf die Stelle '...
            'bewegst, auf die die Kanone zielt. Weil du die '...
            'Kanone nicht mehr sehen kannst, musst du diese '...
            'Stelle aufgrund der Position der letzten Kugeln '...
            'einsch�tzen. Das Geld f�r die gefangenen '...
            'Kugeln bekommst du nach der Studie '...
            'ausgezahlt.\n\nViel Erfolg!'];
    else
        txtStartTask = ['Du hast die �bungsphase abgeschlossen. Kurz '...
            'zusammengefasst ist es deine Aufgabe Kanonenkugeln '...
            'aufzusammeln, indem du deinen Korb '...
            'an der Stelle platzierst, wo die letzte Kanonenkugel '...
            'gelandet ist (schwarzer Strich). '...
            'Das Geld f�r die gesammelten '...
            'Kugeln bekommst du nach der Studie '...
            'ausgezahlt.\n\nViel Erfolg!'];
    end
    
elseif isequal(taskType, 'reversal')
    
    txtPressEnter = 'Press Enter to continue';

elseif isequal(taskType, 'chinese')
    
    txtPressEnter = 'Press Enter to continue';
    
end

strings = struct(fTxtPressEnter, txtPressEnter);
taskParam = struct('gParam', gParam, 'circle', circle, 'keys', keys,...
    'fieldNames', fieldNames, 'triggers', triggers,...
    'colors', colors, 'strings', strings, 'textures', textures,...
    'unitTest', unitTest);

if isequal(taskType, 'dresden')
    
    % ---------------------------------------------------------------------
    % Dresden version
    % ---------------------------------------------------------------------
    
    if Subject.cBal == 1
        DataMain = MainCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowOutcome = FollowOutcomeCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowCannon = FollowCannonCondition;
        
    elseif Subject.cBal == 2
        
        DataMain = MainCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowCannon = FollowCannonCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowOutcome = FollowOutcomeCondition;
        
    elseif Subject.cBal == 3
        
        DataFollowOutcome = FollowOutcomeCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataMain = MainCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowCannon = FollowCannonCondition;
        
    elseif Subject.cBal == 4
        
        DataFollowCannon = FollowCannonCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataMain = MainCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowOutcome = FollowOutcomeCondition;
        
    elseif Subject.cBal == 5
        
        DataFollowOutcome = FollowOutcomeCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowCannon = FollowCannonCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataMain = MainCondition;
        
    elseif Subject.cBal == 6
        
        DataFollowCannon = FollowCannonCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowOutcome = FollowOutcomeCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataMain = MainCondition;
        
    end
    
elseif isequal(taskType, 'oddball')
    
    % ---------------------------------------------------------------------
    % Oddball version
    % ---------------------------------------------------------------------
    
    if Subject.cBal == 1
        DataOddball = OddballCondition;
        DataMain = MainCondition;
    elseif Subject.cBal == 2
        DataMain = MainCondition;
        DataOddball = OddballCondition;
    end
    
elseif isequal(taskType, 'reversal')
    
    % ---------------------------------------------------------------------
    % Reversal version
    % ---------------------------------------------------------------------
    
    DataReversal = ReversalCondition;
    
elseif isequal(taskType, 'chinese')
    
    % ---------------------------------------------------------------------
    % Chinese restaurant version
    % ---------------------------------------------------------------------
    
    DataChinese = ChineseCondition;
    
end

% ---------------------------------------------------------------------
% Translate performance into monetary reward
% ---------------------------------------------------------------------

if isequal(taskType, 'dresden')
    totWin = DataFollowOutcome.accPerf(end) + DataMain.accPerf(end)...
        + DataFollowCannon.accPerf(end);
elseif isequal(taskType, 'oddball')
    totWin = DataOddball.accPerf(end) + DataMain.accPerf(end);
elseif isequal(taskType, 'reversal')
    totWin = DataReversal.accPerf(end);
end

if isequal(taskType, 'dresden')
    Data.DataMain = DataMain;
    Data.DataFollowOutcome = DataFollowOutcome;
    Data.DataFollowCannon = DataFollowCannon;
elseif isequal(taskType, 'oddball')
    Data.DataMain = DataMain;
    Data.DataOddball = DataOddball;
elseif isequal(taskType, 'reversal')
    Data.DataReversal = DataReversal;
end

% -------------------------------------------------------------------------
% End of task
% -------------------------------------------------------------------------

EndOfTask
ListenChar();
ShowCursor;
Screen('CloseAll');

% -------------------------------------------------------------------------
% Additional functions
% -------------------------------------------------------------------------

    function DataOddball = OddballCondition
        %ODDBALLCONDITION   Runs the oddball condition of the cannon task
        
        if runIntro && ~unitTest
            
            if isequal(Subject.session, '1')
                
                Instructions(taskParam, 'oddballPractice', Subject);
                
            elseif isequal(Subject.session, '2') ||...
                    isequal(Subject.session, '3')
                header = 'Oddball Task';
                txtStartTask = ['This is the beginning of the ODDBALL '...
                    'TASK. During this block you will earn real money '...
                    'for your performance. The trials will be exactly '...
                    'the same as those in the in the last session.\n\n'...
                    'On each trial a cannon will aim at a location on '...
                    'the circle. On most trials the cannon will fire a'...
                    'ball somewhere near the point of aim. '...
                    'However, on a few trials a ball will be shot '...
                    'from a different cannon that is equally likely to '...
                    'hit any location on the circle. Like in the '...
                    'previous session you will not see the cannon, '...
                    'but still have to infer its aim in order to catch '...
                    'balls and earn money.'];
                feedback = false;
                BigScreen(taskParam, txtPressEnter, header,...
                    txtStartTask, feedback);
                
            end
            
        end
        [~, DataOddball] = Main(taskParam, haz(1), concentration(1),...
            'oddball', Subject);
        
    end

    function DataMain = MainCondition
        %MAINCONDITION   Runs the change point condition of the cannon task
        
        if runIntro && ~unitTest
            
            if isequal(Subject.session, '1')
                
                if ~oddball
                    
                    if isequal(Subject.group, '1')
                        
                        txtStartTask = ['Du hast die �bungsphase '...
                            'abgeschlossen. Kurz zusammengefasst '...
                            'wehrst du also die meisten Kugeln ab, '...
                            'wenn du den orangenen Punkt auf die '...
                            'Stelle bewegst, auf die die Kanone zielt. '...
                            'Weil du die Kanone meistens nicht mehr '...
                            'sehen kannst, musst du diese Stelle '...
                            'aufgrund der Position der letzten Kugeln '...
                            'einsch�tzen. Das Geld f�r die abgewehrten '...
                            'Kugeln bekommst du nach der Studie '...
                            'ausgezahlt.\n\nViel Erfolg!'];
                        
                    else
                        
                        txtStartTask = ['Sie haben die �bungsphase '...
                            'abgeschlossen. Kurz zusammengefasst '...
                            'wehren Sie also die meisten Kugeln ab, '...
                            'wenn Sie den orangenen Punkt auf die '...
                            'Stelle bewegen, auf die die Kanone zielt. '...
                            'Weil Sie die Kanone meistens nicht mehr '...
                            'sehen k�nnen, m�ssen Sie diese Stelle '...
                            'aufgrund der Position der letzten Kugeln '...
                            'einsch�tzen. Das Geld f�r die abgewehrten '...
                            'Kugeln bekommen Sie nach der Studie '...
                            'ausgezahlt.\n\nViel Erfolg!'];
                        
                    end
                    
                end
                
                Instructions(taskParam, 'mainPractice', Subject);
                if ~oddball
                    Main(taskParam, haz(3), concentration(1),...
                        'mainPractice', Subject);
                    feedback = false;
                    BigScreen(taskParam, txtPressEnter, header,...
                        txtStartTask, feedback);
                end
                
            else
                
                header = 'Change Point Task';
                txt = ['This is the beginning of the CHANGE POINT '...
                    'TASK. During this block you will earn real money '...
                    'for your performance. The trials will be exactly '...
                    'the same as those in the previous session.\n\n'...
                    'On each trial a cannon will aim at a location on '...
                    'the circle. On all trials the cannon will '...
                    'fire a ball somewhere near the point of aim. '...
                    'Most of the time the cannon will remain aimed at '...
                    'the same location, but occasionally the cannon '...
                    'will be reaimed. Like in the previous '...
                    'session you will not see the cannon, but still '...
                    'have to infer its aim in order to catch balls and '...
                    'earn money.'];
                feedback = false;
                BigScreen(taskParam, txtPressEnter, header, txt, feedback);
                
            end
            
        elseif isequal(Subject.session, '2') ||...
                isequal(Subject.session, '3')
            
            Screen('TextSize', taskParam.gParam.window, 30);
            Screen('TextFont', taskParam.gParam.window, 'Arial');
            VolaIndication(taskParam,txtStartTask, txtPressEnter)
            
        end
        [~, DataMain] = Main(taskParam, haz(1), concentration(1),...
            'main', Subject);
        
    end

    function DataFollowOutcome = FollowOutcomeCondition
        %FOLLOWOUTCOMECONDITION   Runs the follow outcome condition of the
        %cannon task
        
        if runIntro && ~unitTest
            
            if isequal(Subject.group, '1')
                
                txtStartTask = ['Du hast die �bungsphase '...
                    'abgeschlossen. Kurz zusammengefasst ist es deine '...
                    'Aufgabe Kanonenkugeln aufzusammeln, indem du '...
                    'deinen Korb an der Stelle platzierst, wo die '...
                    'letzte Kanonenkugel gelandet ist (schwarzer '...
                    'Strich). Das Geld f�r die gesammelten '...
                    'Kugeln bekommst du nach der Studie '...
                    'ausgezahlt.\n\nViel Erfolg!'];
                
            else
                
                txtStartTask = ['Sie haben die �bungsphase '...
                    'abgeschlossen. Kurz zusammengefasst ist es Ihre '...
                    'Aufgabe Kanonenkugeln aufzusammeln, indem Sie '...
                    'Ihren Korb an der Stelle platzieren, wo die '...
                    'letzte Kanonenkugel gelandet ist (schwarzer '...
                    'Strich). Das Geld f�r die gesammelten '...
                    'Kugeln bekommen Sie nach der Studie '...
                    'ausgezahlt.\n\nViel Erfolg!'];
                
            end
            
            Instructions(taskParam, 'followOutcomePractice', Subject)
            Main(taskParam, haz(3),concentration(1),...
                'followOutcomePractice', Subject);
            feedback = false;
            BigScreen(taskParam, txtPressEnter, header, txtStartTask,...
                feedback);
            
        else
            
            Screen('TextSize', taskParam.gParam.window, 30);
            Screen('TextFont', taskParam.gParam.window, 'Arial');
            VolaIndication(taskParam, IndicateFollowOutcome, txtPressEnter)
            
        end
        
        [~, DataFollowOutcome] = Main(taskParam, haz(1),...
            concentration(1), 'followOutcome', Subject);

    end

    function DataFollowCannon = FollowCannonCondition
        %FOLLOWCANNONCONDITION   Runs the follow the cannon condition of
        %the cannon task
        
        if runIntro && ~unitTest
            
            if isequal(Subject.group, '1')
                txtStartTask = ['Du hast die �bungsphase '...
                    'abgeschlossen. Kurz zusammengefasst wehrst du '...
                    'die meisten Kugeln ab, wenn du den orangenen '...
                    'Punkt auf die Stelle bewegst, auf die die Kanone '...
                    'zielt (schwarze Nadel). Dieses Mal kannst du die '...
                    'Kanone sehen.\n\nViel Erfolg!'];      
            else 
                txtStartTask = ['Sie haben die �bungsphase '...
                    'abgeschlossen. Kurz zusammengefasst wehren Sie '...
                    'die meisten Kugeln ab, wenn Sie den orangenen '...
                    'Punkt auf die Stelle bewegen, auf die die Kanone '...
                    'zielt (schwarze Nadel). Dieses Mal k�nnen Sie die '...
                    'Kanone sehen.\n\nViel Erfolg!'];
            end
            
            Instructions(taskParam, 'followCannonPractice', Subject)
            Main(taskParam, haz(3),concentration(1),...
                'followCannonPractice', Subject);
            feedback = false;
            BigScreen(taskParam, txtPressEnter, header, txtStartTask,...
                feedback);
            
        else
            
            Screen('TextSize', taskParam.gParam.window, 30);
            Screen('TextFont', taskParam.gParam.window, 'Arial');
            VolaIndication(taskParam, IndicateFollowCannon, txtPressEnter)
            
        end
        
        [~, DataFollowCannon] = Main(taskParam, haz(1),...
            concentration(1), 'followCannon', Subject);
        
    end

    function DataReversal = ReversalCondition
        %REVERSALCONDITION   Runs the reversal condition of the cannon task
        
        if runIntro && ~unitTest
            
            Instructions(taskParam, 'reversal', Subject);
            Data = Main(taskParam, haz(1), concentration(1),...
                'reversalPractice', Subject); %'reversalPracticeNoiseInv3'
            %Data.cp
            %Data.reversal
            header = 'Beginning of the Task';
            txtStartTask = ['This is the beginning of the task. During '...
                'this block you will earn real money for your '...
                'performance. The trials will be exactly the same as '...
                'those in the in the practice session.\n\nOn each '...
                'trial a cannon will aim at a location on the circle. '...
                'The cannon will fire a ball somewhere near the point '...
                'of aim. Most of the time the cannon will remain aimed '...
                'at the same location, but occasionally the cannon '...
                'will be reaimed, either to the previous aim or to a '...
                'new aim. Like in the previous session you will not '...
                'see the cannon, but have to infer its aim in order '...
                'to catch balls and earn money.'];
            feedback = false;
            BigScreen(taskParam, txtPressEnter, header, txtStartTask,...
                feedback);
            
        end
        
        [~, DataReversal] = Main(taskParam, haz(1), concentration(1),...
            'reversal', Subject);
        
    end

    function DataChinese = ChineseCondition
    %CHINESECONDITION   Runs the chinese condition of the cannon task
    
     [~, DataChinese] = Main(taskParam, haz(1), concentration(1),...
            'chinese', Subject);
    
    end

    function [window, windowRect, textures] = OpenWindow
        %OPENWINDOW   Opens the psychtoolbox screen
        
        if debug == true
            [ window, windowRect] = Screen('OpenWindow',...
                0, [66 66 66], [420 250 1020 650]);
        else
            [ window, windowRect ] = Screen('OpenWindow',...
                0, [66 66 66], []);
        end
        
        imageRect = [0 0 120 120];
        dstRect = CenterRect(imageRect, windowRect);
        [cannonPic, ~, alpha]  = imread('cannon.png');
        cannonPic(:,:,4) = alpha(:,:);
        Screen('BlendFunction', window, GL_SRC_ALPHA,...
            GL_ONE_MINUS_SRC_ALPHA);
        cannonTxt = Screen('MakeTexture', window, cannonPic);
        [shieldPic, ~, alpha]  = imread('shield.png');
        shieldPic(:,:,4) = alpha(:,:);
        shieldTxt = Screen('MakeTexture', window, shieldPic);
        [basketPic, ~, alpha]  = imread('basket.png');
        basketPic(:,:,4) = alpha(:,:);
        basketTxt = Screen('MakeTexture', window, basketPic);
        textures = struct('cannonTxt', cannonTxt, 'shieldTxt',...
            shieldTxt, 'basketTxt', basketTxt, 'dstRect', dstRect);
        %ListenChar(2);
        %HideCursor;
        
    end

    function window = CloseScreenAndOpenAgain
        %CLOSESCREENANDOPENAGAIN   Opens and closes psychtoolbox screen
        %at the end of a condition in order to signal participants that 
        %new task will begin
        
        if ~unitTest
            
            Screen('TextFont', taskParam.gParam.window, 'Arial');
            Screen('TextSize', taskParam.gParam.window, 30);
            
            txt='Ende der Aufgabe!\n\nBitte auf den Versuchsleiter warten';
            
            while 1
                
                Screen('FillRect', taskParam.gParam.window, []);
                DrawFormattedText(taskParam.gParam.window, txt,...
                    'center', 100, [0 0 0]);
                Screen('DrawingFinished', taskParam.gParam.window);
                
                
                t = GetSecs;
                Screen('Flip', taskParam.gParam.window, t + 0.1);
                [~, ~, keyCode] = KbCheck;
                
                if find(keyCode) == taskParam.keys.s
                    break
                end
                
            end
            
            WaitSecs(1);
            ShowCursor;
            Screen('CloseAll');
            disp('Press start to continue...')
            WaitSecs(1);
            
            while 1
                [ keyIsDown, ~, keyCode ] = KbCheck;
                if keyIsDown
                    if keyCode(taskParam.keys.s)
                        break
                    end
                end
            end
            
            window = OpenWindow;
            
        end
        window = taskParam.gParam.window;
    end

    function EndOfTask
        %ENDOFTASK   Screen that shows collected amount of money
        
        while 1
            
            if isequal(taskType, 'oddball') ||...
                    isequal(taskType, 'reversal')
                header = 'End of task!';
                txt = sprintf(['Thank you for participating!'...
                    '\n\n\nYou earned $ %.2f'], totWin);
            elseif isequal(taskType, 'dresden')
                header = 'Ende des Versuchs!';
                if isequal(Subject.group, '1')
                    txt = sprintf(['Vielen Dank f�r deine Teilnahme!'
                        '\n\n\nDu hast %.2f Euro verdient'], totWin);
                else
                    txt = sprintf(['Vielen Dank f�r Ihre Teilnahme!'...
                        '\n\n\nSie haben %.2f Euro verdient'], totWin);
                end
            end
            Screen('DrawLine', taskParam.gParam.window.onScreen,...
                [0 0 0], 0, taskParam.gParam.screensize(4)*0.16,...
                taskParam.gParam.screensize(3),...
                taskParam.gParam.screensize(4)*0.16, 5);
            Screen('DrawLine', taskParam.gParam.window.onScreen,...
                [0 0 0], 0, taskParam.gParam.screensize(4)*0.8,...
                taskParam.gParam.screensize(3),...
                taskParam.gParam.screensize(4)*0.8, 5);
            Screen('FillRect', taskParam.gParam.window.onScreen,...
                [0 25 51],...
       [0, (taskParam.gParam.screensize(4)*0.16)+3,...
                taskParam.gParam.screensize(3),...
                (taskParam.gParam.screensize(4)*0.8)-2]);
            Screen('TextSize', taskParam.gParam.window.onScreen, 30);
            DrawFormattedText(taskParam.gParam.window.onScreen, header,...
                'center', taskParam.gParam.screensize(4)*0.1);
            Screen('TextSize', taskParam.gParam.window.onScreen, textSize);
            DrawFormattedText(taskParam.gParam.window.onScreen, txt,...
                'center', 'center');
            Screen('DrawingFinished', taskParam.gParam.window.onScreen,...
                [], []);
            time = GetSecs;
            Screen('Flip', taskParam.gParam.window.onScreen, time + 0.1);
            
            [ ~, ~, keyCode] = KbCheck;
            
            
            if find(keyCode) == taskParam.keys.s & ~taskParam.unitTest
                break
            elseif taskParam.unitTest
                WaitSecs(1);
                break
            end
            
        end
        
    end

sprintf('total time: %s minutes', (GetSecs - startTime)/60)

end

