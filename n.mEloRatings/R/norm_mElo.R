
# calculating normalised mean Elo using min-max normalization
norm_melo = function(df_melo){

  # calculating components required for min-max normalization to mean Elo ratings
  min.mElo = min(df_melo$mEloRating)
  max.mElo = max(df_melo$mEloRating)
  denom = max.mElo - min.mElo

  # applying min-max normalization
  df_melo$n.mEloRating <- (df_melo$mEloRating - min.mElo) / denom

  return (df_melo)

}
