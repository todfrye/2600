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

P0Idx   DS 1
P0Vect  DS 2
P0Tmp
P0Line  DS 1

P0XPos  DS 6
P0YPos  DS 6


P1Idx   DS 1
P1Vect  DS 2
P1Tmp
P1Line  DS 1

P1XPos  DS 6
P1YPos  DS 6




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
   ; STA BKCLR

    LDA #(P01>>8)
    STA P0Vect+1
    
    LDA #(P11>>8)
    STA P1Vect+1


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

	INC 	FRAME


	LDA 	#$0
	STA 	P0GR
	LDA 	FRAME
	AND 	#127


	lda #100
	sta P0YPos
	lda #100
	sta P0YPos+1
	lda #100
	sta P0YPos+2
	lda #140
	sta P0YPos+3
	lda #160
	sta P0YPos+4
	lda #80
	sta P0YPos+5

	LDX 	#5
loop1
	txa
    lsr
    sec
    adc 	P0XPos,x
	cmp #120
	bcc	.okx   ;blt
	lda #0
.okx
	STA	P0XPos,x
    txa
    lsr
    clc
    sta P1Tmp
    lda P1XPos,x
    sbc P1Tmp
    bpl .oky
    lda #100
.oky
    sta P1XPos,x
    
	DEX
	BPL 	loop1
    

    lda #100
	sta P1YPos+5
    sta P1YPos+4
    sta P1YPos+3
    sta P1YPos+2
    sta P1YPos+1
    sta P1YPos

	LDA    	P0XPos+5
	STA	    P0Tmp
    LDA 	#(P04 & $ff)
	STA 	P0Vect
    
    LDA    	P1XPos+5
	STA	    P1Tmp
    LDA #(P14 & $ff)
    STA P1Vect
    
	LDX 	#5
	STX 	P0Idx
    STX 	P1Idx


WaitForVblankEnd
	LDA INTIM	
	BNE WaitForVblankEnd	
	LDY #96 	            ;count down lines
	STA WSYNC
	STA VBLANK
    STY BKCLR
	JMP (P0Vect)


clear
    LDA  #$24       ;set timer for overscan
	STA  TIM64T
	LDA  #$02       ;clear the screen and turn off the video
	STA  WSYNC
	STA  VBLANK
WaitForOscankEnd
	LDA INTIM	
	BNE     WaitForOscankEnd
	JMP     MainLoop
        

        
      ALIGN $100  
; waiting for ypos  
P01 SUBROUTINE bar

	STA     WSYNC       ;3 begin line 1
	STA     HMOVE
    STA P1GR
    TYA
	LDX	    P0Idx
	CMP 	P0YPos,x

	BCS 	.nochange
	LDA 	# P02 & $ff
	STA 	P0Vect
	LDA 	#7
	STA 	P0Line

.nochange
    LDA #0
    STA CLRHM
	JMP 	(P1Vect)
    
; showing p0 grafix 
P02  SUBROUTINE foo
    STA WSYNC       ;3 begin line 1
    STA HMOVE
    STA P1GR
    LDX P0Line
    LDA GFX0,x
    STA P0GR
    DEX
    LDA GFX0,x
    DEX
    STX P0Line
    STA CLRHM 

    BPL .nochange

	LDX P0Idx
	BEQ .last1
	DEX
	STX P0Idx
	LDA P0XPos,x
	STA P0Tmp
    LDA # P04 & $ff
    STA P0Vect

.last1
    LDA #0
.nochange
    JMP (P1Vect)
        
        
    .if 1
P04 SUBROUTINE
    STA WSYNC       ;3 begin line 1
    STA HMOVE
    STA P1GR
    CLC
    LDA P0Tmp
.DivideLoop
    SBC #15         ;2
    BCS .DivideLoop ;54 max
    sta  P0Tmp
    LDA # P05 & $ff
    STA P0Vect
    STA CLRHM
    sta RESP0
    lda #0
    JMP (P1Vect)
        
P05 SUBROUTINE
    STA WSYNC       ;3 begin line 1
    STA HMOVE
    STA P1GR
    lda P0Tmp
    EOR #7          ;2
    ASL             ;2
    ASL             ;2
    ASL             ;2
    ASL             ;2 -Shift left 4 places
    STA CLRHM
    sta HMP0        ;4     68
    lda #0
    STA P0Vect

    JMP (P1Vect)
    .endif
    ALIGN $100  

P10
    .if 0
        STA WSYNC       ;3 begin line 1
        STA HMOVE
        STA P0GR
        DEY		;decrement scanline counter
        BNE .gogo
        JMP clear
.gogo
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP 
        STA CLRHM
        JMP (P0Vect)
    .endif
    
    
P15 SUBROUTINE
    STA WSYNC       ;3 begin line 1
    STA HMOVE
    STA P0GR
    DEY		;decrement scanline counter
    BNE .gogo
    JMP clear
.gogo
    lda P1Tmp
    EOR #7          ;2
    ASL             ;2
    ASL             ;2
    ASL             ;2
    ASL             ;2 -Shift left 4 places
    STA CLRHM
    sta HMP1       ;4     68
    LDA # P11 & $ff
    STA P1Vect

    lda #0
    JMP (P0Vect)
        ; waiting for ypos  
P11 SUBROUTINE bar

	STA     WSYNC       ;3 begin line 1
	STA     HMOVE
    STA P0GR
    DEY		;decrement scanline counter
    BNE .gogo
    JMP clear
.gogo
    TYA
	LDX	    P1Idx
	CMP 	P1YPos,x

	BCS 	.nochange
	LDA 	# P12 & $ff
	STA 	P1Vect
	LDA 	#7
	STA 	P1Line

.nochange
    LDA #0
    STA CLRHM
	JMP 	(P0Vect)
    
; showing p0 grafix 
P12  SUBROUTINE foo
    STA WSYNC       ;3 begin line 1
    STA HMOVE
    STA P0GR
    LDX P1Line
    LDA GFX1,x
    STA P1GR
    DEY		;decrement scanline counter
    BNE .gogo
    JMP clear
.gogo
    DEX
    LDA GFX1,x
    DEX
    STX P1Line
    STA CLRHM 

    BPL .nochange

	LDX P1Idx
	BEQ .last1
	DEX
	STX P1Idx
	LDA P1XPos,x
	STA P1Tmp
    LDA # P14 & $ff
    STA P1Vect

.last1
    LDA #0
.nochange
    JMP (P0Vect)
        
        
    .if 1
P14 SUBROUTINE
    STA WSYNC       ;3 begin line 1
    STA HMOVE
    STA P0GR
    DEY		;decrement scanline counter
    BNE .gogo
    JMP clear
.gogo
    CLC
    LDA P1Tmp
.DivideLoop
    SBC #15         ;2
    BCS .DivideLoop ;54 max
    sta  P1Tmp
    LDA # 0
    STA P1Vect
    STA CLRHM
    sta RESP1
    JMP (P0Vect)
        




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
