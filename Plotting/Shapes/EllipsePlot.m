function [x, y] = EllipsePlot(data, s)
%   a      - Semi-major axis (horizontal radius)
%   b      - Semi-minor axis (vertical radius)
%   x_center - X-coordinate of the center of the ellipse
%   y_center - Y-coordinate of the center of the ellipse

a = data.cmpnt.cntrlSurf.(s).(data.use.(s)).c / 2;
totalwidth = data.cmpnt.cntrlSurf.(s).yl;
b = totalwidth / 2;
x_center = data.cmpnt.cntrlSurf.(s).x;
y_center = data.cmpnt.cntrlSurf.(s).y;

theta = linspace(0, 2*pi, 100);  % 100 points for smoothness

x = a * cos(theta) + x_center;  % X-coordinates
y = b * sin(theta) + y_center;  % Y-coordinates

return