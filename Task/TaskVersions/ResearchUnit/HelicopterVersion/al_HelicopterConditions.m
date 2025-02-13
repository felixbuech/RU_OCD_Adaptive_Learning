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
%BLOCKLOOP This function loops over task blocks for a given noise condition
%
%   Input
%       taskParam: Task-parameter-object instance
%       cBal: Counterbalancing condition
%       passiveViewing: Indicates if we are in passive-viewing condition
%
%   Output
%       allTaskData: Structure with all task-data-object instances
%       totWin: Total number of hits
%


trial = taskParam.gParam.trials;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;
totWin = 0;
allTaskData = struct();

for b = taskParam.subject.startsWithBlock:taskParam.gParam.nBlocks

    % Select noise condition:
    % ----------------------
    % 1) odd & cBal 1 = low
    % 2) even & cBal 2 = low_withConfidence
    % 3) odd & cBal 2 = high
    % 4) even & cBal 1 = high_withConfidence
   
    if (mod(b,2) == 1 && cBal == 1) || (mod(b,2) == 0 && cBal == 2)
    noiseCondition = 1; % High Noise
elseif (mod(b,2) == 1 && cBal == 2) || (mod(b,2) == 0 && cBal == 1)
    noiseCondition = 2; % Low Noise
end

% **Enable confidence rating ONLY for Blocks 3 & 4**
if b >= 3
    taskParam.trialflow.includeConfidence = true;
else
    taskParam.trialflow.includeConfidence = false;
end


    % **Assign confidence rating condition:**
    % Blocks 1 & 2 → No Confidence
    % Blocks 3 & 4 → With Confidence
    if b <= 2
        taskParam.trialflow.includeConfidence = false; % First two blocks → No Confidence
    else
        taskParam.trialflow.includeConfidence = true;  % Last two blocks → With Confidence
    end

    % Task data
    if ~taskParam.unitTest.run
        taskData = al_taskDataMain(trial, taskParam.gParam.taskType);
        taskData = taskData.al_cannonData(taskParam, haz, concentration(noiseCondition), taskParam.gParam.safe);
        taskData = taskData.al_confettiData(taskParam);
        taskData.block(:) = b;
        file_name_suffix = sprintf('_b%i', b);
    else
        if noiseCondition == 1
            taskData = taskParam.unitTest.taskDataIntegrationTest_HamburgLowNoise;
        elseif noiseCondition == 2
            taskData = taskParam.unitTest.taskDataIntegrationTest_HamburgHighNoise;
        end
        file_name_suffix = '';
    end

    % Indicate noise condition for each block
    if noiseCondition == 1
        al_indicateNoise(taskParam, 'lowNoise', true, passiveViewingCondition)
        fieldName = sprintf('lowNoiseBlock%d', b);
    elseif noiseCondition == 2
        al_indicateNoise(taskParam, 'highNoise', true, passiveViewingCondition)
        fieldName = sprintf('highNoiseBlock%d', b);
    end

    % **Run task with or without confidence**
    data = al_confidenceLoop(taskParam, 'main', taskData, trial, file_name_suffix);

    % Store block data
    data = saveobj(data);
    allTaskData.(fieldName) = data;

    % Update hit counter
    totWin = totWin + sum(data.hit);

    % Short break before next block
    if b < taskParam.gParam.nBlocks
        al_blockBreak(taskParam, b)
    end

end
end