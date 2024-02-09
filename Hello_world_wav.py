import time
import numpy as np
from pydub import AudioSegment
import pybladerf
import pyuhd
import pyshark

def configure_bladerf(device, frequency, sample_rate, gain):
    device.set_frequency('TX', 0, frequency)
    device.set_sample_rate('TX', 0, sample_rate)
    device.set_gain('TX', 0, gain)

def configure_usrp(device, frequency, sample_rate, gain):
    usrp_sink = device.get_tx_stream(pyuhd.CPU_FORMAT_SC16, 0)
    usrp_sink.set_center_freq(frequency)
    usrp_sink.set_samp_rate(sample_rate)
    usrp_sink.set_gain(gain)

def transmit_audio_bladerf(device, audio_file, frequency, sample_rate, duration_sec, pcap_file):
    configure_bladerf(device, frequency, sample_rate, 20)
    
    # Read the audio file
    audio = AudioSegment.from_wav(audio_file)
    signal = np.array(audio.get_array_of_samples(), dtype=np.float32)
    
    # Normalize the signal
    signal /= np.max(np.abs(signal))

    # Transmit the signal
    device.sync_config(layout=pybladerf.SC16_Q11, num_buffers=32, buffer_size=8192)
    device.enable_module('TX', 0)
    device.sync_tx(signal, timeout=int(duration_sec * 1000))
    device.disable_module('TX', 0)

    # Capture transmitted audio to PCAP file
    capture = pyshark.LiveCapture(output_file=pcap_file, interface='loopback')
    capture.sniff(timeout=duration_sec)

def receive_audio_usrp(device, sample_rate, duration_sec, pcap_file):
    configure_usrp(device, frequency, sample_rate, 20)
    
    # Receive the signal
    usrp_source = device.get_rx_stream(pyuhd.CPU_FORMAT_SC16, 0)
    usrp_source.start()
    samples = usrp_source.recv(8192, timeout=int(duration_sec * 1000))
    usrp_source.stop()

    # Capture received audio to PCAP file
    capture = pyshark.LiveCapture(output_file=pcap_file, interface='loopback')
    capture.sniff(timeout=duration_sec)

    return samples

if __name__ == '__main__':
    # Define parameters
    frequency = 900e6  # Frequency in Hz
    sample_rate = 1e6  # Sample rate in Hz
    duration_sec = 10  # Duration of transmission in seconds
    audio_file = 'hello_world.wav'
    pcap_file_tx = 'transmitted_audio.pcap'
    pcap_file_rx = 'received_audio.pcap'

    # Initialize BladeRF and USRP devices
    with pybladerf.Device(-1) as device_bladerf, pyuhd.usrp.MultiUSRP('type=b200') as device_usrp:
        # Transmit audio using BladeRF
        transmit_audio_bladerf(device_bladerf, audio_file, frequency, sample_rate, duration_sec, pcap_file_tx)
        
        # Receive audio using USRP
        received_samples = receive_audio_usrp(device_usrp, sample_rate, duration_sec, pcap_file_rx)
        
        # Print received samples (for demonstration purposes)
        print("Received Samples:", received_samples)
