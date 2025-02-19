function al_bigScreen(taskParam, header, txt, feedback, endOfTask)
% AL_BIGSCREEN displays feedback, optionally with an image.
%
%   Inputs:
%       taskParam - Task parameters including display settings
%       header - Header text
%       txt - Main feedback text
%       feedback - Boolean, whether feedback is being displayed
%       endOfTask - Optional argument for different breakKey behavior
%
%   Output:
%       None

% Manage optional breakKey input: if not provided, use SPACE as default
if ~exist('endOfTask', 'var') || isempty(endOfTask)
    endOfTask = false;
end

% Display text until keypress
while 1
    % Draw Background
    Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);
    Screen('DrawLine', taskParam.display.window.onScreen, [0 0 0], 0, taskParam.display.screensize(4)*0.16,...
        taskParam.display.screensize(3), taskParam.display.screensize(4)*0.16, 5);
    Screen('DrawLine', taskParam.display.window.onScreen, [0 0 0], 0, taskParam.display.screensize(4)*0.8,...
        taskParam.display.screensize(3), taskParam.display.screensize(4)*0.8, 5);
    Screen('FillRect', taskParam.display.window.onScreen, [0, 25, 51], ...
        [0, (taskParam.display.screensize(4)*0.16), taskParam.display.screensize(3), (taskParam.display.screensize(4)*0.8)]);
    
    % Print Header
    Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.headerSize);
    DrawFormattedText(taskParam.display.window.onScreen, header, 'center', taskParam.display.screensize(4)*0.1, [255 255 255]);
    Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);

    % Extract Length of Text
    sentenceLength = taskParam.strings.sentenceLength;
    
  %% --- Draw Feedback Image if Available for Leipzig Version ---
if feedback == true && strcmp(taskParam.trialflow.cannonType, 'HelicopterNEW') && contains(header, 'Zwischenstand')

    
    % Define position for the image (above text)
    [screenX, screenY] = RectCenter(Screen('Rect', taskParam.display.window.onScreen));
    
    % Define image size and position (centered above text)
    imgWidth = 600;  
    imgHeight = 1200; 
    imgSize = [screenX - imgWidth/2, screenY - 350, screenX + imgWidth/2, screenY - 50];

    % Set feedback image 
    feedbackImg = taskParam.display.feedbackTxt; % Always use one image

    % Draw the image (if available)
    if ~isempty(feedbackImg)
        Screen('DrawTexture', taskParam.display.window.onScreen, feedbackImg, [], imgSize);
    end
end

% --- Draw Feedback Message ---
if feedback == true && strcmp(taskParam.trialflow.cannonType, 'HelicopterNEW') && contains(header, 'Zwischenstand')

    % Display text lower on the screen (e.g., 60% down)
    DrawFormattedText(taskParam.display.window.onScreen, txt, 'center', taskParam.display.screensize(4) * 0.6, ...
        [255 255 255], sentenceLength, [], [], taskParam.strings.vSpacing);
elseif feedback == true
        % When feedback is presented, print in screen center...
        DrawFormattedText(taskParam.display.window.onScreen, txt, 'center', 'center', [255 255 255], sentenceLength, [], [], taskParam.strings.vSpacing);
    else
        % ...otherwise at defined location
        DrawFormattedText(taskParam.display.window.onScreen, txt, taskParam.display.screensize(4)*0.2, taskParam.display.screensize(4)*0.2,...
            [255 255 255], sentenceLength, [], [], taskParam.strings.vSpacing);
    end

    
    % Print "Press Enter" to Continue
    if ~endOfTask
        DrawFormattedText(taskParam.display.window.onScreen, taskParam.strings.txtPressEnter, 'center', taskParam.display.screensize(4)*0.9);
    else
        DrawFormattedText(taskParam.display.window.onScreen, 'Bitte auf Versuchtsleiter:in warten...', 'center', taskParam.display.screensize(4)*0.9);
    end

    % Finalize Drawing
    Screen('DrawingFinished', taskParam.display.window.onScreen);

    % Flip Screen to Present Changes
    time = GetSecs;
    Screen('Flip', taskParam.display.window.onScreen, time + 0.1);
    
    % Wait for User Input to Continue
    [~, ~, keyCode] = KbCheck(taskParam.keys.kbDev);
    if keyCode(taskParam.keys.enter) && ~taskParam.unitTest.run && ~endOfTask
        break;
    elseif keyCode(taskParam.keys.s) && ~taskParam.unitTest.run && endOfTask
        break;
    elseif taskParam.unitTest.run
        WaitSecs(1);
        break;
    elseif keyCode(taskParam.keys.esc)
        ListenChar();
        ShowCursor;
        Screen('CloseAll');
        error('User pressed Escape to finish task');
    end
end

% Wait for Keyboard Release
KbReleaseWait();
end
