            SET    0.01,1,0        ;clock tick = 10 microseconds
            VAR    V10             ;;USTime ;set var for US only
            VAR    V11             ;;ISOMED 1
            VAR    V12             ;;ISOMED 2
;VAR    V13; ;DAC 3 (blocker)
            VAR    V14             ;;ISOMED 1 - XY
            VAR    V15             ;;ISOMED 2 - ISOMED 1
            VAR    V16             ;;ISOMED 2 - XY
;Stimulation vars
            VAR    V17             ;;Beginning stimulation (Delay)
            VAR    V18             ;;Delay loop
            VAR    V19             ;;Num of stimulation
            VAR    V20             ;;Delay to end of XY ramp from end of stimulation train
            VAR    V99
;I NEED ALL THEM BECAUSE I CAN'T DO CALCULATIONS IN THE LOOP AS WELL AS IT WILL TAKE TICKS!
            VAR    V13=1000;             ;;correct to ticks calculation

            DAC    0,0             ;Stimulation cable
            DAC    1,0             ;DAC1 TTL for triggering whatever
            DAC    2,0             ;ultrasound --      > this is a TTL with duty cycle of 100Hz, var1
            DAC    3,0             ;DAC 3 set to zero -- > TTL for relay circuit, button switch <10us, var3
            DIGOUT [....01..]      ;digital bits 2 and 3 control the isomed, initially one of them is set high to be able to simply invert them
;!!!!! A WARNING should be send to the user before running the sequencer / the script that is calling it !!!!!
HALT

;HALT ANY SNIPPET AND STOP ANY DAC/digout
STOPSNI: 'P DIGOUT [0000..00] ;everything zero except for the ISOMED
            DAC 0, 0
            DAC 1, 0
            DAC 2, 0
            DAC 3, 0
            HALT

;QUIT AND PUT ALL BITs BACK TO 0
QUIT:   'Q DIGOUT [00000000]
           DAC 0, 0
           DAC 1, 0
           DAC 2, 0
           DAC 3, 0
           HALT

;MOVE ISOMED
ISOMED: 'I  DIGOUT [....ii..]      ;move Isomed
            HALT


;DEFINITIONS FOR TESTING PURPOSES APART FROM THE STUDY PROTOCOL
;INFINITE ULTRASOUND DUTY CYCLE @ 100Hz

INFUS:  'U  DAC    2,4             ;INFINITE US
            DELAY  s(1/200)-4
            DAC    2,0
            DELAY  s(1/200)-1
            BEQ    V1,1,INFUS      ;V1 is manually updated via a button click in the toolbar
            HALT


;DEFINITIONS FOR n SECOND USE OF SINGLE OR COMBINATION OF MEASUREMENT EQUIPMENT

;MOVE ISOMED TWICE FOR FAST Stretch-shortening/ Shortening Stretch cycle.
OISOMED: 'S DAC    1,3             ;TTL from DAC1
            MOV    V1,V11       ; -2 because of this and the upcoming instruction till delay are 4 ticks
            MUL    V1,V13,-3         ;1000 because I am passing the values for the other cycles multiplied by 100. need to remove 3 ticks
            DELAY  V1             ;move only Isomed after time defined in the script
            DIGOUT [....ii..]      ;First rotation
            MOV    V1,V15       ;-3 because of current instruction + the next ones is 3 ticks
            MUL    V1,V13,-3
            DELAY  V1
            DIGOUT [....ii..]      ;Second rotation
            MOV    V1,V16       ;-3 because of current instruction + the next ones is 3 ticks
            MUL    V1,V13,-3
            DELAY  V1             ;3 steps caluclation of the ticks operations
            DAC    1,0
            HALT


;ONLY ULTRASOUND AS XY WIDTH
;only TTL DAC2 WITH DUTY CYCLE @ 100Hz FOR THE US
ULTRAREP: 'u DAC   1,3
            MOV    V1,V10          ;copy the variable V10 in V1, so I do not need to pass everytime in the Idle
USONLY:     DAC    2,4
            DELAY  s(1/200)-4
            DAC    2,0
            DELAY  s(1/200)-1
            DBNZ   V1,USONLY       ;V10 IS DEFINED IN THE SCRIPT
            DAC    1,0
            HALT

;US (DAC2) 100Hz and TTL MYON (DAC1) FOR XY WIDTH AND MOVE ISOMED @sec V11
MYOUSIMO: 'J DAC   1,3             ;TTL from DAC1 and THEN duty cycle 100Hz DAC2 for US
            MOV    V1,V11          ;copy the variable V11 in V1, so I do not need to pass everytime in the Idle
            MOV    V2,V14          ;copy the variable V14 in V2, so I do not need to pass everytime in the Idle
