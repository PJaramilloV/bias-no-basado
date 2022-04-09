# Estadisticas generales
statistics <- people %>% 
                group_by(race,sex) %>% 
                summarize(people = n(),
                          mean_age = round(mean(age), 2),
                          median_age = median(age),
                          mean_jail_t = round(mean(as.Date(c_jail_out) - 
                                               as.Date(c_jail_in),na.rm=TRUE)
                                              ,2),
                          median_jail_t = median(as.Date(c_jail_out) - 
                                                    as.Date(c_jail_in),na.rm=TRUE),
                          mean_decile= round(mean(decile_score),2),
                          median_decile= median(decile_score),
                          total_decile_10= sum(decile_score==10),
                          total_decile_1= sum(decile_score==1))

view(statistics)


# Cantidad total de cargos por tipo: Felony / Misdemeanor / Infraction
people_charge %>% 
  left_join(people %>%
              select("name", "sex","dob", "id") %>%
              relocate(person_id = id),
            by= c("person_id")
            )  %>%
  summarize(felonies = sum(str_detect(charge_degree, "F")),
            misdemeanors = sum(str_detect(charge_degree, "(M|TC)")),
            infractions = n() - felonies -misdemeanors)


# Cantidad total de cargos por tipo: Felony / Misdemeanor / Infraction
# Agrupado por sexo y etnia del individuo
people_charge %>% 
  left_join(people %>%
              select("name", "sex","dob", "id") %>%
              relocate(person_id = id),
            by= c("person_id")
  )  %>%
  group_by(race,sex) %>%
  summarize(felonies = sum(str_detect(charge_degree, "F")),
            misdemeanors = sum(str_detect(charge_degree, "(M|TC)")),
            infractions = n() - felonies -misdemeanors)






