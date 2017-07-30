# Town location

Candidate towns are all of the Urban Centres & Locations in the 2011 ABS ASGS hierarchy, except for the ones not associated with a particular location (no usual address, state/territory remainders, shipping ones). We skipped the available UCL-to-SA1 correspondences, as most public Census data is provided at SA2 level. Instead, we calculated the centroids of the UCLs in QGIS (2.18.2) and then calculated which SA2 each town fell into using Add polygon attributes to points. We used this to associate each town with an SA2 (it's a bit slip-shod, but hey—we're on a timetable here).

## Connectivity

Data source: ASGS 2016 Australia/State/GCCSA/SA4/SA3/SA2 based data for Dwelling Internet Connection by Dwelling Structure, for the 2016 Census of Population and Housing. The processing of this data is in `preprocess-internet.r`; we basically scale the fraction of connected users in a town's 2016 SA2 to 0–1.

## Coastal distance

We used the 2016 ASGS Australia digital boundary for the coastlines. We simplified the coastline geometry (tolerance 0.1, I think) and converted it to points using Extract Nodes. Then we used the Field Calculator in the Attribute Table to assign a unique ID to each coastline point. Finally, the Distance Matrix tool (with `k = 1`) allowed us to work out the distance from each town point to the nearest coastline point.

## Electoral boundaries and data

We used QGIS's Add polygon attributes to points tool on the AEC's [2016 National electoral boundaries](http://www.aec.gov.au/Electorates/gis/gis_datadownload.htm) to associate each town with a division (just as with the 2016 SA2 to 2011 UCL association). Then we extracted the swings for each electorate from [the 2016 election's voting data](http://results.aec.gov.au/20499/Website/Downloads/HouseTppByDivisionDownload-20499.csv).