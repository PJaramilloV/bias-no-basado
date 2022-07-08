# -------------- markdown
# Referencias

https://towardsdatascience.com/feature-selection-with-pandas-e3690ad8504b

# ---------------- code

from sklearn.datasets import load_boston
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.feature_selection import RFE


casearrest = pd.read_csv('../data/cleaned/casearrest_cl.csv', index_col=0)
jailhistory = pd.read_csv('../data/cleaned/jailhistory_cl.csv', index_col=0)
people = pd.read_csv('../data/cleaned/people_cl.csv', index_col=0)
prisonhistory = pd.read_csv('../data/cleaned/prisonhistory_cl.csv', index_col=0)
charge = pd.read_csv('../data/cleaned/charge_cl.csv', index_col=0)


def get_best_features(df, target):
    n_of_features = np.arange(1, df.shape[1])
    high_score = 0
    nof = 0
    score_list = []
    for n in n_of_features:
        X_train, X_test, y_train, y_test = train_test_split(df, target, test_size = 0.3, random_state = 0)
        model = LinearRegression()
        rfe = RFE(model, n)
        X_train_rfe = rfe.fit_transform(X_train, y_train)
        X_test_rfe = rfe.transform(X_test)
        model.fit(X_train_rfe, y_train)
        score = model.score(X_test_rfe, y_test)
        score_list.append(score)
        if(score>high_score):
            high_score = score
            nof = n
    return nof, high_score, score_list


# Casearrest
casearrest_X = casearrest.drop(['decile_score'], axis='columns')
casearrest_y = casearrest['decile_score']
nof, high_score, score_list = get_best_features(casearrest_X, casearrest_y)
print('Casearrest:')
print('N of features:', nof)
print('High score:', high_score)
print('Score list:', score_list)


dataset2["sex"] = np.where(dataset2["sex"]=='Male',1,0) 
dataset2[dataset2.columns[1:-9]]