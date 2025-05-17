function PlotAircraftSideView(data, ax, x_limits)

if isempty(ax)
    figure;
    ax = gca;
end

hold(ax, 'on');
axis(ax, 'equal');
grid(ax, 'on');
xlabel(ax, 'Aircraft Length', 'Interpreter', 'latex');
ylabel(ax, 'Aircraft Height', 'Interpreter', 'latex');
title(ax, 'Aircraft Geometry', 'Interpreter', 'latex');

type1 = fieldnames(data.cmpnt);
for i1 = 1:length(type1)
    sec1 = type1{i1};
    type2 = fieldnames(data.cmpnt.(sec1));
    for i2 = 1:length(type2)
        sec2 = type2{i2};
        if sec1 == "cntrlSurf"
            colour = 'b';
        elseif sec1 == "payload"
            colour = 'c';
        elseif sec2 == "fuselarge"
            colour = [0.6, 0.6, 0.6];
        else
            colour = 'g';
        end
        if sec2 == "Vstab"
            [xv, yv] = VTriangularPlot(data, sec2);
            fill(ax, xv, yv, 'b', 'FaceAlpha', 0.5);
        else
            rectangle(ax, 'Position', [data.cmpnt.(sec1).(sec2).x - data.cmpnt.(sec1).(sec2).xl/2, ...
                                        data.cmpnt.(sec1).(sec2).z - data.cmpnt.(sec1).(sec2).zl/2, ...
                                        data.cmpnt.(sec1).(sec2).xl, ...
                                        data.cmpnt.(sec1).(sec2).zl], ...
                                        'FaceColor', colour);
        end
    end
end

xlim(ax, x_limits);
hold(ax, 'off')
end