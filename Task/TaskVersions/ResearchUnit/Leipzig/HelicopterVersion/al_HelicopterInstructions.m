function al_HelicopterInstructions(taskParam)
%AL_HELICOPTERINSTRUCTIONS This function runs the instructions for the
% Leipzig version of the cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       None

% Extract cBal variable
cBal = taskParam.subject.cBal;

% Adjust trialflow
taskParam.trialflow.cannon = 'show cannon'; % cannon will be displayed
taskParam.trialflow.currentTickmarks = 'hide'; % tick marks initially not shown
taskParam.trialflow.push = 'practiceNoPush'; % turn off push manipulation
taskParam.trialflow.shot = 'animate cannonball'; % in instructions, we animate the confetti
taskParam.trialflow.colors = 'redWhite';
taskParam.trialflow.exp = 'pract'; % ensure that no triggers are sent during practice
taskParam.trialflow.saveData = 'false';
taskParam.trialflow.saveEtData = 'false';

% Set text size and font
Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');

% 1. Present welcome message
% --------------------------

if taskParam.gParam.customInstructions
    txt = taskParam.instructionText.welcomeText;
else
    txt = 'Herzlich Willkommen Zur Konfetti-Kanonen-Aufgabe!';
end

% Load and display welcome image
welcomeImage = imread('NEW_start_image.png'); % Replace with your actual image file
welcomeTexture = Screen('MakeTexture', taskParam.display.window.onScreen, welcomeImage);

while 1
    % Draw image
    Screen('DrawTexture', taskParam.display.window.onScreen, welcomeTexture, [], []);
    
    % Display welcome text
    DrawFormattedText(taskParam.display.window.onScreen, txt, 'center', taskParam.display.screensize(4) * 0.1, [255 255 255]);
    
    % Display "Press Enter" message
    DrawFormattedText(taskParam.display.window.onScreen, 'Drücken Sie Enter, um fortzufahren', 'center', taskParam.display.screensize(4) * 0.9, [255 255 255]);
    
    % Flip screen
    Screen('Flip', taskParam.display.window.onScreen);
    
    % Check for key press
    [~, ~, keyCode] = KbCheck(taskParam.keys.kbDev);
    if keyCode(taskParam.keys.enter)  % If Enter key is pressed, break the loop
        break;
    elseif keyCode(taskParam.keys.esc)  % Allow the user to exit with Escape key
        ListenChar();
        ShowCursor;
        Screen('CloseAll');
        error('User pressed Escape to exit task');
    end
end

% Wait for key release
KbReleaseWait();

% Reset background to gray
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);
Screen('Flip', taskParam.display.window.onScreen);


% 1.B: Display a warning image before the context message
% -------------------------------------------------------

% Load the warning image
warningImage = imread('virus_over_city.png'); 
warningTexture = Screen('MakeTexture', taskParam.display.window.onScreen, warningImage);

% Get screen dimensions
screenRect = Screen('Rect', taskParam.display.window.onScreen);

% Display only the warning image first
Screen('DrawTexture', taskParam.display.window.onScreen, warningTexture, [], []);
Screen('Flip', taskParam.display.window.onScreen);

% Pause before displaying warning text (e.g., 2 seconds)
WaitSecs(2);

% Display warning text
Screen('DrawTexture', taskParam.display.window.onScreen, warningTexture, [], []);
Screen('TextSize', taskParam.display.window.onScreen, 100); % Large font size
DrawFormattedText(taskParam.display.window.onScreen, 'Achtung Virusausbruch!', 'center', 'center', [255 0 0]); % Red color
Screen('Flip', taskParam.display.window.onScreen);

% Pause before displaying instruction text (e.g., 2 more seconds)
WaitSecs(2);

