function My_spectrogram(signal, window, overlap, nfft, Fs, window_name)
    % Number of samples in the signal
    signal_length = length(signal);
    
    % Calculate hop size
    hop_size = length(window) - overlap;
    
    % Calculate number of frames
    num_frames = ceil((signal_length - overlap) / hop_size);
    
    % Zero-pad signal if necessary
    padded_length = (num_frames - 1) * hop_size + length(window);
    signal = [signal, zeros(1, padded_length - signal_length)];
    
    % Initialize spectrogram matrix
    spectrogram_matrix = zeros(nfft / 2 + 1, num_frames);
    
    % FFT frequency axis
    f_axis = linspace(0, Fs / 2, nfft / 2 + 1);
    t_axis = (0:num_frames-1) * hop_size / Fs;
    
    % Compute the spectrogram
    for frame = 1:num_frames
        start_idx = (frame - 1) * hop_size + 1;
        end_idx = start_idx + length(window) - 1;
        frame_signal = signal(start_idx:end_idx) .* window';
        
        % Compute FFT of the frame and take magnitude
        frame_fft = abs(fft(frame_signal, nfft));
        spectrogram_matrix(:, frame) = frame_fft(1:nfft / 2 + 1);
    end
    
    % Plot the spectrogram
    figure;
    imagesc(t_axis, f_axis/1000, 10*log10(spectrogram_matrix));
    axis xy;
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title([ window_name ' Window']);
    colorbar;
end