SET    0.01, 2, 0    ; clock tick = 10 microseconds

DAC    3,0    ;tendontapper
DAC    2,0    ;ultrasound 
DAC    1,5    ;vicon start, starts / stops when pulled from high to low, therefore initially set high
DAC    0,5    ;vicon stop
DIGOUT [....01..]    ;digital bits 2 and 3 control the isomed, initially one of them is set high to be able to simply invert them,
;!!!!! A WARNING should be send to the user before running the sequencer / the script that is calling it !!!!!
HALT    

;DEFINITIONS FOR TESTING PURPOSES APART FROM THE STUDY PROTOCOL
INFUS: 'U  DAC 2, 4
           DELAY s(1/150)-5
           DAC 2, 0
           BEQ V1, 1, INFUS    ;V1 is manually updated via a button click in the toolbar
           HALT

ISOMED: 'I  DIGOUT [....ii..]
            HALT 


;DEFINITIONS FOR 15 SECOND USE OF SINGLE OR COMBINATION OF MEASUREMENT EUIPMENT, TODO: make this dynamic in the future.
NONE: 'n HALT

;this was just for testing
TAPPY: 'j REPORT
          DELAY s(1)
          DAC 3, 9.5
          DELAY s(5)
          DAC 3, 0
          HALT

TAP: 't  MOVI V2, 750
TAPREP:  REPORT
         DAC 3, 9.5
         DELAY s(1/100)-2    ;delay 0.01s twice resulting in a 50% duty cycle at 50 Hz
         DAC 3, 0    ;9.5V to piezo controller which takes this value times 15
         DELAY s(1/100)-4
         DBNZ V2, TAPREP
         HALT

ULTRA: 'u  MOVI V2, 2250 
ULTRAREP:  DAC 2, 4
           DELAY s(1/150)-5
           DAC 2, 0
           DBNZ V2, ULTRAREP
           HALT

VICON: 'v  DAC 1, 0
           DELAY s(15)-1
           DAC 0, 0
           DELAY ms(10)    ;make sure pulling DAC0 low was recognized by vicon
           DAC 1, 5    ;reset the DACs so Vicon could be triggered again
           DAC 0, 5
           HALT

ISO: 'i  DELAY s(6.5)-2    ;3 seconds pre ramp, 2 seconds ramp, move 1.5 seconds after ramp
         DIGOUT [....ii..]
         HALT 

     

TUV: '1  MOVI V2, 750
         DAC 1, 0    ;start vicon recording

         ;#tap1on       
TUVREP:  REPORT
         DAC 3, 9.5
         ;#us1
         DAC 2, 4   
         DElAY ms(1) - 1
         DAC 2, 0    ;since #us1 1ms + 2 clock ticks have passed
 
         DELAY s(1/150) - ms(1) - 3    ;since #us1 1/150s have passed
         ;#us2
         DAC 2, 4    
         DElAY ms(1) - 1
         DAC 2, 0    ;since #us2 1ms + 2 clock ticks have passed, since #tap1on 1/150s + 1ms + 3 clock ticks have passed

         DELAY s(0.5/150) - ms(1) - 4    ;since #tap1on exactly 1.5/150s or 0.5/50s have passed
         ;#tap1off
         DAC 3, 0    ;since #us2 0.5/150s have passed
         
         DELAY s(0.5/150) - 1    ;since #us2 1/150s have passed
         ;#us3
         DAC 2, 4    
         DElAY ms(1) -1
         DAC 2, 0    ;since #us3 1ms + 2 clock ticks have passed, since #tap1off 0.5/150s + 1ms + 3 clock ticks have passed

         DELAY s(1/150) - ms(1) - 6
         DBNZ V2, TUVREP    ;since #tap1off 1.5/150s have passed, since #us3 1/150s -1 clock tick has passed
            
         DAC 0, 0    ;turn off vicon
         DELAY ms(5) ;has to be at least 3 ms on ground to be detected by vicon lock in case someone needs this in a tighter code
         DAC 0, 5
         DAC 1, 5  
         HALT

ALL: '2  MOVI V2, 324
         DAC 1, 0    ;start vicon recording

         ;#tap1on       
