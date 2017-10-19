;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;

;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;

;

	processor	6502
    	include vcs.h



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; STELLA EQUATES
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


VSYNC	EQU		$00			; VERT SYNC
VBLNK	EQU		$01			;
HSYNC	EQU		$02			; STROBE
MCRES	EQU		$03			; MASTER COUNTER RESET
P0SIZE	EQU		$04			; SIZE, NUMBER OF COPIES
P1SIZE	EQU		$05			;
P0CLR	EQU		$06			; COLOR
P1CLR	EQU		$07			;
PFCLR	EQU		$08			;
BKCLR	EQU		$09
PFCTRL	EQU		$0A			; PLAYFIELD CONTROL

P0REF	EQU		$0B			; REFLECT
P1REF	EQU		$0C			;

PF0		EQU		$0D			; PLAYFIELD REGISTERS-rw-rw-r-- 1 tod tod    785 Sep 20 13:07 trf2.bin

PF1		EQU		$0E			;
PF2		EQU		$0F			;

P0RES	EQU		$10			; RESETS
P1RES	EQU		$11			;
M0RES	EQU		$12			;
M1RES	EQU		$13			;
BRES	EQU		$14			;

SNDC0	EQU		$15			; SOUND CONTROL
SNDC1	EQU		$16			;
SNDF0	EQU		$17			; FREQUENCY
SNDF1	EQU		$18			;
SNDV0	EQU		$19			; VOLUME
SNDV1	EQU		$1A			;

P0GR	EQU		$1B			; GRAPHICS REGISTERS
P1GR	EQU		$1C			;
M0GR	EQU		$1D			;
M1GR	EQU		$1E			;
BGR		EQU		$1F			;

P0HM	EQU		$20			; HMOVES
P1HM	EQU		$21
M0HM	EQU		$22
M1HM	EQU		$23
BHM		EQU		$24			;

P0VDEL	EQU		$25			; VERTICAL DELAYS
P1VDEL	EQU		$26			;
BVDEL	EQU		$27			;

MP0RES	EQU		$28			; MISSILE TRACKING
MP1RES	EQU		$29			;
HMOVE	EQU		$2A			; HORIZ MOVEMENT STROBE
CLRHM	EQU		$2B			; CLEAR HMOVE STROBE
CCLR	EQU		$2C			; CX REGISTER RESET STROBE

;READ ADDRESSES

M0PPCX	EQU		$00			; M0 PLAYER CX
M1PPCX	EQU		$01			; M1 PLAYER
P0BPCX	EQU		$02			; P0 BALL/PLAYFIELD CX
P1BPCX	EQU		$03			;
M0BPCX	EQU		$04			; M0 BALL/PLAYFIELD CX
M1BPCX	EQU		$05			;
BPCX	EQU		$06			; BALL PLAYFIELD CX
PPMMCX	EQU		$07			; P0/P1 MISSILE CX
POT0A	EQU		$08			; POT IN, LEFT
POT0B	EQU		$09			; POT IN, LEFT
POT1A	EQU		$0A			; POT IN, RIGHT
POT1B	EQU		$0B			; POT IN, RIGHT
TRIG0	EQU		$0C			; SCHMIDT TRIGGER LEFT
TRIG1	EQU		$0D			; RIGHT

; PIA ADDRESSES

PLRCTL	EQU		$280			; PORT A (CONTROLLERS)
DDRA	EQU		$281			; DATA DIRECTION A
FPCTL	EQU		$282			; FRONT PANEL SWITCHES
DDRB	EQU		$283			; DATA DRIECTION B
TIMER	EQU		$284			; PIA TIMER
TIMOUT	EQU		$285			; PIA TIMER FLAG
TIMD1	EQU		$294			; CLOCK / 1
TIMD8	EQU		$295			; CLOCK / 8
TIMD64	EQU		$296			; CLOCK / 64
TIMD1K	EQU		$297			; CLOCK / 1024

;If the Z flag is 0, then A <> NUM and BNE will branch
;If the Z flag is 1, then A = NUM and BEQ will branch
;If the C flag is 0, then A (unsigned) < NUM (unsigned) and BCC will branch
;If the C flag is 1, then A (unsigned) >= NUM (unsigned) and BCS will branch

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; RAM ALOCATION
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;		CODE
		SEG.U	RAM
		ORG	$80

RAND		DS	1		
RANDH		DS	1
FRAME       DS  1


P0XPos  DS 5





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; MAIN PROGRAM
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	SEG	CODE
	ORG	$1000,0

START	SEI
		CLD			; NO DECIMAL
		LDX	#$00
		TXA
CLP		STA	$0,X	; CLEAR STELLA & RAM
		TXS
		INX
		BNE	CLP

		LDA	#150
		STA	RAND

        LDA #$36
        STA COLUP0

        LDA #$56
        STA COLUP1


        LDA #$ff
        STA P0GR
        STA P1GR




;VSYNC time
MainLoop
    LDA  #2
    STA  VSYNC
    STA  WSYNC
    STA  WSYNC
    STA  WSYNC
    LDA  #43
    STA  TIM64T
    LDA #0
    STA  VSYNC




; RANDOM NUMBER GENERATOR
RANDOM
    LDA	RAND
    ROR
    ROR
    ROR
    EOR	RANDH
    ASL
    ASL
    ROL	RAND
    ROL	RANDH


    INC FRAME
    LDA FRAME
    CMP #150
    BNE .foo
    LDA #0
.foo
    STA FRAME



    STA CLRHM
    LDA     FRAME
    ;AND     #$07f
    LDX #0
    JSR HPOS

    CLC
    LDA #150
    SBC FRAME

    INX
    JSR HPOS
    STA WSYNC
    STA HMOVE




WaitForVblankEnd
	LDA INTIM	
	BNE WaitForVblankEnd
	LDY #96 	            ;count down lines
	STA WSYNC
	STA VBLANK

SupidFakeKernel
	STA WSYNC
	STA WSYNC
	DEY
	BNE SupidFakeKernel

	LDA  #$02       ;clear the screen and turn off the video
	STA  VBLANK

    LDA  #$24       ;set timer for overscan
	STA  TIM64T
WaitForOscankEnd
	LDA     INTIM
	BNE     WaitForOscankEnd
	JMP     MainLoop
        



    ALIGN $100
HPOS SUBROUTINE
    STA WSYNC       ;3 begin line 1
    CLC
.DivideLoop
    SBC #15         ;2
    BCS .DivideLoop ;54 max
    EOR #7          ;2
    ASL             ;2
    ASL             ;2
    ASL             ;2
    ASL             ;2 -Shift left 4 places

    sta HMP0,x       ;4     68
    sta RESP0,x
    RTS



    ALIGN $100
GFX0
	dc.b $ff
    
    dc.b    $18
    dc.b    $24
    dc.b    $42
    dc.b    $81
    dc.b    $42
    dc.b    $24
    dc.b    $18

GFX1
    dc.b    $81
    dc.b    $42
    dc.b    $24
    dc.b    $18
    dc.b    $24
    dc.b    $42
    dc.b    $81

    

    ORG $1FFC            ; Cart config (so 6502 can start it up)
VECTORS
	DC.W	START
	DC.W	START

END
