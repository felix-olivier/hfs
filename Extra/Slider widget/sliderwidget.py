import numpy as np
import matplotlib.pyplot as plt
from matplotlib.widgets import Slider, Button, RadioButtons
from plot_synth_func_working import plot_synth_func_working
from plot_synth_func_workingInitial import plot_synth_func_workingInitial


## Execute function to get wavenr vs intensity ##
Ju=0.5
Jl=1.5
wavenrJ=8081.2+0.04
Au=0.075
Al=0.018
Bu=-0.007
Bl=0.005
wavenrOBS, IOBS=plot_synth_func_workingInitial(Ju, Jl, wavenrJ, Au, Bu, Al, Bl)
##


fig, ax = plt.subplots()
plt.subplots_adjust(left=0.25, bottom=0.25)
#t = np.arange(0.0, 1.0, 0.001)
#a0 = 5
#f0 = 3
#s = a0*np.sin(2*np.pi*f0*t)
#l, = plt.plot(t, s, lw=2, color='red')
l, = plt.plot(wavenrOBS,IOBS, lw=2, color='red') #l, ??

plt.axis([min(wavenrOBS)+0.5,max(wavenrOBS)-0.5, -1, 8.1])#defines axislimits

#ax.axes.set_xlim([min(wavenrOBS)-0.5,max(wavenrOBS)+0.5])
#
#axcolor = 'lightgoldenrodyellow'
#axfreq = plt.axes([0.25, 0.1, 0.65, 0.03], facecolor=axcolor)
#axamp = plt.axes([0.25, 0.15, 0.65, 0.03], facecolor=axcolor)
#axfreq = plt.axes([0.25, 0.1, 0.65, 0.03])
#axamp = plt.axes([0.25, 0.15, 0.65, 0.03])
axAu=plt.axes([0.25, 0.1, 0.65, 0.03]) #position of sliders
axAl=plt.axes([0.25, 0.15, 0.65, 0.03])

#sfreq = Slider(axfreq, 'Freq', 0.1, 30.0, valinit=f0)
#samp = Slider(axamp, 'Amp', 0.1, 10.0, valinit=a0)

sfreq = Slider(axAu, 'Au', -0.03, 0.03, valinit=0,dragging=True)
samp = Slider(axAl, 'Al', -0.03, 0.03, valinit=0,dragging=True)

#def update(Al_n, Au_n):
##    Al_n = samp.val
##    Au_n = sfreq.val
#
#    #l.set_ydata(amp*np.sin(2*np.pi*freq*t))
#    wavenrOBS_n, IOBS_n=plot_synth_func_working(Ju, Jl, wavenrJ, Au_n, Bu, Al_n, Bl)
#    l.set_ydata(IOBS_n)
#    fig.canvas.draw_idle()
#    
#sfreq.on_changed(update(samp.val,sfreq.val))
#samp.on_changed(update(samp.val,sfreq.val))


def update(val):
    Al_n = samp.val
    Au_n = sfreq.val

    #l.set_ydata(amp*np.sin(2*np.pi*freq*t))
    wavenrOBS_n, IOBS_n=plot_synth_func_working(Ju, Jl, wavenrJ, Au_n, Bu, Al_n, Bl)
    #ax.axes.set_xlim([min(wavenrOBS_n)-0.5,max(wavenrOBS_n)+0.5])
    #ax.axes.set_ylim(-max(IOBS_n)*1.2,2)
    #ax.axes.set_ylim(-10,2)
#    l.set_ydata(IOBS_n)
#    fig.canvas.draw_idle()
    l.set_ydata(IOBS_n)
    l.set_xdata(wavenrOBS_n)
    #plt.axis([min(wavenrOBS_n),max(wavenrOBS_n), -3, max(IOBS)*1.2])
    fig.canvas.draw()
    
sfreq.on_changed(update)
samp.on_changed(update)
    
#sfreq_previous=0
#samp_previous=0
#conti=0
#
#while conti<1:
#    if sfreq.val!=sfreq_previous:
#        update()
#        sfreq_previous=sfreq.val
#        conti=conti+0.00001




#resetax = plt.axes([0.8, 0.025, 0.1, 0.04])
#button = Button(resetax, 'Reset', color=axcolor, hovercolor='0.975')
#
#
#def reset(event):
#    sfreq.reset()
#    samp.reset()
#button.on_clicked(reset)

#rax = plt.axes([0.025, 0.5, 0.15, 0.15], facecolor=axcolor)
#rax = plt.axes([0.025, 0.5, 0.15, 0.15])
#radio = RadioButtons(rax, ('red', 'blue', 'green'), active=0)


#def colorfunc(label):
#    l.set_color(label)
#    fig.canvas.draw_idle()
#radio.on_clicked(colorfunc)

#plt.show() #???????????

#plt.plot(wavenrOBS, IOBS)
plt.show()
