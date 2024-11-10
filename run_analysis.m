% run_analysis.m
function run_analysis()
    % Skript zum Ausführen des gesamten Analyseprozesses
    % Definiere Eingabedateien und zugehörige Ausgabedateien
    inputFiles = {'VFB-W24-D-23%.mat', 'VFB-W24-D-60%.mat'};
    correctedFiles = {'VFB-W24-D-23%-corrected.mat', 'VFB-W24-D-60%-corrected.mat'};
    filteredFiles = {'VFB-W24-D-23%-filtered.mat', 'VFB-W24-D-60%-filtered.mat'};
    regressionFiles = {'VFB-W24-D-23%-regression.mat', 'VFB-W24-D-60%-regression.mat'};

    % Transformiere Rohdaten (Höhen- und Winkelkorrektur)
    transform_data(inputFiles, correctedFiles);

    % Filtere relevante Zeilenbereiche der Messdaten
    filter_data(correctedFiles, filteredFiles);

    % Führe lineare Regression durch und berechne Biegelinie
    fit_biegelinie(filteredFiles);
end
