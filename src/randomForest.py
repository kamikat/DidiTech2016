#!/usr/bin/env python

import sys
import numpy as np
from sklearn import tree
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble.forest import RandomForestRegressor

dataset_ = []

with open(sys.argv[1]) as data:
    line = data.readline()
    while line:
        vec = line.split(",")
        dataset_.append(tuple(vec[:]))
        line = data.readline()

dataset = np.asarray(dataset_)

district = LabelEncoder()
date = LabelEncoder()
time_slot = LabelEncoder()
is_holiday = LabelEncoder()
weather = LabelEncoder()

dataset[:,0] = district.fit_transform(dataset[:,0])
dataset[:,1] = date.fit_transform(dataset[:,1])
dataset[:,2] = time_slot.fit_transform(dataset[:,2])
dataset[:,3] = is_holiday.fit_transform(dataset[:,3])
dataset[:,4] = weather.fit_transform(dataset[:,4])
dataset[:,5:] = dataset[:,5:].astype(np.float)

# split data set
is_train = np.random.uniform(0, 1, len(dataset)) <= .75
training, testingSet = dataset[is_train], dataset[~is_train]

# train model
def train(k):
    model = RandomForestRegressor(n_estimators=k, n_jobs=-1, verbose=1)
    model.fit(training[:,:-1], training[:,-1])
    return model

def predict(model, testing):
    prediction = model.predict(testing[:,:-1])
    validation = np.array(testing[:,-1], dtype=np.float)
    prediction = prediction[np.nonzero(validation)]
    validation = validation[np.nonzero(validation)]
    return np.average(np.abs(prediction - validation) / validation)

def perform(model):
    # importance vector
    print "Importances:", zip([
        "district_hash","date","time_slot","is_holiday",
        "weather","temperature","pm25",
        "level_1","level_2","level_3","level_4"] +
        [ "poi_%d" % x for x in range(0, 25) ], model.feature_importances_)
    print "MAPS =", predict(model, testingSet)
    print

perform(train(10))
perform(train(100))
perform(train(1000))

