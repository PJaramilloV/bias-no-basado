source("init.R")



# Exploracion ==================================================================

# pregunta: 
#     como se atribuyen las personas por decil segun sexo?
# insight:
#     clara tendencia a disminuir por decil, mas pronunciada para mujeres,
#     notar tambien |hombres| ~ 4x|mujeres|
people %>%
  filter(decile_score > 0) %>%
  ggplot(aes(x=decile_score, fill=sex)) + 
    geom_bar() +
    facet_wrap(~ sex, scales = "free_y") + 
    scale_x_continuous(breaks= pretty_breaks(10)) +
    labs(title="COMPAS decile score distribution by sex",
         x="decile score", y="number of people") +
    theme(legend.position = "none")


# pregunta: 
#     como se distribuyen la gente criminal por raza?
# insight:
#     USA standard
people %>% 
  filter(decile_score > 0) %>% 
  group_by(race) %>%
  mutate(count = n()) %>%
  ggplot(aes(x= reorder(race, -count), fill=race)) +
  geom_bar() +
  labs(title="Number of analysed people by race",
       x="decile score", y="number of people") +
  theme(legend.position = "none")

# pregunta:
#     como se atribuyen los deciles a las personas por raza?
# insight:
#     clara tendencia a disminuir cantidad por decil, salvo para afro-americanos
#     y nativos. Cezgo racial clasico?
people %>%
  filter(decile_score > 0) %>%
  ggplot(aes(x=decile_score, fill=race)) + 
  geom_bar() +
    facet_wrap(~ race, scales = "free_y") + 
    scale_x_continuous(breaks= pretty_breaks(10)) +
    labs(title="COMPAS decile score distribution by race",
         x="decile score", y="number of people") +
    theme(legend.position = "none")



# pregunta:
#     cuantas personas vuelven a cometer crímenes?
# insight:
#     clara relacion (inversa) entre ofensores (no) repetidos y decil
people %>%
  filter(decile_score > 0) %>%
  filter(!is.na(c_arrest_date) ) %>%
  filter(is_recid != -1) %>%
  mutate(decile_score = as.character(decile_score)) %>%
  mutate(num_r_cases = ifelse(is.na(num_r_cases), 0, num_r_cases)) %>%
  mutate(is_recid = ifelse(is_recid == 0,"No","Yes")) %>%
  ggplot(aes(x= reorder(decile_score, as.integer(decile_score)),
             fill = is_recid)) +
    geom_bar(position=position_dodge(width=0.5)) +
    labs(title="Number of re-offencers by decile score",
         x="decile score", y="Count") + 
    scale_fill_discrete(name = "re-offender?") 

# pregunta:
#     cuantas personas vuelven a cometer crímenes por raza?
#       (agrupemos Asiaticos, Nativos y Otros)
# insight:
#     - la relacion incremental de re-ofensores es directa para afro-americanos
#         pero esta es gaussiana (?) para otras razas
#           (^^^^ sobre-arrestos a afro-americanos? ^^^^)
#     - la relacion decremental de "1 timers" es visible en las razas que NO
#         son afro-americanas, para los afro-americanos se ve asintotica
#         (^^^^ bias racial o side-effect del la relacion incremental? ^^^^)
people %>%
  filter(decile_score > 0) %>%
  filter(!is.na(c_arrest_date) ) %>%
  filter(is_recid != -1) %>%
  mutate(race = ifelse(race %in% c("Asian", "Native American"), 
                       "Other", race )) %>%
  mutate(decile_score = as.character(decile_score)) %>%
  mutate(num_r_cases = ifelse(is.na(num_r_cases), 0, num_r_cases)) %>%
  mutate(is_recid = ifelse(is_recid == 0,"No","Yes")) %>%
  ggplot(aes(x= reorder(decile_score, as.integer(decile_score)),
             fill = is_recid)) +
  geom_bar(position=position_dodge(width=0.5)) +
  facet_wrap(~ race, scales = "free_y") +
  labs(title="Number of re-offencers by decile score",
       x="decile score", y="Count") + 
  scale_fill_discrete(name = "re-offender?") 
    
