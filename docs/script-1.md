---
title: Script hito 1
---

## Presentación

Buenas tardes, somos el grupo 8 del ramo de Minería de Datos, a cargo de los profesores Felipe Bravo y Hernán Sarmiento. En esta ocasión les presentaremos los hallazgos que encontramos durante esta primera etapa de nuestro proyecto.

## Introducción

Inicialmente, como grupo buscamos encontrar un tema no sólo que a todos nos gustará, si no que también nos pareciera importante con respecto al contexto social actual en el que estamos.

Durante la última década, hemos visto que la que creíamos buena sociedad moderna, basada en la igualdad y libertad, ha sido expuesta gracias a diversos movimientos sociales de anti-discriminación alrededor del mundo. Uno de los más importantes fue el de Black Lives Matter, en el cual la población afroamericana de Estados Unidos mostró al mundo entero una cultura que los desfavorecía enormemente o directamente no esperaban nada de ellos.

Desde un punto de vista de *data mining*, salta a la vista la pregunta: ¿Se puede hacer un modelo que consiga evidenciar la discriminación en una base de datos?

Para abarcar esta problemática, decidimos enfocarnos en el caso de estudio de COMPAS. En el cual, se encontró que el modelo predictivo COMPAS otorgaba una evaluación de riesgo mayor a personas afroamericanas que al resto. Es decir, que el modelo "discriminaba" a ciertos grupos de personas basadas en su etnia, marcándolas como potencialmente más propensos a cometer un crimen.

## Exploración de datos

### Acercamiento inicial

Dicho esto, procedimos a indagar dentro de la base de datos que se encontraba en el repositorio de COMPAS, donde se encontraron 7 tablas:

1. casearrest, que contiene observaciones sobre los cargos de arrestos de forma sucinta sin más detalles.
2. charge, la cual presenta información sobre los cargos criminales/infracciones en detalle, a diferencia de la anterior, en esta los cargos no se agrupan.
3. compas, que tiene evaluaciones de un cierto tipo de métrica interna de COMPAS.
4. jailhistory, la cual muestra observaciones sobre el periodo carcelario de cada persona enviada a cárcel por el crimen que llevó a cabo el análisis de COMPAS.
5. people, don se encuentra un resumen personal del historial de COMPAS del individuo. Incluyendo cosas como nombre, edad, genero, etnia, crimen que llevó al análisis de COMPAS y en caso de existir, el crimen reincidente (o segundo crimen).
6. prisonhistory, que es similar a la tabla de jailhistory pero es de datos que involucran periodo de prisión en lugar de cárcel. Y por último:
7. summary, la cual no presenta ningún tipo de información relevante.

Debido a las dimensiones y tipos de datos, decidimos empezar el análisis usando los datos de la tabla de people, juntando esta con los datos de prisonhistory y jailhistory.

### Análisis centrado en la tabla people

Para empezar, sería interesante ver como se distribuyen las personas, separadas por sexo, según los deciles dados por la puntuación de COMPAS. Cabe destacar que como COMPAS es propiedad de una entidad privada, su código no esta disponible al público, y, por lo tanto, en la base de dato sólo se tiene información de a que decil corresponde cada persona y una puntuación en crudo sin mucha interpretación posible.

En el gráfico se observa que para las personas de sexo femenino, hay menos casos en general y, comparativamente, hay menos gente en los deciles mayores con respecto al sexo masculino.

Podemos hacer esto mismo, pero en base la etnia de la persona. Donde vemos la clara irregularidad, la mayoría de etnias presentan un gráfico inversamente proporcional: la cantidad decrece conforme el decil aumenta. No es el caso de los afro-americanos y los nativos, donde vemos un comportamiento semi-constante a lo largo de los deciles.

Con esto, queda claro que, al menos, en tema de estadística pura, existe una distinción en el puntaje de los afro-americanos.

Deberíamos ver cosas que condicionan esta situación, una cosa interesante que contiene esta base de datos es la cantidad de personas que vuelven a cometer un crimen, después del primero. Podemos centrarnos en revisar comparar los afro-americanos, con los hispánicos y caucásicos. Ya que estos dos mantiene un comportamiento similar en el anterior gráfico.

Vemos que la cantidad de reincidencia aumenta de manera consistente en el caso de los afro-americanos, con respecto a los caucásicos, donde parece ser más una distribución normal.

