function arfcn = frequencyToARFCN(frequency_mhz)
    % Convert frequency in MHz to ARFCN based on 3GPP TS 38.104 specifications

    % Define parameters based on frequency ranges
    if frequency_mhz >= 0 && frequency_mhz < 3000
        delta_f_global = 5; % kHz
        f_ref_offs = 0; % MHz
        n_ref_offs = 0;
    elseif frequency_mhz >= 3000 && frequency_mhz < 24250
        delta_f_global = 15; % kHz
        f_ref_offs = 3000; % MHz
        n_ref_offs = 600000;
    elseif frequency_mhz >= 24250 && frequency_mhz <= 100000
        delta_f_global = 60; % kHz
        f_ref_offs = 24250.08; % MHz
        n_ref_offs = 2016667;
    else
        error('Frequency out of range for 5G NR.');
    end

    % Calculate ARFCN
    arfcn = n_ref_offs + round((frequency_mhz - f_ref_offs) * 1e3 / delta_f_global);
end