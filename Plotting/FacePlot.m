function [x1, y1, x2, y2] = FacePlot(data, s)

totalwidth = data.cmpnt.cntrlSurf.(s).b * cos(data.cmpnt.cntrlSurf.(s).gamma);
width = totalwidth / 2;
height = 0.1;
gamma = data.cmpnt.cntrlSurf.(s).gamma; % Rotation angle in degrees

% Define the first rectangle (rotating around bottom-left corner)
x1 = [0, width, width, 0];
y1 = [0, 0, height, height];

% Define the second rectangle (rotating around bottom-right corner)
x2 = [width, 0, 0, width];
y2 = [0, 0, height, height];

% Optionally, close the rectangles by repeating the first point
x1 = [x1, x1(1)];
y1 = [y1, y1(1)];
x2 = [x2, x2(1)];
y2 = [y2, y2(1)];

% Rotation matrices
R1 = [cos(gamma), -sin(gamma); sin(gamma), cos(gamma)]; % Rotate counterclockwise
R2 = [cos(-gamma), -sin(-gamma); sin(-gamma), cos(-gamma)]; % Rotate clockwise

% Apply rotations
coords1 = R1 * [x1; y1];
coords2 = R2 * [x2 - width; y2];
x1 = coords1(1, :);
y1 = coords1(2, :);
x2 = coords2(1, :);
y2 = coords2(2, :);

return