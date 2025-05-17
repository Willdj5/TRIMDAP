function plotConfig(data)

PlotAircraftTopView(data, [])

x_limits = xlim;

PlotAircraftSideView(data, [], x_limits)

PlotAoAvsCL(data, [], 'wing')

PlotAoAvsCL(data, [], 'tail')

%% ELEVATOR ANGLE TO TRIM
figure;
plot(data.stabcon.vStore, deg(data.stabcon.etaBarStore), 'k-', 'LineWidth', 1);
yline(0, 'k--', 'LineWidth', 1);
xlabel('Velocity (v)', 'Interpreter', 'latex');
ylabel('$\bar{\delta_e}$', 'Interpreter', 'latex');
title('Plot of $\bar{\delta_e}$ vs Velocity', 'Interpreter', 'latex');
grid on;

%% ELEVATOR ANGLE FOR A G PULL
figure;
plot(data.stabcon.nStore, deg(data.stabcon.getaStore), 'k-', 'LineWidth', 1);
yline(0, 'k--', 'LineWidth', 1);
xlabel('$n$ Pull', 'Interpreter', 'latex');
ylabel('$\Delta \bar{\delta_e}$', 'Interpreter', 'latex');
title('Plot of $\Delta \bar{\delta_e}$ vs n', 'Interpreter', 'latex');
grid on;

%% SCISSOR PLOT
figure;

hold on;

plot(data.stabcon.hStore, data.stabcon.VbarStore1, 'r-', 'LineWidth', 1, 'DisplayName', 'Kn');
plot(data.stabcon.hStore, data.stabcon.VbarStore2, 'b-', 'LineWidth', 1, 'DisplayName', 'Take Off');
plot(data.stabcon.hStore, data.stabcon.VbarStore3, 'g-', 'LineWidth', 1, 'DisplayName', 'Landing');
hR = data.cmpnt.sec.landing1.x / data.stabcon.cbar;
xline(hR, 'm-', 'LineWidth', 1, 'DisplayName', 'Nose Wheel');
% Add 5% buffer lines (dashed versions)
plot(0.95 * data.stabcon.hStore, 0.95 * data.stabcon.VbarStore1, 'r--', 'LineWidth', 1, 'DisplayName', 'Kn +5%');
plot(1.05 * data.stabcon.hStore, 1.05 * data.stabcon.VbarStore2, 'b--', 'LineWidth', 1, 'DisplayName', 'Take Off +5%');
plot(0.95 * data.stabcon.hStore, 0.95 * data.stabcon.VbarStore3, 'g--', 'LineWidth', 1, 'DisplayName', 'Landing +5%');
hRbuff = hR*0.95;
xline(hRbuff, 'm--', 'LineWidth', 1, 'DisplayName', 'Nose Wheel +5%');

yline(data.stabcon.Vbar, '--', 'LineWidth', 1, 'Color', [1, 0.647, 0], 'DisplayName', 'Vbar');
xlabel('h', 'Interpreter', 'latex');
ylabel('$\overline{V}$', 'Interpreter', 'latex');
title('Scissor Plot', 'Interpreter', 'latex');
legend('show', 'Location', 'best');

grid on;

hold off;