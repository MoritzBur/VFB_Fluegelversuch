
E1 = 21000;
E2 = 21000;
E3 = 21000;
E4 = 21000;
E5 = 21000;

G1 = 200;
G2 = 200;
G3 = 200;
G4 = 200;
G5 = 200;

Iy1 = 220;
Iy2 = 10;
Iy3 = 10;
Iy4 = 10;
Iy5 = 10;

It1 = 10;
It2 = 10;
It3 = 10;
It4 = 10;
It5 = 10;

l1 = 500;
l2 = 500;
l3 = 500;
l4 = 500;
l5 = 500;


K_1 = [
    (12*E1*Iy1)/l1^3,    0,       -6*E1*Iy1/l1^2,    -12*E1*Iy1/l1^3,   0,          -6*E1*Iy1/l1^2;
    0,              G1*It1/l1,  0,              0,              -G1*It1/l1,    0;
    -6*E1*Iy1/l1^2,    0,       4*E1*Iy1/l1,       6*E1*Iy1/l1^2,     0,          2*E1*Iy1/l1;
    -12*E1*Iy1/l1^3,   0,       6*E1*Iy1/l1^2,     12*E1*Iy1/l1^3,    0,          6*E1*Iy1/l1^2;
    0,              -G1*It1/l1, 0,              0,              G1*It1/l1,     0;
    -6*E1*Iy1/l1^2,    0,       2*E1*Iy1/l1,       6*E1*Iy1/l1^2,     0,          4*E1*Iy1/l1;
];

K_2 = [
    12*E2*Iy2/l2^3,    0,       -6*E2*Iy2/l2^2,    -12*E2*Iy2/l2^3,   0,          -6*E2*Iy2/l2^2;
    0,              G2*It2/l2,  0,              0,              -G2*It2/l2,    0;
    -6*E2*Iy2/l2^2,    0,       4*E2*Iy2/l2,       6*E2*Iy2/l2^2,     0,          2*E2*Iy2/l2;
    -12*E2*Iy2/l2^3,   0,       6*E2*Iy2/l2^2,     12*E2*Iy2/l2^3,    0,          6*E2*Iy2/l2^2;
    0,              -G2*It2/l2, 0,              0,              G2*It2/l2,     0;
    -6*E2*Iy2/l2^2,    0,       2*E2*Iy2/l2,       6*E2*Iy2/l2^2,     0,          4*E2*Iy2/l2;
];

K_3 = [
    12*E3*Iy3/l3^3,    0,       -6*E3*Iy3/l3^2,    -12*E3*Iy3/l3^3,   0,          -6*E3*Iy3/l3^2;
    0,              G3*It3/l3,  0,              0,              -G3*It3/l3,    0;
    -6*E3*Iy3/l3^2,    0,       4*E3*Iy3/l3,       6*E3*Iy3/l3^2,     0,          2*E3*Iy3/l3;
    -12*E3*Iy3/l3^3,   0,       6*E3*Iy3/l3^2,     12*E3*Iy3/l3^3,    0,          6*E3*Iy3/l3^2;
    0,              -G3*It3/l3, 0,              0,              G3*It3/l3,     0;
    -6*E3*Iy3/l3^2,    0,       2*E3*Iy3/l3,       6*E3*Iy3/l3^2,     0,          4*E3*Iy3/l3;
];

K_4 = [
    12*E4*Iy4/l4^3,    0,       -6*E4*Iy4/l4^2,    -12*E4*Iy4/l4^3,   0,          -6*E4*Iy4/l4^2;
    0,              G4*It4/l4,  0,              0,              -G4*It4/l4,    0;
    -6*E4*Iy4/l4^2,    0,       4*E4*Iy4/l4,       6*E4*Iy4/l4^2,     0,          2*E4*Iy4/l4;
    -12*E4*Iy4/l4^3,   0,       6*E4*Iy4/l4^2,     12*E4*Iy4/l4^3,    0,          6*E4*Iy4/l4^2;
    0,              -G4*It4/l4, 0,              0,              G4*It4/l4,     0;
    -6*E4*Iy4/l4^2,    0,       2*E4*Iy4/l4,       6*E4*Iy4/l4^2,     0,          4*E4*Iy4/l4;
];

