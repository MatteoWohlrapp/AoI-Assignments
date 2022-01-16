import nengo
import numpy as np

model = nengo.Network()

# function to describe the connection between Ensemble a and Ensemble b 
# caluclates the square of a centered around 0
def a_to_b(x):
    return x * x - 0.5

# function returning the sin with a modified phase
def sin_func(t):
    return np.sin(2*t) 
        
with model:
    # creates the stimulus node with an input following the sin curve defined above 
    stim = nengo.Node(sin_func)
    # creation of 3 Ensembles of 100 neurons each in 1 dimension
    a = nengo.Ensemble(n_neurons=100, dimensions=1)
    b = nengo.Ensemble(n_neurons=100, dimensions=1)
    c = nengo.Ensemble(n_neurons=100, dimensions=1)
    # creation of 1 Ensemble1 of 100 neurons with 2 dimension
    d = nengo.Ensemble(n_neurons=100, dimensions=2)

    # connection the stimulus node to the first ensemble
    nengo.Connection(stim, a)
    # connection the first to the second ensamble
    # Instead of just passing the value, a_to_b is applied
    nengo.Connection(a, b, function=a_to_b)
    # connection between the second and third ensemble, application of transformation to values
    nengo.Connection(b, c, transform=0.5)
    # connecting the ensemble to itself 
    # creates memory behaviour, where the synapse describes how fast changes are transmitted
    nengo.Connection(c, c, synapse=0.1)
    # since d has a dimension of two, we connect stim only to one dimenstion -> the first one
    nengo.Connection(stim, d[0])
    # connecting c to the second dimension of d
    nengo.Connection(c, d[1])


