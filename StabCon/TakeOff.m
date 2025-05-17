function [data] = TakeOff(data)

% For easier calcs
Vbar = data.stabcon.Vbar;
CM0 = data.stabcon.CM0;
a1 = data.stabcon.a1;
a2 = data.stabcon.a2;
h0 = data.stabcon.h0;
h = data.stabcon.h;
etaT = data.stabcon.etaT;
DeDalpha = data.stabcon.DeDalpha;
e0 = data.stabcon.e0;
wing = data.cmpnt.cntrlSurf.wing;
wingAero = data.cmpnt.cntrlSurf.wing.(data.use.wing);
tailAero = data.cmpnt.cntrlSurf.tail.(data.use.tail);
cbar = data.stabcon.cbar;

data.stabcon.haft = h;
data.stabcon.hfwd = h * 0.9 - data.stabcon.Kn * cbar;

haft = data.stabcon.haft;
hfwd = data.stabcon.hfwd;

[~, ~, ~, rho] = atmosisa(0);

%% TAKE OFF
% Velocity
data.stabcon.Vs = sqrt((2 * (data.totalw / wingAero.S))/(rho * wing.CLMAX));
Vr = 1.2 * data.stabcon.Vs;

% CL
CLFLAPS = 1.4;
CLW = data.totalw /  (0.5 * rho * Vr^2 * wingAero.S);
CLTO = CLW + CLFLAPS;

% Drag
data.stabcon.CDi = 0.0077;
data.stabcon.CDb = 0.0325;
CDTO = data.stabcon.CDi + data.stabcon.CDb * CLTO^2;

% Dimensionalise
LTO = 0.5 * rho * Vr^2 * wingAero.S * CLTO;
DTO = 0.5 * rho * Vr^2 * wingAero.S * CDTO;
T = data.prop.thrust;
M0 = 0.5 * rho * Vr^2 * CM0 * wingAero.S * cbar;

% Reaction at nose wheel - set to zero - at point of lift off
data.stabcon.RTO = 0;
data.stabcon.CRTO = data.stabcon.RTO / (0.5 * rho * Vr^2 * wingAero.S * cbar);

% Acceleration
% a = (T - DTO - Ff) / (data.totalw / 9.81);
a = (T - DTO) / (data.totalw / 9.81);

% Total Moment
Ma = (data.totalw / 9.81) * a * data.cgHeight;
data.stabcon.CMref = Ma / (0.5 * rho * Vr^2 * wingAero.S * cbar);

% Tail plane force
LtTO = (M0 - (h0 - hfwd) * cbar * LTO - Ma - data.stabcon.RTO * (data.cmpnt.sec.landing1.x - h0 * cbar)) / (data.stabcon.l);
CLtTO = LtTO / (0.5 * rho * Vr^2 * tailAero.S);

% Deflection effectiveness
aT = etaT - e0;
Te = (aT + (CLtTO / a1)) / rad(25);
etaBarTO = 1 / (Vbar * a2) * (CM0 - (h0 - hfwd) * CLTO - Vbar * (a1 / a * (1 - DeDalpha) * CLTO + a1 * (etaT - e0)));

% Storing
data.stabcon.etaBarTO = etaBarTO;
data.stabcon.CDTO = CDTO;
data.stabcon.CLMAX = wing.CLMAX;
data.stabcon.LTO = LTO;
data.stabcon.TOa = a;
data.stabcon.Te = Te;
data.stabcon.CLW = CLW;
data.stabcon.CLTO = CLTO;
data.stabcon.CLtTO = CLtTO;
data.stabcon.LtTO = LtTO;
data.stabcon.Vr = Vr;
data.stabcon.Ma = Ma;

%% LANDING
% Vms - minimum controllable airspeed - basically stall speed
data.stabcon.Vl = 1.3 * data.stabcon.Vs;
CLWL = data.totalw /  (0.5 * rho * data.stabcon.Vl^2 * wingAero.S);
CLLAND = CLWL + CLFLAPS;
etaBarLand = 1 / (Vbar * a2) * (CM0 - (h0 - haft) * CLLAND - Vbar * (a1 / a * (1 - DeDalpha) * CLLAND + a1 * (etaT - e0)));
CLtLAND = a1 / a * (1 - DeDalpha) * CLLAND + a1 * (etaT - e0) + a2 * etaBarLand;

% Storing
data.stabcon.CLLAND = CLLAND;
data.stabcon.CLtLAND = CLtLAND;
data.stabcon.CLFLAPS = CLFLAPS;
data.stabcon.CLWL = CLWL;
data.stabcon.etaBarLand = etaBarLand;

%% Nose Wheel
x1 = data.cmpnt.sec.landing2.x - haft * cbar;
x2 = data.cmpnt.sec.landing1.x - haft * cbar;
data.stabcon.R2 = data.totalw / ((x2 / x1) + 1);
data.stabcon.R1 = (x2 / x1) * data.stabcon.R2;

return