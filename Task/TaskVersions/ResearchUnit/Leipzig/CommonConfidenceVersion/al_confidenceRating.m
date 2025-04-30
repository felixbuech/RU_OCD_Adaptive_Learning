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

% Define slider size (using degrees of visual angle if enabled)
if taskParam.display.useDegreesVisualAngle
    sliderDeg = 10;
    scaleLengthPix = taskParam.display.deg2pix(sliderDeg);
else
    screensize = taskParam.display.screensize;
    scaleLengthPix = screensize(3) * 0.6;
end

% Slider position
screensize = taskParam.display.screensize;
scaleYPos = screensize(4) * 0.85;
leftEnd = taskParam.display.zero(1) - (scaleLengthPix / 2);
rightEnd = taskParam.display.zero(1) + (scaleLengthPix / 2);

stepSize = 1;  % Fine control

confidenceConfirmed = false;
initialMovementDetected = false;

timestampConfidenceOnset = GetSecs() - taskParam.timingParam.ref;
initialRTconfidence = NaN;

while ~confidenceConfirmed
    % Draw background and visuals
    Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);
    al_drawCircle(taskParam);
    
    if isequal(taskParam.trialflow.confetti, 'show confetti cloud')
        Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
    end
    al_drawFixPoint(taskParam);

    % Draw previous prediction
    if ~isnan(predictedAngle)
        al_tickMark(taskParam, predictedAngle, 'pred');
    end

    % Draw slider
    Screen('DrawLine', taskParam.display.window.onScreen, taskParam.colors.gray, leftEnd, scaleYPos, rightEnd, scaleYPos, 3);
    
    % Set text size for slider labels
    if taskParam.display.useDegreesVisualAngle
        Screen('TextSize', taskParam.display.window.onScreen, round(taskParam.display.deg2pix(0.6)));
    else
        Screen('TextSize', taskParam.display.window.onScreen, 24);
    end

    % Label spacing
    spacing = 20;

    bounds0 = Screen('TextBounds', taskParam.display.window.onScreen, '0');
    bounds100 = Screen('TextBounds', taskParam.display.window.onScreen, '100');

    posX_left = leftEnd - bounds0(3) - spacing;
    posX_right = rightEnd + spacing;

    DrawFormattedText(taskParam.display.window.onScreen, '0', posX_left, scaleYPos + 10, taskParam.colors.gray);
    DrawFormattedText(taskParam.display.window.onScreen, '100', posX_right, scaleYPos + 10, taskParam.colors.gray);

    % Draw slider marker
    markerX = leftEnd + ((confidenceRating - minScale) / (maxScale - minScale)) * scaleLengthPix;
    Screen('DrawDots', taskParam.display.window.onScreen, [markerX; scaleYPos], 15, taskParam.colors.blue, [], 2);

    % Draw confidence number above marker
    ratingText = sprintf('%d', confidenceRating);
    
    if taskParam.display.useDegreesVisualAngle
        Screen('TextSize', taskParam.display.window.onScreen, round(taskParam.display.deg2pix(0.6)));
    else
        Screen('TextSize', taskParam.display.window.onScreen, 24);
    end

    textBounds = Screen('TextBounds', taskParam.display.window.onScreen, ratingText);
    textX = markerX - textBounds(3)/2;
    textY = scaleYPos - 50;

    DrawFormattedText(taskParam.display.window.onScreen, ratingText, textX, textY, taskParam.colors.gray);

    % Draw confidence question
    if taskParam.display.useDegreesVisualAngle
        Screen('TextSize', taskParam.display.window.onScreen, round(taskParam.display.deg2pix(0.6)));
    else
        Screen('TextSize', taskParam.display.window.onScreen, 35);
    end

    if isequal(taskParam.gParam.taskType, 'HelicopterNEW')
        question = 'Wie sicher sind Sie, dass Sie die Medikamente fangen werden?';
    else
        question = 'Wie sicher sind Sie, dass Sie das Konfetti fangen werden?';
    end
    DrawFormattedText(taskParam.display.window.onScreen, question, 'center', screensize(4) * 0.75, taskParam.colors.gray);

    Screen('Flip', taskParam.display.window.onScreen);

    % Handle key input
    [keyIsDown, ~, keyCode] = KbCheck(taskParam.keys.kbDev);
    if keyIsDown
        if (keyCode(taskParam.keys.a) && confidenceRating > minScale) || (keyCode(taskParam.keys.d) && confidenceRating < maxScale)
            if ~initialMovementDetected
                initialRTconfidence = GetSecs() - taskParam.timingParam.ref - timestampConfidenceOnset;
                initialMovementDetected = true;
            end

            if keyCode(taskParam.keys.a) && confidenceRating > minScale
                confidenceRating = confidenceRating - stepSize;
            elseif keyCode(taskParam.keys.d) && confidenceRating < maxScale
                confidenceRating = confidenceRating + stepSize;
            end
            WaitSecs(0.015);
        elseif keyCode(taskParam.keys.space)
            timestampConfidenceResponse = GetSecs() - taskParam.timingParam.ref;
            confidenceConfirmed = true;
        end
    end

    % Escape key check
    taskParam.keys.checkQuitTask(taskParam);
end

% Final RT
confidenceRT = timestampConfidenceResponse - timestampConfidenceOnset;

end
