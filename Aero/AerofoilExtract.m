function [data] = AerofoilExtract(data, aerofoilData, taperW, taperT, taperVS)

data.cmpnt.cntrlSurf.wing.aerofoil = aerofoilData(8:end, 1:7);
data.cmpnt.cntrlSurf.aileron1.aerofoil = aerofoilData(8:end, 1:7);
data.cmpnt.cntrlSurf.aileron2.aerofoil = aerofoilData(8:end, 1:7);
data.cmpnt.cntrlSurf.tail.aerofoil = aerofoilData(8:end, 9:15);
data.cmpnt.cntrlSurf.Vstab.aerofoil = aerofoilData(8:end, 9:15);
data.cmpnt.cntrlSurf.elevator1.aerofoil = aerofoilData(8:end, 9:15);
data.cmpnt.cntrlSurf.elevator2.aerofoil = aerofoilData(8:end, 9:15);
data.cmpnt.cntrlSurf.rudder.aerofoil  = aerofoilData(8:end, 9:15);

data.planform = {'Rectangular', 'Triangular', 'Tapered', 'Elliptical'};
for i = 1:length(data.planform)
    data.cmpnt.cntrlSurf.wing.(data.planform{i}) = struct('shape', data.planform{i}, 'taperR', taperW);
    data.cmpnt.cntrlSurf.tail.(data.planform{i}) = struct('shape', data.planform{i}, 'taperR', taperT);
    data.cmpnt.cntrlSurf.Vstab.(data.planform{i}) = struct('shape', data.planform{i}, 'taperR', taperVS);
    data.cmpnt.cntrlSurf.aileron1.(data.planform{i}) = struct('shape', data.planform{i}, 'taperR', 0);
    data.cmpnt.cntrlSurf.aileron2.(data.planform{i}) = struct('shape', data.planform{i}, 'taperR', 0);
    data.cmpnt.cntrlSurf.elevator1.(data.planform{i}) = struct('shape', data.planform{i}, 'taperR', 0);
    data.cmpnt.cntrlSurf.elevator2.(data.planform{i}) = struct('shape', data.planform{i}, 'taperR', 0);
    data.cmpnt.cntrlSurf.rudder.(data.planform{i}) = struct('shape', data.planform{i}, 'taperR', 0);
end

return