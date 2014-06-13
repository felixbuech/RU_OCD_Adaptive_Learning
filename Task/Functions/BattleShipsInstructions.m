function BattleShipsInstructions(taskParam, cBal)
% BattleShipsInstructions runs the practice sessions.
%   Depending on cBal you start with low or high noise condition.

KbReleaseWait();

%% Generate outcomes for practice trials.

%condition = 'practice';

txtLowNoise='Jetzt fahren die Schiffe selten weiter';
txtHighNoise = 'Jetzt fahren die Schiffe h�ufiger weiter';
txtPressEnter='Weiter mit Enter';
hand = true;
%% Instructions section.

% Screen 1 with painting.
while 1
    
    Screen('TextFont', taskParam.gParam.window, 'Arial');
    Screen('TextSize', taskParam.gParam.window, 50);
    Ship = imread('Sea.jpg');
    ShipTxt = Screen('MakeTexture', taskParam.gParam.window, Ship);
    Screen('DrawTexture', taskParam.gParam.window, ShipTxt,[]);
    txtScreen1='Schiffeversenken';
    DrawFormattedText(taskParam.gParam.window, txtScreen1, 'center', 100, [255 255 255]);
    Screen('Flip', taskParam.gParam.window);
    
    [~, ~, keyCode] = KbCheck;
    if find(keyCode) == taskParam.keys.enter
        break
    end
end
KbReleaseWait();

% Screen 2.
Screen('TextSize', taskParam.gParam.window, 30);
if isequal(taskParam.gParam.computer, 'Humboldt')
    txt='Auf rauer See m�chtest du m�glichst viele Schiffe einer\n\nSchiffsflotte versenken. Als Hilfsmittel benutzt du einen Radar,\n\nder dir einen Hinweis darauf gibt, wo sich ein Schiff aufh�lt.';
else
    txt='Auf rauer See m�chtest du m�glichst viele Schiffe einer Schiffsflotte versenken.\n\nAls Hilfsmittel benutzt du einen Radar, der dir einen Hinweis darauf gibt, wo sich\n\nein Schiff aufh�lt.';
end

