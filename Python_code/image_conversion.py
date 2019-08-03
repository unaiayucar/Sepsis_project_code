import imageio

"""
This file takes a file of images in 2 dimensions and generates an array of n-bits + a searching space area with some
bounds
"""
from scipy import misc

def convert_image(search_space, problem_size, name, bits_per_parameter):

    numbers = imageio.imread(name)
    width, height = numbers.shape
    image_array = []
    new_search_space = []
    for all_rows in range(width):
        image_array.append([])
        for all_columns in range(height):
            if numbers[all_rows][all_columns] == 255:
                image_array[all_rows].append(1)
            else:
                image_array[all_rows].append(0)
        new_search_space.append(search_space)

    return new_search_space, width, height, image_array