while 1
    % Draw warning image and text again
    Screen('DrawTexture', taskParam.display.window.onScreen, warningTexture, [], []);
    Screen('TextSize', taskParam.display.window.onScreen, 100);
    DrawFormattedText(taskParam.display.window.onScreen, 'Achtung Virusausbruch!', 'center', 'center', [255 0 0]); % Red color

    % Display instruction text at the bottom after delay
    Screen('TextSize', taskParam.display.window.onScreen, 40); % Smaller font size
    DrawFormattedText(taskParam.display.window.onScreen, 'Drücken Sie Enter, um fortzufahren', 'center', screenRect(4) - 100, [255 255 255]); % White text at bottom

    % Flip screen to show updated content
    Screen('Flip', taskParam.display.window.onScreen);
    
    % Check for key press
    [~, ~, keyCode] = KbCheck(taskParam.keys.kbDev);
    if keyCode(taskParam.keys.enter)  % Wait for Enter key
        break;
    elseif keyCode(taskParam.keys.esc)  % Allow user to exit with Escape key
        ListenChar();
        ShowCursor;
        Screen('CloseAll');
        error('User pressed Escape to exit task');
    end
end

% Wait for key release
KbReleaseWait();

% Reset background to gray
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);
Screen('Flip', taskParam.display.window.onScreen);



% 2. Introduce Pandemic Context
% -----------------------------


% Load the pandemic context image (Ensure it's a PNG with transparency)
[contextImage, ~, alpha] = imread('Text_bckg_transparent.png'); 

% Convert grayscale image to RGB (if needed)
if size(contextImage, 3) == 1  
    contextImage = repmat(contextImage, [1, 1, 3]); 
end

% Ensure the alpha channel exists, else create a fully opaque one
if isempty(alpha)
    alpha = uint8(255 * ones(size(contextImage, 1), size(contextImage, 2))); % Fully opaque
end

% Combine image and alpha into an RGBA format
contextImageRGBA = cat(3, contextImage, alpha);

% Create a texture with transparency
contextTexture = Screen('MakeTexture', taskParam.display.window.onScreen, contextImageRGBA);

% Display loop
while 1
    
    % Get screen size
screenRect = Screen('Rect', taskParam.display.window.onScreen);

% Define new size for the image (scale factor)
scaleFactor = 1; % Adjust this value to make the image larger or smaller

% Get original image size
[imageHeight, imageWidth, ~] = size(contextImage);

% Calculate new image position (centered)
newWidth = imageWidth * scaleFactor;
newHeight = imageHeight * scaleFactor;
dstRect = CenterRectOnPoint([0, 0, newWidth, newHeight], screenRect(3)/2, screenRect(4)/2);

% Draw the enlarged context image
Screen('DrawTexture', taskParam.display.window.onScreen, contextTexture, [], dstRect);

    % Set text size and display warning
    Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.headerSize);
    DrawFormattedText(taskParam.display.window.onScreen, 'Achtung Virusausbruch!', 'center', taskParam.display.screensize(4) * 0.08, [255 255 255]);

    % Set text size for paragraph
    Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
    DrawFormattedText(taskParam.display.window.onScreen, taskParam.instructionText.context, 'center', 'center', [255 255 255], 80, [], [], 1.5);

    % Display "Press Enter" message
    DrawFormattedText(taskParam.display.window.onScreen, 'Drücken Sie Enter, um fortzufahren', 'center', taskParam.display.screensize(4) * 0.92, [255 255 255]);

    % Flip screen
    Screen('Flip', taskParam.display.window.onScreen);
    
    % Check for key press
    [~, ~, keyCode] = KbCheck(taskParam.keys.kbDev);
    if keyCode(taskParam.keys.enter)  % If Enter key is pressed, break the loop
        break;
    elseif keyCode(taskParam.keys.esc)  % Allow user to exit with Escape key
        ListenChar();
        ShowCursor;
        Screen('CloseAll');
        error('User pressed Escape to exit task');
    end
end

% Wait for key release
KbReleaseWait();



% 2. Introduce the cannon
% -----------------------

% Load task-data-object instance
nTrials = 4;
taskData = al_taskDataMain(nTrials, taskParam.gParam.taskType);

