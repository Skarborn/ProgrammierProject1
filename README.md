# Programming Task via Matlab creating a modified Map
The program is the result of the task to create a script basing upon the 
given "Map.m" and a table of measured network reception data "celldata.mat" 
which draws a heatmap of Oldenburg and also shows the positions of the 
basis transmitter stations (BTS).
It was free to include whatever fits, so some features were added.
Besides the distance to the nearest BTS, the table consists of 
information to which network provider the mast belongs and what sort of 
network is being used (UMTS, LTE or GSM). 
With this program the user is free to choose which BTS of which 
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
the corresponding value to be filled in. The edit fields on the
left-hand side are the least coordinates while the edit fields on the
right-hand side are the maximal coordinates. By ticking the checkboxes 
underneath, the display options are selectable in any way.
It is free to choose whether the heatmap or the radio mast places, which
belong to the different network providers of the different
network kinds are shown. It does not make sense to tick the checkbox
of a network provider and a network kind without ticking the 
"Funktürme"-checkbox.
After pressing the "Änderungen annehmen"-button the changes are registered 
and the program runs with the new parametres.
Moreover, it is choosable with a slider at the bottom of the window
which covering power the heatmap has.
For example if the user is interested into the place where the E-Plus-BTS
stand and how their impact is with LTE, the checkboxes "Funktürme",
"Heatmap", "E-Plus" and "LTE" have to be marked, to get an right result.
With the intention to see only the heatmap it is possible by putting the 
slider for the transparency of the heatmap on the value "1".

## Built With
* [Matlab](https://www.mathworks.de/downloads) - Programed and runned with

## Versioning
Version 1.0
This program is finished and therefore will not be updated again.

## Authors
* **Martin Berdau** - *Programmer* -
[MartinBerdau](https://github.com/MartinBerdau)
* **Tammo Sander** - *Programmer* - 
[TammoSan](https://github.com/TammoSan)
* **Johannes Rüsing** - *Programmer* -
[Skarborn](https://github.com/Skarborn)

## License
This Code is Public Domain.

## Remarks
Besides the main script, the celldata-table and the Map-script, there are 
some other .m-files which are used to reproduce what worksteps have been 
done. The development of the whole project started in the test_map.m where
the first structure and idea took place. In TesteMap.m the first try to
draw the BTS was made and continued in drawBTS.m. To draw the heatmap, 
first createHeatmap.m was designed, but it got superseded by drawHeatmap.m.
After each of the designs was finished, it got implemented in the 
netVision.m-file, the main script. So these mentioned files are not part 
of the final product.

### Structure of netVision
* **Properties** (Z.30-45)
* **Functions**: 
* netVision (Z.48-251),
* apply (Z.253-283),
* relevantData (Z.284-345),
* drawDots (Z.347-409), 
* setAlphaData (Z.410-416),
* drawHeatmap (Z.418-485), 
* eraseOverlays (Z.487-496)

 