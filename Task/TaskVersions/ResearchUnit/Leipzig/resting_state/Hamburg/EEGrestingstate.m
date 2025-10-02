
%%% EEG Resting State 4 minutes %%%%

%% Initialize Sound Driver
InitializePsychSound(1);

%% Input
EEG     = input('EEG recording: Yes (1) or No (0) ? :');
cBal = input('cBal = 1 or = 2?');

%% EEG Settings
port        = "com3"; % Through which port will the EEG triggers be sent
if EEG
   comport = serial(port);
   fopen(comport);
else
    comport = 0;
end


trigDur         = .005;
expStart_trig   = 3;
trigger_open1   = 11;
trigger_open2   = 12;
trigger_closed1 = 21;
trigger_closed2 = 22;
expEnd_trig   = 4;


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
        sendTrigger(comport,trigDur,expStart_trig);
    end
    WaitSecs(1);
    % Instructions
    txt = ['Willkommen zum Experiment \n\n'...
    'Im Folgenden wird die EEG Ruhemessung durchgeführt. Dazu wird Ihnen ein Bildschirm mit Fixationskreuz gezeigt. \n\n'...
    'Außerdem werden Sie in einem anderen Block gebeten, die Augen zu schließen. Sie hören jeweils einen Signalton, wenn Sie die Augen wieder öffnen sollen\n\n'...
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
   sendTrigger(comport,trigDur,trigger_open1);
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
   sendTrigger(comport,trigDur,trigger_closed1);
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
   sendTrigger(comport,trigDur,trigger_open2);
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
   sendTrigger(comport,trigDur,trigger_closed2);
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
   sendTrigger(comport,trigDur,trigger_closed1);
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
   sendTrigger(comport,trigDur,trigger_open1);
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
   sendTrigger(comport,trigDur,trigger_closed2);
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
   sendTrigger(comport,trigDur,trigger_open2);
   end
   WaitSecs(timing);

end


%End of Experiment
   txt = ['Ende der EEG Ruhemessung \n\n'...
    'Bitte warte auf die Versuchsleitung'];
    drawAndKey(w,txt);
   % EEG 
   if EEG == 1
        sendTrigger(comport,trigDur,expEnd_trig);
   end
   % Bildschirm schlieÃŸen
   Screen('CloseAll');



%%% Functions
function drawAndKey(w,txt)
 %% display text
 txtColor=[0 0 0]; % rgb: black
 txt=[txt '\n\nDrücke eine Taste'];
 DrawFormattedText(w, txt, 'center','center', txtColor);
 % "flip" what we've drawn onto the display
 Screen('Flip', w);
 % wait 300 seconds, then advance after keypress
 WaitSecs(.3);
 KbWait(); % press key 3 times to prevent participants from just pressing
 KbWait();
 KbWait();
end

function sendTrigger(comport,duration,trigger)
    fwrite(comport,trigger);
    WaitSecs(duration);
    fwrite(comport,0);
end

