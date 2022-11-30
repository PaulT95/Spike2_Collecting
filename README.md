# Spike2 - Collecting Data
Spike2 script for collecting and sampling with an user-friendly interface. The main point that you need to adapt is the "Equipment options%" because it is associated with the sequencer. 

You can change the sequencer to create specific TTL or DutyCycle signal and trigger the devices, it depends what you need
You can create or import specific ramps to follow via a live feedback (in this case you can chose the channel like Torque, Force, whatever)
You can snippet single shot based on the XYwidth you set in the XY view settings (default 15s). It exports as MAT file all the channels from Cursor(0) when you clicked snippet to Cursor(0) + (X range + 2s). 
I am lazy to describe eveything but many other functions are included, but you can use it as you prefer and change the code. 

PS: here the frequency set in the Config File is 2000Hz so when exporting you will have all <b>RAW</b> channels with X width*2000 points


Thanks to my first German Office Mate **[Tobi (the) Weingarten](https://github.com/vinjardin)** 🍷 who creates the first version!!!

Example real time ramp with dynamic X-Range


  ![GIF_Ramp](https://user-images.githubusercontent.com/73119114/177746110-d5c6240d-1af0-44d8-83c9-f5e2dd74e2d0.gif)
