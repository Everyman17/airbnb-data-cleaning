library(readr)
library(openxlsx)
library(tidyverse)

cidade = readline("Cidade: ")
ano = readline("Ano: ")
mes = readline("Mês: ")

setwd(choose.dir())
# Importação dos dados ----
air_data_new <- read_csv("C:/Users/d_alv/OneDrive/Ambiente de Trabalho/listings.csv")
air_data_old <- read_csv("C:/Users/d_alv/OneDrive/Ambiente de Trabalho/listings_anterior.csv")

# Info ----
cat("Ficheiro novo: ",nrow(air_data_new),"\nFicheiro antigo: ", nrow(air_data_old))

# Colunas a preencher ----
# Se o anuncio é novo ou não
air_data_new$novo_air <- ifelse(air_data_new$id %in% air_data_old$id, "Não", "Sim")

air_data_new$RNAL_anterior_air <- NA

# Elimina os que não são "Entire home/apt"
air_data_new$eliminado_por_air <- ifelse(air_data_new$room_type == "Entire home/apt", NA, "Quarto")

# Elimina os que têm um property_type não aceite
air_data_new$eliminado_por_air <- ifelse(is.na(air_data_new$eliminado_por_air), case_when(
  air_data_new$property_type == "Boat" ~ "Barco",
  air_data_new$property_type == "Boutique hotel" ~ "Hotel",
  air_data_new$property_type == "Hostel" ~ "Hostel",
  air_data_new$property_type == "Serviced apartment" ~ "SA",
  air_data_new$property_type == "Guest suite" ~ "Quarto",
  air_data_new$property_type == "Camper/RV" ~ "Caravana",
  air_data_new$property_type == "Camper/RV" ~ "Caravana",
  air_data_new$property_type == "Hotel" ~ "Hotel",
  air_data_new$property_type == "Aparthotel" ~ "Aparthotel"), "Quarto")

air_data_new$eliminado_por_anterior <- NA
air_data_new$valido_para_parque_air <- ifelse(is.na(air_data_new$eliminado_por_air), NA, 0)
air_data_new$dicofre_temp <- NA
air_data_new$contagem <- NA
air_data_new$no_tp_air <- NA
air_data_new$no_tp_outros_air <- NA
air_data_new$licenca_final_air <- NA

# Ficheiro de coordenadas para o QGIS ----
coordenadas <- air_data_new[,c("id","latitude","longitude")]

# Ficheiro de reviews para a Marta ----
reviews <- air_data_new[,c("id","reviews_per_month","cleaning_fee")]

# Normaliza o nome das colunas necessárias ----
air_data_new = air_data_new %>%
  rename(
    ID_Airbnb = id,
    Airbnb_Nome = name
  )

# Exportaçãoo dos ficheiros ----
write.xlsx(air_data_new, paste0("Airbnb_Tratado_",cidade,"_",ano,"_",mes,".xlsx"))
write.xlsx(reviews, paste0("Reviews_cleaning_fee_",cidade,"_",ano,"_",mes,".xlsx"))
dir.create("Localizacao")
write_csv(coordenadas, path = paste0("Localizacao/Coord_Air_",cidade,"_",ano,"_",mes,".csv"))
