import numpy as np
import matplotlib
# matplotlib.use("qt4agg")
# def patch_qt4agg():
#     import matplotlib.backends.backend_qt4agg as backend
#     code = """
# def draw( self ):
#     FigureCanvasAgg.draw(self)
#     self.repaint()
#     FigureCanvasQTAgg.draw = draw    
# """
#     exec(code, backend.__dict__)

# patch_qt4agg()

import matplotlib.pyplot as plt
from matplotlib.widgets import Button
# import matplotlib
import pprint
from screeninfo import get_monitors


for m in get_monitors():
    print(str(m))

width = 10
height = 5


# w, h = matplotlib.figure.figaspect(3.)
fig = plt.figure(figsize=(width,height))

execMat = np.zeros((height, width))
        
class ButtonClickProcessor(object):

    def __init__(self, axes, label, i, j):
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
        print(execMat)
        self.colorMode = not self.colorMode
        self.button.color = self.colors[self.colorMode]
        self.button.hovercolor = self.button.color

buttons = []
buttonAxes = []
for i in range(width):
    for j in range(height):
        buttonAxes.append(plt.axes([i/float(width), j/float(height), 1/(float(width)), 1/float(height)]))
        buttons.append(ButtonClickProcessor(buttonAxes[-1], "", i, height-1-j))

# mng = plt.get_current_fig_manager()
# mng.resize(*mng.window.maxsize())
plt.show()