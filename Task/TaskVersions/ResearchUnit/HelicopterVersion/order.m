function [Order] = order()

global Order

% Defaults
ID    = '99999';
ord   = '0'; % 1 = first Heli; second Konfetti // 2 = first Konfetti; second Heli

% Variables for input dialog
prompt = {'ID:', 'Order:'};
name = 'Order';
numlines = 1;  % Fixed missing semicolon

% Default values
defaultanswer = {ID, ord};

% Get user input
Info = inputdlg(prompt, name, numlines, defaultanswer);

% Convert order choice to a number (corrected cell indexing)
Order = str2double(Info{2,1});  % Fixed indexing issue

% Run tasks in the specified order
if Order == 1 % First Helicopter
    RunHelicopterVersion;
    RunConfidenceVersionReduced; % Ensure this function exists
else % Order = 2; First Confidence
    RunConfidenceVersion;
    RunHelicopterVersionReduced; % Ensure this function exists
end

end
