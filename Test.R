#MAIN RESULT IS Scrape.R !!!





#IWdata <- read_csv("C:/Users/ryano/OneDrive/Documents/IW Speedrun Data/Raw Data/IWsr.csv") #NOTE PATH NOT UPDATED
#Run individually only when data changes?

#Convert time to seconds (Also changed ggplot: y=Time)
# sec <- data %>% 
#   pull(Time) %>%  #extract a single column from a data frame
#   hms() %>%  #accepts data as numeric vector
#   as.numeric()  #convert character vectors to numeric vectors

# # Convert Time to hms object
# IWdata$Time <- as_hms(IWdata$Time)

#Manipulate time object
#df$Time <- as.POSIXct(strptime(df$Time, format="%H:%M:%S"))

# Format y-axis as MM:SS
time_formatter <- function(x) {
  sprintf("%02d:%02d", hour(x)*60 + minute(x), second(x))
}

#Change legend order (edit whenever there's a new Map added)
IWdata$Map <- factor(IWdata$Map, levels = c("Spaceland", "Rave", "Attack"))

ggplot(IWdata, aes(x=Date, y=Time, color=Map)) +
  labs(x = "", y = "Time") +
  geom_point(shape=21, size=5, stroke=3) +
  scale_color_manual(values = c('blue', 'red', 'black')) +  #Color each map (order from data$Map) SS or, B blue
  scale_y_time(labels = time_formatter)

  
  
    # scale_y_continuous(breaks = seq(800, 1500, by = 300))  #Different y axis scale & ticks
 # scale_y_continuous(breaks=c("00:14:00", "00:16:00", "00:18:00", "00:20:00"), #I think it has to = number of ticks
 #                labels=c("14:00", "16:00", "18:00", "20:00"))




# ggplot(IWdata = df, aes(x = time, y = Time)) + geom_point() +
#   scale_y_datetime(breaks = date_breaks("1 sec"), labels = date_format("%S"))
# 
# ggplot(IWdata = df, aes(x = time, y = Time)) + geom_point() +
#   scale_y_datetime(breaks = date_breaks("1 sec"), labels = date_format("%OS3"))
# 
# ggplot(IWdata = df, aes(x = time, y = Time)) + geom_point() +
#   scale_y_datetime(breaks = date_breaks("4 sec"), labels = date_format("%M:%S"))

# Base plot function. Doesn't work with ggplot2 (doesn't recognize the plot)
# axis(1, at= c(2022, 2023, 2024, 2025),
#      labels = c("test", "test", "test", "test"))

# scale_y_continuous(breaks=c("14:00:00", "16:00:00", "18:00:00", "20:00:00"),
#                  labels=c("14:00", "16:00", "18:00", "20:00"))

#Does this convert time into seconds for me? What will yaxis be?
# stopwatch_data <- stopwatch_data %>%
#   mutate(duration = as.numeric(difftime(end_time, start_time, units = "secs")))