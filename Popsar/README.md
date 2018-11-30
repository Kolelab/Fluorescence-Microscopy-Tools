# Popsar

## General Information

Popsar is a dual channel high frequency splitter for e.g. fast imaging of two fluophores, ratiometric imaging or 
imaging and interleaved photostimulation. A single input channel is alternatively assigned to one of the two output channels.
Popsar is based on the real-time and parallel processing board Propeller ASC+. It is programmed in the freely available
PropellerIDE https://developer.parallax.com/propelleride/



## Part list

The prices are given as an estimate and can vary from country to country.

Item | Supplier/Manufacturer | Catalogue # | Note | Cost (€)
------------ | ------------- | ------------- | ------------- | -------------
Propeller ASC+ | Parallax Inc. | 32214 | Can be purchased from RS components. | 56
Power supply | Farnell | 2451882 | 6-9 V power supply with 2.1 mm jack. The propeller board can also be powered from USB. | 10
BNC connectors | Farnell | 1020959 | Any other panel mount BNC connector can be used. | 1.5/piece
Enclosure | e.g. from Farnell, Digikey or Mouser | N/A | Select an enclosure that fits the dimensions of the board. | up to 30
10 KΩ resistor | e.g. from Farnell, Digikey or Mouser | N/A | Any will do, you might have one lying around. | <1

Alternatively a do-it-yourself protoype enclosure could be made as suggested elsewhere:

https://blog.everydayscientist.com/?p=3139

http://labrigger.com/blog/2014/07/08/cardboard-for-prototyping/


## Further Instructions

1. Wire the board according to the schematic. 
![Circuit Image](https://github.com/Kolelab/Fluorescence-Microscopy-Tools/blob/master/Popsar/Circuit%20Popsar.png)
1. Connect the BNC connectors to the board.
1. Test the connections.
1. Determine polarity of camera pulse given at frame exposure.
1. Download the PropellerIDE.
1. Download from /Popsar/Scripts/... repository the code for either 80 Hz or 1 kHz. 
1. Adjust camera pulse polarity if necessary --> see Note in /Scripts
1. Load the code into the Propller IDE.
1. Connect the propeller board.
1. Write the code to the propeller board.
1. Test.


## Image Processing
After images are acquired images require splitting into two channels. We have implemented a Frame Splitter for RedShirt Imaging files and provide the source code here: https://github.com/Kolelab/Image-analysis/blob/master/FrameSplitter.txt




