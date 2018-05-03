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
import copy

KS = genfromtxt('./4_11 working/KS.csv', delimiter=',')
StateInfo = genfromtxt('./4_11 working/StateInfo.csv', delimiter=',')


width = 1
height = 5


# w, h = matplotlib.figure.figaspect(3.)
fig = plt.figure(figsize=(width,height))

execMat = np.zeros((height, width))

class Servo(object):
	"""A class for a single servo with functions to move it"""
	def __init__(self, pwm, PinNum, servo_min=150, servo_max=600):
		super(Servo, self).__init__()
		self.PinNum = PinNum
		self.servo_min = servo_min  # Min pulse length out of 4096
		self.servo_max = servo_max  # Max pulse length out of 4096
		self.pwm = pwm

	def set_servo_angle(self, angle):
		pulse = int((angle)*(self.servo_max - self.servo_min) + self.servo_min)
#		pulse_length = 1000000    # 1,000,000 us per second
#		pulse_length //= 60       # 60 Hz
#		pulse_length //= 4096     # 12 bits of resolution
#		pulse *= 1000
#		pulse //= pulse_length
		print(pulse)
		self.pwm.set_pwm(self.PinNum, 0, pulse)


def moveServos(KSIn, IDXs, Servos, timeEnd=10, res=500, scaling=.1):
	As = []
	Fs = []
	DriveFuncs = []

	for i, K in enumerate(KSIn, 0):
		Fs.append(K[0:int(len(K)/2)])
		As.append(K[int(len(K)/2-1):-1])
	print(Fs[0])
	print(As[0])
	for i in range(width):
		drive = lambda t, i=i: np.dot(np.sin(t*Fs[i]),As[i])*scaling +.5 # Have to set i as the default argument so lambda function isn't overwritten.
		DriveFuncs.append(drive);
	
	t0 = time.time();
	t = 0;
	while t < timeEnd:
		t = time.time()-t0;
		for i, Servo in enumerate(Servos, 0):
			print(DriveFuncs[i](t))
			Servo.set_servo_angle(DriveFuncs[i](t))
	
class ExecuteButtonProcessor(object):
	def __init__(self, axes, label):
		self.axes = axes
		self.button = Button(axes, "Execute")
		self.button.on_clicked(self.process)

	def process(self, event):
		pwm = Adafruit_PCA9685.PCA9685()
		execMat[execMat == 0] = -1
		# print(StateInfo[:, width:2*width])
		KsRes = []
		Servos = []
		for i in range(width):
			e = StateInfo[:, width:2*width]
			loc = np.where(np.all((e-execMat[:,i])==0, axis=1))#[0][0]
			KsRes.append(KS[loc, :])
			Servos.append(Servo(pwm, i))
		
		for res in KsRes:
			print(res)
        	moveServos(KsRes, [], Servos)
        	execMat[execMat == -1] = 0
		# print(KsRes)

#       for column in 
    
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


# mng = plt.get_current_fig_manager()
# mng.resize(*mng.window.maxsize())
plt.show()

