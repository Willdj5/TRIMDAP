function [data] = AeroPlot(data)

type2 = fieldnames(data.cmpnt.cntrlSurf);
for i1 = 1:length(type2)
    x = type2{i1};

    for i2 = 1:length(data.planform)
        s = data.planform{i2};
        
        data.cmpnt.cntrlSurf.(x).(s).alpha = 0.01; % in degrees
        data.cmpnt.cntrlSurf.(x).(s).taperR = 0.5;

        data = AeroDynamics(data, x, s);

        data.(x).(s).alphaStore = -20*pi/180:1*pi/180:20*pi/180;
        data.(x).(s).CLStore = zeros(size(data.(x).(s).alphaStore));
        for a = 1:length(data.(x).(s).alphaStore)
            data.(x).(s).CLStore(a) = data.cmpnt.cntrlSurf.(x).(s).a...
                * (data.(x).(s).alphaStore(a) - rad(data.cmpnt.cntrlSurf.(x).alphaL0));
        end
    end
    for a = 1:length(data.(x).(s).alphaStore)
        data.(x).infinite.CLStore(a) = data.cmpnt.cntrlSurf.(x).a0...
        * (data.(x).(s).alphaStore(a) - rad(data.cmpnt.cntrlSurf.(x).alphaL0));
    end

    [~, ~, ~, rho1] = atmosisa(data.stage.dash.altft);
    
    data.cmpnt.cntrlSurf.(x).LiftMax = data.cmpnt.cntrlSurf.(x).(data.use.(x)).a * (rad(1.2) - rad(data.cmpnt.cntrlSurf.(x).alphaL0))...
        * 0.5 * rho1 * data.stage.dash.v^2 * data.cmpnt.cntrlSurf.(x).(s).S * cosd(data.cmpnt.cntrlSurf.(x).alphaSwitch);
    
end

end