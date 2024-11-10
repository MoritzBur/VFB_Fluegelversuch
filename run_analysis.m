% run_analysis.m
clear; clc;

% Definieren der Pfade zu den Rohdaten-Dateien
inputFiles = {
    'C:\Users\moritz\Documents\GitHub\VFB_Fluegelversuch\data\VFB-W24-D-23%.mat',
    'C:\Users\moritz\Documents\GitHub\VFB_Fluegelversuch\data\VFB-W24-D-60%.mat'
};

% Definieren der Pfade für die Ausgabedateien
outputFiles = {
    'C:\Users\moritz\Documents\GitHub\VFB_Fluegelversuch\data\deformation_23.mat',
    'C:\Users\moritz\Documents\GitHub\VFB_Fluegelversuch\data\deformation_60.mat'
};

% Transformiere die Daten (Rotation und Korrekturen)
transform_data(inputFiles, outputFiles);

% Weitere Schritte könnten hier eingebunden werden, wie zum Beispiel:
% - clean_data(outputFiles);
% - calc_cot(...);

% Hinweis:
% Jedes Skript sollte modular aufgebaut sein, um eine einfache Anpassung und Erweiterung zu ermöglichen.