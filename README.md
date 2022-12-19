# n.mEloRatings

Functions to calculate Elo, mean Elo (mElo) and normalised mean Elo (n.mElo) ratings from pairwise comparisons.

## Introduction
The `n.mElo package` allows you to generate ratings and rankings of a set of items using the Elo rating system. The package uses binary pairwise comparison (winner/loser) data about the items. This is usually collected using a survey. See https://doi.org/10.35542/osf.io/e34r2.

Although the functions (Elo, mElo and n.mElo) are written from scratch, the concept of mElo is informed by Clark et al (2018): 10.1371/journal.pone.0190393

mElo ratings can also be generated using their 'EloChoice' R package: https://cran.r-project.org/web/packages/EloChoice/index.html

## Instructions for use

### 1. Getting the data: binary pairwise comparison data

This package assumes that you are able to import your survey data into RStudio and convert it to a dataframe.
The dataframe should be in the following format:
* Your survey data should be stored in a dataframe consisting of a row for each pairwise comparison response (every single instance that a respondent has completed a pairwise comparison). For example, if there are 100 survey respondents each performing 50 pairwise comparisons then there should be 5000 rows in the data frame.
* There should be six columns which consist of 1) a respondent identifier (column name: `ResponseId`) - who performed the comparison?, 2) the question number from the bank of questions (column name: `Q`), 3) the first item offered in the pairwise comparison (column name: `A.Code`), 4) the second item offered in the pairwise comparison (column name: `B.Code`), 5) the item that was selected by the respondent (column name: `Winner`) and 6) the item that was not selected by the respondent (column name: `Loser`).

An example data set is provided. This contains the outcomes from a questionnaire designed to rate 91 food items in terms of preference. There are 4095 unique pairs that can be produced with 91 items. 113 questionnaire participants performed 50 randomly allocated pairwise comparisons each. Therefore, there are 5650 rows in the data frame (one per response). The `ResponseId` column contains a unique identifier for each questionnaire participant, there will be 113 unique entries in this column. The `Q` column corresponds to the question number from the bank (maximum = 4095). Notice that some questions are asked more than once. `A.Code` is the first food item offered in the pairwise comparison and `B.Code` is the second, the `Winner` is the item selected as preferred, the `Loser` is the other item. 

### 2. Running the Elo rating system

#### 2.1 Example code to load data via `loader.r`:

```R
df_pw <- loader('example_dataset.csv')
```

The dataframe will look like this:

|`ResponseId`|`Q`|`A.Code`|`B.Code`|`Winner`|`Loser`|
|---|---|---|---|---|---|
|R_22G1pn30ere3rAm|1|Melon|Milk chocolate|Melon|Milk chocolate|
|R_2D5hdzKSoMrJ9ik| 2|     Prawns|      Croissant| Croissant|         Prawns|
|R_24IAat95tz832LX| 3|     Nachos|          Steak|     Steak|         Nachos|
|R_3CJEOmprJg9Qngp| 3|     Nachos|          Steak|     Steak|         Nachos|
|R_1Cj8aNlBXSWK7X8| 3|     Nachos|          Steak|     Steak|         Nachos|
|R_1eXhwYOBWSP0WwH| 4| Boiled egg|       Brownies|  Brownies|     Boiled egg|

#### 2.2 Example code to produce dataframe containing Elo ratings from pairwise comparisons

```R
elo(df_pw)
```
The same Elo ratings should be produced every time the algorithm is run.

#### 2.3 Example code to produce dataframe containing mean Elo (`mElo`) ratings from pairwise comparisons

Here, we use the default values of `melo_randomisations` of `500`, with `initial_rating`s set to `0`, and the `k` factor set to `100`.

```R
melo(df_pw, melo_randomisations = 500, initial_rating = 0, k = 100)
```

This will produce a dataframe of mElo ratings:

|`mEloRating`|                  `Code`|
|---|---|
|387.773180|        Milk chocolate |
|267.096594|  Victoria sponge cake |
|254.239456|             Ice cream|
|244.362544| Chocolate chip muffin |
|217.188779|                 Pasta|

The resultant mElo ratings could be slightly different every time the mElo algorithm is run due to the impact of randomising the input order of pairwise comparisons. However, provided `melo_randomisations` is sufficiently large (we have found 500 to be sufficient - see Supplementary Item 2 10.35542/osf.io/e34r2), the *ranks* of the items should not change.

#### 2.4 Example code to produce dataframe containing Normalised Mean Elo (`n.mElo`) ratings from the mElo dataframe

```R
norm_melo(df_melo)
```

This will produce normalised mElo ratings using **min-max** normalisation:

|`mEloRating`|                  `Code`| `n.mEloRating`|
|---|---|---|
|387.773180|        Milk chocolate | 1.000000000|
|267.096594|  Victoria sponge cake | 0.849607664|
|254.239456|             Ice cream|  0.833584547|
|244.362544| Chocolate chip muffin | 0.821275517|
|217.188779|                 Pasta|  0.787410405|




