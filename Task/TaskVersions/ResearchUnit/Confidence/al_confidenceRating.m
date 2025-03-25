function [confidenceRating, confidenceRT, timestampConfidenceOnset, timestampConfidenceResponse, initialRTconfidence] = al_confidenceRating(taskParam, predictedAngle)
% AL_CONFIDENCERATING - Handles confidence rating while keeping prediction visible
%
%   - A/D keys move the slider smoothly from 0 to 100.
%   - Spacebar confirms the selection.
%   - The user's previous prediction is displayed on the circle.
%   - Records timestamps for slider onset, first movement, and confidence input relative to the reference time.

% Define scale
minScale = 0;
maxScale = 100;
confidenceRating = 50; % Start in the middle

% Define slider position
screensize = taskParam.display.screensize;
scaleLengthPix = screensize(3) * 0.6;
scaleYPos = screensize(4) * 0.85;
leftEnd = taskParam.display.zero(1) - (scaleLengthPix / 2);
rightEnd = taskParam.display.zero(1) + (scaleLengthPix / 2);

confidenceConfirmed = false;
initialMovementDetected = false; % Flag to track first movement

% Record timestamp when confidence slider first appears (relative to ref)
timestampConfidenceOnset = GetSecs() - taskParam.timingParam.ref;
initialRTconfidence = NaN; % Initialize as NaN

while ~confidenceConfirmed
    % Draw background
    Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);
    
    % Draw circle
    al_drawCircle(taskParam);

    % Optionally, show confetti cloud
    if isequal(taskParam.trialflow.confetti, 'show confetti cloud')
        Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
        al_drawFixPoint(taskParam);
    else
        al_drawFixPoint(taskParam);
    end

    % **Draw prediction mark safely**
    if ~isnan(predictedAngle)
        al_tickMark(taskParam, predictedAngle, 'pred');
    end
    
    % Draw confidence slider
    Screen('DrawLine', taskParam.display.window.onScreen, taskParam.colors.gray, leftEnd, scaleYPos, rightEnd, scaleYPos, 3);
    
    % Calculate text width for '0' and '100'
    bounds0 = Screen('TextBounds', taskParam.display.window.onScreen, '0');
    bounds100 = Screen('TextBounds', taskParam.display.window.onScreen, '100');
    
    % Set symmetrical spacing distance from slider
    spacing = 30; % pixels of spacing between slider ends and labels
    
    % Calculate precise X positions
    posX_left = leftEnd - bounds0(3) - spacing;    % left label ("0")
    posX_right = rightEnd + spacing;               % right label ("100")
    
    % Draw left (0) and right (100) labels symmetrically
    DrawFormattedText(taskParam.display.window.onScreen, '0', posX_left, scaleYPos + 10, taskParam.colors.gray);
    DrawFormattedText(taskParam.display.window.onScreen, '100', posX_right, scaleYPos + 10, taskParam.colors.gray);


    % Draw confidence marker
    markerX = leftEnd + ((confidenceRating - minScale) / (maxScale - minScale)) * scaleLengthPix;
    Screen('DrawDots', taskParam.display.window.onScreen, [markerX; scaleYPos], 15, taskParam.colors.blue, [], 2);

    ratingText = sprintf('%d', confidenceRating);
    textBounds = Screen('TextBounds', taskParam.display.window.onScreen, ratingText);
    textX = markerX - textBounds(3)/2; % Center horizontally above marker
    textY = scaleYPos - 50;            % Vertical offset (50 pixels above slider)

    DrawFormattedText(taskParam.display.window.onScreen, ratingText, textX, textY, taskParam.colors.gray);


    % Draw question
    if isequal(taskParam.gParam.taskType, 'HelicopterNEW')
        DrawFormattedText(taskParam.display.window.onScreen, 'Wie sicher sind Sie, dass Sie die Medikamente fangen werden?', 'center', screensize(4) * 0.75, taskParam.colors.gray);
    else
        DrawFormattedText(taskParam.display.window.onScreen, 'Wie sicher sind Sie, dass Sie das Konfetti fangen werden?', 'center', screensize(4) * 0.75, taskParam.colors.gray);
    end

    % Flip screen
    Screen('Flip', taskParam.display.window.onScreen);

    % Handle key input
    [keyIsDown, ~, keyCode] = KbCheck(taskParam.keys.kbDev);
    if keyIsDown
        stepSize = 1; % Base movement speed
        
        % Detect first key press for slider movement
        if (keyCode(taskParam.keys.a) && confidenceRating > minScale) || (keyCode(taskParam.keys.d) && confidenceRating < maxScale)
            if ~initialMovementDetected
                initialRTconfidence = GetSecs() - taskParam.timingParam.ref - timestampConfidenceOnset;
                initialMovementDetected = true; % Mark first movement as detected
            end

            % Adjust slider position
            if keyCode(taskParam.keys.a) && confidenceRating > minScale
                confidenceRating = confidenceRating - 1;
            elseif keyCode(taskParam.keys.d) && confidenceRating < maxScale
                confidenceRating = confidenceRating + 1;
            end
            WaitSecs(0.02);
        elseif keyCode(taskParam.keys.space)
            % Record timestamp when confidence rating is confirmed (relative to ref)
            timestampConfidenceResponse = GetSecs() - taskParam.timingParam.ref;
            confidenceConfirmed = true;
        end
    end

    % Check for escape key
    taskParam.keys.checkQuitTask(taskParam);
end

% Compute Confidence RT
confidenceRT = timestampConfidenceResponse - timestampConfidenceOnset;

end
