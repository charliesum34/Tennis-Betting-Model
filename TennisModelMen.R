#tennis model men



packages <- c("tidyverse", "elo", "formattable", "lubridate", "showtext")
install.packages(setdiff(packages, rownames(installed.packages())))

library(tidyverse)
library(formattable)
library(elo)
library(lubridate)
library(showtext)


setwd("C:\\Users\\Cgh\\Documents\\betting")
match_results_2022 <- read.csv("Tennis2022Men.csv")
match_results_2023 <- read.csv("Tennis2023Men.csv")
match_results_2024 <- read.csv("Tennis2024Men.csv")

match_results <- rbind(match_results_2022, match_results_2023, match_results_2024)
View(match_results)


match_results <- match_results %>% filter(Comment == "Completed")

match_results_wrangled <- match_results %>%
  mutate(
    
    Wgames = coalesce(as.numeric(W1), 0) + coalesce(as.numeric(W2), 0) + coalesce(as.numeric(W3), 0) + coalesce(as.numeric(W4), 0) + coalesce(as.numeric(W5), 0),
    Lgames = coalesce(as.numeric(L1), 0) + coalesce(as.numeric(L2), 0) + coalesce(as.numeric(L3), 0) + coalesce(as.numeric(L4), 0) + coalesce(as.numeric(L5), 0),
    
    # Calculate the margin of victory
    margin = Wgames - Lgames,
    
    
    winner_result = 1,
    loser_result = 0,
    
    
    match_id = row_number()
  ) %>% 
  
  drop_na(margin)


View(match_results_wrangled)


final_dataset <- match_results_wrangled %>% 
  mutate(
    
    k = 20 + 10 * margin, 
    
    
    home_team = Winner,
    away_team = Loser,
    
    
    hga = 0
  ) %>% 
  relocate(match_id)


elo_model <- elo.run(data = final_dataset,
                     formula = winner_result ~ adjust(home_team, hga) + away_team + k(k))


final_elos <- final.elos(elo_model) %>% 
  enframe(name = "player", value = "elo") %>% 
  arrange(desc(elo))


View(final_elos)


font_add_google(name = "Poor Story", family = "poor_story")
showtext_auto()

final_elos %>% 
  ggplot(aes(x = elo)) +
  geom_histogram(binwidth = 50, fill = "#ffb80c", color = "white") +
  theme_minimal() +
  labs(x = "Elo Rating",
       y = "# of Players",
       title = "Distribution of Final Elo Ratings") +
  theme(panel.background = element_rect(fill = "transparent", colour = NA),
        plot.background = element_rect(fill = "transparent", colour = NA),
        text = element_text(color = "black", family = "poor_story"),
        axis.text = element_text(color = "black", size = 14),
        plot.title = element_text(color = "black", size = 24, hjust = 0.5),
        axis.title = element_text(family = "poor_story", size = 16),
        plot.margin = unit(c(1,1,1,1), "cm"))


brier(elo_model)


new_matches <- read_csv("new_matches.csv") 


predictions <- new_matches %>%
  left_join(final_elos %>% rename(home_elo = elo), by = c("home_player" = "player")) %>%
  left_join(final_elos %>% rename(away_elo = elo), by = c("away_player" = "player")) %>%
  mutate(
    home_team_prob = elo.prob(home_elo, away_elo),
    away_team_prob = elo.prob(away_elo, home_elo),
    home_odds = round((1/home_team_prob),2), 
    away_odds = round((1/away_team_prob),2)
  ) %>%
  select(home_player, away_player, home_odds, away_odds)


View(predictions)

write.csv(predictions, "predictions.csv")