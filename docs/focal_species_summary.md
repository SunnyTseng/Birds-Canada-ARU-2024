# Progress report - Nov. 1

## Focal species and BirdNET analysis

The study focuses on 27 target bird species. We processed all ARU (Acoustic Recording Unit) recordings collected during the 2023 and 2024 breeding seasons using BirdNET. For this analysis, BirdNET parameters were set primarily to default, with the following customizations: result_type = "r", batch_size = 4, and threads = 4. To maximize detections, we used a minimum confidence threshold of 0.1.

The initial analysis yielded a total of 4,704,906 detections across all species and recordings. After filtering the dataset to include only the 27 focal species, we retained 788,511 detections. This filtered dataset represents 26 of the 27 focal species, with the White-winged Scoter being the only species not detected in any recordings.

The filtered dataset, with 788,511 rows, can be downloaded from this [link](https://github.com/SunnyTseng/Birds-Canada-ARU-2024/blob/main/data/detections_2023_2024_focal.rda), in a `rda` file format. Use the following line of code to view the dataset in R: 

`load("YOUR_FILE_PATH/detections_2023_2024_focal.rda")`

## Detections across time of day

We applied a universal confidence threshold of 0.5 to filter out potentially unreliable detections. While this approach provides a quick way to visualize general patterns for each species, species-specific thresholds will be necessary to produce unbiased and accurate activity patterns. Determining species-specific thresholds for each focal species will be a priority in the next project phase. This preliminary review examines detection patterns for target species across times of day, focusing on the period from 10 pm to 10 am.

Some species exhibit clear diurnal activity patterns, such as the American Coot, Black Tern, Bufflehead, Evening Grosbeak, Rusty Blackbird, Sharp-tailed Grouse, and Townsend's Warbler, with activity concentrated around dawn. In contrast, species like the Virginia Rail, Flammulated Owl, and Sora demonstrate nocturnal patterns, as they are primarily detected during the first half of the night.

![](/docs/figures/detections_time_of_day_0.5.png)


## Detections across day of year

As with the previous analysis, we applied a universal confidence threshold of 0.5 to filter out potentially unreliable detections. This filtered dataset was then used to visualize the activity patterns of each species across the days of the year. This approach is intended for quick visualization and data exploration. A more detailed analysis will be conducted to determine species-specific thresholds.


![](/docs/figures/species_activity_1.png)
![](/docs/figures/species_activity_2.png)
![](/docs/figures/species_activity_3.png)
![](/docs/figures/species_activity_4.png)
![](/docs/figures/species_activity_5.png)
![](/docs/figures/species_activity_6.png)
![](/docs/figures/species_activity_7.png)

## Next steps
- Set up the system for validating recording segments (360 segments per species)
- Determine species-specific thresholds for target species

## Focal species list
- American Bittern
- American Coot
- American Wigeon
- Barrow's Goldeneye
- Black Tern
- Bufflehead
- Eared Grebe
- Green-winged Teal
- Horned Grebe
- Mallard
- Pied-billed Grebe
- Redhead
- Red-necked Grebe
- Ring-necked Duck
- Ruddy Duck
- Sora
- Trumpeter Swan
- Virginia Rail
- White-winged Scoter
- Yellow Rail
- Band-tailed Pigeon
- Common Nighthawk
- Evening Grosbeak
- Flammulated Owl
- Rusty Blackbird
- Sharp-tailed Grouse
- Townsend's Warbler