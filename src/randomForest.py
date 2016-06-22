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
        vec = line.strip().split("\t")
        dataset_.append(tuple(vec[:]))
        line = data.readline()

columns = dataset_[0]
dataset = np.asarray(dataset_[1:])

district = LabelEncoder()
date = LabelEncoder()

dataset[:,0] = district.fit_transform(dataset[:,0])
dataset[:,1] = date.fit_transform(dataset[:,1])
dataset[:,2:] = dataset[:,2:].astype(np.float)

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
    print >>sys.stderr, "Importance:", zip(columns[:-1], model.feature_importances_)
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
    print
    return avg

print np.average([ measure(district_id, int(sys.argv[2])) for district_id in np.unique(dataset[:,0]).astype(int) ])

