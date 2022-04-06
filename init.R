# Script para cargar data al workspace

# install.packages("RSQLite")
# install.packages("here")
library(RSQLite)
library(rstudioapi)
library(tidyverse)
library(utils)
library(here)
library(scales)

# Setear working directory al directorio de este archivo
setwd(here())

getwd()   # Ver que se seteo bien

# Cargar BD, esta contiene 7 tablas:
#         casearrest      charge          compas      jailhistory     
#         people          prisonhistory   summary
db <- dbConnect(dbDriver("SQLite"), dbname="compas.db")
dbListTables(db)

#   tabla     |           linea de carga          | dimensiones[fila,columna]
casearrest    <- dbReadTable(db, "casearrest")    # [128183, 8 ]
charge        <- dbReadTable(db, "charge")        # [148086, 15]
compas        <- dbReadTable(db, "compas")        # [37578,  21]
jailhistory   <- dbReadTable(db, "jailhistory")   # [22111,  7 ]
people        <- dbReadTable(db, "people")        # [11757,  41]
prisonhistory <- dbReadTable(db, "prisonhistory") # [4945,   9 ]
summary       <- dbReadTable(db, "summary")       # [0,      26] #whatWea

dbDisconnect(db)
rm(db)
rm(summary)


