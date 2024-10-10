function modify_gNB_conf(scs, bandwidth)
    % Function to modify gNB-OAI parameters in the gNB_v3_n77_working_backup.conf file
    % based on the given subcarrier spacing (scs) and bandwidth.
    
    % Read the original configuration file
    configFile = 'gNB_v3_n77_working_backup.conf';
    fid = fopen(configFile, 'r');
    if fid == -1
        error('Cannot open the configuration file: %s', configFile);
    end
    configContent = textscan(fid, '%s', 'Delimiter', '\n', 'Whitespace', '');
    fclose(fid);
    configContent = configContent{1};

    % Calculate the number of PRBs (n_rb) based on the bandwidth and scs
    %n_rb = floor(bandwidth * 1e6 / (scs * 12 * 1e3));
    
    para = calculate_nrbs(scs,bandwidth);
        n_rb = para.n_rb; % Example value for 40 MHz with SCS=15kHz
        dl_subcarrierSpacing = para.dl_subcarrierSpacing ;
        initialDLBWPsubcarrierSpacing = para.initialDLBWPsubcarrierSpacing;
        ul_subcarrierSpacing = para.ul_subcarrierSpacing;
        initialULBWPsubcarrierSpacing = para.initialULBWPsubcarrierSpacing;
        msg1_SubcarrierSpacing = para.msg1_SubcarrierSpacing ;
        subcarrierSpacing = para.subcarrierSpacing;
        referenceSubcarrierSpacing = para.referenceSubcarrierSpacing;
        dl_carrierBandwidth = para.dl_carrierBandwidth ;
        ul_carrierBandwidth = para.ul_carrierBandwidth;
    % Convert the bandwidth to ARFCN for carrier bandwidth calculation
    dl_carrierBandwidth = n_rb;
    ul_carrierBandwidth = dl_carrierBandwidth;  % TDD assumes DL = UL bandwidth
    
    % Calculate initial BWP location and bandwidth using the RIV formula
    N_BWP_size = 275;  % Assuming a maximum BWP size
    RB_start = 0;  % Assuming starting from 0
    L_RB_r = n_rb;
    
    if (L_RB_r - 1) <= floor(N_BWP_size / 2)
        initialDLBWPlocationAndBandwidth = N_BWP_size * (L_RB_r - 1) + RB_start;
        initialULBWPlocationAndBandwidth = initialDLBWPlocationAndBandwidth;
    else
        initialDLBWPlocationAndBandwidth = N_BWP_size * (N_BWP_size - L_RB_r + 1) + (N_BWP_size - 1 - RB_start);
        initialULBWPlocationAndBandwidth = initialDLBWPlocationAndBandwidth;
    end
    
    % Define absolute frequency calculations
    offsetToPointA = 0;  % offset of 3RB
    Kssb = 0;            % 10 RB
    absoluteFrequencyPointA = 3935.640;  % Example ARFCN, modify as needed (it was 3600 in last example)
    %absoluteFrequencySSB = absoluteFrequencyPointA + ...
      %  (10 * 12 * scs / 1000) + offsetToPointA * 12 * 15 / 1000 + Kssb * 15 / 1000;
    absoluteFrequencySSB = absoluteFrequencyPointA + (12*scs*dl_carrierBandwidth/2e3) ;
    %    (10 * 12 * scs / 1000) + offsetToPointA * 12 * 15 / 1000 + Kssb * 15 / 1000;
    absoluteFrequencySSB = frequencyToARFCN(absoluteFrequencySSB);
    %initialDLBWPlocationAndBandwidth = frequencyToARFCN(initialDLBWPlocationAndBandwidth);
    %initialULBWPlocationAndBandwidth = frequencyToARFCN(initialULBWPlocationAndBandwidth);
    absoluteFrequencyPointA = frequencyToARFCN(absoluteFrequencyPointA);
    % Prepare the parameter modification array
    paramsToModify = {
        'absoluteFrequencySSB', sprintf('%d', absoluteFrequencySSB);
        'dl_carrierBandwidth', sprintf('%d', dl_carrierBandwidth);
        'initialDLBWPlocationAndBandwidth', sprintf('%d', initialDLBWPlocationAndBandwidth);
        'initialULBWPlocationAndBandwidth', sprintf('%d', initialULBWPlocationAndBandwidth);
        'dl_absoluteFrequencyPointA', sprintf('%d', absoluteFrequencyPointA);
        'ul_carrierBandwidth', sprintf('%d', ul_carrierBandwidth);
        'dl_subcarrierSpacing', sprintf('%d', dl_subcarrierSpacing);
        'initialDLBWPsubcarrierSpacing', sprintf('%d', initialDLBWPsubcarrierSpacing);
        'ul_subcarrierSpacing', sprintf('%d', ul_subcarrierSpacing);
        'initialULBWPsubcarrierSpacing', sprintf('%d', initialULBWPsubcarrierSpacing);
        'msg1_SubcarrierSpacing', sprintf('%d', msg1_SubcarrierSpacing);
        'subcarrierSpacing', sprintf('%d', subcarrierSpacing);
        'referenceSubcarrierSpacing', sprintf('%d', referenceSubcarrierSpacing)
    };

    % Update the configuration content
    for i = 1:length(configContent)
        line = configContent{i};
        for j = 1:size(paramsToModify, 1)
            paramName = paramsToModify{j, 1};
            if contains(line, paramName)
                configContent{i} = sprintf('%s = %s;', paramName, paramsToModify{j, 2});
                break;
            end
        end
    end

    % Write the modified content to a new configuration file
    newConfigFile = 'gNB.conf';
    fid = fopen(newConfigFile, 'w');
    if fid == -1
        error('Cannot open the output file: %s', newConfigFile);
    end
    fprintf(fid, '%s\n', configContent{:});
    fclose(fid);

    disp('Modified gNB.conf file generated successfully.');
end
