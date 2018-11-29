# TEAMSTER

This is the collection of circuit diagram, code and building instructions for TEAMSTER. Teamster enables LED and camera synchronization via Micromanager for life science microscopy applications.

1. The circuit diagramm shows the pin-in pin-out structure for the provied Arduino code.
Teensy 3.2 and 3.5 can be used as both support 5V signals.

1. There are two different parts of code for TEAMSTER which can be found in subfolders.
In Teamster Arduino there are two sketches wich are written in Arduino compatible code.
Once the Teensy board is recognized by the Arduino environment 
(instructions see: https://www.pjrc.com/teensy/td_download.html ) the code can be verified and uploaded.
* Version 5: is older and requires the board to be wired as shown below. 
* Version 6: **NEWEST** version, in which the the code was changed so resistors as shown below can be omitted.

1. In Teamster Bean Shell Scripts we provide code that can be loaded from the scripting environment of Micromanger. 
Scripts are written in the Bean Shell scripting language.
Executing one of the two scripts will generate a live overlay of two subsequent acquired channels. The frequency of overlay is half of the acquisition rate. Two scripts for acquisition rates of 10 Hz or 20 Hz are provided. 



## Part list

The prices are given as an estimate and can vary from country to country.

Item | Supplier/Manufacturer | Catalogue # | Note | Cost (€)
------------ | ------------- | ------------- | ------------- | -------------
Teensy 3.2 | PJRC.com | TEENSY32 | Arduino compatible board; other Arduino boards possible | 25
Footswitch | Farnell | 1703843 | Can be directly connected to the board or interfaced via a standard connector. | 22
BNC connectors | Farnell | 1020959 | Any other panel mount BNC connector can be used. | 1.5/piece
Switch |Farnell| 2128119 | Panel Mount | 3.5
Enclosure | e.g. from Farnell, Digikey or Mouser | N/A | Select an enclosure that fits the dimensions of the board. | up to 30
10 KΩ resistors | e.g. from Farnell, Digikey or Mouser | N/A | Any will do, you might have one lying around. | <1

If you have access to a 3D printer you can also print an enclosure as provided in the stl file.

Alternatively a do-it-yourself protoype enclosure could be made as suggested elsewhere:

https://blog.everydayscientist.com/?p=3139

http://labrigger.com/blog/2014/07/08/cardboard-for-prototyping/



## Further Instructions

1. Wire the board according to the schematic. 
![Circuit Image](https://github.com/Kolelab/Fluorescence-Microscopy-Tools/blob/master/TEAMSTER/Circuit%20TEAMSTER.png)
1. Connect the BNC connectors to the board.
1. Test the connections.
1. Connect the Arduino via USB to the computer
1. Start the ArduinoIDE
1. Open Fluorescence-Microscopy-Tools/TEAMSTER/Micromanager-teensy-v5-cleanup/Micromanager-teensy-v5-cleanup.ino and upload via the ArduinoIDE to the Teensy board.
1. Hook up camera and LEDs to inputs and outputs.
1. Set up Micromanager according to the instructions provided in Fluorescence-Microscopy-Tools/TEAMSTER/MicroManager_instructions.pdf
1. Test.



