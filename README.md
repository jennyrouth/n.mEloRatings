# n.mEloRatings

Functions to calculate Elo, Mean Elo (mElo) and Normalised Mean Elo (n.mElo) ratings from pairwise comparisons.

## Introduction
The `n.mElo package` allows you to generate ratings and rankings of a set of items using the Elo rating system. The package uses binary pairwise comparison (winner/loser) data about the items. This is usually collected using a survey. See preprint.

## Instructions for use

### 1. Getting the data: binary pairwise comparison data

This package assumes that you are able to import your survey data into RStudio and rearrange it into the following format:
* Your survey data should be stored in a dataframe consisting of a row for each pairwise comparison response (every single instance that a respondent has completed a pairwise comparison). For example, if there are 100 survey respondents each performing 50 pairwise comparisons then there should be 5000 rows in the data frame.
* There should be five columns which consist of 1) the first option/item offered in the pairwise comparison (column name: `A.Code`), 2) the second option/item offered in the pairwise comparison (column name: `B.Code`), 3) the option/item that was selected by the respondent (column name: `Winner`), 4) the option/item that was not selected by the respondent (column name: `Loser`) and 5) a respondent identifier (column name: `ResponseId`).

An example data set is provided. This contains the outcomes from a questionnaire designed to rate 91 food items in terms of preference. There are 4095 unique pairs that can be produced with 91 items. 113 questionnaire participants performed 50 randomly allocated pairwise comparisons each. Therefore, there are 5650 rows in the data frame (one per response). The `ResponseId` column contains a unique identifier for each questionnaire participant, there will be 113 unique entries in this column. There is an additional `Q` column which corresponds to the question number from the bank (maximum = 4095). Notice that some questions are asked more than once. `A.Code` is the first food item offered in the pairwise comparison and `B.Code` is the second, the `Winner` is the item selected as preferred, the `Loser` is the other item. 

### 2. Running the Elo rating system

#### 2.1 Example code to load data via `loader.r`:

```R
df_pw <- loader('example_dataset.csv')
```

The dataframe will look like this:

|`ResponseId`|`Q`|`A.Code`|`B.Code`|`Winner`|`Loser`|
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


