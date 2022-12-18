#mElo
melo = function(df_pw, melo_randomisations=500, initial_rating=0, k=100){

  # initialising a list of elo dataframes
  elo_list = 0

  # iterating through the mean elo (mElo) iterations
  for (i in 1:melo_randomisations){

    # producing a single iteration of the elo scores
    df_elo_i = elo(df_pw, initial_rating, k)

    # one-off extraction to pull out the index / code names
    if (i == 1){
      indices = rownames(df_elo_i)
    }

    # appending the elo scores to elo list
    elo_list[i] = df_elo_i
  }

  # binding each elo iteration together
  df_elo = data.frame(do.call('rbind', elo_list))
  colnames(df_elo) = indices

  # calculating mElo by taking the mean of each column
  df_melo = data.frame(apply(X = df_elo, MARGIN = 2, FUN = mean))
  df_melo$Code = rownames(df_melo)
  colnames(df_melo) = c('mEloRating','Code')

  # and finally ordering by melo rating
  df_melo = df_melo[order(-df_melo$mElo),]
  rownames(df_melo) = NULL

  return (df_melo)
}
