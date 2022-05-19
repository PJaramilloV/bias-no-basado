# Configurations ======

# Save tables as CSV
SAVE = TRUE

# Restore tables to workspace
RESTORE = FALSE

# Eliminate duplicated people
DUP_PPL = TRUE

# Separate COMPAS by assessment
C_BY_ASS = TRUE

# Column eliminations
NULL_NA = TRUE  # columnas nulas
PADDING = TRUE  # columnas con información no utilizable
HUMAN_R = TRUE  # columnas para lectura por humanos

# Row cleaning
# (charge)
CHARGE_DEGREE_X = TRUE  # Grados X no tienen una descripcion de crimen
CHARGE_DESCR_NA = FALSE # Crimenes sin descripción
# (people)
PEOPLE_NEG_RECD = TRUE  # valores de "es recidivista" -1
PEOPLE_NEG_DECL = TRUE  # valores de decil -1
PEOPLE_N_SENTCD = FALSE # gente no sentenciada en primer cargo criminal
PEOPLE_DESCR_NA = TRUE  # gente sin descripción del primer cargo criminal

# Tables to clean
CASEARREST    = TRUE
CHARGE        = TRUE
COMPAS        = TRUE
JAILHISTORY   = TRUE
PEOPLE        = TRUE
PRISONHISTORY = TRUE


################## DO NOT TOUCH FROM HERE ON ################## 

# Initialize elimination vectors
eliminate_ca <- c()
eliminate_ch <- c()
eliminate_co <- c()
eliminate_jh <- c()
eliminate_pe <- c()
eliminate_ph <- c()


# ====== Eliminate Duplicate People ======
if(DUP_PPL && PEOPLE){
  # Referenciar personas con historias de carcel y prision
  people_partial_id <- people %>%
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
    filter(person_id == id | is.na(person_id))
  
  # la gente que no tiene person_id es porque no estaban en jailhistory/prisonhistory
  people_not_sentenced <- people_partial_id %>%
    filter(is.na(person_id))
  
  people <- people_partial_id %>%
    mutate(person_id = ifelse(is.na(person_id), id, person_id)) %>%
    select(-c("person_id"))

  rm(people_not_sentenced)
  rm(people_partial_id)
}

# ====== NUll/NA eliminations ======
if(NULL_NA){

  ## Casearrest ----

  # ---


  ## Charge -------

  append_c <- c("case_type", "filing_date")
  eliminate_ch <- c(eliminate_ch, append_c)


  ## Compas -------

  # ---
  
  
  ## Jailhistory -----
  
  # ---


  ## People -------

  append_c <- c("score_text", "num_vr_cases", "violent_recid")
  eliminate_pe <- c(eliminate_pe, append_c)


  ## Prisonhistory ------

  append_c <- c("name", "middle")
  eliminate_ph <- c(eliminate_ph, append_c)

}

# ====== Unusable data eliminations ====== 
if(PADDING){
  
  ## Casearrest ----- 

  # arrest_id: serial identificator
  # case_number: serial identificator

  append_c <- c("arrest_id", "case_number")
  eliminate_ca <- c(eliminate_ca, append_c)


  ## Charge ---------

  # case_number: serial identificator
  # statute: references a legal article and redundancy with charge
  
  append_c <- c("case_number", "statute")
  eliminate_ch <- c(eliminate_ch, append_c)


  
  ## Compas ---------
  
  # compas_person_id: serial identificator
  # compas_case_id: serial identificator
  # compas_assessment_id: serial identificator
  # legal_status: constant
  # assessment_reason: constant
  # scale_set: semi constant but redundant with study
  # scale_id: type of assessment integer id

  append_c <- c("compas_person_id", "compas_case_id", 
                "compas_assessment_id", "legal_status", 
                "assessment_reason", "scale_set", "scale_id")
  eliminate_co <- c(eliminate_co, append_c)
  
  ## Jailhistory -----

  # ---



  ## People ----------

  # c_case_number: serial identificator
  # r_case_number: serial identificator
  # vr_case_number: serial identificator

  append_c <- c("c_case_number", "r_case_number", "vr_case_number")
  eliminate_pe <- c(eliminate_pe, append_c)


  ## Prisonhistory -----

  # ---
}

# ====== Human readable_data eliminations ======
if(HUMAN_R){

  ## CaseArrest -----

  # id: serial identificator
  # name: meaningless for basic ML
  # person_id: serial identificator

  append_c <- c("id", "name", "person_id")
  eliminate_ca <- c(eliminate_ca, append_c)
  
  ## Charge ---------
  
  # charge: readable description of the crime, useless for basic ML
  # filing_agency: where the data was entered
  # filing_type: states how the data was obtained
  # name: meaningless for basic ML
  # person_id: serial identificator
  # id: serial identificator

  append_c <- c("charge", "filing_agency", "filing_type",
                "name", "person_id", "id")
  eliminate_ch <- c(eliminate_ch, append_c)


  ## Compas ---------

  # id: serial identificator
  # first: meaningless for basic ML
  # last: meaningless for basic ML
  # agency_text: miscellaneous information

  append_c <- c("id", "first", "last", "agency_text")
  eliminate_co <- c(eliminate_co, append_c)


  ## Jailhistory -----

  # id: serial identificator
  # first: meaningless for basic ML
  # last: meaningless for basic ML
  # person_id: serial identificator

  append_c <- c("id", "first", "last", "person_id")
  eliminate_jh <- c(eliminate_jh, append_c)


  ## People ---------

  # id: serial identificator
  # name: meaningless for basic ML
  # first: meaningless for basic ML
  # last: meaningless for basic ML
  # age_cat: redundant with age
  # c_charge_desc: readable description of the crime, useless for basic ML
  # r_charge_desc: readable description of the crime, useless for basic ML
  # vr_charge_desc: readable description of the crime, useless for basic ML

  append_c <- c("id", "name", "first", "last", "age_cat",
                "c_charge_desc", "r_charge_desc", "vr_charge_desc")
  eliminate_pe <- c(eliminate_pe, append_c)

  ## Prisonhistory -----

  # id: serial identificator
  # first: meaningless for basic ML
  # last: meaningless for basic ML
  # person_id: serial identificator

  append_c <- c("id", "first", "last", "person_id")
  eliminate_ph <- c(eliminate_ph, append_c)
}


