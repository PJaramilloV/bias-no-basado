source("init.R")




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