K_5 = [
    12*E5*Iy5/l5^3,    0,       -6*E5*Iy5/l5^2,    -12*E5*Iy5/l5^3,   0,          -6*E5*Iy5/l5^2;
    0,              G5*It5/l5,  0,              0,              -G5*It5/l5,    0;
    -6*E5*Iy5/l5^2,    0,       4*E5*Iy5/l5,       6*E5*Iy5/l5^2,     0,          2*E5*Iy5/l5;
    -12*E5*Iy5/l5^3,   0,       6*E5*Iy5/l5^2,     12*E5*Iy5/l5^3,    0,          6*E5*Iy5/l5^2;
    0,              -G5*It5/l5, 0,              0,              G5*It5/l5,     0;
    -6*E5*Iy5/l5^2,    0,       2*E5*Iy5/l5,       6*E5*Iy5/l5^2,     0,          4*E5*Iy5/l5;
];


% Anzahl der Knoten und Freiheitsgrade
num_nodes = 6;       % Anzahl der Knoten
dof_per_node = 3;    % Freiheitsgrade pro Knoten
total_dof = num_nodes * dof_per_node; % Gesamtanzahl der Freiheitsgrade

% Initialisierung der globalen Steifigkeitsmatrix
K_global = zeros(total_dof, total_dof);

K_global(1,1) = K_1(1,1);
K_global(2,1) = K_1(2,1);
K_global(3,1) = K_1(3,1);
K_global(4,1) = K_1(4,1);
K_global(5,1) = K_1(5,1);
K_global(6,1) = K_1(6,1);

K_global(1,2) = K_1(1,2);
K_global(2,2) = K_1(2,2);
K_global(3,2) = K_1(3,2);
K_global(4,2) = K_1(4,2);
K_global(5,2) = K_1(5,2);
K_global(6,2) = K_1(6,2);

K_global(1,3) = K_1(1,3);
K_global(2,3) = K_1(2,3);
K_global(3,3) = K_1(3,3);
K_global(4,3) = K_1(4,3);
K_global(5,3) = K_1(5,3);
K_global(6,3) = K_1(6,3);

K_global(1,4) = K_1(1,4);
K_global(2,4) = K_1(2,4);
K_global(3,4) = K_1(3,4);
K_global(4,4) = K_1(4,4)+K_2(1,1);
K_global(5,4) = K_1(5,4)+K_2(2,1);
K_global(6,4) = K_1(6,4)+K_2(3,1);

K_global(1,5) = K_1(1,5);
K_global(2,5) = K_1(2,5);
K_global(3,5) = K_1(3,5);
K_global(4,5) = K_1(4,5)+K_2(1,2);
K_global(5,5) = K_1(5,5)+K_2(2,2);
K_global(6,5) = K_1(6,5)+K_2(3,2);

K_global(1,6) = K_1(1,6);
K_global(2,6) = K_1(2,6);
K_global(3,6) = K_1(3,6);
K_global(4,6) = K_1(4,6)+K_2(1,3);
K_global(5,6) = K_1(5,6)+K_2(2,3);
K_global(6,6) = K_1(6,6)+K_2(3,3);

K_global(7,4) = K_2(4,1);
K_global(8,4) = K_2(5,1);
K_global(9,4) = K_2(6,1);

K_global(7,5) = K_2(4,2);
K_global(8,5) = K_2(5,2);
K_global(9,5) = K_2(6,2);

K_global(7,6) = K_2(4,3);
K_global(8,6) = K_2(5,3);
K_global(9,6) = K_2(6,3);

K_global(4,7) = K_2(1,4);
K_global(5,7) = K_2(2,4);
K_global(6,7) = K_2(3,4);

K_global(4,8) = K_2(1,5);
K_global(5,8) = K_2(2,5);
K_global(6,8) = K_2(3,5);

K_global(4,9) = K_2(1,6);
K_global(5,9) = K_2(2,6);
K_global(6,9) = K_2(3,6);

K_global(7,7) = K_2(4,4)+K_3(1,1);
K_global(8,7) = K_2(5,4)+K_3(2,1);
K_global(9,7) = K_2(6,4)+K_3(3,1);

K_global(7,8) = K_2(4,5)+K_3(1,2);
K_global(8,8) = K_2(5,5)+K_3(2,2);
K_global(9,8) = K_2(6,5)+K_3(3,2);

