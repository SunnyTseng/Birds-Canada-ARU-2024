ARU data processing on BirdNET for Birds Canada (west)
================

## Introduction

The ARU data was collected by Birds Canada during 2023 breeding season
in the area of Chilcotin, Cariboo, BC, Canada. A total of 21 sites were
set up, with each site having 2 ARU locations. The goal of this
repository is to analyzing all the ARU recordings that collected from
this project through BirdNET, and provide detection information for each
of the ARU.

## Workflow

1.  Data organization
2.  Data exploration
3.  Processing data through BirdNET GUI
4.  Data wrangling and cleaning
5.  Final summarizing

## BirdNET Analyzer GUI settings

All the analyses were done on [BirdNET
Analyzer](https://github.com/kahst/BirdNET-Analyzer) GUI on Windows. The
model version that used in the GUI is
*BirdNET_GLOBAL_6K_V2.4_Model_FP32.tfile*.

- Species by location: setting the location and time would enhance the
  precision of detection.
  - latitude: 51 or 52, base on site location
  - longitude: -121 or -122, base on site location
  - week: 24, mid June, base on the time that the recording was made
- Inference settings
  - Minimum confidence: 0.5 (default)
  - Sensitivity: 1 (default)
  - Overlap: 0 (default)
- Other settings
  - Result type: R
  - Batch size: 4
  - Threads: 4

## Output

- One excel file was produced for each site, each ARU, with the
  following naming rule: `site_location_aruid_type.csv`
- Each row of the data frame represents single BirdNET detection
- Columns of the data set are explained below:

| Column name     | Description                                                                                                              |
|-----------------|--------------------------------------------------------------------------------------------------------------------------|
| site            | the site name of ARU employment, one of the 21 sites                                                                     |
| location        | value being 1 or 2. The first or the second location of ARU within each site                                             |
| aru_id          | a 4 digits number. Unique ID of each ARU unit                                                                            |
| type            | “Mini” or “BAR-LT”                                                                                                       |
| date            | the date of detection, with the format yyyymmdd                                                                          |
| hour            | the hour of detection                                                                                                    |
| start           | within a specific recording, where is the start time of the detection                                                    |
| end             | within a specific recording, where is the end time of the detection                                                      |
| scientific_name | scientific name of the detected species                                                                                  |
| common_name     | common name of the detected species                                                                                      |
| confidence      | confidence value for the detection provided by BirdNET. Higher confidence corresponded to higher probability of presence |
| filepath        | file path of the original recording file                                                                                 |

## Processing schedule & Output

- [Working notes](./docs/working-notes.md)
- Full list of BirdNET output files can be found for [All
  Species](./data/cleaned/all) and [Focal Species](./data/cleaned/focal)

<table style="width:97%;">
<colgroup>
<col style="width: 9%" />
<col style="width: 4%" />
<col style="width: 3%" />
<col style="width: 3%" />
<col style="width: 3%" />
<col style="width: 8%" />
<col style="width: 26%" />
<col style="width: 27%" />
<col style="width: 9%" />
</colgroup>
<thead>
<tr class="header">
<th>Site</th>
<th>Location</th>
<th>ARU ID</th>
<th>Type</th>
<th>Date</th>
<th>Time</th>
<th>Output (all)</th>
<th>Output (focal)</th>
<th>Note</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Axe Lake</td>
<td>1</td>
<td>9126</td>
<td>BAR-LT</td>
<td>Dec.04</td>
<td>17:10 - 20:46</td>
<td><a href="./data/cleaned/all/AxeLake_1_9126_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/AxeLake_1_9126_BARLT.csv">file</a></td>
<td>3.5 hr</td>
</tr>
<tr class="even">
<td>Axe Lake</td>
<td>2</td>
<td>7859</td>
<td>Mini</td>
<td>Dec.04</td>
<td>21:20 - 22:30</td>
<td><a href="./data/cleaned/all/AxeLake_2_7859_Mini.csv">file</a></td>
<td><a href="./data/cleaned/focal/AxeLake_2_7859_Mini.csv">file</a></td>
<td>1.5 hr</td>
</tr>
<tr class="odd">
<td>Baptiste Meadow</td>
<td>1</td>
<td>9742</td>
<td>BAR-LT</td>
<td>Dec.06</td>
<td>10:19 - 12:32</td>
<td><a
href="./data/cleaned/all/BaptisteMeadow_1_9742_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/BaptisteMeadow_1_9742_BARLT.csv">file</a></td>
<td>2 hr</td>
</tr>
<tr class="even">
<td>Baptiste Meadow</td>
<td>2</td>
<td>9441</td>
<td>BAR-LT</td>
<td>Dec.04</td>
<td>22:40 - 9:00 (+1)</td>
<td><a
href="./data/cleaned/all/BaptisteMeadow_2_9441_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/BaptisteMeadow_2_9441_BARLT.csv">file</a></td>
<td></td>
</tr>
<tr class="odd">
<td>Big Creek Control</td>
<td>1</td>
<td>9089</td>
<td>BAR-LT</td>
<td>Dec.06</td>
<td>13:08 - 14:46</td>
<td><a
href="./data/cleaned/all/BigCreekControl_1_9089_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/BigCreekControl_1_9089_BARLT.csv">file</a></td>
<td>1.5 hr</td>
</tr>
<tr class="even">
<td>Big Creek Control</td>
<td>2</td>
<td>9515</td>
<td>BAR-LT</td>
<td>Dec.08</td>
<td><p>10:20 -</p>
<p>11:52</p></td>
<td><a
href="./data/cleaned/all/BigCreekControl_2_9515_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/BigCreekControl_2_9515_BARLT.csv">file</a></td>
<td>1.5 hr</td>
</tr>
<tr class="odd">
<td>Burnson Lake</td>
<td>1</td>
<td>7915</td>
<td>Mini</td>
<td>Dec.06</td>
<td>14:58 - 16:20</td>
<td><a
href="./data/cleaned/all/BurnsonLake_1_7915_Mini.csv">file</a></td>
<td><a
href="./data/cleaned/focal/BurnsonLake_1_7915_Mini.csv">file</a></td>
<td>1.5 hr</td>
</tr>
<tr class="even">
<td>Burnson Lake</td>
<td>2</td>
<td>9214</td>
<td>BAR-LT</td>
<td>Dec.06</td>
<td>16:20 - 18:10</td>
<td><a
href="./data/cleaned/all/BurnsonLake_2_9214_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/BurnsonLake_2_9214_BARLT.csv">file</a></td>
<td>2 hr</td>
</tr>
<tr class="odd">
<td>Chilco Ranch</td>
<td>1</td>
<td>9807</td>
<td>BAR-LT</td>
<td>Dec.08</td>
<td>19:09 - 20:36</td>
<td><a
href="./data/cleaned/all/ChilcoRanch_1_9807_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/ChilcoRanch_1_9807_BARLT.csv">file</a></td>
<td>Run in batch (below)</td>
</tr>
<tr class="even">
<td>Chilco Ranch</td>
<td>2</td>
<td>9603</td>
<td>BAR-LT</td>
<td>Dec.08</td>
<td>17:41 - 19:08</td>
<td><a
href="./data/cleaned/all/ChilcoRanch_2_9603_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/ChilcoRanch_2_9603_BARLT.csv">file</a></td>
<td></td>
</tr>
<tr class="odd">
<td>Colpitt Lake</td>
<td>1</td>
<td>8792</td>
<td>BAR-LT</td>
<td>Dec.08</td>
<td>21:57 - 23:50</td>
<td><a
href="./data/cleaned/all/ColpittLake_1_8792_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/ColpittLake_1_8792_BARLT.csv">file</a></td>
<td></td>
</tr>
<tr class="even">
<td>Colpitt Lake</td>
<td>2</td>
<td>7255</td>
<td>Mini</td>
<td>Dec.08</td>
<td>20:46 - 21:57</td>
<td><a
href="./data/cleaned/all/ColpittLake_2_7255_Mini.csv">file</a></td>
<td><a
href="./data/cleaned/focal/ColpittLake_2_7255_Mini.csv">file</a></td>
<td></td>
</tr>
<tr class="odd">
<td>Dog Creek Road</td>
<td>1</td>
<td>9029</td>
<td>BAR-LT</td>
<td>Dec.09</td>
<td>00:34 - 02:35</td>
<td><a
href="./data/cleaned/all/DogCreekRoad_1_9029_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/DogCreekRoad_1_9029_BARLT.csv">file</a></td>
<td></td>
</tr>
<tr class="even">
<td>Dog Creek Road</td>
<td>2</td>
<td>7245</td>
<td>Mini</td>
<td>Dec.08</td>
<td>11:56 - 00:34 (+1)</td>
<td><a
href="./data/cleaned/all/DogCreekRoad_2_7245_Mini.csv">file</a></td>
<td><a
href="./data/cleaned/focal/DogCreekRoad_2_7245_Mini.csv">file</a></td>
<td></td>
</tr>
<tr class="odd">
<td>Enterprise Road</td>
<td>1</td>
<td>9270</td>
<td>BAR-LT</td>
<td>Dec.09</td>
<td>2:36 - 4:36</td>
<td><a
href="./data/cleaned/all/EnterpriseRoad_1_9270_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/EnterpriseRoad_1_9270_BARLT.csv">file</a></td>
<td>Location was NA</td>
</tr>
<tr class="even">
<td>Fiftynine Creek</td>
<td>1</td>
<td>9782</td>
<td>BAR-LT</td>
<td>Dec.09</td>
<td>6:52 - 9:05</td>
<td><a
href="./data/cleaned/all/FiftynineCreek_1_9782_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/FiftynineCreek_1_9782_BARLT.csv">file</a></td>
<td></td>
</tr>
<tr class="odd">
<td>Fiftynine Creek</td>
<td>2</td>
<td>8990</td>
<td>BAR-LT</td>
<td>Dec.09</td>
<td>4:37 - 6:51</td>
<td><a
href="./data/cleaned/all/FiftynineCreek_2_8990_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/FiftynineCreek_2_8990_BARLT.csv">file</a></td>
<td></td>
</tr>
<tr class="even">
<td>Helena Conservation</td>
<td>1</td>
<td>9235</td>
<td>BAR-LT</td>
<td>Dec.11</td>
<td>14:03 - 16:24</td>
<td><a
href="./data/cleaned/all/HelenaConservation_1_9235_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/HelenaConservation_1_9235_BARLT.csv">file</a></td>
<td>Run in batch (below)</td>
</tr>
<tr class="odd">
<td>Helena Conservation</td>
<td>2</td>
<td>9140</td>
<td>BAR-LT</td>
<td>Dec.11</td>
<td>11:16 - 14:02</td>
<td><a
href="./data/cleaned/all/HelenaConservation_2_9140_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/HelenaConservation_2_9140_BARLT.csv">file</a></td>
<td></td>
</tr>
<tr class="even">
<td>Helena Lake</td>
<td>1</td>
<td>9621</td>
<td>BAR-LT</td>
<td>Dec.11</td>
<td>18:42 - 20:51</td>
<td><a
href="./data/cleaned/all/HelenaLake_1_9621_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/HelenaLake_1_9621_BARLT.csv">file</a></td>
<td></td>
</tr>
<tr class="odd">
<td>Helena Lake</td>
<td>2</td>
<td>8923</td>
<td>BAR-LT</td>
<td>Dec.11</td>
<td>16:25 - 18:41</td>
<td><a
href="./data/cleaned/all/HelenaLake_2_8923_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/HelenaLake_2_8923_BARLT.csv">file</a></td>
<td></td>
</tr>
<tr class="even">
<td>Lilypad Lake</td>
<td>1</td>
<td>8860</td>
<td>BAR-LT</td>
<td>Dec.11</td>
<td>22:18 - 00:20 (+1)</td>
<td><a
href="./data/cleaned/all/LilypadLake_1_8860_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/LilypadLake_1_8860_BARLT.csv">file</a></td>
<td></td>
</tr>
<tr class="odd">
<td>Lilypad Lake</td>
<td>2</td>
<td>7836</td>
<td>Mini</td>
<td>Dec.11</td>
<td>21:02 - 22:08</td>
<td><a
href="./data/cleaned/all/LilypadLake_2_7836_Mini.csv">file</a></td>
<td><a
href="./data/cleaned/focal/LilypadLake_2_7836_Mini.csv">file</a></td>
<td></td>
</tr>
<tr class="even">
<td>Murphy Lake</td>
<td>1</td>
<td>6663</td>
<td>Mini</td>
<td>Dec.12</td>
<td>00:32 - 1:53</td>
<td><a
href="./data/cleaned/all/MurphyLake_1_6663_Mini.csv">file</a></td>
<td><a
href="./data/cleaned/focal/MurphyLake_1_6663_Mini.csv">file</a></td>
<td></td>
</tr>
<tr class="odd">
<td>Murphy Lake</td>
<td>2</td>
<td>7710</td>
<td>Mini</td>
<td>Dec.12</td>
<td>2:04 - 3:25</td>
<td><a
href="./data/cleaned/all/MurphyLake_2_7710_Mini.csv">file</a></td>
<td><a
href="./data/cleaned/focal/MurphyLake_2_7710_Mini.csv">file</a></td>
<td></td>
</tr>
<tr class="even">
<td>Pete Kitchen Lake</td>
<td>1</td>
<td>9058</td>
<td>NA</td>
<td>NA</td>
<td>NA</td>
<td>NA</td>
<td>NA</td>
<td>empty folder</td>
</tr>
<tr class="odd">
<td>Pete Kitchen Lake</td>
<td>2</td>
<td>9205</td>
<td>BAR-LT</td>
<td>Dec.12</td>
<td>3:25 - 5:28</td>
<td><a
href="./data/cleaned/all/PeteKitchenLake_2_9205_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/PeteKitchenLake_2_9205_BARLT.csv">file</a></td>
<td></td>
</tr>
<tr class="even">
<td>Tatton Lake</td>
<td>1</td>
<td>6705</td>
<td>Mini</td>
<td>Dec.12</td>
<td>11:11 - 12:40</td>
<td><a
href="./data/cleaned/all/TattonLake_1_6705_Mini.csv">file</a></td>
<td><a
href="./data/cleaned/focal/TattonLake_1_6705_Mini.csv">file</a></td>
<td>Run in batch (below)</td>
</tr>
<tr class="odd">
<td>Tatton Lake</td>
<td>2</td>
<td>9633</td>
<td>BAR-LT</td>
<td>Dec.12</td>
<td>12:41 - 15:08</td>
<td><a
href="./data/cleaned/all/TattonLake_2_9633_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/TattonLake_2_9633_BARLT.csv">file</a></td>
<td></td>
</tr>
<tr class="even">
<td>Thaddus Lake</td>
<td>1</td>
<td>9584</td>
<td>BAR-LT</td>
<td>Dec.12</td>
<td>16:56 - 19:28</td>
<td><a href="./data/cleaned/all/Thaddus_1_9584_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/Thaddus_1_9584_BARLT.csv">file</a></td>
<td></td>
</tr>
<tr class="odd">
<td>Thaddus Lake</td>
<td>2</td>
<td>5976</td>
<td>Mini</td>
<td>Dec.12</td>
<td>15:21 - 16:56</td>
<td><a href="./data/cleaned/all/Thaddus_2_5976_Mini.csv">file</a></td>
<td><a href="./data/cleaned/focal/Thaddus_2_5976_Mini.csv">file</a></td>
<td></td>
</tr>
<tr class="even">
<td>Watson Creek</td>
<td>1</td>
<td>9157</td>
<td>BAR-LT</td>
<td>Dec.12</td>
<td>21:06 - 23:28</td>
<td><a
href="./data/cleaned/all/WatsonCreek_1_9157_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/WatsonCreek_1_9157_BARLT.csv">file</a></td>
<td></td>
</tr>
<tr class="odd">
<td>Watson Creek</td>
<td>2</td>
<td>7759</td>
<td>Mini</td>
<td>Dec.12</td>
<td>19:40 - 21:07</td>
<td><a
href="./data/cleaned/all/WatsonCreek_2_7759_Mini.csv">file</a></td>
<td><a
href="./data/cleaned/focal/WatsonCreek_2_7759_Mini.csv">file</a></td>
<td></td>
</tr>
<tr class="even">
<td>Wildhorse Meadow</td>
<td>1</td>
<td>9072</td>
<td>BAR-LT</td>
<td>Dec.12</td>
<td>23:29 - 1:50 (+1)</td>
<td><a
href="./data/cleaned/all/WildhorseMeadow_1_9072_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/WildhorseMeadow_1_9072_BARLT.csv">file</a></td>
<td></td>
</tr>
<tr class="odd">
<td>Wildhorse Meadow</td>
<td>2</td>
<td>9799</td>
<td>BAR-LT</td>
<td>Dec.13</td>
<td>1:50 - 4:10</td>
<td><a
href="./data/cleaned/all/WildhorseMeadow_2_9799_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/WildhorseMeadow_2_9799_BARLT.csv">file</a></td>
<td></td>
</tr>
<tr class="even">
<td>Winthrow Creek</td>
<td>1</td>
<td>9065</td>
<td>BAR-LT</td>
<td>Dec.13</td>
<td>4:11 - 6:31</td>
<td><a
href="./data/cleaned/all/WinthrowCreek_1_9065_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/WinthrowCreek_1_9065_BARLT.csv">file</a></td>
<td></td>
</tr>
<tr class="odd">
<td>Winthrow Creek</td>
<td>2</td>
<td>9171</td>
<td>BAR-LT</td>
<td>Dec.13</td>
<td>6:31 - 8:53</td>
<td><a
href="./data/cleaned/all/WinthrowCreek_2_9171_BARLT.csv">file</a></td>
<td><a
href="./data/cleaned/focal/WinthrowCreek_2_9171_BARLT.csv">file</a></td>
<td></td>
</tr>
</tbody>
</table>
