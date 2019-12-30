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
from   keras.utils      import  np_utils, plot_model
from   keras.models     import  Sequential
from   keras.layers     import  Dense
from   keras.losses     import  categorical_crossentropy
from   keras.optimizers import  adam
from   keras            import  callbacks as cb
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
y_array    = np.loadtxt(TARGETFILE, delimiter=",")
y          = np_utils.to_categorical(y_array)
LS         = 834
RS         = 2500 
X2         = np.absolute(X_scaled)
#X_train, X_test, y_train,y_test = train_test_split(X2,y, test_size=0.2, random_state=seed)

#### Creating Model

My_model = Sequential()
My_model.add(Dense(int(Length/2),   activation='relu',input_shape=(Length,)))
My_model.add(Dense(int(Length/4),   activation='relu'))
My_model.add(Dense(int(Length/8),   activation='relu'))
My_model.add(Dense(int(Length/16),  activation='relu'))
My_model.add(Dense(int(Length/32),  activation='relu'))
My_model.add(Dense(int(Length/64),  activation='relu'))
My_model.add(Dense(int(Length/128), activation='relu'))
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
Network_history = My_model.fit(X2,y, epochs=300, validation_split=0.2, batch_size=45, callbacks=call_backs)
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

plt.figure()
plt.xlabel('Epochs')
plt.ylabel('loss, val_loss')
plt.plot(history['loss'])
plt.plot(history['val_loss'])
plt.legend(['loss', 'val_loss'])

plt.figure()
plt.xlabel('Epochs')
plt.ylabel('accuracy, val_accuracy')
plt.plot(history['accuracy'])
plt.plot(history['val_accuracy'])
plt.legend(['accuracy', 'val_accuracy'])
#################################################################################################
######################################### evaluate model ######################################## 
test_loss, test_accuracy = My_model.evaluate(X_test,y_test)
test_labels_predict = My_model.predict(X_test)
test_labels_predict = np.argmax(test_labels_predict, axis=1)
print(My_model.metrics_names[1], test_accuracy*100)
print(My_model.metrics_names[0], test_loss)

#plt.plot(np.absolute(X_scaled[2,:].T));plt.plot(np.absolute(X_scaled[412,:].T))
#plt.plot(np.absolute(X_scaled[2,:].T));plt.plot(np.absolute(X_scaled[1412,:].T))
#plt.plot(np.absolute(X_scaled[2,:].T));plt.plot(np.absolute(X_scaled[1612,:].T))

My_model.save("D:\\FCModel.h5")
My_model.save_weights("D:\\FCModel_weights.h5")
