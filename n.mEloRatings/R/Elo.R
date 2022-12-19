# Assigning initial ratings to items
initialise_scores = function(df_pw, initial_rating=0){

  # code list: we'll assign initial ratings to each code
  code_list = unique(c(unique(df_pw$A.Code), unique(df_pw$B.Code)))

  # the names of the list of ratings are the abbreviated code names
  scores = vector(mode="list", length=length(code_list))
  names(scores) = code_list

  # assigning initial ratings to codes
  for (i in 1:length(code_list)){
    scores[[i]] = initial_rating
  }

  return (scores)
}


#Expected outcome
#The expected probability of player 1 beating player 2, if player 1 has rating `r1` and player 2 has rating `r2`.
expected_win = function(r1, r2){
  return (1.0 / (1 + 10^( (r2-r1) / 400) ))
}


#Update rating using pairwise comparison outcome
elo_update = function(input_rating_winner, input_rating_loser, k=100){

  # calculating probabilities of winner and loser (pre-comparison)
  P_winner = expected_win(input_rating_winner, input_rating_loser)
  P_loser = expected_win(input_rating_loser, input_rating_winner)

  # updating the ratings
  output_rating_winner = input_rating_winner + (k * (1 - P_winner))
  output_rating_loser = input_rating_loser + (k * (0 - P_loser))

  # outputting the updated winner and loser ratings
  return (c(output_rating_winner, output_rating_loser))
}

#Elo sequence
#' Generating Elo ratings from pairwise comparison data
#'
#' @param df_pw The dataframe of pairwise comparison outcomes
#' @param initial_rating The initial rating of the items at the start of the rating calculations, defaults to 0
#' @param k k is a constant representing the maximum point exchange. The exact value of k effects the volatility of system, i.e., how quickly the ratings change with each pairwise comparison. As k increases, winners gain more points and losers lose more points, and the impact that a surprising result has is greater. If k is too low, the ratings won’t change meaningfully as more pairwise comparison data is entered into the system. If k is too high, the ratings won’t stabilise sufficiently. However, given a sufficient number of pairwise comparisons, k has been demonstrated to have a limited effect on eventual item rankings. k is usually set between 16 and 200, it defaults to 100.
#'
#' @return Returns a dataframe consisting of items' Elo ratings. The Elo ratings will vary slightly every time the Elo algorithm is run because the input order of the pairwise comparisons is randomised, and order matters. The ratings should form a stable ranking provided that 1) items are paired randomly, 2) there is sufficient variation in the items from the respondent’s perspectives and 3) there is a reasonable degree of shared perspectives among respondents in the group of study.
#' @export
#'
#' @examples elo(df_pw)
#' @examples elo(df_pw, initial_rating=100, k=20)

elo = function(df_pw, initial_rating=0, k=100){

  # initialising scores
  scores = initialise_scores(df_pw, initial_rating)

  # getting the number of rows
  num_pw = dim(df_pw)[1]

  # randomising the order of the pairwise comparision dataframe
  #set.seed(123)
  df_pw_rand = df_pw[sample(num_pw),c('ResponseId','Q','Winner','Loser')]

  # iterating through the pairwise comparisons
  for (i in 1:num_pw){

    # getting winner and loser codes for each row
    winner = df_pw_rand[i,'Winner']
    loser = df_pw_rand[i,'Loser']

    # getting ratings
    winner_rating = scores[winner][[1]]
    loser_rating = scores[loser][[1]]

    # performing the match (using the function we defined above)
    match = elo_update(winner_rating, loser_rating, k)

    # updating our scores for the winner and loser
    scores[winner] = match[1]
    scores[loser] = match[2]
  }

  df_elo = data.frame(unlist(scores))
  colnames(df_elo) = 'EloRating'

  return (df_elo)
}
