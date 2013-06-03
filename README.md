Pulsar_SDR
==========

Altera Cyclone FPGA Code to implement a Software Defined Radio

Developed for Tayloe detector and DE0 Nano dev board
Eventually will be migrated to a direct sampling design

## TO DO

In something of a priority order.

### Tests

* Receive
    * Save quadrature sampling data for post-processing with GNU Radio
    * Streaming receive over Ethernet

* Transmit
    * Block transmit with DAC direct out
    * Streaming transmit over Ethernet

### Hardware

* Decide on and purchase new FPGA dev board
* Layout, manufacture and build LT2208 board
* Qualify noise performance of RX signal chain
* Qualify noise performance of DAC (does this need a spectrum analyzer?)
* Layout, manufacture and build TxDAC board
* Construct HF amplifier (10W with cheap power FETs ?)
* Package in some kind of nice case
* Do something hella cool (Summits on the Air?)
* Build down-converter
* Do additional hella cool things (moon bounce?)

### FPGA/HDL

* Learn how to work with FIFOs
* Create PHY interface compatible with [UHD](http://code.ettus.com/redmine/ettus/projects/uhd/wiki)
* ADC interface (LT2208)
* Down sampling filters
* Glue logic and control circuits

### Software/GNU Radio

* Experiment with demodulating simple voice/data modes (AM, SSB, RTTY, PSK)
* Determine if GNU radio based system or SDR#/HDSDR/linrad
* Learn how to use UHD driver
