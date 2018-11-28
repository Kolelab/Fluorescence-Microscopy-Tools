{{
  This code is the foundation for a dedicated pulse generator.
  See related documents.
}}

CON
  _xinfreq = 5000000
  _clkmode = xtal1 + pll16x

VAR
  long InputBit
  long Gatebit
  long OutputBit1
  long OutputBit2
  long OutputPulseDelay 
  long OutputPulseDuration
  long PulseGeneratorBit
  long PulseInterval
  long PulseDuration
  long OptoGateBit
  long OptoGateMinusOut2
  
PUB Main

  'Set up structure for the Pulse Detector

  InputBit:=10            
  GateBit:=8              
  OutputBit1:= 0
  OutputBit2:= 2

{{

  ____________________________
  OutputPulseDelay needed is 1ms
}}
  
  OutputPulseDelay:=(clkfreq/1000)*1

{{

  ____________________________
  OutputPulseDuration is 10ms
}}
  
  OutputPulseDuration:=(clkfreq/1000)*10
  
  
  OptoGateBit := 5

  OptoGateMinusOut2 := OptoGateBit - OutputBit2
  
  PulseGeneratorBit := 1
  
{{

  ____________________________
  InputPulseInterval is 12.5mS
}}

  PulseInterval:=(clkfreq/1000)*12.5

{{

  ____________________________
  InputPulseDuration is 200nS
  clk is 5 million for 1s, so 1 is for 200ns
}}

  PulseDuration:=1
  
  CogNew (@PulseGenerator, @PulseGeneratorBit)
  CogNew (@PulseDetector, @InputBit)
  CogStop(CogID)
          
DAT

        org 0

PulseDetector

        mov    PulseDetector_struct, par
        rdlong InputBit_position, PulseDetector_struct

        add    PulseDetector_struct, #4
        rdlong GateBit_position, PulseDetector_struct

        add    PulseDetector_struct, #4
        rdlong OutputBit1_position, PulseDetector_struct

        add    PulseDetector_struct, #4
        rdlong OutputBit2_position, PulseDetector_struct

        add    PulseDetector_struct, #4
        rdlong OutputPulse_Delay, PulseDetector_struct
        sub    OutputPulse_Delay,#16
        'This 16 sub confuses me
                                                   
        add    PulseDetector_struct, #4
        rdlong OutputPulse_Duration, PulseDetector_struct
        sub    OutputPulse_duration,#0                                            
        
        add    PulseDetector_struct, #4
        rdlong OptoGateBit_position, PulseDetector_struct

        add    PulseDetector_struct, #4
        rdlong OptoDiff, PulseDetector_struct
		
                'Create handy and fast masks
        mov    InputBit_mask, #1                                                                
        shl    InputBit_mask, InputBit_position                         '10000000000
        mov    NInputBit_mask,InputBit_mask                                        
        
		mov    GateBit_mask, #1
        shl    GateBit_mask, GateBit_position                           '00100000000
        'or     NInputBit_mask, GateBit_mask
        mov    OptoGateBit_mask, #1
        shl    OptoGateBit_mask, OptoGateBit_position         		    '00000100000
        'or     NInputBit_mask, OptoGateBit_mask                        
                
        xor    NInputBit_mask, Inverse_mask                             '01111111111
        
        mov    OutputBit1_mask, #1
        shl    OutputBit1_mask, OutputBit1_position                     '00000000001
        mov    OutputBit2_mask, #1
        shl    OutputBit2_mask, OutputBit2_position                     '00000000100
        
        mov    OutputBits_mask, OutputBit1_mask
        or     OutputBits_mask, OutputBit2_mask                         '00000000101
        
        mov    NOutputBits_mask,OutputBits_mask
        xor    NOutputBits_mask,Inverse_mask                            '11111111010

        'Set direction of the input and output pins
        and    dira, NInputBit_mask                                             '0dddddddddd
        or     dira, OutputBits_mask                                            '0ddddddd1d1
        and    outa, NOutputBits_mask                                           'oooooooo0o0

        'set which output bit to initially send a pulse to
        mov     OutputBit_mask,OutputBit1_mask
 
        '______________________________________            
        'Gate: T=*
