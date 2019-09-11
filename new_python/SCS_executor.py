import sys
import SCS_algorithm
import importing_csv_file


# problem configuration
filename = 'exampleA.csv'
data = importing_csv_file.from_csv_to_matrix(filename)
# algorithm configuration
max_generations = 4
population_size = 10
SOFA = True

best = SCS_algorithm.search(max_generations, population_size, data,SOFA)