% Generate practice-phase data
taskData.catchTrial(1:nTrials) = 0; % no catch trials
taskData.initiationRTs(1:nTrials) = nan;  % set initiation RT to nan to indicate that this is the first response
taskData.initialTendency(1:nTrials) = nan;  % set initial tendency of mouse movement
taskData.block(1:nTrials) = 1; % block number
taskData.allShieldSize(1:nTrials) = rad2deg(2*sqrt(1/12)); % shield size
taskData.shieldType(1:nTrials) = 1; % shield color
taskData.distMean = [300, 240, 300, 65]; % aim of the cannon
taskData.outcome = taskData.distMean; % in practice phase, mean and outcome are the same
taskData.pred(1:nTrials) = nan; % initialize predictions
taskData.nParticles(1:nTrials) = taskParam.cannon.nParticles; % number of confetti particles
taskData.greenCaught(1:nTrials) = nan;
taskData.redCaught(1:nTrials) = nan;
for t = 1:nTrials
    taskData.dotCol(t).rgb = taskParam.colors.colorsRedWhite;
end
taskParam.unitTest.pred = [300, 0, 300, 0];

% Introduce cannon
if taskParam.gParam.customInstructions
    txt = taskParam.instructionText.introduceCannon;
else
    txt = ['Sie blicken von oben auf eine Konfetti-Kanone, die in der Mitte eines Kreises positioniert ist. Ihre Aufgabe ist es, das Konfetti mit einem Eimer zu fangen. Mit dem rosafarbenen '...
        'Punkt können Sie angeben, wo auf dem Kreis Sie Ihren Eimer platzieren möchten, um das Konfetti zu fangen. Sie können den Punkt mit der '...
        'Maus steuern.'];
end
currTrial = 1;
taskParam = al_introduceCannon(taskParam, taskData, currTrial, txt);




% 3. Introduce confetti
% ---------------------

if taskParam.gParam.customInstructions
    txt = taskParam.instructionText.introduceConfetti;
else
    txt = 'Das Ziel der Konfetti-Kanone wird mit der schwarzen Linie angezeigt. Steuern Sie den rosafarbenen Punkt auf den Kreis und drücken Sie die linke Maustaste, damit die Konfetti-Kanone schießt.';
end
currTrial = 2; % update trial number
[taskData, taskParam] = al_introduceConfetti(taskParam, taskData, currTrial, txt);

% 4. Introduce prediction spot and ask participant to catch confetti
% ------------------------------------------------------------------

% Add tickmarks to introduce them to participant
taskParam.trialflow.currentTickmarks = 'show';
currTrial = 3; % update trial number

% Repeat as long as subject misses confetti
while 1

    if taskParam.gParam.customInstructions
        txt = taskParam.instructionText.introduceSpot;
    else
        txt = ['Der schwarze Strich zeigt Ihnen die mittlere Position der letzten Konfettiwolke. Der rosafarbene Strich zeigt Ihnen die '...
            'Position Ihres letzten Eimers. Steuern Sie den rosa Punkt jetzt bitte auf das Ziel der Konfetti-Kanone und drücken Sie die linke Maustaste.'];
    end

    [taskData, taskParam, xyExp, dotSize] = al_introduceSpot(taskParam, taskData, currTrial, txt);

    % If it is a miss, repeat instruction
    if abs(taskData.predErr(currTrial)) >= taskParam.gParam.practiceTrialCriterionEstErr

        if taskParam.gParam.customInstructions
            header = taskParam.instructionText.noCatchHeader;
            txt = taskParam.instructionText.noCatch;
        else
            header = 'Leider nicht gefangen!';
            txt = 'Sie haben leider zu wenig Konfetti gefangen. Versuchen Sie es noch mal!';
        end

        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);
    else
        break
    end
end

% 5. Introduce shield
% -------------------

if taskParam.gParam.customInstructions
    txt = taskParam.instructionText.introduceShield;
else
    txt = 'Wenn Sie mindestens die Hälfte des Konfettis im Eimer fangen, zählt es als Treffer und Sie erhalten einen Punkt.';
end

win = true; % color of shield when catch is rewarded
al_introduceShield(taskParam, taskData, win, currTrial, txt, xyExp, taskData.dotCol(currTrial).rgb, dotSize);

% 6. Introduce practice blocks
% ----------------------------

