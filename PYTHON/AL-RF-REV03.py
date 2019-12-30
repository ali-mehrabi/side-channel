# -*- coding: utf-8 -*-
"""
Created on Mon Dec  9 20:03:31 2019

@author: Ali
"""

#import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from   sklearn import  metrics 
from   sklearn.model_selection import train_test_split
from   sklearn.ensemble import RandomForestClassifier
from   sklearn.metrics  import classification_report, confusion_matrix 
from   sklearn          import preprocessing  as pp 
from   sklearn.datasets import make_classification
DATASET    = "D:\\Dataset2.csv"
TARGETFILE = "D:\\Y2.csv"

U          = 199104             #  24888*int(SP)
FRAME      = 4384
DFRAME     = 1310               #
WINDOW     = 2600 
seed       = 9
X          = np.loadtxt(DATASET, delimiter=",")
X          = X[:,0:WINDOW]
Length     = X.shape[1]
scaler     = pp.MaxAbsScaler()
X_scaled   = scaler.fit_transform(X)
X_abs      = np.absolute(X_scaled)
y          = np.loadtxt(TARGETFILE, delimiter=",")

X_train, X_test, y_train,y_test = train_test_split(X_abs,y, test_size=0.2, random_state=None)
################################## Creating Model##########################################
rfc = RandomForestClassifier(n_estimators=90, criterion='entropy', max_depth=90,n_jobs=-1 )
rfc.fit(X_train, y_train)
y_pred = rfc.predict(X_test)
print ("###########################RFC, n_stimator = 90, entropy, max_depth =90")
#print(confusion_matrix(y_test,y_pred))
#print(classification_report(y_test,y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
#classification_report(y_test, y_pred)
print("##################################################")
rfc = RandomForestClassifier(n_estimators=900, criterion='entropy', max_depth=900,n_jobs=-1 )
rfc.fit(X_train, y_train)
y_pred = rfc.predict(X_test)
print ("###########################RFC, n_stimator = 900, entropy, max_depth =900")
#print(confusion_matrix(y_test,y_pred))
#print(classification_report(y_test,y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
#classification_report(y_test, y_pred)
print("##################################################")
rfc = RandomForestClassifier(n_estimators=1300, criterion='entropy', max_depth=1300,n_jobs=-1 )
rfc.fit(X_train, y_train)
y_pred = rfc.predict(X_test)
print ("###########################RFC, n_stimator = 1300, entropy, max_depth =1300")
#print(confusion_matrix(y_test,y_pred))
#print(classification_report(y_test,y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
#classification_report(y_test, y_pred)
print("##################################################") 
      
rfc = RandomForestClassifier(n_estimators=90, criterion='entropy', max_depth=900,n_jobs=-1 )
rfc.fit(X_train, y_train)
y_pred = rfc.predict(X_test)
print ("###########################RFC, n_stimator = 90, entropy, max_depth =900")
#print(confusion_matrix(y_test,y_pred))
#print(classification_report(y_test,y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
#classification_report(y_test, y_pred)
print("##################################################")      
      
rfc = RandomForestClassifier(n_estimators=90, criterion='entropy', max_depth=1300,n_jobs=-1 )
rfc.fit(X_train, y_train)
y_pred = rfc.predict(X_test)
print ("###########################RFC, n_stimator = 90, entropy, max_depth =1300")
#print(confusion_matrix(y_test,y_pred))
#print(classification_report(y_test,y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
#classification_report(y_test, y_pred)
print("##################################################")

rfc = RandomForestClassifier(n_estimators=900, criterion='entropy', max_depth=90,n_jobs=-1 )
rfc.fit(X_train, y_train)
y_pred = rfc.predict(X_test)
print ("###########################RFC, n_stimator = 900, entropy, max_depth =90")
#print(confusion_matrix(y_test,y_pred))
#print(classification_report(y_test,y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
#classification_report(y_test, y_pred)
print("##################################################")  
rfc = RandomForestClassifier(n_estimators=900, criterion='entropy', max_depth=1300,n_jobs=-1 )
rfc.fit(X_train, y_train)
y_pred = rfc.predict(X_test)
print ("###########################RFC, n_stimator = 900, entropy, max_depth =1300")
#print(confusion_matrix(y_test,y_pred))
#print(classification_report(y_test,y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
#classification_report(y_test, y_pred)
print("##################################################")  

rfc = RandomForestClassifier(n_estimators=1300, criterion='entropy', max_depth=90,n_jobs=-1 )
rfc.fit(X_train, y_train)
y_pred = rfc.predict(X_test)
print ("###########################RFC, n_stimator = 1300, entropy, max_depth =90")
#print(confusion_matrix(y_test,y_pred))
#print(classification_report(y_test,y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
#classification_report(y_test, y_pred)
print("##################################################")  
rfc = RandomForestClassifier(n_estimators=1300, criterion='entropy', max_depth=900,n_jobs=-1 )
rfc.fit(X_train, y_train)
y_pred = rfc.predict(X_test)
print ("###########################RFC, n_stimator = 1300, entropy, max_depth =900")
#print(confusion_matrix(y_test,y_pred))
#print(classification_report(y_test,y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
#classification_report(y_test, y_pred)
print("##################################################")        
rfc = RandomForestClassifier(n_estimators=270, criterion='entropy', max_depth=270,n_jobs=-1 )
rfc.fit(X_train, y_train)
y_pred = rfc.predict(X_test)
print ("###########################RFC, n_stimator = 90, entropy, max_depth =900")
#print(confusion_matrix(y_test,y_pred))
#print(classification_report(y_test,y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
#classification_report(y_test, y_pred)
print("##################################################")      
      
 ################################  reduced window  ######################################     
Xp         = X[:,1050:1550]
scaler     = pp.MaxAbsScaler()
Xp_scaled   = scaler.fit_transform(Xp)
Xp_abs      = np.absolute(X_scaled)
Xp_train, Xp_test, y_train,y_test = train_test_split(Xp_abs,y, test_size=0.2, random_state=None)

rfc = RandomForestClassifier(n_estimators=270, criterion='entropy', max_depth=270 ,n_jobs=-1 )
rfc.fit(Xp_train, y_train)
y_pred = rfc.predict(Xp_test)

print ("###########################RFC, n_stimator = 270, entropy, max_depth =270")
#print(confusion_matrix(y_test,y_pred))
#print(classification_report(y_test,y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
#classification_report(y_test, y_pred)
print("##################################################")  
      
      
rfc = RandomForestClassifier( criterion='entropy', n_jobs=-1 )
rfc.fit(X_train, y_train)
y_pred = rfc.predict(X_test)
print ("###########################RFC, n_stimator = 9, entropy, max_depth =90")
#print(confusion_matrix(y_test,y_pred))
#print(classification_report(y_test,y_pred))
print("F1 score is : %.3f" %metrics.f1_score(y_test, y_pred, average='weighted',labels=np.unique(y_pred)))
print("precision is: %.3f " %metrics.precision_score(y_test,y_pred, average='weighted'))
print("Accuracy is : %.3f" %metrics.accuracy_score(y_test,y_pred))
#classification_report(y_test, y_pred)
print("##################################################")
      
      