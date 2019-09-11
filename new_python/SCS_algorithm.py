import math
from random import random
from operator import attrgetter
import copy


def create_population(population_size, data):
    population = [data]*population_size
    return population

def add_random(population, population_size, slope):
    for i in range(population_size):
        f = random()
        population[i] = population[i] + f*slope
    return population

def execute_SOFA(list_of_parameters, passed):

    return passed

def execute_SIRS(list_of_parameters, passed):

    return passed



def sepsis_clonal_selection(slope,max_generations,population_size, data):
    best = [data,data]
    if slope >  0 or slope < 0:
        # the case slope 0 is not interesting no change is going to happen
        population = create_population(population_size, data)
        for i in range(max_generations):
            population = add_random(population, population_size, slope)

        best[0] = max(population)
        best[1] = min(population)

    return best

"""
search:

"""


def search(max_generations, population_size, data, SOFA):
    # mutation rate will be defined later
    counter1 = 0
    counter2 = 0
    passed = False
    list_of_parameters = []
    list_of_parameters.append([0]*len(data))
    list_of_parameters.append([0]*len(data))
    best = [0,0]

    for column in data[0]:
        for row in data:
            # go row by row (parameter by parameter)
            # go column by column value by value
            if counter1 == 0:
                # this means first value, with only one value there exists no possibility of computing a slope
                counter2 = counter2 + 1
            else:
                slope = (row[counter1] - row[counter1-1])/2
                best = sepsis_clonal_selection(slope, max_generations, population_size, row[counter1])
                list_of_parameters[0][counter2] = copy.deepcopy(best[0])
                list_of_parameters[1][counter2] = copy.deepcopy(best[1])
                counter2 = counter2 + 1

        counter1 = counter1 + 1
        if SOFA == True:
            passed = execute_SOFA(list_of_parameters, passed)
            if passed == True:
                break
        else:
            passed = execute_SIRS(list_of_parameters, passed)
            if passed == True:
                break
        counter2 = 0

    return counter1, passed

