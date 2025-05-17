function [data] = AeroDynamics(data, sec, s)

% Find row with 5 and -5 degrees
row_n5 = find(data.cmpnt.cntrlSurf.(sec).aerofoil(:,1) == -5);
n5 = data.cmpnt.cntrlSurf.(sec).aerofoil(row_n5, :);

row_p5 = find(data.cmpnt.cntrlSurf.(sec).aerofoil(:,1) == 5);
p5 = data.cmpnt.cntrlSurf.(sec).aerofoil(row_p5, :);

a0 = (p5(2) - n5(2)) / (rad(p5(1)) - rad(n5(1)));
data.cmpnt.cntrlSurf.(sec).a0 = a0;

% Typically around 90% of CLMAX for infinite
data.cmpnt.cntrlSurf.(sec).CLMAX = 0.9 * max(data.cmpnt.cntrlSurf.(sec).aerofoil(:,2));

% Find index of the value closest to CLMAX_target
[~, idx] = min(abs(data.cmpnt.cntrlSurf.(sec).aerofoil(:,2) - data.cmpnt.cntrlSurf.(sec).CLMAX));

% Get the corresponding x value (e.g., angle of attack)
data.cmpnt.cntrlSurf.(sec).alphaSwitch = data.cmpnt.cntrlSurf.(sec).aerofoil(idx, 1);

%%
d = data.cmpnt.cntrlSurf.(sec).aerofoil;
col1 = d(:,1);
col2 = d(:,2);

for row = 1:length(col2) - 1
    if (col2(row) < 0 && col2(row+1) >= 0)
        idx = row;
        break
    end
end

x1 = col1(idx);
x2 = col1(idx+1);
y1 = col2(idx);
y2 = col2(idx+1);

data.cmpnt.cntrlSurf.(sec).alphaL0 = x1 - y1 * (x2 - x1) / (y2 - y1);
%%
c = zeros(4, 1);

switch data.cmpnt.cntrlSurf.(sec).(s).shape

case 'Rectangular'
    %% GEOMETRY
    if data.cmpnt.cntrlSurf.(sec).AR == 0
        data.cmpnt.cntrlSurf.(sec).AR = data.cmpnt.cntrlSurf.(sec).yl / data.cmpnt.cntrlSurf.(sec).xl;
    end
    data.cmpnt.cntrlSurf.(sec).(s).S = data.cmpnt.cntrlSurf.(sec).yl^2 / data.cmpnt.cntrlSurf.(sec).AR;
    data.cmpnt.cntrlSurf.(sec).(s).c = data.cmpnt.cntrlSurf.(sec).(s).S / data.cmpnt.cntrlSurf.(sec).yl;
    data.cmpnt.cntrlSurf.(sec).(s).cbar = data.cmpnt.cntrlSurf.(sec).(s).c;
    data.cmpnt.cntrlSurf.(sec).xl = data.cmpnt.cntrlSurf.(sec).(s).cbar;

    %% AERO CALCS
    nStore = 1:4;
    eq = zeros(4, 4);
    for n = nStore
        c(n, 1) = (pi*(rad(data.cmpnt.cntrlSurf.(sec).(s).alpha)-rad(data.cmpnt.cntrlSurf.(sec).alphaL0)))...
            / (2 * data.cmpnt.cntrlSurf.(sec).AR);
        theta = n * pi/8;
        for p = nStore
            nV = 2 * p - 1;
            eq(n, p) = sin(theta * nV) * (1 + (nV * pi)/(2 * data.cmpnt.cntrlSurf.(sec).AR * sin(theta)));
        end
    end
    An = eq\c;
    data.cmpnt.cntrlSurf.(sec).(s).CL = An(1) * pi * data.cmpnt.cntrlSurf.(sec).AR;
    data.cmpnt.cntrlSurf.(sec).(s).CDi = pi * data.cmpnt.cntrlSurf.(sec).AR * An(1)^2 * ...
        (1 + 3 * (An(2) / An(1))^2 + 5 * (An(3) / An(1))^2 + 7 * (An(4) / An(1))^2);
    
    data.cmpnt.cntrlSurf.(sec).(s).delta = ((data.cmpnt.cntrlSurf.(sec).(s).CDi * pi * data.cmpnt.cntrlSurf.(sec).AR)...
        / (data.cmpnt.cntrlSurf.(sec).(s).CL^2)) - 1;
    data.cmpnt.cntrlSurf.(sec).(s).e = 1 / (1 + data.cmpnt.cntrlSurf.(sec).(s).delta);
    data.cmpnt.cntrlSurf.(sec).(s).a = a0 / (1 + a0 / (pi * data.cmpnt.cntrlSurf.(sec).(s).e * data.cmpnt.cntrlSurf.(sec).AR));

