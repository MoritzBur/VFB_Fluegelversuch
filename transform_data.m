% transform_data.m
function transform_data(inputFiles, outputFiles)
    % Erwartet inputFiles und outputFiles als Zell-Arrays mit Dateipfaden
    
    % Prüfen, ob Anzahl der Eingabe- und Ausgabedateien übereinstimmt
    if length(inputFiles) ~= length(outputFiles)
        error('Die Anzahl der Eingabedateien muss der Anzahl der Ausgabedateien entsprechen.');
    end
    
    % Laden der Sensor-Koordinaten für Vorder- und Hinterkante
    load('V_sensors.mat', 'V_sensors');
    load('H_sensors.mat', 'H_sensors');
    
    % Extrahieren der x-Koordinaten für die Vorder- und Hinterkante
    V_x = cell2mat(V_sensors(:, 2));
    H_x = cell2mat(H_sensors(:, 2));
    
    % Schleife über alle angegebenen Dateien
    for fileIdx = 1:length(inputFiles)
        inputFile = inputFiles{fileIdx};
        outputFile = outputFiles{fileIdx};

        % Laden der Rohdaten
        load(inputFile, 'Data', 'Head'); % Data: Matrix der Messwerte, Head: Spaltennamen

        % Zeige die geladenen Variablen zur Fehlersuche an
        disp(['Variablen in der Datei ', inputFile, ':']);
        whos('-file', inputFile);

        % Index für die Spalten, die Verschiebungen repräsentieren
        vIndices = find(contains(Head, 'V')); % Indizes der Verschiebungen an der Vorderkante
        hIndices = find(contains(Head, 'H')); % Indizes der Verschiebungen an der Hinterkante

        % MW900 und M0 bestimmen (suchen nach Namensteilen)
        mw900Index = find(contains(Head, 'MW900'));
        m0Index = find(contains(Head, 'M0'));

        % Überprüfen, ob die nötigen Messpunkte existieren
        if isempty(mw900Index)
            error(['Der notwendige Messpunkt MW900 fehlt in den Daten der Datei: ', inputFile]);
        end
        if isempty(m0Index)
            error(['Der notwendige Messpunkt M0 fehlt in den Daten der Datei: ', inputFile]);
        end

        % Rohdaten in die Variablen laden
        mw900 = Data(:, mw900Index); % Verschiebung an der Drehachse
        m0 = Data(:, m0Index);        % Verschiebungspunkt M0

        % Schritt 1: Korrektur der Verschiebungen um M0
        correctedDataHeight = Data;
        correctedDataHeight(:, [vIndices, hIndices]) = correctedDataHeight(:, [vIndices, hIndices]) + m0;

        % Schritt 2: Winkelkorrektur durch Anwendung des Strahlensatzes
        heightDifference = mw900 - m0;
        leverArm = 900; % Hebelarm in mm

        % Winkelberechnung (kleine Winkel angenommen, daher tan(theta) ~ theta)
        theta = heightDifference / leverArm; % in rad, Annahme: kleine Winkel

        % Korrigierte Daten nach Winkelkorrektur
        correctedDataAngle = correctedDataHeight;
        % Vorderkante
        for i = 1:length(vIndices)
            distanceFromAxis = V_x(i); % Tatsächliche x-Koordinate der Messstelle an der Vorderkante
            correction = distanceFromAxis * theta;
            correctedDataAngle(:, vIndices(i)) = correctedDataAngle(:, vIndices(i)) + correction;
        end

        % Hinterkante
        for i = 1:length(hIndices)
            distanceFromAxis = H_x(i); % Tatsächliche x-Koordinate der Messstelle an der Hinterkante
            correction = distanceFromAxis * theta;
            correctedDataAngle(:, hIndices(i)) = correctedDataAngle(:, hIndices(i)) + correction;
        end

        % Nur den Dateinamen und die Erweiterung für den Plot-Titel anzeigen
        [~, fileName, ext] = fileparts(inputFile);

        % Plot der Rohdaten und schrittweisen Korrekturen
        figure;
        % Plot der Rohdaten für die Vorderkante
        subplot(3, 2, 1);
        plot(Data(:, vIndices));
        title(['Vorderkante - Rohdaten - Datei: ', fileName, ext]);
        xlabel('Zeitindex');
        ylabel('Verformung (mm)');

        % Plot der Rohdaten für die Hinterkante
        subplot(3, 2, 2);
        plot(Data(:, hIndices));
        title(['Hinterkante - Rohdaten - Datei: ', fileName, ext]);
        xlabel('Zeitindex');
        ylabel('Verformung (mm)');

        % Plot der höhenkorrigierten Daten für die Vorderkante
        subplot(3, 2, 3);
        plot(correctedDataHeight(:, vIndices));
        title(['Vorderkante - Höhenkorrigiert - Datei: ', fileName, ext]);
        xlabel('Zeitindex');
        ylabel('Verformung (mm)');

        % Plot der höhenkorrigierten Daten für die Hinterkante
        subplot(3, 2, 4);
        plot(correctedDataHeight(:, hIndices));
        title(['Hinterkante - Höhenkorrigiert - Datei: ', fileName, ext]);
        xlabel('Zeitindex');
        ylabel('Verformung (mm)');

        % Plot der winkelkorrigierten Daten für die Vorderkante
        subplot(3, 2, 5);
        plot(correctedDataAngle(:, vIndices));
        title(['Vorderkante - Winkelkorrigiert - Datei: ', fileName, ext]);
        xlabel('Zeitindex');
        ylabel('Verformung (mm)');

        % Plot der winkelkorrigierten Daten für die Hinterkante
        subplot(3, 2, 6);
        plot(correctedDataAngle(:, hIndices));
        title(['Hinterkante - Winkelkorrigiert - Datei: ', fileName, ext]);
        xlabel('Zeitindex');
        ylabel('Verformung (mm)');

        % Interaktiver Plot der Biegelinie entlang der Spannweite
        figure('Name', ['Biegelinie - Datei: ', fileName, ext]);
        set(gcf, 'Position', [100, 100, 800, 600]); % Fenstergröße festlegen
        bendPlot = subplot(1, 1, 1);
        timeStepSlider = uicontrol('Style', 'slider', 'Position', [100, 20, 600, 20], 'Min', 1, 'Max', size(Data, 1), 'Value', 1, 'SliderStep', [1/(size(Data, 1)-1), 10/(size(Data, 1)-1)]);
        addlistener(timeStepSlider, 'Value', 'PostSet', @(src, event) updateBendPlot(bendPlot, round(timeStepSlider.Value), V_x, H_x, correctedDataAngle, vIndices, hIndices, fileName, ext));
        % Initialer Plot der Biegelinie
        updateBendPlot(bendPlot, 1, V_x, H_x, correctedDataAngle, vIndices, hIndices, fileName, ext);

        % Speichern der transformierten Daten
        save(outputFile, 'correctedDataAngle', 'Head');
    end

    % Funktion zur Aktualisierung des Biegelinienplots basierend auf dem Zeitschritt
    function updateBendPlot(bendPlot, timeStep, V_x, H_x, correctedDataAngle, vIndices, hIndices, fileName, ext)
        axes(bendPlot); % Aktuelle Achse setzen
        cla; % Achse leeren
        hold on;
        plot(V_x, correctedDataAngle(timeStep, vIndices), '-o', 'Color', 'b', 'DisplayName', 'Vorderkante');
        plot(H_x, correctedDataAngle(timeStep, hIndices), '-s', 'Color', 'r', 'DisplayName', 'Hinterkante');
        title(['Biegelinie entlang der Spannweite - Datei: ', fileName, ext, ' - Zeitschritt ', num2str(timeStep)]);
        xlabel('Position entlang der Spannweite (mm)');
        ylabel('Verformung (mm)');
        legend;
        grid on;
        hold off;
    end

    % Speichern der transformierten Daten
    save(outputFiles{fileIdx}, 'correctedDataAngle', 'Head');
end
