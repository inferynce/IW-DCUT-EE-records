#MAIN RESULT IS Scrape.R !!!

#TO DO LIST
# Add rest of data 
# Consider filling the circles (geom_point no shape argument)
# Add color (see IW arrows). I could do diff shapes for maps
# Add corresponding legend. Get rid of dark square around circle
# Add labels to some (runner name)
# Change y axis to get rid of exta :00

#IWdata <- read_csv("C:/Users/ryano/OneDrive/Documents/IW Speedrun Data/Raw Data/IWsr.csv") #NOTE PATH NOT UPDATED
#Run individually only when data changes?

# Format y-axis as MM:SS
time_formatter <- function(x) {
  sprintf("%02d:%02d", hour(x)*60 + minute(x), second(x))
}

#Change legend order (edit whenever there's a new Map added and adjust scale_color_manual)
IWdata$Map <- factor(IWdata$Map, levels = c("Spaceland", "Rave", "Attack"))

ggplot(IWdata, aes(x=Date, y=Time, color=Map)) +
  labs(x = "", y = "Time") +
  geom_point(size=5, 
             stroke=0, #edge of the circles?
             alpha = 0.3) + #transparency
  scale_color_manual(values = c('purple', 'red', 'green')) + #Color each map (order from data$Map) SS or, B blue
  scale_y_time(labels = time_formatter) +
  ggtitle("IW DCUT F&F Speedrun Records") +
  theme(plot.title = element_text(hjust = 0.5), #centering title
  panel.background = element_rect(fill = '#CCC', color = 'black'))  #background color
  # annotate('text', x = 2022, y = 18:00, label = 'C')


#scale_y_continuous(breaks = seq(800, 1500, by = 300)) + #Different y axis scale & ticks
  