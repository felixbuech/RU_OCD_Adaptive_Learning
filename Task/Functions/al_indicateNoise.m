function al_indicateNoise(taskParam, noiseCondition, variableShield, passiveViewing)
% AL_INDICATENOISE This function indicates the noise condition.
%
%   Input:
%       taskParam: Task-parameter-object instance
%       noiseCondition: String indicating noise level ('lowNoise' or 'highNoise')
%       variableShield: Boolean indicating if shield is variable (optional)
%       passiveViewing: Boolean indicating if we are in passive-viewing (optional)
%
%   Output:
%       None

% Check for variable shield input
if ~exist('variableShield', 'var') || isempty(variableShield)
    variableShield = false;
end

% Check for passive-viewing input
if ~exist('passiveViewing', 'var') || isempty(passiveViewing)
    passiveViewing = false;
end

% ----- Branch 1: Fixed shield (variableShield == false) -----
if strcmp(noiseCondition, 'lowNoise') && ~variableShield
    if isequal(taskParam.gParam.language, 'German')
        header = 'Genauere Konfetti-Kanone';
        txt = ['Im folgenden Block wird die Konfetti-Kanone relativ genau sein.\n\n'...
               'Weil Sie das Konfetti hier relativ gut vorhersagen können, '...
               'wird der Eimer, mit dem Sie das Konfetti fangen sollen, relativ klein sein.\n\n'...
               'Zur Erinnerung: Der rosafarbene Strich zeigt Ihre letzte Vorhersage. Der schwarze '...
               'Strich zeigt die Position der letzten Konfetti-Wolke.'];
    elseif isequal(taskParam.gParam.language, 'English')
        header = 'More accurate confetti cannon';
        txt = ['In the following block, the confetti cannon will be relatively accurate.\n\n'...
               'Because you can predict the confetti relatively well here, '...
               'the bucket with which you should catch the confetti will be relatively small.'];
    else
        error('language parameter unknown')
    end

elseif strcmp(noiseCondition, 'highNoise') && ~variableShield
    if isequal(taskParam.gParam.language, 'German')
        header = 'Ungenauere Konfetti-Kanone';
        txt = ['Im folgenden Block wird die Konfetti-Kanone relativ ungenau sein.\n\n'...
               'Weil Sie das Konfetti hier schwieriger vorhersagen können, '...
               'wird der Eimer, mit dem Sie das Konfetti fangen sollen, relativ groß sein.\n\n'...
               'Zur Erinnerung: Der rosafarbene Strich zeigt Ihre letzte Vorhersage. Der schwarze '...
               'Strich zeigt die Position der letzten Konfetti-Wolke.'];
    elseif isequal(taskParam.gParam.language, 'English')
        header = 'Less accurate confetti cannon';
        txt = ['In the following block, the confetti cannon will be relatively inaccurate.\n\n'...
               'Because it is more difficult to predict the confetti here, '...
               'the bucket with which you should catch the confetti will be relatively large.'];
    else
        error('language parameter unknown')
    end

% ----- Branch 2: Variable shield & non-passive viewing -----
% Now we separate the variable-shield branch into two cases:
% one for blocks with confidence and one for blocks without confidence.

elseif strcmp(noiseCondition, 'lowNoise') && variableShield && ~passiveViewing
    if taskParam.trialflow.includeConfidence
        % With confidence text for low noise
        if taskParam.gParam.customInstructions
            header = taskParam.instructionText.introduceLowNoiseHeader;
            txt = taskParam.instructionText.introduceLowNoiseConfidence;
        else
            if isequal(taskParam.gParam.language, 'German')
                header = 'Genauer Helikopter (mit Vertrauensangabe)';
                txt = ['Im folgenden Block wird der Helikopter relativ genau sein.\n\n'...
                       'Die Größe des Netzes kann sich von Durchgang zu Durchgang ändern. '...
                       'Diese Veränderung können Sie nicht beeinflussen und auch nicht vorhersagen. '...
                       'Daher ist es immer die beste Strategie, das Netz genau dorthin zu stellen, '...
                       'wo Sie das Ziel des Helikopters vermuten.\n\n'...
                       'Bitte geben Sie zusätzlich an, wie sicher Sie sich Ihrer Vorhersage sind.'];
            elseif isequal(taskParam.gParam.language, 'English')
                header = 'More accurate helicopter (with confidence rating)';
                txt = ['In the following block, the helicopter will be relatively accurate.\n\n'...
                       'The size of the net can change from trial to trial. '...
                       'You cannot influence this change nor can you predict it. '...
                       'Therefore, the best strategy is always to place the net exactly where '...
                       'you think the helicopter will drop.\n\n'...
                       'Please also rate your confidence in your prediction.'];
            else
                error('language parameter unknown')
            end
        end
    else
        % Without confidence text for low noise
        if taskParam.gParam.customInstructions
            header = taskParam.instructionText.introduceLowNoiseHeader;
            txt = taskParam.instructionText.introduceLowNoise;
        else
            if isequal(taskParam.gParam.language, 'German')
                header = 'Genauer Helikopter';
                txt = ['Im folgenden Block wird der Helikopter relativ genau sein.\n\n'...
                       'Die Größe des Netzes kann sich von Durchgang zu Durchgang ändern. '...
                       'Diese Veränderung können Sie nicht beeinflussen und auch nicht vorhersagen. '...
                       'Daher ist es immer die beste Strategie, das Netz genau dorthin zu stellen, '...
                       'wo Sie das Ziel des Helikopters vermuten.'];
            elseif isequal(taskParam.gParam.language, 'English')
                header = 'More accurate helicopter';
                txt = ['In the following block, the helicopter will be relatively accurate.\n\n'...
                       'The size of the net can change from trial to trial. '...
                       'You cannot influence this change nor can you predict it. '...
                       'Therefore, the best strategy is always to place the net exactly where '...
                       'you think the helicopter will drop.'];
            else
                error('language parameter unknown')
            end
        end
    end

