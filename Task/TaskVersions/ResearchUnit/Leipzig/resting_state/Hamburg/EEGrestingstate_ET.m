%%% EYELINK EEG Resting State 4 minutes  %%%%

%%% Directories to save the data

MAINPATH = 'C:\Users\EEG\Documents\GitKraken\EEG Resting State';
cd(MAINPATH)
% PATHIN = fullfile(MAINPATH,'task',filesep);
PATHOUT = fullfile(MAINPATH,'analysis','Data storage',filesep);
addpath(fullfile(MAINPATH),'mats')

%% Input
EEG     = input('EEG recording: Yes (1) or No (0) ? :');
ET      = input ('EyeLink recording: Yes(1) or No (0)? :');
el = ET; % 1 = Eyelink on; 0 = Eyelink off;

%%Enter Subject Information
prompt  = {'Subject Number:','Gender (f/m)','Age', 'Date'}; %prompt
default = {'99999','fm','99','dd/mm/yy'};
dlgname = 'Setup Info';
LineNo = 1;
answer = inputdlg(prompt,dlgname,LineNo,default);
[subNum, sex, age, date] = deal(answer{:});
input('Press ENTER to continue');


%% Initialize Sound Driver
InitializePsychSound(1);

%% EEG Settings
port        = "com3"; % Through which port will the EEG triggers be sent
if EEG
   comport = serial(port);
   fopen(comport);
  % comport = serialport(port, EEG);
  % serialportfind(port, EEG)
else
    comport = 0;
end

%% Eye Link settings
if ET == 1
% Common eyetracking set up
ExpCond.distSc_Sbj = 65; % Distance from subject to monitor [cm] % CHANGE BASED ON YOUR SETUP!
ExpCond.ScWidth = 53.4; % Screen width [cm] % CHANGE BASED ON YOUR SETUP!
ExpCond.smpfreq = 1000; % Sampling rate of Eyelink [Hz] % CHANGE BASED ON YOUR SETUP!
ExpCond.linewidth = 7; % in pixels
dummymode = 0;
KbName('UnifyKeyNames');
Screen('Preference', 'VisualDebuglevel', 2);
screens=Screen('Screens');
screenNumber = max(screens);
[window,ExpCond.rect]=Screen('OpenWindow',screenNumber);

% Eye-tracking data's filename (temporary)
if el == 1
    Eyelinkuse = 'on';
else
    Eyelinkuse = 'off';
end

tmpname = subNum; % name for eyetracking data

% ExpDataDrct = [ExpDataDrct,'/'];
% mkdir(ExpDataDrct);

%%% EyeLink calibration
if strcmp(Eyelinkuse,'on')==1
    if ~dummymode, HideCursor; end
    commandwindow;
    fprintf('EyelinkToolbox Example\n\n\t');
    eyl=EyelinkInitDefaults(window);
    ListenChar(2);
    if ~EyelinkInit(dummymode, 1)
        fprintf('Eyelink Init aborted.\n');
        cleanup;  % cleanup function
        return;
    end
    [v,vs]=Eyelink('GetTrackerVersion');
    fprintf('Running experiment on a ''%s'' tracker.\n', vs );
    Eyelink('Command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');
    %     Eyelink('Openfile',[EyelinkName,'.edf']);
    Eyelink('Openfile',[tmpname,'.edf']);
    EyelinkDoTrackerSetup(eyl);
    %EyelinkDoDriftCorrection(eyl);
    Eyelink('StartRecording');
    error = Eyelink('checkrecording');
    WaitSecs(0.1);
    Eyelink('Message', 'SYNCTIME');
end
end

%%%% trigger (for EEG and ET)
trigDur         = .005;
expStart_trig   = 3;
trigger_open   = 10;
expEnd_trig   = 4;


% Initialise Psychtoolbox
Screen('Preference', 'SkipSyncTests', 1);
Screen('CloseAll');

% Open Screen
[w, rect] = PsychImaging('OpenWindow', 0, [128 128 128]);
Screen('TextSize', w, 24);
[screenXpixels, screenYpixels] = Screen('WindowSize', w);

%hide cursor
HideCursor

% Randomisation of blocks
%cBal = 2; %Open-Closed-Open-Closed (OCOC); = 2; Closed-Open-Closed-Open (COCO)
backgroundColor = [128, 128, 128]; % grey
timing = 240; %duration of one condition

%Sound: https://de.mathworks.com/help/matlab/ref/audioread.html
[y, Fs] = audioread('sound_eyes_closed.wav');

% Start of Experiment
    if EEG == 1
    sendTrigger(comport,trigDur,expStart_trig);
    end
    if ET == 1
    Eyelink('StartRecording'); % start recording (to the file)
    Eyelink('message', num2str(expStart_trig));
    end
    WaitSecs(1);
    % Instructions
    txt = ['Willkommen zum Experiment \n\n'...
    'Im Folgenden wird die EEG Ruhemessung durchgeführt. Dazu wird Ihnen ein Bildschirm mit Fixationskreuz gezeigt. \n\n'...
    'Schauen Sie bitte auf das Fixationskreuz. die Ruhemessung dauert 4 Minuten\n\n'...
    'Start der Ruhemessung mit Enter'];
    drawAndKey(w,txt);

%Only eyes open
   %Fixation
   Screen('FillRect', w, backgroundColor);
   DrawFormattedText(w,'+','center','center', [400 400 400]);
   Screen('Flip', w);
   % EEG trigger
   if EEG == 1
   sendTrigger(comport,trigDur,trigger_open);
   end
   if ET == 1
   Eyelink('message', num2str(trigger_open));
   end
   WaitSecs(timing);

%End of Experiment
   txt = ['Ende der EEG Ruhemessung \n\n'...
    'Bitte warte auf die Versuchsleitung'];
    drawAndKey(w,txt);
   % EEG 
   if EEG == 1
        sendTrigger(comport,trigDur,expEnd_trig);
   end
   if ET == 1
    Eyelink('message', num2str(expEnd_trig));
   Eyelink('StopRecording'); % stop recording (to the file)
   Eyelink('ReceiveFile', tmpname); %copy file from ET PC to Stim PC
   Eyelink('CloseFile');
   Eyelink('Shutdown');
   end
   % Close screen
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
 KbWait();%3 times to prevent participants from just pressing
 KbWait();
 KbWait();
end

function sendTrigger(comport,duration,trigger)
    fwrite(comport,trigger);
    WaitSecs(duration);
    fwrite(comport,0);
end

