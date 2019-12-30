# -*- coding: utf-8 -*-
"""
Created on Thu Dec  5 19:21:09 2019

@author: Ali
"""

###############################################################################
import numpy as np
import matplotlib.pyplot as plt
from   sklearn.model_selection import train_test_split
from   sklearn.neighbors import KNeighborsClassifier
from   sklearn.metrics import classification_report, confusion_matrix
from   sklearn import  metrics 
from   sklearn         import preprocessing  as pp 


DATASET    = "D:\\Dataset2.csv"
TARGETFILE = "D:\\Y2.csv"

#DATASET    = "D:\\Power_dataset.csv"
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
KNNclassifier = KNeighborsClassifier(n_neighbors=9, weights= 'uniform', algorithm='auto', leaf_size=243, metric= 'minkowski',n_jobs=-1 )
KNNclassifier.fit(X_train, y_train)
y_pred = KNNclassifier.predict(X_test)
print ("###########################Linear Model")
print(confusion_matrix(y_test,y_pred))
print(classification_report(y_test,y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
print("##################################################")
'''
k_range = range(1,20)
scores = np.array(range(20))
scores_list = []

for k in k_range:
    knn = KNeighborsClassifier(n_neighbors=9, weights= 'uniform', algorithm='auto', leaf_size=243, metric= 'minkowski',n_jobs=-1)
    knn.fit(X_train,y_train)
    y_pred = knn.predict(X_test)
    scores[k] = metrics.accuracy_score(y_test,y_pred)
    scores_list.append(metrics.accuracy_score(y_test,y_pred))   
plt.plot(k_range,scores_list)
plt.xlabel("Value of k for KNN")
plt.ylabel("Testing accuracy")
'''
KNNclassifier = KNeighborsClassifier(n_neighbors=3, weights= 'uniform', algorithm='auto', leaf_size=90, metric= 'minkowski',n_jobs=-1 )
KNNclassifier.fit(X_train, y_train)
y_pred = KNNclassifier.predict(X_test)
print ("###########################Linear Model")
print(confusion_matrix(y_test,y_pred))
print(classification_report(y_test,y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))     