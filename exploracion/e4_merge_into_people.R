
# Se realizara una extracción de datos de people_charge (tabla charge + race desde people)
# Recordar que person_id identifica a cada individuo por separado


#---- Join Charge a People -----

# Para simplificar se reducirá a solo estas columnas
attributes_vect <- c("person_id","name","race", "date_charge_filed", 
                     "charge_degree", "days_since_compas", "filing_agency")

# Se usa la nivelación de charge_degree
charge_degree_ = c("(F1)", "(F5)", "(F6)", 
                   "(F2)", "(F3)", "(F7)", 
                   "(M1)", "(M2)", "(CT)", 
                   "(M3)", "(MO3)", "(TCX)", "(TC4)", 
                   "(NI0)", "(CO3)", "(0)")

# Valores respectivos de cada grado según gravedad
num_charge_deg = c(1.0, 1.0, 1.0, 
                   0.9, 0.85, 0.85,
                   0.6, 0.55, 0.5, 
                   0.4, 0.4, 0.35, 0.12, 
                   0.07, 0.03, 0.0)

essentials <- people_charge %>%
                select(attributes_vect) %>% 
                mutate_at("date_charge_filed", as.Date, format = "%Y-%m-%d") %>%
                filter(!str_detect(charge_degree, 'XX')) %>%                     # Eliminar datos mal registrados
                filter(charge_degree != '(X)')
                
# Pasar cargos de string a float normalizado
essentials$charge_degree <- essentials$charge_degree %>%
                              mapvalues( from=charge_degree_, to=num_charge_deg)
essentials <- essentials %>% mutate(charge_degree = as.numeric(charge_degree))


# Crear nueva tabla
new_table <-  essentials %>% 
                mutate_at("date_charge_filed", as.numeric) %>%                  # Pasar fecha a float
                mutate(across("date_charge_filed", ~ round((.x + 18342)/(36604), 5))) %>% 
                group_by(person_id, name, race) %>%                             # Por cada persona, guardar nombre y etnia
                summarize(max_degree = max(charge_degree),
                          min_degree = min(charge_degree),
                          avg_degree = round(mean(charge_degree), 5),
                          med_degree = round(median(charge_degree),5),
                          charges_recid = sum(days_since_compas < 0),
                          charges_no_recid = ( n() - charges_recid ), 
                          charges_total = n(),
                          charge_latest = max(date_charge_filed)) %>%
                relocate(id = person_id)


# Limpiar tabla people
eliminate_pe = c("first", "last", "age", "age_cat", "score_text", "violent_recid", 
                 "c_case_number", "c_charge_desc", "c_arrest_date")
# columnas de fecha en string
dates_pe = c("dob", "compas_screening_date", "c_jail_in", "c_jail_out", "c_offense_date")

# limpiar tabla people
people_filtered <- people %>% # juntar "c_offense_date" y "c_arrest_date", pues son complementarias y no poseen intersección
                    mutate(c_offense_date = ifelse(is.na(c_offense_date), c_arrest_date, c_offense_date ) ) %>%
                    mutate(num_r_cases = ifelse(is.na(num_r_cases), 0, num_r_cases) ) %>%
                    select(!"r_case_number":last_col()) %>% # eliminar columnas de reincidencia salvo "is_recid" y numero de casos reincidentes
                    select(-eliminate_pe) %>% # eliminar las columnas vacias o sin valor numerico
                    mutate_at(dates_pe, as.Date, format = "%Y-%m-%d") %>% # pasar fechas a numeros
                    mutate_at(dates_pe, as.numeric) %>% 
                    mutate(across(dates_pe, ~ round((.x + 18342)/(36604), 5))) %>%
                    mutate(c_jail_in  = ifelse(is.na(c_jail_in) , compas_screening_date, c_jail_in) ) %>% # considerar fecha de carcel como la de analisis en casos nulos, pues se restriene a la gente ese dia
                    mutate(c_jail_out = ifelse(is.na(c_jail_out), compas_screening_date, c_jail_out) )%>%
                    filter(!str_detect(c_charge_degree, 'XX')) %>%                
                    filter(c_charge_degree != '(X)') %>% 
                    mutate(days_b_screening_arrest = round( days_b_screening_arrest/36604.0 , 5)) %>% 
                    mutate(c_days_from_compas = round( days_b_screening_arrest/36604.0 , 5))

# juntar estadistica de cargos a tabla people
people_joined_charge <- people_filtered %>% 
                          left_join(new_table, by=c("id", "name", "race") ) %>%
                          filter(!is.na(charges_total))
