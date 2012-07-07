# char_mapgen.py

"""
This is a python script to take an ASCII description of pixel characters
for a VGA monitor and converts them to a mif format for use by Altera
Quartus II to load into a character ROM

The script will also hopefully support Intel Hex files eventually

Copyright Lee Szuba 2012
""" 

import sys
import random

if(len(sys.argv) != 2):
    print("Error in input, please specify the output file name")
    sys.exit(2)

outName = sys.argv[1]

print("Output file: ", outName) 

Chars = open(outName, 'w')

preamble = """--
--
-- RAM Character Test file
-- For VGA video output
--
-- Copyright Lee Szuba 2012
--
-- This character test file prints random values to a *.mif file
-- to use for loading the character memory
--
--

WIDTH=7;
DEPTH={0};

ADDRESS_RADIX=HEX;
DATA_RADIX=BIN;

CONTENT BEGIN

-------------------- START OF DATA --------------------

"""

postamble = """
-------------------- END OF DATA --------------------

END;"""

curLine = 0
radix = 0
writeFile = preamble

for curLine in range(0,8192):
    element = str.zfill(bin(random.randint(32,127))[2:], 7)
    address = str.zfill(str.upper(hex(curLine)[2:]), 4)
    line = '\t' + address + '\t:\t' + element + ';\n'
    writeFile += line
    curLine += 1
    radix += 1

writeFile = str.format(writeFile, str(radix))
writeFile += postamble
Chars.write(writeFile)

Chars.close();