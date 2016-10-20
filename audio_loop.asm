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
TIMD1K	EQU		$297			; CLOCK / 1024 dc.b  16    ; 0



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; RAM ALOCATION
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;		CODE
		SEG.U	RAM
		ORG	$80

audio_count ds 2
audio_step  ds 2
frame   ds 1





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

        LDA #$36		
        STA COLUP0
        STA BKCLR
        
        lda #0
        sta SNDC0

    lda #0
    sta audio_step
    lda #4
    sta audio_step+1

;VSYNC time
MainLoop
        sta WSYNC
        ldx         audio_count+1
        lda SineWave,x
        sta SNDV0
        clc
        lda audio_count
        adc audio_step 
        sta audio_count
        lda audio_count+1
        adc audio_step+1
        sta audio_count+1
        

        sta WSYNC
        ldx frame 
        inx
        stx frame
        nop
        nop
        nop
        nop
        nop
        

        jmp MainLoop
        

    
    
    
        ALIGN $100
SineWave
  dc.b  8    ; 0
 dc.b  8    ; 1
 dc.b  8    ; 2
 dc.b  8    ; 3
 dc.b  8    ; 4
 dc.b  8    ; 5
 dc.b  9    ; 6
 dc.b  9    ; 7
 dc.b  9    ; 8
 dc.b  9    ; 9
 dc.b  9    ; 10
 dc.b  10    ; 11
 dc.b  10    ; 12
 dc.b  10    ; 13
 dc.b  10    ; 14
 dc.b  10    ; 15
 dc.b  11    ; 16
 dc.b  11    ; 17
 dc.b  11    ; 18
 dc.b  11    ; 19
 dc.b  11    ; 20
 dc.b  11    ; 21
 dc.b  12    ; 22
 dc.b  12    ; 23
 dc.b  12    ; 24
 dc.b  12    ; 25
 dc.b  12    ; 26
 dc.b  12    ; 27
 dc.b  13    ; 28
 dc.b  13    ; 29
 dc.b  13    ; 30
 dc.b  13    ; 31
 dc.b  13    ; 32
 dc.b  13    ; 33
 dc.b  13    ; 34
 dc.b  14    ; 35
 dc.b  14    ; 36
 dc.b  14    ; 37
 dc.b  14    ; 38
 dc.b  14    ; 39
 dc.b  14    ; 40
 dc.b  14    ; 41
 dc.b  14    ; 42
 dc.b  14    ; 43
 dc.b  15    ; 44
 dc.b  15    ; 45
 dc.b  15    ; 46
 dc.b  15    ; 47
 dc.b  15    ; 48
 dc.b  15    ; 49
 dc.b  15    ; 50
 dc.b  15    ; 51
 dc.b  15    ; 52
 dc.b  15    ; 53
 dc.b  15    ; 54
 dc.b  15    ; 55
 dc.b  15    ; 56
 dc.b  15    ; 57
 dc.b  15    ; 58
 dc.b  15    ; 59
 dc.b  15    ; 60
 dc.b  15    ; 61
 dc.b  15    ; 62
 dc.b  15    ; 63
 dc.b  15    ; 64
 dc.b  15    ; 65
 dc.b  15    ; 66
 dc.b  15    ; 67
 dc.b  15    ; 68
 dc.b  15    ; 69
 dc.b  15    ; 70
 dc.b  15    ; 71
 dc.b  15    ; 72
 dc.b  15    ; 73
 dc.b  15    ; 74
 dc.b  15    ; 75
 dc.b  15    ; 76
 dc.b  15    ; 77
 dc.b  15    ; 78
 dc.b  15    ; 79
 dc.b  15    ; 80
 dc.b  15    ; 81
 dc.b  15    ; 82
 dc.b  15    ; 83
 dc.b  15    ; 84
 dc.b  14    ; 85
 dc.b  14    ; 86
 dc.b  14    ; 87
 dc.b  14    ; 88
 dc.b  14    ; 89
 dc.b  14    ; 90
 dc.b  14    ; 91
 dc.b  14    ; 92
 dc.b  14    ; 93
 dc.b  13    ; 94
 dc.b  13    ; 95
 dc.b  13    ; 96
 dc.b  13    ; 97
 dc.b  13    ; 98
 dc.b  13    ; 99
 dc.b  13    ; 100
 dc.b  12    ; 101
 dc.b  12    ; 102
 dc.b  12    ; 103
 dc.b  12    ; 104
 dc.b  12    ; 105
 dc.b  12    ; 106
 dc.b  11    ; 107
 dc.b  11    ; 108
 dc.b  11    ; 109
 dc.b  11    ; 110
 dc.b  11    ; 111
 dc.b  11    ; 112
 dc.b  10    ; 113
 dc.b  10    ; 114
 dc.b  10    ; 115
 dc.b  10    ; 116
 dc.b  10    ; 117
 dc.b  9    ; 118
 dc.b  9    ; 119
 dc.b  9    ; 120
 dc.b  9    ; 121
 dc.b  9    ; 122
 dc.b  8    ; 123
 dc.b  8    ; 124
 dc.b  8    ; 125
 dc.b  8    ; 126
 dc.b  8    ; 127
 dc.b  8    ; 128
 dc.b  8    ; 129
 dc.b  8    ; 130
 dc.b  8    ; 131
 dc.b  8    ; 132
 dc.b  8    ; 133
 dc.b  7    ; 134
 dc.b  7    ; 135
 dc.b  7    ; 136
 dc.b  7    ; 137
 dc.b  7    ; 138
 dc.b  6    ; 139
 dc.b  6    ; 140
 dc.b  6    ; 141
 dc.b  6    ; 142
 dc.b  6    ; 143
 dc.b  5    ; 144
 dc.b  5    ; 145
 dc.b  5    ; 146
 dc.b  5    ; 147
 dc.b  5    ; 148
 dc.b  5    ; 149
 dc.b  4    ; 150
 dc.b  4    ; 151
 dc.b  4    ; 152
 dc.b  4    ; 153
 dc.b  4    ; 154
 dc.b  4    ; 155
 dc.b  3    ; 156
 dc.b  3    ; 157
 dc.b  3    ; 158
 dc.b  3    ; 159
 dc.b  3    ; 160
 dc.b  3    ; 161
 dc.b  3    ; 162
 dc.b  2    ; 163
 dc.b  2    ; 164
 dc.b  2    ; 165
 dc.b  2    ; 166
 dc.b  2    ; 167
 dc.b  2    ; 168
 dc.b  2    ; 169
 dc.b  2    ; 170
 dc.b  2    ; 171
 dc.b  1    ; 172
 dc.b  1    ; 173
 dc.b  1    ; 174
 dc.b  1    ; 175
 dc.b  1    ; 176
 dc.b  1    ; 177
 dc.b  1    ; 178
 dc.b  1    ; 179
 dc.b  1    ; 180
 dc.b  1    ; 181
 dc.b  1    ; 182
 dc.b  1    ; 183
 dc.b  1    ; 184
 dc.b  1    ; 185
 dc.b  1    ; 186
 dc.b  1    ; 187
 dc.b  1    ; 188
 dc.b  1    ; 189
 dc.b  1    ; 190
 dc.b  1    ; 191
 dc.b  0    ; 192
 dc.b  1    ; 193
 dc.b  1    ; 194
 dc.b  1    ; 195
 dc.b  1    ; 196
 dc.b  1    ; 197
 dc.b  1    ; 198
 dc.b  1    ; 199
 dc.b  1    ; 200
 dc.b  1    ; 201
 dc.b  1    ; 202
 dc.b  1    ; 203
 dc.b  1    ; 204
 dc.b  1    ; 205
 dc.b  1    ; 206
 dc.b  1    ; 207
 dc.b  1    ; 208
 dc.b  1    ; 209
 dc.b  1    ; 210
 dc.b  1    ; 211
 dc.b  1    ; 212
 dc.b  2    ; 213
 dc.b  2    ; 214
 dc.b  2    ; 215
 dc.b  2    ; 216
 dc.b  2    ; 217
 dc.b  2    ; 218
 dc.b  2    ; 219
 dc.b  2    ; 220
 dc.b  2    ; 221
 dc.b  3    ; 222
 dc.b  3    ; 223
 dc.b  3    ; 224
 dc.b  3    ; 225
 dc.b  3    ; 226
 dc.b  3    ; 227
 dc.b  3    ; 228
 dc.b  4    ; 229
 dc.b  4    ; 230
 dc.b  4    ; 231
 dc.b  4    ; 232
 dc.b  4    ; 233
 dc.b  4    ; 234
 dc.b  5    ; 235
 dc.b  5    ; 236
 dc.b  5    ; 237
 dc.b  5    ; 238
 dc.b  5    ; 239
 dc.b  5    ; 240
 dc.b  6    ; 241
 dc.b  6    ; 242
 dc.b  6    ; 243
 dc.b  6    ; 244
 dc.b  6    ; 245
 dc.b  7    ; 246
 dc.b  7    ; 247
 dc.b  7    ; 248
 dc.b  7    ; 249
 dc.b  7    ; 250
 dc.b  8    ; 251
 dc.b  8    ; 252
 dc.b  8    ; 253
 dc.b  8    ; 254
 dc.b  8    ; 255

       
        

        ORG $1FFC            ; Cart config (so 6502 can start it up)
VECTORS
        DC.W	START
        DC.W	START

END
