#!/bin/bash

# Parameters
LATITUDE=22.2222      # Latitude of the desired location
LONGITUDE=-111.1234  # Longitude of the desired location
ALTITUDE=100          # Altitude in meters
SAMPLE_RATE=2600000   # Sample rate for HackRF
FREQUENCY=1575420000  # GPS L1 frequency
POWER_LEVEL=0         # Transmit power level

# Infinite loop to fetch, generate, and transmit GPS signals every 10 minutes
while true; do
  # Fetch latest ephemeris data
  wget -q -O brdcfile.Z ftp://cddis.gsfc.nasa.gov/gnss/data/daily/$(date +%Y)/brdc/brdc$(date +%j)0.$(date +%y)n.Z
  gunzip -f brdcfile.Z

  # Generate GPS signal with gps-sdr-sim
  ./gps-sdr-sim -e brdc$(date +%j)0.$(date +%y)n -l $LATITUDE,$LONGITUDE,$ALTITUDE -T $(date +%Y/%m/%d,%H:%M:%S) -b 8 -s $SAMPLE_RATE -o gpssim.bin

  # Transmit GPS signal with HackRF
  hackrf_transfer -t gpssim.bin -f $FREQUENCY -s $SAMPLE_RATE -x $POWER_LEVEL

  # Wait for 10 minutes
  sleep 600
done
