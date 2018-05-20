import pygame
import serial
import threading
import numpy as np
from struct import *

portName = 'COM5'
baudRate = 460800
position_pedal = 0
position_target = 0
velocity_pedal = 0
velocity_target = 0
prev_position_pedal = 0
prev_position_mass = 0

crashed = False
threadLock = threading.Lock()
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

pygame.init()


class myThread(threading.Thread):
    def __init__(self, threadID):
        threading.Thread.__init__(self)
        self.threadID = threadID

    def run(self):
        global crashed
        global position_pedal
        global position_target
        global velocity_pedal
        global velocity_target

        while (not crashed):
            try:
                temp = ser.read_until(b'$$')

                line = ser.read_until(b'**')
                line = line[0: len(line) - 2]
                # print(len(line))
                if len(line) == 20:
                    # little endian unsigned integer
                    (time, position_pedal, position_target, velocity_pedal, velocity_target) = unpack('<Iffff',line)

                    print("Time:{0} Pedal_Pos:{1:.2}, Target_Pos:{2:.2} Pedal_Vel:{3:.2}, Target_Vel:{4:.2}\n"
                        .format(time,
                                round(position_pedal, 2),
                                round(position_target, 2),
                                round(velocity_pedal, 2),
                                round(velocity_target, 2)))
                    fileStreamer.write(time,position_pedal,position_target,velocity_pedal,velocity_target)
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
pedal_img_rect = pedalImg.get_rect()
targetImg = pygame.image.load('target.png')
target_img_rect = targetImg.get_rect()

pedalWidth, pedalHeigth = pedalImg.get_rect().size
massWidth, massHeigth = targetImg.get_rect().size

gameDisplay = pygame.display.set_mode([600, 600])
pygame.display.set_caption('Target Tracking')

thread1.start()
while not crashed:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            crashed = True

    gameDisplay.fill(white)

    threadLock.acquire()

    pedal = pygame.transform.rotate(pedalImg, position_pedal-90)
    pedal_rect = pedal.get_rect()
    pedal_rect.center = pedal_img_rect.center
    pedal_rect= pedal_rect.move(0, 300)
    target = pygame.transform.rotate(targetImg, position_target - 90)
    target_rect = target.get_rect()
    target_rect.center = target_img_rect.center
    target_rect = target_rect.move(172, 300)
    # print(pedal_rect.center,target_rect.center)

    gameDisplay.blit(pedal, pedal_rect)
    gameDisplay.blit(target, target_rect)

    threadLock.release()
    pygame.display.update()

    clock.tick(60)
thread1.join()
pygame.quit()
quit()
