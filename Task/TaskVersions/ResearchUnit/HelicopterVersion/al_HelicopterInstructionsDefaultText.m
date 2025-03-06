classdef al_HelicopterInstructionsDefaultText
    %AL_COMMONCONFETTIINSTRUCTIONSDEFAULTTEXT This class-definition file
    % specifiec the properties of the instruction text.
    %
    % The advantage of this kind of text file is that most text is in one
    % place and a local file can replace (specified in the config file) the
    % default file so that local differences are not tracked on GitHub.

    properties

        language
        welcomeText
        % pandemicHeader
        context
        introduceCannon
        introduceConfetti
        introduceSpot
        introduceShield
        introduceMiss
        introduceMissBucket
        introducePracticeSession
        firstPracticeHeader
        firstPractice
        reduceShieldHeader
        reduceShield
        secondPracticeHeader
        secondPractice
        thirdPracticeHeader
        thirdPractice
        fourthPracticeHeader
        fourthPractice
        startTaskHeader
        startTask
        noCatchHeader
        noCatch
        accidentalCatchHeader
        accidentalCatch
        showCannonText
        addCannonText
        cannonFeedbackText
        practiceBlockFailHeader
        practiceBlockFail
        cannonPracticeFail
        firstPupilBaselineHeader
        firstPupilBaseline
        secondPupilBaselineHeader
        secondPupilBaseline
        introduceLowNoiseHeader
        introduceLowNoise
        introduceHighNoiseHeader
        introduceHighNoise
        dynamicFeedbackTxt
        dynamicFeedbackHeader
        introducePassiveViewingHeader
        introducePassiveViewing
        dynamicBlockTxt
        introduceLowNoiseConfidence
        introduceHighNoiseConfidence
        ConfidencePractice
        ConfidencePracticeHeader
        ConfidencePracticeHeaderTwo
        ConfidencePracticeTwo
        
    end

    methods

        function self = al_HelicopterInstructionsDefaultText(language)
            % This function creates an object of
            % class al_commonConfettiInstructionsDefaultText
            %
            %   Input
            %       language: Optional parameter specifying language (default German)
            %
            %   Output
            %       None


            % Check if language parameter is provided
    if ~exist('language', 'var') || isempty(language)
        self.language = 'German';
    else
        self.language = language;
    end

    

            % First message when starting task
            if isequal(self.language, 'German')
                self.welcomeText = 'Herzlich Willkommen zur Helikopter-Aufgabe!';
            elseif isequal(self.language, 'English')
                self.welcomeText = 'Welcome to the confetti-cannon task!';
            else
                error('language parameter unknown')
            end

            % Introduce Pandemic Context

            if isequal(self.language, 'German')
    % self.pandemicHeader = 'Achtung Virusausbruch!';
    self.context = ['In Ihrer Region ist ein lebensbedrohliches Virus ausgebrochen. Die Zahl der Infizierten steigt rasant und täglich sterben Menschen. '...
        'Das ganze Gebiet wurde deshalb von der Umgebung abgeschottet. '...
        'Da kein direkter Kontakt mit der Außenwelt mehr möglich ist, werden lebensrettende Medikamente von Hubschraubern abgeworfen.\n\n '...
        'Sie arbeiten als Koordinationsleitung des Katastrophenschutzes und sind für die Entgegennahme der Güter auf dem Boden verantwortlich. '...
        'Da der Hubschrauber die Medikamente aus großer Höhe abwirft, kann der Landungsort nie genau vorhergesagt werden.\n\n'...
        'Werden die überlebenswichtigen Medikamente nicht sofort gesichert, sind sie unbrauchbar und weniger Infizierten kann geholfen werden. '...
        'Ihre Aufgabe ist es, Ihr Team immer dorthin zu schicken, wo Sie den Landungsort vermuten. Sie allein tragen die Verantwortung, das Leben vieler Menschen zu retten.\n'...
        'Versagen Sie, hat dies weitere Todesfälle zur Folge!​'];

elseif isequal(self.language, 'English')
    self.context = 'Welcome to the confetti-cannon task!';
else
    error('language parameter unknown')
