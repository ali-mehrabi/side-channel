# -*- coding: utf-8 -*-
"""
Created on Mon Dec  9 20:03:31 2019

@author: Ali
"""

#import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from   sklearn.model_selection import train_test_split
from   sklearn.ensemble import RandomForestClassifier
from   sklearn.metrics import classification_report, confusion_matrix 
from   sklearn         import preprocessing  as pp 
DATASET    = "D:\\Dataset2.csv"
TARGETFILE = "D:\\Y2.csv"
#DATASET    = "D:\\PowerDataset.csv"
#TARGETFILE = "D:\\TrainLabels.csv"
#LABELFILE  = "D:\\Targets.csv"
U          = 199104             #  24888*int(SP)
FRAME      = 4384
DFRAME     = 1310               #
WINDOW     = 2600 
seed       = 9
X          = np.loadtxt(DATASET, delimiter=",")
X          = X[:, 0:WINDOW]
Length     = X.shape[1]
scaler     = pp.MaxAbsScaler()
X_scaled   = scaler.fit_transform(X)
X_abs      = np.absolute(X_scaled)
y          = np.loadtxt(TARGETFILE, delimiter=",")

#X_red   = np.concatenate((X_abs[:,0:L1],X_abs[:,L2:L3],X_abs[:,L4:LEN-1]),axis=1)
################################## Creating Model##########################################
X_train, X_test, y_train,y_test = train_test_split(X_abs,y, test_size=0.2, random_state=seed)
rfclassifier = RandomForestClassifier(n_estimators=2600, criterion='entropy', max_depth=90,n_jobs=-1 )
rfclassifier.fit(X_train, y_train)
y_pred = rfclassifier.predict(X_test)
print ("###########################Linear Model")
print(confusion_matrix(y_test,y_pred))
print(classification_report(y_test,y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
classification_report(y_test, y_pred)
print("##################################################")
print("##################################################")
rfclassifier = RandomForestClassifier(n_estimators='warn', criterion='entropy', max_depth=6561,max_features=2600, n_jobs=-1 )
rfclassifier.fit(X_train, y_train)
y_pred = rfclassifier.predict(X_test)
print ("###########################Linear Model")
print(confusion_matrix(y_test,y_pred))
print(classification_report(y_test,y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
classification_report(y_test, y_pred)
print("##################################################")
      
rfclassifier = RandomForestClassifier(n_estimators=1300, criterion='entropy', max_depth=6561 ,max_features=2600, min_samples_split=10, n_jobs=-1 )
rfclassifier.fit(X_train, y_train)
y_pred = rfclassifier.predict(X_test)
print ("###########################Linear Model")
print(confusion_matrix(y_test,y_pred))
print(classification_report(y_test,y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
classification_report(y_test, y_pred)
print("##################################################")      