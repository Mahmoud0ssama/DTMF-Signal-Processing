function decoded = decodeDTMF(signal, Fs)
    % DTMF frequencies
    f_low = [697 770 852 941];      % Low-frequency row tones
    f_high = [1209 1336 1477 1633]; % High-frequency column tones
    
    % Symbol mapping (extended keypad including A, B, C, D)
    keypad = ['1', '2', '3', 'A'; 
              '4', '5', '6', 'B'; 
              '7', '8', '9', 'C'; 
              '*', '0', '#', 'D'];
          
    % Parameters
    tone_duration = 0.1; % 100ms tone duration
    guard_duration = 0.02; % 20ms guard interval
    frame_size = round(tone_duration * Fs);
    guard_size = round(guard_duration * Fs);
    total_frame_size = frame_size + guard_size;
    
    % Calculate number of frames (tones) in the signal
    num_frames = floor(length(signal) / total_frame_size);
    decoded = ''; % Initialize the decoded output string
    
    for frame_idx = 0:num_frames-1
        % Extract one frame (tone without guard interval)
        start_idx = frame_idx * total_frame_size + 1;
        end_idx = start_idx + frame_size - 1;
        if end_idx > length(signal)
            break; % Exit if frame exceeds signal length
        end
        frame = signal(start_idx:end_idx);
        
        % Calculate Goertzel magnitudes for low and high frequencies
        mags_low = zeros(1, length(f_low));
        mags_high = zeros(1, length(f_high));
        
        for j = 1:length(f_low)
            omega = 2 * pi * f_low(j) / Fs;
            coeff = 2 * cos(omega);
            S1 = 0;
            S2 = 0;
            for n = 1:frame_size
                S0 = frame(n) + coeff * S1 - S2;
                S2 = S1;
                S1 = S0;
            end
            mags_low(j) = sqrt(S1^2 + S2^2 - S1 * S2 * coeff);
        end
        
        for j = 1:length(f_high)
            omega = 2 * pi * f_high(j) / Fs;
            coeff = 2 * cos(omega);
            S1 = 0;
            S2 = 0;
            for n = 1:frame_size
                S0 = frame(n) + coeff * S1 - S2;
                S2 = S1;
                S1 = S0;
            end
            mags_high(j) = sqrt(S1^2 + S2^2 - S1 * S2 * coeff);
        end
        
        % Identify the strongest row and column frequencies
        [max_low, row] = max(mags_low);
        [max_high, col] = max(mags_high);
        
        % Apply thresholds to validate detection
        threshold_low = 0.5 * max(mags_low);
        threshold_high = 0.5 * max(mags_high);
        if max_low > threshold_low && max_high > threshold_high
            % Map to keypad and append to decoded output
            decoded = [decoded, keypad(row, col)];
        else
            % Append '?' if detection fails
            decoded = [decoded, '?'];
            fprintf('Frame %d: Weak or unclear tone detected.\n', frame_idx + 1);
        end
    end
end
