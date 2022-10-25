SET    0.01, 1, 0    ; clock tick = 10 microseconds
VAR    V10; ;USTime ;set var for US onl

DAC    2, 0    ;ultrasound --> this is a TTL with duty cycle of 100Hz, var1
DAC    1, 0    ;IMUs/EMGs system --> this is a TTL, var2
DAC    3, 0    ;DAC 3 set to zero --> TTL for relay circuit, button switch <10us, var3
DIGOUT [....01..]    ;digital bits 2 and 3 control the isomed, initially one of them is set high to be able to simply invert them,
;!!!!! A WARNING should be send to the user before running the sequencer / the script that is calling it !!!!!
HALT

;MOVE ONLY ISOMED AFTER 4 seconds
OISOMED: 'i DELAY ms(4000)-1 ;move only Isomed after 4s
            DIGOUT [....ii..]
            HALT

;MOVE ISOMED
ISOMED: 'I  DIGOUT [....ii..] ;move Isomed            
            HALT

;DAC3   ON
RELAYON: 'Q  DAC 3, 5 ;Set DAC3 HIGH
             BEQ V7, 1, RELAYON
             HALT

;DAC3   OFF
RELAYOFF: 'W    DAC 3, 0 ;Set DAC3 LOW
                BEQ V7, 0, RELAYOFF
                HALT

;DEFINITIONS FOR TESTING PURPOSES APART FROM THE STUDY PROTOCOL
;INFINITE ULTRASOUND DUTYCYCLE
INFUS: 'U  DAC 2, 4 ;INFINITE US
           DELAY s(1/200)-4
           DAC 2, 0
           DELAY s(1/200)-1
           BEQ V1, 1, INFUS    ;V1 is manually updated via a button click in the toolbar
           HALT

;DEFINITIONS FOR 15 SECOND USE OF SINGLE OR COMBINATION OF MEASUREMENT EQUIPMENT

NONE: 'n HALT

;ONLY ULTRASOUND 15s
;ULTRA: 'u  MOVI V2, 1000 ;only TTL DAC2 with duty cycle 15s for ultrasound @ 100Hz
ULTRAREP: 'u  DAC 2, 4
           DELAY s(1/200)-4
           DAC 2, 0
           DELAY s(1/200)-1
           DBNZ V10, ULTRAREP ;get V10 from script
           HALT

;US (DAC2) DUTYCYCLE 100Hz, MYON (DAC1) TTL for 15s and RELEASE DAC3 @4s
USMYION: 'H DAC 1, 4  ; TTL from DAC1 and duty cycle @ 100Hz DAC2 for US
           MOVI V3, 399
USM:       DAC 2, 4
           DELAY s(1/200)-4
           DAC 2, 0
           DELAY s(1/200)-1
           DBNZ V3, USM

           DAC 2, 4
           DELAY s(1/200)-4
           DAC 2, 0
           DELAY s(1/200)-1
           DAC 3, 0   ; TTL DAC 3 goes LOW so trigger the box for the block

           MOVI V3, 1100
USMO2:   DAC 2, 4
            DELAY s(1/200)-4
            DAC 2, 0
            DELAY s(1/200)-1
            DBNZ V3, USMO2
            HALT

           DAC 1, 0 ; Turn DAC 1 LOW
           HALT

;US (DAC2) 100Hz FOR 15s AND MOVE ISOMED @sec 4
ULTRAISO: 'm    MOVI V2, 399 ;duty cycle for US (DAC2) @100Hz for 15s and trigger Isomed at 4s
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
ULTRAMO2:   DAC 2, 4
             DELAY s(1/200)-4
             DAC 2, 0
             DELAY s(1/200)-1
             DBNZ V2, ULTRAMO2
             HALT


;US (DAC2) 100Hz and TTL MYON (DAC1) FOR 15s AND MOVE ISOMED @sec 4
MYOUSIMO: 'J  DAC 1, 4  ;TTL from DAC1 and THEN duty cycle 100Hz DAC2 for US
            MOVI V2, 399
ULTRAMU:   DAC 2, 4
            DELAY s(1/200)-4
            DAC 2, 0
            DELAY s(1/200)-1
            DBNZ V2, ULTRAMU

            DAC 2, 4
            DELAY s(1/200)-4
            DAC 2, 0
            DELAY s(1/200)-1
            DIGOUT [....ii..]

            MOVI V2, 1100
ULTRAMU2:   DAC 2, 4
            DELAY s(1/200)-4
            DAC 2, 0
            DELAY s(1/200)-1
            DBNZ V2, ULTRAMU2
            DAC 1, 0    ;report dac 1 to zero
            HALT
