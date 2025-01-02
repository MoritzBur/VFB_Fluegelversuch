%% Daten auslesen und in eigene Matrixen packen
% Annahme: 'Data' ist ein Array der Größe 1849x29 im Workspace vorhanden.
load ("VFB-W24-D-SMP2-filtered.mat");
% Zeit (Spalte 1) extrahieren
time = filteredData(:, 1); % 1849x1-Matrix

% Gesamtkraft Fges (Spalte 2) extrahieren
Fges = filteredData(:, 2); % 1849x1-Matrix

% Messwerte V0-V9 (Spalten 9 bis 18) extrahieren
measurements_v = filteredData(:, 9:18); % 1849x10-Matrix

% Messwerte H0-H9 (Spalten 20 bis 29) extrahieren
measurements_h = filteredData(:, 20:29); % 1849x10-Matrix

% Plot erstellen
figure('Name', 'Messwerte V und H in Abhängigkeit von der Zeit', 'NumberTitle', 'off');
hold on;

% Plotten der Messwerte V0-V9
for i = 1:size(measurements_v, 2)
    plot(time, measurements_v(:, i), 'DisplayName', sprintf('V%d', i-1)); % Dynamische Legende
end

% Plotten der Messwerte H0-H9
for i = 1:size(measurements_h, 2)
    plot(time, measurements_h(:, i), '--', 'DisplayName', sprintf('H%d', i-1)); % Dynamische Legende, gestrichelte Linie
end
ylabel('Biegung in mm');

yyaxis right; % Rechte y-Achse für die Gesamtkraft Fges
plot(time, Fges, 'k-', 'LineWidth', 1.5, 'DisplayName', 'Fges'); % Gesamtkraft in Schwarz
ylabel('Gesamtkraft F_{ges} [N]');

% Achsenbeschriftungen und Titel
title('Messwerte Vorderkante und Hinterkante beim errechneten SMP');
xlabel('Zeit [s]');
legend('show'); % Legende anzeigen
hold off;

%% Regression aufteilen an einem beliebigen X Punkt und nicht nur an den Messpunkten
%Bereich finden, in dem Fges etwa 4558 N beträgt (Toleranz: ±100 N)
tolerance = 100; % Toleranz in N
indices = find(abs(Fges - 4558) <= tolerance);

% Mittlerer Zeitpunkt bei Fges ~ 4558 N für stabileren Wert
index = round(mean(indices)); 

% Koordinaten der Messpunkte (in mm)
x_coords = [0, 646, 1135, 1727, 2205, 2678, 3276, 3847, 4322, 4795]; % Für H1/V1 bis H9/V9

% Biegungswerte bei Fges ~ 4558 N
V_bending = measurements_v(index, 1:end); % V1-V9
H_bending = measurements_h(index, 1:end); % H1-H9

%Mittelwert von V- und H-Biegungen berechnen
y_bending = (V_bending + H_bending) / 2; 

% Trennstelle an Lastscheere D
split_x = 2780;

% Interpolierte y-Werte an der Trennstelle berechnen
split_y = interp1(x_coords, y_bending, split_x, 'linear');

% Linke Seite der Daten (x < split_x)
x_left = [x_coords(x_coords < split_x), split_x];
y_left = [y_bending(x_coords < split_x), split_y];

% Rechte Seite der Daten (x >= split_x)
x_right = [split_x, x_coords(x_coords >= split_x)];
y_right = [split_y, y_bending(x_coords >= split_x)];

% Lineare Regression für linke Seite
coeffs_left = polyfit(x_left, y_left, 3); 
fit_left = polyval(coeffs_left, x_left); % Angepasste Werte berechnen

% Lineare Regression für rechte Seite
coeffs_right = polyfit(x_right, y_right, 3); 
fit_right = polyval(coeffs_right, x_right); % Angepasste Werte berechnen

% Plot erstellen
figure('Name', 'Biegung der Messpunkte mit, getrennt an Lastscheere D', 'NumberTitle', 'off');
hold on;

