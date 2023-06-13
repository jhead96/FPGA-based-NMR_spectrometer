# FPGA-based-NMR_spectrometer

Verilog source code for an FPGA-based NMR spectrometer designed for use on an SP Devices SDR14 radioprocessor board.

# Features
- Generates output RF signals up to 800MHz with a frequency resolution of < 1 Hz.
- Pulse programmer supports NMR sequences with up to 3 variable width TTL pulses.
- Input signal sampled at 800 MSa/s and processed using a quadrature mixer and parallel FIR filter with the option of downsampling. 
