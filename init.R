# Script para cargar data al workspace

# install.packages("RSQLite")
# install.packages("here")
library(RSQLite)
library(rstudioapi)
library(plyr)
library(tidyverse)
library(utils)
#library(here)
library(scales)


# Setear working directory al directorio de este archivo
#setwd(here())

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




# Limpieza de tablas =========================================================


# tabla de personas con sus IDs
# se cruzan las tablas de historia carcelaria (jail) y penal (prison) para enlazar
# los id's de las personas con su nombre completo y fecha de nacimiento
#     se filtran person_id != id, pues son personas que aparecen duplicadas (3 personas)
#       con esos valores eliminados se puede copiar el id al person id pues son identicos
#       entonces se tiene una tabla que enlaza unicamente a una persona con 1 id
#       para asi cruzar esta tabla con tablas de arresto para graficar segun raza
people_partial_id <- people %>%
  left_join(jailhistory %>%
              distinct(first, last, dob, person_id) %>%
              select("first", "last", "dob", "person_id"), 
            by=c("first", "last", "dob")) %>%
  left_join(prisonhistory %>%  distinct(first, last, dob, person_id) %>%
              select("first", "last", "dob", "person_id"), 
            by=c("first", "last", "dob")) %>%
  mutate(person_id.x = ifelse(is.na(person_id.x), person_id.y, person_id.x)) %>%
  relocate(person_id = person_id.x) %>%
  select(-person_id.y) %>% 
  filter(person_id == id | is.na(person_id))

# la gente que no tiene person_id es porque no estaban en jailhistory/prisonhistory
people_not_sentenced <- people_partial_id %>%
  filter(is.na(person_id))

# Lista de cargos sospechosos compilada a mano
flimsy_charges = c("Infraction", "Municipal (Speed Not Indicated)", 
                   "Speeding (Speed not Indicated)", 
                   "Speeding (Speed Not Indicated)", 
                   "Unlawful Speed / Speed Not Indicated", "Loitering", NA
)


people_w_id <- people_partial_id %>%
  mutate(person_id = ifelse(is.na(person_id), id, person_id))


# tabla de los crimenes con razas appendadas
# filtro para id's <NA> es porque no cometieron crimenes y por lo tanto no aparecen en jailhistory/charge 
people_charge <- charge %>%
  left_join(people_w_id %>% 
              select(race, person_id), 
            by=c("person_id")) %>%
  distinct()

rm(people_not_sentenced)
rm(people_partial_id)
rm(people_w_id)