#mElo
#' Generating mean Elo ratings from pairwise comparison data
#'
#' @param df_pw The dataframe of pairwise comparison outcomes
#' @param melo_randomisations The mElo randomisation number (X) is the number of times that the Elo rating system is run. Each time the same pairwise comparison data is used, but the order in which the pairwise comparisons are entered into the system is randomised. It could be easier to think of this as X number of virtual sequences of the pairwise comparisons which are fed into the algorithm. This generates a set of X Elo ratings for each item. Each set will have a distribution of values due to the effect of sequence order, and the mean (mElo) rating is subsequently calculated. Defaults to 500.
#' @param initial_rating 	The initial rating of the items at the start of the rating calculations, defaults to 0
#' @param k k is a constant representing the maximum point exchange. The exact value of k effects the volatility of system, i.e., how quickly the ratings change with each pairwise comparison. As k increases, winners gain more points and losers lose more points, and the impact that a surprising result has is greater. If k is too low, the ratings won’t change meaningfully as more pairwise comparison data is entered into the system. If k is too high, the ratings won’t stabilise sufficiently. However, given a sufficient number of pairwise comparisons, k has been demonstrated to have a limited effect on eventual item rankings. k is usually set between 16 and 200, it defaults to 100.
#'
#' @return  Returns a dataframe consisting of items' mElo ratings. Note: the resultant mElo ratings could be slightly different every time the mElo algorithm is run due to the impact of randomising the input order of pairwise comparisons. However, provided `melo_randomisations` is sufficiently large (we have found 500 to be sufficient - see Supplementary Item 2 10.35542/osf.io/e34r2), the *ranks* of the items should not change.
#' @export
#'
#' @examples melo(df_pw, melo_randomisations=20, initial_rating=100, k=20)
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