DrawFormattedText(taskParam.gParam.window,txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
button = taskParam.keys.enter;
taskParam = ControlLoopInstrTxt(taskParam, txt, button, hand);
KbReleaseWait();

% Screen 3.
if isequal(taskParam.gParam.computer, 'Humboldt')
    txt='Dein Abschussziel gibst du mit dem blauen Punkt an, den du mit der\n\nrechten und linken Pfeiltaste steuerst.\n\nVersuche den Punkt auf den Zeiger zu bewegen und dr�cke LEERTASTE.';
else
    txt='Dein Abschussziel gibst du mit dem blauen Punkt an, den du mit der rechten und\n\nlinken Pfeiltaste steuerst.\n\nVersuche den Punkt auf den Zeiger zu bewegen und dr�cke LEERTASTE.';
end

button = taskParam.keys.space;
taskParam = ControlLoopInstrTxt(taskParam, txt, button, hand);
LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
DrawCircle(taskParam.gParam.window);
DrawCross(taskParam.gParam.window);
Screen('Flip', taskParam.gParam.window);
WaitSecs(1);

% Screen 4.
while 1
    
    if isequal(taskParam.gParam.computer, 'Humboldt')
        txt='Der schwarze Balken zeigt dir dann die Position des Schiffs an. Wenn dein Punkt auf dem Schiff ist, hast du es getroffen.';
    else
        txt='Der schwarze Balken zeigt dir dann die Position des Schiffs an. Wenn dein\n\nPunkt auf dem Schiff ist, hast du es getroffen.';
    end
    LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
    DrawCircle(taskParam.gParam.window);
    DrawOutcome(taskParam, 238);
    DrawCross(taskParam.gParam.window);
    PredictionSpot(taskParam);
    DrawFormattedText(taskParam.gParam.window,txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.15,taskParam.gParam.screensize(4)*0.1, [0 0 0]);
    Screen('Flip', taskParam.gParam.window);
    
    [ keyIsDown, ~, keyCode ] = KbCheck;
    if keyIsDown
        if find(keyCode) == taskParam.keys.enter
            break
        end
    end
end
KbReleaseWait();

% Screen 5.
while 1
    
    if isequal(taskParam.gParam.computer, 'Humboldt')
        txt='Daraufhin siehst du welche Ladung das Schiff an Bord hat.\n\nDies wird dir auch angezeigt, wenn du das Schiff nicht getroffen hast.\n\nDieses Schiff hat GOLD geladen. Wenn du es triffst, verdienst\n\ndu 20 CENT.';
    else
        txt='Daraufhin siehst du welche Ladung das Schiff an Bord hat. Dies wird dir auch\n\nangezeigt, wenn du das Schiff nicht getroffen hast.\n\nDieses Schiff hat GOLD geladen. Wenn du es triffst, verdienst du 20 CENT. ';
    end
    
    LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.15,taskParam.gParam.screensize(4)*0.1, [0 0 0]);
    DrawCircle(taskParam.gParam.window)
    DrawBoat(taskParam, taskParam.colors.gold)
    DrawFormattedText(taskParam.gParam.window,txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
    Screen('Flip', taskParam.gParam.window);
    
    [ ~, ~ , keyCode ] = KbCheck;
    if find(keyCode)==taskParam.keys.enter
        break
    end
end
KbReleaseWait();

% Screen 6.
% while 1
%     
%     if isequal(taskParam.gParam.computer, 'Humboldt')
%         txt='Dieses Schiff hat BRONZE geladen. Wenn du es triffst, verdienst\n\ndu 10 CENT. ';
%     else
%         txt='Dieses Schiff hat BRONZE geladen. Wenn du es triffst, verdienst du 10 CENT. ';
%     end
%     
%     LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
%     DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.15,taskParam.gParam.screensize(4)*0.1, [0 0 0]);
%     DrawFormattedText(taskParam.gParam.window,txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
%     DrawCircle(taskParam.gParam.window)
%     DrawBronzeBoat(taskParam)
%     Screen('Flip', taskParam.gParam.window);
%     
%     [ ~,~ , keyCode ] = KbCheck;
%     if find(keyCode) == taskParam.keys.enter
%         break
%     end
% end
% KbReleaseWait();

% Screen 7.
while 1
    
    if isequal(taskParam.gParam.computer, 'Humboldt')
        txt='Dieses Schiff hat STEINE geladen. Wenn du es triffst, verdienst\n\ndu leider NICHTS. ';
    else
        txt='Dieses Schiff hat STEINE geladen. Wenn du es triffst, verdienst du leider NICHTS. ';
    end
    
    LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.15,taskParam.gParam.screensize(4)*0.1, [0 0 0]);
    DrawFormattedText(taskParam.gParam.window,txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
    DrawCircle(taskParam.gParam.window)
    DrawBoat(taskParam, taskParam.colors.silver)
    Screen('Flip', taskParam.gParam.window);
    
    [~, ~, keyCode ] = KbCheck;
    if find(keyCode) == taskParam.keys.enter
        break
    end
end
KbReleaseWait();

% Screen 8.
header = 'Wie der Radar funktioniert';
if isequal(taskParam.gParam.computer, 'Humboldt')
    txt = 'Der Radar zeigt dir die Position der Schiffsflotte leider nur ungef�hr an.\n\nDurch den Seegang kommt es oft vor, dass die Schiffe nur in der N�he\n\nder angezeigten Position sind. Manchmal sind sie etwas weiter links\n\nund manchmal etwas weiter rechts. Diese Abweichungen von der\n\nRadarnadel sind zuf�llig und du kannst nicht perfekt vorhersagen,\n\nwo sich ein Schiff aufh�lt.';
else
    txt = 'Der Radar zeigt dir die Position der Schiffsflotte leider nur ungef�hr an.\n\nDurch den Seegang kommt es oft vor, dass die Schiffe nur in der N�he der\n\nangezeigten Position sind. Manchmal sind sie etwas weiter links und manchmal\n\netwas weiter rechts. Diese Abweichungen von der Radarnadel sind zuf�llig und du\n\nkannst nicht perfekt vorhersagen, wo sich ein Schiff aufh�lt.';
end
BigScreen(taskParam, txtPressEnter, header, txt);

% Screen 9.
header = 'Wie du einen Schuss abgibst';
if isequal(taskParam.gParam.computer, 'Humboldt')
    txt='Mit LEERTASTE gibst du einen Schuss ab. Richte dich dabei nach\n\nder Radarnadel. Beachte, dass der Radar dir durch den Seegang\n\nnur ungef�hr angibt wo die Schiffe sind.';
else
    txt='Mit LEERTASTE gibst du einen Schuss ab. Richte dich dabei nach der\n\nRadarnadel. Beachte, dass dir der Radar durch den Seegang nur\n\nungef�hr angibt wo, die Schiffe sind.';
end
BigScreen(taskParam, txtPressEnter, header, txt);

% Screen 10.
header = 'Worauf du achten solltest';
if isequal(taskParam.gParam.computer, 'Humboldt')
    txt = 'Es ist wichtig, dass du w�hrend der Aufgabe immer auf das\n\nFixationskreuz schaust. Wir bitten dich darum, m�glichst wenige\n\nAugenbewegungen zu machen. Versuche au�erdem wenig zu blinzeln.\n\nWenn du blinzeln musst, dann bitte bevor du einen Schuss abgibst.\n\n\nIn der folgenden �bung sollst du probieren, m�glichst viele Schiffe\n\nzu treffen.';
else
    txt = 'Es ist wichtig, dass du w�hrend der Aufgabe immer auf das Fixationskreuz\n\nschaust. Wir bitten dich darum, m�glichst wenige Augenbewegungen zu machen.\n\nVersuche au�erdem wenig zu blinzeln. Wenn du blinzeln musst, dann bitte bevor\n\ndu einen Schuss abgibst.\n\n\nIn der folgenden �bung sollst du probieren, m�glichst viele Schiffe zu treffen.';
end
BigScreen(taskParam, txtPressEnter, header, txt);


%%% Intro-trials with length == taskParam.intTrials and counterbalance condition (cBal) %%%

% if cBal == '1'
    
    % Screen 11.
    
    %NoiseIndication(taskParam, txtLowNoise, txtPressEnter)
    
    
    
    distMean = 338;
    outcome = [324;348;371;303;316;332;310;339;357;316;320;308;308;311;330;299;359;375;368;303];
    boatType = [1;3;1;1;3;3;3;1;2;2;1;3;1;3;3;1;3;2;3;2];
    
    
    % Screen 12 (1st practice block).
    for i = 1:taskParam.gParam.intTrials
        
        taskParam = ControlLoop(taskParam, distMean, outcome(i), boatType(i));
        
    end
    
%     % Screen 13.
%     
%     NoiseIndication(taskParam, txtHighNoise, txtPressEnter)
%     
%     
%     %  Screen 14 (1st practice block with high noise).
%     distMean = 249;
%     outcome = [255;237;195;277;205;222;274;263;324;232;236;184;266;240;184;272;244;268;185;236];
%     boatType = [1;3;1;1;3;3;3;1;2;2;1;3;1;3;3;1;3;2;3;2];
%     
%     for i = 1:taskParam.gParam.intTrials
%         
%         taskParam = ControlLoop(taskParam, distMean, outcome(i), boatType(i));
%         
%     end
    
% elseif cBal == '2'
%     
%     % Screen 15.
%     
%     NoiseIndication(taskParam, txtHighNoise, txtPressEnter)
%     
%     
%     % Screen 16 (1st practice block with high noise).
%     distMean = 249;
%     outcome = [255;237;195;277;205;222;274;263;324;232;236;184;266;240;184;272;244;268;185;236];
%     boatType = [1;3;1;1;3;3;3;1;2;2;1;3;1;3;3;1;3;2;3;2];
%     
%     for i = 1:taskParam.gParam.intTrials
%         
%         taskParam = ControlLoop(taskParam, distMean, outcome(i), boatType(i));
%         
%     end
%     
%     % Screen 17.
%     
%     NoiseIndication(taskParam, txtLowNoise, txtPressEnter)
%     
%     
%     % Screen 18 (1st practice block with low noise)
%     distMean = 338;
%     outcome = [324;348;371;303;316;332;310;339;357;316;320;308;308;311;330;299;359;375;368;303];
%     boatType = [1;3;1;1;3;3;3;1;2;2;1;3;1;3;3;1;3;2;3;2];
%     
%     for i = 1:taskParam.gParam.intTrials
%         
%         taskParam = ControlLoop(taskParam, distMean, outcome(i), boatType(i));
%         
%     end
% end

%KbReleaseWait();

% Screen 19.
header = 'Ende der ersten �bung';
if isequal(taskParam.gParam.computer, 'Humboldt')
    txt='Im n�chsten �bungsdurchgang fahren die Schiffe ab und zu weiter.\n\nWann die Flotte weiterf�hrt kannst du nicht vorhersagen. Wenn dir\n\ndie Radarnadel eine neue Position anzeigt, solltest du dich daran\n\nanpassen.\n\n\nVersuche bitte wieder auf das Fixationskreuz zu gucken und m�glichst\n\nwenig zu blinzeln.';
else
    txt='Im n�chsten �bungsdurchgang fahren die Schiffe ab und zu weiter.\n\nWann die Flotte weiterf�hrt kannst du nicht vorhersagen. Wenn dir die\n\nRadarnadel eine neue Position anzeigt, solltest du dich daran anpassen.\n\n\nVersuche bitte wieder auf das Fixationskreuz zu gucken und m�glichst wenig\n\nzu blinzeln.';
end
BigScreen(taskParam, txtPressEnter, header, txt)


if cBal == '1'
    
    % Screen 20.
    
    NoiseIndication(taskParam, txtLowNoise, txtPressEnter)
    
    
    % Screen 21 (2nd practice block with low noise).
    outcome = [142;165;88;147;248;250;232;268;237;231;271;315;315;309;327;260;299;250;291;42];
    distMean = [146;146;146;146;242;242;242;242;242;242;242;291;291;291;291;291;291;291;291;20];
    boatType = [1;1;2;2;2;2;3;1;3;2;2;3;3;1;1;2;1;2;2;3];
    
    for i=1:taskParam.gParam.intTrials
        
        taskParam = ControlLoop(taskParam, distMean(i), outcome(i), boatType(i));
        
    end
    
    % Screen 22.
    
    
    NoiseIndication(taskParam, txtHighNoise, txtPressEnter)
    
    
    KbReleaseWait();
    
    % Screen 23 (2nd practice block with high noise).
    outcome = [329;372;317;285;340;344;266;332;264;110;135;180;163;237;189;93;229;247;312;179];
    distMean = [312;312;312;312;312;312;312;312;312;176;176;176;176;176;176;176;224;224;224;224];
    boatType = [1;1;2;2;2;2;3;1;3;2;2;3;3;1;1;2;1;2;2;3];
    
    for i=1:taskParam.gParam.intTrials
        
        taskParam = ControlLoop(taskParam, distMean(i), outcome(i), boatType(i));
        
    end
    
elseif cBal == '2'
    
    % Screen 24.
    
    NoiseIndication(taskParam, txtHighNoise, txtPressEnter)
    
    
    
    KbReleaseWait();
    
    % Screen 25 (2nd practice block with high noise).
    outcome = [329;372;317;285;340;344;266;332;264;110;135;180;163;237;189;93;229;247;312;179];
    distMean = [312;312;312;312;312;312;312;312;312;176;176;176;176;176;176;176;224;224;224;224];
    boatType = [1;1;2;2;2;2;3;1;3;2;2;3;3;1;1;2;1;2;2;3];
    
    for i=1:taskParam.gParam.intTrials
        
        taskParam = ControlLoop(taskParam, distMean(i), outcome(i), boatType(i));
        
    end
    
    % Screen 26.
    NoiseIndication(taskParam, txtLowNoise, txtPressEnter)
    
    
    
    % Screen 27 (2nd practice block with low noise).
    outcome = [142;165;88;147;248;250;232;268;237;231;271;315;315;309;327;260;299;250;291;42];
    distMean = [146;146;146;146;242;242;242;242;242;242;242;291;291;291;291;291;291;291;291;20];
    boatType = [1;1;2;2;2;2;3;1;3;2;2;3;3;1;1;2;1;2;2;3];
    
    for i=1:taskParam.gParam.intTrials
        
        taskParam = ControlLoop(taskParam, distMean(i), outcome(i), boatType(i));
        
    end
    
end

header = 'Ende der zweiten �bung';
if isequal(taskParam.gParam.computer, 'Humboldt')
    txt = 'In der folgenden �bung ist dein Radar leider kaputt. Die Radarnadel\n\nkannst du jetzt nur noch selten sehen. In den meisten F�llen musst\n\ndu die Schiffsposition selber herausfinden. Trotzdem solltest du\n\nversuchen, m�glichst viele Schiffe abzuschie�en.';
else
    txt = 'In der folgenden �bung ist dein Radar leider kaputt. Die Radarnadel kannst du\n\njetzt nur noch selten sehen. In den meisten F�llen musst du die Schiffsposition\n\nselber herausfinden. Du solltest versuchen, m�glichst viele Schiffe\n\nabzuschie�en.';
end
BigScreen(taskParam, txtPressEnter, header, txt)


%% End of intro // Save data.


end
