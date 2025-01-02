% Gegebene Daten
x_points = [0, 960, 1930, 3040, 4120, 4950]; % Abschnitte (mm)
x_data = [646, 1135, 1727, 2205, 2678, 3276, 3847, 4322, 4795]; % Positionen (mm)
w_data = [2.64533349731956, 4.45048900136384, 8.19861958355964, ...
          11.4390276173267, 15.6241738882355, 21.3035849913526, ...
          26.7704441867653, 31.5015611665103, 36.1671690345242]; % Verschiebungen (mm)

% % Umrechnung in Meter
% x_points = x_points / 1000; % mm -> m
% x_data = x_data / 1000; % mm -> m
% w_data = w_data / 1000; % mm -> m

% Fitten eines Polynoms dritten Grades
p = polyfit(x_data, w_data, 3);

% Zweite Ableitung des Polynoms
p_derivative2 = polyder(polyder(p)); % Zweite Ableitung von p

% Berechnung der lokalen Biegesteifigkeit
F_z = 5000; % Gesamtkraft in N
EI_local = zeros(1, length(x_points)-1); % Platzhalter für lokale Biegesteifigkeit

for i = 1:length(x_points)-1
    % Bereichsgrenzen
    x_start = x_points(i);
    x_end = x_points(i+1);
    
    % Mittlere zweite Ableitung in diesem Bereich
    x_mid = (x_start + x_end) / 2;
    w_pp = polyval(p_derivative2, x_mid); % w''(x) am Mittelwert
    
    % Lokale Biegesteifigkeit
    EI_local(i) = F_z / (6 * w_pp);
end

% Ergebnisse ausgeben
disp('Lokale Biegesteifigkeiten in den Bereichen (Nmm^2):');
for i = 1:length(EI_local)
    fprintf('Bereich %d (%.2f mm - %.2f mm): EI = %.2e Nmm^2\n', ...
        i, x_points(i), x_points(i+1), EI_local(i));
end

% Optional: Plot von w(x) und EI(x)
x_fine = linspace(min(x_points), max(x_points), 1000);
w_fine = polyval(p, x_fine);
w_pp_fine = polyval(p_derivative2, x_fine);
EI_fine = F_z ./ (6 * w_pp_fine);

figure;
subplot(2,1,1);
plot(x_data, w_data, 'bo', 'DisplayName', 'Gegebene Daten'); hold on;
plot(x_fine, w_fine, 'r-', 'DisplayName', 'Fit (w(x))');
xlabel('Position x (mm)');
ylabel('Verschiebung w(x) (mm)');
legend('show');
grid on;
title('Verschiebung w(x)');

subplot(2,1,2);
plot(x_fine, EI_fine, 'g-', 'DisplayName', 'Lokales EI(x)');
xlabel('Position x (mm)');
ylabel('Biegesteifigkeit EI (Nmm^2)');
legend('show');
grid on;
title('Lokale Biegesteifigkeit EI');