% Display instructions
if taskParam.gParam.customInstructions
    txt = taskParam.instructionText.introducePracticeSession;
else
    txt = 'Im Folgenden durchlaufen Sie ein paar Übungsdurchgänge\nund im Anschluss zwei Durchgänge des Experiments.';
end
header = '';
feedback = true; % present text centrally
al_bigScreen(taskParam, header, txt, feedback);

% 7. Cannon visible
% -----------------

% Display instructions
if taskParam.gParam.customInstructions
    header = taskParam.instructionText.firstPracticeHeader;
    txt = taskParam.instructionText.firstPractice;
else
    header = 'Erster Übungsdurchgang';
    txt=['Weil die Konfetti-Kanone schon sehr alt ist, sind die Schüsse ziemlich ungenau. Das heißt, auch wenn '...
        'Sie genau auf das Ziel gehen, können Sie das Konfetti verfehlen. Die Ungenauigkeit ist zufällig, '...
        'dennoch fangen Sie am meisten Konfetti, wenn Sie den rosanen Punkt genau auf die Stelle '...
        'steuern, auf die die Konfetti-Kanone zielt.\n\nIn dieser Übung sollen Sie mit der Ungenauigkeit '...
        'der Konfetti-Kanone erst mal vertraut werden. Steuern Sie den rosanen Punkt bitte immer auf die anvisierte '...
        'Stelle.'];
end

feedback = false; % indicate that this is the instruction mode
al_bigScreen(taskParam, header, txt, feedback);

% Load outcomes for practice
condition = 'practice';
taskData = load('visCannonPracticeLeipzig.mat'); %% changed to Leipzig for Helicopter Version
taskData = taskData.taskData;
taskData.saveAsStruct = true; % ensure that we save as struct
taskParam.trialflow.exp = 'practVis';
taskParam.trialflow.saveData = 'true';
taskParam.trialflow.shieldAppearance = 'full';

% Reset roation angle to starting location
taskParam.circle.rotAngle = 0;

% Update unit test predictions
taskParam.unitTest.pred = zeros(20,1);

% Initialize block counter
b = 1;
totalFail = 0;

% Run task
while 1


    % File name suffix
    file_name_suffix = sprintf('_b%i', b);

    % Task loop
    taskData = al_helicopterLoop(taskParam, condition, taskData, taskParam.gParam.practTrialsVis, file_name_suffix);

    % If estimation error is larger than a criterion on more than five
    % trials, we repeat the instructions
    repeatBlock = sum(abs(taskData.estErr) >= taskParam.gParam.practiceTrialCriterionEstErr);
    if (sum(repeatBlock) > taskParam.gParam.practiceTrialCriterionNTrials) && taskParam.unitTest.run == false
        WaitSecs(0.5)
       
        % Break out of loop, even if criterion missed, after 3 attempts
        totalFail = totalFail + 1;
        if totalFail == taskParam.gParam.cannonPractFailCrit
            break
        end

        if taskParam.gParam.customInstructions
            header = taskParam.instructionText.practiceBlockFailHeader;
            txt = taskParam.instructionText.practiceBlockFail;
        else
            header = 'Bitte noch mal probieren!';
            txt = ['Sie haben Ihren Eimer oft neben dem Ziel der Kanone platziert. Versuchen Sie im nächsten '...
                'Durchgang bitte, den Eimer direkt auf das Ziel zu steuern. Das Ziel wird mit der Nadel gezeigt.'];
        end

        al_bigScreen(taskParam, header, txt, feedback);
    else
        break
    end

    % Update block counter
    b = b+1;
end

% 8. Reduce shield
% ----------------

% Display instructions
if taskParam.gParam.customInstructions
    header = taskParam.instructionText.reduceShieldHeader;
    txt = taskParam.instructionText.reduceShield;
