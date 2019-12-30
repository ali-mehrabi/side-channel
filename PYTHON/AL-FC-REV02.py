# -*- coding: utf-8 -*-
"""
Created on Sun Dec  8 22:26:09 2019

@author: Ali
"""

###############################################################################
import numpy as np
import matplotlib.pyplot as plt
from   sklearn.model_selection import train_test_split
from   sklearn          import preprocessing  as pp 
from   keras.utils      import  np_utils
from   keras.models     import  Sequential
from   keras.layers     import  Dense
from   keras.losses     import  categorical_crossentropy
from   keras.optimizers import  adam

DATASET    = "D:\\PowerDataset.csv"
TARGETFILE = "D:\\TrainLabels.csv"
LABELFILE  = "D:\\Targets.csv"
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
X_abs      = np.absolute(X)
y_array = np.loadtxt(TARGETFILE, delimiter=",")
y       = np_utils.to_categorical(y_array)

X_train, X_test, y_train,y_test = train_test_split(X_scaled,y, test_size=0.1, random_state=seed)

#### Creating Model

My_model = Sequential()
My_model.add(Dense(int(Length/2),  activation='relu',input_shape=(Length,)) )
My_model.add(Dense(int(Length/4),  activation='relu'))
My_model.add(Dense(int(Length/8),  activation='relu'))
My_model.add(Dense(int(Length/40), activation='relu'))
My_model.add(Dense(9, activation='softmax'))
My_model.summary()
My_model.compile(optimizer=adam(), loss=categorical_crossentropy, metrics=['accuracy'] )
################################################################################################

################################# training Model ###############################################
Network_history = My_model.fit(X,y, epochs=220, validation_split=0.1)
history  = Network_history.history
losses   = history['loss']
accuracy = history['accuracy']
##############################Plot loss and accuracy ###########################################
losses   = history['loss']
accuracy = history['accuracy']
plt.figure()
plt.xlabel('Epochs')
plt.ylabel('losses, accuracy')
plt.plot(losses)
plt.plot(accuracy)
plt.legend(['loss','accuracy'])#
plt.figure()
plt.xlabel('Epochs')
plt.ylabel('val_losses, val_accuracy')
plt.plot(history['val_loss'])
plt.plot(history['val_accuracy'])
plt.legend(['val_loss', 'val_acc'])
#################################################################################################
######################################### evaluate model ######################################## 
test_loss, test_accuracy = My_model.evaluate(X_test,y_test)
test_labels_predict = My_model.predict(X_test)
test_labels_predict = np.argmax(test_labels_predict, axis=1)
print(My_model.metrics_names[1], test_accuracy*100)
print(My_model.metrics_names[0], test_loss)