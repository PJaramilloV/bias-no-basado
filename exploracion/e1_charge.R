source("init.R")

# Estructuras de datos =========================================================

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


# Exploracion ==================================================================

# pregunta:
#     Los cargos sospechosamente leves, y/o ambiguos son repartidos con bias racial?
# insight:
#     posiblemente, se vuelve a ver que en especial los "whites" se les detiene
#     menos que a los afro-americanos bajo esos cargos
# DISCLAIMER:
#     se necesitan mas cargos "flimsy" para dar peso a la observacion
people_charge %>%
  group_by(race) %>%
  mutate(count = n()) %>%
  ggplot(aes(x=reorder(race, -count), fill=race)) +
    geom_bar() +
    facet_wrap(~ !(charge %in% flimsy_charges), scales="free_y",
               labeller=as_labeller(
                 c(`FALSE` = "Flimsy charges", `TRUE` = "Other charges"))) +
    labs(title="Number of arrests by race with flimsy charges compared to other cases",
         x="Race", y="Number of arrests") +
    theme(legend.position = "none", axis.text.x = element_text(angle=15, vjust=0.9, hjust=0.55))


# pregunta:
#     
# insight:
#     

# pregunta:
#     
# insight:
#     