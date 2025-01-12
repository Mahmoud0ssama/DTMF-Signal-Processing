# DTMF Signal Processing in MATLAB

This project demonstrates the generation, analysis, and decoding of Dual-Tone Multi-Frequency (DTMF) signals using MATLAB. It includes a complete pipeline for synthesizing DTMF tones, adding noise, analyzing signals, generating spectrograms, and decoding noisy signals.

---

## Features
- **DTMF Signal Generation**: Create DTMF tones for phone numbers using standard frequency mappings.
- **Noise Addition**: Add Additive White Gaussian Noise (AWGN) to simulate real-world conditions.
- **Time and Frequency Domain Analysis**: Visualize signals before and after noise addition.
- **Spectrogram Analysis**: Generate spectrograms with various window types and sizes.
- **Signal Decoding**: Decode noisy DTMF signals back to their original symbols.
- **WAV File Export**: Save noisy signals as `.wav` files for further use.

---

## File Structure
- **`sym2TT.m`**  
  Generates a single DTMF tone for a given symbol (e.g., '5', '#', 'A').
- **`decodeDTMF.m`**  
  Decodes a DTMF signal back to its original symbols.
- **`My_spectrogram.m`**  
  Custom spectrogram generator with flexible window and overlap settings.
- **`main_script.m`**  
  Main script integrating all functionalities:
  - Generates a phone number signal.
  - Adds noise and saves the noisy signal as a WAV file.
  - Analyzes signals in time and frequency domains.
  - Generates spectrograms and decodes the noisy signal.

---

## Visual Outputs
1. **Time-Domain Signal**:
   - Original signal, noise, and noisy signal.
2. **Frequency Spectrum**:
   - Magnitude spectra of original, noise, and noisy signals.
3. **Spectrograms**:
   - Time-frequency representations with different window types and sizes.

---

## Customization
1. **Phone Number**:
   - Modify the `phone_number` variable in `main_script.m` to use a different number.

2. **Noise Level**:
   - Adjust the noise variance in the `noise` variable to simulate different conditions.

3. **Spectrogram Settings**:
   - Change `window_sizes`, `overlap_percent`, and `nfft` variables in the spectrogram section.

4. **Sampling Rate**:
   - Update the `Fs` variable if using a different sampling rate.
