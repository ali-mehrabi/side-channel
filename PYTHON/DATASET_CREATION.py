# -*- coding: utf-8 -*-
"""
Created on Wed Dec  4 13:42:36 2019

@author: Ali
"""

import numpy as np
import pandas as pd
import math as m
import FUNCTIONS as ft
from matplotlib import pyplot as plt
import csv as csv
import math as m
###############################################################################
###############constants###########################
Frequency    = 3*10**6    # Hz
T            = (1/Frequency) # seconds
Sample       = 1 * 10**6    # samples per Frame 
FR           = 40 * 10**-3  # full frame  40 mSeconds
SR           = Sample/FR  # Sample per Sec
OFFSET       = (8*10**-3)*SR     # Start reading after 8 ms
OFST         = int(OFFSET)
ROFST        = int((10*10**-3)*SR)
SP           = T*SR # samples per clk pulse
PD           = m.ceil(155*SP)   #
PA           = m.ceil(370*SP)   # 
LEN          = int(PD+PA+2*SP)  # Length of a block of data
FILE      = "D:\\power_analysis" 
EXT       = ".csv"
TRAINFILE = "D:\\TrainingDS.csv"
TESTFILE  = "D:\\TestingDS.csv"
RLBLFILE  = "D:\\TrainLabels.csv"
TLBLFILE  = "D:\\TestLabels.csv"
i=1
###############################################################################
##################### Extract PD/PA power signals
while(i<8):  
    x_data=pd.read_csv(FILE + str(i) + EXT )
    X_data=x_data.iloc[1:1001]
    X_test=x_data.iloc[1001:1501]
    
    X_data.to_csv(TRAINFILE, mode='a')
    X_test.to_csv(TESTFILE, mode='a')
###############################################################################
############# Extract PD power signals
###############################################################################
Z=np.zeros(LEN-PD)
x_data = pd.read_csv(FILE+str(8)+EXT)
X_data = x_data.iloc[1:1001]
dd     = np.array(X_data)
zd=pd.DataFrame()
for j in range(0,1000):
    data8  = np.concatenate((dd[j,0:PD], Z), axis=0)
    z = pd.DataFrame(data8)
    z = (z.T)
    zd=pd.concat((zd,z),axis=0)
zd.to_csv(TRAINFILE, mode='a')
X_test = x_data.iloc[1001:1501]
dd     = np.array(X_test)
zd=pd.DataFrame()
for j in range(0,500):
    data8  = np.concatenate((dd[j,0:PD], Z), axis=0)
    z = pd.DataFrame(data8)
    z = z.T
    zd=pd.concat((zd,z),axis=0)
zd.to_csv(TESTFILE, mode='a')  
  
####################### Y_test and Y-test generation ##########################
###############################################################################    
y_train=np.array([])
y_test =np.array([])
yr = np.ones(1000)
yt = np.ones(500)
for j in range(1,9):
    y_train=np.append(y_train,j*yr,axis=0)
    y_test =np.append(y_test,j*yt, axis=0)
y_train= np.append(y_train,np.zeros(1000),axis=0)
y_test = np.append(y_test,np.zeros(500),axis=0) 
y_train = pd.DataFrame(y_train)
y_test= pd.DataFrame(y_test) 
y_train.to_csv(RLBLFILE)
y_test.to_csv(TLBLFILE)
###############################################################################