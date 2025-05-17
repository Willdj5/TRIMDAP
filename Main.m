function [data] = Main(data)
%% NOTES 
% [T, a, P, rho] = atmosisa(3000);

data.stage.current = 'loiter';

%% COG
type1 = fieldnames(data.cmpnt);
moment = 0;
data.totalw = 0;
for i1 = 1:length(type1)
    sec1 = type1{i1};
    type2 = fieldnames(data.cmpnt.(sec1));
    for i2 = 1:length(type2)
        sec2 = type2{i2};
        m = data.cmpnt.(sec1).(sec2).m * 9.81 * data.cmpnt.(sec1).(sec2).x;
        moment = moment + m;
        data.totalw = data.totalw + (data.cmpnt.(sec1).(sec2).m * 9.81);
    end
end

data.hc = moment / data.totalw;
data.h0c = data.cmpnt.cntrlSurf.wing.x;

display(data.hc)
display(data.h0c)

% convensional 5%-10%
% canard 20%-30%
if data.cmpnt.cntrlSurf.tail.x - data.cmpnt.cntrlSurf.wing.x < 0
    split = -0.3;
else
    split = -0.09;
end

data.stabcon.etaBar = 1;

while abs(deg(data.stabcon.etaBar)) > 0.1
    %% Lift wing / tailplane split
    % convensional 5%-10%
    % canard 20%-30%
    data.cmpnt.cntrlSurf.wing.Lift = data.totalw * (1 + split);
    data.cmpnt.cntrlSurf.tail.Lift = - data.cmpnt.cntrlSurf.wing.Lift * split;
    
    disp(['SPLIT ', num2str(split)]);
    disp(['ETA TO TRIM ', num2str(deg(data.stabcon.etaBar))]);
    
    %% CALCULATING AOA REQUIRED
    data = AeroControl(data);
    
    %% GAINING STABCON VALUES
    data = StabConstants(data);
    data = StatStability(data);

    if deg(data.stabcon.etaBar) > 0
        split = split - 0.001;
    else
        split = split + 0.001;
    end
end

data = TakeOff(data);
data = VTailEquivilent(data);

%% GRAPHS
data = StabPlots(data);
data.aeroData = AeroPlot(data);

data = IntertiaM(data);

return