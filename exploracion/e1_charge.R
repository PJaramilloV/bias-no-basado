source("init.R")

charge %>%
  filter(charge_degree == "(CO3)") %>%
  group_nest(charge) 

charge %>%
  group_nest(charge_degree)

#"Infraction", "Municipal (Speed Not Indicated)", "Speeding (Speed not Indicated)", "Speeding (Speed Not Indicated)", "Unlawful Speed / Speed Not Indicated", "Loitering"

# NA