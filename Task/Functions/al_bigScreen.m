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
    
  
  % Draw Feedback Image if Available for Leipzig Version 
  %-----------------------------------------------------------

if feedback == true && strcmp(taskParam.trialflow.cannonType, 'HelicopterNEW') && contains(header, 'Zwischenstand')

    
    % Define position for the image (above text)
    [screenX, screenY] = RectCenter(Screen('Rect', taskParam.display.window.onScreen));
    
    % Define image size and position (centered above text)
    imgWidth = 1024 *0.5;  %400;
    imgHeight = 1024 *0.5; %600;
    
    % NEW: Move the image lower by changing the vertical center
    yOffsetFromCenter = -113;  % increase this to move image even lower

    % Image rectangle
    imgSize = [screenX - imgWidth/2, screenY + yOffsetFromCenter - imgHeight/2, ...
               screenX + imgWidth/2, screenY + yOffsetFromCenter + imgHeight/2];

    % Set feedback image 
    feedbackImg = taskParam.display.feedbackTxt; 

    % Check if feedbackTxt is a matrix (image), and convert if needed
if ~isempty(taskParam.display.feedbackTxt)
    Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.feedbackTxt, [], imgSize);
end

end


% --- Draw Feedback Message ---
if feedback == true && strcmp(taskParam.trialflow.cannonType, 'HelicopterNEW') && contains(header, 'Zwischenstand')

    % Display text lower on the screen
    DrawFormattedText(taskParam.display.window.onScreen, txt, 'center', taskParam.display.screensize(4) * 0.66, ...
        [255 255 255], sentenceLength, [], [], taskParam.strings.vSpacing);

elseif contains(header, 'Bedienung Schieberegler')

    % Display text slightly lower for "Bedienung Schieberegler" (e.g., 50% down)
    DrawFormattedText(taskParam.display.window.onScreen, txt, 'center', taskParam.display.screensize(4) * 0.5, ...
        [255 255 255], sentenceLength, [], [], taskParam.strings.vSpacing);

elseif contains(header, 'Virusausbruch')

    % Display text slightly lower for "Virusausbruch" (e.g., 65% down)
    DrawFormattedText(taskParam.display.window.onScreen, txt, 'center', taskParam.display.screensize(4) * 0.65, ...
        [255 255 255], sentenceLength, [], [], taskParam.strings.vSpacing);


elseif feedback == true
    % When feedback is presented, print in screen center...
    DrawFormattedText(taskParam.display.window.onScreen, txt, 'center', 'center', [255 255 255], sentenceLength, [], [], taskParam.strings.vSpacing);

else
     % ...otherwise at defined location
    DrawFormattedText(taskParam.display.window.onScreen, txt, taskParam.display.screensize(4) * 0.2, taskParam.display.screensize(4) * 0.2, ...
        [255 255 255], sentenceLength, [], [], taskParam.strings.vSpacing);
end


% Draw Keyboard for Leipzig Version to practice confidence
%-----------------------------------------------------------

if contains(header, 'Bedienung Schieberegler')

    
    % Define position for the image (above text)
    [screenX, screenY] = RectCenter(Screen('Rect', taskParam.display.window.onScreen));
    
    % Define image size and position (centered above text)
    imgWidth = 1200;  %400;
    imgHeight = 600; %600;

    imgSize = [screenX - imgWidth/2, screenY - 350, screenX + imgWidth/2, screenY - 50];

    % Set feedback image 
    keyboardImg = taskParam.display.keyboardTxt; 

    % Draw the image 
    if ~isempty(keyboardImg)
        Screen('DrawTexture', taskParam.display.window.onScreen, keyboardImg, [], imgSize);
    end
end

% Draw Reminder Image Leipzig Version
%-----------------------------------------------------------

if contains(header, 'Virusausbruch')
  
    % Bildschirm-Zentrum bestimmen
    [screenX, screenY] = RectCenter(Screen('Rect', taskParam.display.window.onScreen));

   % Dynamische Skalierung basierend auf Screengröße
maxWidth = taskParam.display.window.screenX * 0.35;  % z. B. 60% der Breite
aspectRatio = 3713 / 2563;
imgWidth = maxWidth;
imgHeight = imgWidth / aspectRatio;


    ReminderImg = taskParam.display.ReminderTxt; 

    % Bild zentriert horizontal, oberhalb des Textes
imgTop = taskParam.display.window.screenY * 0.15;  % obere Y-Position z. B. 10 %
imgSize = [screenX - imgWidth/2, imgTop, ...
           screenX + imgWidth/2, imgTop + imgHeight];

     % Draw the image 
    if ~isempty(ReminderImg)
        Screen('DrawTexture', taskParam.display.window.onScreen, ReminderImg, [], imgSize, [], 0);

    end
end
    
    
 % Print "Press Enter" to indicate how to continue with instructions
    if ~endOfTask
        DrawFormattedText(taskParam.display.window.onScreen, taskParam.strings.txtPressEnter, 'center', taskParam.display.screensize(4)*0.9);
    else
        DrawFormattedText(taskParam.display.window.onScreen, 'Bitte auf Versuchtsleiter:in warten...', 'center', taskParam.display.screensize(4)*0.9);
    end

     % All text strings are presented
    Screen('DrawingFinished', taskParam.display.window.onScreen);

    % Flip Screen to Present Changes
    time = GetSecs;
    Screen('Flip', taskParam.display.window.onScreen, time + 0.1);
    
    % Check for response of participant to continue to next screen
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

% Wait for keyboard release
KbReleaseWait();
