function [x, y] = RectanglePlot(data, s)

width = data.cmpnt.cntrlSurf.(s).(data.use.(s)).c;
x_center = data.cmpnt.cntrlSurf.(s).x;
y_center = data.cmpnt.cntrlSurf.(s).y;

half_width = width / 2;

totalheight = data.cmpnt.cntrlSurf.(s).yl;
half_height = totalheight / 2;

% Define the rectangle corners based on the center
x = [x_center - half_width, x_center + half_width, x_center + half_width, x_center - half_width];
y = [y_center - half_height, y_center - half_height, y_center + half_height, y_center + half_height];

% Optionally, close the rectangle by repeating the first point
x = [x, x(1)];
y = [y, y(1)];

return