% V-Werte plotten
plot(x_coords, V_bending, 'o-', 'DisplayName', 'V-Messpunkte', 'LineWidth', 1.5);

% H-Werte plotten
plot(x_coords, H_bending, 'o--', 'DisplayName', 'H-Messpunkte', 'LineWidth', 1.5);

% Linke Regressionslinie plotten
plot(x_left, fit_left, '-g', 'DisplayName', 'Regression links', 'LineWidth', 1.5);

% Rechte Regressionslinie plotten
plot(x_right, fit_right, '-r', 'DisplayName', 'Regression rechts', 'LineWidth', 1.5);

% Vertikale Linie an der Trennstelle zeichnen
ylimits = ylim; % Aktuelle y-Grenzen abrufen
line([split_x, split_x], ylimits, 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1.5, 'DisplayName', 'Lastscheere D');


% Achsentitel, allgemeiner Titel und Legende
title('Biegung der Messpunkte bei Fges \approx 4558 N');
xlabel('Position entlang des Balkens [mm]');
ylabel('Biegung [mm]');
legend('show');
grid on;
hold off;


%% Biegemomentenverlauf
% Kräfte und Positionen der Lastscheeren (in mm und N)
forces = [0, 1199.1, 1349.7, 1124.9, 778.4, 105.5]; % Kräfte in N bei 4558 N
positions = [0, 700, 1670, 2780, 3860, 4690]; % Positionen in mm

% Anzahl der Abschnitte
n_sections = length(forces);

% Biegemoment für jeden Abschnitt berechnen
x_values = cell(n_sections, 1); % Abschnitte der x-Werte
M_values = cell(n_sections, 1); % Biegemomentenwerte

for i = 1:n_sections
    if i == n_sections
        % Letzter Abschnitt bis zum Ende des Balkens
        x_range = linspace(positions(i), max(positions) + 100, 100);
    else
        % Abschnitt zwischen zwei benachbarten Lastscheeren
        x_range = linspace(positions(i), positions(i+1), 100);
    end
    x_values{i} = x_range; % Speichern der x-Werte
    
    % Biegemoment berechnen
    M = zeros(size(x_range));
    for j = 1:length(forces)
        % Kraefte rechts vom Punkt in betracht beziehen
        M = M - forces(j) * max(0, (positions(j) - x_range));
    end
    M_values{i} = M; % Speichern der Momente
end


% Plot erstellen
figure('Name', 'Biegemomentenverlauf in Abschnitten', 'NumberTitle', 'off');
hold on;

% Abschnitte plotten
colors = lines(n_sections); % Farben für die Abschnitte
for i = 1:n_sections
    plot(x_values{i}, M_values{i}, 'Color', colors(i, :), 'LineWidth', 1.5, ...
         'DisplayName', sprintf('Abschnitt %d', i));
end

% Manuelle Benennung der Lastscheeren (ohne C)
lastscheeren = {'0','A', 'B', 'D', 'E', 'F'};

% Vertikale Linien für Lastscheeren A bis F zeichnen
for i = 1:length(positions)
    line([positions(i), positions(i)], ylim, 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1.5, 'DisplayName', sprintf('Lastscheere %s', lastscheeren{i}));
end

% Zusätzliche Plot-Details
xlabel('Position entlang des Balkens [mm]');
ylabel('Biegemoment [Nmm]');
title('Biegemomentenverlauf in Abschnitten');
legend('show');
grid on;
hold off;

%% EI fuer jeden Abschnitt  berechnen
EI = cell(n_sections, 1);
% EI berechnen nach EI = My/w``. Dafuer annehmen, dass die Linke seite
% eingespannt ist
%erste Ableitung durchführen
W1rechts = polyder(coeffs_left);

W1links = polyder(coeffs_right);

%zweite Ableitung durchführen
W2rechts = polyder(W1rechts);

W2links = polyder(W1links);

