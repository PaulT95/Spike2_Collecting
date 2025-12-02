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

            DAC    0,5             ;5V output for potentiometer (Aka goniometer)
            DAC    1,0             ;DAC1 TTL for triggering whatever
            DAC    2,0             ;ultrasound --      > this is a TTL with duty cycle of 100Hz, var1
            DAC    3,0             ;DAC 3 set to zero -- > TTL for relay circuit, button switch <10us, var3
            DIGOUT [....01..]      ;digital bits 2 and 3 control the isomed, initially one of them is set high to be able to simply invert them
;!!!!! A WARNING should be send to the user before running the sequencer / the script that is calling it !!!!!
HALT

;YOU CANNOT DO DELAY Vn -3, so a var -3 ticks. We have 10us  per tick, so for our purpose, we won't notice any issue.
;Otherwise you need MOV varx,vary,-4 so the ticks plus the one of each mov
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

;For the other conditions, it would be good to decrease the variable of n stimulation
;in every cycle, so I do not need to pass tons of variables

;YOU CANNOT DO DELAY Vn -3, so a var -3 ticks. We have 10us ticks, so for our purpose, we won't notice any issue.
;Otherwise you need MOV varx,vary,-4 so the ticks plus the one of each mov
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
            SUB    V2,V18,-3       ;delta time between end of stimulation and start of rotation
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

            MOV    V1,V17    ;copy time point (begin stim)
            MOV    V2,V20
            SUB    V1,V11,-3   ;delta t from rot time point to begin stim    ;-3 because of previous operations
            DELAY  V1

LOOPost:    DIGOUT [0000..01]      ;send signal
            DIGOUT [0000..00]
            DELAY  V19             ;delay based on delta t of the frequency
            DBNZ   V20,LOOPost     ;REP STIMULATIONS according to n stimulation

            MOV    V1,V99,-1
            SUB    V1,V18,-1
            JUMP   END

;;;;;;;;;;; Rotation in the middle of stimulation train

MID:        MOV    V2,V11
            SUB    V2,V17       ;delta time between beginning of stimulation and start of rotation
            DIV    V2,V19          ;calculate n stimulation to send

                    ;otherwise they are menat to finish before the second rot
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


;;;;;;;;;;;;;;;;;;STIM and TWO ROTATIONS
STIM2R: 'L DAC   1,3
             ;MOV V1,V11 ;copy V11 into 1
             ;BGE V1, V17 ;if Isomed rotation starts the same or after stimulation begin
             ;SUB V1,V17 ;potentially add a tick to V1 and fuck off
            BGE    V11,V18,PRER2     ;stimulation pre rotations so rot isomed 1 starts after the end of stim train
            BGE    V17,V12,AFTERr2 ;stimulations starts AFTER BOTH rots
            BGE    V17,V11,AFTERr1 ;stimulations starts after r1 with 2 cases: finishes before rot 2 or after
            JUMP   HARDCOD          ;"default" stimulations starts before rot 1 with 2cases: finishes before rot 1 or after
;;;;;;;;; Stimulations before BOTH rotations
PRER2:      MOV    V1,V20           ;copy n stimulation into V1 otherwise dbnz decrease V1 to 0
            MOV    V2,V11,-1
            SUB    V2,V18,-3       ;delta time between end of stimulation and start of first rotation
            DELAY  V17             ;5+1 instructions before

LOOPRo:     DIGOUT [0000..01]      ;send signal to front panel digital output
            ;DELAY ms(1) ;according to the manufacture 1ms is needed for stimulating
            DIGOUT [0000..00]
            DELAY  V19             ;just add 1ms -1 tick; delay based on delta t of the frequency
            DBNZ   V1,LOOPRo

            DELAY  V2
            DIGOUT [....ii..] ;1st rot
            MOV    V2, V12
            SUB    V2, V11,-3     ;delta time between two rots
            DELAY  V2
            DIGOUT [....ii..]  ;2nd rot

            MOV    V1,V99,-3       ;V99 XY width
            SUB    V1,V12,-1       ;-1 tick DELAY to end of the XY
            JUMP   ENDR2


