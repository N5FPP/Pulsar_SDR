# char_mapgen.py

"""
This is a python script to take an ASCII description of pixel characters
for a VGA monitor and converts them to a mif format for use by Altera
Quartus II to load into a character ROM

The script will also hopefully support Intel Hex files eventually

Copyright Lee Szuba 2012
""" 

import sys

if(len(sys.argv) != 3):
    print("Error in input, please specify the input and output file name")
    sys.exit(2)

inName = sys.argv[1]
outName = sys.argv[2]

print("Input file:  ", inName)
print("Output file: ", outName) 

HexMap = open(outName, 'w')
CharMap = open(inName, 'r')

preamble = """--
--
-- ROM Character Map file
-- For VGA video output
--
-- Copyright Lee Szuba 2012
--
-- This character map uses all the printable ASCII characters
-- The non-printable characters have been replaced with fillers
-- Characters are 8x16 bits
--
--

WIDTH=8;
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

try:
    for line in CharMap:
        elements = line.split('#', 1)
        element = str.strip(elements[0])
        if (element is not None) and (element is not ''):
            element = str.replace(element, '-', '0')
            element = str.replace(element, '@', '1')

            address = str.zfill(str.upper(hex(curLine)[2:]), 4)
            line = '\t' + address + '\t:\t' + element + ';\n'

            writeFile += line
            curLine += 1
            radix += 1

finally:

    writeFile = str.format(writeFile, str(radix))
    writeFile += postamble
    HexMap.write(writeFile)

    HexMap.close();
    CharMap.close();