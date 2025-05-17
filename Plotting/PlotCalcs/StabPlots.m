function [data] = StabPlots(data)

% For easier calcs
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
Detabn = data.stabcon.Detabn;
Kn = data.stabcon.Kn;
cbar = data.stabcon.cbar;

[~, ~, ~, rho] = atmosisa(data.stage.(data.stage.current).altft);

%% CHANGE IN V WITH ELEVATOR DEFLECTION
data.stabcon.vStore = 20:100;
data.stabcon.etaBarStore = zeros(size(data.stabcon.vStore));

for v = 1:length(data.stabcon.vStore)
    vCL = (data.cmpnt.cntrlSurf.wing.Lift + data.cmpnt.cntrlSurf.tail.Lift)...
        / (0.5 * rho * data.stabcon.vStore(v)^2 * data.cmpnt.cntrlSurf.wing.(data.use.wing).S);
    data.stabcon.etaBarStore(v) = 1 / (Vbar * a2) * (CM0 - (h0 - h)...
        * vCL - Vbar * (a1 / a * (1 - DeDalpha) * vCL + a1 * (etaT - e0)));
end

%% CHANGE IN N WITH ELEVATOR DEFLECTION
data.stabcon.nStore = 0.1:0.1:8;
data.stabcon.getaStore = zeros(size(data.stabcon.nStore));

for n = 1:length(data.stabcon.nStore)
     data.stabcon.getaStore(n) = data.stabcon.nStore(n) * Detabn;
end

%% SCISSOR PLOT
data.stabcon.hStore = (h-1.5):0.1:(h+1.5);
data.stabcon.VbarStore1 = zeros(size(data.stabcon.hStore));
data.stabcon.VbarStore2 = zeros(size(data.stabcon.hStore));
data.stabcon.VbarStore3 = zeros(size(data.stabcon.hStore));
data.stabcon.VbarStore4 = zeros(size(data.stabcon.hStore));

for hvary = 1:length(data.stabcon.hStore)
    % Kn
    data.stabcon.VbarStore1(hvary) = a / (a1 * (1 - DeDalpha)) * (Kn - h0 + data.stabcon.hStore(hvary));
    
    % Take off
    data.stabcon.VbarStore2(hvary) = (CM0 - (h0 - data.stabcon.hStore(hvary)) * data.stabcon.CLTO...
        - (data.cmpnt.sec.landing1.x - h0 * cbar) * data.stabcon.CRTO - data.stabcon.CMref) / data.stabcon.CLtTO;
    
    % Landing
    data.stabcon.VbarStore3(hvary) = (CM0 - (h0 - data.stabcon.hStore(hvary)) * data.stabcon.CLLAND) / data.stabcon.CLtLAND;

end

return