K_global(7,9) = K_2(4,6)+K_3(1,3);
K_global(8,9) = K_2(5,6)+K_3(2,3);
K_global(9,9) = K_2(6,6)+K_3(3,3);

K_global(10,7) = K_3(4,1);
K_global(11,7) = K_3(5,1);
K_global(12,7) = K_3(6,1);

K_global(10,8) = K_3(4,2);
K_global(11,8) = K_3(5,2);
K_global(12,8) = K_3(6,2);

K_global(10,9) = K_3(4,3);
K_global(11,9) = K_3(5,3);
K_global(12,9) = K_3(6,3);

K_global(7,10) = K_3(1,4);
K_global(8,10) = K_3(2,4);
K_global(9,10) = K_3(3,4);

K_global(7,11) = K_3(1,5);
K_global(8,11) = K_3(2,5);
K_global(9,11) = K_3(3,5);

K_global(7,12) = K_3(1,6);
K_global(8,12) = K_3(2,6);
K_global(9,12) = K_3(3,6);

K_global(10,10) = K_3(4,4)+K_4(1,1);
K_global(11,10) = K_3(5,4)+K_4(2,1);
K_global(12,10) = K_3(6,4)+K_4(3,1);

K_global(10,11) = K_3(4,5)+K_4(1,2);
K_global(11,11) = K_3(5,5)+K_4(2,2);
K_global(12,11) = K_3(6,5)+K_4(3,2);

K_global(10,12) = K_3(4,6)+K_4(1,3);
K_global(11,12) = K_3(5,6)+K_4(2,3);
K_global(12,12) = K_3(6,6)+K_4(3,3);

K_global(10,13) = K_4(1,4);
K_global(11,13) = K_4(2,4);
K_global(12,13) = K_4(3,4);

K_global(10,14) = K_4(1,5);
K_global(11,14) = K_4(2,5);
K_global(12,14) = K_4(3,5);

K_global(10,15) = K_4(1,6);
K_global(11,15) = K_4(2,6);
K_global(12,15) = K_4(3,6);

K_global(13,10) = K_4(4,1);
K_global(14,10) = K_4(5,1);
K_global(15,10) = K_4(6,1);

K_global(13,11) = K_4(4,2);
K_global(14,11) = K_4(5,2);
K_global(15,11) = K_4(6,2);

K_global(13,12) = K_4(4,3);
K_global(14,12) = K_4(5,3);
K_global(15,12) = K_4(6,3);

K_global(13,13) = K_4(4,4)+K_5(1,1);
K_global(14,13) = K_4(5,4)+K_5(2,1);
K_global(15,13) = K_4(6,4)+K_5(3,1);

K_global(13,14) = K_4(4,5)+K_5(1,2);
K_global(14,14) = K_4(5,5)+K_5(2,2);
K_global(15,14) = K_4(6,5)+K_5(3,2);

K_global(13,15) = K_4(4,6)+K_5(1,3);
K_global(14,15) = K_4(5,6)+K_5(2,3);
K_global(15,15) = K_4(6,6)+K_5(3,3);

K_global(10,16) = K_5(1,4);
K_global(11,16) = K_5(2,4);
K_global(12,16) = K_5(3,4);

K_global(10,17) = K_5(1,5);
K_global(11,17) = K_5(2,5);
K_global(12,17) = K_5(3,5);

K_global(10,18) = K_5(1,6);
K_global(11,18) = K_5(2,6);
K_global(12,18) = K_5(3,6);

K_global(16,13) = K_5(4,1);
K_global(17,13) = K_5(5,1);
K_global(18,13) = K_5(6,1);

K_global(16,14) = K_5(4,2);
K_global(17,14) = K_5(5,2);
K_global(18,14) = K_5(6,2);

K_global(16,15) = K_5(4,3);
K_global(17,15) = K_5(5,3);
K_global(18,15) = K_5(6,3);

K_global(16,16) = K_5(4,4);
K_global(17,16) = K_5(5,4);
K_global(18,16) = K_5(6,4);

K_global(16,17) = K_5(4,5);
K_global(17,17) = K_5(5,5);
K_global(18,17) = K_5(6,5);

K_global(16,18) = K_5(4,6);
K_global(17,18) = K_5(5,6);
K_global(18,18) = K_5(6,6);


K_global