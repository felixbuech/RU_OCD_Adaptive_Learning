function [confidenceRating, confidenceRT] = al_confidenceRating(taskParam, predictedAngle)
% AL_CONFIDENCERATING - Handles confidence rating while keeping prediction visible
%
%   - A/D keys move the slider smoothly from 1 to 100.
%   - Spacebar confirms the selection.
%   - The user's previous prediction is displayed on the circle.

% Define scale
minScale = 1;
maxScale = 100;
confidenceRating = 50; % Start in the middle

% Define slider position
screensize = taskParam.display.screensize;
scaleLengthPix = screensize(3) * 0.6;
scaleYPos = screensize(4) * 0.85;
leftEnd = taskParam.display.zero(1) - (scaleLengthPix / 2);
rightEnd = taskParam.display.zero(1) + (scaleLengthPix / 2);

confidenceConfirmed = false;

% Record the start time when the slider first appears
startTimeSlider = GetSecs();

while ~confidenceConfirmed
    % Draw background
    Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);
    
    % Draw circle
    al_drawCircle(taskParam);

    % Optionally, show confetti cloud
        if isequal(taskParam.trialflow.confetti, 'show confetti cloud')
            Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
            al_drawFixPoint(taskParam)
        elseif isequal(condition, 'cannonPract1') == false ||  isequal(condition, 'cannonPract2') == false
            % Otherwise just fixation cross
            al_drawFixPoint(taskParam)
        end
   
    
    % **Draw prediction mark safely**
    if ~isnan(predictedAngle)
        al_tickMark(taskParam, predictedAngle, 'pred');
    end
    
    % Draw confidence slider
    Screen('DrawLine', taskParam.display.window.onScreen, taskParam.colors.gray, leftEnd, scaleYPos, rightEnd, scaleYPos, 3);
    
   % Draw confidence marker
markerX = leftEnd + ((confidenceRating - minScale) / (maxScale - minScale)) * scaleLengthPix;
Screen('DrawDots', taskParam.display.window.onScreen, [markerX; scaleYPos], 15, taskParam.colors.blue, [], 2);

% Display current confidence rating above marker
DrawFormattedText(taskParam.display.window.onScreen, sprintf('%d', confidenceRating), markerX - 10, scaleYPos - 50, taskParam.colors.gray);

   
    % % Draw question
    % DrawFormattedText(taskParam.display.window.onScreen, 'Wie sicher sind Sie, dass Ihre Vorhersage eintrifft?', 'center', screensize(4) * 0.75, taskParam.colors.gray);
    
    if isequal (taskParam.gParam.taskType, 'HelicopterNEW')
                DrawFormattedText(taskParam.display.window.onScreen, 'Wie sicher sind Sie, dass Sie die Medikamente fangen werden?', 'center', screensize(4) * 0.75, taskParam.colors.gray);
            else
                DrawFormattedText(taskParam.display.window.onScreen, 'Wie sicher sind Sie, dass Sie das Konfetti fangen werden?', 'center', screensize(4) * 0.75, taskParam.colors.gray);
            end


    % Flip screen
    Screen('Flip', taskParam.display.window.onScreen);

    % Handle key input
    [keyIsDown, ~, keyCode] = KbCheck(taskParam.keys.kbDev);
    if keyIsDown
        if keyCode(taskParam.keys.a) && confidenceRating > minScale
            confidenceRating = confidenceRating - 1;
            WaitSecs(0.02);
        elseif keyCode(taskParam.keys.d) && confidenceRating < maxScale
            confidenceRating = confidenceRating + 1;
            WaitSecs(0.02);
        elseif keyCode(taskParam.keys.space)
            % Record the time when spacebar is pressed
            endTimeSlider = GetSecs();
            confidenceRT = endTimeSlider - startTimeSlider; % Calculate RT
            confidenceConfirmed = true;
        end
    end

    % Check for escape key
    taskParam.keys.checkQuitTask(taskParam);
end

end