end

           
            
            % Introduce cannon
            if isequal(self.language, 'German')
                self.introduceCannon = ['Sie blicken von oben auf das Gefahrengebiet und den Hubschrauber, der die Medikamente abwirft. Ihre Aufgabe ist es, die Medikamente mit einem Netz zu fangen. Mit dem rosafarbenen '...
    'Punkt können Sie angeben, wo auf dem Kreis Sie Ihr Netz platzieren möchten, um die Medikamente zu fangen. Sie können den Punkt mit der Maus steuern.'];
            elseif isequal(self.language, 'English')
                self.introduceCannon = ['You are looking from above at a confetti cannon placed in the center of a circle. Your task is to catch the confetti with a bucket. Use the pink dot '...
                    'to indicate where you would like to place your bucket to catch the confetti. '...
                    'You can move the pink dot using the mouse.'];
            else
                error('language parameter unknown')
            end

            % Introduce confetti
            if isequal(self.language, 'German')
                self.introduceConfetti = 'Das Ziel des Helikopters wird mit der schwarzen Linie angezeigt. Steuern Sie den rosafarbenen Punkt auf den Kreis und drücken Sie die linke Maustaste, damit der Helikopter die Medikamente abwirft.';
            elseif isequal(self.language, 'English')
                self.introduceConfetti = 'The aim of the cannon is indicated by the black line. Hit the left mouse button to fire the cannon.';
            else
                error('language parameter unknown')
            end

            % Introduce spot
            if isequal(self.language, 'German')
                self.introduceSpot = ['Der schwarze Strich zeigt Ihnen die mittlere Position des letzten Lieferung von Medikamenten. Der rosafarbene Strich zeigt Ihnen die '...
                    'letzte Position Ihres Netzes. Steuern Sie den rosafarbenen Punkt jetzt bitte auf das Ziel des Helikopters und drücken Sie die linke Maustaste.'];
            elseif isequal(self.language, 'English')
                self.introduceSpot = ['The black line shows the central position of the last confetti burst. The pink line shows the '...
                    'last position of your bucket. Now move the pink dot to the aim of the confetti cannon and press the left mouse button.'];
            else
                error('language parameter unknown')
            end

            % Introduce shield
            if isequal(self.language, 'German')
                self.introduceShield = 'Nach dem Abwurf sehen Sie den das Netz. Wenn Sie mindestens die Hälfte der Medikamente fangen, zählt der Abwurf als gesichert und Sie erhalten einen Punkt.';
            elseif isequal(self.language, 'English')
                self.introduceShield = ['After the cannon is shot you will see the bucket. '...
                    'If you catch at least half of the confetti with the bucket, it is considered a "catch" and you get a point. '];
            else
                error('language parameter unknown')
            end

            % Introduce miss
            if isequal(self.language, 'German')
                self.introduceMiss = 'Versuchen Sie nun, Ihr Netz so zu positionieren, dass Sie die Medikamente verfehlen. Drücken Sie dann die linke Maustaste.';
            elseif isequal(self.language, 'English')
                self.introduceMiss = ['Now try to place the bucket so that you miss the confetti. Then press '...
                    'the left mouse button. '];
            else
                error('language parameter unknown')
            end

            % Introduce miss with bucket
            if isequal(self.language, 'German')
                self.introduceMissBucket = 'In diesem Fall haben Sie die Medikamente verfehlt.';
            elseif isequal(self.language, 'English')
                self.introduceMissBucket = 'In this case you missed the confetti.';
            else
                error('language parameter unknown')
            end

            % Introduce practice session
            if isequal(self.language, 'German')
                self.introducePracticeSession = 'Im Folgenden durchlaufen Sie ein paar Übungsdurchgänge\nund im Anschluss zwei Durchgänge des Experiments.';
            elseif isequal(self.language, 'English')
                self.introducePracticeSession = 'In the following, you will go through a few practice runs\nand then two blocks of the experiment.';
            else
                error('language parameter unknown')
            end

            % First practice header
            if isequal(self.language, 'German')
                self.firstPracticeHeader = 'Erster Übungsdurchgang';
            elseif isequal(self.language, 'English')
                self.firstPracticeHeader = 'First Practice Run';
            else
                error('language parameter unknown')
            end

            % First practice
            if isequal(self.language, 'German')
                self.firstPractice = ['Weil die Umgebung sehr windig ist, ist der Landeort der Medikamente ziemlich ungenau.\n\nDas heißt, auch wenn '...
    'Sie genau auf das Ziel gehen, können Sie die Medikamente verfehlen.\n\nDie Ungenauigkeit ist zufällig, '...
    'dennoch fangen Sie die meisten Medikamente, wenn Sie den rosafarbenen Punkt genau auf die Stelle '...
    'steuern, die der Hubschrauber anpeilt.\n\nIn dieser Übung sollen Sie mit der Ungenauigkeit '...
    'des Hubschraubers erst mal vertraut werden. Steuern Sie den rosafarbenen Punkt bitte immer auf die anvisierte '...
    'Stelle.\n\nAchten Sie bitte auf Augenbewegungen und Blinzeln wie von der Versuchsleitung erklärt.'];
            
            elseif isequal(self.language, 'English')
                self.firstPractice = ['In this block, the confetti cannon is very old '...
                    'and its aim therefore pretty inaccurate. Even if you move the bucket to the exact aim of the confetti cannon, '...
                    'you might miss the confetti. This inaccuracy is random. '...
                    'Still, your best strategy is to place the '...
                    'bucket in the location where the cannon is '...
                    'aimed.\n\nThe purpose of this practice session is to familiarize yourself with the inaccuracy '...
                    'of the confetti cannon. Please always aim the pink dot at the '...
                    'aim of the cannon.'];
            else
                error('language parameter unknown')
            end

            % Reduced shield header
            if isequal(self.language, 'German')
                self.reduceShieldHeader = 'Illustration Ihres Netzes';
            elseif isequal(self.language, 'English')
                self.reduceShieldHeader = 'Demonstration of your bucket';
            else
                error('language parameter unknown')
            end

            % Reduced
            if isequal(self.language, 'German')
                self.reduceShield = ['Ab jetzt sehen Sie das Netz nur noch mit zwei Strichen dargestellt.\n\n'...
                    'Außerdem sehen Sie die Aufgabe in weniger Farben.' ...
                    'Dies ist notwendig, damit wir Ihre Pupillengröße gut messen können.\n\n Achten Sie daher bitte besonders darauf, '...
                    'Ihren Blick auf den Punkt in der Mitte des Kreises zu fixieren. Bitte versuchen Sie Augenbewegungen und Blinzeln '...
                    'so gut es geht zu vermeiden.\n\n'...
                    'Jetzt folgt zunächst eine kurze Demonstration, wie das Netz mit Strichen im Vergleich zum Netz der vorherigen Übung aussieht.'];
            elseif isequal(self.language, 'English')
                self.reduceShield = 'Please update if you plan to use this.';
            else
                error('language parameter unknown')
            end

            % Second practice header
            if isequal(self.language, 'German')
                self.secondPracticeHeader = 'Zweiter Übungsdurchgang';
            elseif isequal(self.language, 'English')
                self.secondPracticeHeader = 'Second Practice Run';
            else
                error('language parameter unknown')
            end

            % Second practice
            if isequal(self.language, 'German')
                self.secondPractice = ['Um sicherzugehen, dass Sie die Aufgabe verstanden haben, machen wir jetzt eine kurze Übung:\n\n'...
                    'Sie werden hintereinander fünf Abwürfe des Helikopters sehen. Danach geben Sie bitte an, wo Sie das Ziel des Helikopters vermuten.\n\n'...
                    'Die beste Strategie ist, die mittlere Position der Abwürfe anzugeben. Diese Position ist die beste Vohersage, um in der Aufgabe am meisten Medikamente zu fangen.'];

            elseif isequal(self.language, 'English')
                self.secondPractice = ['Add instructions please']; % update few things if planning to use this
            else
                error('language parameter unknown')
            end

            % Third practice header
            if isequal(self.language, 'German')
                self.thirdPracticeHeader = 'Dritter Übungsdurchgang';
            elseif isequal(self.language, 'English')
                self.thirdPracticeHeader = 'Third Practice Run';
            else
                error('language parameter unknown')
            end

            % Third practice
            if isequal(self.language, 'German') %% slighlty altered for Helicopter Version
                self.thirdPractice = ['In dieser Übung sehen Sie nur noch den Abwurf des Helikopters. '...
                    'Bitte geben Sie wieder an, wo Sie das Ziel des Helikopter vermuten.\n\nBitte beachten Sie, dass das Ziel des Helikopters meistens gleich bleibt. Manchmal richtet sich der Helikopter allerding neu aus. '...
                    'Wenn Sie denken, dass die Konfetti-Kanone ihre Richtung geändert hat, sollten Sie auch das Netz '...
                    'dorthin bewegen.\n\nBeachten Sie, dass Sie die Medikamente trotz guter Vorhersagen auch häufig nicht fangen können.'];
            elseif isequal(self.language, 'English')
                self.thirdPractice = ['Add instructions please']; % update few things if planning to use this
            else
                error('language parameter unknown')
            end

            % Fourth practice header
            if isequal(self.language, 'German')
                self.fourthPracticeHeader = 'Vierter Übungsdurchgang';
            elseif isequal(self.language, 'English')
                self.fourthPracticeHeader = 'Fourth Practice Run';
            else
                error('language parameter unknown')
            end

            % Fourth practice
            if isequal(self.language, 'German') %% slighlty altered for Helicopter Version, because confidence Training follows 
                self.fourthPractice = ['Jetzt kommen wir zur nächsten Übung.\n\nDiesmal müssen Sie mit dem rosafarbenen Punkt Ihr Netz platzieren und sehen dabei den Helikopter nicht mehr. Außerdem werden Sie es sowohl mit einem relativ genauen '...
                    'als auch einem eher ungenauen versteckten Helikopter zu tun haben.\n\n'...
                    'Achten Sie bitte auf Augenbewegungen und Blinzeln wie von der Versuchsleitung erklärt.'...
                    '\n\nBeachten Sie bitte auch, dass das Ziel des Helikopters in manchen Fällen sichtbar sein wird. In diesen Fällen ist die beste Strategie, zum Ziel des Helikopters zu gehen.'];

            elseif isequal(self.language, 'English')
                self.fourthPractice = ['Add instructions please']; % update few things if planning to use this
            else
                error('language parameter unknown')
            end

           % First Screen Confidence Pratcice Header
            
            if isequal(self.language, 'German')
                self.ConfidencePracticeHeader = 'Letzter Übungsdurchgang';
            else
                error('language parameter unknown')
            end

            % First Screen Confidence Practice
            if isequal(self.language, 'German')
                self.ConfidencePractice = ['Jetzt kommen wir zur letzten Übung.\n\n'...
    'Im folgenden Übungsdurchgang werden Sie zusätzlich zu Ihrer Vorhersage, wo Sie das Ziel des Helikopters vermuten, angeben, wie sicher Sie sich sind, dass Ihre Vorhersage zutrifft und Sie die Medikamente mit dem Netz fangen.\n\n'...
    'Nachdem Sie – wie in den vorherigen Übungen – Ihre Vorhersage auf dem Kreis eingegeben haben, wird ein Schieberegler erscheinen. Dieser Schieberegler kann zwischen 1 (sehr unsicher) und 100 (sehr sicher) bewegt werden.\n\n'...
    'Nutzen Sie den Schieberegler, um anzugeben, wie sicher Sie sich sind, dass Ihre Vorhersage zutrifft und Sie die Medikamente in Ihrem Netz fangen.\n\n'...
    'Diese zusärtliche Abfrage wird nur in bestimmten Blöcken erfolgen und wird Ihnen vorher angesagt werden.'];

            
             end
            

 % Second Screen Confidence Pratcice Header
            
            if isequal(self.language, 'German')
                self.ConfidencePracticeHeaderTwo = 'Bedienung Schieberegler';
            else
                error('language parameter unknown')
            end

            % Second Screen Confidence Practice
            if isequal(self.language, 'German')
                self.ConfidencePracticeTwo = ['Legen Sie dazu bitte nun Ihre linke Hand auf die Tastatur, sodass Ihr Ringfinger auf der Taste A, Ihr Zeigefinger auf der Taste D und Ihr Daumen auf der Leertaste liegt.\n\n'...
                    'Drücken Sie "A" bewegt sich der Regler nach links (unsicher) und drücken Sie die Taste "D" bewegt sich der Regler nach rechts (sicher).'...
                    ' Abschließend bestätigen Ihre Eingabe mit der Leertaste.\n\n'...
                    'Im Folgenden absolvieren Sie einige Durchgänge, um sich mit dem Schieberegler vertraut zu machen.'];
             end

            
            % Start task header
            if isequal(self.language, 'German')
                self.startTaskHeader = 'Start des Experiments';
            elseif isequal(self.language, 'English')
                self.startTaskHeader = 'Beginning of the Experiment';
            else
                error('language parameter unknown')
            end

            % Start task
            if isequal(self.language, 'German')
                self.startTask = ['Sie haben die Übungsphase abgeschlossen. Kurz zusammengefasst fangen Sie also die meisten Medikamente, '...
                    'wenn Sie das Netz (rosafarbener Punkt) auf die Stelle bewegen, auf die der Helikopter zielt. Weil Sie den Helikopter meistens nicht mehr '...
                    'sehen können, müssen Sie diese Stelle aufgrund der Position des letzten Medikamenten-Abwurfs einschätzen. Beachten Sie, dass Sie die Medikamente trotz '...
                    'guter Vorhersagen auch häufig nicht fangen können. \n\nIn wenigen Fällen werden Sie den Helikopter zu sehen bekommen und können Ihre Leistung '...
                    'verbessern, indem Sie das Netz genau auf das Ziel steuern.\n\n'...
                    'Achten Sie bitte auf Augenbewegungen und Blinzeln wie von der Versuchsleitung erklärt.\n\n' ...
                    'In manchen Blöcken des Experiments werden Sie zudem gebeten eine Einschätzung abzugeben, wie sicher Sie sind, dass sie die Medikamente fangen werden.'...
                    'Es wird Ihnen vorher angezeigt werden, wenn dies der Fall ist.\n\n'...
                    'Viel Erfolg!'];
            elseif isequal(self.language, 'English')
                self.startTask = ['You have completed the practice phase. To summarize, you catch the most confetti, '...
                    'when you move the bucket (pink dot) to the aim of the confetti cannon. Because you can usually no longer see the cannon, '...
                    'you will have to estimate the aim based on the last confetti bursts. Please note that despite '...
                    'good predictions, you often wont be able to catch it. \n\nIn a few cases, you will see the confetti cannon and can improve your performance '...
                    'by moving the bucket to its aim.\n\n'...
                    'Please avoid eye movements and blinking during a trial. If the dot in the middle is light grey at the end of a trial, you may blink.\n\nGood luck!'];            else
                error('language parameter unknown')
            end

            % No catch header
            if isequal(self.language, 'German')
                self.noCatchHeader = 'Leider nicht gefangen!';
            elseif isequal(self.language, 'English')
                self.noCatchHeader = 'Unfortunately no catch!';
            else
                error('language parameter unknown')
            end

            % No catch
            if isequal(self.language, 'German')
                self.noCatch = 'Sie haben leider zu wenig Medikamente gefangen. Versuchen Sie es noch mal!';
            elseif isequal(self.language, 'English')
                self.noCatch = 'Unfortunately, you did not catch enough confetti. Try again!';
            else
                error('language parameter unknown')
            end

            % Accidental catch header
            if isequal(self.language, 'German')
                self.accidentalCatchHeader = 'Leider gefangen!';
            elseif isequal(self.language, 'English')
                self.accidentalCatchHeader = 'A catch, unfortunately!';
            else
                error('language parameter unknown')
            end

            % Accidental catch
            if isequal(self.language, 'German')
                self.accidentalCatch = 'Sie haben zu viele Medikamente gefangen. Versuchen Sie bitte, die Medikamente zu verfehlen!';
            elseif isequal(self.language, 'English')
                self.accidentalCatch = 'You have caught too much confetti. Please try to miss the confetti!';
            else
                error('language parameter unknown')
            end

            % Show cannon
            if isequal(self.language, 'German')
                self.showCannonText = 'Bitte geben Sie an, wo Sie den Helikopter vermuten.';
            elseif isequal(self.language, 'English')
                self.showCannonText = 'Please add instructions';
            else
                error('language parameter unknown')
            end

            % Additional show cannon text
            if isequal(self.language, 'German')
                self.addCannonText = ['\n\nDie grauen Striche zeigen die letzten Medikamenten-Abwürfe.\n'...
                    'Mit der Maus können Sie angeben, wo Sie den Helikopter vermuten.'];
            elseif isequal(self.language, 'English')
                self.addCannonText = 'Please add instructions';
            else
                error('language parameter unknown')
            end

            % Cannon feedback text
            if isequal(self.language, 'German')
                self.cannonFeedbackText = '\n\nHier können Sie Ihre Angabe und den echten Helikopter vergleichen.';
            elseif isequal(self.language, 'English')
                self.cannonFeedbackText = 'Please add instructions';
            else
                error('language parameter unknown')
            end

            % Practice block fail header
            if isequal(self.language, 'German')
                self.practiceBlockFailHeader = 'Bitte noch mal probieren!';
            elseif isequal(self.language, 'English')
                self.practiceBlockFailHeader = 'Please try again!';
            else
                error('language parameter unknown')
            end

            % Practice block fail
            if isequal(self.language, 'German')
                self.practiceBlockFail = ['Sie haben Ihr Netz oft neben dem Ziel des Helikopters platziert. Versuchen Sie im nächsten '...
                    'Durchgang bitte, das Netz direkt auf das Ziel zu steuern. Das Ziel wird durch die schwarzen Linie angezeigt.'];
            elseif isequal(self.language, 'English')
                self.practiceBlockFail = ['You have often placed your bucket next to the aim of the cannon. In the next '...
                    'phase, please try to aim the bucket directly at the target. The aim is indicated by the black line.'];
            else
                error('language parameter unknown')
            end

            % Practice block fail
            if isequal(self.language, 'German')
                self.cannonPracticeFail = ['Sie haben den Helikopter nicht genau genug eingeschätzt. Versuchen Sie im nächsten '...
                    'Durchgang bitte, den Mittelpunkt der einzelnen Schüsse auszuwählen. Bei Fragen, wenden Sie sich an die Versuchsleitung.'];
            elseif isequal(self.language, 'English')
                self.cannonPracticeFail = ['Please add instructions'];
            else
                error('language parameter unknown')
            end

            % First pupil baseline
            if isequal(self.language, 'German')
                self.firstPupilBaselineHeader = 'Erste Pupillenmessung';
                self.firstPupilBaseline = ['Sie werden jetzt für drei Minuten verschiedene Farben auf dem Bildschirm sehen. '...
                    'Bitte fixieren Sie Ihren Blick währenddessen auf den kleinen Punkt in der Mitte des Bildschirms.'];
            elseif isequal(self.language, 'English')
                self.firstPupilBaselineHeader = 'First Pupil Assessment';
                self.firstPupilBaseline = ['Include correct instructions here'];
            else
                error('language parameter unknown')
            end

            % Second pupil baseline
            if isequal(self.language, 'German')
                self.secondPupilBaselineHeader = 'Zweite Pupillenmessung';
                self.secondPupilBaseline = ['Sie werden jetzt noch mal für drei Minuten verschiedene Farben auf dem Bildschirm sehen. '...
                    'Bitte fixieren Sie Ihren Blick währenddessen auf den kleinen Punkt in der Mitte des Bildschirms.'];
            elseif isequal(self.language, 'English')
                self.secondPupilBaselineHeader = 'Second Pupil Assessment';
                self.secondPupilBaseline = ['Include correct instructions here'];
            else
                error('language parameter unknown')
            end

  
            % Indicate low noise
