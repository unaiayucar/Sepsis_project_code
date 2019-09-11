import math
from random import randint
from operator import attrgetter
import copy
"""
CLONALG is a so called immune algorithm. You can find a reference to this algorithm in:
 http://www.cleveralgorithms.com/nature-inspired/immune/clonal_selection_algorithm.html
 
You can also find a code implementation in Ruby that same link.

This script is a personal adaptation of this two examples.
"""


class population_characteristics():
    def __init__(self, field1, field2, field3, field4):
        self.bitlist = field1
        self.vector = field2
        self.cost = field3
        self.affinity = field4

def create_affinity(distance_vector, bits_per_parameter):
    """
    affinity = []
    for elements_in_dist_vec in range(len(distance_vector)):
        affinity.append(1-(distance_vector[elements_in_dist_vec]/bits_per_parameter))
    """
    return [(bits_per_parameter - x)/bits_per_parameter for x in distance_vector]


"""
objective_function:
-> Cuadratic distance: x^2 + y^2
"""


def objective_function(array, objective_value):
    """
    sumation = 0
    for all_values in range(len(array)):
        sumation += abs(array[all_values] - objective_value[0].vector[all_values])
    sumation = sumation/(all_values+1)
    """
    return sum(array)/(len(array))

"""
decode: 
This function decodes the binary number into real numbers and scale then into the range of the search_space
e.g. in range -5,5 the distance is 10 so any of the numbers that you take for the 16 bits you map then into that range
"""


def decode(bitlist, search_space, bits_per_parameter, individual_bitlist):
    new_vector = []
    sumation = 0
    hamming_distance = 0
    for different_space_values in range(len(search_space)):
        for all_the_bits in range(bits_per_parameter):
            #sumation += bitlist[different_space_values][all_the_bits] * (2 ** all_the_bits)
            if bitlist[different_space_values][all_the_bits] != individual_bitlist[different_space_values][all_the_bits]:
                hamming_distance += 1
        #new_vector.append((search_space[different_space_values][0]) + (
                    #((search_space[different_space_values][1]) - (search_space[different_space_values][0])) / (
                    #(2 ** bits_per_parameter) - 1)) * sumation)
        # that was the cost function that existed before, but now we are going to implement an easier one
        new_vector.append(hamming_distance)
        sumation = 0
        hamming_distance=0
    return new_vector


def evaluate_individual(individual, search_space, bits_per_parameter):
    original = copy.deepcopy(individual)
    for every_element_in_population in range(len(original)):
        original[every_element_in_population].vector = decode(original[every_element_in_population].bitlist,
                                                                search_space, bits_per_parameter, individual[0].bitlist)
        original[every_element_in_population].cost = objective_function(original[every_element_in_population].vector,
                                                                        original)
        original[every_element_in_population].affinity = create_affinity(original[every_element_in_population].vector,
                                                                         bits_per_parameter)
    return original

"""
evaluate:
This function executes first decode and then objective_function. This is store as a property of the population:
e.g population.vector = ans->decode()
    population.cost = ans->objective_function()
"""


def evaluate(population, search_space, bits_per_parameter, individual):
    for every_element_in_population in range(len(population)):
        population[every_element_in_population].vector = decode(population[every_element_in_population].bitlist,
                                                                search_space, bits_per_parameter, individual[0].bitlist)
        population[every_element_in_population].cost = objective_function(population[every_element_in_population].vector,
                                                                          individual)
        population[every_element_in_population].affinity = create_affinity(population[every_element_in_population].vector,
                                                                         bits_per_parameter)
    return population


"""
random_bitstring:
generates a pseudo random bit string of twice the size of the specified amount of bits.
"""


def random_bitstring(bit_array, bits_per_parameter, search_space):
    bit_array = []
    for all_spaces in range(len(search_space)):
        bit_array.append([])
        for amount_of_bits_to_be_created in range(bits_per_parameter):
            number = randint(0, 2)
            if number > 1:
                bit_array[all_spaces].append(1)
            else:
                bit_array[all_spaces].append(0)
    return bit_array

"""
"""
"""
point_mutation:
"""

def point_mutation(population_element, m_rate):
    amount_of_elements = len(population_element.bitlist[0])
    child = copy.deepcopy(population_element.bitlist)
    for all_searchs_in_m_rate in range(len(m_rate)):
        amount_of_tries = round(amount_of_elements*m_rate[all_searchs_in_m_rate])
        for tries in range(amount_of_tries):
            random_number = randint(0, amount_of_elements -1)
            child[all_searchs_in_m_rate][random_number] = abs(population_element.bitlist[all_searchs_in_m_rate][random_number]-1)
    return child


"""
def point_mutation(population_element, m_rate):
    child = []
    for all_bitlist_spaces in range(len(population_element.bitlist)):
        child.append([])
        for amount_of_bits_to_be_created in range(len(population_element.bitlist[0])):
            number = randint(0, 1)
            if number > m_rate[all_bitlist_spaces]:
                if population_element.bitlist[all_bitlist_spaces] == 1:
                    child[all_bitlist_spaces].append(0)
                else:
                    child[all_bitlist_spaces].append(1)
            else:
                if population_element.bitlist[all_bitlist_spaces] == 1:
                    child[all_bitlist_spaces].append(1)
                else:
                    child[all_bitlist_spaces].append(0)
    return child


"""
"""
calculate_mutation_rate:

"""


