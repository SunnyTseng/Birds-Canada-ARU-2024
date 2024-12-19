Birds Canada Chilcotin ARU Analysis
================
Sunny Tseng
2024-12-19

## **Overview**

This project was contracted to Sunny Tseng by Birds Canada, with the
goal of processing the audio data collected by Birds Canada in the field
and providing a descriptive report on the detections. This document
serves as the final report, summarizing the methods employed in the
analysis and presenting the results. All R code developed during the
project is available on the “[Birds Canada ARU
2024](https://github.com/SunnyTseng/Birds-Canada-ARU-2024/tree/main)”
GitHub page.

``` r
# required packages if you are following the code
library(tidyverse)
library(here)
```

## **Audio data & BirdNET processing**

Audio data were collected during the bird breeding seasons (May to July)
of 2023 and 2024 in the Chilcotin Cariboo region of British Columbia,
Canada. In 2023, 19 sites were surveyed, with each site monitored at one
or two locations. In 2024, the survey expanded to 24 sites, each with
two monitored locations. Approximately 6 TB of audio recordings were
gathered over the two years. Data collection employed two models of
Autonomous Recording Units (ARUs): the BAR-LT from Frontier Labs and the
Song Meter Mini from Wildlife Acoustics.

All audio data were analyzed using BirdNET (model v2.4) with the
original Python code from the [BirdNET Analyzer GitHub
repository](https://github.com/kahst/BirdNET-Analyzer). Analyses were
performed on a desktop computer using Visual Studio Code. While BirdNET
parameters were largely kept at their default settings, specific
adjustments included `result_type = "r"`, `batch_size = 4`, and
`threads = 4`. To maximize detections, a minimum confidence threshold of
0.1 was applied. Processing the full 6 TB of audio data required
approximately 72 hours of computer time.

## **All species - raw output**

The initial BirdNET analysis identified a total of 4,704,906 detections
across 5,384 classes, including birds, non-birds, and non-animal sounds.
The complete dataset is available for download from the project’s GitHub
page in `.rda` file format. To load and view the dataset in R, use the
following line of code:

``` r
# edit file path as needed
load(here("data", "BirdNET_detections", "detections_2023_2024.rda"))
```

I filtered the detections using the bird species list from the [Atlas of
the Breeding Birds of British
Columbia](https://www.birdatlas.bc.ca/bcdata/datasummaries.jsp?extent=Prov&summtype=SpList&year=allyrs&byextent1=Prov&byextent2=Sq&region2=1&squarePC=&region1=0&square=&region3=0&lang=en),
which includes 329 bird species recorded in the province. After
filtering, the detection dataset was reduced to 3,247,719 detections
representing 298 species. This filtered dataset can be accessed in R by
subsetting the full dataset using the BC bird list as follows:

``` r
# edit file path as needed
bc_list <- read_csv(here("data", "bird_list", "atlasdata_bc_birdlist.csv"))

detections_bc <- detections_2023_2024 %>%
  filter(common_name %in% bc_list$Species) 
```

It is important to note that these detections have not yet been
validated, so we cannot confirm that they represent the total number of
species detected in the study area. However, these provide an overview
of the number of detections and species across different sites. A
comprehensive species validation process is required to accurately
verify species richness. This process involves confirming the presence
of each species by validating at least one recording segment per
species.

Although this validation was not performed in the current analysis, it
can be achieved by selecting the top 5 or 10 detections for each species
and verifying their presence. This approach would provide a more
reliable estimate of the species richness in the study area.

<div class="datatables html-widget html-fill-item" id="htmlwidget-03ab497e696472a307f0" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-03ab497e696472a307f0">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33"],["2023","2023","2023","2023","2023","2023","2023","2023","2023","2023","2023","2023","2024","2024","2024","2024","2024","2024","2024","2024","2024","2024","2024","2024","2024","2024","2024","2024","2024","2024","2024","2024","2024"],["Axe Lake","Big Creek Control","Brunson Lake","Colpitt Lake","Dog Creek Road","Enterprise Road","Fiftynine Creek","Lilypad Lake","Murphy Lake","Tatton Lake","Thaddus Lake","Watson Creek","130 Mile reservoir","Big Creek Rd. 1","Buckskin","Chilco Jones Lake","Chilcotin Marshes","Chilcotin Meldrum Rd. 2","Chilcotin Meldrum Rd. 4","Enterprise road 1","Farwell Canyon Rd 1","Hutch segment 3","Isaac Meadow","Isaac meadow","Jaimeson Meadow","Maze Lake 1","McKay Rd 3","Mons Lake 3","Murphy Lake","Puntzi seg 6","Stack Vallley Rd. 2","Sugar Cane Jack","Tatton Lake"],[1,2,2,1,1,1,1,1,2,1,1,2,1,1,1,2,1,1,1,1,2,1,1,1,2,1,2,1,1,1,1,1,2],[37015,42,49869,28635,32986,64408,77797,45895,78106,24679,55729,39145,126579,158983,51811,143913,122544,98952,300,144157,242657,146841,131157,83768,252718,80604,241180,60135,98938,91698,123834,147504,165140],[199,13,232,195,218,204,247,175,219,205,238,200,271,262,178,276,268,271,25,252,277,258,258,215,288,197,259,216,206,233,245,281,253]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>year<\/th>\n      <th>site<\/th>\n      <th>No. location<\/th>\n      <th>Detections<\/th>\n      <th>No. BC species<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"pageLength":10,"scrollY":"400px","scrollCollapse":true,"columnDefs":[{"className":"dt-right","targets":[3,4,5]},{"orderable":false,"targets":0},{"name":" ","targets":0},{"name":"year","targets":1},{"name":"site","targets":2},{"name":"No. location","targets":3},{"name":"Detections","targets":4},{"name":"No. BC species","targets":5}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>

## **Focal species - validated output**

### Background

A total of 27 species were identified as focal species for this
analysis. These focal species are:

    ##  [1] "American Bittern"    "American Coot"       "American Wigeon"    
    ##  [4] "Barrow's Goldeneye"  "Black Tern"          "Bufflehead"         
    ##  [7] "Eared Grebe"         "Green-winged Teal"   "Horned Grebe"       
    ## [10] "Mallard"             "Pied-billed Grebe"   "Redhead"            
    ## [13] "Red-necked Grebe"    "Ring-necked Duck"    "Ruddy Duck"         
    ## [16] "Sora"                "Trumpeter Swan"      "Virginia Rail"      
    ## [19] "White-winged Scoter" "Yellow Rail"         "Band-tailed Pigeon" 
    ## [22] "Common Nighthawk"    "Evening Grosbeak"    "Flammulated Owl"    
    ## [25] "Rusty Blackbird"     "Sharp-tailed Grouse" "Townsend's Warbler"

After filtering the dataset to include only the 27 focal species,
788,511 detections were retained. This filtered dataset represents 26 of
the 27 focal species, with the White-winged Scoter being the only
species not detected in any recordings. The filtered dataset contains
788,511 rows. The complete dataset is available for download from the
project’s GitHub page in `.rda` file format. To load and view the
dataset in R, use the following line of code:

``` r
# edit file path as needed
load(here("data", "BirdNET_detections", "detections_2023_2024_focal.rda"))
```

The objective of selecting these focal species is to identify BirdNET
species-specific thresholds. The aim of setting species-specific
threshold is to maximize true-positive detections while minimizing
false-positives. To achieve this, we applied the methods proposed by
[Wood and Kahl
(2024)](https://link.springer.com/article/10.1007/s10336-024-02144-5)
and [Tseng et
al. (2024)](https://github.com/SunnyTseng/thesis_aru_BirdNET_evaluation/blob/main/R/Ch1_10_step_by_step_tutorial/species_specific_method_tutorial.md)
for establishing species-specific thresholds for BirdNET.

### Validation process

We selected 180 nine-second recording segments using stratified random
sampling across confidence values for each target species. Subsequently,
we validated whether these recordings were true positives (indicating
the target species was present) or false positives (indicating the
target species was absent).

Sunny Tseng, David Bradley, and Remi Torrenta participated in the
validation process. Sunny drafted the [validation
protocol](https://github.com/SunnyTseng/Birds-Canada-ARU-2024/blob/main/docs/project_report_11_19_species_validation_with_ShinyR.md)
and designed an R Shiny app that supports both audio playback and
spectrogram viewing. The validation process was conducted in November
and December 2024. The allocation of species among the three
participants can be found in this
[spreadsheet](https://docs.google.com/spreadsheets/d/1Ulb9EUYBQRwxg-WvMJjte0vJT6bJMl6n/edit?gid=554288332#gid=554288332).

### Calibration curve

Using the validated dataset, I employed a generalized linear model with
a binomial distribution to analyze the relationship between true/false
positives (response variable) and BirdNET confidence values (predictor
variables). This analysis will allow us to determine how BirdNET
confidence relates to true positive detections. The calibration curves
for each species indicate that most species can achieve a probability of
being a true positive of approximately 0.75 when the BirdNET confidence
value ranges from 0.25 to 0.40.

<img src="figures/calibration_curves_logistic.PNG" width="2834" />

### Species-specific thresholds (precision = 0.9, 0.95, 0.99)

To determine species-specific thresholds, I back-transformed the model
output to predict the probability of each BirdNET detection being a true
positive based on the reported confidence value. I then identified the
confidence threshold required to achieve a certain precision (i.e., 0.9,
0.95, 0.99), meaning the percentage of detections retained after
applying this threshold were true positives. For detailed methods, refer
to [Tseng et
al. (2024)](https://github.com/SunnyTseng/thesis_aru_BirdNET_evaluation/blob/main/R/Ch1_10_step_by_step_tutorial/species_specific_method_tutorial.md).

<div class="datatables html-widget html-fill-item" id="htmlwidget-0f5710b97816c3370042" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-0f5710b97816c3370042">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14"],["American Bittern","American Coot","American Wigeon","Band-tailed Pigeon","Barrow's Goldeneye","Black Tern","Common Nighthawk","Evening Grosbeak","Green-winged Teal","Mallard","Pied-billed Grebe","Sora","Townsend's Warbler","Virginia Rail"],[1,0.1,0.1,1,0.399,0.269,0.1,0.446,0.161,0.1,0.176,0.1,0.257,0.183],[1,0.1,0.1,1,0.537,0.369,0.1,0.714,0.345,0.1,0.279,0.1,0.367,0.275],[1,0.245,0.126,1,0.84,0.591,0.233,1,0.754,0.506,0.506,0.1,0.611,0.476]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>common_name<\/th>\n      <th>t_0.9<\/th>\n      <th>t_0.95<\/th>\n      <th>t_0.99<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"pageLength":10,"scrollY":"400px","scrollCollapse":true,"columnDefs":[{"className":"dt-right","targets":[2,3,4]},{"orderable":false,"targets":0},{"name":" ","targets":0},{"name":"common_name","targets":1},{"name":"t_0.9","targets":2},{"name":"t_0.95","targets":3},{"name":"t_0.99","targets":4}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>

### Daily activity (after applying species-specific threshold with precision = 0.95)

<img src="figures/daily_pattern_0.95.PNG" width="2834" />

### Seasonal activity (after applying species-specific threshold with precision = 0.95)

<img src="figures/seasonal_pattern_0.95_1.PNG" width="2834" /><img src="figures/seasonal_pattern_0.95_2.PNG" width="2834" /><img src="figures/seasonal_pattern_0.95_3.PNG" width="2834" />
