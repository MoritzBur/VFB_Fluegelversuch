% Lädt die Daten für 23%
load('VFB-W24-D-23%-filtered.mat-fit.mat');
% Lädt die x-y Koordinaten der Kraftaufnehmer für Vorder- und Hinterkante
load('V_sensors.mat')
load('H_sensors.mat')

% % Lädt die Polynomkoeffizienten der Biegelinie für 23 %
% polyV_23 = polyV;
% polyH_23 = polyH;
% 
% Für Messpunkte V1/H1 bis V9/H9 die linearen Geradengleichungen aufstellen von 23%
% Cell wird zu Matrix transformiert

linc_z_H_23 = hFits(1,2:10);
for i = 1:9
    z_H_23(i,1:2) = cell2mat(linc_z_H_23(1,i));
end

linc_z_V_23 = vFits(1,2:10);
for i = 1:9
    z_V_23(i,1:2) = cell2mat(linc_z_V_23(1,i));
end

% Verschiebungen für 2500 N werden berechnet an den 9 Kraftaufnehmern

w_z_H_23 = z_H_23(:,1) * 5000 ;%+z_H_23(:,2);
w_z_V_23 = z_V_23(:,1) * 5000 ;%+z_V_23(:,2);

% y-Koordinaten der Kraftaufnehmner von cell nach Matrix
V_y = cell2mat(V_sensors(2:10,3));%*(-1);
H_y = cell2mat(H_sensors(2:10,3));%*(-1);

% z = my + b
% m = (z_H - z_V) / (y_V - y_H)
% b = z_V + y_V * m             

%Geradengleichungen für Flügelebene aus der Verschiebung von Vorder- und Hinterkante
m_23 = (w_z_H_23(:,1) - w_z_V_23(:,1)) ./ (H_y(:,1) - V_y(:,1));
b_23 = w_z_H_23(:,1) - m_23 .* H_y(:,1);

% Das gleiche wie oben nochmal für 60 %
load('VFB-W24-D-60%-filtered.mat-fit.mat');
% Lädt die Polynomkoeffizienten der Biegelinie für 60 %
polyV_60 = polyV;
polyH_60 = polyH;
% Für Messpunkte V1/H1 bis V9/H9 die linearen Geradengleichungen aufstellen von 60%
% Cell wird zu Matrix transformiert
linc_z_H_60 = hFits(1,2:10);
for i = 1:9
    z_H_60(i,1:2) = cell2mat(linc_z_H_60(1,i));
end

linc_z_V_60 = vFits(1,2:10);
for i = 1:9
    z_V_60(i,1:2) = cell2mat(linc_z_V_60(1,i));
end

% Verschiebungen für 2500 N werden berechnet an den 9 Kraftaufnehmern
w_z_H_60 = z_H_60(:,1) * 5000 ;%+z_H_60(:,2);
w_z_V_60 = z_V_60(:,1) * 5000 ;%+z_V_60(:,2);

%Geradengleichungen für Flügelebene aus der Verschiebung von Vorder- und Hinterkante
m_60 = (w_z_H_60(:,1) - w_z_V_60(:,1)) ./ (H_y(:,1) - V_y(:,1));
b_60 = w_z_H_60(:,1) - m_60 .* H_y(:,1);

% y_schnitt sind die y-Koordinaten der SMPs an den Kraftaufnehmer x-Koordinaten
y_schnitt = (b_60 - b_23) ./ (m_23 -  m_60);
z_schnitt = y_schnitt .* m_60 + (b_60.*[1;1;1;1;1;1;1;1;1]);

% Y und Z Koordinaten für Plot der SMPs
Y = [V_y, H_y ,y_schnitt];
Z_60 = [w_z_V_60, w_z_H_60, z_schnitt];
Z_23 = [w_z_V_23, w_z_H_23, z_schnitt];

% Plot der SMPs und ihrer lokalen Verschiebungen
figure('Name','Ermittelung der SMPs','NumberTitle','off')
for i = 1:9
    plot(Y(i,:),Z_23(i,:),'*',Y(i,:),Z_60(i,:),'x')
    axis([-600,600,0,20])
    line(Y(i,:),Z_60(i,:))
    line(Y(i,:),Z_23(i,:))
    hold on
end
hold off

