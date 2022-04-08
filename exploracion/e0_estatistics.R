people %>% group_by(race,sex) %>% summarize(numero_total = n(),promedio_edad = mean(age),
                                            mediana_edad = median(age),
                                            promedio_tiempo_carcel = mean(as.Date(c_jail_out) - 
                                                                            as.Date(c_jail_in),na.rm=TRUE),
                                            mediana_tiempo_carcel = median(as.Date(c_jail_out) - 
                                                                             as.Date(c_jail_in),na.rm=TRUE),
                                            promedio_decile=mean(decile_score),mediana_decile=median(decile_score),
                                            cantidad_score_10=n(decile_score==10))
view(people %>% group_by(race,sex) %>% summarize(numero_total = n(),promedio_edad = mean(age),
                                                 mediana_edad = median(age),
                                                 promedio_tiempo_carcel = mean(as.Date(c_jail_out) - 
                                                                                 as.Date(c_jail_in),na.rm=TRUE),
                                                 mediana_tiempo_carcel = median(as.Date(c_jail_out) - 
                                                                                  as.Date(c_jail_in),na.rm=TRUE),
                                                 promedio_decile=mean(decile_score),mediana_decile=median(decile_score),
                                                 cantidad_decile_10=sum(decile_score==10)))

     