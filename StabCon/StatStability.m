function [data] = StatStability(data)
% Checked
% For easier calcs
CL = data.stabcon.CL;
Vbar = data.stabcon.Vbar;
CM0 = data.stabcon.CM0;
a = data.stabcon.a;
a1 = data.stabcon.a1;
a2 = data.stabcon.a2;
h0 = data.stabcon.h0;
h = data.stabcon.h;
etaT = data.stabcon.etaT;
DeDalpha = data.stabcon.DeDalpha;
e0 = data.stabcon.e0;
mu1 = data.stabcon.mu1;

% Kn
data.stabcon.hn = h0 + Vbar * (a1 / a) * (1 - DeDalpha);
data.stabcon.Kn = h0 - h + Vbar * (a1 / a) * (1 - DeDalpha);

% eta to trim
data.stabcon.etaBar = 1 / (Vbar * a2) * (CM0 - (h0 - h) * CL - Vbar * (a1 / a * (1 - DeDalpha) * CL + a1 * (etaT - e0)));

% Manouvre
data.stabcon.Detabn = - CL / (Vbar * a2) * ((h0 - h) + Vbar * (a1 / a * (1 - DeDalpha) + a1 / (2 * mu1)));
data.stabcon.hm = h0 + Vbar * (a1 / a * (1 - DeDalpha) + a1 / (2 * mu1));
data.stabcon.Hm = - Vbar * a2 / CL * data.stabcon.Detabn;

% Manouvre max tail force for 3g pull
etaReq = 3 * data.stabcon.Detabn;
data.stabcon.maxCLt = (a1 / a) * (1 - DeDalpha) * (1 + 3) * CL + a1 * (etaT - e0) + a2 * etaReq + a1 * (3 * CL) / (2 * mu1);
data.stabcon.maxLt = data.stabcon.maxCLt * 0.5 * 1.225 * data.stage.dash.v^2 * data.stabcon.St;

return