
# Cuantos cargos hay por nivel?
people_charge %>% 
  ggplot(aes(x=charge_degree)) +
    geom_bar() + 
    labs(y="numero de instancias", x ="grado de cargo", 
         title="Numero de cargos por grado")

# Crimenes cometidos por personas analizadas por COMPAS a lo largo del tiempo
people_charge %>%
  ggplot(aes(x=offense_date)) + 
    geom_histogram(bins = 40) +
    labs(x="año de crimen", y="cantidad de crimenes", 
         title="Crimenes cometidos por gente analizada por COMPAS a lo largo del tiempo")


# Arrestos de los analizados por COMPAS a lo largo del tiempo
casearrest %>%
  ggplot(aes(x=arrest_date)) + 
    geom_histogram(bins = 40) +
    labs(x="año de crimen", y="cantidad de arrestos", 
         title="Arrestos a gente analizada por COMPAS a lo largo del tiempo")


# Estado civil?
compas %>%
  filter(type_of_assessment == "Risk of Violence") %>% # Tipo escogido al azar, es para no tener datos triplicados
  ggplot(aes(x=marital_status)) +
    geom_bar() +
    labs(x="Estado civil", y="Numero de gente", 
         title="Estado civil de la gente analizada por COMPAS")


# Situación al ser analizado ?
compas %>% 
  filter(type_of_assessment == "Risk of Violence") %>% # Tipo escogido al azar, es para no tener datos triplicados
  ggplot(aes(x=custody_status)) +
    geom_bar() + 
    labs(x="Estado de custodia", y="Numero de gente", 
         title="Estado custodial de la gente analizada por COMPAS")


# Nivel de supervisión que COMPAS recomiende que se ponga sobre los analizados
compas %>%
  filter(type_of_assessment == "Risk of Violence") %>% # Tipo escogido al azar, es para no tener datos triplicados
  ggplot(aes(x=rec_supervision_level_text)) +
    geom_bar() +
    labs(x="Nivel de supervisión recomendado", y="Numero de gente", 
         title="Nivel de supervisión recomendado para la gente analizada por COMPAS")


# Puntaje crudo por tipo de analisis de COMPAS
# Riesgo de reincidencia
compas %>%
  filter(type_of_assessment == "Risk of Recidivism") %>%
  ggplot(aes(x=raw_score)) +
    geom_histogram() +
    labs(x="Puntaje COMPAS", y="Numero de gente", 
         title="Distribución de puntaje COMPAS sobre 'Riesgo de Reincidencia' ") 

# Riesgo de violencia
compas %>%
  filter(type_of_assessment == "Risk of Violence") %>%
  ggplot(aes(x=raw_score)) +
    geom_histogram() +
    labs(x="Puntaje COMPAS", y="Numero de gente", 
       title="Distribución de puntaje COMPAS sobre 'Riesgo de Reincidencia Violenta' ")

# Riesgo de fallo de aparecer en corte
compas %>%
  filter(type_of_assessment == "Risk of Failure to Appear") %>%
  ggplot(aes(x=raw_score)) +
    geom_histogram() +
    labs(x="Puntaje COMPAS", y="Numero de gente", 
         title="Distribución de puntaje COMPAS sobre 'Riesgo de fallo de aparecer en corte' ")


# Distribución de decirles de riesgo
compas %>%
  filter(decile_score > 0) %>%
  ggplot(aes(x=decile_score)) +
    geom_bar() +
    facet_wrap(~ type_of_assessment) +
    labs(x="Decil COMPAS", y="Numero de gente", 
       title="Distribución de deciles COMPAS por tipo de analisis ")


# Fecha de salida versus fecha de ingreso a cárcel
jailhistory %>%
  ggplot(aes(x=in_custody, y=out_custody, color=(as.numeric(in_custody - dob, unit="weeks") /52.25 ) )) +
    geom_point( alpha=0.4) +
    labs(x="fecha de ingreso a carcel", y="fecha de salida de carcel", title="Fecha de entrada versus salida de carcel" ) +
    scale_color_continuous(name="edad al ingresar")


# Fecha de salida versus fecha de ingreso a prisión
prisonhistory %>%
  ggplot(aes(x=in_custody, y=out_custody, color=(as.numeric(in_custody - dob, unit="weeks") /52.25 ) )) +
    geom_point( alpha=0.4) +
    labs(x="fecha de ingreso a prision", y="fecha de salida de prision", title="Fecha de entrada versus salida de prision" ) +
    scale_color_continuous(name="edad al ingresar")



# Numero de crimenes previos al crimen que llevó al analisis de COMPAS
people %>% 
  ggplot(aes(x=priors_count)) + 
    geom_bar() +
    labs(x="numero de cargos previos al crimen que llevó al analisis COMPAS", y="Numero de gente",
         title="Cargos previos al analisis de COMPAS")

# Porcentaje de reincidencia 
lookup =  c("-1"="No Sentenciado", "0"= "No", "1"="Si")
people %>%
  group_by(is_recid) %>%
  summarize(n=n()) %>%
  mutate(perc = n/sum(n)) %>%
  mutate(is_recid = as.character(is_recid) ) %>%
  mutate(is_recid = recode(is_recid, !!!lookup )) %>%
  ggplot(aes(x="", y=n, fill=is_recid)) +
    geom_col() + 
    geom_text(aes(label = percent(round(perc,3))), position = position_stack(vjust = 0.5)) +
    coord_polar("y") +
    scale_fill_discrete("es reincidente?")+
    theme_void() + 
    ggtitle("Porcentajes de reincidencia")
rm(lookup)

people %>%
  group_by(sex) %>%
  summarize(n=n()) %>%
  mutate(perc = n/sum(n)) %>%
  ggplot(aes(x="", y=n , fill=sex)) + 
    geom_col() + 
    geom_text(aes(label = percent(round(perc,3))), position = position_stack(vjust = 0.5)) +
    coord_polar("y") +
    scale_fill_discrete("Sexo")+
    theme_void() + 
    ggtitle("Distribución de sexo")

people %>%
  group_by(race) %>%
  summarize(n=n()) %>%
  mutate(perc = n/sum(n)) %>%
  ggplot(aes(x="", y=n , fill=race)) + 
  geom_col() + 
  geom_text(aes(label = percent(round(perc,3))), position = position_stack(vjust=0.5)) +
  coord_polar("y") +
  scale_fill_discrete("etnia")+
  theme_void() + 
  ggtitle("Distribución de etnia")
