
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
