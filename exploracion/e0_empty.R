source("init.R")


# Deteccion de valores invalidos/vacios ========================================

## charge -----------------------------------------------------------------------
#
# id           : 1-148086 redundante con orden original
# case_type    : "" (100%)
# filing_date  : 1800-01-01 00:00:00.000000 (100%)
# filing_type  : 56837/148086 <NA> (38.4%)
# charge       : 573  /148086 <NA> ( 0.004%)
# filing_agency: 6    /148086 <NA> (~0.0%)
# statute      : 573  /148086 <NA> ( 0.004%)
#
#charge %>% group_nest(case_type)
#charge %>% filter(is.na(statute))

summary(charge)


## casearrest -------------------------------------------------------------------
#
# id    : 1-128183 redundante con orden original

summary(casearrest)


## compas -----------------------------------------------------------------------
#
# id                : 1-37578 redundante con orden original
# agency_text       : PRETRIAL (95.9%)   |   Probation (3.4%)   |   Broward County (0.3%)   |   DRRD (0.4%)
# legal_status      : Pretrial (100%)
# assessment_reason : Intake   (100%)
# scale_set         : Risk and Prescreen (98.7%)   |   All Scales   (1.3%)
# type_of_assessment: Risk of Failure to Appear (33.3%)   |   Risk of Recidivism (33.%)   |   Risk of Violence (33.3%)
# scale_id          : {7, 8, 18} == {Risk of Violence, Risk of Recidivism, Risk of Failure to Appear}

summary(compas)


## jailhistory ------------------------------------------------------------------
#
# id    : 1-4945 redundante con orden original

summary(jailhistory)


## people -----------------------------------------------------------------------
#
# id                     : 1-11757 redundante con orden original
# score_text             : <NA> (100%)
# violent_recid          : <NA> (100%)
# num_vr_cases           : <NA> (100%)
# days_b_screening_arrest: 742  /11757 <NA> ( 6.3%)
# c_days_from_compas     : 742  /11757 <NA> ( 6.3%)
# c_jail_in              : 742  /11757 <NA> ( 6.3%)
# c_jail_out             : 742  /11757 <NA> ( 6.3%)
# c_case_number          : 742  /11757 <NA> ( 6.3%)
# c_days_from_compas     : 742  /11757 <NA> ( 6.3%)
# c_arrest_date          : 9899 /11757 <NA> (84.2%)
# c_offense_date         : 2600 /11757 <NA> (22.1%)
# c_charge_degree        : 742  /11757 <NA> ( 6.3%)
# c_charge_desc          : 749  /11757 <NA> ( 6.4%)
# num_r_cases            : 8054 /11757 <NA> (68.5%)
# r_case_number          : 8054 /11757 <NA> (68.5%)
# r_charge_degree        : 8054 /11757 <NA> (68.5%)
# r_days_from_arrest     : 9297 /11757 <NA> (79.1%)
# r_offense_date         : 8054 /11757 <NA> (68.5%)
# r_charge_desc          : 8114 /11757 <NA> (69.0%)
# r_jail_in              : 9297 /11757 <NA> (79.1%)
# r_jail_out             : 9297 /11757 <NA> (79.1%)
# vr_case_number         : 10875/11757 <NA> (92.5%)
# vr_charge_degree       : 10875/11757 <NA> (92.5%)
# vr_offense_date        : 10875/11757 <NA> (92.5%)
# vr_charge_desc         : 10875/11757 <NA> (92.5%)
#
#people %>% filter(is.na(c_arrest_date))

summary(people)


## prisonhistory ----------------------------------------------------------------
#
# id    : 1-4945 redundante con orden original
# name  : <NA> (100%)
# middle: <NA> (100%)
#
#prisonhistory %>% group_nest(name)

summary(prisonhistory)