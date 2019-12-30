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
X_train, X_test, y_train,y_test = train_test_split(X_abs,y, test_size=0.1, random_state=seed)
######################################## Linear Model ###############################
svclassifier = SVC(kernel='linear', gamma='auto', decision_function_shape='ovo')
svclassifier.fit(X_train, y_train)
y_pred = svclassifier.predict(X_test)
print ("###########################Linear Model")
print(confusion_matrix(y_test,y_pred))
print(classification_report(y_test,y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
print("##################################################")

######################################## Polynomial model ##############################
svclassifier = SVC(kernel='poly', degree=8, gamma='auto', decision_function_shape='ovo')
svclassifier.fit(X_train, y_train)
y_pred = svclassifier.predict(X_test)
print ( "###########################Polynomial model")
print(confusion_matrix(y_test, y_pred))
print(classification_report(y_test, y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
print("##################################################")
######################################## Gaussian Model ################################
svclassifier = SVC(kernel='rbf', gamma='auto', decision_function_shape='ovo')
svclassifier.fit(X_train, y_train)
y_pred = svclassifier.predict(X_test)
print ("###########################Gaussian Model")
print(confusion_matrix(y_test, y_pred))
print(classification_report(y_test, y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
print("##################################################")
########################################## Sigmoid Model ################################
svclassifier = SVC(kernel='sigmoid', gamma='auto', decision_function_shape='ovo')
svclassifier.fit(X_train, y_train)
y_pred = svclassifier.predict(X_test)
print(metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print ("###########################Sigmoid Model")
print(confusion_matrix(y_test, y_pred))
print(classification_report(y_test, y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
print("##################################################")
X_train, X_test, y_train,y_test = train_test_split(X_scaled,y, test_size=0.1, random_state=seed)
svclassifier = LinearSVC()
svclassifier.fit(X_train,y_train)
y_pred = svclassifier.predict(X_test)
print(metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print ("###########################Linear SVC Model")
print(confusion_matrix(y_test, y_pred))
print(classification_report(y_test, y_pred))
print("F1 score  is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is : %.3f" %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy  is : %.3f" %metrics.accuracy_score(y_test,y_pred))

       

My_model.save("D:\\CONV1D_Model.h5")
My_model.save_weights("D:\\CONV1D_Model_weights.h5")