# -*- coding: utf-8 -*-
"""
Created on Sun Dec 22 19:04:38 2019

@author: Ali
"""

# -*- coding: utf-8 -*-
"""
Created on Mon Dec  9 13:28:20 2019

@author: Ali
"""
#import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from   sklearn.model_selection import train_test_split
from   sklearn.svm     import SVC, LinearSVC
from   sklearn         import preprocessing  as pp 
from   sklearn.metrics import classification_report, confusion_matrix
from   sklearn         import metrics 

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

################################## Creating Model##########################################
X_train, X_test, y_train,y_test = train_test_split(X_abs,y, test_size=0.2, random_state=seed)


######################################## Polynomial model ##############################
svclassifier = SVC(kernel='poly', degree=7, gamma='auto', decision_function_shape='ovo')
svclassifier.fit(X_train, y_train)
y_pred = svclassifier.predict(X_test)
print ( "###########################Polynomial model")
print(confusion_matrix(y_test, y_pred))
print(classification_report(y_test, y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
print("##################################################")
      
      ######################################## Polynomial model ##############################
svclassifier = SVC(kernel='poly', degree=9, gamma='auto', decision_function_shape='ovo')
svclassifier.fit(X_train, y_train)
y_pred = svclassifier.predict(X_test)
print ( "###########################Polynomial model")
print(confusion_matrix(y_test, y_pred))
print(classification_report(y_test, y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
print("##################################################")

######################################## Polynomial model ##############################
svclassifier = SVC(kernel='poly', degree=11, gamma='auto', decision_function_shape='ovo')
svclassifier.fit(X_train, y_train)
y_pred = svclassifier.predict(X_test)
print ( "###########################Polynomial model")
print(confusion_matrix(y_test, y_pred))
print(classification_report(y_test, y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
print("##################################################")

######################################## Polynomial model ##############################
svclassifier = SVC(kernel='poly', degree=17, gamma='auto', decision_function_shape='ovo')
svclassifier.fit(X_train, y_train)
y_pred = svclassifier.predict(X_test)
print ( "###########################Polynomial model")
print(confusion_matrix(y_test, y_pred))
print(classification_report(y_test, y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
print("##################################################")
