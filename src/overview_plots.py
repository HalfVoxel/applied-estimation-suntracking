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
rcParams['font.size'] = 24
rcParams['mathtext.default'] = 'regular'

for plotIdx in range(5):
    fig, axs = plt.subplots(2, figsize=(12, 5), sharey=True, sharex=False)


    # colors = ["#fdd49e", "#fdbb84", "#fc8d59", "#e34a33"]
    colors = ["#fdbb84", "#fc8d59", "#e34a33", "#b30000"]

    data = [[float(v) for v in r.split(',')] for r in open(f"overview{plotIdx}.mat").read().strip().split('\n')]
    values = np.array(data)
    print(values[1, :].shape)
    values[1, :] *= (180 / math.pi)

    # circ = Circle((0.5, 100), 150, alpha=0.0, fc='yellow')
    # circ.center = self.x0 + dx, self.y0 + dy
    # ax.add_patch(circ)
    # line.set_clip_path(circ)

    ax = axs[1]
    ax.plot(values[0, :], values[1, :], color="#e43b1a")
    # ax.plot([values[0,0], values[0,-1]], [0,0], color="#890f10")

    ax.set_xlim(np.min(values[0, :]), np.max(values[0, :]))

    # ax.set_ylabel("Sun angle [degrees]")
    # ax.set_xlabel("Time [days]")

    mx = np.max(values[1, :])
    mn = np.min(values[1, :])
    mx_margin = mx * 1.1
    mn_margin = mn * 1.1

    if mx >= 85:
        ax.set_yticks([-90, 0, 90])
        ax.set_yticks([-45, 45], minor=True)


    def add_daynight(ax, mn, mx):
        labels = ['Night', 'Day']
        ax2 = ax.twinx()
        ax2.set_ylim(ax.get_ylim())
        ax2.tick_params(axis='y', which='both', labelleft=False, labelright=True, length=0)
        ax2.set_yticks([mn*0.5, mx*0.5])
        ax2.set_yticklabels(labels)


    zoom_indices = [2000, 2500]
    rect = Rectangle((values[0, zoom_indices[0]], mn), values[0, zoom_indices[1]] - values[0, zoom_indices[0]], mx - mn, linewidth=1, edgecolor='#000000', facecolor='none', zorder=5)

    con = ConnectionPatch((0, 0), (values[0, zoom_indices[0]], mx), 'axes fraction', 'data', axesA=axs[0], axesB=axs[1])
    ax.add_artist(con)
    con = ConnectionPatch((1, 0), (values[0, zoom_indices[1]], mx), 'axes fraction', 'data', axesA=axs[0], axesB=axs[1])
    ax.add_artist(con)
    ax.add_patch(rect)
    ax.fill([values[0, 0], values[0, 0], values[0, -1], values[0, -1]], [mn_margin, 0, 0, mn_margin], alpha=0.3, facecolor="#377eb8", zorder=4, edgecolor='none')
    ax.fill([values[0, 0], values[0, 0], values[0, -1], values[0, -1]], [mx_margin, 0, 0, mx_margin], alpha=0.3, facecolor="#ffffb3", zorder=4, edgecolor='none')

    ax = axs[0]
    ax.xaxis.tick_top()
    ax.plot(values[0, zoom_indices[0]:zoom_indices[1]], values[1, zoom_indices[0]:zoom_indices[1]], color="#e43b1a")
    ax.fill([values[0, zoom_indices[0]], values[0, zoom_indices[0]], values[0, zoom_indices[1]], values[0, zoom_indices[1]]],
            [mn_margin, 0, 0, mn_margin], alpha=0.3, edgecolor='none', facecolor="#377eb8", zorder=4)
    ax.fill([values[0, zoom_indices[0]], values[0, zoom_indices[0]], values[0, zoom_indices[1]], values[0, zoom_indices[1]]],
            [mx_margin, 0, 0, mx_margin], alpha=0.3, edgecolor='none', facecolor="#ffffb3", zorder=4)
    ax.set_ylim(mn_margin, mx_margin)
    ax.set_xlim(np.min(values[0, zoom_indices[0]:zoom_indices[1]]), np.max(values[0, zoom_indices[0]:zoom_indices[1]]))

    minorLocator = MultipleLocator(1)
    majorLocator = MultipleLocator(5)
    ax.xaxis.set_minor_locator(minorLocator)
    ax.xaxis.set_major_locator(majorLocator)

    # ax.set_ylabel("Sun angle [degrees]")
    # ax.set_xlabel("Time [days]")
    add_daynight(axs[0], mn, mx)
    add_daynight(axs[1], mn, mx)


    fig.text(0.5, 0.05, 'Time [days]', ha='center')
    fig.text(0.02, 0.5, 'Sun height [degrees]', va='center', rotation='vertical')
    plt.tight_layout(pad=2, h_pad=0)

    # ax.plot(*np.array(locked).T, color="#e41a1c")
    # ax.add_patch(Rectangle((11, -1), 1, 3, facecolor="#EEEEEE", zorder=10, edgecolor="#000000"))
    # ax.add_patch(Rectangle((16, -1), 1, 3, facecolor="#EEEEEE", zorder=10, edgecolor="#000000"))
    # ax.add_patch(Rectangle((19, -1), 1, 3, facecolor="#EEEEEE", zorder=10, edgecolor="#000000"))
    # plt.text(11.5, 0.5, "Jump", {'ha': 'center', 'va': 'center'}, rotation=90, zorder=11)
    # plt.text(16.5, 0.5, "Jump", {'ha': 'center', 'va': 'center'}, rotation=90, zorder=11)
    # plt.text(19.5, 0.5, "Stop", {'ha': 'center', 'va': 'center'}, rotation=90, zorder=11)
    # ax.set_xlabel('Footprint number [1]')
    # ax.set_ylabel('s [1]')

    # plt.text(7.3, 0.46, "σ=10", {'ha': 'center', 'va': 'center'}, rotation=67, zorder=11)
    # plt.text(8, 0.4, "σ=6", {'ha': 'center', 'va': 'center'}, rotation=68, zorder=11)
    # plt.text(8.65, 0.35, "σ=3", {'ha': 'center', 'va': 'center'}, rotation=70, zorder=11)


    # minorLocator = MultipleLocator(1)
    # majorLocator = MultipleLocator(5)
    # ax.xaxis.set_minor_locator(minorLocator)
    # ax.xaxis.set_major_locator(majorLocator)

    # plt.show()
    pdf = PdfPages(f'/Users/arong/cloud/Skolarbeten/ML-2/estimation/project/sun_overview{plotIdx}.pdf')
    pdf.savefig(fig)
    pdf.close()
    # plt.savefig('../final_images/speed' + ("_annotated" if annotate else "") + '.png', transparent=True)

