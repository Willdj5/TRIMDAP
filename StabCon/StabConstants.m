function [data] = StabConstants(data)
% Checked
[~, ~, ~, rho] = atmosisa(data.stage.(data.stage.current).altft);

%% CL
data.stabcon.CL = (data.cmpnt.cntrlSurf.wing.Lift + data.cmpnt.cntrlSurf.tail.Lift)...
    / (0.5 * rho * data.stage.(data.stage.current).v^2 * data.cmpnt.cntrlSurf.wing.(data.use.wing).S);

data.stabcon.CL_wb = data.cmpnt.cntrlSurf.wing.Lift...
    / (0.5 * rho * data.stage.(data.stage.current).v^2 * data.cmpnt.cntrlSurf.wing.(data.use.wing).S);

%% Wing
data.stabcon.bw = data.cmpnt.cntrlSurf.wing.yl;

%% Tail
data.stabcon.l = data.cmpnt.cntrlSurf.tail.x - data.cmpnt.cntrlSurf.wing.x;
data.stabcon.lv = data.cmpnt.cntrlSurf.Vstab.x - data.hc;
data.stabcon.lt = data.cmpnt.cntrlSurf.tail.x - data.hc;
data.stabcon.cbar = data.cmpnt.cntrlSurf.wing.(data.use.wing).cbar;

data.stabcon.mu1 = data.totalw / (rho * 9.81 * data.cmpnt.cntrlSurf.wing.(data.use.wing).S * data.stabcon.lt);

data.stabcon.St = data.cmpnt.cntrlSurf.tail.(data.use.tail).S;
data.stabcon.S = data.cmpnt.cntrlSurf.wing.(data.use.wing).S;
data.stabcon.Sv = data.cmpnt.cntrlSurf.Vstab.(data.use.Vstab).S;

data.stabcon.Vbar = (data.stabcon.St / data.stabcon.S) *...
    (data.stabcon.l / data.stabcon.cbar);

data.stabcon.VertVbar = (data.stabcon.Sv / data.stabcon.S) *...
    (data.stabcon.lv / data.stabcon.bw);

%% CM0
rows = find(data.cmpnt.cntrlSurf.wing.aerofoil(:,1) >= -5 & data.cmpnt.cntrlSurf.wing.aerofoil(:,1) <= 5);
selected_data = data.cmpnt.cntrlSurf.wing.aerofoil(rows, :);
data.stabcon.CM0 = mean(selected_data(:, 5));

%% Lift Curve Slopes - Proved not to change
data.stabcon.a = data.cmpnt.cntrlSurf.wing.(data.use.wing).a;
data.stabcon.a1 = data.cmpnt.cntrlSurf.tail.(data.use.tail).a;
data.stabcon.a2 = data.cmpnt.cntrlSurf.elevator1.(data.use.elevator1).a;
data.stabcon.av = data.cmpnt.cntrlSurf.Vstab.(data.use.Vstab).a;
data.stabcon.aa = data.cmpnt.cntrlSurf.aileron1.(data.use.aileron1).a;
data.stabcon.ar = data.cmpnt.cntrlSurf.rudder.(data.use.rudder).a;

%%
data.stabcon.h0 = data.h0c / data.stabcon.cbar;
data.stabcon.h = data.hc / data.stabcon.cbar;

%% Difference between tail angle and wing angle
data.stabcon.etaT = rad(data.cmpnt.cntrlSurf.tail.(data.use.tail).alpha)...
    - rad(data.cmpnt.cntrlSurf.wing.(data.use.wing).alpha);

data.stabcon.DeDalpha = 2 * data.stabcon.a / (pi * data.cmpnt.cntrlSurf.wing.(data.use.wing).e * data.cmpnt.cntrlSurf.wing.AR);
data.stabcon.e0 = 2 * data.cmpnt.cntrlSurf.wing.(data.use.wing).CL / (pi * data.cmpnt.cntrlSurf.wing.(data.use.wing).e * data.cmpnt.cntrlSurf.wing.AR);

return