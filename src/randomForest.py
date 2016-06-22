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
def split(dataset):
    is_train = np.random.uniform(0, 1, len(dataset)) <= .75
    return dataset[is_train], dataset[~is_train]

# train model
def train(training, k):
    model = RandomForestRegressor(n_estimators=k, n_jobs=-1)
    model.fit(training[:,:-1], training[:,-1])
    return model

# predict and evaluate MAPE value
def predict(model, testing):
    prediction = model.predict(testing[:,:-1])
    validation = np.array(testing[:,-1], dtype=np.float)
    prediction = prediction[np.nonzero(validation)]
    validation = validation[np.nonzero(validation)]
    return np.average(np.abs(prediction - validation) / validation)

def perform(dataset, k):
    training, testing = split(dataset)
    model = train(training, k)
    # importance vector
    print >>sys.stderr, "Importance:", dict(zip([
        "district_hash","date","time_slot","is_holiday",
        "weather","temperature","pm25",
        "level_1","level_2","level_3","level_4"] +
        [ "poi_%d" % x for x in range(0, 25) ], model.feature_importances_))
    maps = predict(model, testing)
    print >>sys.stderr, "MAPS:", maps
    # tree.export_graphviz(model.estimators_[0].tree_)
    return maps

def measure(district_id, k):
    print >>sys.stderr, "=" * 42
    print >>sys.stderr, "District:", district.inverse_transform(district_id)
    print >>sys.stderr, "=" * 42
    avg = np.average([ perform(dataset[dataset[:,0].astype(int) == district_id], k) for i in xrange(1, 10) ])
    print >>sys.stderr, "-" * 42
    print >>sys.stderr, "AVG(MAPS[%s]) =" % district.inverse_transform(district_id), avg
    return avg

print np.average([ measure(district_id, int(sys.argv[2])) for district_id in np.unique(dataset[:,0]).astype(int) ])

