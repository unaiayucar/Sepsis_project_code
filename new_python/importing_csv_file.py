import csv

matrix = []
with open('exampleA.csv') as csvfile:
    f = csv.reader(csvfile, delimiter=',')
    for row in f:
        row = [int(i) for i in row]
        matrix.append(row)

r = matrix[0][0]
hell = 0