#install.packages("rvest")
#install.packages("dplyr")
#install.packages('xml2')
#install.packages("writexl")
library(xml2)
library(rvest)
library(writexl)
library(dplyr)
library(stringr)

crypto=data.frame()  # created an empty dataframe

# get_cast = function(movie_links)
# {
#   movie_page = read_html(movie_links)
#   movie_cast = movie_page %>% html_nodes(".primary_photo+ td a") %>% html_text() %>% paste(collapse=(","))
#   return(movie_cast)
#   
# }

for (i in seq(from=1, to=200, by=100)) {
  link1=paste0("https://www.coincarp.com/pn_", i,".html")
  print(link1)
  page=read_html(link1)
  
  link=read_html("https://www.coincarp.com/")
  
  Rank=link %>% html_nodes(".sorting_1") %>% html_text()
  Names=link %>% html_nodes(".fullname") %>% html_text()
  Symbol= link %>% html_nodes(".symbo") %>% html_text()
  Rank1=list()
  Symbol1=list()
  for (i in Symbol) {
    Rank=str_extract(i,"\\d+" )
    Rank1=append(Rank1, Rank)
    Crypto_Symbol=str_extract(i, "[A-Za-z]+")
    Symbol1=append(Symbol1, Crypto_Symbol)
  }
  print(Rank1)
  print(Symbol1)
  
  Price=link %>% html_nodes("td.td3") %>% html_text()
  one_day_change=link %>% html_nodes(".td4") %>% html_text()
  one_day_change
  one_week_change=link %>% html_nodes(".red , #flarenetworks .green , #kava .green , #xinfin .green , #paxgold .green , #iota .green , #bittorrent-new .green , #kcs .green , #stellar .green , #bitcoin-cash .green , #monero .green , #tron .green , #binanceusd .green , #tether .green") %>% html_text()
  marketcapital=link %>% html_nodes("th6") %>% html_text()
  volume=link %>% html_nodes(".volume") %>% html_text()
  circulation_supply=link %>% html_nodes(".td8 span") %>% html_text()
  total_volume=link %>% html_nodes(".vol-table span") %>% html_text()
  
  
  for (i in Names) {
    l1=paste0("https://www.coincarp.com/currencies/", i, "/")
    print(l1)
    each_name_link=read_html(l1)
    print(each_name_link)
    
  }
  
  
  Price= page %>% html_nodes(".lister-item-content")
  Price=sapply(Price, function(x){
    x %>%  html_nodes(".ratings-imdb-rating strong") %>% 
      html_text() %>% as.numeric()
  }) %>% sapply( function(x) ifelse(length(x) == 0, NA, x))
  
  synopsis= page %>% html_nodes(".lister-item-content")
  synopsis = sapply(synopsis, function(x){
    x %>%  html_nodes(".ratings-bar+ .text-muted") %>% 
      html_text() %>% as.character()
  }) %>% sapply( function(x) ifelse(length(x) == 0, NA, x))
  timing=page %>% html_nodes(".lister-item-content")
  timing=sapply(timing, function(x){
    x %>%  html_nodes(".runtime") %>% 
      html_text() %>% as.character()
  }) %>% sapply( function(x) ifelse(length(x) == 0, NA, x))
  
  movie_url=page %>% html_nodes(".lister-item-header a") %>% html_attr("href") %>% paste("https://www.imdb.com", ., sep="")
  votes=page %>% html_nodes(".lister-item-content")
  votes=sapply(votes, function(x){
    x %>%  html_nodes(".sort-num_votes-visible span:nth-child(2)") %>% 
      html_text() %>% as.character()
  }) %>% sapply( function(x) ifelse(length(x) == 0, NA, x))
  genre=page %>% html_nodes(".genre") %>% html_text()
  genre
  movies=rbind(movies, data.frame(titles, year, runtime=timing, votes, ratings, genre, synopsis, movie_url))
}
