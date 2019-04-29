import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)
from collections import Counter
from numpy import genfromtxt

# Input data files are available in the "../input/" directory.
# For example, running this (by clicking run or pressing Shift+Enter) will list the files in the input directory

fields = ['case_status','country_of_citzenship','decision_date']
file=pd.read_csv("/Users/thomaswang/Downloads/us_perm_visas_final.csv",skipinitialspace=True, usecols=fields, low_memory=False)
#arr=np.genfromtxt(file)
#print(arr)

#field = ['country_of_citzenship']
#f=pd.read_csv("/Users/thomaswang/Downloads/us_perm_visas_final.csv",skipinitialspace=True, usecols=field, low_memory=False)

#print(f.shape)

#print(file.head(1000))

print(file.shape)
#country=f.to_numpy()
#country_list=(np.reshape(country,(1,374362)))[0]
#print(country_list)
#print(country_list.shape)
all=file.to_numpy()
print(all)
list=[]
#nump=np.array(list)
for thing in all:
    #print(type(thing[1]))
    if isinstance(thing[1],str) and thing[0]=="Certified":
        list.append(thing[1])
nump = np.array(list)
print(nump.shape)
print(nump)
#for thing in all:
 #   print(thing)
country=all[:,1]
country_list=(np.reshape(country,(1,374362)))[0]
print(country_list)
print(country_list.shape)

print(Counter(country_list))
print(Counter(nump))

#my_data = genfromtxt('/Users/thomaswang/Downloads/us_perm_visas_final.csv', delimiter=',', usecols=fields)
#import os
#print(os.listdir("../input"))
