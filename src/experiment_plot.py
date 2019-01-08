#!/usr/local/bin/python3
import numpy as np
import sys
import math
from matplotlib import rcParams
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages
from matplotlib.ticker import MultipleLocator
from matplotlib.patches import Rectangle, Circle, ConnectionPatch

rcParams['font.family'] = 'serif'
rcParams['font.serif'] = ['CMU Serif']
rcParams['font.size'] = 12
rcParams['mathtext.default'] = 'regular'

for plotIdx in range(1,7):
    # fig, axs = plt.subplots(4, figsize=(12, 5), sharey=False, sharex=True)


    # colors = ["#fdd49e", "#fdbb84", "#fc8d59", "#e34a33"]
    colors = ["#fdbb84", "#fc8d59", "#e34a33", "#b30000"]
    fig = plt.figure(figsize=(9,4))

    data = [[float(v) for v in r.split(',')] for r in open(f"../test{plotIdx}/states.csv").read().strip().split('\n')]
    values = np.array(data)
    state_times = values[0,:]
    state_times -= state_times[0]
    state_lats = values[1,:] * 180/math.pi
    heights = values[2,:]
    time_error = values[3,:]
    day_error = values[4,:]
    lat_error = values[5,:]
    estimated_time = values[6,:]
    estimated_lat = values[7,:] * 180/math.pi
    estimated_lat *= np.sign(estimated_lat * state_lats)

    print(values[1, :].shape)

    ax = plt.subplot2grid((3,2), (0,0), rowspan=2)
    ax.plot(state_times, heights, 'o', markersize=0.5, color="#377eb8")
    ax.margins(0)
    ax.set_ylim([0,91])
    ax.set_yticks([0, 30, 60, 90])
    ax.set_yticks([15, 45, 75], minor=True)
    # ax.set_visible(False)
    ax.tick_params(axis='x', left=False, top=False, right=False, bottom=True, labelleft=False, labeltop=False, labelright=False, labelbottom=False)
    ax.set_ylabel("Sun angle [deg]")

    ax = plt.subplot2grid((3,2), (2,0), rowspan=1, sharex=ax)
    ax.plot(state_times, estimated_lat, color="#e43b1a")
    ax.plot(state_times, state_lats, color="#377eb8")
    print(estimated_lat)
    ax.set_ylim([-1,91])
    ax.set_yticks([0, 45, 90])
    ax.set_yticks([22.5, 45 + 22.5], minor=True)
    ax.margins(0)
    ax.set_ylabel("Latitude [deg]")
    ax.set_xlabel("Time [days]")

    ax = plt.subplot2grid((3,2), (0,1))
    ax.plot(state_times, time_error * 60, color="#e43b1a")
    ax.set_ylim([-30,30])
    ax.tick_params(axis='x', left=False, top=False, right=False, bottom=True, labelleft=False, labeltop=False, labelright=False, labelbottom=False)
    minorLocator = MultipleLocator(5)
    ax.yaxis.set_minor_locator(minorLocator)

    ax.set_ylabel("$E_{day}$ [min]")

    ax = plt.subplot2grid((3,2), (1,1), sharex=ax)
    ax.plot(state_times, day_error, color="#e43b1a")
    ax.set_ylim([-1,40])
    ax.tick_params(axis='x', left=False, top=False, right=False, bottom=True, labelleft=False, labeltop=False, labelright=False, labelbottom=False)
    # ax.set_yscale('log')
    ax.set_ylabel("$E_{year}$ [days]")

    ax = plt.subplot2grid((3,2), (2,1), sharex=ax)
    ax.plot(state_times, lat_error, color="#e43b1a")
    ax.set_ylim([-1,10])
    minorLocator = MultipleLocator(1)
    ax.yaxis.set_minor_locator(minorLocator)
    # ax.xaxis.set_major_locator(majorLocator)
    # majorLocator = MultipleLocator(5)
    ax.set_xlabel("Time [days]")

    # ax.set_yscale('log')
    ax.set_ylabel("$E_{lat}$ [deg]")

    plt.tight_layout()


    # plt.show()
    pdf = PdfPages(f'/Users/arong/cloud/Skolarbeten/ML-2/estimation/project/experiment_{plotIdx}.pdf')
    pdf.savefig(fig)
    pdf.close()

