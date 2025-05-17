function [configs] = config2(aerofoilData, configs)
%% TWIN BOOM
data = struct();

%% VALUES------------------------------------------------------------------
% x = location in x axis from nose (nose = 0)
% y = location in y axis from centre line
% z = location in z axis from centre line of fuselarge
% xl distance in x plane (chord)
% yl distance in y plane (span)
% zl distance in z plane
%--------------------------------------------------------------------------

%% ENGINE
data.prop.downloc = 0;
data.prop.thrust = 4390;
data.cgHeight = 0.8;

%% AIRCRAFT COMPONENTS
data.cmpnt.sec.fuselarge    = struct('m', 0, ...
                            'x', 1, 'y', 0, 'z', 0, ...
                            'xl', 1.8, 'yl', 0.5, 'zl', 0.5);

data.cmpnt.payload.p1       = struct('m', 0, ...
                            'x', 1, 'y', 0, 'z', -0.3, ...
                            'xl', 0.2, 'yl', 0.2, 'zl', 0.2);

data.cmpnt.payload.p2       = struct('m', 450, ...
                            'x', 1.45, 'y', 0, 'z', -0.071, ...
                            'xl', 0.2, 'yl', 0.2, 'zl', 0.2);

data.cmpnt.sec.fuel         = struct('m', 0, ...
                            'x', 1, 'y', 0, 'z', 0.25, ...
                            'xl', 0.2, 'yl', 0.2, 'zl', 0.1);

data.cmpnt.sec.engine       = struct('m', 0, ...
                            'x', 1, 'y', 0, 'z', 0, ...
                            'xl', 0.2, 'yl', 0.2, 'zl', 0.2);

data.cmpnt.sec.landing1     = struct('m', 0, ...
                            'x', 1.60, 'y', 0, 'z', -0.575, ...
                            'xl', 0.2, 'yl', 0.50, 'zl', 0.625);

data.cmpnt.sec.landing2     = struct('m', 0, ...
                            'x', 0.50, 'y', 0, 'z', -0.575, ...
                            'xl', 0.2, 'yl', 0.50, 'zl', 0.625);
%--------------------------------------------------------------------------
% To add another follow the guide below
%
% To add another payload
% data.cmpnt.payload.p(x) = struct('m', value, ...
%                           'x', value, 'y', value, 'z', value, ...
%                           'xl', value, 'yl', value, 'zl', value);
% (replace the (x) value with number of your choosing)
%
% To add another section
% data.cmpnt.sec.(x) = struct('m', value, ...
%                           'x', value, 'y', value, 'z', value, ...
%                           'xl', value, 'yl', value, 'zl', value);
% (replace the (x) value with the section you require)
%
% ENSURE ALL ADDITIONS FOLLOW THE SAME STRUCTURE AS EXAMPLES
% -------------------------------------------------------------------------

%% AERO
%
% Either
% If xl is zero and AR is a valid number
% xl gets recalculated based on AR
%
% If AR is zero and xl is a valid number
% AR gets recalculated based on xl

data.cmpnt.cntrlSurf.wing  = struct('m', 0,...
                                    'x', 1.3, 'y', 0, 'z', 0.25,...
                                    'xl', 0, 'yl', 10, 'zl', 0.1,...
                                    'AR', 14);
data.cmpnt.cntrlSurf.tail  = struct('m', 0,...
                                    'x', 3, 'y', 0, 'z', 0.25, ...
                                    'xl', 0, 'yl', 3.10, 'zl', 0.1, ...
                                    'AR', 7);
data.cmpnt.cntrlSurf.Vstab = struct('m', 0, ...
                                    'x', 2.8, 'y', 0, 'z', 0.20, ...
                                    'xl', 1, 'yl', 0.1, 'zl', 1, ...
                                    'AR', 0);