# pregunta:
#     como se distribuyen la cantidad de crímenes posterior al original?
# insight:
#     se nota que incrementan algo, pero no bastante, podría ser que
#     mayor decil --> mas t en carcel --> menos oportunidad de cometer crímenes ?
people %>%
  filter(decile_score > 0) %>%
  filter(!is.na(c_arrest_date) ) %>%
  filter(is_recid != -1) %>%
  mutate(decile_score = as.character(decile_score)) %>%
  mutate(is_violent_recid = ifelse(is_violent_recid == 0,"No","Yes")) %>%
  ggplot(aes(x= reorder(decile_score, as.integer(decile_score)), 
             y=num_r_cases, color=is_violent_recid)) + 
    geom_boxplot(alpha=0.2) +
    labs(title="Number of re-offences by decile score and violence",
         x="decile score", y="Re-offences") + 
    scale_color_discrete(name = "violent individual?") 


# pregunta:
#     se arresta sin motivo a los afro-americanos mas que al resto de la gente?
# insight:
#     relativamente hablando: si, se puede ver que las cantidades de arrestos sin
#     razon dada para las razas no afroamericanas son menores que las mismas para
#     arrestos con razon dada al usar a los afroamericanos como referencia
people %>%
  filter(!(is.na(c_charge_desc))) %>%
  group_by(race) %>%
  mutate(count = n()) %>%
  ggplot(aes(x=reorder(race, -count), fill=race)) +
    geom_bar() +
    facet_wrap(~ c_charge_desc!="arrest case no charge", scales="free_y",
                labeller=as_labeller(
                c(`TRUE` = "arrest case with some charge", `FALSE` = "arrest case no charge"))
               ) +
    labs(title="Number of people arrested with reason: 'arrest case no charge' by race",
          x="Race", y="Number of people") +
    theme(legend.position = "none", axis.text.x = element_text(angle=15, vjust=0.9, hjust=0.55))



# pregunta:
#     De la gente que no fue a prision o carcel, como se distribuyen?
# insight:
#     Las proporciones se mantienen +- constantes en relatividad entre ellas 
#    (salvo a los hispanicos, se les sentencia menos a ellos)
#     Notar: al parecer si te analiza COMPAS tienes una probabilidad de ~94.5%
#             de ser sentenciado a carcel o prision.
#             (91.5% si eres hispanico)
people_partial_id %>%
  group_by(race) %>%
  mutate(count = n()) %>%
  ggplot(aes(x=reorder(race, -count), fill=race)) +
    geom_bar() +
    facet_wrap(~ is.na(person_id), scales="free_y",
               labeller=as_labeller(
                 c(`TRUE` = "Not sent to jail/prison", `FALSE` = "Sent to jail/prison"))
    ) +
    labs(title="Race by whether people were sent to jail or prison",
         x="Race", y="Number of people") +
    theme(legend.position = "none", axis.text.x = element_text(angle=15, vjust=0.9, hjust=0.55))

# pregunta:
#     Como se distribuyen etnicamente las edades?
# insight:
#     Se puede observar que salvo los afro-americanos los grupos etnicos distribuyen
#     de forma similar entorno a la edad, los outliers son normalmente personas de la
#     3ra edad
people %>% 
  ggplot(aes(x=race, y=age)) +
    geom_boxplot() +
    labs(title="Age distribution by race",
         x="Race", y="Age")

# pregunta:
#     Existira una relacion edad y decil de COMPAS?
# insight:
#     La gente de 3ra edad se ubica más frecuentemente en el decil 1, mientras que
#     el resto de las edades se distribuye mas o menos decrementalmente por cada
#     decil, mostrandose una concentración mayor de adultos jovenes
people %>%
  filter(decile_score > 0) %>%
  ggplot(aes(x=reorder(decile_score, as.integer(decile_score)), y=age)) +
    geom_point(shape=16,  alpha=0.3, 
               position = position_jitter(width= 0.3)) + 
    labs(title="Age by COMPAS decile",
         x="Decile", y="Age")

# pregunta:
#     
# insight:
#     


# pregunta:
#     
# insight:
#     
