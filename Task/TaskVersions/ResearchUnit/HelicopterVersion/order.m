function [Order] = order()
    global Order

    % Defaults
    ID    = '99999';
    ord   = '0'; % 1 = first Heli; second Konfetti // 2 = first Konfetti; second Heli

    % Variables for input dialog
    prompt = {'ID:', 'Order:'};
    name = 'Order';
    numlines = 1;

    % Default values
    defaultanswer = {ID, ord};

    % Get user input
    Info = inputdlg(prompt, name, numlines, defaultanswer);

    % Convert order choice to a number
    Order = str2double(Info{2,1});

    % Set practice trials dynamically based on order
    if Order == 1  % First Helicopter
        config1 = al_HelicopterConfig(true);  % First task = more practice
        RunHelicopterVersion(config1);

        config2 = al_ConfidenceConfig(false); % Second task = less practice
        RunConfidenceVersion(config2); 

    else  % First Confidence
        config1 = al_ConfidenceConfig(true);  % First task = more practice
        RunConfidenceVersion(config1); 

        config2 = al_HelicopterConfig
        
        
        
        
        
        
        (false); % Second task = less practice
        RunHelicopterVersion(config2); 
    end
end
