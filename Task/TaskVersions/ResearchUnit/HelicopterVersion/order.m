function [Order] = order()
    
% Define default values
    ID    = '99999';
    ord   = '0'; % 1 = first Heli, second Konfetti; 2 = first Konfetti, second Heli

    % Variables for input dialog
    prompt = {'ID:', 'Order (1 = Heli first, 2 = Konfetti first):'};
    name = 'Order Selection';
    numlines = 1;
    defaultanswer = {ID, ord};

    % Get user input
    Info = inputdlg(prompt, name, numlines, defaultanswer);

    % Validate input
    if isempty(Info)  % If user cancels input dialog
        error('User canceled input. Exiting function.');
    end

    Order = str2double(Info{2,1});

    if isnan(Order) || ~ismember(Order, [1, 2])
        error('Invalid input. Order must be 1 (Heli first) or 2 (Konfetti first).');
    end

    % Execute tasks based on user selection
    if Order == 1  % First Helicopter
        config1 = al_HelicopterConfig(true);  % First task = more practice
        RunHelicopterVersion(config1);

        config2 = al_ConfidenceConfig(false); % Second task = less practice
        RunConfidenceVersion(config2); 
    else  % First Confidence
        config1 = al_ConfidenceConfig(true);  % First task = more practice
        RunConfidenceVersion(config1); 

        config2 = al_HelicopterConfig(false); % Second task = less practice
        RunHelicopterVersion(config2); 
    end
end
