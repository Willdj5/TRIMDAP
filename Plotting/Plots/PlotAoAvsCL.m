function PlotAoAvsCL(data, ax, type)

if isempty(ax)
    figure;
    ax = gca;
end

legendEntries = cell(1, length(data.planform) + 1);

hold(ax, 'on');
for i = 1:length(data.planform)
    s = data.planform{i};
    plot(ax, data.aeroData.(type).(s).alphaStore * 180/pi, data.aeroData.(type).(s).CLStore, 'LineWidth', 1);
    legendEntries{i} = s;
end
plot(ax, data.aeroData.(type).(s).alphaStore * 180/pi, data.aeroData.(type).infinite.CLStore, 'LineWidth', 1);
legendEntries{end} = 'infinite';

yline(ax, 0, 'k--');
xlabel(ax, '$\alpha$', 'Interpreter', 'latex');
ylabel(ax, '$C_{L}$', 'Interpreter', 'latex');
title(ax, sprintf('%s', type), 'Interpreter', 'latex');
legend(ax, legendEntries, 'Interpreter', 'latex', 'Location', 'best');
grid(ax, 'on');
hold(ax, 'off')

end