ULTRAMU:    DAC    2,4
            DELAY  s(1/200)-4
            DAC    2,0
            DELAY  s(1/200)-1
            DBNZ   V1,ULTRAMU      ;REP CYCLE TILL FIRST TRIGGER OF ISOMED

;            DAC    2,4
;            DELAY  s(1/200)-4
;            DAC    2,0
;            DELAY  s(1/200)-2
            DIGOUT [....ii..]

ULTRAMU2:   DAC    2,4
            DELAY  s(1/200)-4
            DAC    2,0
            DELAY  s(1/200)-1
            DBNZ   V2,ULTRAMU2     ;Loop till end of XY width'
            DAC    1,0             ;report DAC 1 to zero
            HALT


;US (DAC2) 100Hz and TTL (DAC1) FOR XY WIDTH AND MOVE ISOMED TWICE
MYUSISOS: 'k DAC   1,3             ;TTL from DAC1 and THEN duty cycle 100Hz DAC2 for US
            MOV    V1,V11          ;copy the variable V11 in V1, so I do not need to pass everytime in the Idle
            MOV    V2,V15          ;copy the variable V15 in V2, so I do not need to pass everytime in the Idle
            MOV    V3,V16          ;copy the variable V16 in V3, so I do not need to pass everytime in the Idle
ULTRAMUS:   DAC    2,4
            DELAY  s(1/200)-4
            DAC    2,0
            DELAY  s(1/200)-1
            DBNZ   V1,ULTRAMUS     ;REP CYCLE TILL FIRST TRIGGER OF ISOMED

;            DAC    2,4
;            DELAY  s(1/200)-4
;            DAC    2,0
;            DELAY  s(1/200)-2
            DIGOUT [....ii..]

ULTRAMD:    DAC    2,4
            DELAY  s(1/200)-4
            DAC    2,0
            DELAY  s(1/200)-1
            DBNZ   V2,ULTRAMD      ;Repeat till V12 second time trigger ISOMED

;            DAC    2,4
;            DELAY  s(1/200)-4
;            DAC    2,0
;            DELAY  s(1/200)-2
            DIGOUT [....ii..]

ULTRAMH:    DAC    2,4
            DELAY  s(1/200)-4
            DAC    2,0
            DELAY  s(1/200)-1
            DBNZ   V3,ULTRAMH      ;Repeat till end of XY width
            DELAY  3 ;3tick because of previous instructs
            DAC    1,0             ;report dac 1 to zero
            HALT

;;;;;;;;;TAP DAC for LONG recording SYNC (e.g., HDEMG)
;1ms square wave pulse for syncing devices in long recording
;it is useful for fatiguing contraction where we export the spike file afterwards
;as we do not know for how long a contraction can protract
TAPT: 'T  DAC 1,3
          DELAY ms(1)-1
          DAC 1,0
          HALT

;STIMULATION PART: WE USE THE DIGITAL BIT 0(ZERO) IN THE FRONT PANEL OF THE 1401

;STIM AND NO rotation
STIMFIX: 'M DAC    1,3             ;TTL from DAC1 and then stimulation train
            MOV    V1,V20          ;Rep Stimlation
            MOV    V2,V99,-1
            SUB    V2,V18,-1       ;delay till end XY

            DELAY  V17             ;wait till the beginning of stim
FIRSTTR:    DIGOUT [0000..01]      ;send signal to front panel digital output 0
            DIGOUT [0000..00]
            DELAY  V19             ;delay based on delta t of the frequency
            DBNZ   V1,FIRSTTR      ;REP STIMULATIONS according to n stimulation

            DELAY  V2              ;delay to keep DAC1 up till end of XY view
            DAC    1,0
            HALT

;For the other condition, it would be good to decrease the variable of n stiumlation
;in every cycle, so I do not need to pass tons of variables

;STIM and ONE ROTATION
STIMONER: 'N DAC   1,3
             ;MOV V1,V11 ;copy V11 into 1
             ;BGE V1, V17 ;if Isomed rotation starts the same or after stimulation begin
             ;SUB V1,V17 ;potentially add a tick to V1 and fuck off
            BGE    V11,V18,PRE     ;stimulation pre rotation
            BGE    V17,V11,AFTER   ;stimulation after rotation
            JUMP   MID             ;nor one neither the other

