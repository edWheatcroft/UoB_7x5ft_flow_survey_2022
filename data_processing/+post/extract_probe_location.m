function res = extract_probe_location(res)
%EXTRACT_PROBE_LOCATION Summary of this function goes here
%   Detailed explanation goes here
for i = 1:length(res)
    % get estimate for deflection
    func = @(x)x;
    gain = 0.07/func(1.02);
    deflection = gain*func(abs(res(i).Radius)/1000)*1000;
    loc = [0 0 -res(i).Radius]' + deflection*[0 sind(res(i).Roll) 0]';
    probe_loc = fh.rotx(-res(i).Roll)*loc;
    res(i).y = probe_loc(2);
    res(i).z = probe_loc(3);
end
end

