classdef al_display
    %AL_DISPLAY This class definition file specifies the
    %   properties and methods of a display object
    %
    %   A display object has general display methods such as
    %   creating the psychtoolbox window and parameters, e.g.,
    %   screen coordinates


    % Properties of the display object
    % --------------------------------

    properties

        % General
        screensize % screen size
        screensizePart % witdh and height of screen
        globalScreenBorder % for Linux: virtual border sparating global screen
        distance2screen % participant distance to screen in mm
        screenWidthInMM % for degrees visual angle
        window % psychtoolbox window
        zero % center of the screen
        backgroundCoords % background coordinates
        socialsample % type of pictures (none, adolescents, youngera adults)

        % Textures
        cannonTxt
        doctorTxt
        heliTxt
        duckTxt
        pill1Txt
        pill2Txt
        pill3Txt
        pill4Txt
        syringeTxt
        cloudTexture
        feedbackTxt
        keyboardTxt
        

        % Image rectangles
        %% todo: check if dst and image rects can be merged
        imageRect % cannon image rectangle size (before centering)
        dstRect % cannon image rectangle size (after centering)
        doctorRect
        centeredSocialFeedbackRect
        windowRect
        heliImageRect
        duckImageRect
        pillImageRect
        syringeImageRect
        socialFeedbackRect

        % Textures
        backgroundTxt % background texture
        backgroundCol % background color
        socialHasTxts
        socialDisTxts

        % Number of textures in social task (also potentially child class)
        nHas
        nDis

        % Indicate if we want to use degrees visual angle
        useDegreesVisualAngle

    end

    % Methods of the display object
    % -----------------------------
    methods

        function self = al_display()
            %AL_self This function creates a displayob object of
            % class al_display
            %
            %   The initial values correspond to useful defaults that
            %   are often used across tasks.

            self.cannonTxt = nan;
            self.doctorTxt = nan;
            self.dstRect = nan;
            self.backgroundTxt = nan;
            %% todo: add common value here (not yet decided)
            self.distance2screen = 700;
            self.screenWidthInMM = 309.40; % Rasmus' default laptop
            self.backgroundCol = [0, 0, 0];
            self.socialFeedbackRect = [0 0 2048 2048]/4; %[0 0 562 762]/4;
            self.socialsample = 1;
            self.imageRect = [0 0 180 270];
            self.doctorRect = [0 0 100 100];
            self.heliImageRect = [0 0 100 100];
            self.duckImageRect = [0 0 100 100];
            self.pillImageRect = [0 0 30 30];
            self.syringeImageRect = [0 0 50 50];
            self.useDegreesVisualAngle = false;
            self.globalScreenBorder = 0;

        end

        function self = openWindow(self, gParam)
            %OPENWINDOW This function creates an opens the psychtoolbox
            %   screen
            %
            %   Input
            %       gParam: General task parameters

            % screensize = screensize(taskParam.gParam.screenNumber, :);
            self.screensizePart = self.screensize(3:4);
            self.zero = self.screensizePart / 2;

            % Open psychtoolbox window
            if gParam.debug == true
                [self.window.onScreen, self.windowRect] = Screen('OpenWindow', gParam.screenNumber-1, self.backgroundCol, [1920 0 1920+1920 1080]);
            else
                windowScreensize = self.screensize;
                windowScreensize(1) = windowScreensize(1) + self.globalScreenBorder;
                windowScreensize(3) = windowScreensize(3) + self.globalScreenBorder;

                [self.window.onScreen, self.windowRect] = Screen('OpenWindow', gParam.screenNumber-1, self.backgroundCol, windowScreensize); 
            end

            [self.window.screenX, self.window.screenY] = Screen('WindowSize', self.window.onScreen);
            self.window.centerX = self.window.screenX * 0.5; % center of screen in X direction
            self.window.centerY = self.window.screenY * 0.5; % center of screen in Y direction
            self.window.centerXL = floor(mean([0 self.window.centerX])); % center of left half of screen in X direction
            self.window.centerXR = floor(mean([self.window.centerX self.window.screenX])); % center of right half of screen in X direction

        end

        function self = createRects(self)
            % CREATERECTS This function centers the imageRect ("dstRect")
            % based on "windowRect" by taking into account that imageRect
            % differs for each task version, e.g., standard cannon vs.
            % confetti

            self.dstRect = CenterRect(self.imageRect, self.windowRect);
            self.doctorRect = CenterRect(self.doctorRect, self.windowRect);
            self.heliImageRect = CenterRect(self.heliImageRect, self.windowRect);
            self.duckImageRect = CenterRect(self.duckImageRect, self.windowRect);
            self.pillImageRect = CenterRect(self.pillImageRect, self.windowRect);
            self.syringeImageRect = CenterRect(self.syringeImageRect, self.windowRect);
            self.centeredSocialFeedbackRect = CenterRect(self.socialFeedbackRect, self.windowRect);
            % todo: check if we can rename to socialFeedbackRect

        end

        function self = createTextures(self, cannonType)
    % CREATETEXTURES This function loads and creates textures of displayed images
    %
    %   Inputs:
    %       cannonType - Determines which type of cannon should be shown
    %
    %   Outputs:
    %       self - Updated display object with loaded textures
    
    % === Load Background Image ===
    [backgroundPic, ~, ~] = imread('hospital_setting_from_above.png');

