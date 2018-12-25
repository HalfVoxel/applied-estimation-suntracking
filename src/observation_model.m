% function h = observation_model(S,W,j)
% This function is the implementation of the observation model
% The bearing should lie in the interval [-pi,pi)
% Inputs:
%           S           3XM %particles
% Outputs:  
%           h           1XM %expected sun height
function h = observation_model(S)
    assert(size(S,1) == 3, 'S has wrong dimensions');
    days_per_year = 365.2422;
    W = 2*pi/days_per_year; %orbital angular velocity, rad per day
    eccentricity = 0.0167; %orbital eccentricity
    axial_tilt = 23.43683; % in degrees
    time = S(1,:); %in fractional days e.g. 8.5 = 12:00 January 9
    latitude = S(2,:);
    
    
    %hour angle: pi minus the angle Earth has rotated since the start of the day
        %starts at pi at 00:00:00, ends at -pi at 23:59:59.999...
    omega = pi*(1 - 2*mod(time,1));
    A = W*(time+10); %orbital angle change since winter solstice in rad, 
                     %assuming circular orbit at average velocity
    %orbital angle change since winter solstice in rad, incl. eccentricity
    B = A + 2*eccentricity*sin(W*(time-2));
    %asin of declination of the sun w.r.t plane of rotation, incl. eccentricity
    sin_delta = sin(-axial_tilt*pi/180)*cos(B);
    
    %cos(theta) = sin(latitude)sin(delta) + cos(latitude)cos(delta)cos(omega)
    %= sin(latitude)sin_delta + cos(latitude)sqrt(1-sin_delta^2)cos(omega)
    sin_h = sin(latitude).*sin_delta + cos(latitude).*sqrt(1-sin_delta.^2).*cos(omega);
    h = asin(sin_h); %expected sun height in radians
end