case 'Tapered'
    %% GEOMETRY
    if data.cmpnt.cntrlSurf.(sec).AR == 0
        ct = data.cmpnt.cntrlSurf.(sec).xl * data.cmpnt.cntrlSurf.(sec).(s).taperR;
        data.cmpnt.cntrlSurf.(sec).(s).S = data.cmpnt.cntrlSurf.(sec).yl * (ct + data.cmpnt.cntrlSurf.(sec).xl) / 2;
        data.cmpnt.cntrlSurf.(sec).AR = data.cmpnt.cntrlSurf.(sec).yl^2 / data.cmpnt.cntrlSurf.(sec).(s).S;
    end
    data.cmpnt.cntrlSurf.(sec).(s).S = data.cmpnt.cntrlSurf.(sec).yl^2 / data.cmpnt.cntrlSurf.(sec).AR;
    data.cmpnt.cntrlSurf.(sec).(s).c = 2 * data.cmpnt.cntrlSurf.(sec).(s).S /...
        (data.cmpnt.cntrlSurf.(sec).yl * (1 + data.cmpnt.cntrlSurf.(sec).(s).taperR));
    ct = data.cmpnt.cntrlSurf.(sec).(s).c * data.cmpnt.cntrlSurf.(sec).(s).taperR;
    data.cmpnt.cntrlSurf.(sec).(s).cbar = data.cmpnt.cntrlSurf.(sec).(s).c * (2/3) * ...
        ((1 + data.cmpnt.cntrlSurf.(sec).(s).taperR + data.cmpnt.cntrlSurf.(sec).(s).taperR^2)...
        / (1 + data.cmpnt.cntrlSurf.(sec).(s).taperR));
    data.cmpnt.cntrlSurf.(sec).xl = data.cmpnt.cntrlSurf.(sec).(s).cbar;

    %% AERO CALCS
    grad = (data.cmpnt.cntrlSurf.(sec).(s).c - ct)/(data.cmpnt.cntrlSurf.(sec).yl / 2);
    
    nStore = 1:4;
    eq = zeros(4, 4);
    for n = nStore
        theta = n * pi/8;
        y = - (data.cmpnt.cntrlSurf.(sec).yl / 2) * cos(theta);
        chord = y * grad + data.cmpnt.cntrlSurf.(sec).(s).c;
        c(n, 1) = (pi*(rad(data.cmpnt.cntrlSurf.(sec).(s).alpha)-rad(data.cmpnt.cntrlSurf.(sec).alphaL0))*chord)...
            / (2 * data.cmpnt.cntrlSurf.(sec).yl);
        for p = nStore
            nV = 2 * p - 1;
            eq(n, p) = sin(theta * nV) * (1 + (nV * pi * chord)/(2 * data.cmpnt.cntrlSurf.(sec).yl * sin(theta)));
        end
    end
    An = eq\c;
    
    data.cmpnt.cntrlSurf.(sec).(s).CL = An(1) * pi * data.cmpnt.cntrlSurf.(sec).AR;
    data.cmpnt.cntrlSurf.(sec).(s).CDi = pi * data.cmpnt.cntrlSurf.(sec).AR * An(1)^2 * ...
        (1 + 3 * (An(2) / An(1))^2 + 5 * (An(3) / An(1))^2 + 7 * (An(4) / An(1))^2);
    
    data.cmpnt.cntrlSurf.(sec).(s).delta = ((data.cmpnt.cntrlSurf.(sec).(s).CDi * pi * data.cmpnt.cntrlSurf.(sec).AR)...
        / (data.cmpnt.cntrlSurf.(sec).(s).CL^2)) - 1;
    data.cmpnt.cntrlSurf.(sec).(s).e = 1 / (1 + data.cmpnt.cntrlSurf.(sec).(s).delta);
    data.cmpnt.cntrlSurf.(sec).(s).a = a0 / (1 + a0 / (pi * data.cmpnt.cntrlSurf.(sec).(s).e * data.cmpnt.cntrlSurf.(sec).AR));

