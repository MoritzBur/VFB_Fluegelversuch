% fit_biegelinie.m
function fit_biegelinie(inputFiles, outputFiles)
    % Erwartet inputFiles als Zell-Array mit Dateipfaden und outputFiles für Speicherung der Fit-Daten
    
    % Standardmäßig outputFiles auf leere Zellen setzen, falls nicht angegeben
    if nargin < 2
        outputFiles = strcat(inputFiles, '-fit.mat'); % Generiert Standardnamen, falls nicht explizit übergeben
    end
    
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
    
    for fileIdx = 1:length(inputFiles)
        inputFile = inputFiles{fileIdx};
        outputFile = outputFiles{fileIdx};

        % Laden der gefilterten Daten
        load(inputFile, 'filteredData', 'Head');

        % Indizes der relevanten Spalten bestimmen
        vIndices = find(contains(Head, 'V')); % Verschiebungen an der Vorderkante
        hIndices = find(contains(Head, 'H')); % Verschiebungen an der Hinterkante
        fIndex = find(contains(Head, 'F_ges')); % Spalte mit der gesamten Kraft

        % Lineare Regression für Verschiebung über Kraft (Vorderkante und Hinterkante)
        vFits = cell(1, length(vIndices));
        hFits = cell(1, length(hIndices));
        for i = 1:length(vIndices)
            vFits{i} = polyfit(filteredData(:, fIndex), filteredData(:, vIndices(i)), 1);
        end
        for i = 1:length(hIndices)
            hFits{i} = polyfit(filteredData(:, fIndex), filteredData(:, hIndices(i)), 1);
        end

        % Plot der linearen Regression für Verschiebung über Kraft
        figure;
        subplot(2, 1, 1);
        hold on;
        for i = 1:length(vIndices)
            plot(filteredData(:, fIndex), filteredData(:, vIndices(i)), '.', 'DisplayName', ['V', num2str(i)]);
            fplot(@(x) polyval(vFits{i}, x), [min(filteredData(:, fIndex)), max(filteredData(:, fIndex))], 'DisplayName', ['Fit V', num2str(i)]);
        end
        title(['Lineare Regression - Vorderkante - Datei: ', inputFile]);
        xlabel('Kraft (N)');
        ylabel('Verformung (mm)');
        legend;
        grid on;

        subplot(2, 1, 2);
        hold on;
        for i = 1:length(hIndices)
            plot(filteredData(:, fIndex), filteredData(:, hIndices(i)), '.', 'DisplayName', ['H', num2str(i)]);
            fplot(@(x) polyval(hFits{i}, x), [min(filteredData(:, fIndex)), max(filteredData(:, fIndex))], 'DisplayName', ['Fit H', num2str(i)]);
        end
        title(['Lineare Regression - Hinterkante - Datei: ', inputFile]);
        xlabel('Kraft (N)');
        ylabel('Verformung (mm)');
        legend;
        grid on;

        % Fit der Biegelinie mit Polynom 3. Grades für VK und HK
        vCoeffs = cellfun(@(fit) fit(1), vFits); % Steigungen der linearen Fits
        hCoeffs = cellfun(@(fit) fit(1), hFits); % Steigungen der linearen Fits
        polyV = polyfit(V_x, vCoeffs, 3);
        polyH = polyfit(H_x, hCoeffs, 3);

        % Plot der Ergebnisse
        figure;
        subplot(2, 1, 1);
        plot(V_x, vCoeffs, 'o', 'DisplayName', 'Vorderkante Daten');
        hold on;
        fplot(@(x) polyval(polyV, x), [min(V_x), max(V_x)], 'DisplayName', 'Vorderkante Fit');
        title(['Polynom 3. Grades für Vorderkante - Datei: ', inputFile]);
        xlabel('Position entlang der Spannweite (mm)');
        ylabel('Linearkoeffizient');
        legend;
        grid on;

        subplot(2, 1, 2);
        plot(H_x, hCoeffs, 'o', 'DisplayName', 'Hinterkante Daten');
        hold on;
        fplot(@(x) polyval(polyH, x), [min(H_x), max(H_x)], 'DisplayName', 'Hinterkante Fit');
        title(['Polynom 3. Grades für Hinterkante - Datei: ', inputFile]);
        xlabel('Position entlang der Spannweite (mm)');
        ylabel('Linearkoeffizient');
        legend;
        grid on;

        % Speichern der Fit-Daten
        save(outputFile, 'vFits', 'hFits', 'vCoeffs', 'hCoeffs', 'polyV', 'polyH', 'V_x', 'H_x');
    end
end
