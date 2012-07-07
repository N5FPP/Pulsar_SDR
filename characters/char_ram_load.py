# char_ram_load.py

"""
This is a python script to take an ASCII description of the SDR static
text on screen and convert it to a *.mif file for use by Altera
Quartus II to load into character RAM

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
-- RAM Character Map file
-- For VGA video output
--
-- Copyright Lee Szuba 2012
--
-- This character map describes the static text for the SDR
-- video output
--

WIDTH=8;
DEPTH={0};

ADDRESS_RADIX=HEX;
DATA_RADIX=HEX;

CONTENT BEGIN

-------------------- START OF DATA --------------------

"""

postamble = """
-------------------- END OF DATA --------------------

END;"""

radix = 0
writeFile = preamble

try:
    for line in CharMap:
        hexLine = ''
        elements = ''
        hexLine = ''

        elements = str.rstrip(line.split('%', 1)[0])

        if ((elements != '') and (elements != None)):
            elements = elements[0:99]

            while (len(elements) < 128):
                elements += ' '

            for character in elements:
                hexLine += str.upper(hex(ord(character))[2:])

            hexLine = [hexLine[x:x+2] for x in range(0,len(hexLine),2)]

            # Each horizontal line is 7 bits, so we need to append 0's to fill
            # the excess memory

            for hexChar in hexLine:
                address = str.zfill(str.upper(hex(radix)[2:]), 4)
                line = '\t' + address + '\t:\t' + hexChar + ';\n'

                writeFile += line
                radix += 1

    while (radix < 8192):
        address = str.zfill(str.upper(hex(radix)[2:]), 4)
        line = '\t' + address + '\t:\t' + '20' + ';\n'

        writeFile += line
        radix += 1

finally:

    writeFile = str.format(writeFile, str(radix))
    writeFile += postamble
    HexMap.write(writeFile)

    HexMap.close();
    CharMap.close();