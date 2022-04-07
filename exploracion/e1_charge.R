source("init.R")

# Estructuras de datos =========================================================

# Lista de cargos sospechosos compilada a mano
flimsy_charges = c("Infraction", "Municipal (Speed Not Indicated)", 
                   "Speeding (Speed not Indicated)", 
                   "Speeding (Speed Not Indicated)", 
                   "Unlawful Speed / Speed Not Indicated", "Loitering", NA
                   )

# tabla de personas con sus IDs
# se cruzan las tablas de historia carcelaria (jail) y penal (prison) para enlazar
# los id's de las personas con su nombre completo y fecha de nacimiento
#     se filtran person_id != id, pues son personas que aparecen duplicadas (3 personas)
#       con esos valores eliminados se puede copiar el id al person id pues son identicos
#       entonces se tiene una tabla que enlaza unicamente a una persona con 1 id
#       para asi cruzar esta tabla con tablas de arresto para graficar segun raza
people_w_id <- people %>%
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
                  filter(person_id == id | is.na(person_id)) %>%
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