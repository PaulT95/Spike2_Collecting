# Spike2_Collecting
Spike script for collecting and sampling with a nice interface

You can change the sequencer to create specific TTL or DutyCycle signal and trigger the devices, it depends what you need
You can create or import specific ramps to follow via a live feedback (in this case you can chose the channel like Torque, Force, whatever)
You can snippet single shot based on the XYwidth you set in the XY view settings (default 15s). It export as MAT file all the channels from Cursor(0) when you clicked snippet to Cursor(0) + 17s. You can either increases this time window as you preferred. 
I am lazy to describe eveything but many other functions are included, but you can use it as you prefer and change the code. 

PS: here the frequency set in the Config File is 2000Hz so when exporting you will have all channels with 34000 points


Thanks to my first German Office Mate **[Tobi (the) Weingarten](https://github.com/vinjardin)** 🍷 who creates the first versions!!!

Example real time following ramp


  ![GIF_Ramp](https://user-images.githubusercontent.com/73119114/177746110-d5c6240d-1af0-44d8-83c9-f5e2dd74e2d0.gif)
