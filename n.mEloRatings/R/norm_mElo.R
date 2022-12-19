#' Calculating normalised mean Elo ratings using min-max normalization.
#'
#' @description Min-max normalisation is a linear mathematical transformation which was performed on the original mElo ratings to generate ratings that ranged from zero to one (n.mElo ratings).  See: https://doi.org/10.1016/B978-0-12-381479-1.00003-4
#' @param df_melo A dataframe containing mElo ratings (colname: mEloRating)
#'
#' @return Returns a dataframe containing mElo and n.mElo ratings
#' @export
#'
#' @examples norm_melo(df_melo)
# Calculating normalised mean Elo using min-max normalization
norm_melo = function(df_melo){

  # calculating components required for min-max normalization to mean Elo ratings
  min.mElo = min(df_melo$mEloRating)
  max.mElo = max(df_melo$mEloRating)
  denom = max.mElo - min.mElo

  # applying min-max normalization
  df_melo$n.mEloRating <- (df_melo$mEloRating - min.mElo) / denom

  return (df_melo)

}
