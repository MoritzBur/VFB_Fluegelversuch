% transform_data.m
function transform_data(inputFiles, outputFiles)
    % Erwartet inputFiles und outputFiles als Zell-Arrays mit Dateipfaden
    
    % Prüfen, ob Anzahl der Eingabe- und Ausgabedateien übereinstimmt
    if length(inputFiles) ~= length(outputFiles)
        error('Die Anzahl der Eingabedateien muss der Anzahl der Ausgabedateien entsprechen.');
    end
    
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
        % Subtrahiere die Verschiebung M0 von allen relevanten Messkanälen (V0-V9 und H0-H9)
        correctedData = Data;
        correctedData(:, [vIndices, hIndices]) = correctedData(:, [vIndices, hIndices]) - m0;

        % Schritt 2: Winkelkorrektur durch Anwendung des Strahlensatzes
        % Bestimmung des Höhenunterschieds zwischen MW900 und M0
        heightDifference = mw900 - m0;
        leverArm = 900; % Hebelarm in mm

        % Winkelberechnung (kleine Winkel angenommen, daher tan(theta) ~ theta)
        theta = heightDifference / leverArm; % in rad, Annahme: kleine Winkel

        % Korrektur der Verschiebungen entsprechend ihres Abstands zur Drehachse
        for i = 1:length(vIndices)
            distanceFromAxis = 100 * (i - 1); % Annahme: Messstellen sind in 100-mm-Schritten entlang der Vorderkante verteilt
            correction = distanceFromAxis * theta;
            correctedData(:, vIndices(i)) = correctedData(:, vIndices(i)) - correction;
        end

        for i = 1:length(hIndices)
            distanceFromAxis = 100 * (i - 1); % Annahme: Messstellen sind in 100-mm-Schritten entlang der Hinterkante verteilt
            correction = distanceFromAxis * theta;
            correctedData(:, hIndices(i)) = correctedData(:, hIndices(i)) - correction;
        end

        % Nur den Dateinamen und die Erweiterung für den Plot-Titel anzeigen
        [~, fileName, ext] = fileparts(inputFile);
        
        % Plot der korrigierten Daten für eine visuelle Überprüfung
        figure;
        subplot(2, 1, 1);
        plot(Data(:, [vIndices, hIndices]));
        title(['Rohdaten der Verschiebungen - Datei: ', fileName, ext]);
        xlabel('Zeitindex');
        ylabel('Verformung (mm)');

        subplot(2, 1, 2);
        plot(correctedData(:, [vIndices, hIndices]));
        title(['Korrigierte Verschiebungen - Datei: ', fileName, ext]);
        xlabel('Zeitindex');
        ylabel('Verformung (mm)');

        % Speichern der transformierten Daten
        save(outputFile, 'correctedData', 'Head');
    end
end
