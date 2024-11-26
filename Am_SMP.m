load('VFB-W24-D-SMP2-filtered.mat-fit.mat');
% Lädt die x-y Koordinaten der Kraftaufnehmer für Vorder- und Hinterkante
load('V_sensors.mat')
load('H_sensors.mat')

% Für Messpunkte V1/H1 bis V9/H9 die linearen Geradengleichungen aufstellen von 23%
% Cell wird zu Matrix transformiert

linc_z_H_SMP = hFits(1,2:10);
for i = 1:9
    z_H_SMP(i,1:2) = cell2mat(linc_z_H_SMP(1,i));
end

linc_z_V_SMP = vFits(1,2:10);
for i = 1:9
    z_V_SMP(i,1:2) = cell2mat(linc_z_V_SMP(1,i));
end

% Verschiebungen für 5000 N werden berechnet an den 9 Kraftaufnehmern

w_z_H_SMP = z_H_SMP(:,1) * 5000 ;%+z_H_SMP(:,2);
w_z_V_SMP = z_V_SMP(:,1) * 5000 ;%+z_V_SMP(:,2);

% y-Koordinaten der Kraftaufnehmner von cell nach Matrix
V_y = cell2mat(V_sensors(2:10,3));%*(-1);
H_y = cell2mat(H_sensors(2:10,3));%*(-1);

Delta_w_SMP = w_z_V_SMP - w_z_H_SMP ;

Delta_w_SMP_prozent = Delta_w_SMP ./ ((w_z_V_SMP+w_z_H_SMP) / 2) * 100;
x_Last = [960; 1930; 3040; 4120; 4950];
figure('Name','Verformung bei Messung am SMP','NumberTitle','off')
hold on
plot(H_x(2:10),w_z_H_SMP,'x',Color='red')
plot(V_x(2:10),w_z_V_SMP,'x',Color='blue')
xline(x_Last,Color='blue');
legend('Verformungen HK', 'Verformungen VK', 'Lastscherenpositionen');