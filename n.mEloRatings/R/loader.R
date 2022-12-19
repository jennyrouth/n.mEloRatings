#' Loader function
#' @description Loads the .csv file containing the pairwise comparison data. This file should contain the following columns:
#'
#' `ResponseId` - a unique identifier for each questionnaire participant,
#'
#' `Q` - the question number from the bank of all possible questions (as opposed to the question order presented to each participant),
#'
#' `A.Code` - the first item offered in the pairwise comparison,
#'
#' `B.Code`- the second item offered in the pairwise comparison,
#'
#' `Winner` - the item selected by the participant,
#'
#' `Loser` - the item NOT selected by the participant.
#'
#' A single row for every pairwise comparison performed by every participant.
#'
#' @param filename The name of the .csv file, or the entire .csv file path name.
#' @param repo The folder in which the .csv file is stored. Defaults to blank.
#'
#' @return Returns a dataframe to be used in the Elo/mElo/norm_mElo functions
#' @export
#'
#' @examples loader('/Users/example_user/example_file_path/example_dataset.csv')
#' @examples loader(example_dataset.csv, repo='/Users/example_user/example_file_path')
#' @examples loader('C:\Documents\example_file_path\example_dataset.csv')
#' @examples loader(example_dataset.csv, repo='C:\Documents\example_file_path')

loader = function(filename, repo=''){
  # stitching together the repo name with filename (a csv of pairwise comparisons)
  filepath <- file.path(repo, filename)

  # loading csv into dataframe
  df_pw <- read.csv(filepath)

  return (df_pw)
}
