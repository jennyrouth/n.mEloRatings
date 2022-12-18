
loader = function(filename, repo=''){
  # stitching together the repo name with filename (a csv of pairwise comparisons)
  filepath <- file.path(repo, filename)

  # loading csv into dataframe
  df_pw <- read.csv(filepath)

  return (df_pw)
}
