##Interactive plot with plotly
#https://www.littlemissdata.com/blog/interactiveplots
install.packages("plotly")
install.packages("tidyverse")
install.packages("htmlwidgets")
library(plotly)
library(tidyverse)
library(htmlwidgets)



##delete the gifski library to delete the green flashes problem
library(gapminder)
library(ggplot2)
library(gapminder)
library(utf8)
install.packages("utf8")
install.packages("gapminder")
install.packages("gganimate")
library(gganimate)


ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, colour = country)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  facet_wrap(~continent) +
  # Here comes the gganimate specific bits
  labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) +
  ease_aes('linear')
