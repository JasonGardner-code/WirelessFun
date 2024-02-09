# WirelessFun #

#hello_world#
The hello_world_wav.py script reads an audio file (hello_world.wav) and transmits it using the BladeRF and receives it on a USRP. The received audio is additionally captured to a PCAP file for analysis in Wireshark. Make sure to replace the audio file with your own recording or use any suitable audio file in WAV format.

The appropriate sample rate and gain settings depend on various factors, including the characteristics of your signal, the transmission medium, and the capabilities of your hardware.

Here are some considerations:

### Sample Rate:
- **Higher Sample Rate:** A higher sample rate allows you to capture more detail in the signal, especially at higher frequencies. However, it also requires more processing power and bandwidth. Use a sample rate that is at least twice the bandwidth of your signal (Nyquist theorem).

### Gain:
- **Optimal Gain:** The optimal gain setting depends on the strength of your signal and the dynamic range of your hardware. Too low a gain might result in a weak signal, while too high a gain could lead to distortion or saturation.
- **Adjustable Gain:** Many SDR devices provide adjustable gain settings. You may need to experiment with different gain values to find the one that works best for your specific setup.

### Specific Recommendations:
- **BladeRF:** For the BladeRF, a sample rate of 1 MHz (1e6 Hz) is often a reasonable starting point for experimentation. The gain setting can vary depending on your specific application and signal strength, but you can start with a moderate gain value like 20 dB.

- **USRP:** For the USRP, the recommended sample rate and gain settings depend on the specific model (e.g., B200). Generally, you can start with a sample rate of 1 MHz and a moderate gain setting, adjusting as needed.

### Experimentation:
It's recommended to start with conservative settings and then gradually increase or decrease the sample rate and gain while observing the received signal's quality. Monitor for issues such as distortion, saturation, or inadequate signal strength.

Remember that these recommendations are general guidelines, and the optimal settings can vary based on your specific use case. If possible, refer to the documentation for your specific hardware and consider any recommendations or best practices provided by the device manufacturer.

### broadcast_time_SSID:
To use this script:
1. Make sure you have `hostapd` installed on your system. You can install it using `sudo apt-get install hostapd`.

2. Open a text editor, copy the script into a new file, and save it with a `.sh` extension (e.g., `broadcast_time_loop.sh`).

3. Set the appropriate interface name in the `interface` variable.

4. Optionally, modify the `wpa_passphrase` to set the desired passphrase for the Wi-Fi network.

5. Run the script using `bash broadcast_time_loop.sh` or `./broadcast_time_loop.sh` (if you have given executable permissions to the script using `chmod +x broadcast_time_loop.sh`).


