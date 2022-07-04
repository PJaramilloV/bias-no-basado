# Script para juntar decile_score de reincidencia a otras tablas

# guardar las tablas enteras
SAVE_TABLES = FALSE
# reemplazar las tablas iniciales para guardarlas en "e2_clean_tablas.R"
REPLACE_TABLES = TRUE

# atributos a juntar
attributes_ <- c("person_id", "decile_score")

# tabla intermedia
compas_recid <- compas %>%
  filter(scale_id == 8) %>%
  select(attributes_) %>%
  distinct(person_id, .keep_all = TRUE)

  
# Añadir el decile_score de reincidencia a todas las tablas
casearrest_w_decile <- casearrest %>%
  left_join(compas_recid, by="person_id")

charge_w_decile <- charge %>%
  left_join(compas_recid, by="person_id")

prisonhistory_w_decile <- prisonhistory %>%
  left_join(compas_recid, by="person_id")

jailhistory_w_decile <- jailhistory %>%
  left_join(compas_recid, by="person_id")


# parametros para guardas
path = paste0(getwd(), '/data/cleaned/')
form = '.csv'



if(SAVE_TABLES){
  # guardar tablas
  write.csv(casearrest_w_decile,    paste0(path, 'casearrest_w_decile'   , form))
  write.csv(charge_w_decile,        paste0(path, 'charge_w_decile'       , form))
  write.csv(jailhistory_w_decile,   paste0(path, 'jailhistory_w_decile'  , form))
  write.csv(prisonhistory_w_decile, paste0(path, 'prisonhistory_w_decile', form))
}
if(REPLACE_TABLES){
  casearrest <- casearrest_w_decile
  charge <- charge_w_decile
  jailhistory <- jailhistory_w_decile
  prisonhistory <- prisonhistory_w_decile

  rm(casearrest_w_decile, charge_w_decile, jailhistory_w_decile, prisonhistory_w_decile)
}


# eliminar tabla intermedia
rm(compas_recid)
# eliminar variables
rm(attributes_, path, form, SAVE_TABLES, REPLACE_TABLES)