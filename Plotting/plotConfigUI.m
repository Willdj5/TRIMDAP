function plotConfigUI(fig, data, configName)

screenSize = get(0, 'ScreenSize');
screenWidth = screenSize(3) - 100;
screenHeight = screenSize(4) - 100;

%% Main aircraft top view
ax_top = uiaxes(fig, 'Position', [screenWidth * 0.03,...
                                  screenHeight * 0.17...
                                  screenWidth * 0.2,...
                                  screenWidth * 0.2]);

PlotAircraftTopView(data, ax_top)

x_limits = xlim(ax_top);

%% Side View
ax_side = uiaxes(fig, 'Position', [screenWidth * 0.03,...
                                   screenHeight * 0.55...
                                   screenWidth * 0.2,...
                                   screenWidth * 0.2]);

PlotAircraftSideView(data, ax_side, x_limits)

%% Wing AoA vs CL
ax_aoa_wing = uiaxes(fig, 'Position', [screenWidth * 0.25,...
                                       screenHeight * 0.5...
                                       screenWidth * 0.135,...
                                       screenWidth * 0.135]);

PlotAoAvsCL(data, ax_aoa_wing, 'wing')

ax_aoa_tail = uiaxes(fig, 'Position', [screenWidth * 0.4,...
                                       screenHeight * 0.5...
                                       screenWidth * 0.135,...
                                       screenWidth * 0.135]);

PlotAoAvsCL(data, ax_aoa_tail, 'tail')

%% Elevator Trim vs Velocity
ax_eta_v = uiaxes(fig, 'Position', [screenWidth * 0.25,...
                                    screenHeight * 0.75...
                                    screenWidth * 0.135,...
                                    screenWidth * 0.135]);
plot(ax_eta_v, data.stabcon.vStore, deg(data.stabcon.etaBarStore), 'b-', 'LineWidth', 1);
yline(ax_eta_v, 0, 'k--');
xlabel(ax_eta_v, 'Velocity (v)', 'Interpreter', 'latex');
ylabel(ax_eta_v, '$\bar{\delta_e}$', 'Interpreter', 'latex');
title(ax_eta_v, 'Plot of $\bar{\delta_e}$ vs Velocity', 'Interpreter', 'latex');
grid(ax_eta_v, 'on');

%% Elevator Angle for G Pull
ax_eta_g = uiaxes(fig, 'Position', [screenWidth * 0.4,...
                                    screenHeight * 0.75...
                                    screenWidth * 0.135,...
                                    screenWidth * 0.135]);
plot(ax_eta_g, data.stabcon.nStore, deg(data.stabcon.getaStore), 'r-', 'LineWidth', 1);
yline(ax_eta_g, 0, 'k--');
xlabel(ax_eta_g, '$n$ Pull', 'Interpreter', 'latex');
ylabel(ax_eta_g, '$\Delta \bar{\delta_e}$', 'Interpreter', 'latex');
title(ax_eta_g, 'Plot of $\Delta \bar{\delta_e}$ vs n', 'Interpreter', 'latex');
grid(ax_eta_g, 'on');

%% Scissor Plot
ax_scissor = uiaxes(fig, 'Position', [screenWidth * 0.25,...
                                      screenHeight * 0.0...
                                      screenWidth * 0.25,...
                                      screenWidth * 0.25]);
hold(ax_scissor, 'on');

plot(ax_scissor, data.stabcon.hStore, data.stabcon.VbarStore1, 'r-', 'LineWidth', 1, 'DisplayName', 'Kn');
plot(ax_scissor, data.stabcon.hStore, data.stabcon.VbarStore2, 'b-', 'LineWidth', 1, 'DisplayName', 'Take Off');
plot(ax_scissor, data.stabcon.hStore, data.stabcon.VbarStore3, 'g-', 'LineWidth', 1, 'DisplayName', 'Landing');
hR = data.cmpnt.sec.landing1.x / data.stabcon.cbar;
xline(ax_scissor, hR, 'm-', 'LineWidth', 1, 'DisplayName', 'Nose Wheel');
% Add 5% buffer lines (dashed versions)
plot(ax_scissor, 0.95 * data.stabcon.hStore, 0.95 * data.stabcon.VbarStore1, 'r--', 'LineWidth', 1, 'DisplayName', 'Kn +5%');
plot(ax_scissor, 1.05 * data.stabcon.hStore, 1.05 * data.stabcon.VbarStore2, 'b--', 'LineWidth', 1, 'DisplayName', 'Take Off +5%');
plot(ax_scissor, 0.95 * data.stabcon.hStore, 0.95 * data.stabcon.VbarStore3, 'g--', 'LineWidth', 1, 'DisplayName', 'Landing +5%');
hRbuff = hR*0.95;
xline(ax_scissor, hRbuff, 'm--', 'LineWidth', 1, 'DisplayName', 'Nose Wheel +5%');

yline(ax_scissor, data.stabcon.Vbar, '--', 'LineWidth', 1, 'Color', [1, 0.647, 0], 'DisplayName', 'Vbar');
xlabel(ax_scissor, 'h', 'Interpreter', 'latex');
ylabel(ax_scissor, '$\overline{V}$', 'Interpreter', 'latex');
title(ax_scissor, 'Scissor Plot', 'Interpreter', 'latex');
legend(ax_scissor, 'show', 'Location', 'best');
grid(ax_scissor, 'on');

%% UI Text Area for Summary
summaryArea = uitextarea(fig, ...
    'Position', [screenWidth * 0.57,...
                 screenHeight * 0.05...
                 screenWidth * 0.4,...
                 screenHeight * 0.9], ...
    'Editable', false, ...
    'FontSize', 10);

lines = TextOut(data, configName);

summaryArea.Value = lines;

end