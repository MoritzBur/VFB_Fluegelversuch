% Gegebene Daten
x_data = [646, 1135, 1727, 2205, 2678, 3276, 3847, 4322, 4795]; % Positionen (mm)
w_data = [2.64533349731956, 4.45048900136384, 8.19861958355964, ...
          11.4390276173267, 15.6241738882355, 21.3035849913526, ...
          26.7704441867653, 31.5015611665103, 36.1671690345242]; % Verschiebungen (mm)
x_force = [960, 1930, 3040, 4120, 4950]; % Positionen der Kräfte (mm)
f_force = [1213.25, 1365.11, 1096.85, 771.03, 111.27]; % Kräfte (N)

% % Umrechnung in Meter
% x_data = x_data / 1000; % mm -> m
% w_data = w_data / 1000; % mm -> m
% x_force = x_force / 1000; % mm -> m

% Fitten eines Polynoms dritten Grades für w(x)
p = polyfit(x_data, w_data, 3);

% Zweite Ableitung des Polynoms
p_derivative2 = polyder(polyder(p));

% Berechnung der zweiten Ableitung w''(x) an den x-Positionen der Kräfte
w_pp = polyval(p_derivative2, x_force);

% Berechnung der Biegesteifigkeit EI
EI = f_force ./ (6 * w_pp);

% Ergebnisse ausgeben
disp('Biegesteifigkeit EI (Nm^2) an den gegebenen x-Positionen:');
for i = 1:length(x_force)
    fprintf('x = %.3f m, EI = %.2e Nm^2\n', x_force(i), EI(i));
end

% Optional: Plot von w(x) und EI(x)
x_fine = linspace(min(x_data), max(x_data), 1000);
w_fine = polyval(p, x_fine);
w_pp_fine = polyval(p_derivative2, x_fine);
EI_fine = f_force(1) ./ (6 * w_pp_fine); % Beispiel mit f_force(1) für Vergleich

figure;
subplot(2,1,1);
plot(x_data, w_data, 'bo', 'DisplayName', 'Gegebene Daten'); hold on;
plot(x_fine, w_fine, 'r-', 'DisplayName', 'Fit (w(x))');
xlabel('Position x (m)');
ylabel('Verschiebung w(x) (m)');
legend('show');
grid on;
title('Verschiebungsprofil w(x)');

subplot(2,1,2);
plot(x_force, EI, 'go', 'DisplayName', 'Biegesteifigkeit EI(x)');
xlabel('Position x (m)');
ylabel('Biegesteifigkeit EI (Nm^2)');
legend('show');
grid on;
title('Biegesteifigkeit an den x-Positionen');
