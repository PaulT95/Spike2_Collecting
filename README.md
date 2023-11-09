# PATEC script: Spike2 Collecting Data

PATEC script is a Spike2 script for collecting and sampling data with a user-friendly interface implemented in Spike2.



## How it works

You can change the sequencer to create a specific TTL or DutyCycle signal and trigger the devices, it depends on what you need. However, this script can update the sequencer in real time (with a fixed setup), depending on your goals.
You can create or import specific ramps/traces (txt files, with a matrix of 2 col and n points) to follow via live feedback (in this case you can choose the channel like Torque, Force, whatever), first column X (so time), second column array of ramp/trace to plot
You can snippet a single shot based on the XYwidth you set in the XY view settings (default 15s). It exports as MAT file all the  <b>RAW</b> channels from Cursor(0) when you click snippet to Cursor(0) + (XY width) + 1s, so one second before you see feedback in the XY view and one second after the end of the XY view. 
You can either import a Txt file with two columns (X and Y values) and plot them for non-linear/special traces. See Matlab/Python example code for creating sinewave ramps to be plotted. I recommend creating millions of points
The sequencer is flexible now, so when you change the values in the "XY rep /Seq Config" this will be updated in the background in the sequencer, so you don't have to re-program the sequencer. You can also perform repetitive ramp/cycle. So the XY view will be repeated as many times as you set. Each time the XY restarts to be repeated, the sample key is sent to the sequencer to trigger again the tools (for example repetitive stretch-shortening cycles).
I made that the xy restart from 0 every cycle and does not scroll because after ~2min plotting the view starts flickering and becomes hard to follow as well the participants become idiots with the eyes. Further, in this way, the vertical dashed lines will be permanent independently of the cycle;)

THE GAME MODE is available;)
I am lazy to describe everything but many other functions are included, but you can use it as you prefer and change the code. 

Example: Here the frequency set in the Config File is 2000Hz so when exporting you will have all <b>RAW</b> channels with (X width + 2) *2000 points


## Auto saving of Telemed ultrasound video in tvd format
To use the exe console script I created please refers to the following library [Save TVD](https://github.com/PaulT95/Save_TVD_exe) or if you want to implement any command to control EchoWave via Spike2 buttons you can use [EchoWave CMD](https://github.com/PaulT95/EchoWave_cmd). 


## Acknowledgments 
Thanks to my first German Office Mate **[Tobi (the) Weingarten](https://github.com/vinjardin)** 🍷 who helped me!!!

## How to mention
You can credit this work by including the following text:

"The library used is publicly available on [GitHub](https://github.com/PaulT95/Spike2_Collecting) ."

Thank you for choosing this library. Happy coding! 😄

## Example real-time torque feedback on a drawn ramp using GAME MODE


  ![GIF_Ramp](https://user-images.githubusercontent.com/73119114/177746110-d5c6240d-1af0-44d8-83c9-f5e2dd74e2d0.gif)
