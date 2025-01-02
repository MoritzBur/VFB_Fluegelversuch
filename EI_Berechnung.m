% EI * [k] * [u] = [F]
% EI * k * [w_x; w_y; w_z; phi_x; phi_y; phi_z ... mit index 2 ] * [F_x ;F_y ;F_z; M_x; M_y; M_z ... mit index 2]
% EI * k * [w1, phix1, phiy1, w2, phix2, phiy2] = [Fz1, Mx1, My1, Fz2, Mx2, My2]

% Gegebene Daten
x = [646, 1135, 1727, 2205, 2678, 3276, 3847, 4322, 4795]; % Positionen (mm)
w = [2.64533349731956, 4.45048900136384, 8.19861958355964, ...
     11.4390276173267, 15.6241738882355, 21.3035849913526, ...
     26.7704441867653, 31.5015611665103, 36.1671690345242]; % Verschiebungen (mm)

% % Umrechnung in Meter
% x = x / 1000; % mm -> m
% w = w / 1000; % mm -> m

% Fitten eines Polynoms dritten Grades
p = polyfit(x, w, 3);

% Koeffizienten ausgeben
disp('Polynomkoeffizienten (w(x) = a3*x^3 + a2*x^2 + a1*x + a0):');
disp(p);

% Berechnung von EI
F_z = 5000; % Gesamtkraft in N
a3 = p(1); % Koeffizient für x^3
EI = F_z / (6 * a3);

% Ergebnis ausgeben
disp('Biegesteifigkeit EI (Nm^2):');
disp(EI);

% Plot des Fits
w_fit = polyval(p, x); % Berechnete Werte aus dem Fit
figure;
plot(x, w, 'bo', 'DisplayName', 'Gegebene Daten'); hold on;
plot(x, w_fit, 'r-', 'DisplayName', 'Fit (w(x))');
xlabel('Position x (m)');
ylabel('Verschiebung w(x) (m)');
legend('show');
grid on;
title('Verschiebungsfit');