else
    header = 'Illustration Ihres Eimers';
    txt = ['Ab jetzt sehen Sie den Eimer nur noch mit zwei Strichen dargestellt. Außerdem sehen Sie die Aufgabe in weniger Farben. ' ...
        'Dies ist notwendig, damit wir Ihre Pupillengröße gut messen können. Achten Sie daher bitte besonders darauf, '...
        'Ihren Blick auf den Punkt in der Mitte des Kreises zu fixieren. Bitte versuchen Sie Augenbewegungen und blinzeln '...
        'so gut es geht zu vermeiden.\n\n'...
        'Jetzt folgt zunächst eine kurze Demonstration, wie der Eimer mit Strichen im Vergleich zum Eimer der vorherigen Übung aussieht.'];
end

feedback = false;
al_bigScreen(taskParam, header, txt, feedback);

% Show reduced shield animation
taskData = struct();
taskData.allShieldSize = [20, 30, 15, 50, 10];
taskData.pred = [40, 190, 80, 1, 340];
taskParam.trialflow.colors = 'dark';
taskParam.cannon = taskParam.cannon.al_staticConfettiCloud(taskParam.trialflow.colors, taskParam.display);
al_introduceReducedShield(taskParam, taskData, 5)

% 9. Illustrate and test if subject understands the idea of the cannon mean
% -------------------------------------------------------------------------

% Display instructions
if taskParam.gParam.customInstructions
    header = taskParam.instructionText.secondPracticeHeader;
    txt = taskParam.instructionText.secondPractice;
else
    header = 'Zweiter Übungsdurchgang';
    txt = ['Um sicherzugehen, dass Sie die Aufgabe verstanden haben, machen wir jetzt eine kurze Übung:\n\n'...
        'Sie werden hintereinander fünf Schüsse der Konfetti-Kanone sehen. Danach geben Sie bitte an, wo Sie das Ziel der Konfetti-Kanone vermuten.\n\n'...
        'Die beste Strategie ist, die mittlere Position der Schüsse anzugeben. Diese Position ist die beste Vohersage, um in der Aufgabe am meisten Konfetti zu fangen.'];
end

feedback = false;
al_bigScreen(taskParam, header, txt, feedback);

% TaskData-object instance
nTrials = taskParam.gParam.practTrialsHid; %20; % taskParam.gParam.passiveViewingPractTrials
taskData = al_taskDataMain(nTrials, taskParam.gParam.taskType);
haz = 0;
concentration = 12;

% Update trialflow
taskParam.trialflow.exp = 'cannonPract1';

% Initialize block counter
b = 1;
totalFail = 0;

% Run task
while 1

    % File name suffix
    file_name_suffix = sprintf('_b%i', b);

    % Generate outcomes using cannon-data function using average concentration
    nRep = taskParam.gParam.practTrialsHid/taskParam.gParam.cannonPractNumOutcomes;
    endPoint = taskParam.gParam.practTrialsHid;
    taskParam.gParam.blockIndices = linspace(1, endPoint+1, nRep+1);
    taskParam.gParam.catchTrialProb = 0.0;
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confetti-data function
    taskData = taskData.al_confettiData(taskParam);

    % Run cannon practice
    testPassed = al_cannonPractice(taskParam, taskData, nTrials, file_name_suffix);

    % If estimation error was too large, we repeat the instructions
    if (sum(testPassed) < taskParam.gParam.cannonPractCriterion)  && taskParam.unitTest.run == false
        WaitSecs(0.5)

        % Break out of loop, even if criterion missed, after 3 attempts
        totalFail = totalFail + 1;
        if totalFail == taskParam.gParam.cannonPractFailCrit
            break
        end

        if taskParam.gParam.customInstructions
            header = taskParam.instructionText.practiceBlockFailHeader;
            txt = taskParam.instructionText.cannonPracticeFail;
        else
            header = 'Bitte noch mal probieren!';
            txt = ['Sie haben die Konfetti-Kanone nicht genau genug eingeschätzt. Versuchen Sie im nächsten '...
                'Durchgang bitte, den Mittelpunkt der einzelnen Schüsse auszuwählen. Bei Fragen, wenden Sie sich an die Versuchsleitung.'];
        end
        feedback = true;
        al_bigScreen(taskParam, header, txt, feedback);
    else
        break
    end

    % Update block counter
    b = b+1;
end

% Wait until keys released
KbReleaseWait();

