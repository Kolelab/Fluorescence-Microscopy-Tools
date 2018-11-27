# TEAMSTER

This is the collection of circuit diagram, code and building instructions for TEAMSTER.

1. The circuit diagramm shows the pin-in pin-out structure for the provied Arduino code.
Teensy 3.2 and 3.5 can be used as both support 5V signals.

1. There are two different parts of code for TEAMSTER which can be found in subfolders.
In Teamster Arduino there are two sketches wich are written in Arduino compatible code.
Once the Teensy board is recognized by the Arduino environment 
(instructions see: https://www.pjrc.com/teensy/td_download.html ) the code can be verified and uploaded.

1. In Teamster Bean Shell Scripts we provide code that can be loaded from the scripting environment of Micromanger. 
Scripts are written in the Bean Shell scripting language.
**What does this code do?**
Executing one of the two scripts will generate a live overlay of two subsequent acquired channels. The frequency of overlay is half of the acquisition rate. Two scripts for acquisition rates of 10 Hz or 20 Hz are provided. 

