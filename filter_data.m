% filter_data.m
function filter_data(inputFiles, outputFiles)
    % Erwartet inputFiles und outputFiles als Zell-Arrays mit Dateipfaden
    
    % Prüfen, ob Anzahl der Eingabe- und Ausgabedateien übereinstimmt
    if length(inputFiles) ~= length(outputFiles)
        error('Die Anzahl der Eingabedateien muss der Anzahl der Ausgabedateien entsprechen.');
    end

    % Definierte Zeilenintervalle (nicht interaktiv)
    intervals = {
        [757:1425, 1426:2039],  % Intervalle für die erste Datei
        [540:1030, 1031:1503]   % Intervalle für die zweite Datei
    };

    % Schleife über alle angegebenen Dateien
    for fileIdx = 1:length(inputFiles)
        inputFile = inputFiles{fileIdx};
        outputFile = outputFiles{fileIdx};

        % Laden der korrigierten Daten
        load(inputFile, 'correctedDataAngle', 'Head');

        % Kombinieren der definierten Zeilenintervalle
        selectedRows = intervals{fileIdx};

        % Filtere die Daten
        filteredData = correctedDataAngle(selectedRows, :);

        % Speichern der gefilterten Daten
        save(outputFile, 'filteredData', 'Head');
    end
end