if isequal(self.language, 'German')
    self.introduceLowNoiseHeader = 'Genauer Helikopter - wenig Wind';
    
   
        self.introduceLowNoiseConfidence = ['Im folgenden Block wird der Helikopter relativ genau sein.\n\n'...
            'Die Größe des Netzes kann sich von Durchgang zu Durchgang ändern. '...
            'Diese Veränderung können Sie nicht beeinflussen und auch nicht vorhersagen. '...
            'Daher ist es immer die beste Strategie, das Netz genau dorthin zu stellen, '...
            'wo Sie das Ziel des Helikopters vermuten.\n\n'...
            'Zur Erinnerung: Der rosafarbene Strich zeigt Ihre letzte Vorhersage. '...
            'Der schwarze Strich zeigt die Position des letzten Helikopter-Abwurfs.\n\n'...
            'Achten Sie bitte auf Augenbewegungen und Blinzeln wie von der Versuchsleitung erklärt.\n\n'...
            'Zusätzlich geben Sie bitte an, wie sicher Sie sind, dass Sie die Medikamente fangen werden. Bewegen Sie dazu den Schieberegler nach jeder Vorhersage auf eine Zahl zwischen 1 (sehr unsicher) und 100 (sehr sicher).\n\n'...
                    'Um den Schieberegler zu bewegen, verwenden Sie bitte die Tasten a und d und anschließend die Leertaste, um Ihre Antwort einzugeben.'];
    
        self.introduceLowNoise = ['Im folgenden Block wird der Helikopter relativ genau sein.\n\n'...
            'Die Größe des Netzes kann sich von Durchgang zu Durchgang ändern. '...
            'Diese Veränderung können Sie nicht beeinflussen und auch nicht vorhersagen. '...
            'Daher ist es immer die beste Strategie, das Netz genau dorthin zu stellen, '...
            'wo Sie das Ziel des Helikopters vermuten.\n\n'...
            'Zur Erinnerung: Der rosafarbene Strich zeigt Ihre letzte Vorhersage. '...
            'Der schwarze Strich zeigt die Position des letzten Helikopter-Abwurfs.\n\n'...
            'Achten Sie bitte auf Augenbewegungen und Blinzeln wie von der Versuchsleitung erklärt.'];
    

        elseif isequal(self.language, 'English')
    self.introduceLowNoiseHeader = 'More accurate helicopter - little wind';

   
        self.introduceLowNoise = ['In the following block, the helicopter will be relatively accurate.\n\n'...
            'In addition to making your prediction, you will also rate your confidence in your decision.\n\n'...
            'You will use a scale to indicate how certain you feel. A higher number means you are very confident, '...
            'while a lower number means you are more uncertain.\n\n'...
            'This helps us understand how you make decisions.'];
    
        self.introduceLowNoise = ['In the following block, the helicopter will be relatively accurate.\n\n'...
            'The size of the net can change from trial to trial. '...
            'You cannot influence this change nor can you predict it. '...
            'Therefore, the best strategy is always to place the net exactly where you think '...
            'the helicopter’s drop zone will be.\n\n'...
            'The pink line shows your last prediction. The black line shows the position of the last helicopter drop.'];
    