%Werte für Lastscheeren berechnen
% %Lastscheere 0
% EI{1} = polyval(M_values{1}, 1) / (polyval(W2links, positions(2)) - polyval(W2links, positions(1)));
% %Lastscheere A
% EI{2} = polyval(M_values{2}, 1) / (polyval(W2links, positions(3)) - polyval(W2rechts, positions(2)));
% %Lastscheere B
% EI{3} = polyval(M_values{3}, 1) / (polyval(W2rechts, positions(4)) - polyval(W2rechts, positions(3)));
% %Lastscheere D
% EI{4} = polyval(M_values{4}, 1) / (polyval(W2rechts, positions(5)) - polyval(W2rechts, positions(4)));
% %lastscheere E
% EI{5} = polyval(M_values{5}, 1) / (polyval(W2rechts, positions(6)) - polyval(W2rechts, positions(5)));
% %Lastscheere F
% EI{6} = polyval(M_values{6}, 1) / (polyval(W2rechts, 4790) - polyval(W2rechts, positions(6)));


% Neue Berechnung, obrige ggf Falsch
%Lastscheere 0
EI{1} = polyval(M_values{1}, 1) / (polyval(W2links, positions(2)));
%Lastscheere A
EI{2} = polyval(M_values{2}, 1) / (polyval(W2links, positions(3)));
%Lastscheere B
EI{3} = polyval(M_values{3}, 1) / (polyval(W2rechts, positions(4)));
%Lastscheere D
EI{4} = polyval(M_values{4}, 1) / (polyval(W2rechts, positions(5)));
%lastscheere E
EI{5} = polyval(M_values{5}, 1) / (polyval(W2rechts, positions(6)));
%Lastscheere F
EI{6} = polyval(M_values{6}, 1) / (polyval(W2rechts, 4790));
%% Modell aufstellen
%EI_values = [EI{1}, EI{2}, EI{3}, EI{4}, EI{5}]; % Abschnittsweise EI