% Moveable control surfaces
% Alierons
am = 0;
ax = 0; % Auto at end of wing
ay = 3.6;
az = 0.375;
axl = 0.2;
ayl = 2;
azl = 0.1;
aAR = 0;
data.cmpnt.cntrlSurf.aileron1 = struct('m', am,...
                                       'x', ax, 'y', ay, 'z', az,...
                                       'xl', axl, 'yl', ayl, 'zl', azl,...
                                       'AR', aAR);
data.cmpnt.cntrlSurf.aileron2 = struct('m', am,...
                                       'x', ax, 'y', -ay, 'z', az,...
                                       'xl', axl, 'yl', ayl, 'zl', azl,...
                                       'AR', aAR);
data.cmpnt.cntrlSurf.aileron1.x = data.cmpnt.cntrlSurf.wing.x +...
                                    (data.cmpnt.cntrlSurf.wing.yl/data.cmpnt.cntrlSurf.wing.AR)/2 -...
                                    data.cmpnt.cntrlSurf.aileron1.xl / 2;
data.cmpnt.cntrlSurf.aileron2.x = data.cmpnt.cntrlSurf.wing.x +...
                                    (data.cmpnt.cntrlSurf.wing.yl/data.cmpnt.cntrlSurf.wing.AR)/2 -...
                                    data.cmpnt.cntrlSurf.aileron2.xl / 2;

% Elevator
em = 0;
ex = 0; % Auto at end of tail
ey = 0.7;
ez = 0.375;
exl = 0.15;
eyl = 1.5;
ezl = 0.1;
eAR = 0;
data.cmpnt.cntrlSurf.elevator1 = struct('m', em,...
                                        'x', ex, 'y', ey, 'z', ez,...
                                        'xl', exl, 'yl', eyl, 'zl', ezl,...
                                        'AR', eAR);
data.cmpnt.cntrlSurf.elevator2 = struct('m', em,...
                                        'x', ex, 'y', -ey, 'z', ez,...
                                        'xl', exl, 'yl', eyl, 'zl', ezl,...
                                        'AR', eAR);
data.cmpnt.cntrlSurf.elevator1.x = data.cmpnt.cntrlSurf.tail.x +...
                                    (data.cmpnt.cntrlSurf.tail.yl/data.cmpnt.cntrlSurf.tail.AR)/2 -...
                                    data.cmpnt.cntrlSurf.elevator1.xl / 2;
data.cmpnt.cntrlSurf.elevator2.x = data.cmpnt.cntrlSurf.tail.x +...
                                    (data.cmpnt.cntrlSurf.tail.yl/data.cmpnt.cntrlSurf.tail.AR)/2 -...
                                    data.cmpnt.cntrlSurf.elevator2.xl / 2;

% Rudder
data.cmpnt.cntrlSurf.rudder = struct('m', 0.00, ...
                                     'x', 0, 'y', 0, 'z', 0.375, ...
                                     'xl', 0.2, 'yl', 0.2, 'zl', 1, ...
                                     'AR', 0);
data.cmpnt.cntrlSurf.rudder.x = data.cmpnt.cntrlSurf.Vstab.x + data.cmpnt.cntrlSurf.Vstab.xl / 2 - data.cmpnt.cntrlSurf.rudder.xl * 1.5;
data.cmpnt.cntrlSurf.rudder.z = data.cmpnt.cntrlSurf.Vstab.zl / 2 + data.cmpnt.cntrlSurf.Vstab.z;

WingTaper = 0.5;
TailTaper = 0.2;
VstabTaper = 0.3;

data = AerofoilExtract(data, aerofoilData, WingTaper, TailTaper, VstabTaper);

% Triangular only applys to veritcal
data.use.wing = 'Tapered';
data.use.tail = 'Elliptical';
data.use.Vstab = 'Triangular';

data.use.aileron1 = 'Rectangular';
data.use.aileron2 = 'Rectangular';
data.use.elevator1 = 'Rectangular';
data.use.elevator2 = 'Rectangular';
data.use.rudder = 'Rectangular';

%% STAGES
data.stage.loiter    = struct('v', 38, 'altft', 1640);
data.stage.dash      = struct('v', 50, 'altft', 1640);

configs.cg2.data = data;

return


