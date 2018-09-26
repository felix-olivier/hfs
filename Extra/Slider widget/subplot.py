import mpld3
from mpld3 import plugins


#import numpy as np
import matplotlib.pyplot as plt
from matplotlib.widgets import Slider #, Button, RadioButtons
from plot_synth_func_working import plot_synth_func_working
#import numpy.random as rnd
#import matplotlib.gridspec as gridspec


## Execute function to get wavenr vs intensity ##
Ju=0.5
Jl=1.5
wavenrJ=8081.24
Au=0.000001
Al=0.000001
Bu=0.000001
Bl=0.000001
wavenrOBS, IOBS, E_Fu, E_Fl, E_Fu1,E_Fu2, E_Fu3, E_Fu4, E_Fu5, E_Fu6=plot_synth_func_working(Ju, Jl, wavenrJ, Au, Bu, Al, Bl)
##


fig, ax = plt.subplots()
plt.subplots_adjust(left=0.25, bottom=0.25)
#t = np.arange(0.0, 1.0, 0.001)
#a0 = 5
#f0 = 3
#s = a0*np.sin(2*np.pi*f0*t)
#l, = plt.plot(t, s, lw=2, color='red')
ax1= plt.subplot2grid((100,5),(2,1), rowspan=300, colspan=200)
l, = plt.plot(wavenrOBS,IOBS, lw=2, color='red') #l, ??

plt.axis([min(wavenrOBS)+0.5,max(wavenrOBS)-0.5, -1, 8.1])#defines axislimits
ax1.set_xlabel(r'$Wavenumber \/ (cm^{-1}) \rightarrow$', fontsize=16)
ax1.xaxis.set_label_position('top')
ax1.set_ylabel(r'$Intensity \rightarrow$', fontsize=16)
ax1.yaxis.set_label_position('right')
ax1.set_yticklabels([])

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


ax2 = plt.subplot2grid((100,5),(2,0), rowspan=300)
ax2.set_ylabel(r'$Energy \/ (cm^{-1}) \rightarrow$', fontsize=16)

ax2.set_yticklabels([])
ax2.set_xticklabels([])

q1, =plt.plot([2,4], [E_Fu[0], E_Fu[0]], lw=2, color='red')
q2, =plt.plot([2,4], [E_Fu[1], E_Fu[1]], lw=2, color='red')
q3, =plt.plot([2,4], [E_Fl[0], E_Fl[0]], lw=2, color='red')
q4, =plt.plot([2,4], [E_Fl[1], E_Fl[1]], lw=2, color='red')
q5, =plt.plot([2,4], [E_Fl[2], E_Fl[2]], lw=2, color='red')
q6, =plt.plot([2,4], [E_Fl[3], E_Fl[3]], lw=2, color='red')
ax2.set_xlim([0, 6])
ax2.set_ylim([16, 32])

#gs = gridspec.GridSpec(1,0)
#ax2.set_position(gs[0:2].get_position(fig))

##plt.show()

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
    wavenrOBS_n, IOBS_n, E_Fu_n, E_Fl_n, E_Fu1, E_Fu2, E_Fl1,E_Fl2,E_Fl3,E_Fl4=plot_synth_func_working(Ju, Jl, wavenrJ, Au_n, Bu, Al_n, Bl)
    #ax.axes.set_xlim([min(wavenrOBS_n)-0.5,max(wavenrOBS_n)+0.5])
    #ax.axes.set_ylim(-max(IOBS_n)*1.2,2)
    #ax.axes.set_ylim(-10,2)
#    l.set_ydata(IOBS_n)
#    fig.canvas.draw_idle()
    l.set_ydata(IOBS_n)
    l.set_xdata(wavenrOBS_n)
    
    q1.set_ydata(E_Fu1)
    q2.set_ydata(E_Fu2)
    q3.set_ydata(E_Fl1)
    q4.set_ydata(E_Fl2)
    q5.set_ydata(E_Fl3)
    q6.set_ydata(E_Fl4)
    
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
#plt.show()

#mpld3.save_html(fig, 'try.html')

