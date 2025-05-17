function [data] = AeroControl(data)
% Checked

type2 = fieldnames(data.cmpnt.cntrlSurf);
for i1 = 1:length(type2)
    sec = type2{i1};
    s = data.use.(sec);
    
    data.cmpnt.cntrlSurf.(sec).(s).alpha = 0.01; % in degrees
    
    data = AeroDynamics(data, sec, s);
    
    [~, ~, ~, rho] = atmosisa(data.stage.(data.stage.current).altft);
    
    Lift = data.cmpnt.cntrlSurf.(sec).(s).CL * 0.5 * rho * data.stage.(data.stage.current).v^2 * data.cmpnt.cntrlSurf.(sec).(s).S;
    
    if isfield(data.cmpnt.cntrlSurf.(sec), 'Lift')
        while abs(abs(Lift) - abs(data.cmpnt.cntrlSurf.(sec).Lift)) >= 15
            data = AeroDynamics(data, sec, s);
            
            Lift = data.cmpnt.cntrlSurf.(sec).(s).CL * 0.5 * rho * data.stage.(data.stage.current).v^2 * data.cmpnt.cntrlSurf.(sec).(s).S;

            if data.cmpnt.cntrlSurf.(sec).Lift > Lift
                data.cmpnt.cntrlSurf.(sec).(s).alpha = data.cmpnt.cntrlSurf.(sec).(s).alpha + 0.01;
            else
                data.cmpnt.cntrlSurf.(sec).(s).alpha = data.cmpnt.cntrlSurf.(sec).(s).alpha - 0.01;
            end
        end
    else
        data.cmpnt.cntrlSurf.(sec).(s).alpha = 0.00;
    end

end

return