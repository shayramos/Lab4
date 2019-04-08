import wave, struct
DEPTH = 32
WIDTH = 16
ADDRESS_RADIX = 'HEX'
DATA_RADIX = 'HEX'

def tohex(val, nbits):
  return hex((val + (1 << nbits)) % (1 << nbits))


w = wave.open('smb3_sound_effects_1_up.wav', 'r')
# framerate: numero de sample por segundo
# nframes: numero de sample (informação da amplitude)
# Returns a tuple (nchannels, sampwidth, framerate, nframes, comptype, compname)
print(w.getparams())

f = open("initialization.mif", "w+")
f.write("DEPTH = %d;" % DEPTH)
f.write('\t\t\t' + '% Memory depth and width are required %' + '\n')
f.write('\t\t\t\t\t' + '% DEPTH is the number of addresses %' + '\n')
f.write("WIDTH = %d;" % WIDTH)
f.write('\t\t\t' + '% WIDTH is the number of bits of data per word %' + '\n')
f.write('\t\t\t\t\t' + '% DEPTH and WIDTH should be entered as decimal numbers %' + '\n')
f.write("ADDRESS_RADIX = %s;" % ADDRESS_RADIX)
f.write('\t' + '% Address and value radixes are required %' + '\n')
f.write("DATA_RADIX = %s;" % DATA_RADIX)
f.write('\t\t' + '% Enter BIN, DEC, HEX, OCT, or UNS; unless %' + '\n')
f.write('\t\t\t\t\t' + '% otherwise specified, radixes = HEX %' + '\n')
f.write("-- Specify values for addresses, which can be single address or range" + '\n')
f.write("CONTENT" + '\n')
f.write("BEGIN" + '\n')
for i in range(44, w.getnframes()):
    waveData = w.readframes(1)
    # print(len(waveData))
    data = struct.unpack("<h", waveData)
    f.write(hex(i-44) + '\t')
    f.write(":\t" + tohex(data[0], 16) + ";" + "\n")

f.write("END;")
