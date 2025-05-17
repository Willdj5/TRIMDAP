function plotAllData(configs, defaultConfigName)
configNames = fieldnames(configs);

screenSize = get(0, 'ScreenSize');
screenWidth = screenSize(3) - 100;
screenHeight = screenSize(4) - 100;

fig = uifigure('Name', 'Aircraft Config Plot', 'Position', [0, 0, screenWidth, screenHeight]);

% Define the update function
function updatePlots(configName)
    data = configs.(configName).data;

    clf(fig);  % Clear all existing UI components
    dd = uidropdown(fig, ...
        'Items', configNames, ...
        'Value', configName, ...
        'Position', [screenWidth * 0.03, screenHeight * 0.92, 200, 30], ...
        'ValueChangedFcn', @(dd, event) updatePlots(dd.Value));

    btn = uibutton(fig, ...
        'Text', 'Output Graphs', ...
        'Position', [screenWidth * 0.16, screenHeight * 0.92, 150, 30], ...
        'ButtonPushedFcn', @(btn, event) plotConfig(configs.(configName).data));

    plotConfigUI(fig, data, configName); % Recursive call is safe here since we reset the figure

end

% Initial plot
updatePlots(defaultConfigName);
end