;;;;;;;;;    Stimulation pre rotation
PRE:        MOV    V1,V20
            MOV    V2,V11,-1
            SUB    V2,V18          ;delta time between end of stimulation and start of rotation
            DELAY  V17             ;5+1 instructions before

LOOPre:     DIGOUT [0000..01]      ;send signal to front panel digital output
            ;DELAY ms(1) ;according to the manufacture 1ms is needed for stimulating
            DIGOUT [0000..00]
            DELAY  V19             ;just add 1ms -1 tick; delay based on delta t of the frequency
            DBNZ   V1,LOOPre

            DELAY  V2
            DIGOUT [....ii..]
            MOV    V1,V99,-1       ;V99 XY width
            SUB    V1,V11,-1       ;-1 tick DELAY to end of the XY
            JUMP   END

;;;;;;;;; Stimulation after rotation
AFTER:      DELAY  V11
            DIGOUT [....ii..]

            MOV    V1,V17
            MOV    V2,V20
            SUB    V1,V11       ;-3 because of previous operations
            DELAY  V1

LOOPost:    DIGOUT [0000..01]      ;send signal
            DIGOUT [0000..00]
            DELAY  V19             ;delay based on delta t of the frequency
            DBNZ   V20,LOOPost     ;REP STIMULATIONS according to n stimulation

            MOV    V1,V99,-1
            SUB    V1,V18,-1
            JUMP   END


;;;;;;;;;;; Rotation in the middle

MID:        MOV    V2,V11,-1
            SUB    V2,V17       ;delta time between beginning of stimulation and start of rotation
            DIV    V2,V19          ;calculate n stimulation to send

            MOV    V3,V18
            SUB    V3,V11              ;delta time between rotation to end of stimulation
            DIV    V3,V19          ;n stim to end, +1 because one instruction is lost due to digout

            DELAY  V17             ;5+1 instructions before

LOOPreR:    DIGOUT [0000..01]      ;send signal
            DIGOUT [0000..00]
            DELAY  V19             ;delay based on delta t of the frequency
            DBNZ   V2,LOOPreR      ;REP STIMULATIONS according to n stimulation

            DIGOUT [....ii..]

LOOPosR:    DIGOUT [0000..01]      ;send signal
            DIGOUT [0000..00]
            DELAY  V19             ;delay based on delta t of the frequency
            DBNZ   V3,LOOPosR      ;REP STIMULATIONS according to n stimulation

            ;DIGOUT [0000..01]      ;send last stim signal
            ;DIGOUT [0000..00]

            MOV    V1,V99,-1
            SUB    V1,V18,-1       ;delay till end XY
            JUMP   END
;;;;END;;;;

END:        DELAY  V1              ;-3 because of MOV,MULI,JUMP
            DAC    1,0
            HALT


;;;;;;;;;;;;;;;;;;;
;STIM and a random rotation for checking Stim at a specific value pt
;Keep it in mind that CHAN treats data as 16bits, 1  ;Read data of Torque
;however you CANNOT use VDAC16 with a variable, that's why I convert that in the script first
TESTPT: 'A DAC   1,3
         ;DIGOUT [....ii..] ;trigger rot
         VAR     V1,level         ;level to cross
         VAR     V2,data          ;to hold the last data
         VAR     V3,low           ;some sort of hysteresis level
         MOV     level, V22
         MOV     low, V23         ;copy converted voltage values because I can't use VDAC16 with a variable
         MOV     V4,V10,-6        ;copy X range var -6 ticks
;         MOV     V5,V11,-7           ;Copy Time to triggering rotation
;         MOV     V6,V14,-8        ;copy Time after rotation trigger to X range var -7 ticks
         VAR     V99=4            ;empty var necessary for using SUB


MATCH:   BLT    V4,4,XEND
         SUB    V4,V99       ;'remove at each ticks
         CHAN   data, 1  ;Read data of Torque
         BGT    data,low,MATCH   ;
         BLT    data,level,MATCH  ;

         ;DIGOUT [....ii..] ;trigger rot
         ;Make a loop here based on the xywidth variable
;BELOW:   CHAN    data, 1  ;Read data of Torque
;         BGT     data,low,below   ;wait for below     >wait below
;ABOVE:   CHAN    data, 1  ;Read data of Torque
;         BLE     data,level,above ;wait for above     >wait above
         ;send the pulse of 1ms
         DIGOUT  [.......1]       ;pulse output for 1ms
         DELAY ms(1)-1
         DIGOUT  [.......0]
         SUB V4,V99,-100 ;100 = 1ms
         DELAY V4       ;wait till the end of the XY ramp

XEND:    DAC 1,0
