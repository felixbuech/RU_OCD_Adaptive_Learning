function [allTaskData, totWin] = al_HelicopterConditions(taskParam)
%AL_HELICOPTERCONDITIONS This function runs the change-point condition of the cannon
%task tailored to the Leipzig specific Version of the task
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       allTaskData: Structure with all task-data-object instances
%       totWin: Total number of points

% Screen background
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);

% -----------------------------------------------------
% 1. Extract some variables from task-parameters object
% -----------------------------------------------------

runIntro = taskParam.gParam.runIntro;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;
cBal = taskParam.subject.cBal;
passiveViewingCondition = taskParam.gParam.passiveViewing;

% --------------------------------
% 2. Show instructions, if desired
% --------------------------------

% Todo: turn on eye tracker for practice. To monitor saccades. Don't need
% to save et though.

if runIntro && passiveViewingCondition == false

    al_HelicopterInstructions(taskParam)

elseif runIntro && passiveViewingCondition

    % Update trial flow
    taskParam.trialflow.shot = 'static';
    taskParam.trialflow.colors = 'dark';
    taskParam.trialflow.shieldAppearance = 'lines';
    taskParam.trialflow.saveData = 'true';
    taskParam.trialflow.exp = 'passive';
    taskParam.cannon = taskParam.cannon.al_staticConfettiCloud(taskParam.trialflow.colors, taskParam.display);

    % TaskData-object instance
    taskData = al_taskDataMain(taskParam.gParam.passiveViewingPractTrials, taskParam.gParam.taskType);

    % Generate outcomes using cannon-data function using average concentration
    taskData = taskData.al_cannonData(taskParam, haz, mean(concentration), taskParam.gParam.safe);

    % Generate outcomes using confetti-data function
    taskDataPassiveViewingPract = taskData.al_confettiData(taskParam);

    % Run task
    txt = ['Versuchen Sie in dieser Aufgabe bitte in die Mitte '...
        'des Bildschirms zu fixieren. Es ist wichtig, dass Sie Ihre Augen nicht bewegen!\n\n'...
        'Versuchen Sie nur zu blinzeln, wenn der weiße Punkt erscheint. Während dieser Übung '...
        'wird der Versuchsleiter Sie darauf hinweisen.'];
    al_bigScreen(taskParam, 'Übung', txt, true);
    al_helicopterLoop(taskParam, 'main', taskDataPassiveViewingPract, taskParam.gParam.passiveViewingPractTrials, '_p0');

end

% Update trial flow
taskParam.trialflow.shot = 'static';
taskParam.trialflow.colors = 'dark';
taskParam.trialflow.shieldAppearance = 'lines';
taskParam.trialflow.saveData = 'true';

if passiveViewingCondition == false
    taskParam.trialflow.exp = 'exp';
elseif passiveViewingCondition == true
    taskParam.trialflow.exp = 'passive';
end

taskParam.cannon = taskParam.cannon.al_staticConfettiCloud(taskParam.trialflow.colors, taskParam.display);

% ------------------------------
% 3. Optionally baseline arousal
% ------------------------------

if taskParam.gParam.baselineArousal && taskParam.subject.startsWithBlock == 1

    % Display pupil info
    if taskParam.gParam.customInstructions
        header = taskParam.instructionText.firstPupilBaselineHeader;
        txt = taskParam.instructionText.firstPupilBaseline;
    else
        header = 'Erste Pupillenmessung';
        txt=['Sie werden jetzt für drei Minuten verschiedene Farben auf dem Bildschirm sehen. '...
            'Bitte fixieren Sie Ihren Blick währenddessen auf den kleinen Punkt in der Mitte des Bildschirms.'];
    end

    feedback = false; % indicate that this is the instruction mode
    al_bigScreen(taskParam, header, txt, feedback, true);

    % Measure baseline arousal
    al_baselineArousal(taskParam, '_a1')

end

%-------------
% A Reminder message is preseneted before the main task begins
%-------------

header = 'Virusausbruch';
if taskParam.gParam.customInstructions
    txt = taskParam.instructionText.ReminderText;
else
    txt = ['Behalten Sie in Erinnerung: Die Zahl der Infizierten steigt immer weiter.\n' ...
           'Das Überleben der kranken Menschen liegt nun in Ihren Händen.\n\n' ...
           'Jetzt gilt es so viele Medikamente wie möglich zu sichern.\n\nViel Erfolg!'];
