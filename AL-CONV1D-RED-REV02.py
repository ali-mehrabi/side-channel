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
from   keras.utils import np_utils, plot_model
from   keras.models import Sequential, Model
from   keras.layers import Dense, Dropout, Conv1D, MaxPool1D, Flatten, AveragePooling1D, Input
from   keras.losses import categorical_crossentropy
from   keras.optimizers import SGD, adam
from   keras            import  callbacks as cb


DATASET    = "D:\\Dataset2.csv"
TARGETFILE = "D:\\Y2.csv"

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
y_array    = np.loadtxt(TARGETFILE, delimiter=",")
y          = np_utils.to_categorical(y_array)
LS         = 834
RS         = 2500 
X2         = np.absolute(X_scaled)
XX         = np.expand_dims(X2, axis=2)
################################## Creating Model##########################################
X_train, X_test, y_train,y_test = train_test_split(XX,y, test_size=0.2, random_state=seed)
y_test     = y_test.astype('int')
#######################################################################################
######################### Parameters ##################################################
epochs     = 80
batch_size = 20 #X_train.shape[0]
channels   = 1
verbose    = 0 
n_samples, n_features, n_outputs = X.shape[0], X.shape[1], y_train.shape[1]


########################################################################################
My_Input  = Input(shape=(n_features,1))
Conv1     = Conv1D(filters=549, kernel_size=16,  strides= 8, activation='relu')(My_Input)
Conv2     = Conv1D(filters=61, kernel_size=8, strides= 4, activation='relu')(Conv1)
#Conv3     = Conv1D(filters=180, kernel_size=10, strides= 2, activation='relu')(Conv2)
AVG1      = AveragePooling1D()(Conv2)
Conv3     = Conv1D(filters=61, kernel_size=8, strides= 1, activation='relu')(AVG1)
Pool1     = MaxPool1D(pool_size=2)(Conv3)
Conv4     = Conv1D(filters=27,  kernel_size=8, strides= 1, activation='relu')(Pool1)
Flat1     = Flatten()(Conv4)
Out_layer = Dense(9,   activation='softmax')(Flat1)
My_model  = Model(My_Input, Out_layer)
My_model.summary()
My_model.compile(optimizer=adam(), loss=categorical_crossentropy, metrics=['accuracy'] )

plot_model(My_model, to_file='D:\\CONV1D_model.png' ,show_shapes=True, show_layer_names=True)
logger           = cb.CSVLogger("D:\\CONV1D_logger.log")
model_checkpoint = cb.ModelCheckpoint("D:\\CONV1D_Model.h5")
tensorboard      = cb.TensorBoard(log_dir="D:\\LOGS") 
call_backs = [ logger,model_checkpoint, tensorboard ]
################################################################################################

## training Model
Network_history = My_model.fit(XX,y, epochs=epochs, validation_data=(X_test,y_test), callbacks=call_backs)
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
plt.figure()
plt.xlabel('Epochs')
plt.ylabel('losses, val_losses')
plt.plot(history['loss'])
plt.plot(history['val_loss'])
plt.legend(['loss', 'val_loss'])
#################################################################################################
plt.figure()
plt.xlabel('Epochs')
plt.ylabel('accuracy, val_accuracy')
plt.plot(history['accuracy'])
plt.plot(history['val_accuracy'])
plt.legend(['accuracy', 'val_accuracy'])

### evaluate model 
test_loss, test_accuracy = My_model.evaluate(XX,y)
print(My_model.metrics_names[1], test_accuracy*100)
print(My_model.metrics_names[0], test_loss)
#test_labels_predict = My_model.predict(X_test)
#test_labels_predict = np.argmax(test_labels_predict, axis=1)