% % 
% % Parameter definieren
% %EI = 210e9 * 0.0001;  % Biegesteifigkeit (z.B. für Stahl mit I = 0.0001 m^4)
%  L = 0.7;               % Länge des Balkens [m]
% % P = 1000;             % äußere Kraft am rechten Ende [N]
% % a = L;                % Hebelarm der Kraft (wirkt am rechten Ende)
% 
% % Momentenverlauf definieren
% syms x C1 C2;
% %My = P * (L - x);  % Momentenverlauf [Nm] (durch äußere Kraft am rechten Ende)
% 
% % Differentialgleichung des Balkens aufstellen
% % EI * d^2w/dx^2 = My
% % d^2w/dx^2 = My / EI
% d2w_dx2 = polyval(-M_values{1},1) / EI{1};
% 
% % Erste Integration (Neigung)
% dw_dx = int(d2w_dx2, x) + C1;
% 
% % Zweite Integration (Durchbiegung)
% w = int(dw_dx, x) + C2;
% 
% % Randbedingungen definieren
% % w(0) = 0, dw_dx(0) = 0
% eq1 = subs(w, x, 0) == 0;      % Durchbiegung an x = 0
% eq2 = subs(dw_dx, x, 0) == 0;  % Neigung an x = 0
% 
% % Integrationskonstanten lösen
% sol = solve([eq1, eq2], [C1, C2]);
% C1_sol = sol.C1;
% C2_sol = sol.C2;
% 
% % Durchbiegungsfunktion aktualisieren
% w = subs(w, [C1, C2], [C1_sol, C2_sol]);
% w_fit = polyval(w(700), x_left);
% % Moment am rechten Ende überprüfen (optional)
% %M_L = subs(My, x, L); % Moment an x = L (optional zur Kontrolle)
% 
% % Ergebnisse anzeigen
% disp('Durchbiegung w(x):');
% disp(w);
% 
% figure('Name', 'Biegung des Ersten Biegemodells', 'NumberTitle', 'off');
% hold on;
% plot(w_fit, fit_left);
% xlabel('x [mm]');
% ylabel('Durchbiegung w(x) [mm]');
% title('Durchbiegung eines Bernoulli-Balkens mit externer Kraft am Ende');
% grid on;
% hold off;
%% Die Biegung bei einem Kraftwert plotten und eine Regression durchfuehren
% % Bereich finden, in dem Fges etwa 3000 N beträgt (Toleranz: ±100 N)
% tolerance = 100; % Toleranz in N
% indices = find(abs(Fges - 3000) <= tolerance);
% 
% % Mittlerer Zeitpunkt bei Fges ~ 3000 N für stabileren Wert
% index = round(mean(indices)); 
% 
% % Koordinaten der Messpunkte (in mm)
% x_coords = [646, 1135, 1727, 2205, 2678, 3276, 3847, 4322, 4795]; % Für H1/V1 bis H9/V9
% % Biegungswerte bei Fges ~ 3000 N
% V_bending = measurements_v(index, 2:end); % V1-V9
% H_bending = measurements_h(index, 2:end); % H1-H9
% 
% % Aufteilen der Daten an der Grenze (2678 mm)
% split_index = find(x_coords == 2678); % Index des Trennpunkts
% 
% % Linke Seite der Daten (x < 2678)
% x_left = x_coords(1:split_index);
% y_left = (V_bending(1:split_index) + H_bending(1:split_index)) / 2; % Mittelwert von V und H
% 
% % Rechte Seite der Daten (x >= 2678)
% x_right = x_coords(split_index:end);
% y_right = (V_bending(split_index:end) + H_bending(split_index:end)) / 2; % Mittelwert von V und H
% 
% % Lineare Regression für linke Seite
% coeffs_left = polyfit(x_left, y_left, 3);
% fit_left = polyval(coeffs_left, x_left); % Angepasste Werte berechnen
% 
% % Lineare Regression für rechte Seite
% coeffs_right = polyfit(x_right, y_right, 2);
% fit_right = polyval(coeffs_right, x_right); % Angepasste Werte berechnen
% 
% % Plot erstellen
% figure('Name', 'Biegung der Messpunkte mit geteilter Regression', 'NumberTitle', 'off');
% hold on;
% 
% % V-Werte plotten
% plot(x_coords, V_bending, 'o-', 'DisplayName', 'V-Messpunkte', 'LineWidth', 1.5);
% 
% % H-Werte plotten
% plot(x_coords, H_bending, 'o--', 'DisplayName', 'H-Messpunkte', 'LineWidth', 1.5);
% 
% % Linke Regressionslinie plotten
% plot(x_left, fit_left, '-g', 'DisplayName', 'Regression links', 'LineWidth', 1.5);
% 
% % Rechte Regressionslinie plotten
% plot(x_right, fit_right, '-r', 'DisplayName', 'Regression rechts', 'LineWidth', 1.5);
% 
% % Achsentitel, allgemeiner Titel und Legende
% title('Biegung der Messpunkte bei Fges \approx 3000 N mit geteilter Regression');
% xlabel('Position entlang des Balkens [mm]');
% ylabel('Biegung [mm]');
% legend('show');
% grid on;
% hold off;

