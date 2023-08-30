# Spike2 - Collecting Data
Spike2 script for collecting and sampling with an user-friendly interface. The main point that you need to adapt is the "Equipment options%" because it is associated with the sequencer. 

You can change the sequencer to create specific TTL or DutyCycle signal and trigger the devices, it depends what you need
You can create or import specific ramps/traces (txt files, with a matrix 2 col and n points) to follow via a live feedback (in this case you can chose the channel like Torque, Force, whatever), first column X (so time), second column array of ramp/trace to plot
You can snippet single shot based on the XYwidth you set in the XY view settings (default 15s). It exports as MAT file all the  <b>RAW</b> channels from Cursor(0) when you clicked snippet to Cursor(0) + (XY width) + 1s, so one second before you see feedback in the XY view and one second after the end of the XY view. 
You can either import a txt file with two columns (X and Y values) and plot them for non-linear/special traces. See matlab example code for create sinewave ramps to be plot. I reccomend to not create milions of points
The sequencer is flexible now, so when you change the values in the "XY rep /Seq Config" this will be updated in background in the sequencer, so you don't have everytime to re-program the sequencer. You can also perform repetitive ramp/cycle. So the XY view will be repeated as many times as you set. Each time the XY restarts to be repeated, the sample key is sent to the sequencer for triggering again the tools (for example repetitive stretch-shortening cycles).
I made that the xy restart from 0 every cycle and does not scroll because after ~2min plotting the view starts flickering and becomes hard to follow as well the participants become idiots with the eyes. Further, in this way the vertical dashed lines will be permament independently of the cycle;)

THE GAME MODE is available;)
I am lazy to describe eveything but many other functions are included, but you can use it as you prefer and change the code. 

Example: here the frequency set in the Config File is 2000Hz so when exporting you will have all <b>RAW</b> channels with (X width + 2) *2000 points


Thanks to my first German Office Mate **[Tobi (the) Weingarten](https://github.com/vinjardin)** 🍷 who created the first version!!!

## Example real-time plotting and ramp using GAME MODE


  ![GIF_Ramp](https://user-images.githubusercontent.com/73119114/177746110-d5c6240d-1af0-44d8-83c9-f5e2dd74e2d0.gif)
