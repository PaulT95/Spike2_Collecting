#   Simple script to create a matrix with 2 columns to be plotted in Spike2 as a trace
#   Author: Paolo Tecchio

import numpy as np
import matplotlib.pyplot as plt
from tkinter import filedialog

# Create a matrix with 2 columns
# Column 1 = x (time points), Column 2 = y (whatever)
matrix = np.zeros((1000, 2))

# x points or time points
matrix[:, 0] = np.linspace(0, 40, 1000)

# y points
matrix[:, 1] = np.sin(matrix[:, 0]) * 20  # 20 is the amplitude
matrix = np.round(matrix, 2)

# Save the data to a text file
file_path = filedialog.asksaveasfilename(defaultextension=".txt", filetypes=[("Text Files", "*.txt")])

if file_path:
    np.savetxt(file_path, matrix, delimiter=',', comments='')

# Plot the data
plt.plot(matrix[:, 0], matrix[:, 1])
plt.xlabel('Time Points')
plt.ylabel('Y Values')
plt.show()

