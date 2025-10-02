
%%% EEG Resting State 4 minutes %%%%

addpath(genpath('C:\Users\pc\Desktop\RU_OCD_Adaptive_Learning'));


%% Initialize Sound Driver
InitializePsychSound(1);

%% EEG Settings (Leipzig: LPT via io64)
EEG = input('EEG recording: Yes (1) or No (0) ? :');
cBal = input('cBal = 1 or = 2?');

trigDur         = .005;
expStart_trig   = 3;
trigger_open1   = 11;
trigger_open2   = 12;
trigger_closed1 = 21;
trigger_closed2 = 22;
expEnd_trig     = 4;

if EEG
    ioObj = io64;
    status = io64(ioObj);
    if status ~= 0
        error('io64 init failed (status=%d). Install InpOutx64 and run MATLAB as admin?', status);
    end
    lptAddr = hex2dec('0378');  % Leipzig LPT base address
else
    ioObj = [];
    lptAddr = [];
end



% Initialise Psychtoolbox
Screen('Preference', 'SkipSyncTests', 1);
Screen('CloseAll');

% Open Screen
[w, rect] = PsychImaging('OpenWindow', 0, [128 128 128]);
Screen('TextSize', w, 24);
[screenXpixels, screenYpixels] = Screen('WindowSize', w);

%hide cursor
HideCursor;

% Randomisation of blocks
 %Open-Closed-Open-Closed (OCOC); = 2; Closed-Open-Closed-Open (COCO)
backgroundColor = [128, 128, 128]; % grey
timing = 60; %duration of one condition

%Sound: https://de.mathworks.com/help/matlab/ref/audioread.html
[y, Fs] = audioread('sound_eyes_closed.wav');

% Start of Experiment
    if EEG == 1
        
        sendTrigger(ioObj,lptAddr,trigDur,expStart_trig);
    end
    WaitSecs(1);
    % Instructions
    txt = ['Willkommen zum Experiment \n\n'...
    'Im Folgenden wird die EEG Ruhemessung durchgeführt. Dazu wird Ihnen ein Bildschirm mit Fixationskreuz gezeigt. \n\n'...
    'Außerdem werden Sie in einem anderen Block gebeten, die Augen zu schließen. Sie hören jeweils einen Signalton, wenn Sie die Augen wieder öffnen sollen. \n\n'...
    'Bitte bleiben Sie während der Messung ruhig sitzen und wach. Wenn Sie die Augen geöffnet haben, schauen Sie bitte auf das Fixationskreuz\n\n'...
    'Start der Ruhemessung mit Enter'];
    drawAndKey(w,txt);

%OCOC
if cBal == 1
   %Fixation
   Screen('FillRect', w, backgroundColor);
   DrawFormattedText(w,'+','center','center', [400 400 400]);
   Screen('Flip', w);
   % EEG trigger
   if EEG == 1
   sendTrigger(ioObj,lptAddr,trigDur,trigger_open1);
   end
   WaitSecs(timing);

   %Auditory signal
   sound(y, Fs);
  
   %Closed eyes
   Screen('FillRect', w, backgroundColor);
   DrawFormattedText(w,'Augen schließen','center','center', [255 255 255]);
   Screen('Flip', w);
   % EEG trigger
   if EEG == 1
   sendTrigger(ioObj,lptAddr,trigDur,trigger_closed1);
   end
   WaitSecs(timing);
  
   %Auditory signal
   sound(y, Fs);
  
   %Fixation
   Screen('FillRect', w, backgroundColor);
   DrawFormattedText(w,'+','center','center', [255 255 255]);
   Screen('Flip', w);
   % EEG trigger
   if EEG == 1
   sendTrigger(ioObj,lptAddr,trigDur,trigger_open2);
   end
   WaitSecs(timing);

   %Auditory signal
   sound(y, Fs);

   %Closed eyes
   Screen('FillRect', w, backgroundColor);
   DrawFormattedText(w,'Augen schließen','center','center', [255 255 255]);
   Screen('Flip', w);
   % EEG trigger
   if EEG == 1
   sendTrigger(ioObj,lptAddr,trigDur,trigger_closed2);
   end
   WaitSecs(timing);

   %Auditory signal
   sound(y, Fs); 
end

%COCO
if cBal == 2
   
   %Closed eyes
   Screen('FillRect', w, backgroundColor);
   DrawFormattedText(w,'Augen schließen','center','center', [255 255 255]);
   Screen('Flip', w);
   % EEG trigger
   if EEG == 1
   sendTrigger(ioObj,lptAddr,trigDur,trigger_closed1);
   end
   WaitSecs(timing);

   %Auditory signal
   sound(y, Fs);
   
   %Fixation
   Screen('FillRect', w, backgroundColor);
   DrawFormattedText(w,'+','center','center', [255 255 255]);
   Screen('Flip', w);
   % EEG trigger
   if EEG == 1
   sendTrigger(ioObj,lptAddr,trigDur,trigger_open1);
   end
   WaitSecs(timing);

   %Auditory signal
   sound(y, Fs);

   %Closed eyes
   Screen('FillRect', w, backgroundColor);
   DrawFormattedText(w,'Augen schließen','center','center', [255 255 255]);
   Screen('Flip', w);
   % EEG trigger
   if EEG == 1
   sendTrigger(ioObj,lptAddr,trigDur,trigger_closed2);
   end
   WaitSecs(timing);

   %Auditory signal
   sound(y, Fs);
   
   %Fixation
   Screen('FillRect', w, backgroundColor);
   DrawFormattedText(w,'+','center','center', [255 255 255]);
   Screen('Flip', w);
   % EEG trigger
   if EEG == 1
   sendTrigger(ioObj,lptAddr,trigDur,trigger_open2);
   end
   WaitSecs(timing);

end


%End of Experiment
   txt = ['Ende der EEG Ruhemessung \n\n'...
    'Bitte warte auf die Versuchsleitung'];
    drawAndKey(w,txt);
   % EEG 
   if EEG == 1
        sendTrigger(ioObj,lptAddr,trigDur,expEnd_trig);
   end
   % Bildschirm schließen
   Screen('CloseAll');



%%% Functions
function drawAndKey(w,txt)
 %% display text
 txtColor=[0 0 0]; % rgb: black
 % txt=[txt '\n\nDrücke eine Taste'];
 DrawFormattedText(w, txt, 'center','center', txtColor);
 % "flip" what we've drawn onto the display
 Screen('Flip', w);
 % wait 300 seconds, then advance after keypress
 WaitSecs(.3);
 KbWait(); % press key 3 times to prevent participants from just pressing
 KbWait();
 KbWait();
end

function sendTrigger(ioObj,lptAddr,duration,trigger)
    io64(ioObj, lptAddr, uint8(trigger));
    WaitSecs(duration);
    io64(ioObj, lptAddr, uint8(0));
end


