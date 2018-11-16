import pygame
import serial
import threading
import numpy as np
from pygame import gfxdraw
from struct import *
import os
import time
from pygl2d import display, draw

# ///// Experiment Variables //////
position_pedal = 0
position_target = 0
velocity_pedal = 0
velocity_target = 0
unfiltered_position_pedal = 0

sendJson = False
experimentState = 0
isWindowClosed = False

def calculateRectangleCorners(angle=0, length=200, thickness=5):
    sineValue = np.sin(np.deg2rad(angle))
    cosineValue = np.cos(np.deg2rad(angle))

    lineEnd_x = middleOfTheScreen[0] - length * cosineValue
    lineEnd_y = middleOfTheScreen[1] - length * sineValue

    UL = ((lineEnd_x - thickness * sineValue), (lineEnd_y + thickness * cosineValue))
    UR = ((lineEnd_x + thickness * sineValue), (lineEnd_y - thickness * cosineValue))

    BL = ((middleOfTheScreen[0] - thickness * sineValue), (middleOfTheScreen[1] + thickness * cosineValue))
    BR = ((middleOfTheScreen[0] + thickness * sineValue), (middleOfTheScreen[1] - thickness * cosineValue))
    return UL, UR, BR, BL, lineEnd_x, lineEnd_y

# Mutex for multi threading
threadLock = threading.Lock()

ser = serial.Serial()
portName = 'COM4'  # Look for port name every time!
baudRate = 2000000  # 2 MHz
fileStreamer = 0
try:
    ser.port = portName
    ser.baudrate = baudRate
    ser.timeout = 10
    ser.open()
    fileStreamer = open('lastReadData.csv', 'w')
except:
    print('The port cannot be opened!')
    # Do not start the pyGame screen
    quit()


class myThread(threading.Thread):
    def __init__(self, threadID):
        threading.Thread.__init__(self)
        self.threadID = threadID

    def run(self):
        global isWindowClosed
        global position_pedal
        global position_target
        global velocity_pedal
        global velocity_target
        global unfiltered_position_pedal
        global experimentState
        global fileStreamer
        while not isWindowClosed:
            try:
                temp = ser.read_until(b'$$')

                line1 = ser.read_until(b'**')
                line = line1[0: len(line1) - 2]
                # print(len(line))
                if len(line) == 24:
                    # Acquire mutex
                    threadLock.acquire()
                    # little endian unsigned integer
                    (time, unfiltered_position_pedal, position_pedal, velocity_pedal, position_target, velocity_target) = unpack('<Ifffff', line)

                    #Release mutex
                    threadLock.release()
                    if experimentState == 1:
                        # print("Time:{0} Pedal_Pos:{1:.2}, Target_Pos:{2:.2} Pedal_Vel:{3:.2}, Target_Vel:{4:.2}\n"
                        #       .format(time,
                        #               round(unfiltered_position_pedal, 2),
                        #               round(position_pedal, 2),
                        #               round(position_target, 2),
                        #               round(velocity_pedal, 2),
                        #               round(velocity_target, 2)))
                        fileStreamer.write(
                            "{0},{1:.2f},{2:.4f},{3:.4f},{4:.4f},{5:.4f}\n".format(time, round(unfiltered_position_pedal, 2),
                                                                                   round(position_pedal, 4),
                                                                                   round(velocity_pedal, 4),
                                                                                   round(position_target, 4),
                                                                                   round(velocity_target, 4)))
                    if position_target == -1000000 and velocity_target == -1000000:
                        position_pedal = 0
                        position_target = 0
                        velocity_pedal = 0
                        velocity_target = 0
                        unfiltered_position_pedal = 0
                        fileStreamer.close()
                        experimentState = 0

                else:
                    print("Delimiter Error:")
                    print(line1)
                    continue

            except KeyboardInterrupt:
                # fileStreamer.close()
                isWindowClosed = True
                ser.close()
                print('KEYBOARD INTERRUPT')
                break
        print('EXITING READER')


readerThread = myThread(1)
readerThread.start()

os.environ['SDL_VIDEO_WINDOW_POS'] = 'center'

isNewExperimentConfigRequired = input("Do you want to change the experiment config?(y/n)")
while not sendJson:
    if isNewExperimentConfigRequired == 'y':
        print("Config editor is starting")
        os.system("python configJSON_editor.py")
        sendJson = True
    elif isNewExperimentConfigRequired == 'n':
        sendJson = True
    else:
        continue

with open('haptic.json') as json_data:
    jsonConfig = json_data.read().encode(encoding='utf-8')
    ser.write(jsonConfig)
