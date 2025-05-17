function PlotAircraftTopView(data, ax)

if isempty(ax)
    figure;
    ax = gca;
end

hold(ax, 'on');
axis(ax, 'equal');
grid(ax, 'on');
xlabel(ax, 'Aircraft Length', 'Interpreter', 'latex');
ylabel(ax, 'Aircraft Width', 'Interpreter', 'latex');
title(ax, 'Aircraft Geometry', 'Interpreter', 'latex');

type1 = fieldnames(data.cmpnt);
for i1 = 1:length(type1)
    sec1 = type1{i1};
    type2 = fieldnames(data.cmpnt.(sec1));
    for i2 = 1:length(type2)
        sec2 = type2{i2};
        if sec1 == "cntrlSurf"
            switch data.use.(sec2)
                case "Tapered"
                    [xv, yv] = TaperedPlot(data, sec2);
                case "Elliptical"
                    [xv, yv] = EllipsePlot(data, sec2);
                case {"Rectangular", "Triangular"}
                    [xv, yv] = RectanglePlot(data, sec2);
            end
            fill(ax, xv, yv, 'b', 'FaceAlpha', 0.5);
        else
            if sec1 == "payload"
                colour = 'c';
            elseif sec2 == "fuselarge"
                colour = [0.6, 0.6, 0.6];
            else
                colour = 'g';
            end
            rectangle(ax, ...
                'Position', [data.cmpnt.(sec1).(sec2).x - data.cmpnt.(sec1).(sec2).xl/2, ...
                             data.cmpnt.(sec1).(sec2).y - data.cmpnt.(sec1).(sec2).yl/2, ...
                             data.cmpnt.(sec1).(sec2).xl, ...
                             data.cmpnt.(sec1).(sec2).yl], ...
                'FaceColor', colour);
        end
    end
end

% CG, AC, Manoeuvre Point, Neutral Point
PoleCirclePlot(data.hc, 0, 'r', ax);
PoleCirclePlot(data.h0c, 0, 'b', ax);
PoleCirclePlot(data.stabcon.hm * data.stabcon.cbar, 0, 'g', ax);
PoleCirclePlot(data.stabcon.hn * data.stabcon.cbar, 0, 'y', ax);

xlim(ax); % Update x-limits if needed

hold(ax, 'off');
end