%% Load the Feedback Image for the Leipzig Task Version

% Define image path 
feedbackImagePath = 'C:\Users\pc\Desktop\RU_OCD_Adaptive_Learning\pictures\new_hospital_image.png'; 

% Initialize placeholder
self.feedbackTxt = nan;

% Load Feedback Image
if exist(feedbackImagePath, 'file') ~= 2
    warning('Feedback image not found: %s', feedbackImagePath);
else
    [feedbackPic, ~, feedbackAlpha] = imread(feedbackImagePath);

    % Merge alpha channel if available
    if ~isempty(feedbackAlpha)
        feedbackPic(:,:,4) = feedbackAlpha;
    end

    % Create texture and store it
    self.feedbackTxt = Screen('MakeTexture', self.window.onScreen, feedbackPic);
    
end

%% Load the Keyboard Image for the Leipzig Task Version

% Define image path 
KeyboardImagePath = 'C:\Users\pc\Desktop\RU_OCD_Adaptive_Learning\pictures\Tastatur_No_Background.png'; 

% Initialize placeholder
self.keyboardTxt = nan;

% Load Keyboard Image
if exist(KeyboardImagePath, 'file') ~= 2
    warning('Feedback image not found: %s', KeyboardImagePath);
else
    [keyboardPic, ~, keyboardAlpha] = imread(KeyboardImagePath);

    % Merge alpha channel if available
    if ~isempty(keyboardAlpha)
        keyboardPic(:,:,4) = keyboardAlpha;
    end

    % Create texture and store it
    self.keyboardTxt = Screen('MakeTexture', self.window.onScreen, keyboardPic);
    
