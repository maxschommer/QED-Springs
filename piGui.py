import numpy as np
import matplotlib
import pyautogui
import matplotlib.pyplot as plt
from matplotlib.widgets import Button
import pprint
from screeninfo import get_monitors


for m in get_monitors():
    print(str(m))

width = 5
height = 5


# w, h = matplotlib.figure.figaspect(3.)
fig = plt.figure(figsize=(width,height))

execMat = np.zeros((height, width))
        
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
        buttonAxes.append(plt.axes([i/float(width), j/float(height), 1/(float(width)), 1/float(height)]))
        buttons.append(ButtonClickProcessor(buttonAxes[-1], "", i, height-1-j))

# mng = plt.get_current_fig_manager()
# mng.resize(*mng.window.maxsize())
plt.show()