:Gate   
        waitpeq GateBit_mask, GateBit_mask

        '______________________________________            
        'A: T=*
        waitpeq InputBit_mask, InputBit_mask   

        '______________________________________            
        'B: T=*
        waitpne InputBit_mask, InputBit_mask

        '______________________________________            
        'C: T=0
        mov    DelayEnd, OutputPulse_delay
        add    DelayEnd, cnt

        '______________________________________            
        'D: T>0  
        waitcnt DelayEnd, OutputPulse_delay

        '______________________________________            
        'E: T=1ms
        
                mov        ReadOptoGateBit_mask, ina					'iiiiiiiiiii
                shr        ReadOptoGateBit_mask, OptoDiff   'hack! can't change pins optogate and out2
				and        ReadOptoGateBit_mask, OutputBit2_mask		
                or         ReadOptoGateBit_mask, OutputBit1_mask
                and        ReadOptoGateBit_mask, OutputBit_mask
                
                or     outa, ReadOptoGateBit_mask

                
        mov    OutputPulseEnd,OutputPulse_duration  
        add    OutputPulseEnd,cnt

        waitcnt OutputPulseEnd, OutputPulse_duration

        '______________________________________            
        'F: T=11ms

        xor    OutputBit_mask,Inverse_mask                    
        and    outa,OutputBit_mask                

        xor    OutputBit_mask,Inverse_mask         
        xor    OutputBit_mask, OutputBits_mask    

        jmp    #:Gate                     

Inverse_mask         long -1

'_________________________________
InputBit_position    res 1 
'_________________________________
GateBit_position     res 1
'_________________________________
OptoGateBit_position     res 1
'_________________________________
OutputBit1_position  res 1                                                 
'_________________________________
OutputBit2_position  res 1 
'_________________________________
OutputPulse_delay    res   1
'_________________________________
OutputPulse_duration res   1 

'Summary of variables used by the assembler program.

'_________________________________
InputBit_mask        res 1                        
'_________________________________
NInputBit_mask       res 1
'_________________________________
GateBit_mask         res 1
'_________________________________
OptoGateBit_mask     res 1
'_________________________________
ReadOptoGateBit_mask     res 1
'_________________________________

OutputBit1_mask      res 1                              
'_________________________________
OutputBit2_mask      res 1  
'_________________________________
OutputBits_mask      res 1
'_________________________________
NOutputBits_mask     res 1
'_________________________________
 OutputBit_mask       res   1
'_________________________________
 OptoDiff		      res   1
'_________________________________
DelayEnd             res   1          
'_________________________________
OutputPulseEnd       res   1 
'_________________________________
PulseDetector_struct res   1         
'_________________________________
Xvalue               res   1
'_________________________________
 
                     fit   496

DAT    

        org     0

PulseGenerator

        mov     PulseGenerator_struct, par
        rdlong  PulseBit_, PulseGenerator_struct

        add     PulseGenerator_struct, #4
        rdlong  PulseInterval_, PulseGenerator_struct

        add     PulseGenerator_struct, #4
        rdlong  PulseDuration_, PulseGenerator_struct
        
        mov     PulseBitMask_, #1
        shl     PulseBitMask_, PulseBit_
        mov     NPulseBitMask_, PulseBitMask_
        xor     NPulseBitMask_, Inverse_mask

        or      dira, PulseBitMask_            
        and     outa, NPulseBitMask_           

        mov     Interval_timeout_, cnt
        add     Interval_timeout_, PulseInterval_

:Pulsing
        waitcnt Interval_timeout_, PulseInterval_

        xor     outa, PulseBitMask_            
        nop 
        nop 
        nop 
        xor     outa, PulseBitMask_

        jmp     #:Pulsing

PulseBit_             res 1 
PulseInterval_        res 1 
PulseDuration_        res 1 

PulseGenerator_struct res 1 
Interval_timeout_     res 1 
             
PulseBitMask_         res 1 
NPulseBitMask_        res 1 


        fit     496
            