;;;;;;;Stim train AFTER both rotations
AFTERr2:     DELAY V11 ;wait before trigger Isomed rot 1
             DIGOUT [....ii..]

             MOV V1, V12        ;copy time point rot 2
             SUB V1, V11,-3      ;delta time rot 2-1
             DELAY V1
             DIGOUT [....ii..]  ;2nd rot

             MOV V2, V17        ;copy time point start stim
             MOV V3, V20         ;now copy n stimulations into V3, otherwise DBNZ decrese it until 0 so for multi snippet adios
             SUB V2, V12,-4      ;delta time between triger rot 2 and start stim
             DELAY V2

LOOpPR:      DIGOUT [0000..01]      ;send signal
             DIGOUT [0000..00]
             DELAY  V19             ;delay based on delta t of the frequency
             DBNZ   V3,LOOpPR      ;REP STIMULATIONS according to n stimulation

             MOV    V1,V99,-3
             SUB    V1,V18,-1       ;delay till end XY
             JUMP   ENDR2

;;;;;;;;;;; Stimulations AFTER rot 1 with check whether ends before OR after Rot 2

AFTERr1:    DELAY V11 ;wait before trigger ISomed rot 1
            DIGOUT [....ii..]

            MOV V1,V17
            SUB V1,V11,-3 ;calculate delta time between triger rot 1 and stimulation start, so delay
            DELAY V1

            MOV V2,V20 ;in case of simple case V3 is already done
            BLE V18,V12,SIMPLE ;check whether the stimulations end before rotation 2
            ;JUMP LOBEFR2 ;if rotation is in the middle of the entire loop train
;in case stimulations are before and after rotation 2
LOBEFR2:    MOV V2,V12  ;now check delta time between beginning of stim and triger rotation
            SUB V2,V17,-3 ;calculate times of loop before trigger with rotation 2
            DIV V2,V19          ;calculate n stimulation to send until rotation 2 occur
            MOV V3,V20  ;copy total nstimulations to send
            SUB V3,V2   ;stimulation left AFTER the rotation 2 (so total numb of stim - the one before rotation)

LOOPRe2:    DIGOUT [0000..01]      ;send signal
            DIGOUT [0000..00]
            DELAY  V19             ;delay based on delta t of the frequency
            DBNZ   V2,LOOPRe2      ;REP STIMULATIONS according to n stimulation

            DIGOUT [....ii..]   ;rotate 2nd time isomed
            ;continue the stim train
LOOPo2:     DIGOUT [0000..01]      ;send signal
            DIGOUT [0000..00]
            DELAY  V19             ;delay based on delta t of the frequency
            DBNZ   V3,LOOPo2      ;REP STIMULATIONS according to n stimulation

            MOV    V1,V99,-1
            SUB    V1,V18,-3       ;delay till end XY
            JUMP   ENDR2
;;; In case entire stimulation train finished before rotation two
SIMPLE:      DIGOUT [0000..01]      ;send signal
             DIGOUT [0000..00]
             DELAY  V19             ;delay based on delta t of the frequency
             DBNZ   V2,SIMPLE      ;REP STIMULATIONS according to n stimulation

             MOV V3, V12
             SUB V3, V18,-4 ;get delta time between end of stimulation and rot 2
             DELAY V3
             DIGOUT [....ii..] ;sec rotation isomed

             MOV V1, V99,-1
             SUB V1, V12,-3 ;delay till end of XY
             JUMP ENDR2

;;;;;;;;;;; Stimulations BEFORE rot 1 with check whether ends before OR after Rot 2

HARDCOD:   DELAY V17   ;wait unil begin of stim

           MOV V1,V11
           SUB V1,V17,-5 ;get delta time between first rotation and begin stimulation
           DIV V1,V19   ;calculate n stimulation to sedn until rot 1+
           MOV V2,V20 ;get number of stim to send in total
           SUB V2,V1 ;in case stim finishes BEFORE rot 2, easy, just difference total - counts before first rot
;;FIRST train of stims until first rotation
HARD1:     DIGOUT [0000..01]      ;send signal
           DIGOUT [0000..00]
           DELAY  V19             ;delay based on delta t of the frequency
           DBNZ   V1,HARD1      ;REP STIMULATIONS according to n stimulation

           DIGOUT [....ii..] ;first rotation
           BGE V18,V12,HARD3 ;check whether stimulations train finishes AFTER the rot 2
