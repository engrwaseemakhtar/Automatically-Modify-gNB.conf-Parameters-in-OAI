% Function to get band parameters
function [start_freq, end_freq, start_arfcn, end_arfcn] = get_band_params(band)
    switch band
        case 'n77'
            start_freq = 3300; end_freq = 4200;
            start_arfcn = 620000; end_arfcn = 680000;
        case 'n78'
            start_freq = 3300; end_freq = 3800;
            start_arfcn = 620000; end_arfcn = 653333;
        case 'n42'
            start_freq = 3400; end_freq = 3600;
            start_arfcn = 626667; end_arfcn = 640000;
        otherwise
            error('Unsupported band');
    end
end

% Function to convert ARFCN to frequency in MHz
function freq_mhz = arfcn_to_freq(arfcn)
    freq_mhz = 3000 + 0.015 * (arfcn - 600000);
end

% Function to calculate GSCN
function gscn = calculate_gscn(freq_mhz)
    gscn = floor((freq_mhz - 3000) / 1.44) + 7499;
end

% Input parameters
band = input('Enter band (n77, n78, n42): ', 's');
bandwidth_mhz = input('Enter bandwidth in MHz (40, 30, 25, 20, 15, 10): ');
subcarrier_spacing_khz = input('Enter subcarrier spacing in kHz (15, 30, 60): ');

% Get band parameters
[start_freq, end_freq, start_arfcn, end_arfcn] = get_band_params(band);

% Set step size based on subcarrier spacing
step_size = subcarrier_spacing_khz / 15;

% Initialize arrays to store valid ARFCNs and GSCNs
valid_arfcns = [];
valid_gscns = [];

% Loop through possible ARFCNs
for arfcn = start_arfcn:step_size:end_arfcn
    freq_mhz = arfcn_to_freq(arfcn);
    
    % Check if the frequency + bandwidth is within the band limits
    if freq_mhz >= start_freq && freq_mhz + bandwidth_mhz <= end_freq
        valid_arfcns = [valid_arfcns, arfcn];
        valid_gscns = [valid_gscns, calculate_gscn(freq_mhz)];
    end
end

% Display results
fprintf('Valid ARFCNs and GSCNs for NR band %s (%d MHz bandwidth, %d kHz subcarrier spacing):\n', ...
    band, bandwidth_mhz, subcarrier_spacing_khz);
fprintf('Total number of valid ARFCNs/GSCNs: %d\n', length(valid_arfcns));
fprintf('First valid ARFCN: %d, GSCN: %d\n', valid_arfcns(1), valid_gscns(1));
fprintf('Last valid ARFCN: %d, GSCN: %d\n', valid_arfcns(end), valid_gscns(end));

% Display all valid ARFCNs and GSCNs
fprintf('All valid ARFCNs and GSCNs:\n');
for i = 1:length(valid_arfcns)
    fprintf('ARFCN: %d, GSCN: %d\n', valid_arfcns(i), valid_gscns(i));
end

% Save the results to a CSV file
filename = sprintf('valid_arfcns_gscns_%s_%dmhz_%dkhz.csv', band, bandwidth_mhz, subcarrier_spacing_khz);
fid = fopen(filename, 'w');
fprintf(fid, 'ARFCN,GSCN,Frequency(MHz)\n');
for i = 1:length(valid_arfcns)
    fprintf(fid, '%d,%d,%.3f\n', valid_arfcns(i), valid_gscns(i), arfcn_to_freq(valid_arfcns(i)));
end
fclose(fid);
fprintf('Results saved to %s\n', filename);

%% -------Use the following calculators to find the point A and SSB in
%%ARFCN--------%%
%  -----GSCN2ARFCN--------%
%    https://5g-tools.com/5g-nr-gscn-calculator/
%  -----ARFCN2pointA--------%
%    https://www.sqimway.com/nr_refA.php