case 'Triangular'
    %% GEOMETRY
    if data.cmpnt.cntrlSurf.(sec).AR == 0
        ct = data.cmpnt.cntrlSurf.(sec).xl * data.cmpnt.cntrlSurf.(sec).(s).taperR;
        data.cmpnt.cntrlSurf.(sec).(s).S = data.cmpnt.cntrlSurf.(sec).zl * (ct + data.cmpnt.cntrlSurf.(sec).xl) / 2;
        data.cmpnt.cntrlSurf.(sec).AR = data.cmpnt.cntrlSurf.(sec).zl^2 / data.cmpnt.cntrlSurf.(sec).(s).S;
    end
    data.cmpnt.cntrlSurf.(sec).(s).S = data.cmpnt.cntrlSurf.(sec).zl^2 / data.cmpnt.cntrlSurf.(sec).AR;
    data.cmpnt.cntrlSurf.(sec).(s).c = 2 * data.cmpnt.cntrlSurf.(sec).(s).S /...
        (data.cmpnt.cntrlSurf.(sec).zl * (1 + data.cmpnt.cntrlSurf.(sec).(s).taperR));
    ct = data.cmpnt.cntrlSurf.(sec).(s).c * data.cmpnt.cntrlSurf.(sec).(s).taperR;
    data.cmpnt.cntrlSurf.(sec).(s).cbar = data.cmpnt.cntrlSurf.(sec).(s).c * (2/3) * ...
        ((1 + data.cmpnt.cntrlSurf.(sec).(s).taperR + data.cmpnt.cntrlSurf.(sec).(s).taperR^2)...
        / (1 + data.cmpnt.cntrlSurf.(sec).(s).taperR));
    data.cmpnt.cntrlSurf.(sec).xl = data.cmpnt.cntrlSurf.(sec).(s).cbar;

    %% AERO CALCS
    grad = (data.cmpnt.cntrlSurf.(sec).(s).c - ct)/(data.cmpnt.cntrlSurf.(sec).zl / 2);
    
    nStore = 1:4;
    eq = zeros(4, 4);
    for n = nStore
        theta = n * pi/8;
        y = - (data.cmpnt.cntrlSurf.(sec).zl / 2) * cos(theta);
        chord = y * grad + data.cmpnt.cntrlSurf.(sec).(s).c;
        c(n, 1) = (pi*(rad(data.cmpnt.cntrlSurf.(sec).(s).alpha)-rad(data.cmpnt.cntrlSurf.(sec).alphaL0))*chord)...
            / (2 * data.cmpnt.cntrlSurf.(sec).zl);
        for p = nStore
            nV = 2 * p - 1;
            eq(n, p) = sin(theta * nV) * (1 + (nV * pi * chord)/(2 * data.cmpnt.cntrlSurf.(sec).zl * sin(theta)));
        end
    end
    An = eq\c;
    
    data.cmpnt.cntrlSurf.(sec).(s).CL = An(1) * pi * data.cmpnt.cntrlSurf.(sec).AR;
    data.cmpnt.cntrlSurf.(sec).(s).CDi = pi * data.cmpnt.cntrlSurf.(sec).AR * An(1)^2 * ...
        (1 + 3 * (An(2) / An(1))^2 + 5 * (An(3) / An(1))^2 + 7 * (An(4) / An(1))^2);
    
    data.cmpnt.cntrlSurf.(sec).(s).delta = ((data.cmpnt.cntrlSurf.(sec).(s).CDi * pi * data.cmpnt.cntrlSurf.(sec).AR)...
        / (data.cmpnt.cntrlSurf.(sec).(s).CL^2)) - 1;
    data.cmpnt.cntrlSurf.(sec).(s).e = 1 / (1 + data.cmpnt.cntrlSurf.(sec).(s).delta);
    data.cmpnt.cntrlSurf.(sec).(s).a = a0 / (1 + a0 / (pi * data.cmpnt.cntrlSurf.(sec).(s).e * data.cmpnt.cntrlSurf.(sec).AR));
    
case 'Elliptical'
    %% GEOMETRY
    if data.cmpnt.cntrlSurf.(sec).AR == 0
        data.cmpnt.cntrlSurf.(sec).S = pi * data.cmpnt.cntrlSurf.(sec).yl / 2 * data.cmpnt.cntrlSurf.(sec).xl / 2;
        data.cmpnt.cntrlSurf.(sec).AR = data.cmpnt.cntrlSurf.(sec).yl^2 / data.cmpnt.cntrlSurf.(sec).(s).S;
    end
    data.cmpnt.cntrlSurf.(sec).(s).S = data.cmpnt.cntrlSurf.(sec).yl^2 / data.cmpnt.cntrlSurf.(sec).AR;
    data.cmpnt.cntrlSurf.(sec).(s).c = 4 * data.cmpnt.cntrlSurf.(sec).(s).S / (data.cmpnt.cntrlSurf.(sec).yl * pi);
    data.cmpnt.cntrlSurf.(sec).(s).cbar = 0.785 * data.cmpnt.cntrlSurf.(sec).(s).c * data.cmpnt.cntrlSurf.(sec).yl;
    data.cmpnt.cntrlSurf.(sec).xl = data.cmpnt.cntrlSurf.(sec).(s).cbar;

    %% AERO CALCS
    data.cmpnt.cntrlSurf.(sec).(s).a = a0 / (1 + a0 / (pi * data.cmpnt.cntrlSurf.(sec).AR));
    
    data.cmpnt.cntrlSurf.(sec).(s).CL = data.cmpnt.cntrlSurf.(sec).(s).a *...
        (rad(data.cmpnt.cntrlSurf.(sec).(s).alpha) - rad(data.cmpnt.cntrlSurf.(sec).alphaL0));
    data.cmpnt.cntrlSurf.(sec).(s).CDi = data.cmpnt.cntrlSurf.(sec).(s).CL^2 / (2 * data.cmpnt.cntrlSurf.(sec).AR);
    data.cmpnt.cntrlSurf.(sec).(s).delta = 0;
    data.cmpnt.cntrlSurf.(sec).(s).e = 1;
end

return;
