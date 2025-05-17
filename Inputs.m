function [configs] = Inputs(configs)
% Checked 1

aerofoilData = readmatrix("AerofoilData.csv");

% Final
configs = config1(aerofoilData, configs);

% Toms
configs = config2(aerofoilData, configs);

% Point mass
configs = config3(aerofoilData, configs);

return