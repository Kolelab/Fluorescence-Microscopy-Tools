# SLIDER

SLIDER - Simple light digitizer, provides digital control of LED intensities when the Thorlabs T-cube LED driver 
is used in modulation mode. SLIDER is designed to be interconnected between LED triggering hardware and the T-cube driver.
By integrating a built-in analog switch delays are kept at a mimimun. Steps are coded at 12 bit allowing fine adjustment 
of LED intensities.


## Part list

The prices are given as an estimate and can vary from country to country.

Item | Supplier/Manufacturer | Catalogue # | Note | Cost (€)
------------ | ------------- | ------------- | ------------- | -------------
Analogue Switch MC14066B | ON Semiconductor | MC14066B | | 0.5
Operational amplifier LM158 | Texas Instruments | 1459505 or 2474067 | Other Op-Amp with similar specs exist. | 0.5
1.8" Color TFT LCD - ST7735R | Adafruit | 358 | 3.3V-5V
160 x128 pixels| 20
Teensy 3.6 |PJRC.com| TEENSY36 | 3.3 V| 30
Power connector | Farnell | 2646488 | Panel mount | 4
Power supply | Farnell | 1971798 | Generic 24V | 17
Voltage regulators (each 1x) | Farnell | 12V: 2849721, 5V: 1564483, 3.3V: 1652296 or 1703357 | 12V, 5V, 3.3V
One might want to include heatsinks as the voltage regulators will get hot. | 0.5-1/piece
Switch | Farnell | 9473602 | Panel mount two way ON-ON switch  | 6
Push buttons (8x) | Farnell | 2456210 or 2543089 | Soldered onto breadboard | 2
4 BNC connectors  | Farnell | 1020959 | Panel mount | 1.5/piece
Capacitors (100 nF) | Farnell | 9411887 | Through hole | 0.5
Resistors (4 x 10 kΩ, 2 x 20 kΩ)| Farnell | 10 kΩ: 2329609 20 kΩ: 9342796 | Through hole | 1
Prototyping board | Farnell | 1172108 | Similar boards can be utilized and cut to size | 6
Enclosure | 3D printed | N/A | Stl files provided | N/A





## Further Instructions

1. Wire the board according to the schematic. 
![Circuit Image](https://github.com/Kolelab/Fluorescence-Microscopy-Tools/blob/master/TEAMSTER/Circuit%20TEAMSTER.png)
1. Connect the BNC connectors to the board.
1. Test the connections.
1. Hook up camera and LEDs to inputs and outputs.
1. Set up Micromanager according to the instructions provided in /TEAMSTER/MMinstructions.pdf.
1. Test.

