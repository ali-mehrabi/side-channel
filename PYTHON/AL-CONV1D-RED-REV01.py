# -*- coding: utf-8 -*-
"""
Created on Fri Dec  6 11:43:20 2019

@author: Ali
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from   sklearn.model_selection import train_test_split
from   sklearn.preprocessing   import StandardScaler
from   keras.utils import np_utils
from   keras.models import Sequential, Model
from   keras.layers import Dense, Dropout, Conv1D, MaxPool1D, Flatten, AveragePooling1D, Input
from   keras.losses import categorical_crossentropy
from   keras.optimizers import SGD, adam

DATASET   = "D:\\Power_dataset.csv"
TARGETFILE = "D:\\TrainLabels.csv"
LABELFILE = "D:\\Targets.csv"
LEN = int(4392); # 

#X = pd.read_csv(DATASET)
#y = pd.read_csv(LABELFILE)
#y_array    = np.array(y)

X_array    = np.loadtxt(DATASET, delimiter=",")
X_abs      = np.absolute(X_array)
y_array    = np.loadtxt(TARGETFILE, delimiter=",")

Scaler     = StandardScaler()
XX         = Scaler.fit_transform(X_array)
################################## Creating Model##########################################
seed       = 9
XX_abs     = np.expand_dims(X_abs, axis=2)
XX         = np.expand_dims(X_array, axis=2) ### X_array or X_absolute
yy         = np_utils.to_categorical(y_array)
X_train, X_test, y_train,y_test = train_test_split(XX_array,yy, test_size=0.15, random_state=seed)
#X_train    = X_train.astype('float32')
#X_test     = X_test.astype('float32')
y_test     = y_test.astype('int')
#######################################################################################
######################### Parameters ##################################################
epochs     = 100 
batch_size = 20 #X_train.shape[0]
channels   = 1
verbose    = 0 
n_samples, n_features, n_outputs = X_array.shape[0], X_array.shape[1], y_train.shape[1]
########################################################################################
My_Input = Input(shape=(n_features,1))
Conv1     = Conv1D(filters=549, kernel_size=16,  strides= 8, activation='relu')(My_Input)
Conv2     = Conv1D(filters=61, kernel_size=8, strides= 4, activation='relu')(Conv1)
#Conv3     = Conv1D(filters=180, kernel_size=10, strides= 2, activation='relu')(Conv2)
AVG1      = AveragePooling1D()(Conv2)
Conv3     = Conv1D(filters=61, kernel_size=8, strides= 1, activation='relu')(AVG1)
Pool1     = MaxPool1D(pool_size=2)(Conv3)
Conv4     = Conv1D(filters=27,  kernel_size=8, strides= 1, activation='relu')(Pool1)
Flat1     = Flatten()(Conv4)
#Dense1    = Dense(90, activation='relu')(Flat1)
#Dense2    = Dense(90, activation='relu')(Dense1)
#Dense3    = Dense(90,  activation='relu')(Dense2)
Out_layer = Dense(9,   activation='softmax')(Flat1)
My_model  = Model(My_Input, Out_layer)
My_model.summary()
My_model.compile(optimizer=adam(), loss=categorical_crossentropy, metrics=['accuracy'] )
################################################################################################

## training Model
Network_history = My_model.fit(XX,yy, epochs=epochs, validation_data=(X_test,y_test))
history = Network_history.history

##############################plot loss and accuracy ###########################################
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

##########################################################################
### evaluate model 
test_loss, test_accuracy = My_model.evaluate(XX,yy)
print(My_model.metrics_names[1], test_accuracy*100)
print(My_model.metrics_names[0], test_loss)
#test_labels_predict = My_model.predict(X_test)
#test_labels_predict = np.argmax(test_labels_predict, axis=1)