end

    %% Load Other Images Based on Cannon Type ===
    if strcmp(cannonType, 'standard')
        [cannonPic, ~, alpha] = imread('cannon_not_centered.png');
    elseif strcmp(cannonType, 'HelicopterNEW')
        [cannonPic, ~, alpha] = imread('Hubschrauber_rotated.png');
    elseif strcmp(cannonType, 'duck')
        [duckPic, ~, duckAlpha] = imread('duck.png');
    else
        [cannonPic, ~, alpha] = imread('confetti_cannon.png');
    end

    % === Set Background Image Size ===
    backgroundPicSize = size(backgroundPic);
    ySize = self.window.screenY;
    scaleFactor = ySize / backgroundPicSize(1);
    xSize = backgroundPicSize(2) * scaleFactor;
    self.backgroundCoords = [self.zero(1)-xSize/2, self.zero(2)-ySize/2, self.zero(1)+xSize/2, self.zero(2)+ySize/2];

    % === Merge Alpha Channels for Transparency ===
    if strcmp(cannonType, 'helicopter')
        doctorPic(:,:,4) = doctorAlpha(:,:);
        heliPic(:,:,4) = heliAlpha(:,:);
        pill1Pic(:,:,4) = pill1Alpha(:,:);
        pill2Pic(:,:,4) = pill2Alpha(:,:);
        pill3Pic(:,:,4) = pill3Alpha(:,:);
        pill4Pic(:,:,4) = pill4Alpha(:,:);
        syringePic(:,:,4) = syringeAlpha(:,:);
    elseif strcmp(cannonType, 'duck')
        duckPic(:,:,4) = duckAlpha(:,:);
    else
        cannonPic(:,:,4) = alpha(:,:);
    end

    % === Set Alpha Blending Mode ===
    Screen('BlendFunction', self.window.onScreen, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    % === Create Textures ===
    self.backgroundTxt = Screen('MakeTexture', self.window.onScreen, backgroundPic);
    
    if strcmp(cannonType, 'helicopter')
        self.doctorTxt = Screen('MakeTexture', self.window.onScreen, doctorPic);
        self.heliTxt = Screen('MakeTexture', self.window.onScreen, heliPic);
        self.pill1Txt = Screen('MakeTexture', self.window.onScreen, pill1Pic);
        self.pill2Txt = Screen('MakeTexture', self.window.onScreen, pill2Pic);
        self.pill3Txt = Screen('MakeTexture', self.window.onScreen, pill3Pic);
        self.pill4Txt = Screen('MakeTexture', self.window.onScreen, pill4Pic);
        self.syringeTxt = Screen('MakeTexture', self.window.onScreen, syringePic);
    elseif strcmp(cannonType, 'duck')
        self.duckTxt = Screen('MakeTexture', self.window.onScreen, duckPic);
    else
        self.cannonTxt = Screen('MakeTexture', self.window.onScreen, cannonPic);
    end
end


        function sizePixel = deg2pix(self, sizeDeg)
            %DEG2PIX This function translates degrees visual angle to
            % pixels
            %
            %   The function is used to define stimulus size in terms of
            %   degrees visual angle and to translate it to pixels for
            %   psychtoolbox
            %
            %   Input
            %       sizeDeg: Stimulus size in degrees visual angle
            %
            %   Output
            %       sizePixel: Stimulus size in pixels
            
            % Extract relevant parameters
            screenWidth = self.screenWidthInMM; % screen width in mm
            distance = self.distance2screen; % distance to screen in mm
            horizontalRes = self.screensize(3); % horizontal resolution in pixels

            % Compute size of each pixel in mm
            singlePixelMM = screenWidth / horizontalRes;

            % Compute degrees visual angle of each pixel
            singlePixelDeg = rad2deg(atan(singlePixelMM/distance));

            % Compute size in pixels
            sizePixel = sizeDeg / singlePixelDeg;

        end

        function sizeDeg = pix2deg(self, sizePixel)
            %PIX2DEG This function translates pixels to degrees visual
            % angle
            %
            %   Input
            %       sizePixels: Stimulus size in pixels
            %
            %   Output
            %       sizeDeg: Stimulus size in degrees visual angle

            % Extract relevant parameters
            screenWidth = self.screenWidthInMM; % screen width in mm
            distance = self.distance2screen; % distance to screen in mm
            horizontalRes = self.screensize(3); % horizontal resolution in pixels

            % Compute size of each pixel in mm
            singlePixelMM = screenWidth / horizontalRes;

            % Compute stimulus size in degrees visual angle
            sizeDeg = rad2deg(atan((sizePixel*singlePixelMM)/distance));

        end
    end

    methods (Static)
        function screen_warnings()
            % SCREENWARNINGS This function handles screen warnings

            Screen('Preference', 'VisualDebugLevel', 3);
            Screen('Preference', 'SuppressAllWarnings', 1);
            Screen('Preference', 'SkipSyncTests', 2);

        end
    end
end

