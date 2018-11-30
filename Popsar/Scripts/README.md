## Information

Scripts were written for RedShirtImaging (RSI) cameras. Depending on the manufacturing date, RSI cameras give out negative or positive pulses at begin of frame exposure. This has to be determined for the camera that will be utilized. 

* There are two folders in Fluorescence-Microscopy-Tools/Popsar/Scripts. These two scripts both provide alternating outputs on the two TTL ouput channels (from one input channel).

## Differences in functionality

### Script in: Fluorescence-Microscopy-Tools/Popsar/Scripts/Popsar_inverted_80Hz
* This script detectes inverted camera output pulses (from high to low).
* The script has a software coded acqusition frequency (can be changed).
* The opto-gate is implemented. When a BNC is connected to the opto-gate only one TTL is activated unless the opto-gate is receiving an input, then both TTL ouputs are assigned.

Lines 145-149 require editing if camera provides positive pulses (low to high):
```
        'A: T=*
        waitpeq InputBit_mask, InputBit_mask        ' change to waitpne if low to high

        '______________________________________            
        'B: T=*
        waitpne InputBit_mask, InputBit_mask        ' change to waitpeq if low to high

```


### Scripts in: Fluorescence-Microscopy-Tools/Popsar/Scripts/Popsar_normal_1kHz/ 
* These two scripts are different versions:
  * Fluorescence-Microscopy-Tools/Popsar/Scripts/Popsar_normal_1kHz/Dual Popsar V0 - External 1kHz.spin has a defined 1 kHz acquisition frequency (can be changed in the code).
  * Fluorescence-Microscopy-Tools/Popsar/Scripts/Popsar_normal_1kHz/new_popsar_newRSI_alwayspin0_WIP.spin autodetection of acquisition frame rate is implemented (first 2 frames are discarded).
** NB: Neccesiates a synchronization pulse when used in conjungtion with electrophysiology (as imaging frames are shifted).
* Detected are normal polarity pulses (low to high).
* Opto-gate is not implemented in these two scripts as activation frequencies are presumably too short at 1 Khz to sufficiently activtate channelrhodopsin (not tested).


#### new_popsar_newRSI_alwayspin0_WIP

Lines 51 and 52 as well as 54 and 55 require editing if camera gives out inverted pulses:
```
waitpne _Cam2, _Cam2                    'wait for camera pulse to be off
waitpeq _Cam2, _Cam2                    'wait for camera pulse to be on 
```
This detects off -> on transition or rising phase.
 
If the camera sends falling phase then it would be:
 ```
waitpeq _Cam2, _Cam2                    'wait for camera pulse to be on 
waitpne _Cam2, _Cam2                    'wait for camera pulse to be off
``` 
 
 
Lines 59-60 determine pulse duration automatically.

 ``` 
shr     _End, #2                    'divide by 4 and round (this is the delay)
shr     _End2, #1                   'divide by 2 and round (this is the pulse)
  ```
Now this was quick and dirty. Fast current drivers like [Cyclops](http://www.open-ephys.org/cyclops/) don´t need a quarter of time for delay.
These are **very** safe values. Advanced users should reduce delay for fast current drivers.