% 11. Introduce hidden confetti cannon
% ------------------------------------

% Update condition
condition = 'cannonPract2';
taskParam.trialflow.exp = condition;

% Display instructions
if taskParam.gParam.customInstructions
    header = taskParam.instructionText.thirdPracticeHeader;
    txt = taskParam.instructionText.thirdPractice;
else
    header = 'Dritter Übungsdurchgang';
    txt = ['In dieser Übung sehen Sie nur noch einen Schuss der Konfetti-Kanone. Bitte geben Sie wieder an, wo Sie die Konfetti-Kanone vermuten.\n\nWenn Sie denken, dass die Konfetti-Kanone ihre Richtung geändert hat, sollten Sie auch den Eimer '...
        'dorthin bewegen.\n\nBeachten Sie, dass Sie das Konfetti trotz '...
        'guter Vorhersagen auch häufig nicht fangen können.'];
end

feedback = false;
al_bigScreen(taskParam, header, txt, feedback);

% Update trial flow
taskParam.trialflow.colors = 'dark';
taskParam.trialflow.shot = 'static';
taskParam.trialflow.shieldAppearance = 'lines';
taskParam.cannon = taskParam.cannon.al_staticConfettiCloud(taskParam.trialflow.colors, taskParam.display);

% todo: think about potential criterion for this one as well

% Load data
taskData = load('cannonPractice.mat');
taskData = taskData.taskData;
taskData.saveAsStruct = true; % ensure that we save as struct

% Update trial flow
taskParam.trialflow.cannon = 'hide cannon'; % don't show cannon anymore
taskParam.trialflow.confetti = 'show confetti cloud';

% Run practice block
al_helicopterLoop(taskParam, condition, taskData, taskParam.gParam.practTrialsHid);




% 11. Introduce hidden confetti cannon
% ------------------------------------

% Update condition
condition = 'main';

% Display instructions
if taskParam.gParam.customInstructions
    header = taskParam.instructionText.fourthPracticeHeader;
    txt = taskParam.instructionText.fourthPractice;
else
    header = 'Vierter Übungsdurchgang';
    txt = ['Jetzt kommen wir zur letzten Übung.\n\nDiesmal müssen Sie mit dem rosafarbenen Punkt Ihr Schild platzieren und sehen dabei die Kanone nicht mehr. Außerdem werden Sie es sowohl mit einer relativ genauen '...
        'als auch einer eher ungenauen versteckten Konfetti-Kanone zu tun haben.\n\n'...
        'Bitte versuchen Sie Augenbewegungen und blinzeln '...
        'so gut es geht zu vermeiden.'...
        '\n\nBeachten Sie bitte auch, dass das Ziel der Konfetti-Kanone in manchen Fällen sichtbar sein wird. In diesen Fällen ist die beste Strategie, zum Ziel der Kanone zu gehen.'];
end

feedback = false;
al_bigScreen(taskParam, header, txt, feedback);

taskParam.trialflow.colors = 'dark';
taskParam.trialflow.shot = 'static';
taskParam.trialflow.exp = 'practHid';
taskParam.trialflow.shieldAppearance = 'lines';
taskParam.cannon = taskParam.cannon.al_staticConfettiCloud(taskParam.trialflow.colors, taskParam.display);

% 1) Low noise
taskData = load('hidCannonPracticeHamburg_c16.mat');
taskDataLowNoise = taskData.taskData;
taskDataLowNoise.saveAsStruct = true; % ensure that we save as struct

% 2) High noise
taskData = load('hidCannonPracticeHamburg_c8.mat');
taskDataHighNoise = taskData.taskData;
taskDataHighNoise.saveAsStruct = true; % ensure that we save as struct

if cBal == 1 || cBal == 2 

    % Low noise first...
    % ------------------

    taskParam.trialflow.cannon = 'hide cannon'; % don't show cannon anymore
    taskParam.trialflow.confetti = 'show confetti cloud';
    al_indicateNoise(taskParam, 'lowNoise', true)
    al_helicopterLoop(taskParam, condition, taskDataLowNoise, taskParam.gParam.practTrialsHid);

    % ... high noise second
    % ---------------------

    al_indicateNoise(taskParam, 'highNoise', true)
    al_helicopterLoop(taskParam, condition, taskDataHighNoise, taskParam.gParam.practTrialsHid);