else
    error('language parameter unknown')
end


% Indicate high noise
if isequal(self.language, 'German')
    self.introduceHighNoiseHeader = 'Ungenauerer Helikopter - viel Wind';
    

        self.introduceHighNoiseConfidence = ['Im folgenden Block wird der Helikopter relativ ungenau sein.\n\n'...
            'Die Größe des Netzes kann sich von Durchgang zu Durchgang ändern. '...
            'Diese Veränderung können Sie nicht beeinflussen und auch nicht vorhersagen. '...
            'Daher ist es immer die beste Strategie, das Netz genau dorthin zu stellen, '...
            'wo Sie das Ziel des Helikopters vermuten.\n\n'...
            'Zur Erinnerung: Der rosafarbene Strich zeigt Ihre letzte Vorhersage. '...
            'Der schwarze Strich zeigt die Position des letzten Helikopter-Abwurfs.\n\n'...
            'Achten Sie bitte auf Augenbewegungen und Blinzeln wie von der Versuchsleitung erklärt.\n\n'...
            'Zusätzlich geben Sie bitte an, wie sicher Sie sind, dass Sie die Medikamente fangen werden. Bewegen Sie dazu den Schieberegler nach jeder Vorhersage auf eine Zahl zwischen 1 (sehr unsicher) und 100 (sehr sicher).\n\n'...
                    'Um den Schieberegler zu bewegen, verwenden Sie bitte die Tasten a und d und anschließend die Leertaste, um Ihre Antwort einzugeben.'];
    
        self.introduceHighNoise = ['Im folgenden Block wird der Helikopter relativ ungenau sein.\n\n'...
            'Die Größe des Netzes kann sich von Durchgang zu Durchgang ändern. '...
            'Diese Veränderung können Sie nicht beeinflussen und auch nicht vorhersagen. '...
            'Daher ist es immer die beste Strategie, das Netz genau dorthin zu stellen, '...
            'wo Sie das Ziel des Helikopters vermuten.\n\n'...
            'Zur Erinnerung: Der rosafarbene Strich zeigt Ihre letzte Vorhersage. '...
            'Der schwarze Strich zeigt die Position des letzten Helikopter-Abwurfs.'];
    