# ====== Row Cleaning Filters ======
if(CHARGE){
  if(CHARGE_DEGREE_X){ # degrees X ~ 18 rows
  charge <- charge %>% filter(!str_detect(charge_degree, 'XX')) %>% filter(charge_degree != '(X)')
  }
  
  if(CHARGE_DESCR_NA){# null charges ~ 576 rows
    charge <- charge %>% filter(!is.na(charge))
  }
}
if(PEOPLE){
  if(PEOPLE_N_SENTCD){# people not sentenced in first crime ~ 742 rows (P_NS)
people %>% filter(!is.na(c_jail_in))
}

if(PEOPLE_NEG_RECD){# people analized without crime registered (or not sentenced) ~716 rows (subset of P_NS)
people %>% filter(is_recid != -1)
}

if(PEOPLE_NEG_DECL){# people with negative decile score ~ 15 rows (subset of P_NS)
people %>% filter(decile_score > 0)
}

if(PEOPLE_DESCR_NA){# people with no first crime charge description ~ 749 rows
people %>% filter(!is.na(c_charge_desc))
}
}

# ====== CLEAN TABLES ======
{
if(CASEARREST){
  casearrest <- casearrest %>% select(-eliminate_ca)
  rm(eliminate_ca)
}
if(CHARGE){
  charge <- charge %>% select(-eliminate_ch)
  rm(eliminate_ch)
}
if(COMPAS){
  compas <- compas %>% select(-eliminate_co)
  rm(eliminate_co)
}
if(JAILHISTORY){
  jailhistory <- jailhistory %>% select(-eliminate_jh)
  rm(eliminate_jh)
}
if(PEOPLE){
  people <- people %>% select(-eliminate_pe)
  rm(eliminate_pe)
}
if(PRISONHISTORY){
  prisonhistory <- prisonhistory %>% select(-eliminate_ph)
  rm(eliminate_ph)
}
gc()
}

# ====== Separate COMPAS ======
if(C_BY_ASS){
  compas_violence <- compas %>% filter(type_of_assessment == 'Risk of Violence') %>% select(-c("type_of_assessment"))
  compas_recid    <- compas %>% filter(type_of_assessment == 'Risk of Recidivism') %>% select(-c("type_of_assessment"))
  compas_fail_app <- compas %>% filter(type_of_assessment == 'Risk of Failure to Appear') %>% select(-c("type_of_assessment"))
}


# ====== Save tables as .csv ======
if(SAVE){
  path = paste0(getwd(), '/data/cleaned/')
  form = '.csv'
  
  {
    write.csv(casearrest,        paste0(path, 'casearrest_cl'     , form))
    write.csv(charge,            paste0(path, 'charge_cl'         , form))
    write.csv(jailhistory,       paste0(path, 'jailhistory_cl'    , form))
    write.csv(people,            paste0(path, 'people_clean'      , form))
    write.csv(prisonhistory,     paste0(path, 'prisonhistory_cl'  , form))
    if(C_BY_ASS){
      write.csv(compas_violence, paste0(path, 'compas_violence_cl', form))
      write.csv(compas_recid,    paste0(path, 'compas_recid_cl'   , form))
      write.csv(compas_fail_app, paste0(path, 'compas_failure_cl' , form))
    } else {
      write.csv(compas,          paste0(path, 'compas_cl'         , form))
    }
  }
  rm(path)
  rm(form)
  gc()
}


# ====== Restore original tables to workspace ======
if(RESTORE){
  source("init.R")
}

# ====== Clean Workspace ======
{
  rm(append_c)
  rm(CASEARREST)
  rm(CHARGE)
  rm(CHARGE_DEGREE_X)
  rm(CHARGE_DESCR_NA)
  rm(COMPAS)
  rm(DUP_PPL)
  rm(HUMAN_R)
  rm(JAILHISTORY)
  rm(NULL_NA)
  rm(PADDING)
  rm(PEOPLE)
  rm(PEOPLE_DESCR_NA)
  rm(PEOPLE_N_SENTCD)
  rm(PEOPLE_NEG_DECL)
  rm(PEOPLE_NEG_RECD)
  rm(PRISONHISTORY)
  rm(RESTORE)
  rm(SAVE)
  if(C_BY_ASS){
    rm(compas)
  }
  rm(C_BY_ASS)
}









