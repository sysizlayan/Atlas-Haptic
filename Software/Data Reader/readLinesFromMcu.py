import serial
from struct import *
#import threading

portName = 'COM4'
baudRate = 2000000
position = 0.0
filteredPosition = 0.0
velocity = 0.0
time = 0
positionOfNewLine = 0
crashed = False
fileStreamer = open('lastReadData.csv','w')
ser = serial.Serial()
try:
    ser.port = portName
    ser.baudrate = baudRate
    ser.timeout = 10
    ser.open()
except:
    print('The port cannot be opened!')
    crashed = True
error = False
while(not crashed and ser.is_open):
    try:
        # line = ser.readline()
        temp = ser.read_until(b'$$')

        line = ser.read_until(b'**')
        line = line[0: len(line)-2]
        # print(len(line))
        # if(len(line)!=16):
        # print(line)
        # for i in range(0,len(line)):
        #     if line[i] == 10:
        #         positionOfNewLine = i
        #         break
        # if positionOfNewLine != len(line)-1:
        #     line = line + ser.readline()
        # print(len(line))
        # print(line[0:2],line[14:16])
        # print(line[0],line[1],line[14],line[15])
        # if(len(line) == 14 and line[0] == 36 and line[1]== 35 and line[14] == 35 and line[15] == 36):
        #     print(len(line))
        if len(line) == 24:
            (time, unfiltered_position, position_pedal, velocity_pedal, position_target, velocity_target) = unpack(
                '<Ifffff', line)
                # print(type(time))
                # position = unpack('<f',line[6:10])  # little endian float
                # velocity = unpack('<f',line[10:14])  # little endian float
            print("Time:{0} Pos_P: {2:.2f} Vel_P: {3:.2f} Pos_T: {4:.2f} Vel_T: {5:.2f}\n".format(time, round(unfiltered_position, 2), round(position_pedal, 2), round(velocity_pedal, 2), round(position_target, 2), round(velocity_target,2)))
            fileStreamer.write("{0},{1:.2f},{2:.4f},{3:.4f},{4:.4f},{5:.4f}\n".format(time, round(unfiltered_position, 2), round(position_pedal, 4), round(velocity_pedal, 4), round(position_target, 4), round(velocity_target,4)))
        else:
            print(line)
            # print("Delimiter Error!")
            continue
    except KeyboardInterrupt:
        print('exiting')
        crashed = True
ser.close()
fileStreamer.close()
print('exiting thread')

quit()
