import librosa


def tohex(val, nbits):
    return hex((val + (1 << nbits)) % (1 << nbits))


# Downsample 9600 Hz
y1, sr = librosa.load('smw_1_up.wav', sr=9600)
y2, sr = librosa.load('smw_bubble_pop.wav', sr=9600)
y3, sr = librosa.load('smw_coin.wav', sr=9600)
y4, sr = librosa.load('smw_fireball.wav', sr=9600)
y5, sr = librosa.load('smw_jump.wav', sr=9600)

# dados do wave para uma lista
data1 = map(lambda x: int(x / max(abs(min(y1.tolist())), max(y1.tolist())) * 32767), y1.tolist())
data2 = map(lambda x: int(x / max(abs(min(y2.tolist())), max(y2.tolist())) * 32767), y2.tolist())
data3 = map(lambda x: int(x / max(abs(min(y3.tolist())), max(y3.tolist())) * 32767), y3.tolist())
data4 = map(lambda x: int(x / max(abs(min(y4.tolist())), max(y4.tolist())) * 32767), y4.tolist())
data5 = map(lambda x: int(x / max(abs(min(y5.tolist())), max(y5.tolist())) * 32767), y5.tolist())
datanew = [len(data1)] + data1 + \
          [len(data2)] + data2 + \
          [len(data3)] + data3 + \
          [len(data4)] + data4 + \
          [len(data5)] + data5

# Mif headers
DEPTH = 1024 * 1024
WIDTH = 16
ADDRESS_RADIX = 'HEX'
DATA_RADIX = 'HEX'

# Mif file
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

# indexes
f.write(hex(0) + "\t:\t" + hex(32) + ";\n")
f.write(hex(1) + "\t:\t" + hex(32 + len(data1)) + ";\n")
f.write(hex(2) + "\t:\t" + hex(32 + len(data1) + len(data2)) + ";\n")
f.write(hex(3) + "\t:\t" + hex(32 + len(data1) + len(data2) + len(data3)) + ";\n")
f.write(hex(4) + "\t:\t" + hex(32 + len(data1) + len(data2) + len(data3) + len(data4)) + ";\n")

for i in range(5, 32):
    f.write(hex(i) + "\t:\t" + hex(0) + ";\n")

# first wave
for i in range(32, len(datanew)):
    f.write(hex(i) + "\t:\t" + hex(datanew[i - 32]) + ";\n")

f.write("END;")
