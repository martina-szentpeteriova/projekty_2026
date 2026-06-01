
% hlavny_subor_01.m
% spusta vsetky m-subory v poradi

% clc+clear vycisti prostredie pred spustenim nasich suborov (vymaze veci 
% z pamati aby bola volna - premenne, tabulky, polia, ...)
clc; clear;
run('importovanie_dat_02.m');
run('analyza_dat_03.m');
run('vypisy_04.m');
run('vymaz_subory_05.m');
