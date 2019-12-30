# -*- coding: utf-8 -*-
"""
Created on Sun Dec  8 22:26:09 2019

@author: Ali
"""

###############################################################################

""
import matplotlib.pyplot as plt
from   sklearn.model_selection import train_test_split
import numpy as np

from keras.utils      import  np_utils
from keras.models     import  Sequential
from keras.layers     import  Dense
from keras.losses     import  categorical_crossentropy
from keras.optimizers import  adam

DATASET   = "D:\\Power_dataset.csv"
TARGETFILE = "D:\\TrainLabels.csv"
LABELFILE = "D:\\Targets.csv"
LEN = int(4392); # 

L1 = int(50*8.333)
L2 = int(105*8.333)
L3 = int(207*8.333)
L4 = int(320*8.333)
seed = 9

X       = np.loadtxt(DATASET, delimiter=",")
X_abs   = np.absolute(X)
#X_red   = np.concatenate((X[:,0:L1],X[:,L2:L3],X[:,L4:LEN-1]),axis=1)
X_red   = np.concatenate((X_abs[:,0:L1],X_abs[:,L2:L3],X_abs[:,L4:LEN-1]),axis=1)
y_array = np.loadtxt(TARGETFILE, delimiter=",")
y       = np_utils.to_categorical(y_array)

X_train, X_test, y_train,y_test = train_test_split(X_red,y, test_size=0.1, random_state=seed)

Length = X_red.shape[1]

#### Creating Model

My_model = Sequential()
My_model.add(Dense( Length, activation='relu',input_shape=(Length,)) )
My_model.add(Dense(int(Length/3), activation='relu'))
My_model.add(Dense(int(Length/9), activation='relu'))
My_model.add(Dense(int(Length/27), activation='relu'))
My_model.add(Dense(int(Length/81), activation='relu'))
My_model.add(Dense(9, activation='softmax'))
My_model.summary()
My_model.compile(optimizer=adam(), loss=categorical_crossentropy, metrics=['accuracy'] )
################################################################################################

################################# training Model ###############################################
Network_history = My_model.fit(X_red,y, epochs=120, validation_split=0.2)
history = Network_history.history
losses = history['loss']
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