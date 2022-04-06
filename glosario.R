
# Info preeliminar =============================================================

# Los datos son de Broward County, Florida, USA.
# Los datos corresponden a personas punteadas en 2013 y 2014, originalmente eran 18610,
#     pero el dataset contiene 11757, razon explicada sgtemente.
# Los datos de las 11757 personas fueron usados para evaluar a los detenidos antes de juicio
#
# https://www.propublica.org/article/how-we-analyzed-the-compas-recidivism-algorithm

# COMPAS:
#        Correctional
#        Offender
#        Management
#        Profiling
#        (for) Alternative
#        Sanctions

# COMPAS es una herramienta de Northpointe,Inc (Equivant) para calcular riesgos
# de repetir ofensas criminales según las características de un criminal.
#
# La controversia alrededor de COMPAS es que posiblemente esta cesgado contra 
# ciertos grupos sea por raza o sexo.
#
# https://en.wikipedia.org/wiki/COMPAS_(software)

# COMPAS asigna puntaje a 3 factores:
#   - Riesgo de reiteracion             | "Risk of Recidivism"
#   - Riesgo de violencia               | "Risk of Violence"
#   - Riesgo de no aparecer en tribunal | “Risk of Failure to Appear”



# Descripcion atributos ========================================================

## charge_degree ----------------------------------------------------------------

# charge_degree es el tipo y grado de la ofensa criminal
# 
# 0      = Infraction   
# CT     = Infraction ?(Contempt to Court / failing to appear to summons)
# CO3    = Infraction  (Mal comportamiento, loitering, literring, sleeping)
# M | MO = Misdemeanor
# F      = Felony
# NIO    = Infraction ?
# TC4    = Misdemeanor (DUI / DWAI) Felony_4 if charge 4 or 5
# TCX    = Misdemeanor (Drive no license / Reckless Drive / License revoked/ License Expired)
# X      = No info
#
#
# 1-7    = grados de crimen, 1 mas serio 
# 
# https://en.wikipedia.org/wiki/Classes_of_offenses_under_United_States_federal_law

## days_since_compas_arrest -----------------------------------------------------

# ??????
#
#


## filing_type -----------------------------------------------------------------

# como llego el reporte a la base de datos


## filing_agency ---------------------------------------------------------------

# desde donde se mando el reporte a la base de datos


## statute ---------------------------------------------------------------------

# el estatuto legal infringido en el caso particular


## person_id ---------------------------------------------------------------------

# id interno del individuo, no tiene relación con el "Social Security Number" 


## compas_person_id ------------------------------------------------------------

# otro id interno del individuo


## compas_case_id --------------------------------------------------------------

# id del analisis de COMPAS para un procedimiento particular, en particular dato
# el dataset, esto es antes de juicio


## compas_assessment_id --------------------------------------------------------

# id de los resultados del analisis


## agency_text -----------------------------------------------------------------

# un tag que le puso el usuario del sistema al analisis, casi siempre "PRETRIAL"


## scale_set -------------------------------------------------------------------

# conjuntos de mediciones hecho, irrelevante pues siempre se tienen las 3 mismas


## assessment_reason -----------------------------------------------------------

# porque fue hecho el analisis (?), irrelevante pues siempre es "Intake"


## legal_status ----------------------------------------------------------------

# estado legal del caso en el momento del analisis, irrelevante, pues siempre "Pretrial"


## custody_status --------------------------------------------------------------

# estado de custodia del arrestado, 6 categorias posibles


## marital_status --------------------------------------------------------------

# estado de civil del arrestado, 7 categorias posibles


## screening_date --------------------------------------------------------------

# dia del analisis de COMPAS


## rec_supervision_level -------------------------------------------------------

# nivel de supervision requerida ????


## rec_supervision_level_text --------------------------------------------------

# texto equivalente a rec_supervision_level


## score_text ------------------------------------------------------------------

# nivel del puntaje, referencial


## scale_id --------------------------------------------------------------------

# id del tipo de medicion: 7, 8 o 18 son los trabajados en la tabla


## type_of_assessment ----------------------------------------------------------

# texto equivalente a scale_id


## raw_score -------------------------------------------------------------------

# puntaje de la medicion, obtenido por el algoritmo de COMPAS, no open source


## decile_score ----------------------------------------------------------------

# en que decil de la medición se encuentra el sujeto en cuestion, la medicion
# busca predecir que tan probable es que el sujeto haga el mal del 
# type_of_assessment correspondiente
# 1-> muy poco probable; 10-> casi garantizado


## age_cat ---------------------------------------------------------------------

# rango de edad; [0,25) , [25,45], (45, \inf)


## juv_fel_count  --------------------------------------------------------------

# cantidad de felonias cometidas mientras menor de edad (<18)


## juv_misd_count  -------------------------------------------------------------

# cantidad de misdemeanors cometidos mientras menor de edad (<18)


## juv_other_count  ------------------------------------------------------------

# cantidad de infracciones cometidas mientras menor de edad (<18)


## decile_score  ---------------------------------------------------------------

# decil de que tan propenso es a hacer mal de nuevo
# 1-> poco probable,   10-> muy probable


## priors_count  ---------------------------------------------------------------

# cantidad de infricciones totales cometidas antes de ser analisado por COMPAS


## compas_screening_date  ------------------------------------------------------

# fecha en la cual se analiso al preso con COMPAS


## days_b_screening_arrest  ----------------------------------------------------

# resta en dias: compas_screening_date - c_jail_in


## c_days_from_compas ----------------------------------------------------------

# resta en dias: compas_screening_date - c_offense_date ???????
#
# NOTA: prefijo "c_" denota informacion relacionada con el crimen que dio origen
#         a la necesidad de analisar al sujeto con COMPAS


## is_recid --------------------------------------------------------------------

# booleano: volvio a hacer crimen? si o no


## num_r_cases  ----------------------------------------------------------------

# numero de casos de crimenes post libertad del crimen original


## decile_score  ---------------------------------------------------------------

# decil de que tan propenso es a hacer mal de nuevo


## r_days_from_arrest  ---------------------------------------------------------

# resta en dias: r_jail_in - r_offense_date
#
# NOTA: prefijo "r_" denota informacion relacionada con el/los crimen(es) despues
#         de que se diera libertad al sujeto despues de su primer crimen/infraccion


## is_violent_recid ------------------------------------------------------------

# booleano: fue violento en su crimen post COMPAS? si o no


## num_vr_cases  ----------------------------------------------------------------

# numero de casos de crimenes violentos post libertad del crimen original
#
# NOTA: sospecho que hubo un error en la generacion de la tabla pues este atributo
#         siempre es <NA>

