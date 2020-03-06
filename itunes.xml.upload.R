#http://dataislife.blogspot.com/2014/11/how-to-import-your-itunes-library-into-r.html

# work_dir_home <- "/Users/perkot/Dropbox/R Programming - Personal/git/itunes/"
# setwd(work_dir_home)

library(XML)
library(plyr)
library(dplyr)

#read in .xml file 
ituneslib <- readKeyValueDB("iTunes Library.xml")
#extract out large list called 'tracks', housing all song information 
tracksxml <- ituneslib$Tracks
#convert all 71 items in list into df
tracksxml1 <- lapply(tracksxml, data.frame)
#return as a dataframe 
songs <- ldply(tracksxml1)

#do all of this in one line of code
#songs <- ldply(lapply(readKeyValueDB("iTunes Library.xml")$Tracks, data.frame))

colnames(songs)
str(songs)

detach(package:plyr)

#Summarise by Artist
songs.artist <- songs %>% 
  group_by(Artist) %>% 
  summarise(Band.Listens = sum(Play.Count)) %>%
  arrange(desc(Band.Listens))

songs.album <- songs %>% 
  group_by(Album) %>% 
  summarise(Album.Listens = sum(Play.Count)) %>%
  arrange(desc(Album.Listens)) 

skip.artist <- songs %>% 
  group_by(Artist) %>% 
  summarise(Skips = sum(Skip.Count)) %>%
  arrange(desc(Skips)) 

genre <- songs %>% 
  group_by(Genre) %>% 
  summarise(Genre.listens = sum(Play.Count)) %>%
  arrange(desc(Genre.listens))