Siguiendo con esto, podemos ver ahora como se distribuyen las edades de los criminales. En el siguiente gráfico se puede observar que los afro-americanos tienen una cantidad de personas mucho más joven que el resto de etnias, rondando la mediana los 33 años. Esto es importante, puesto que en este otro gráfico podemos ver que a medida que aumenta el decil de la puntuación, la edad también disminuye.

### Análisis centrado en la tabla charge

Para terminar con el análisis podemos tomar la tabla charge, y analizar los cargos menores o sin detalles según la etnia, donde vemos que existe una ligera diferencia en comparación con los otros cargos, en particular, la razón entre la cantidad de afro-americanos y caucásicos para los cargos menores es de un 60 y 20% del total, respectivamente, mientras que para los cargos más serios es de un 60 y 30%.

## Preguntas y Problemas

Una vez dicho esto, habiendo analizado los parámetros más importantes de la base de datos, saltan a la mente unas cuantas preguntas, yendo por partes:

- ¿Por qué la distribución de los afro-americanos es tan uniforme?

Resulta intrigante ver que COMPAS otorga una puntuación casi perfectamente distribuida. Esto se puede ver como un claro indicio de racismo del modelo, puesto que ocurre solo para los afro-americanos, podríamos hacer el ejercicio opuesto y ver si mediante los deciles y el puntaje en crudo se pueda predecir al etnia de una persona.

- ¿Los afro-americanos son más propensos a volver a cometer un crimen?

Tal vez no es que la modelo sea racista, quizás como existe una relación tan particular podríamos obtener resultados similares a los de COMPAS usando la reincidencia en vez de la etnia de la persona, si este es el caso, realmente sería complejo hablar de que el modelo es racista, puesto que es consecuencia de otro parámetro. Con lo cual podríamos centrarnos en encontrar otro grupo que posea la misma curva de reincidencia.

- La importancia de la edad

Algo que pasa desapercibido a primera vista, es que tanto importa la edad a la hora de hacer estos análisis de crímenes, como vimos, la mayoría de criminales afro-americanos tiene una menor edad con respecto a las otras etnias. A su vez, los deciles más altos del puntaje de COMPAS, también corresponden con gente más joven. Es posible hacer lo mismo que lo anterior pero con la edad: reemplazar la etnia y ver los resultados. Mientras más relaciones podemos hacer de peso entre variables no relacionadas con la etnia y el puntaje de COMPAS, tendremos más formas de poder abarcar la problemática.

- Género e ingresos

Algo que no hemos profundizado mucho en esta primera etapa, es el análisis a través del sexo del sujeto. Es algo a tener en cuenta para poder ver si sólo ocurre discriminación a nivel étnico o también existe a nivel de género. Ahora sólo alcanzamos a ver una pincelada de esto y el análisis mostró que podría existir. Adicionalmente, notamos que esta base de datos no contiene en nivel socio-económico del sujeto, asi como el nivel educativo, sería un esfuerzo mayor poder cruzar otra base de datos para obtener estos datos, pero de poder lograrlo se conseguiría un mayor entendimiento. 

## Conclusión

Queda claro el camino a seguir para nosotros, debemos enfocarnos en entender mejor como se otorgo el puntaje en base a aspectos únicamente criminales, para asi ver como se distribuyen estos antecedentes con respecto a la edad, el sexo, la etnia e incluso, si es posible, los ingresos. 

Por lo que, la idea es analizar si es que se puede omitir la etnia y obtener resultados similares, o en caso contrario, enmascarar las la variable. Es decir, poder sacar de la variable etnia, otras etiquetas que estén bajo menos prejuicios, aunque esto podría verse como poco ético.

Finalmente, es importante notar que, a pesar de que hablamos de un modelo discriminatorio, la verdad es que un modelo toma las etiquetas para precisamente crear nuevas etiquetas. El tema de fondo es que los propios datos que son usados para entrenar al modelo están contaminados por una cultura y sociedad que categoriza y prejuicia a las personas. Como analistas de datos a priori lo único que podemos hacer es omitir o esconder dicho prejuicio del modelo, por lo menos hasta que la situación se normalize. Al final, parte de la gracia de los modelos más avanzados de predicción, es decir, los de machine learning, es que estos son capaces de identificar correlaciones entre datos que no aparentan estar relacionados.

Con esto concluye nuestra presentación, gracias por su atención