sendJson = False
experimentState = 1
fileStreamer = open('lastReadData.csv', 'w')

# ///////// GUI INIT ////////////////
pygame.init()
print(pygame.display.Info())
screenInfo = pygame.display.Info()
GUISize = (screenInfo.current_w, screenInfo.current_h)
upLeftCorner = (0, 0)
downLeftCorner = (0, GUISize[1] - 1)
upRightCorner = (GUISize[0]-1, 0)
downRightCorner = (GUISize[0]-1, GUISize[1]-1)
middleOfTheScreen = (GUISize[0]/2, GUISize[1]/2)


clock = pygame.time.Clock()
# GUIDisplay = pygame.display.set_mode(GUISize)
pygame.display.set_mode(GUISize, pygame.DOUBLEBUF | pygame.OPENGL | pygame.HWSURFACE | pygame.FULLSCREEN)
display.init_gl()

pygame.display.set_caption('Target Tracking')

redColor   = (255, 0, 0)
blackColor = (0, 0, 0)
handleLength = 400  # Line size
handleThickness = 5
targetRadius = 25
pedalRadius = 35
rectangleSize = (10, 200)

test1 = 0
direction = 0

isWindowReady = True
isQuitNecessary = False

while True:
    if experimentState == 0:
        if isWindowReady:
            pygame.display.quit()
            pygame.quit()
            isWindowReady = False
        # time.sleep(3)
        isNewExperimentConfigRequired = input("Do you want to change the experiment config?(y/n)")
        while not sendJson:
            if isNewExperimentConfigRequired == 'y':
                print("Config editor is starting")
                os.system("python configJSON_editor.py")
                sendJson = True
            elif isNewExperimentConfigRequired == 'n':
                sendJson = True
            else:
                continue

        with open('haptic.json') as json_data:
            jsonConfig = json_data.read().encode(encoding='utf-8')
            ser.write(jsonConfig)
        sendJson = False

        fileStreamer = open('lastReadData.csv', 'w')

        pygame.init()
        clock = pygame.time.Clock()
        # GUIDisplay = pygame.display.set_mode(GUISize)
        pygame.display.set_mode(GUISize, pygame.DOUBLEBUF | pygame.OPENGL | pygame.HWSURFACE)
        display.init_gl()
        pygame.display.set_caption('Target Tracking')
        experimentState = 1

    # // GUI LOOP //
    elif experimentState == 1:
        if isWindowReady is not True:
            pygame.init()
            clock = pygame.time.Clock()
            # GUIDisplay = pygame.display.set_mode(GUISize)
            pygame.display.set_mode(GUISize, pygame.DOUBLEBUF | pygame.OPENGL | pygame.HWSURFACE | pygame.FULLSCREEN)
            display.init_gl()
            pygame.display.set_caption('Target Tracking')
            isWindowReady = True
        while not isWindowClosed and experimentState == 1:
            clock.tick(260)
            for e in pygame.event.get():
                if e.type == pygame.QUIT:
                    isWindowClosed = True
                if e.type == pygame.KEYDOWN:
                    if e.key == pygame.K_ESCAPE:
                        isWindowClosed = True

            # test1 = test1 + 1
            # if test1 is 2:
            #     if direction is 0:
            #         position_pedal = position_pedal + 1
            #         position_target = position_target - 1
            #         if position_pedal == 90:
            #             direction = 1
            #     else:
            #         position_pedal = position_pedal - 1
            #         position_target = position_target + 1
            #         if position_pedal == -90:
            #             direction = 0
            #     test1 = 0

            # Acquire thread lock
            threadLock.acquire()
            # Take local copies of the positions
            # Only positions will be used for GUI
            _pT = -1 * position_target + 90
            _pP = -1 * position_pedal + 90

            # Release the mutex after taking copies
            threadLock.release()
            targetRectangle = calculateRectangleCorners(_pT, handleLength, handleThickness)
            pedalRectangle  = calculateRectangleCorners(_pP, handleLength, handleThickness)

            display.begin_draw(GUISize)
            draw.polygon(pedalRectangle[0:4], blackColor, aa=True, alpha=255.0)
            draw.circle((int(pedalRectangle[4]),int(pedalRectangle[5])), pedalRadius, blackColor)
            draw.polygon(targetRectangle[0:4], redColor, aa=True, alpha=255.0)
            draw.circle((int(targetRectangle[4]), int(targetRectangle[5])), targetRadius, redColor)
            draw.circle((int(middleOfTheScreen[0]), int(middleOfTheScreen[1])), handleThickness, redColor)
            display.end_draw()


readerThread.join()
pygame.quit()
quit()
