function para = calculate_nrbs(scs, cbw)
    % Function to determine the number of resource blocks (NRBs)
    % based on the subcarrier spacing (scs) and channel bandwidth (cbw).
    %
    % Inputs:
    %   scs - Subcarrier spacing in kHz
    %   cbw - Channel bandwidth in MHz

    % Initialize para structure
    para = struct();

    % Determine n_rb based on scs and cbw
    switch scs
        case 15
            switch cbw
                case 5
                    para.n_rb = 25;
                case 10
                    para.n_rb = 52;
                case 15
                    para.n_rb = 79;
                case 20
                    para.n_rb = 106;
                case 25
                    para.n_rb = 133;
                case 30
                    para.n_rb = 160;
                case 40
                    para.n_rb = 216;
                otherwise
                    error('Unsupported channel bandwidth for SCS=15kHz.');
            end
            para.dl_subcarrierSpacing = 0;
            para.initialDLBWPsubcarrierSpacing = 0;
            para.ul_subcarrierSpacing = 0;
            para.initialULBWPsubcarrierSpacing = 0;
            para.msg1_SubcarrierSpacing = 0;
            para.subcarrierSpacing = 0;
            para.referenceSubcarrierSpacing = 0;
            para.dl_carrierBandwidth = para.n_rb;
            para.ul_carrierBandwidth = para.n_rb;

        case 30
            switch cbw
                case 5
                    para.n_rb = 11;
                case 10
                    para.n_rb = 24;
                case 15
                    para.n_rb = 38;
                case 20
                    para.n_rb = 51;
                case 25
                    para.n_rb = 65;
                case 30
                    para.n_rb = 78;
                case 40
                    para.n_rb = 106;
                otherwise
                    error('Unsupported channel bandwidth for SCS=30kHz.');
            end
            para.dl_subcarrierSpacing = 1;
            para.initialDLBWPsubcarrierSpacing = 1;
            para.ul_subcarrierSpacing = 1;
            para.initialULBWPsubcarrierSpacing = 1;
            para.msg1_SubcarrierSpacing = 1;
            para.subcarrierSpacing = 1;
            para.referenceSubcarrierSpacing = 1;
            para.dl_carrierBandwidth = para.n_rb;
            para.ul_carrierBandwidth = para.n_rb;

        case 60
            switch cbw
                case 5
                    para.n_rb = 11;
                case 10
                    para.n_rb = 24;
                case 15
                    para.n_rb = 38;
                case 20
                    para.n_rb = 51;
                case 25
                    para.n_rb = 65;
                case 30
                    para.n_rb = 78;
                case 40
                    para.n_rb = 106;
                otherwise
                    error('Unsupported channel bandwidth for SCS=60kHz.');
            end
            para.dl_subcarrierSpacing = 2;
            para.initialDLBWPsubcarrierSpacing = 2;
            para.ul_subcarrierSpacing = 2;
            para.initialULBWPsubcarrierSpacing = 2;
            para.msg1_SubcarrierSpacing = 2;
            para.subcarrierSpacing = 2;
            para.referenceSubcarrierSpacing = 2;
            para.dl_carrierBandwidth = para.n_rb;
            para.ul_carrierBandwidth = para.n_rb;

        case 120
            switch cbw
                case 5
                    para.n_rb = 11;
                case 10
                    para.n_rb = 24;
                case 15
                    para.n_rb = 38;
                case 20
                    para.n_rb = 51;
                case 25
                    para.n_rb = 65;
                case 30
                    para.n_rb = 78;
                case 40
                    para.n_rb = 106;
                otherwise
                    error('Unsupported channel bandwidth for SCS=120kHz.');
            end
            para.dl_subcarrierSpacing = 3;
            para.initialDLBWPsubcarrierSpacing = 3;
            para.ul_subcarrierSpacing = 3;
            para.initialULBWPsubcarrierSpacing = 3;
            para.msg1_SubcarrierSpacing = 3;
            para.subcarrierSpacing = 3;
            para.referenceSubcarrierSpacing = 3;
            para.dl_carrierBandwidth = para.n_rb;
            para.ul_carrierBandwidth = para.n_rb;

        otherwise
            error('Unsupported subcarrier spacing.');
    end
end