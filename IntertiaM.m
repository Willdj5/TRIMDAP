function [data] = IntertiaM(data)

I = zeros(3, 3);

type1 = fieldnames(data.cmpnt);

for i1 = 1:length(type1)

    x = type1{i1};
    type2 = fieldnames(data.cmpnt.(x));

    for i2 = 1:length(type2)
        y = type2{i2};
        
        x_dist = abs(data.cmpnt.(x).(y).x - data.hc);
        y_dist = abs(data.cmpnt.(x).(y).y);
        z_dist = abs(data.cmpnt.(x).(y).z);
        
        mass = data.cmpnt.(x).(y).m;
        
        Ixx = mass * x_dist;
        Iyy = mass * y_dist;
        Izz = mass * z_dist;
        
        % Add to the overall matrix
        I(1, 1) = I(1, 1) + Ixx;
        I(2, 2) = I(2, 2) + Iyy;
        I(3, 3) = I(3, 3) + Izz;
    end
end

data.I = I;

display(data.I)
return