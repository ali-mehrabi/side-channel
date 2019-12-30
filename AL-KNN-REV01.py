# -*- coding: utf-8 -*-
"""
Created on Wed Dec  4 17:42:19 2019

@author: Ali
"""
import matplotlib.pyplot as plt
from   sklearn.neighbors import KNeighborsClassifier
import sklearn.svm as svm
from   sklearn.model_selection import train_test_split
from   sklearn.preprocessing import label_binarize
from   sklearn import metrics
import pandas as pd
import numpy as np

DATASET   = "D:\\Power_dataset.csv"
LABELFILE = "D:\\TrainLabels.csv"
LEN = int(4392); # 
k_range= range(1,20)
scores ={}
scores_list = []

X = pd.read_csv(DATASET)
y = pd.read_csv(LABELFILE)
y = label_binarize(y, classes=[0, 1, 2, 3, 4, 5, 6, 7, 8])
X_train, X_test, y_train,y_test = train_test_split(X,y, test_size=0.15, random_state=4)

for k in k_range:
    knn = KNeighborsClassifier(n_neighbors=20, metric='euclidean', weights='uniform')
    knn.fit(X_train,y_train)
    y_pred = knn.predict(X_test)
    scores[k] = metrics.accuracy_score(y_test,y_pred)
    scores_list.append(metrics.accuracy_score(y_test,y_pred))
    
plt.plot(k_range,scores_list)
plt.xlabel("Value of k for KNN")
plt.ylabel("Testing accuracy")


SVM = svm.SVC(kernel='linear') # Linear Kernel
SVM.fit(X_train, y_train)
y_pred = SVM.predict(X_test)
SVM.fit()
print("Accuracy:",metrics.accuracy_score(y_test, y_pred))
print("Precision:",metrics.precision_score(y_test, y_pred))

plt.plot(k_range,scores_list)
plt.xlabel("Value of k for KNN")
plt.ylabel("Testing accuracy")