elseif cBal == 3 || cBal == 4

    % High noise first...
    % ------------------

    taskParam.trialflow.cannon = 'hide cannon'; % don't show cannon anymore
    taskParam.trialflow.confetti = 'show confetti cloud';
    al_indicateNoise(taskParam, 'highNoise', true)
    al_helicopterLoop(taskParam, condition, taskDataHighNoise, taskParam.gParam.practTrialsHid);

    % ... low noise second
    % ---------------------

    % Run task
    al_indicateNoise(taskParam, 'lowNoise', true)
    al_helicopterLoop(taskParam, condition, taskDataLowNoise, taskParam.gParam.practTrialsHid);

end


%  12. Introduce Confidence Rating
% ------------------------------------

% Step 1: Present First Instruction Screen (No Image)
if taskParam.gParam.customInstructions
    header = taskParam.instructionText.ConfidencePracticeHeader;
    txt = taskParam.instructionText.ConfidencePractice;
else
    txt = 'Welcome to the Confidence Practice Task!';
end

feedback = false;
al_bigScreen(taskParam, header, txt, feedback); % al_bigScreen handles waiting for Enter

% Step 2: Present Second Instruction Screen (With Image Handled in al_bigScreen)
if taskParam.gParam.customInstructions
    header = taskParam.instructionText.ConfidencePracticeHeaderTwo;
    txt = taskParam.instructionText.ConfidencePracticeTwo;
else
    txt = 'This is the second part of the Confidence Practice instructions.';
end

% Call al_bigScreen to display text (Image will be handled automatically inside)
al_bigScreen(taskParam, header, txt, feedback);

% Update trial flow
taskParam.trialflow.colors = 'dark';
taskParam.trialflow.shot = 'static';
taskParam.trialflow.shieldAppearance = 'lines';
taskParam.cannon = taskParam.cannon.al_staticConfettiCloud(taskParam.trialflow.colors, taskParam.display);

% Load data
taskData = load('ConfidencePractice.mat');
taskData = taskData.taskData;
taskData.saveAsStruct = true; % ensure that we save as struct

% Update trial flow
taskParam.trialflow.cannon = 'hide cannon'; % show cannon 
taskParam.trialflow.confetti = 'show confetti cloud';

% Run practice block
taskParam.trialflow.includeConfidence = true;
al_helicopterLoop(taskParam, condition, taskData, taskParam.gParam.practTrialsConf);



% 13. Instructions experimental blocks
% ------------------------------------

% Display instructions
if taskParam.gParam.customInstructions
    header = taskParam.instructionText.startTaskHeader;
    txt = taskParam.instructionText.startTask;
else
    header = 'Jetzt kommen wir zum Experiment';
    txt = ['Sie haben die Übungsphase abgeschlossen. Kurz zusammengefasst fangen Sie also das meiste Konfetti, '...
        'wenn Sie den Eimer (rosafarbener Punkt) auf die Stelle bewegen, auf die die Konfetti-Kanone zielt. Weil Sie die Konfetti-Kanone meistens nicht mehr '...
        'sehen können, müssen Sie diese Stelle aufgrund der Position der letzten Konfettiwolken einschätzen. Beachten Sie, dass Sie das Konfetti trotz '...
        'guter Vorhersagen auch häufig nicht fangen können. \n\nIn wenigen Fällen werden Sie die Konfetti-Kanone zu sehen bekommen und können Ihre Leistung '...
        'verbessern, indem Sie den Eimer genau auf das Ziel steuern.\n\n'...
        'Achten Sie bitte auf Ihre Augenbewegungen und vermeiden Sie es während eines Versuchs zu blinzeln. Wenn der Punkt in der Mitte am Ende eines Versuchs weiß ist, dürfen Sie blinzeln.\n\nViel Erfolg!'];
end

feedback = false;
al_bigScreen(taskParam, header, txt, feedback);

end