% % Verschiebungen für 2500 N mit den Polyfit Werten der Biegelinie
% poly_w_V_23 = ((V_x(2:10,1) .^3) * polyV_23(1,1) + (V_x(2:10,1) .^2) * polyV_23(1,2) + V_x(2:10,1) * polyV_23(1,3) + polyV_23(1,4) * [1;1;1;1;1;1;1;1;1])*5000;
% poly_w_H_23 = (H_x(2:10,1) .^3 * polyH_23(1,1) + H_x(2:10,1) .^2 * polyH_23(1,2) + H_x(2:10,1) * polyH_23(1,3) + polyH_23(1,4) * [1;1;1;1;1;1;1;1;1])*5000;
% poly_w_V_60 = (V_x(2:10,1) .^3 * polyV_60(1,1) + V_x(2:10,1) .^2 * polyV_60(1,2) + V_x(2:10,1) * polyV_60(1,3) + polyV_60(1,4) * [1;1;1;1;1;1;1;1;1])*5000;
% poly_w_H_60 = (H_x(2:10,1) .^3 * polyH_60(1,1) + H_x(2:10,1) .^2 * polyH_60(1,2) + H_x(2:10,1) * polyH_60(1,3) + polyH_60(1,4) * [1;1;1;1;1;1;1;1;1])*5000;
% 
% % Polyfit Geradengleichungen der 9 Kraftaufnehmerpunkte
% poly_m_23 = (poly_w_H_23(:,1) - poly_w_V_23(:,1)) ./ (H_y(:,1) - V_y(:,1));
% poly_b_23 = poly_w_H_23(:,1) - poly_m_23 .* H_y(:,1);
% poly_m_60 = (poly_w_H_60(:,1) - poly_w_V_60(:,1)) ./ (H_y(:,1) - V_y(:,1));
% poly_b_60 = poly_w_H_60(:,1) - poly_m_60 .* H_y(:,1);
% 
% % Polyfit SMPs
% poly_y_schnitt = (poly_b_60 - poly_b_23) ./ (poly_m_23 -  poly_m_60);

% Plot der SMPs und Lineare Regressionen an den Lasteinleitungspunkten
figure('Name','SMP Regression','NumberTitle','off')
%subplot(1,2,1)
plot(V_x(2:10,1),y_schnitt,'x',Color = 'blue')
hold on
xlabel('Spannweite x [mm]')
ylabel('Flügeltiefe y [mm]')
SMP_reg = polyfit([V_x(3:4,1); V_x(6:10,1)],[y_schnitt(2:3,1);  y_schnitt(5:9,1)],1);
%SMP_reg = polyfit(V_x(3:10,1),y_schnitt(2:9,1),1);

x_Last = [960; 1930; 3040; 4120; 4950];
% Die Schubmittelpunkte an den Lastscheren sind im Vektor y_Last zu finden
y_Last = x_Last * SMP_reg(1,1) + (SMP_reg(1,2)*[1;1;1;1;1]);
plot(x_Last, y_Last,'o', Color = 'red')
line([0, x_Last(5,1)],[SMP_reg(1,2), y_Last(5,1)], Color = '#7E2F8E');
punkt_eins_fit = polyfit(V_x(2:3,1),y_schnitt(1:2,1),1);
last_eins = punkt_eins_fit(1,1)*x_Last(1,1) + punkt_eins_fit(1,2);
plot(x_Last(1,1),last_eins,'o', Color = 'blue')
legend('SMP Messpunkte','SMP Lastscheren','SMP Regression','SMP Korrektur')


%figure('Name','SMP Regression aus Polyfit Biegelinie','NumberTitle','off')

% subplot(1,2,2)
% plot(V_x(2:10,1),poly_y_schnitt,'x',Color = 'blue')
% hold on
% xlabel('Spannweite x [mm]')
% ylabel('Flügeltiefe y [mm]')
% poly_SMP_reg = polyfit(V_x(2:10,1),poly_y_schnitt(1:9,1),1);
% poly_SMP_reg_1 = polyfit(V_x(2:5,1),poly_y_schnitt(1:4,1),1);
% poly_SMP_reg_2 = polyfit(V_x(6:10,1),poly_y_schnitt(5:9,1),1);
% %x_Last = [960; 1930; 3040; 4120; 4950];
% % Die Schubmittelpunkte an den Lastscheren sind im Vektor y_Last zu finden
% poly_y_Last = x_Last * poly_SMP_reg(1,1) + (poly_SMP_reg(1,2)*[1;1;1;1;1]);
% poly_y_Last_1 = x_Last(1:2,1) * poly_SMP_reg_1(1,1) + (poly_SMP_reg_1(1,2)*[1;1]);
% poly_y_Last_2 = x_Last(3:5,1) * poly_SMP_reg_2(1,1) + (poly_SMP_reg_2(1,2)*[1;1;1]);
% 
% plot(x_Last, poly_y_Last,'o', Color = 'red')
% plot(x_Last(1:2,1), poly_y_Last_1,'o', Color = 'green')
% plot(x_Last(3:5,1), poly_y_Last_2,'o', Color = 'green')
% line([0, x_Last(5,1)],[poly_SMP_reg(1,2), poly_y_Last(5,1)], Color = '#7E2F8E');
% line([0, V_x(5,1)],[poly_SMP_reg_1(1,2), (V_x(5,1)*poly_SMP_reg_1(1,1)+poly_SMP_reg_1(1,2))], Color = '#06402B');
% line([V_x(6,1), x_Last(5,1)],[(V_x(6,1)*poly_SMP_reg_2(1,1)+poly_SMP_reg_2(1,2)), poly_y_Last_2(3,1)], Color = '#06402B');
% x_graph = [-5,7];
% y_graph = [1.5,0.5];
% figure('Name','Abbildung 1','NumberTitle','off')

% plot(x_graph,y_graph)
% ax = gca;
% ax.XAxisLocation = "origin";
% ax.YAxisLocation = "origin";
% axis([-8,8,-0.5,2]);