elseif strcmp(noiseCondition, 'highNoise') && variableShield && ~passiveViewing
    if taskParam.trialflow.includeConfidence
        % With confidence text for high noise
        if taskParam.gParam.customInstructions
            header = taskParam.instructionText.introduceHighNoiseHeader;
            txt = taskParam.instructionText.introduceHighNoiseConfidence;
        else
            if isequal(taskParam.gParam.language, 'German')
                header = 'Ungenauerer Helikopter (mit Vertrauensangabe)';
                txt = ['Im folgenden Block wird der Helikopter relativ ungenau sein.\n\n'...
                       'Die Größe des Netzes kann sich von Durchgang zu Durchgang ändern. '...
                       'Diese Veränderung können Sie nicht beeinflussen und auch nicht vorhersagen. '...
                       'Daher ist es immer die beste Strategie, das Netz genau dorthin zu stellen, '...
                       'wo Sie das Ziel des Helikopters vermuten.\n\n'...
                       'Bitte geben Sie zusätzlich an, wie sicher Sie sich Ihrer Vorhersage sind.'];
            elseif isequal(taskParam.gParam.language, 'English')
                header = 'Less accurate helicopter (with confidence rating)';
                txt = ['In the following block, the helicopter will be relatively inaccurate.\n\n'...
                       'The size of the net can change from trial to trial. '...
                       'You cannot influence this change nor can you predict it. '...
                       'Therefore, the best strategy is always to place the net exactly where '...
                       'you think the helicopter will drop.\n\n'...
                       'Please also rate your confidence in your prediction.'];
            else
                error('language parameter unknown')
            end
        end
    else
        % Without confidence text for high noise
        if taskParam.gParam.customInstructions
            header = taskParam.instructionText.introduceHighNoiseHeader;
            txt = taskParam.instructionText.introduceHighNoise;
        else
            if isequal(taskParam.gParam.language, 'German')
                header = 'Ungenauerer Helikopter';
                txt = ['Im folgenden Block wird der Helikopter relativ ungenau sein.\n\n'...
                       'Die Größe des Netzes kann sich von Durchgang zu Durchgang ändern. '...
                       'Diese Veränderung können Sie nicht beeinflussen und auch nicht vorhersagen. '...
                       'Daher ist es immer die beste Strategie, das Netz genau dorthin zu stellen, '...
                       'wo Sie das Ziel des Helikopters vermuten.'];
            elseif isequal(taskParam.gParam.language, 'English')
                header = 'Less accurate helicopter';
                txt = ['In the following block, the helicopter will be relatively inaccurate.\n\n'...
                       'The size of the net can change from trial to trial. '...
                       'You cannot influence this change nor can you predict it. '...
                       'Therefore, the best strategy is always to place the net exactly where '...
                       'you think the helicopter will drop.'];
            else
                error('language parameter unknown')
            end
        end
    end

% ----- Branch 3: Passive viewing (overrides noise conditions) -----
elseif passiveViewing == true
    if taskParam.gParam.customInstructions
        header = taskParam.instructionText.introducePassiveViewingHeader;
        txt = taskParam.instructionText.introducePassiveViewing;
    else
        header = 'Beobachtungsaufgabe';
        txt = ['Versuchen Sie in dieser Aufgabe bitte in die Mitte '...
               'des Bildschirms zu fixieren. Es ist wichtig, dass Sie Ihre Augen nicht bewegen!\n\n'...
               'Versuchen Sie nur zu blinzeln, wenn der weiße Punkt erscheint.'];
    end

% ----- Fallback branch -----
else
    header = 'Default Instruction';
    txt = 'No specific instruction for this condition.';
end

feedback = true;
al_bigScreen(taskParam, header, txt, feedback);

end
