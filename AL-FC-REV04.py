# -*- coding: utf-8 -*-
"""
Created on Sun Dec  8 22:26:09 2019

@author: Ali
in rev 4 the dataset increased to 500 rows for each D/A probablity 
"""
###############################################################################
import numpy as np
import matplotlib.pyplot as plt
from   sklearn.model_selection import train_test_split
from   sklearn          import preprocessing  as pp 
from   keras.utils      import  np_utils, plot_model
from   keras.models     import  Sequential
from   keras.layers     import  Dense, Dropout
from   keras.losses     import  categorical_crossentropy,mean_squared_error, categorical_hinge,sparse_categorical_crossentropy 
from   keras.optimizers import  adam
from   keras            import  callbacks as cb
DATASET    = "D:\\Dataset2.csv"
TARGETFILE = "D:\\Y2.csv"
U          = 199104             #  24888*int(SP)
FRAME      = 4384
DFRAME     = 1310               #
WINDOW     = 2600 
seed       = 4500
X          = np.loadtxt(DATASET, delimiter=",")
X          = X[:, 0:WINDOW]
scaler     = pp.MaxAbsScaler()
X_scaled   = scaler.fit_transform(X)
X_abs      = np.absolute(X)
y_array    = np.loadtxt(TARGETFILE, delimiter=",")
y          = np_utils.to_categorical(y_array)
LS         = 834
RS         = 4500 
X2         = np.absolute(X_scaled)
Length     = X.shape[1]
#X_train, X_test, y_train,y_test = train_test_split(X2,y, test_size=0.1, random_state=seed)


My_model = Sequential()
My_model.add(Dense(int(Length/4),   activation='relu',input_shape=(Length,)))
My_model.add(Dense(int(Length/16),   activation='relu'))
My_model.add(Dense(int(Length/32),   activation='relu'))
My_model.add(Dropout(rate=0.4))
My_model.add(Dense(int(Length/64),  activation='relu'))
My_model.add(Dense(int(Length/128),  activation='relu'))
#My_model.add(Dense(int(Length/64),  activation='relu'))
#My_model.add(Dense(int(Length/128), activation='relu'))
My_model.add(Dense(9, activation='softmax'))
My_model.summary()
My_model.compile(optimizer=adam(), loss=categorical_crossentropy, metrics=['accuracy'] )
################################################################################################
plot_model(My_model, to_file='D:\\FC_model.png' ,show_shapes=True, show_layer_names=True)
logger           = cb.CSVLogger("D:\\logger.log")
model_checkpoint = cb.ModelCheckpoint("D:\\Model.h5")
tensorboard      = cb.TensorBoard(log_dir="D:\\LOGS") 
call_backs = [ logger,model_checkpoint, tensorboard ]
################################# training Model ###############################################
Network_history = My_model.fit(X2,y, epochs=200, validation_split=0.15, batch_size=45, callbacks=call_backs)
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
##############################plot loss and accuracy ###########################################

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
#################################################################################################


plt.figure()
plt.xlabel('Epochs')
plt.ylabel('losses, accuracy, val_losses, val_accuracy')
plt.plot(losses, marker='o', color = 'b')
plt.plot(history['val_loss'], marker='s', color = 'orange')
plt.plot(accuracy, marker = '^', color = 'g')
plt.plot(history['val_accuracy'], marker='d', color='r')
plt.legend(['loss','val_loss', 'accuracy', 'val_acc'])#
#################################################################################################
plt.figure()
plt.xlabel('Epochs')
plt.ylabel('losses, accuracy, val_losses, val_accuracy')
plt.plot(losses, linewidth=1, marker='o', markersize=4, color = 'b')
plt.plot(history['val_loss'],  linewidth=1, markersize=4, marker='s', color = 'orange')
plt.plot(accuracy, linewidth=2, marker = '^', markersize=4,color = 'g')
plt.plot(history['val_accuracy'], linewidth=2, marker='d',markersize=4, color='r')
plt.legend(['loss','val_loss', 'accuracy', 'val_acc'])#



My_model.save("D:\\FCModel.h5")
My_model.save_weights("D:\\FCModel_weights.h5")
