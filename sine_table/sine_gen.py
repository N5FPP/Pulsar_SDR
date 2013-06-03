# sine_gen.py

"""
This script creates a lookup table of all values for one
cycle of a sine wave.

Each sample is 16 bits, 14 bits padded with 2 trailing 0's.

16 384 16-bit words of memory are required, or 32 768 bytes.
"""

import sys
import math

preamble = """--
--
-- Sine Lookup Table file
-- For DAC output
--
-- Copyright Lee Szuba 2012
--
--

WIDTH=14;
DEPTH={0};

ADDRESS_RADIX=HEX;
DATA_RADIX=HEX;

CONTENT BEGIN

-------------------- START OF DATA --------------------

"""

postamble = """
-------------------- END OF DATA --------------------

END;"""

if(len(sys.argv) != 2):
    print("Error in input, please specify the output file name")
    sys.exit(2)

outName = sys.argv[1]

print("Output file: ", outName)

SineLookup = open(outName, 'w')

sampl_len = pow(2,14)

curLine = 0
radix = 0
writeFile = preamble

try:
    for curLine in range(0, sampl_len-1):
        address = str.zfill(str.upper(hex(curLine)[2:]), 4)
        sineValue = (1+math.sin(2*math.pi*curLine/sampl_len))/2*(sampl_len-1)
        line = '\t' + address + '\t:\t' + str.zfill(str.upper(hex(int(math.floor(sineValue))))[2:], 4) + ';\n'
        writeFile += line
        curLine += 1
        radix += 1
finally:
    writeFile = str.format(writeFile, str(radix))
    writeFile += postamble
    SineLookup.write(writeFile)

    SineLookup.close();