ALLREP:  REPORT
         DAC 3, 9.5
         ;#us1
         DAC 2, 4   
         DElAY ms(1) - 1
         DAC 2, 0    ;since #us1 1ms + 2 clock ticks have passed
 
         DELAY s(1/150) - ms(1) - 3    ;since #us1 1/150s have passed
         ;#us2
         DAC 2, 4    
         DElAY ms(1) - 1
         DAC 2, 0    ;since #us2 1ms + 2 clock ticks have passed, since #tap1on 1/150s + 1ms + 3 clock ticks have passed

         DELAY s(0.5/150) - ms(1) - 4    ;since #tap1on exactly 1.5/150s or 0.5/50s have passed
         ;#tap1off
         DAC 3, 0    ;since #us2 0.5/150s have passed
         
         DELAY s(0.5/150) - 1    ;since #us2 1/150s have passed
         ;#us3
         DAC 2, 4    
         DElAY ms(1) -1
         DAC 2, 0    ;since #us3 1ms + 2 clock ticks have passed, since #tap1off 0.5/150s + 1ms + 3 clock ticks have passed

         DELAY s(1/150) - ms(1) - 6
         DBNZ V2, ALLREP    ;since #tap1off 1.5/150s have passed, since #us3 1/150s -1 clock tick has passed
         
         REPORT
         DAC 3, 9.5
         ;#us1
         DAC 2, 4   
         DElAY ms(1) - 1
         DAC 2, 0    ;since #us1 1ms + 2 clock ticks have passed
 
         DELAY s(1/150) - ms(1) - 3    ;since #us1 1/150s have passed
         ;#us2
         DAC 2, 4    
         DElAY ms(1) - 1
         DAC 2, 0    ;since #us2 1ms + 2 clock ticks have passed, since #tap1on 1/150s + 1ms + 3 clock ticks have passed

         DELAY s(0.5/150) - ms(1) - 4    ;since #tap1on exactly 1.5/150s or 0.5/50s have passed
         ;#tap1off
         DAC 3, 0    ;since #us2 0.5/150s have passed
         
         DELAY s(0.5/150) - 1    ;since #us2 1/150s have passed
         ;#us3
         DAC 2, 4    
         DElAY ms(1) -1
         DAC 2, 0    ;since #us3 1ms + 2 clock ticks have passed, since #tap1off 0.5/150s + 1ms + 3 clock ticks have passed

         DELAY s(1/150) - ms(1) - 8
         
         MOVI V2, 425
         DIGOUT [....ii..]
         
ALLREP2:  REPORT
          DAC 3, 9.5
          ;#us1
          DAC 2, 4   
          DElAY ms(1) - 1
          DAC 2, 0    ;since #us1 1ms + 2 clock ticks have passed
 
          DELAY s(1/150) - ms(1) - 3    ;since #us1 1/150s have passed
          ;#us2
          DAC 2, 4    
          DElAY ms(1) - 1
          DAC 2, 0    ;since #us2 1ms + 2 clock ticks have passed, since #tap1on 1/150s + 1ms + 3 clock ticks have passed
 
          DELAY s(0.5/150) - ms(1) - 4    ;since #tap1on exactly 1.5/150s or 0.5/50s have passed
          ;#tap1off
          DAC 3, 0    ;since #us2 0.5/150s have passed
          
          DELAY s(0.5/150) - 1    ;since #us2 1/150s have passed
          ;#us3
          DAC 2, 4    
          DElAY ms(1) -1
          DAC 2, 0    ;since #us3 1ms + 2 clock ticks have passed, since #tap1off 0.5/150s + 1ms + 3 clock ticks have passed

          DELAY s(1/150) - ms(1) - 6
          DBNZ V2, ALLREP2    ;since #tap1off 1.5/150s have passed, since #us3 1/150s -1 clock tick has passed
         
             
         DAC 0, 0    ;turn off vicon
         DELAY ms(5) ;has to be at least 3 ms on ground to be detected by vicon lock in case someone needs this in a tighter code
         DAC 0, 5
         DAC 1, 5  
         HALT
         