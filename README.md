

# 🎾 Predictive Tennis Betting Model in RStudio

This project is an effort to create a predictive tennis betting model using RStudio. Inspired by the [soccer ELO tutorial](https://betfair-datascientists.github.io/modelling/soccerEloTutorialR/), this model applies similar concepts to predict outcomes of football matches.

## 🔍 Overview

The main goal of this project is to calculate 'power' ratings for individual male tennis players, which can then be used to predict match outcomes. The core of the model is based on the **ELO rating system**, originally developed for Chess.

### Data Source

All necessary data is sourced from [Tennis Data](http://www.tennis-data.co.uk/), which provides historical match results crucial for calculating accurate player ratings.

### How It Works

- **Initial Ratings:** Every player starts with a rating of **1500**.
- **Wins and Losses:** Ratings are adjusted based on match results. Wins increase a player's rating, while losses decrease it.
- **Opponent Difficulty:** The rating adjustment depends on the strength of the opponent.
- **Margin of Victory:** The number of games won in a match also affects the rating adjustment.

## 📊 Current ELO Rankings

As of **12th August 2024**, the current male tennis rankings according to the ELO score are:

![tennis_elo](https://github.com/user-attachments/assets/c585e626-b549-4aa3-bc99-823b45cbe4d9)



## 🔮 Predicted Win Probabilities

Here are the forecasted win probabilities if some of these players were to match up tomorrow:

![tennis_predictions](https://github.com/user-attachments/assets/580ce38e-db3e-40c5-a5e1-f1728ee9e3cf)


