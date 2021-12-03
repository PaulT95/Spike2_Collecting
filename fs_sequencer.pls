SET    0.01, 1, 0    ; clock tick = 10 microseconds

DAC    2, 0    ;ultrasound 
DIGOUT [....01..]    ;digital bits 2 and 3 control the isomed, initially one of them is set high to be able to simply invert them,
;!!!!! A WARNING should be send to the user before running the sequencer / the script that is calling it !!!!!
HALT    

;DEFINITIONS FOR TESTING PURPOSES APART FROM THE STUDY PROTOCOL
INFUS: 'U  DAC 2, 4
           DELAY s(1/200)-4
           DAC 2, 0
           DELAY s(1/200)-1
           BEQ V1, 1, INFUS    ;V1 is manually updated via a button click in the toolbar
           HALT

ISOMED: 'I  DIGOUT [....ii..]
            HALT 


;DEFINITIONS FOR 15 SECOND USE OF SINGLE OR COMBINATION OF MEASUREMENT EUIPMENT
NONE: 'n HALT


ULTRA: 'u  MOVI V2, 1500 
ULTRAREP:  DAC 2, 4
           DELAY s(1/200)-4
           DAC 2, 0
           DELAY s(1/200)-1
           DBNZ V2, ULTRAREP
           HALT


ULTRAISO: 'm    MOVI V2, 399
ULTRAMOV:   DAC 2, 4
            DELAY s(1/200)-4
            DAC 2, 0
            DELAY s(1/200)-1
            DBNZ V2, ULTRAMOV

            DAC 2, 4
            DELAY s(1/200)-4
            DAC 2, 0
            DELAY s(1/200)-2
                
            DIGOUT [....ii..]
            
             MOVI V2, 1100
ULTRAMO2:  DAC 2, 4
             DELAY s(1/200)-4
             DAC 2, 0
             DELAY s(1/200)-1
             DBNZ V2, ULTRAMO2
             HALT