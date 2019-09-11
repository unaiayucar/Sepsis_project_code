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

    SOFA_reference = 5
    SOFA_counter = 0
    gcs_values_L = list_of_parameters[1][2] + list_of_parameters[1][3] + list_of_parameters[1][4]
    if gcs_values_L <= 14 and gcs_values_L >= 13:
        SOFA_counter = SOFA_counter + 1
    elif gcs_values_L <= 12 and gcs_values_L >= 10:
        SOFA_counter = SOFA_counter + 2
    elif gcs_values_L <= 9 and gcs_values_L >= 6:
        SOFA_counter = SOFA_counter + 3
    elif gcs_values_L < 6:
        SOFA_counter = SOFA_counter + 4

    FIO2PO2 = list_of_parameters[1][11] / list_of_parameters[0][12]

    if FIO2PO2 < 400 and FIO2PO2 >= 300:
        SOFA_counter = SOFA_counter + 1
    elif FIO2PO2 < 300:
        SOFA_counter = SOFA_counter + 2

    if list_of_parameters[0][1] >=1.2 and list_of_parameters[0][1] < 2:
        SOFA_counter = SOFA_counter + 1
    elif list_of_parameters[0][1] >= 2 and list_of_parameters[0][1] < 6:
        SOFA_counter = SOFA_counter + 2
    elif list_of_parameters[0][1] >= 6 and list_of_parameters[0][1] < 12:
        SOFA_counter = SOFA_counter + 3
    elif list_of_parameters[0][1] >= 12:
        SOFA_counter = SOFA_counter + 4

    if list_of_parameters[0][0] >= 1.2 and list_of_parameters[0][0] < 2:
        SOFA_counter = SOFA_counter + 1
    elif list_of_parameters[0][0] >= 2 and list_of_parameters[0][0] < 3.5:
        SOFA_counter = SOFA_counter + 2
    elif list_of_parameters[0][0] >= 3.5 and list_of_parameters[0][0] < 5:
        SOFA_counter = SOFA_counter + 3
    elif list_of_parameters[0][0] >= 5:
        SOFA_counter = SOFA_counter + 4

    if list_of_parameters[1][10] >= 100 and list_of_parameters[1][10] < 150:
        SOFA_counter = SOFA_counter + 1
    elif list_of_parameters[1][10] >= 50 and list_of_parameters[1][10] < 100:
        SOFA_counter = SOFA_counter + 2
    elif list_of_parameters[1][10] >= 20 and list_of_parameters[1][10] < 50:
        SOFA_counter = SOFA_counter + 3
    elif list_of_parameters[1][10] < 20:
        SOFA_counter = SOFA_counter + 4

    if list_of_parameters[1][9] < 70:
        SOFA_counter = SOFA_counter + 1
    elif (list_of_parameters[0][5] <= 5 and list_of_parameters[0][5] > 0) or (list_of_parameters[0][6] > 0):
        SOFA_counter = SOFA_counter + 2
    elif (list_of_parameters[0][5] <= 15 and list_of_parameters[0][5] > 5) or (list_of_parameters[0][7] <= 0.1 and list_of_parameters[0][7] > 0) or (list_of_parameters[0][8] <= 0.1 and list_of_parameters[0][8] > 0):
        SOFA_counter = SOFA_counter + 3
    elif (list_of_parameters[0][5] > 15) or (list_of_parameters[0][7] > 0.1) or (list_of_parameters[0][8] > 0.1):
        SOFA_counter = SOFA_counter + 4


    if SOFA_reference <= SOFA_counter:
        passed = True
    return passed

def execute_SIRS(list_of_parameters, passed):
    SIRS_reference = 2
    SIRS_counter = 0

    if list_of_parameters[0][0] > 20 or list_of_parameters[1][1] < 43:
        SIRS_counter = SIRS_counter +1

    if list_of_parameters[0][2] > 38 or list_of_parameters[1][2] < 36:
        SIRS_counter = SIRS_counter +1

    if list_of_parameters[0][3] > 90:
        SIRS_counter = SIRS_counter +1

    if list_of_parameters[1][4] < 4 or list_of_parameters[0][4] > 12:
        SIRS_counter = SIRS_counter +1

    if SIRS_counter >= SIRS_reference:
        passed = True
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

