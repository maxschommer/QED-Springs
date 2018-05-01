import numpy as np
import matplotlib.pyplot as plt
from matplotlib.widgets import Button
import matplotlib
import pprint
from screeninfo import get_monitors
for m in get_monitors():
    print(str(m))

width = 10
height = 5


# w, h = matplotlib.figure.figaspect(3.)
fig = plt.figure(figsize=(width,height))

def buttonCallback(event):
    print('you pressed', event.button, event.xdata, event.ydata)
    button.color = 'Red'

class Index(object):
    ind = 0

    def next(self, event):
        self.ind += 1
        i = self.ind % len(freqs)
        ydata = np.sin(2*np.pi*freqs[i]*t)
        l.set_ydata(ydata)
        plt.draw()

    def prev(self, event):
        self.ind -= 1
        i = self.ind % len(freqs)
        ydata = np.sin(2*np.pi*freqs[i]*t)
        l.set_ydata(ydata)
        plt.draw()

callback = Index()
buttons = []
buttonAxes = []
for i in range(width):
    for j in range(height):
        buttonAxes.append(plt.axes([i/float(width), j/float(height), 1/(float(width)), 1/float(height)]))
        buttons.append(Button(buttonAxes[-1], ""))
        buttons[-1].on_clicked(buttonCallback)
# axprev = plt.axes([0.5, 0.05, 0.1, 0.075])
# axnext = plt.axes([0.81, 0.05, 0.1, 0.075])
# bnext = Button(axnext, 'Next')
# bnext.on_clicked(callback.next)
# bprev = Button(axprev, 'Previous')
# bprev.on_clicked(callback.prev)

mng = plt.get_current_fig_manager()
mng.resize(*mng.window.maxsize())
plt.show()