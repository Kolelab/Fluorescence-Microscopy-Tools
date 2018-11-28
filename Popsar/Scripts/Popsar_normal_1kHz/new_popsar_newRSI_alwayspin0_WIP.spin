'OUTPUTS:
'0, 1 and 2 are outputs
'0 and 1 are LEDs
'2 is virtual shutter out
'INPUTS:
'3 is virtual shutter in (INTERNALY CONNECTED TO pin2)
'4 camera frame
'5 real shutter

CON
  _xinfreq = 5000000
  _clkmode = xtal1 + pll16x

VAR
  long OutputPulseDelay 
  long OutputPulseDuration
  long OutputBitMask  

PUB Main
  OutputPulseDelay:=20000                    'set an initial value of delay
  OutputPulseDuration:=40000                 'set an initial value of pulse
  OutputBitMask:=1                           'initial out is 1

  
  '0, 1 and 2 are outputs
  '0 and 1 are LEDs
  '2 is virtual shutter
  
  CogNew (@PulseMeasurer, @OutputPulseDelay)     'start pulse measuring
  'CogNew (@PulseGenerator, @OutputPulseDelay) 
  CogNew (@PulseDetector, @OutputPulseDelay)     'start pulse detecting
  CogStop(CogID)


DAT
  org 0

PulseMeasurer
        mov    PulseMeasurer_struct, par    'probably can be omitted
        rdlong _End, PulseMeasurer_struct   'probably can be omitted
        add    PulseMeasurer_struct, #4     'probably can be omitted
        rdlong  _End2, PulseMeasurer_struct 'probably can be omitted
                                            'just amking sure _End and _End2 are long
        mov _One, #1
        or     dira, #4                     'pin2 is output (virtual shutter)
        mov _RShutt, #32                    'read real shutter on pin5
        mov _Cam, #16                       'read camera frame out at pin4 

:Gate   
        waitpeq _RShutt, _RShutt            'wait for real shutter on            
        waitpne _Cam, _Cam                  'wait for camera pulse to be off  
        waitpeq _Cam, _Cam                  'wait for camera pulse to be on
        mov     _Beg, cnt                   'count to _Beg
        waitpne _Cam, _Cam                  'wait for camera pulse to be off
        waitpeq _Cam, _Cam                  'wait for camera pulse to be on
        mov     _End, cnt                   'count to _End
        sub     _End, _Beg                  'subtract to get the difference _End is now difference
        mov     _End2, _End                 '_End2 is now difference as well
        shr     _End, #2                    'divide by 4 and round (this is the delay)
        shr     _End2, #1                   'divide by 2 and round (this is the pulse)
        mov    PulseMeasurer_struct, par    'write these two to delay and pulse
        wrlong _End, PulseMeasurer_struct   'write delay duration
        add    PulseMeasurer_struct, #4     'move address
        wrlong  _End2, PulseMeasurer_struct 'write pulse duration
        add    PulseMeasurer_struct, #4
        wrlong _One, PulseMeasurer_struct     'write pin1 to start with
        or     outa, #4                     'output virtual shutter high
        waitpne _RShutt, _RShutt            'wait for real shutter off
        and    outa, #3                     'output virtual shutter low
        jmp    #:Gate

PulseMeasurer_struct    res 1
_Cam                    res 1
_RShutt                 res 1
_Beg                    res 1
_End                    res 1
_End2                   res 1
_One                    res 1         
        fit   496


DAT

        org 0

PulseDetector

        or     dira, #3                         'output LED pins are pin0 and pin1      
        and    outa, #4                         'out pins to zero
        mov    _Shutt, #8                       'read virtual shutter at pin3
                                                'PINS 2 AND 3 ARE INTERNALY CONNECTED
        mov    _Cam2, #16                       'read camera frame at pin4

        '______________________________________            
        'Gate: T=*
:Gate2   
                                                
        waitpeq _Shutt, _Shutt                  'wait for virtual shutter on
        
        mov    PulseDetector_struct, par        'read measured delay
        rdlong OutputPulse_Delay, PulseDetector_struct  'read measured delay
        add    PulseDetector_struct, #4         'read measured pulse
        rdlong OutputPulse_Duration, PulseDetector_struct 'read measured pulse
        add    PulseDetector_struct, #4         'read measured pulse
        rdlong OutputBit_mask, PulseDetector_struct 'read output pin
        '______________________________________            
        'A: T=*
        waitpne _Cam2, _Cam2                    'wait for camera pulse to be off
        waitpeq _Cam2, _Cam2                    'wait for camera pulse to be on      

        '______________________________________            
        'C: T=0
        mov    DelayEnd, OutputPulse_delay      'set this variable to delay
        add    DelayEnd, cnt                    'add current clock tick count to it

        '______________________________________            
        'D: T>0  
        waitcnt DelayEnd, #0                    'wait for clock to reach clock+delay

        '______________________________________            
        'E: T=1ms
        or     outa, OutputBit_mask             'set pin high (inintially pin0)

        mov     OutputPulseEnd,OutputPulse_duration  'set this variable to pulse
        add     OutputPulseEnd,cnt              'add current clock tick count to it
        waitcnt OutputPulseEnd, #0              'wait for clock to reach clock+delay

        '______________________________________            
        'F: T=11ms

        and    outa, #4                        'both pin0 and pin1 off
        xor    OutputBit_mask, #3              'invert mask (initialy set to pin0, now it is pin1)
                                               'in the second loop it will convert the other way

        mov    PulseDetector_struct, par        '
        add    PulseDetector_struct, #4         '
        add    PulseDetector_struct, #4         '
        wrlong OutputBit_mask, PulseDetector_struct 'write new out pin
        
        jmp    #:Gate2          

PulseDetector_struct    res 1 
DelayEnd                res 1
OutputPulse_delay       res 1
OutputPulseEnd          res 1
OutputPulse_duration    res 1 
OutputBit_mask          res 1
_Shutt                  res 1
_Cam2                   res 1   
         
        fit   496


{{        
DAT    

        org     0

PulseGenerator

        mov     PulseBit_, #0

        mov    PulseGenerator_struct, par
        rdlong PulseInterval_, PulseGenerator_struct
        

        
        mov     PulseBitMask_, #3
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

        mov    PulseGenerator_struct, par
        rdlong PulseInterval_, PulseGenerator_struct
        


        jmp     #:Pulsing



 Inverse_mask         long -1

PulseBit_             res 1 
PulseInterval_        res 1 
PulseDuration_        res 1 

PulseGenerator_struct res 1 
Interval_timeout_     res 1 
             
PulseBitMask_         res 1 
NPulseBitMask_        res 1 


        fit     496
}}