%% Kombinierte Daten für Regression (NUR EINE REGRESSIONSKURVE, obere
% Variante besser
% combined_x = [x_coords, x_coords]; % Alle x-Werte (V und H)
% combined_y = [V_bending, H_bending]; % Alle y-Werte (V und H)
% 
% % Lineare Regression für kombinierte Daten
% coeffs_combined = polyfit(combined_x, combined_y, 1); % Grad 1 (linear)
% fit_combined = polyval(coeffs_combined, x_coords); % Angepasste Werte für x-Koordinaten berechnen
% 
% % Plot erstellen
% figure('Name', 'Biegung der Messpunkte mit gemeinsamer Regression', 'NumberTitle', 'off');
% hold on;
% 
% % V-Werte plotten
% plot(x_coords, V_bending, 'o-', 'DisplayName', 'V-Messpunkte', 'LineWidth', 1.5);
% 
% % H-Werte plotten
% plot(x_coords, H_bending, 'o--', 'DisplayName', 'H-Messpunkte', 'LineWidth', 1.5);
% 
% % Gemeinsame Regression plotten
% plot(x_coords, fit_combined, '-k', 'DisplayName', 'Gemeinsame Regression', 'LineWidth', 1.5);
% 
% % Achsentitel, allgemeiner Titel und Legende
% title('Biegung der Messpunkte bei Fges \approx 3000 N mit gemeinsamer Regression');
% xlabel('Position entlang des Balkens [mm]');
% ylabel('Biegung [mm]');
% legend('show');
% grid on;
% hold off;

%% Neuer Versuch FEM Balken Biegung Balken 1
% MATLAB-Skript: FEM-Modell eines Balkens mit nur einem Element
% Gegebene Parameter
L = 700; % [mm], Länge des Balkens

% Auswahl des ersten Balkens
%EI1 = EI(1);
M = cell2mat(M_values(1));

% Lokale Steifigkeitsmatrix für den gesamten Balken (1 Element)
% Basierend auf der Euler-Bernoulli-Theorie
K_local = (EI{1} / L^3) * [12, 6*L, -12, 6*L;
                        6*L, 4*L^2, -6*L, 2*L^2;
                        -12, -6*L, 12, -6*L;
                        6*L, 2*L^2, -6*L, 4*L^2];

% Lastvektor: Moment am freien Ende
F_local = [0; 0; 0; M(1)];
%disp(M(1));
%disp(EI{1});
% Randbedingungen: Feste Einspannung am linken Ende (Knoten 1)
% Verschiebung u1 = 0 und Rotation theta1 = 0
K_global = K_local;
F_global = F_local;

%test = cell2mat(F_global(1:4));
% Randbedingungen anwenden (erste zwei Gleichungen entfernen)
K_global(1:2, :) = 0;
K_global(:, 1:2) = 0;
K_global(1, 1) = 1; % Stabilität (Dummywert)
K_global(2, 2) = 1; % Stabilität (Dummywert)
F_global(1:2) = 0;

% Lösung des Gleichungssystems
displacements = K_global \ F_global;

% Ausgabe der Ergebnisse
fprintf('Balken 1 Verschiebungen und Rotationen (u und theta) an den Knoten:\n');
disp(displacements);

%% Balken 2
L = 1670-700; % [mm], Länge des Balkens

% Auswahl des ersten Balkens
%EI1 = EI(1);
M = cell2mat(M_values(2));

% Lokale Steifigkeitsmatrix für den gesamten Balken (1 Element)
% Basierend auf der Euler-Bernoulli-Theorie
K_local = (EI{2} / L^3) * [12, 6*L, -12, 6*L;
                        6*L, 4*L^2, -6*L, 2*L^2;
                        -12, -6*L, 12, -6*L;
                        6*L, 2*L^2, -6*L, 4*L^2];

% Lastvektor: Moment am freien Ende
F_local = [0; 0; 0; M(1)];
%disp(M(1));
%disp(EI{2});
% Randbedingungen: Feste Einspannung am linken Ende (Knoten 1)
% Verschiebung u1 = 0 und Rotation theta1 = 0
K_global = K_local;
F_global = F_local;

%test = cell2mat(F_global(1:4));
% Randbedingungen anwenden (erste zwei Gleichungen entfernen)
K_global(1:2, :) = 0;
K_global(:, 1:2) = 0;
K_global(1, 1) = 1; % Stabilität (Dummywert)
K_global(2, 2) = 1; % Stabilität (Dummywert)
F_global(1:2) = 0;

% Lösung des Gleichungssystems
displacements = K_global \ F_global;

% Ausgabe der Ergebnisse
fprintf('Balken 2 Verschiebungen und Rotationen (u und theta) an den Knoten:\n');
disp(displacements);

%% Balken 3
L = 2780-1670; % [mm], Länge des Balkens

% Auswahl des ersten Balkens
%EI1 = EI(1);
M = cell2mat(M_values(3));

% Lokale Steifigkeitsmatrix für den gesamten Balken (1 Element)
% Basierend auf der Euler-Bernoulli-Theorie
K_local = (EI{3} / L^3) * [12, 6*L, -12, 6*L;
                        6*L, 4*L^2, -6*L, 2*L^2;
                        -12, -6*L, 12, -6*L;
                        6*L, 2*L^2, -6*L, 4*L^2];

% Lastvektor: Moment am freien Ende
F_local = [0; 0; 0; M(1)];
%disp(M(1));
%disp(EI{3});
% Randbedingungen: Feste Einspannung am linken Ende (Knoten 1)
% Verschiebung u1 = 0 und Rotation theta1 = 0
K_global = K_local;
F_global = F_local;

%test = cell2mat(F_global(1:4));
% Randbedingungen anwenden (erste zwei Gleichungen entfernen)
K_global(1:2, :) = 0;
K_global(:, 1:2) = 0;
K_global(1, 1) = 1; % Stabilität (Dummywert)
K_global(2, 2) = 1; % Stabilität (Dummywert)
F_global(1:2) = 0;

% Lösung des Gleichungssystems
displacements = K_global \ F_global;

% Ausgabe der Ergebnisse
fprintf('Balken 3 Verschiebungen und Rotationen (u und theta) an den Knoten:\n');
disp(displacements);

%% Balken 4
L = 3860-2780; % [mm], Länge des Balkens

% Auswahl des ersten Balkens
%EI1 = EI(1);
M = cell2mat(M_values(4));

% Lokale Steifigkeitsmatrix für den gesamten Balken (1 Element)
% Basierend auf der Euler-Bernoulli-Theorie
K_local = (EI{4} / L^3) * [12, 6*L, -12, 6*L;
                        6*L, 4*L^2, -6*L, 2*L^2;
                        -12, -6*L, 12, -6*L;
                        6*L, 2*L^2, -6*L, 4*L^2];

% Lastvektor: Moment am freien Ende
F_local = [0; 0; 0; M(1)];

% Randbedingungen: Feste Einspannung am linken Ende (Knoten 1)
% Verschiebung u1 = 0 und Rotation theta1 = 0
K_global = K_local;
F_global = F_local;
%disp(M(1));
%disp(EI{4});
%test = cell2mat(F_global(1:4));
% Randbedingungen anwenden (erste zwei Gleichungen entfernen)
K_global(1:2, :) = 0;
K_global(:, 1:2) = 0;
K_global(1, 1) = 1; % Stabilität (Dummywert)
K_global(2, 2) = 1; % Stabilität (Dummywert)
F_global(1:2) = 0;

% Lösung des Gleichungssystems
displacements = K_global \ F_global;

% Ausgabe der Ergebnisse
fprintf('Balken 4 Verschiebungen und Rotationen (u und theta) an den Knoten:\n');
disp(displacements);

%% Balken 5
L = 4690-3860; % [mm], Länge des Balkens

% Auswahl des ersten Balkens
%EI1 = EI(1);
M = cell2mat(M_values(5));

% Lokale Steifigkeitsmatrix für den gesamten Balken (1 Element)
% Basierend auf der Euler-Bernoulli-Theorie
K_local = (EI{5} / L^3) * [12, 6*L, -12, 6*L;
                        6*L, 4*L^2, -6*L, 2*L^2;
                        -12, -6*L, 12, -6*L;
                        6*L, 2*L^2, -6*L, 4*L^2];

% Lastvektor: Moment am freien Ende
F_local = [0; 0; 0; M(1)];

% Randbedingungen: Feste Einspannung am linken Ende (Knoten 1)
% Verschiebung u1 = 0 und Rotation theta1 = 0
K_global = K_local;
F_global = F_local;
%disp(M(1));
%disp(EI{5});
%test = cell2mat(F_global(1:4));
% Randbedingungen anwenden (erste zwei Gleichungen entfernen)
K_global(1:2, :) = 0;
K_global(:, 1:2) = 0;
K_global(1, 1) = 1; % Stabilität (Dummywert)
K_global(2, 2) = 1; % Stabilität (Dummywert)
F_global(1:2) = 0;

% Lösung des Gleichungssystems
displacements = K_global \ F_global;

% Ausgabe der Ergebnisse
fprintf('Balken 5 Verschiebungen und Rotationen (u und theta) an den Knoten:\n');
disp(displacements);