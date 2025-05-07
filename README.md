# PATEC Script: Spike2 Data Collection

The PATEC script is a user-friendly Spike2 script designed for collecting and sampling data efficiently. This tool provides a customizable interface for diverse lab settings, making data acquisition straightforward and flexible.

## Overview
The primary functions and operational details of this script are described in the [Readme](https://github.com/PaulT95/Spike2_Collecting/blob/main/Spike_Config_FINALE/Extra/Patec_ReadMe.pdf). The script allows for real-time updates to the sequencer, enabling users to create specific TTL or DutyCycle signals to trigger devices as needed. Depending on your goals, the sequencer can adapt in real time with a fixed setup.

### Main features
1. **Ramps and Traces with Real-Time Visual Feedback**:
   - Users can create or import linear ramp directly in Spike2
   - Select two channels from the Sampling configuration for live feedback plotting. By default X = Time (none), Y = a channel. However, it is now possible to select both X and Y channels over time. 
   - Import non-linear or custom traces to plot and import from `.txt` files (formatted as two columns: X for time or any other channel/variable, and Y for the ramp/trace array). Examples available in MATLAB/Python for generating sinewave ramps are in the extra folder.
   - A hand-draw feature is included for creating custom paths with the mouse.
   - Users can visualize and follow real-time feedback and follow specific traces designed in the XY ramp.

2. **Snippet Functionality**:
   - Lunch the visual live feedback, while the sequencer does the hard work in the back ground. Extract then the data within a user-defined XY range (default: 15s) set in the XY-ramp settings.
   - The snippet exports all **RAW** channels as a `.MAT` file, capturing data from Cursor(0) to Cursor(0) + (XY width range * n repetition) + 1s. This includes one second before and after the defined range to ensure comprehensive data collection.

Further details and explanation are provided in the readme file.

### Sequencer Details
The sequencer dynamically updates based on changes made in the "XY Rep / Seq Config" settings, eliminating the need for manual reprogramming. This:
   - Facilitates rapid testing and piloting across various conditions.
   - Supports repetitive ramp wtih cycle operations.

When repeating cycles, the XY view resets to 0 at the beginning of each cycle, avoiding continuous scrolling. This ensures smoother visualization and minimizes flickering, which can be visually distracting and hard to follow for participants. This also allows permanent vertical dashed lines in the plot, providing consistent visual reference points, regardless of the cycle.

## Auto-Saving Ultrasound Videos
For Telemed ultrasound video saving in `.tvd` format, you can use the accompanying executable console script. Refer to the [Save TVD](https://github.com/PaulT95/Save_TVD_exe) library for details. Additionally, commands to control EchoWave via Spike2 buttons can be implemented using the [EchoWave CMD](https://github.com/PaulT95/EchoWave_cmd) library.

## Trigger box - Dynamometer
Who is in the field of Neuromechanics and movement science like me, likely they use a dynamometer. To trigger the rotation of the device's lever arm, I designed a triggering box controlled via Spike2 and two digital bits via the sequencer file. Specifically, this box was made up for the [Isomed2000](http://www.isomed2000.de/prod.im.intro.php?lc=de_il), but I would be happy to help in case of updating docs for any other device you use in the lab. 

## Extra
Inside the Fusshalter model folder, you can the STL model to 3D print. They were designed to adapt to the footplate adapter of the dynamometer, in order to generate a rigid part for dorsiflexion contractions.

## Acknowledgments
Special thanks to my first German office mate, **[Tobi Weingarten](https://github.com/vinjardin)** 🍇, for invaluable assistance!

## Citation
If you use this script, please credit it as follows:

"The library used is publicly available on [GitHub](https://github.com/PaulT95/Spike2_Collecting)."

Thank you for choosing this library. Happy data collection and coding! 😄

## Example: Real-Time Visual Torque Feedback
Below is an example of real-time torque feedback on a linear ramp using GAME MODE. The first dashed line indicates the start of the dynamometer rotation, triggered by DIGOUT set up automatically in the sequencer.

![GIF_Ramp](https://user-images.githubusercontent.com/73119114/177746110-d5c6240d-1af0-44d8-83c9-f5e2dd74e2d0.gif)
