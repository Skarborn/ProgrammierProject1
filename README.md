# Programming Task via Matlab creating a modified Map
The program is the result of the task to create a script basing upon the 
given "Map.m" and a table of measured network reception data "celldata.mat" 
which draws a heatmap of Oldenburg and also shows the positions of the 
radio masts.
It was free to include whatever fits, so some features were added.
Besides the distance to the nearest radio mast, the table consists of 
information to which network provider the mast belongs and what sort of 
network is being used (UMTS, LTE or GSM). 
With this program the user is free to choose which radio masts of which 
networking system and provider he wants to see. In addition to that it is
not only possible to get a map of Oldenburg, but also of every other town
in Germany with this display options.

## Getting Started

To get this program, everything the user has to do is, download the 
zip-file of the 
[GitHub-homepage](https://github.com/Skarborn/ProgrammierProject1.git)
and run it on Matlab after defining the path from where it has to run.
When you do not own Matlab in any version, you can download it at the 
owner's expense on the 
[MathWorks-homepage](https://www.mathworks.de/downloads).

## Running the Program

The "ProgrammierProject1"-file consists of nine different files, but to run
the main project, the user has only to type
```
>> netVision
```
in the Command Window or to press the in the right direction pointing green 
triangle after opening the netVision.m.
It may take some time until the window with the map and the command center
appears. 

### Defining the parametres
To get the wished information, the parametres have to be defined in the 
command center on the left-hand side of the window. For changing the 
coordinates, one of four applicable text edit fields has to be selected and
the corresponding value to be filled in. By ticking the checkboxes 
underneath, the display options are selectable in any way.
It is free to choose whether the heatmap or the radio mast places, which
belong to the different network providers of the different
network kinds are shown. 
After pressing the "�nderungen annehmen"-button the changes are registered 
and the program runs with the new parametres.
Moreover, it is choosable with a slider at the bottom of the window
which covering power the heatmap has.

## Built With
* [Matlab](https://www.mathworks.de/downloads) - Programed and runned with

## Versioning
Version 1.0
This program is finished and therefore will not be updated again.

## Authors
* **Martin Berdau** - *Head Programming Mastermind* 
* **Tammo Sander** - *Programming Mastermind* - 
[TammoSan](https://github.com/TammoSan)
* **Johannes R�sing** - *Programmer*
[Skarborn](https://github.com/Skarborn)

## License
This Code is Public Domain.

## Acknowledgements

 