# library(tidyverse)
# library(ggrepel)


#Data (scraped 5/10/25)
IWdata <- read_csv("C:/Users/ryano/OneDrive/Documents/ZWR Speedrun Project/Raw Data/zwr_combined_leaderboard.csv", #PUB C:/.../name.csv
col_types = cols(Time = col_character()))

#Remove date suffixes
IWdata$Date <- gsub("(\\d+)(st|nd|rd|th)", "\\1", IWdata$Date)

# Convert date from character to date format
IWdata$Date <- as.Date(IWdata$Date, format = "%d, %B %Y")


#Fixing time (MM:SS is initially read as HH:MM:SS, where MM=HH and SS=MM --> MM:SS:00)
IWdata <- IWdata %>%
  mutate(
    Time_chr = as.character(Time),
    Time_parts = strsplit(Time_chr, ":", fixed = TRUE),
    Time_secs = sapply(Time_parts, function(tp) {
      if (length(tp) == 2 && all(grepl("^[0-9]+$", tp))) {
        as.numeric(tp[1]) * 60 + as.numeric(tp[2])
      } else {
        NA_real_
      }
    }),
    Time_MMSS = ifelse(!is.na(Time_secs),
                       sprintf("%02d:%02d", Time_secs %/% 60, Time_secs %% 60),
                       NA_character_)
  ) %>%
  select(-Time, -Time_chr, -Time_parts, -Time_secs) %>%
  rename(Time = Time_MMSS)

#Time in seconds for plotting
IWdata$Time_seconds <- sapply(strsplit(IWdata$Time, ":"), function(tp) {
  as.numeric(tp[1]) * 60 + as.numeric(tp[2])
})


#Labels 
label_data1 <- IWdata %>%
  filter(Map == "Spaceland", Player == "Bab", Time == "13:38") %>%
  mutate(Label = "Bab\n13:38")
label_data2 <- IWdata %>%
  filter(Map == "Rave", Player == "Pinkhalfmoon", Time == "17:29")  %>%
  mutate(Label = "Pinkhalfmoon\n17:29")
label_data3 <- IWdata %>%
  filter(Map == "Shaolin", Player == "MenBot115", Time == "21:16") %>%
  mutate(Label = "MenBot115\n21:16")
label_data4 <- IWdata %>%
  filter(Map == "Attack", Player == "sixkzz", Time == "13:39") %>%
  mutate(Label = "sixkzz\n13:39")
label_data5 <- IWdata %>%
  filter(Map == "Beast", Player == "Rorek1", Time == "11:21") %>%
  mutate(Label = "Rorek1\n11:21")


#Change legend order (remember to adjust scale_color_manual)
IWdata$Map <- factor(IWdata$Map, levels = c("Spaceland", "Rave", "Shaolin", "Attack", "Beast"))

#Plot
ggplot(IWdata, aes(x=Date, y=Time_seconds, color=Map)) +
  labs(x = "", y = "Time",
       caption = "*Doesn't account for runs not submitted, runs taken down, or different upload dates") + #Footnote
  geom_point(size=4, 
             stroke=0, #edge of the circles?
             alpha = 0.3) + #transparency
  geom_text_repel( #Bab label
    data = label_data1,
    aes(x = Date, y = Time_seconds, label = Label),
    nudge_y = 30,
    nudge_x = -140,
    segment.color = "gray40",
    size = 3.5,
    box.padding = 0.5,
    max.overlaps = Inf,
    show.legend = FALSE) +
  geom_text_repel( #Pinkhalfmoon label
    data = label_data2,
    aes(label = Label),
    nudge_y = 300,
    nudge_x = -150,
    segment.color = "gray40",
    size = 3.5,
    box.padding = 0.5,
    max.overlaps = Inf,
    show.legend = FALSE) +
  geom_text_repel( #MenBot115 label
    data = label_data3,
    aes(label = Label),
    nudge_y = 10,
    nudge_x = -200,
    segment.color = "gray40",
    size = 3.5,
    box.padding = 0.5,
    max.overlaps = Inf,
    show.legend = FALSE) +
  geom_text_repel( #sixkzz label
    data = label_data4,
    aes(label = Label),
    nudge_y = -80,
    nudge_x = -100,
    segment.color = "gray40",
    size = 3.5,
    box.padding = 0.5,
    max.overlaps = Inf,
    show.legend = FALSE) +
  geom_text_repel( #Rorek1 label
    data = label_data5,
    aes(label = Label),
    nudge_y = -60,
    nudge_x = -170,
    segment.color = "gray40",
    size = 3.5,
    box.padding = 0.5,
    max.overlaps = Inf,
    show.legend = FALSE) +  
  scale_color_manual(values = c('purple', 'red', 'orange', 'green', 'blue')) + #Color each map (order from data$Map)
  scale_y_continuous( #y-axis ticks
    limits = c(600, 2880),
    breaks = seq(600, 2880, by = 120),  # 10:00 to 48:00 in seconds
    labels = function(x) sprintf("%02d:%02d", x %/% 60, x %% 60), #ticks in MM:SS
    expand=c(0,0)) + #expand prevents the plot from expanding/showing the plot greater than limits set
  ggtitle("IW DCUT F&F Speedrun Records") +
  theme(plot.title = element_text(hjust = 0.5), #centering title
        # panel.background = element_rect(fill = 'white'),
        # panel.grid.major = element_line(color = "black"),
        legend.key = element_blank())          # Remove legend key background color
  # annotate("text", x = 4, y = 25, label = "Some text")
# 

#EXPORT: PDF (9.01 x 6.65), landscape. Screenshot(snip) it for discord sharing