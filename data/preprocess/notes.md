# Town location Notes

Candidate towns are all of the Urban Centres & Locations in the 2011 ABS ASGS hierarchy, except for the ones not associated with a particular location (no usual address, state/territory remainders, shipping ones). We skipped the available UCL-to-SA1 correspondences, as most public Census data is provided at SA2 level. Instead, we calculated the centroids of the UCLs in QGIS and then calculated which SA2 each centroid fell into. We used this to associate each town with an SA2.

## Connectivity

Data source: ASGS 2016 Australia/State/GCCSA/SA4/SA3/SA2 based data for Dwelling Internet Connection by Dwelling Structure, for the 2016 Census of Population and Housing. The processing of this data is in `preprocess-internet.r`; we basically scale the fraction of connected users in a town's 2016 SA2 to 0–1.

## Coastal distance