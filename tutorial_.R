# Tutorial R con tidiverse =====================================================


# Cargar Base de datos desde archivos .db
db <- dbConnect(dbDriver("SQLite"), dbname="compas.db")
dbListTables(db) # mostrar tablas displonibles

casearrest    <- dbReadTable(db, "casearrest")    # [128183, 8 ]
jailhistory   <- dbReadTable(db, "jailhistory")   # [22111,  7 ]
people        <- dbReadTable(db, "people")        # [11757,  41]

dbDisconnect()
rm(db)
gc()

# Seleccionar columnas
people %>% select(name) # 1 columna
people %>% select(name, sex, age, race) # seleccionar 
people %>% select(-dob) # todas menos cierto algunas columnas
#people %>% select(-across(is.numeric.Date()) )


people %>% group_nest(race)
people %>% group_by(race) %>% summarize(numero_total = n(),
                                        promedio_edad = mean(age),
                                        mediana_edad = median(age))


people %>% filter(race == "Asian")
people %>% filter(race %in% c("African-American", "Caucasian") )
people %>% filter(!(race %in% c("African-American", "Caucasian")))
people %>% filter(is.na(c_arrest_date))
people %>% filter(age == 20 | first == "miguel")

people %>% distinct()  # elminina duplicados
people %>% distinct(first, age, .keep_all=TRUE) # tuplas unicas de nombre y edad


people %>% 
  mutate(jail_period = as.Date(c_jail_out) - as.Date(c_jail_in)  ) %>%
  relocate(jail_period, .after=c_jail_out) %>%
  relocate(jail_in = c_jail_in,  .before=c_jail_out) %>%
  relocate(jail_out = c_jail_out, .before=jail_period)






people %>% 
  ggplot(aes(x=race, y=age )) + 
    geom_boxplot() +
    facet_wrap(~ sex)


people %>% 
  group_by(race, sex) %>% 
  summarize(numero_total = n(), 
            promedio_edad = mean(age), 
            mediana_edad = median(age)) %>%
  ggplot(aes(x= reorder(race, -promedio_edad) , y=promedio_edad,
             fill = sex)) +
    geom_col(position= "dodge")

people %>% 
  mutate(sex = ifelse(sex == "Male", "hombre", "mujer") )


people %>% 
  group_by(race, sex) %>% 
  summarize(numero_total = n(), 
            promedio_edad = mean(age), 
            mediana_edad = median(age)) %>%
  mutate(sex = ifelse(sex == "Male", "hombre", "mujer") ) %>%
  ggplot(aes(x= reorder(race, -promedio_edad) , y=promedio_edad,
             fill = sex)) +
  geom_col(position= position_dodge(width = 0.5)) +
  scale_fill_discrete(name = "genero") + 
  labs(x="etnia")


summary(people)