end
feedback = false;
al_bigScreen(taskParam, header, txt, feedback);


% ------------
% 4. Main task
% ------------

% Run all task blocks
[totWin, allTaskData] = blockLoop(taskParam, cBal, passiveViewingCondition);

% ------------------------------
% 5. Optionally baseline arousal
% ------------------------------

if taskParam.gParam.baselineArousal

    % Display pupil info
    if taskParam.gParam.customInstructions
        header = taskParam.instructionText.secondPupilBaselineHeader;
        txt = taskParam.instructionText.secondPupilBaseline;
    else
        header = 'Zweite Pupillenmessung';
        txt = ['Sie werden jetzt noch mal für drei Minuten verschiedene Farben auf dem Bildschirm sehen. '...
            'Bitte fixieren Sie Ihren Blick währenddessen auf den kleinen Punkt in der Mitte des Bildschirms.'];
    end

    feedback = false; % indicate that this is the instruction mode
    al_bigScreen(taskParam, header, txt, feedback, true);

    % Meaure baseline arousal
    al_baselineArousal(taskParam, '_a2')

end
end



function [totWin, allTaskData] = blockLoop(taskParam, cBal, passiveViewingCondition)
%BLOCKLOOP - Runs multiple blocks, counterbalancing confidence & noise order
%
%   Input:
%       taskParam: Task-parameter-object instance
%       cBal: Counterbalancing condition (1-4)
%       passiveViewingCondition: Boolean flag for passive-viewing condition
%
%   Output:
%       allTaskData: Structure with all task-data-object instances
%       totWin: Total number of points

trial = taskParam.gParam.trials;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;
totWin = 0;
allTaskData = struct();

% Define block orders based on cBal
% Each row corresponds to Block 1 → Block 2 → Block 3 → Block 4 → Block 5 → Block 6
blockOrders = { 
    % cBal = 1 (NoConf first, Low-High-Low-High | Conf, Low-High)
    [false,1; false,2; false,1; false,2; true,1; true,2]; 
    % cBal = 2 (NoConf first, High-Low-High-Low | Conf, High-Low)
    [false,2; false,1; false,2; false,1; true,2; true,1]; 
    % cBal = 3 (Conf first, Low-High | NoConf, Low-High-Low-High)
    [true,1; true,2; false,1; false,2; false,1; false,2]; 
    % cBal = 4 (Conf first, High-Low | NoConf, High-Low-High-Low)
    [true,2; true,1; false,2; false,1; false,2; false,1];
};

% Get the specific order for this subject
blockOrder = blockOrders{cBal};

for b = 1:taskParam.gParam.nBlocks
    % Extract confidence and noise settings for this block
    taskParam.trialflow.includeConfidence = blockOrder(b,1); % true = Confidence, false = No Confidence
    noiseCondition = blockOrder(b,2); % 1 = Low Noise, 2 = High Noise

    % Task data preparation
    if ~taskParam.unitTest.run
        taskData = al_taskDataMain(trial, taskParam.gParam.taskType);
        taskData = taskData.al_cannonData(taskParam, haz, concentration(noiseCondition), taskParam.gParam.safe);
        taskData = taskData.al_confettiData(taskParam);
        taskData.block(:) = b;
        % taskData.confidence(:) = taskParam.trialflow.includeConfidence; % Store confidence status
        file_name_suffix = sprintf('_b%i', b);
    else
        taskData = taskParam.unitTest.taskDataIntegrationTest_HamburgLowNoise;
        file_name_suffix = '';
    end

    % **Indicate noise condition**
    if noiseCondition == 1
        noiseLabel = 'lowNoise';
    else
        noiseLabel = 'highNoise';
    end
    al_indicateNoise(taskParam, noiseLabel, true, passiveViewingCondition);

    % Determine confidence condition label
    if taskParam.trialflow.includeConfidence
        confidenceLabel = 'WithConfidence';
    else
        confidenceLabel = 'NoConfidence';
    end

    % Generate structured field name for storage
    fieldName = sprintf('%s_%s_Block%d', confidenceLabel, noiseLabel, b);

    % **Run the task**
    data = al_helicopterLoop(taskParam, 'main', taskData, trial, file_name_suffix);

    % Store block data
    data = saveobj(data);
    allTaskData.(fieldName) = data;

    % Update hit counter
    totWin = totWin + sum(data.hit);

    % Short break before next block
    if b < taskParam.gParam.nBlocks
        al_blockBreak(taskParam, b);
    end
end 

end

