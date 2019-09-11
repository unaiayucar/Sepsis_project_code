import csv
"""
This file will import properly the data passed from previous algorithm
"""
def from_csv_to_matrix(filename):
    matrix = []
    with open(filename) as csvfile:
        f = csv.reader(csvfile, delimiter=',')
        for row in f:
            row = [int(i) for i in row]
            matrix.append(row)

    return matrix
