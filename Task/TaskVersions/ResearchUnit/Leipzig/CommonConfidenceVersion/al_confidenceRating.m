function [confidenceRating, confidenceRT, timestampConfidenceOnset, timestampConfidenceResponse, initialRTconfidence] = al_confidenceRating(taskParam, predictedAngle)
% AL_CONFIDENCERATING - Handles confidence rating while keeping prediction visible
%
% - A/D keys move the slider smoothly from 0 to 100.
% - Spacebar confirms the selection.
% - Uses degrees of visual angle for layout if enabled.
% - Draws confidence slider, question, prediction, and marker.

% --- Parameters ---
minScale = 0;
maxScale = 100;
confidenceRating = 50;
stepSize = 1;

% Visual angle layout parameters
sliderLengthDeg = 10;
sliderOffsetDeg = 8;
questionAboveSliderDeg = 2.5;
numberAboveDeg = 1;
labelOffsetDegY = 0.2;

labelNumberLeftPix = 20;
labelNumberRightPix = 28;

% Text size (visual angle)
fontDeg_conf = 0.6;
fontDeg_labels = 0.5;
fontDeg_question = 0.6;

screensize = taskParam.display.screensize;

% --- Positioning ---
if taskParam.display.useDegreesVisualAngle
    scaleLengthPix = taskParam.display.deg2pix(sliderLengthDeg);
    scaleYPos = taskParam.display.zero(2) + taskParam.display.deg2pix(sliderOffsetDeg);
    textY = scaleYPos - taskParam.display.deg2pix(numberAboveDeg);
    labelY = scaleYPos + taskParam.display.deg2pix(labelOffsetDegY);
    questionY = scaleYPos - taskParam.display.deg2pix(questionAboveSliderDeg);

    textSize_confidenceValue = round(taskParam.display.deg2pix(fontDeg_conf));
    textSize_labels = round(taskParam.display.deg2pix(fontDeg_labels));
    textSize_question = round(taskParam.display.deg2pix(fontDeg_question));
else
    scaleLengthPix = screensize(3) * 0.6;
    scaleYPos = screensize(4) * 0.85;
    textY = scaleYPos - 50;
    labelY = scaleYPos + 10;
    questionY = screensize(4) * 0.75;

    textSize_confidenceValue = 24;
    textSize_labels = 20;
    textSize_question = 35;
end

leftEnd = taskParam.display.zero(1) - (scaleLengthPix / 2);
rightEnd = taskParam.display.zero(1) + (scaleLengthPix / 2);

% --- Timing ---
confidenceConfirmed = false;
initialMovementDetected = false;
timestampConfidenceOnset = GetSecs() - taskParam.timingParam.ref;
initialRTconfidence = NaN;

while ~confidenceConfirmed
    % --- Draw background and visuals ---
    Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);
    al_drawCircle(taskParam);

    if isequal(taskParam.trialflow.confetti, 'show confetti cloud')
        Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
    end
    al_drawFixPoint(taskParam);

    % --- Draw previous prediction ---
    if ~isnan(predictedAngle)
        al_tickMark(taskParam, predictedAngle, 'pred');
    end

    % --- Draw slider line ---
    Screen('DrawLine', taskParam.display.window.onScreen, taskParam.colors.gray, leftEnd, scaleYPos, rightEnd, scaleYPos, 3);

    % --- Draw "0" and "100" labels ---
    Screen('TextSize', taskParam.display.window.onScreen, textSize_labels);
    bounds0 = Screen('TextBounds', taskParam.display.window.onScreen, '0');
    bounds100 = Screen('TextBounds', taskParam.display.window.onScreen, '100');

    % Center labels horizontally at ends of slider
    textX_0 = leftEnd - bounds0(3)/2;
    textX_100 = rightEnd - bounds100(3)/2;

    DrawFormattedText(taskParam.display.window.onScreen, '0', textX_0 - labelNumberLeftPix, labelY, taskParam.colors.gray);
    DrawFormattedText(taskParam.display.window.onScreen, '100', textX_100 + labelNumberRightPix, labelY, taskParam.colors.gray);

    % --- Draw confidence marker ---
    markerX = leftEnd + ((confidenceRating - minScale) / (maxScale - minScale)) * scaleLengthPix;
    Screen('DrawDots', taskParam.display.window.onScreen, [markerX; scaleYPos], 15, taskParam.colors.blue, [], 2);

    % --- Draw confidence value above marker ---
    Screen('TextSize', taskParam.display.window.onScreen, textSize_confidenceValue);
    ratingText = sprintf('%d', confidenceRating);
    textBounds = Screen('TextBounds', taskParam.display.window.onScreen, ratingText);
    textX = markerX - textBounds(3)/2;
    DrawFormattedText(taskParam.display.window.onScreen, ratingText, textX, textY, taskParam.colors.gray);

    % --- Draw confidence question ---
    Screen('TextSize', taskParam.display.window.onScreen, textSize_question);
    if isequal(taskParam.gParam.taskType, 'HelicopterNEW')
        question = 'Wie sicher sind Sie, dass Sie die Medikamente fangen werden?';
    else
        question = 'Wie sicher sind Sie, dass Sie das Konfetti fangen werden?';
    end
    DrawFormattedText(taskParam.display.window.onScreen, question, 'center', questionY, taskParam.colors.gray);

    % --- Flip to screen ---
    Screen('Flip', taskParam.display.window.onScreen);

    % --- Key input ---
    [keyIsDown, ~, keyCode] = KbCheck(taskParam.keys.kbDev);
    if keyIsDown
        if (keyCode(taskParam.keys.a) && confidenceRating > minScale) || (keyCode(taskParam.keys.d) && confidenceRating < maxScale)
            if ~initialMovementDetected
                initialRTconfidence = GetSecs() - taskParam.timingParam.ref - timestampConfidenceOnset;
                initialMovementDetected = true;
            end
            if keyCode(taskParam.keys.a)
                confidenceRating = max(minScale, confidenceRating - stepSize);
            elseif keyCode(taskParam.keys.d)
                confidenceRating = min(maxScale, confidenceRating + stepSize);
            end
            WaitSecs(0.015);  % smooth response
        elseif keyCode(taskParam.keys.space)
            timestampConfidenceResponse = GetSecs() - taskParam.timingParam.ref;
            confidenceConfirmed = true;
        end
    end

    % --- Escape key handling ---
    taskParam.keys.checkQuitTask(taskParam);
end

% --- Compute RT ---
confidenceRT = timestampConfidenceResponse - timestampConfidenceOnset;

end