def calculate_mutation_rate(antibody, mutation_factor):
    #return math.exp(mutation_factor*antibody.affinity) # old one
    m_rate = []
    for all_in_anti in range(len(antibody.affinity)):
        mutation_f = (1 - antibody.affinity[all_in_anti]) + mutation_factor
        if not (0 <= mutation_f <= 1):
            mutation_f = (1 - antibody.affinity[all_in_anti])
        m_rate.append(mutation_f)
    return m_rate



"""
num_clones:
number_clones is define by the amount of clone factor respect to the population size
"""


def num_clones(population_size, clone_factor):
    return math.floor(population_size * clone_factor)

"""
ORIGINAL CALCULATE AFFINITY, I WANT A MORE SPECIFIC ONE
"""
"""
calculate_affinity:
computes affinity as 1-(cost)/possible_cost_rage
where possible cost range is defined as the maximum cost minus the smallest one
"""
"""

def calculate_affinity(population):
    sorted_population = sorted(population, key=attrgetter('cost'))
    operable_range = sorted_population[-1].cost - sorted_population[0].cost
    if operable_range == 0:
        for all_elements_in_sorted_population in range(len(sorted_population)):
            sorted_population[all_elements_in_sorted_population].affinity = 1.0
    else:
        for all_elements_in_sorted_population in range(len(sorted_population)):
            sorted_population[all_elements_in_sorted_population].affinity = 1.0 - \
                                            sorted_population[all_elements_in_sorted_population].cost/operable_range
    return sorted_population


"""
"""
def calculate_affinity(population):
    sorted_population = sorted(population, key=attrgetter('cost'))
    if sorted_population[0].cost == 0:
        for elements_in_affinity in range(len(sorted_population[0].affinity)):
            sorted_population[0].affinity[elements_in_affinity] = 1
        return sorted_population
    else:
        for all_elem_in_sorted in range(len(sorted_population)):
            for elements_in_affinity in range(len(sorted_population[0].affinity)):
                
    return 
"""
"""
clone_and_hypermutate:
"""


def clone_and_hypermutate(population, clone_factor, mutation_factor):
    create_clones = []
    number_of_clones = num_clones(len(population), clone_factor)
    #population = calculate_affinity(population)
    sorted_pop = sorted(population, key=attrgetter('cost'))
    for elements_population in range(len(population)):
        m_rate = calculate_mutation_rate(population[elements_population], mutation_factor)
        if (len(sorted_pop) - elements_population) < number_of_clones:
            minimum_number_of_clones = number_of_clones
        else:
            minimum_number_of_clones = (len(sorted_pop) - elements_population)
        for all_clones in range(minimum_number_of_clones):
            clone = point_mutation(population[elements_population], m_rate)
            create_clones.append(population_characteristics(clone, [], 0, 0.0))
    return create_clones


"""
random_insertion:

"""


def random_insertion(search_space, population, num_rand, bits_per_parameter, population_size, individual):
    if num_rand == 0:
        return population
    else:
        random_population = []
        for all_requiered_random_arrays in range(num_rand):
            random_arrays = []
            random_arrays = random_bitstring(random_arrays, bits_per_parameter, search_space)
            random_population.append(population_characteristics(random_arrays, [], 0, 0.0))
        random_population = evaluate(random_population, search_space, bits_per_parameter, individual)
        population.extend(random_population)
        population = sorted(population, key=attrgetter('cost'))
        population = population[:population_size]
        return population


"""
plot_best
"""

def plot_best(best, each_generation):
    print("\n")
    print("gen=" + str(each_generation))
    plot_var = ""
    for all_row in range(len(best.bitlist)):
        plot_var += "\n"
        for all_column in range(len(best.bitlist[0])):
            if best.bitlist[all_row][all_column] == 1:
                plot_var += "X"
            else:
                plot_var += " "
    return print(plot_var)



"""
search:

"""


def search(search_space, max_generations, population_size, clone_factor, num_rand, bits_per_parameter, mutation_rate,
           problem_size, data):
    mutation_rate = mutation_rate/bits_per_parameter
    individual = []
    individual.append(population_characteristics(data, [], 0, []))
    individual = evaluate_individual(individual, search_space, bits_per_parameter)
    population = []
    for generate_random_bitstring in range(population_size):
        bit_array = []
        bit_array = random_bitstring(bit_array, bits_per_parameter, search_space)
        population.append(population_characteristics(bit_array, [], 0, 0.0))
    population = evaluate(population, search_space, bits_per_parameter, individual)
    best = min(population, key=attrgetter('cost'))  # The one with the inferior cost
    for each_generation in range(max_generations):
        created_clones = clone_and_hypermutate(population, clone_factor, mutation_rate)
        created_clones = evaluate(created_clones, search_space, bits_per_parameter, individual)
        population.extend(created_clones)
        population = sorted(population, key=attrgetter('cost'))
        population = population[:population_size]
        population = random_insertion(search_space, population, num_rand, bits_per_parameter, population_size, individual)
        population_plus_best = population[:]
        population_plus_best.append(population_characteristics(best.bitlist, best.vector, best.cost, best.affinity))
        best = min(population_plus_best, key=attrgetter('cost'))  # The one with the inferior cost
        plot_best(best, each_generation)
        if best.cost == 0:
            return best
    return best
