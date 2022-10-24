library(rvest)
library(tidyverse)
library(openxlsx)
library(DT)
library(dplyr)
library(formattable)
library(stringr)

url1 <- 'https://www.soccerstats.com/matches.asp?matchday=1&listing=1'
url2 <- 'https://www.soccerstats.com/matches.asp?matchday=1&listing=2'
tb1 <- read_html(url1) %>% html_table()
tb2 <- read_html(url2) %>% html_table()
dd1 <- tb1[[7]]     
dd2 <- tb2[[7]]
colnames(dd1) <- c('País','Over25_H','Over15_H','GolsSofridos_H',
                   'GolsMarcados_H','MediaGols_H','PPG_H','GP_H','Scope_H',
                   'Home','Hora','Away','Scope_A','GP_A','PPG_A','MediaGols_A',
                   'GolsMarcados_A','GolsSofridos_A','Over15_A','Over25_A',"")
dd1 <- select(dd1,c('País','Over25_H','Over15_H','GolsSofridos_H',
                    'GolsMarcados_H','MediaGols_H','PPG_H','Home','Hora',
                    'Away','PPG_A','MediaGols_A','GolsMarcados_A',
                    'GolsSofridos_A','Over15_A','Over25_A'))
colnames(dd2) <- c('País','BTTS_H','FTS','CS','%Vitorias_H','TG','PPG','GP','Scope',
                   'HOME','','','Scope.1','GP.1','PPG.1','TG.1','%Vitorias_A',
                   'CS.1','FTS.1','BTTS_A')
dd2 <- select(dd2, c('BTTS_H','%Vitorias_H','BTTS_A','%Vitorias_A'))
df <- bind_cols(dd1,dd2)
df_med <- select(df,c('País','Hora','Home','Away','%Vitorias_H','%Vitorias_A',
                      'Over15_H','Over25_H','Over15_A','Over25_A'))
for (i in 5:10) {
  df_med[[i]] <- str_remove(df_med[[i]],'[%]')
}
for (i in 5:10) {
  df_med[[i]] <- as.numeric(df_med[[i]])
}
df_med["OVER2.5%"] <- round((df_med$Over25_H+df_med$Over25_A)/2,2)
df_med["OVER1.5%"] <- round((df_med$Over15_H+df_med$Over15_A)/2,2)
df_med <- df_med %>% select(País,Hora,Home,Away,`%Vitorias_H`,`%Vitorias_A`,
                            `OVER1.5%`,`OVER2.5%`)
df_maxrate <- filter(df_med, `OVER2.5%` > 75)
for (i in 5:8) {
  df_maxrate[[i]] <- paste0(df_maxrate[[i]], '%')
}
write.xlsx(df_maxrate, file = "analise_jogos_hj.xlsx")
rm(list = c("dd1","dd2","df","df_med","i","tb1","tb2","url1","url2"))


