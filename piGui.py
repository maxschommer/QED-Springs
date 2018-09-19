from __future__ import division
import numpy as np
from numpy import genfromtxt
import matplotlib
import pyautogui
import matplotlib.pyplot as plt
from matplotlib.widgets import Button
import pprint
from screeninfo import get_monitors
import time
import Adafruit_PCA9685
#import copy


KS = genfromtxt('./5_2/CSV_StateInfo/Ks.csv', delimiter=',')
States = genfromtxt('./5_2/CSV_StateInfo/States.csv', delimiter=',')

width = 1
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

    	


def moveServos(KSIn, IDXs, Servos, timeEnd=25, res=500, scaling=10):
	As = []
	Fs = []
	DriveFuncs = []
	#print(KSIn)
	for i, K in enumerate(KSIn, 0):
		Fs.append(K[0:int(len(K)/2)])
		As.append(K[int(len(K)/2):])
	print("Fs: ", Fs[0])
	print("As: ", As[0])
	startTime = 0
	for i in range(width):
		drive = lambda t, i=i: np.dot(np.sin((t-startTime)*Fs[i] * 2* np.pi), As[i]/scaling + .5)  # Have to set i as the default argument so lambda function isn't overwritten.
		DriveFuncs.append(drive);
	
	pltfig = plt.figure()
	t0 = time.time();
	t = 0;
	y = []
	ts = []
	while t < timeEnd:
		#t = time.time()-t0;
		t = t + .05
		#print("t: ", t)
		for i, Servo in enumerate(Servos, 0):
			#print(180*DriveFuncs[i](t))
			
			y.append(DriveFuncs[i](t))
			ts.append(t)
	
			#Servo.set_servo_angle(DriveFuncs[i](t))
	plt.plot(ts, y)
	plt.show()

class ExecuteButtonProcessor(object):
	def __init__(self, axes, label):
		self.axes = axes
		self.button = Button(axes, "Execute")
		self.button.on_clicked(self.process)
		self.intializeServos()
		
	def intializeServos(self):
		for i in range(width):
			servo = Servo(i)
			servo.set_servo_angle(90)
			
			print("Setting Angle")
			
	def process(self, event):
		
		execMat[execMat == 0] = -1
		# print(States[:, width:2*width])
		KsRes = []
		Servos = []
		for i in range(width):
			e = States[:, 5:10] # The width of the array for States
			loc = np.where(np.all((e-execMat[:,i])==0, axis=1))[0][0]
			KsRes.append(KS[loc, :])
			Servos.append(Servo(i))
		
		for res in KsRes:
			# pass
			print(res)
        	moveServos(KsRes, [], Servos)
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
plt.show()

