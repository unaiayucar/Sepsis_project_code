import sys
import CS_algorithm
import image_conversion


# problem configuration
problem_size = 2
search_space = [0, 1024]
bits_per_parameter = 16
image = '2' \
        '.png'
search_space, problem_size, bits_per_parameter, data = image_conversion.convert_image(search_space, problem_size, image, bits_per_parameter)
# algorithm configuration
max_generations = 100
population_size = 100
clone_factor = 0.1
num_rand = 2
mutation_rate = 0  # when mutation rate is 0 the mutation is not altered and follows the normal statistics. if its
# negative its going to generate the mutation to be slower than what it should be, and if its positive is going to
# generate more mutations recommended values is 0. Maximum value bits_per_parameter
# execute the algorithm
best = CS_algorithm.search(search_space, max_generations, population_size, clone_factor, num_rand, bits_per_parameter,
                           mutation_rate, problem_size, data)
#print("the best: {}\n bitlist: {} \n vector: {}\n cost: {}\n affinity: {}".format(best,best.bitlist,best.vector, best.cost, best.affinity))
