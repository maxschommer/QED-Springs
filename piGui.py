#!/bin/bash

from __future__ import division
import numpy as np
from numpy import genfromtxt
import matplotlib
#import pyautogui
import matplotlib.pyplot as plt
from matplotlib.widgets import Button
import pprint
from screeninfo import get_monitors
import time
import Adafruit_PCA9685



KS = genfromtxt('/home/pi/Documents/Github/QED-Springs/5_2/CSV_StateInfo/Ks.csv', delimiter=',')
States = genfromtxt('/home/pi/Documents/Github/QED-Springs/5_2/CSV_StateInfo/States.csv', delimiter=',')
Durations = genfromtxt('/home/pi/Documents/Github/QED-Springs/5_2/CSV_StateInfo/times.csv', delimiter=',')
Poses = genfromtxt('/home/pi/Documents/Github/QED-Springs/5_2/CSV_StateInfo/Poss.csv', delimiter=',')
PosTims = genfromtxt('/home/pi/Documents/Github/QED-Springs/5_2/CSV_StateInfo/Tims.csv', delimiter=',')

width = 5
height = 5

# Initialise the PCA9685 using the default address (0x40).
pwm = Adafruit_PCA9685.PCA9685()

# Alternatively specify a different address and/or bus:
#pwm = Adafruit_PCA9685.PCA9685(address=0x41, busnum=2)

# Configure min and max servo pulse lengths
servo_min = 150  # Min pulse length out of 4096
servo_max = 600  # Max pulse length out of 4096



# Set frequency to 60hz, good for servos.
pwm.set_pwm_freq(60)

w, h = matplotlib.figure.figaspect(3.)
fig = plt.figure(figsize=(width,height))

execMat = np.zeros((height, width))

class Servo(object):
	"""A class for a single servo with functions to move it"""
	def __init__(self, PinNum):
		super(Servo, self).__init__()
		self.PinNum = PinNum

	def set_servo_angle(self, angle):
		pulse = int(angle*(servo_max-servo_min)+servo_min)
		print(pulse)
		pwm.set_pwm(self.PinNum, 0, pulse)


def moveServos(Poses, Times, Durations, Servos):
	
	t = 0;
	y = []
	ts = []

	maxTime = 25 - max(Durations)
	t0 = time.time() - maxTime;
	maxIndex = next(i for i,v in enumerate(Times) if v > maxTime)
	i = maxIndex
	print(Times[i])
	while t < Times[-1]:
		t = time.time()-t0;
		if t > Times[i]:
			for j, Servo in enumerate(Servos, 0):
				Servo.set_servo_angle(Poses[j][i])
			i = i + 1
			
	time.sleep(3)
	for Servo in Servos:
		Servo.set_servo_angle(.5)




class ExecuteButtonProcessor(object):
	def __init__(self, axes, label):
		self.axes = axes
		self.button = Button(axes, "Execute")
		self.button.on_clicked(self.process)
		self.intializeServos()
		
	def intializeServos(self):
		for i in range(width):
			servo = Servo(i)
			servo.set_servo_angle(.5)
			
			print("Setting Angle")
				
	def process(self, event):

		execMat[execMat == 0] = -1
		# print(States[:, width:2*width])
		#KsRes = []
		PosRes = []
		DurRes = []
		Servos = []
		#theseTimes = []
		for i in range(width):
			e = States[:, 5:10] # The width of the array for States
			loc = np.where(np.all((e-execMat[:,i])==0, axis=1))[0][0]
			#KsRes.append(KS[loc, :])
			PosRes.append(Poses[loc, :])
			DurRes.append(Durations[loc])
			Servos.append(Servo(i))
			#theseTimes.append(Times[loc])

		#for res in KsRes:
			# pass
		#	print(res)
        	moveServos(PosRes, PosTims, DurRes, Servos)
        	execMat[execMat == -1] = 0
		# print(KsRes)
    
class ButtonClickProcessor(object):

	def __init__(self, axes, label, i, j):
		self.axes = axes
		self.button = Button(axes, label)
		self.button.on_clicked(self.process)
		self.button.color = 'Red'
		self.button.hovercolor = self.button.color
		self.colorMode = 0
		self.colors = ['Red', 'Blue']
		self.i = i
		self.j = j

	def process(self, event):

		execMat[self.j][self.i] = not execMat[self.j][self.i]
		print("execMatGen", execMat)
		print(self.i)
		print(self.j)
		self.colorMode = not self.colorMode
		self.button.color = self.colors[self.colorMode]
		self.button.hovercolor = self.button.color
		pyautogui.moveRel(0, 1)
		pyautogui.moveRel(0, -1)
		fig.canvas.draw()


buttons = []
buttonAxes = []
for i in range(width):
	for j in range(height):
		buttonAxes.append(plt.axes([(i)/float(width+1), j/float(height), 1/(float(width)), 1/float(height)]))
		buttons.append(ButtonClickProcessor(buttonAxes[-1], "", i, height-1-j))

execButtonAxes = plt.axes([1-1/(width+1), 0, 1/(float(width+1)), height])
execButton = ExecuteButtonProcessor(execButtonAxes, "Execute")

mng = plt.get_current_fig_manager()
mng.full_screen_toggle()

plt.show()