;;IN case stim finishes BEFORE rot 2, just do the rest of the amount of stim and calculate delays
HARD2:     DIGOUT [0000..01]      ;send signal
           DIGOUT [0000..00]
           DELAY  V19             ;delay based on delta t of the frequency
           DBNZ   V2,HARD2      ;REP STIMULATIONS according to n stimulation - the previous block before rot 1

           MOV V3, V12
           SUB V3, V18,-4 ;Get delay between end of stimulations and rotation 2
           DELAY V3
           DIGOUT [....ii..] ;second rotation

           MOV    V1,V99,-3
           SUB    V1,V12,-1       ;delay till end XY
           JUMP   ENDR2
;;IN case stim go BEYOND rotation 2, then we have to calculate a shit amount of stuff:)
HARD3:     MOV V2, V12 ;overwrite V2 because the block must be smaller than total - first block, there are 3 blocks when I have 2 rotations
           SUB V2, V11,-3 ;get delta time between two rots
           DIV V2, V19 ;calculation n stims  for this block in between rotations

HARDL1:    DIGOUT [0000..01]      ;send signal
           DIGOUT [0000..00]
           DELAY  V19             ;delay based on delta t of the frequency
           DBNZ   V2,HARDL1      ;REP STIMULATIONS according to n stimulation - the previous block before rot 1

           DIGOUT [....ii..] ;second rotation

           MOV V3, V18
           SUB V3, V12,-3 ;get delta time between rotation 2 and end of train stim
           DIV V3, V19

HARDL2:    DIGOUT [0000..01]      ;send signal
           DIGOUT [0000..00]
           DELAY  V19             ;delay based on delta t of the frequency
           DBNZ   V3,HARDL2      ;REP STIMULATIONS according to n stimulation - the previous block before rot 1

           MOV    V1,V99,-3
           SUB    V1,V18,-1       ;delay till end XY
           JUMP   ENDR2
;;;;END;;;;
ENDR2:      DELAY  V1              ;use always V1 at the end of each part as trick to have END label consistent among conditions
            DAC    1,0
            HALT

;;;;;;;;;;;;;;;;;;;
;STIM and a random rotation for checking Stim @ SPECIFIC VALUEpt
;Keep it in mind that CHAN treats data as 16bits, 1  ;Read data of Torque
;however you CANNOT use VDAC16 with a variable, that's why I convert that in the script first
TESTPT: 'A DAC   1,3
        ;DIGOUT [....ii..] ;trigger rot
        VAR     V5=4            ;empty var necessary for using SUB in a loop properly
        VAR     V1,level         ;level to cross
        VAR     V2,data          ;to hold the last data
        VAR     V3,low           ;some sort of hysteresis level
        MOV     level, V22
        MOV     low, V23         ;copy converted voltage values because I can't use VDAC16 with a variable
        MOV     V4,V10,-6        ;copy XY range var -6 ticks because of previous commands, however adjust later on

        MATCH:   BLE    V4,4,XEND   ;if the amount of time the XY view (so snippet time) <= 4 ticks, jump to the end because ramp finished
                 SUB    V4,V5       ;Remove at each loop the amount ticks needed for the loop although
                 CHAN   data, 1  ;Read data of Torque
                 BGT    data,low,MATCH   ;keep checking whether data is within such "hysterisys"
                 BLT    data,level,MATCH ;keep checking, if I get here I actually NEED to remove an additional tick right?

      ;DIGOUT [....ii..] ;trigger rot randomly for checking. Code implementation necessary
      ;Make a loop here based on the xywidth variable
      ;BELOW:   CHAN    data, 1  ;Read data of Torque
      ;         BGT     data,low,below   ;wait for below     >wait below
      ;ABOVE:   CHAN    data, 1  ;Read data of Torque
      ;         BLE     data,level,above ;wait for above     >wait above

      ;send the pulse of 1ms as soon as both conditions are NOT satisfied (i.e., value within the histerisys)
      DIGOUT  [.......1]       ;pulse output for 1ms
      DELAY ms(1)-1
      DIGOUT  [.......0]
      SUB V4,V5,-100 ;100 = 1ms, so remove the previous stimulation time, however it may result in negative results, will this result in infinite loop?
      DELAY V4       ;wait till the end of the XY ramp

      XEND:    DAC 1,0
