function x = sym2TT(S)
    % DTMF frequencies
    f_low = [697 770 852 941];      % Low-frequency row tones
    f_high = [1209 1336 1477 1633]; % High-frequency column tones
    
    % Symbol mapping (extended keypad including A, B, C, D)
    keypad = ['1', '2', '3', 'A'; 
              '4', '5', '6', 'B'; 
              '7', '8', '9', 'C'; 
              '*', '0', '#', 'D'];
    
    % Find the position of the symbol
    [row, col] = find(keypad == S);
    
    % Sampling parameters
    Fs = 8000;          % Sampling frequency (8 kHz)
    duration = 0.1;     % Tone duration (100 ms)
    t = 0:1/Fs:duration-1/Fs; % Time vector
    
    % Generate DTMF tone (sum of the row and column frequencies)
    x = 0.5 * (sin(2*pi*f_low(row)*t) + sin(2*pi*f_high(col)*t)); % Reduced amplitude to prevent clipping
end