elseif isequal(self.language, 'English')
    self.introduceHighNoiseHeader = 'Less accurate helicopter - strong wind';
    
   
        self.introduceHighNoise = ['In the following block, the helicopter will be relatively inaccurate.\n\n'...
            'In addition to making your prediction, you will also rate your confidence in your decision.\n\n'...
            'You will use a scale to indicate how certain you feel. A higher number means you are very confident, '...
            'while a lower number means you are more uncertain.\n\n'...
            'This helps us understand how you make decisions.'];
    
        self.introduceHighNoise = ['In the following block, the helicopter will be relatively inaccurate.\n\n'...
            'The size of the net can change from trial to trial. '...
            'You cannot influence this change nor can you predict it. '...
            'Therefore, the best strategy is always to place the net exactly where you think '...
            'the helicopter’s drop zone will be.'];
    
else
    error('language parameter unknown')
end



            self.introducePassiveViewingHeader = 'Beobachtungsaufgabe';
            self.introducePassiveViewing = ['Versuchen Sie in dieser Aufgabe bitte in die Mitte '...
                'des Bildschirms zu fixieren. Es ist wichtig, dass Sie Ihre Augen nicht bewegen!\n\n'...
                'Versuchen Sie nur zu blinzeln, wenn der weiße Punkt erscheint.'];

        end


        function self = giveFeedback(self, currPoints, type)
            %GIVEFEEDBACK This function displays feedback after a block or
            %the task
            %
            %   Input
            %       self: Instructions-text-object instance
            %       currPoints: Number of points
            %       type: Single-block vs. whole task feedback
            %
            %   Output
            %       self: Instructions-text-object instance


            if isequal(type, 'block') 
    if isequal(self.language, 'German')
        self.dynamicFeedbackTxt = sprintf(['Sie haben %.0f Einheiten lebensrettender Medikamente gesichert.\n\n' ...
        'Nur wenn Sie genügend Medikamente sichern, können die Kranken geheilt werden.\n\n Jede Ihrer Entscheidungen zählt!'], currPoints);
    
    elseif isequal(self.language, 'English')
        self.dynamicFeedbackTxt = sprintf(['You caught %.0f life-saving medicine units.\n\n' ...
            'Many sick people have been helped!'], currPoints);
    else
        error('Language parameter unknown');
    end


            elseif isequal(type, 'task')
                if isequal(self.language, 'German')
                    self.dynamicFeedbackHeader = 'Ende des Versuchs!';
                    self.dynamicFeedbackTxt = sprintf('Vielen Dank für Ihre Teilnahme!\n\n\nSie haben insgesamt %i Einheiten lebensrettender Medikamente gesichert!', currPoints);
                elseif isequal(self.language, 'English')
                    self.dynamicFeedbackHeader = 'End of the Experiment!';
                    self.dynamicFeedbackTxt = sprintf('Thank you for taking part!\n\n\nYou have won a total of %i points!', currPoints);
                else
                    error('language parameter unknown')
                end
            else
                error('type parameter unknown')
            end
        end


        function self = giveBlockFeedback(self, nBlocks, currBlock)
            %GIVEBLOCKFEEDBACK This function displays how many blocks have
            %been completed so far
            %
            %   Input
            %       self: Instructions-text-object instance
            %       nBlocks: Number of blocks
            %       currBlock: Indicates if we are in passive-viewing condition
            %   Output
            %       self: Instructions-text-object instance


            self.dynamicBlockTxt = sprintf('Kurze Pause!\n\nSie haben bereits %i von insgesamt %i Durchgängen geschafft.', currBlock, nBlocks);

        end

    end
end