% Generate phone number signal
phone_number = '01156812358'; % Replace with your number
Fs = 8000;
guard_duration = 0.02; % 20ms
guard_samples = zeros(1, round(guard_duration * Fs));

% Generate complete signal
x = []; % Initialize the signal
for digit = phone_number
    digit_signal = sym2TT(digit); % Generate tone for the digit
    x = [x, digit_signal, guard_samples]; % Append tone and guard interval
end

%% Add noise
noise = sqrt(0.1) * randn(size(x));
y = x + noise;

%% Save as WAV file
audiowrite('dtmf_signal.wav', y, Fs, 'BitsPerSample', 24); % Increased bits per sample

%% Plot time domain signal
figure (1)
t = (0:length(y)-1)/Fs;
subplot (3,1,1)
plot (t , x)
title ('Original Signal in Time Domain')
xlabel ('Time (s)')
ylabel ('Amplitude')
subplot (3,1,2)
plot (t,noise)
title ('AWGN Noise')
xlabel ('Time (s)')
ylabel ('Noise Amplitude')
subplot (3,1,3)
plot (t,y)
title ('Signal with AWGN')
xlabel ('Time (s)')
ylabel ('Amplitude')

%% Plot frequency spectrum
f = (-0.5+1/length(x) : 1/length(x) : 0.5) * Fs ;
X = abs (fftshift (fft(x)/Fs)) ;
Noise = abs(fftshift(fft(noise)/Fs)) ;
Y = abs (fftshift(fft(y)/Fs)) ;

Y_mag = abs(Y);
Y_db = 20*log10(Y_mag/max(Y_mag));

figure (2);
subplot (3,1,1)
plot (f,X)
title ('Original Signal in Frequency Domain')
xlabel ('Frequency (Hz)')
ylabel ('Amplitude')
subplot (3,1,2)
plot (f ,Noise)
title ('AWGN Noise in Frequency Domain')
xlabel ('Frequency (Hz)')
ylabel ('Noise Amplitude')
subplot (3,1,3)
plot (f ,Y)
title ('Signal with AWGN in Frequency Domain')
xlabel ('Frequency (Hz)')
ylabel ('Amplitude') 

figure(3);
plot(f, Y_db);
grid on;
xlim([600 1700]);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Frequency Spectrum');

%% Generate spectrograms 
window_sizes = [16, 64, 256, 1024, 4096];
overlap_percent = 0.5;
nfft = 2^14;

for i = 1:length(window_sizes)
    win_size = window_sizes(i);
    overlap_samples = round(win_size * overlap_percent);
    
    % Rectangular window
    rect_win = rectwin(win_size);
    My_spectrogram(y, rect_win, overlap_samples, nfft, Fs, ['Rectangular (Size: ' num2str(win_size) ')']);
    
    % Blackman window
    black_win = blackman(win_size);
    My_spectrogram(y, black_win, overlap_samples, nfft, Fs, ['Blackman (Size: ' num2str(win_size) ')']);
end

%% Decode the signal
decoded_number = decodeDTMF(y, Fs);
fprintf('Decoded phone number: %s\n', decoded_number);

