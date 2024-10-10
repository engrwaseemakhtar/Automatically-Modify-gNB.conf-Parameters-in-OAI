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

% Input parameters
band = input('Enter band (n77, n78, n42): ', 's');
bandwidth_mhz = input('Enter bandwidth in MHz (40, 30, 25, 20, 15, 10): ');
subcarrier_spacing_khz = input('Enter subcarrier spacing in kHz (15, 30, 60): ');

% Get band parameters
[start_freq, end_freq, start_arfcn, end_arfcn] = get_band_params(band);

% Set step size based on subcarrier spacing
step_size = subcarrier_spacing_khz / 15;

% Function to convert ARFCN to frequency in MHz
arfcn_to_freq = @(arfcn) 3000 + 0.015 * (arfcn - 600000);

% Initialize array to store valid ARFCNs
valid_arfcns = [];

% Loop through possible ARFCNs
for arfcn = start_arfcn:step_size:end_arfcn
    freq_mhz = arfcn_to_freq(arfcn);
    
    % Check if the frequency + bandwidth is within the band limits
    if freq_mhz >= start_freq && freq_mhz + bandwidth_mhz <= end_freq
        valid_arfcns = [valid_arfcns, arfcn];
    end
end

% Display results
fprintf('Valid ARFCNs for NR band %s (%d MHz bandwidth, %d kHz subcarrier spacing):\n', ...
    band, bandwidth_mhz, subcarrier_spacing_khz);
fprintf('Total number of valid ARFCNs: %d\n', length(valid_arfcns));
fprintf('First valid ARFCN: %d\n', valid_arfcns(1));
fprintf('Last valid ARFCN: %d\n', valid_arfcns(end));

% Display all valid ARFCNs
fprintf('All valid ARFCNs:\n');
fprintf('%d ', valid_arfcns);
fprintf('\n');

% Optionally, save the results to a file
filename = sprintf('valid_arfcns_%s_%dmhz_%dkhz.csv', band, bandwidth_mhz, subcarrier_spacing_khz);
dlmwrite(filename, valid_arfcns', 'delimiter', '\n');
fprintf('Results saved to %s\n', filename);