people_joined_charge$c_charge_degree <- people_joined_charge$c_charge_degree %>%
                                          mapvalues( from=charge_degree_, to=num_charge_deg)
people_joined_charge <- people_joined_charge %>% mutate(c_charge_degree = as.numeric(c_charge_degree))


# limpiar tablas intermedias
rm(essentials, new_table, people_filtered)
# limpiar variables y estructuras intermedias
rm(attributes_vect, charge_degree_, num_charge_deg, eliminate_pe, dates_pe)

#---- Join Compas a People -----

attributes_ <- c("id", "decile_score")

compas_violence <- compas %>%
                    filter(scale_id == 7) %>%
                    select(-id) %>% # eliminar id local
                    relocate(id = person_id) %>% # person_id será el id
                    select(attributes_) %>% # tomar solo el decil
                    distinct(id, .keep_all = TRUE) %>% # quedarse con solo el 1er analisis (el cual es el registrado en tabla people)
                    relocate(decile_violence = decile_score, .after=last_col() ) # renombrar decil_score
                    


compas_recid <- compas %>%
                    filter(scale_id == 8) %>%
                    select(-id) %>%
                    relocate(id = person_id) %>%
                    select(attributes_) %>% 
                    distinct(id, .keep_all = TRUE) %>%
                    relocate(decile_recid = decile_score, .after=last_col()) 



compas_failure <- compas %>%
                    filter(scale_id == 18) %>%
                    select(-id) %>%
                    relocate(id = person_id) %>%
                    select(attributes_) %>% 
                    distinct(id, .keep_all = TRUE) %>%
                    relocate(decile_fail_to_appear = decile_score, .after=last_col())
                   

people_w_charge_decile <- people_joined_charge %>% 
                            left_join( compas_recid , by="id") %>%
                            left_join( compas_violence, by="id") %>%
                            left_join( compas_failure, by="id")

# eliminar tablas intermedias
rm(compas_failure, compas_recid, compas_violence, people_joined_charge)
# eliminar estructuras intermedias
rm(attributes_)



## ---- INFORMACIÓN IMPORTANTE ----

#### EN ESTA TABLA HAY INFORMACIÓN REDUNDANTE


# decile_score y decile_recid    completamente coinciden

# num_r_cases y  charges_recid    deberian coincidir, pero solo coinciden en el 
#                                 61% de las personas, por lo que se puede probar
#                                 cambiando entre usar una o la otra columna



#### EN ESTA TABLA HAY INFORMACION CONTRADICTORIA

# si is_recid != 1, entonces no deberian existir cargos reincidentes.

# no obstante esto NO SE CUMPLE, en el 16.2% de los casos ocurre que
# charges_recid > 0 con is_recid != 1
#
# charges_recid se calcula como la suma de entradas en charge con "days_since_compas" > 0
# se ha visto que esta columna corresponde a la resta "date_charge_filed" de la tabla charge
# menos "compas_screening_date" de la tabla people, la cual es el primer analisis
#
# por lo que no se entiende como ocurre lo visto.
#     por lo tanto se puede intentar redefinir is_recid como
#     is_recid = 1 if (charges_recid > 0)   else 0
#



#### LOS SIGUIENTES ATRIBUTOS CONTIENEN INFORMACION "REINCIDENTE"

# num_r_cases, max_degree, min_degree, avg_degree, med_degree, charges_recid, 
# charges_total, charge_latest, is_recid



#### COMO OBTENER ATRIBUTOS LIBRES DE INFORMACION "REINCIDENTE"

# recalcular: max_degree, min_degree, avg_degree, med_degree, charge_latest
#
# tal que se consideren solo cargos con "days_since_compas" >= 0
# el calculo original se realiza en la linea 39
# notar que para este cambio no basta con un filter, seria mejor hacer 2 new_tables y hacer join

ELIM_REDUNDANC = TRUE
REDEFINE_RECID = FALSE

final_table <- people_w_charge_decile %>% select(-name)

if(ELIM_REDUNDANC){
  final_table <- final_table %>% select(-decile_score)
}
if(REDEFINE_RECID){
  final_table <- final_table %>% mutate(is_recid = ifelse(charges_recid > 0 ,1,0) )
}

path = paste0(getwd(), '/data/cleaned/')
form = '.csv'
write.csv(final_table,  paste0(path, 'people_joined_charge_decile', form))

# eliminar variables
rm(ELIM_REDUNDANC, REDEFINE_RECID, path, form)
# eliminar tabla intermedia
rm(people_w_charge_decile)
