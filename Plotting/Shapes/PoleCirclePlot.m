function PoleCirclePlot(x, y, color, ax)

r = 0.1;
theta = linspace(0, 2*pi, 100);

xc = r * cos(theta) + x;
yc = r * sin(theta) + y;
if isempty(ax)
    plot(xc, yc, 'k', 'LineWidth', 2);
else
    plot(ax, xc, yc, 'k', 'LineWidth', 2);
end

theta1 = linspace(0, pi/2, 25);
theta2 = linspace(pi, 3*pi/2, 25);

xq1 = [x, r*cos(theta1) + x, x];
yq1 = [y, r*sin(theta1) + y, y];

if isempty(ax)
    fill(xq1, yq1, color, 'EdgeColor', 'none');
else
    fill(ax, xq1, yq1, color, 'EdgeColor', 'none');
end

xq2 = [x, r*cos(theta2) + x, x];
yq2 = [y, r*sin(theta2) + y, y];

if isempty(ax)
    fill(xq2, yq2, color, 'EdgeColor', 'none');
else
    fill(ax, xq2, yq2, color, 'EdgeColor', 'none');
end

end