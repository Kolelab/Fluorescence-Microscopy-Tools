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

PUB Main

  'Set up structure for the Pulse Detector

  InputBit:=10            
  GateBit:=8              
  OutputBit1:= 0
  OutputBit2:= 2

{{

  ____________________________
  OutputPulseDelay needed is 250uS.
}}
  
  OutputPulseDelay:=20000

{{

  ____________________________
  OutputPulseDuration is 0.5mS
}}
  
  OutputPulseDuration:=40000

  PulseGeneratorBit := 1
  
{{

  ____________________________
  InputPulseInterval is 4mS
}}

  PulseInterval:=80000

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

        add    PulseDetector_struct, #4
        rdlong OutputPulse_Duration, PulseDetector_struct
        sub    OutputPulse_duration,#0                                            

        'Create handy and fast masks
        mov    InputBit_mask, #1
        shl    InputBit_mask, InputBit_position
        mov    NInputBit_mask,InputBit_mask
        xor    NInputBit_mask, Inverse_mask
        mov    GateBit_mask, #1
        shl    GateBit_mask, GateBit_position
        mov    OutputBit1_mask, #1
        shl    OutputBit1_mask, OutputBit1_position
        mov    OutputBit2_mask, #1
        shl    OutputBit2_mask, OutputBit2_position
        mov    OutputBits_mask, OutputBit1_mask
        or     OutputBits_mask, OutputBit2_mask
        mov    NOutputBits_mask,OutputBits_mask
        xor    NOutputBits_mask,Inverse_mask

        'Set direction of the input and output pins
        and    dira, NInputBit_mask   
        or     dira, OutputBits_mask  
        and    outa, NOutputBits_mask 

        'set which output bit to initially send a pulse to
        mov     OutputBit_mask,OutputBit1_mask
 
        '______________________________________            
        'Gate: T=*
:Gate   
        waitpeq GateBit_mask, GateBit_mask

        '______________________________________            
        'A: T=*
        waitpne InputBit_mask, InputBit_mask

        '______________________________________            
        'B: T=*
        waitpeq InputBit_mask, InputBit_mask 

        '______________________________________            
        'C: T=0
        mov    DelayEnd, OutputPulse_delay
        add    DelayEnd, cnt

        '______________________________________            
        'D: T>0  
        waitcnt DelayEnd, OutputPulse_delay

        '______________________________________            
        'E: T=100uS
        or     outa, OutputBit_mask

        mov    OutputPulseEnd,OutputPulse_duration  
        add    OutputPulseEnd,cnt

        waitcnt OutputPulseEnd, OutputPulse_duration

        '______________________________________            
        'F: T=3.6mS

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
            