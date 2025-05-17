function [data] = VTailEquivilent(data)

data.stabcon.Vtail = struct();

data.stabcon.Vtail.S = data.stabcon.St + data.stabcon.Sv;
data.stabcon.Vtail.S1 = data.stabcon.Vtail.S / 2;

data.stabcon.Vtail.angle = atan(sqrt(data.stabcon.Sv / data.stabcon.St));

% Chord is same as tail chord
data.stabcon.Vtail.chord = data.cmpnt.cntrlSurf.tail.(data.use.tail).cbar;

data.stabcon.Vtail.b = data.stabcon.Vtail.S / data.stabcon.Vtail.chord;
data.stabcon.Vtail.b1 = data.stabcon.Vtail.b / 2;

data.stabcon.Vtail.flatspan = data.stabcon.Vtail.b * cos(data.stabcon.Vtail.angle);

end