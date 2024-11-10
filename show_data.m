% MATLAB Skript zum Laden der Daten und Anzeigen der ersten X Zeilen
clear; clc;

% Pfad zur .mat Datei
filePath = 'C:\Users\moritz\Documents\GitHub\VFB_Fluegelversuch\data\VFB-W24-D-60%.mat';

% Laden der Daten aus der .mat Datei
load(filePath, 'Data', 'Head');

% Überprüfen, ob die Variablen existieren
if exist('Data', 'var')
    X = 10; % Anzahl der Zeilen, die angezeigt werden sollen (z.B. 10)

    % Anzeige der ersten X Zeilen von Data
    disp(['Ersten ', num2str(X), ' Zeilen von Data:']);
    disp(Data(1:X, :));

    % Falls 'Head' existiert, als Tabellenkopf verwenden
    if exist('Head', 'var') && isstring(Head)
        % Erstelle eine Tabelle aus den Daten und der Kopfzeile
        DataTable = array2table(Data, 'VariableNames', cellstr(Head));

        % Zeige die ersten X Zeilen der Tabelle an
        disp(['Ersten ', num2str(X), ' Zeilen von DataTable:']);
        disp(DataTable(1:X, :));
    end
else
    disp('Die Variable "Data" wurde nicht in der Datei gefunden.');
end
