## Focal species and BirdNET analysis

The study focuses on 27 target bird species. We processed all ARU (Acoustic Recording Unit) recordings collected during the 2023 and 2024 breeding seasons using BirdNET. For this analysis, BirdNET parameters were set primarily to default, with the following customizations: result_type = "r", batch_size = 4, and threads = 4. To maximize detections, we used a minimum confidence threshold of 0.1.

The initial analysis yielded a total of 4,704,906 detections across all species and recordings. After filtering the dataset to include only the 27 focal species, we retained 788,511 detections. This filtered dataset represents 26 of the 27 focal species, with the White-winged Scoter being the only species not detected in any recordings.

The filtered dataset can be found from this link, in a `rda` file format. Use the following line of code to view the dataset in R: 

`load("YOUR_FILE_PATH/detections_2023_2024_focal.rda")`

## Detections across time of day

We applied a universal confidence threshold of 0.5 to filter out potentially unreliable detections. While this approach provides a quick way to visualize general patterns for each species, species-specific thresholds will be necessary to produce unbiased and accurate activity patterns. Determining species-specific thresholds for each focal species will be a priority in the next project phase. This preliminary review examines detection patterns for target species across times of day, focusing on the period from 10 pm to 10 am.

Some species exhibit clear diurnal activity patterns, such as the American Coot, Black Tern, Bufflehead, Evening Grosbeak, Rusty Blackbird, Sharp-tailed Grouse, and Townsend's Warbler, with activity concentrated around dawn. In contrast, species like the Virginia Rail, Flammulated Owl, and Sora demonstrate nocturnal patterns, as they are primarily detected during the first half of the night.

![](/docs/figures/detections_time_of_day_0.5.png)

## Number of detections across sites and day of a year




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