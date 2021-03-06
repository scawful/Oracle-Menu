;====================================
; Text Routines
;====================================

;; Alphabet manual writing function
;; $2550 --> A 
;; $2551 --> B
;; $2552 --> C
;; $2553 --> D
;; $2554 --> E, etc 
'A' = $2550
'B' = $2551
'C' = $2552
'D' = $2553
'E' = $2554
'F' = $2555
'G' = $2556
'H' = $2557
'I' = $2558
'J' = $2559
'K' = $255A
'L' = $255B
'M' = $255C
'N' = $255D
'O' = $255E
'P' = $255F
'Q' = $2560
'R' = $2561
'S' = $2562
'T' = $2563
'U' = $2564
'V' = $2565
'W' = $2566
'X' = $2567
'Y' = $2568
'Z' = $2569
'.' = $256A
':' = $256B
'0' = $2570
'1' = $2571
'2' = $2572
'3' = $2573
'4' = $2574
'5' = $2575
'6' = $2576
'7' = $2577
'8' = $2578
'9' = $2579
'_' = $20F5

; ===================================================================================

DeathLabel:
  dw "DEATHS:_"

DrawDeathCounter:
  REP #$30
  LDX.w #$0E

.draw2
  LDA.w DeathLabel, X
  STA.w $13CC, X 
  DEX : DEX : BPL .draw2

  RTS

; ===================================================================================

ScrollsLabel:
  dw "SCROLLS:_"

DrawScrollsLabel:
  LDX.w #$10

.draw2
  LDA.w ScrollsLabel, X
  STA.w $140C, X 
  DEX : DEX : BPL .draw2

  RTS

; ===================================================================================

PlaytimeLabel:
  dw "PLAYTIME:_"

DrawPlaytimeLabel:
  LDX.w #$10

.draw2
  LDA.w PlaytimeLabel, X
  STA.w $1692, X 
  DEX : DEX : BPL .draw2

  RTS

; ===================================================================================

Menu_ItemNames:
  dw "__SLINGSHOT___  "
  dw "__BOOMERANG___  "
  dw "___HOOKSHOT___  "
  dw "____BOMBS_____  "
  dw "__DEKU_MASK___  "
  dw "____BOTTLE____  "
  dw "___FIRE_ROD___  "
  dw "___ICE_ROD____  "
  dw "_____LAMP_____  "
  dw "____HAMMER____  "
  dw "__GORON_MASK__  "
  dw "____BOTTLE____  "
  dw "___SOMARIA____  "
  dw "____BYRNA_____  "
  dw "_SECRET_TOME__  "
  dw "_JUMP_FEATHER_  "
  dw "__BUNNY_HOOD__  "
  dw "____BOTTLE____  "
  dw "___OCARINA____  "
  dw "_MAGIC_MIRROR_  "
  dw "____SHOVEL____  "
  dw "_MAGIC_POWDER_  "
  dw "__STONE_MASK__  "
  dw "____BOTTLE____  "

Menu_DrawItemName:
  LDA.w $0202 : DEC
  ASL : ASL : ASL : ASL : ASL
  LDY.w #$000
  TAX 
.loop
  LDA.w Menu_ItemNames, X ; Load your text character
  STA.w $1692, Y ; <- into the buffer
  INX : INX
  INY : INY : CPY #$001C : BCC .loop
  RTS

; ===================================================================================

; ;LDX.w $7E00A0 		; load room number
;-------------------------------------
TestLocationName:
    dw "YOUR_HOUSE__"
;-------------------------------------

DrawLocationName:
{
  REP #$30
  LDA $1B 		; check if indoors or outdoors 
  AND.w #$00FF    ; isolate bit 
  CMP.w #$01      ; if 1, then indoors 
  BEQ .indoors
  
  LDA.b $8A
  ASL : ASL : ASL : ASL : ASL
  LDY.w #$000
  TAX 
.loop
  LDA.w OverworldLocationNames, X ; Load your text character
  STA.w $12CC, Y ; <- into the buffer
  INX : INX
  INY : INY : CPY #$0020 : BCC .loop
  RTS

.indoors
  LDX.w #$16

  .loop2
  LDA.w TestLocationName, X
  STA.w $12CC, X

  DEX : DEX
  BPL .loop2

  RTS
}


; ===================================================================================

Menu_DrawSelect:
  REP #$30
  LDX.w #$16

.loop
  LDA.w SelectItemTXT, X
  STA.w $1194, X

  DEX : DEX
  BPL .loop

  RTS

; ===================================================================================

Menu_DrawQuestStatus:
  REP #$30
  LDX.w #$16

.loop
  LDA.w QuestStatusTXT, X
  STA.w $1194, X

  DEX : DEX
  BPL .loop

  RTS

; ===================================================================================

Menu_DrawAreaNameTXT:
  REP #$30
  LDX.w #$26

.loop
  LDA.w AreaNameTXT, X
  STA.w $128C, X

  DEX : DEX
  BPL .loop

  RTS

; ===================================================================================
    
; Player's Name
; $3D9-$3E4: See appendix for listing of character codes. Note each of the six letters is represented by a 16-bit number.
; 00-A 01-B 02-C 03-D 04-E 05-F 06=G 07-H 08-I^ 09-J 0A-K 0B-L 0C-M 0D-N OE-O OF-P 
; 10-??
; 20-Q 21-R 22-S 23-T 24-U 25-V 26-W 27-X 28-Y 29-Z 2A-a 2B-b-2C-c 2D-d 2E-e 2F-f
; 40-g 41-h 42-k 43-j 44-i 45-l 46-m 47-n 48-o 49-p 4A-q 4B-r 4C-s 4D-t 4E-u 4F-v

; 60-w 61-x 62-y 63-z 64-0 65-1 66-2 67-3 68-4 69-5 6A-6 6B-7 6C-8 6D-9 6E-"?" 6F-"!"
; 80-"-" 81-"." 82-","   85-"(" 86-")" 

;B1-blank^

; ^This code is not the canon encoding of this character. ex. AF is the proper "I". 08 is not.

Menu_DrawCharacterName:
  REP #$30

  LDX.w #$C
.loop
  LDA.l $7EF3D9, X
  CMP.w #$AF : BEQ .fix_i 
  CMP.w #$10 : BCC .skip ; handle P -> Q gap
  SBC.b #$10
  CLC
  CMP.w #$2A : BCS .fix_lowercase 
.skip
  CLC : ADC #$2550
  STA.w $138C, X
  DEX : DEX : BPL .loop

  RTS

.fix_i
  LDA.w #$08 : BRA .skip 

.fix_lowercase
  LDA.w #$1D : BRA .skip