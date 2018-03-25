import pygame
import serial
import threading
import numpy as np
from struct import *


portName = 'COM3'
baudRate = 230400
position_pedal = 0
position_mass = 0
prev_position_pedal = 0
prev_position_mass = 0

numberOfHorizontalPixelsOnWindow = 400
numberOfVerticalPixelsOnWindow = 600
numberOfVerticalPixelsOnScreen = 768 # 768 # pixel
screenHeight = 0.18 # 18  # cm
screenConstant = numberOfVerticalPixelsOnScreen/screenHeight
pedalLength = 0.17  # cm
# windowHeight = screenHeight*numberOfVerticalPixelsOnWindow/numberOfVerticalPixelsOnScreen

crashed = False
threadLock = threading.Lock()
# fileStreamer = open('lastReadData.csv','w')
ser = serial.Serial()
try:
    ser.port = portName
    ser.baudrate = baudRate
    ser.timeout = 10
    ser.open()
except:
    print('The port cannot be opened!')
    crashed = True

pygame.init()

class myThread(threading.Thread):
   def __init__(self, threadID):
      threading.Thread.__init__(self)
      self.threadID = threadID
   def run(self):
       global position_pedal
       global position_mass
       global crashed
       global prev_position_pedal
       global prev_position_mass
       while(not crashed):
           try:
               temp = ser.read_until(b'$$')

               line = ser.read_until(b'**')
               line = line[0: len(line) - 2]
               # print(len(line))
               if len(line) == 12:
                   # (time, filteredPosition, velocity) = unpack('<Iff', line)  # little endian unsigned integer
                   # print("Time:{0} Pos: {1:.6} Vel:{2:.6}\n".format(time,filteredPosition,velocity))
                   # fileStreamer.write("{0},{1:.6},{2:.6}\n".format(time, filteredPosition, velocity))


                   # 18cm vertical -> 768 pixel
                   # (time, filteredPedalPosition, massPosition, pedalVelocity, massVelocity) = unpack('<Iffff', line)  # little endian unsigned integer
                   # print("READ: Time:{0} Pedal_Pos:{1:.6}, Mass_Pos:{2:.6}, Pedal_Vel:{3:.6}, Mass_Vel:{4:.6}\n".format(time,filteredPedalPosition,massPosition,pedalVelocity,massVelocity))

                   (time, filteredPedalPosition, massPosition) = unpack('<Iff',line)  # little endian unsigned integer
                   print("READ: Time:{0} Pedal_Pos:{1:.6}, Mass_Pos:{2:.6}\n".format(time, filteredPedalPosition, massPosition))

                   # position_pedal = pedalLength * filteredPedalPosition * screenConstant
                   # position_pedal = pedalLength * np.sin(np.deg2rad(filteredPedalPosition)) * screenConstant # 768/18
                   position_pedal = filteredPedalPosition * screenConstant
                   position_mass = massPosition * screenConstant
                   # print("CORR: Time:{0} Pedal: {1:.6} Mass:{2:.6}\n".format(time,position_pedal,position_mass))

                   # threadLock.acquire()

                   # threadLock.release()
               else:
                   print(line)
                   # print("Delimiter Error!")
                   continue

           except KeyboardInterrupt:
               # fileStreamer.close()
               ser.close()
               print('exiting')
               break
       print('exiting thread')


thread1 = myThread(1)

black = (0, 0, 0)
white = (255, 255, 255)

clock = pygame.time.Clock()
pedalImg = pygame.image.load('pedal.png')
massImg = pygame.image.load('mass.png')

pedalWidth, pedalHeigth = pedalImg.get_rect().size
massWidth, massHeigth = massImg.get_rect().size

gameDisplay = pygame.display.set_mode((pedalWidth, numberOfVerticalPixelsOnWindow))
pygame.display.set_caption('Pedal')

x_pedal = 0
x_mass = massWidth/2
y = numberOfVerticalPixelsOnWindow/2

thread1.start()
while not crashed:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            crashed = True

    gameDisplay.fill(white)

    threadLock.acquire()
    gameDisplay.blit(pedalImg, (x_pedal, numberOfVerticalPixelsOnWindow/2 + position_pedal))
    gameDisplay.blit(massImg,  (x_mass, numberOfVerticalPixelsOnWindow/2 + position_mass))
    threadLock.release()
    pygame.display.update()

    clock.tick(60)
thread1.join()
pygame.quit()
quit()
