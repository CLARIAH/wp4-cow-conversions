## Catatso
Data repo for the 1427 Florentine Catasto

### Versions
There are two online catasto datafiles:
* http://www.disc.wisc.edu/archive/catasto/index.html.
* https://acrh.revues.org/7458, https://acrh.revues.org/7465, and https://acrh.revues.org/7462.

The wisconsin version has english documentation, but requires reconstructing the data from fixed-width files based on original punch cards. As this seems an error-prone process, I've used the French language version from https://acrh.revues.org rather than my old fwf-conversion. I have used the English version to translate and check for errors.

###  Data structure
Original data is in a wide format, with each row a household and each  individual from a demographic card for that household getting a new set of variables (A1, S1, ..., C47). These have been restructured so that each household contains a number of individuals who have a number of characteristics (age, sex, etc.). The original household-level observations have been left intact. Relationships to houshold head can be to one of multiple household heads. This can probably be expressed in a more direct way.

### Todo
Codebook:
    * Fix relate mess: relationToHead is not actually relationToHead.
    * Fix dimensions in URIs household/individual.
    * Check NUMSER role in locations.
    * check if resource/code/betail rather than resource/catasto/code/betail (as subject)
    * check if resource/code/numser rather than resource/catasto/code/numser (as object)
    * check if resource/NUMSER resource/catasto/dimension/NUMSER (as predicate)
    * check if resource/catasto/age resource/catasto/dimension/AGE (as predicate)
    * check if resource/catasto/comment resource/catasto/dimension/COMMENT (as predicate)
    * maybe also for maison and metier ?