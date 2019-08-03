import png
"""
an easy code to generate some numbers and save them

"""

"""
Images are of size 12x10
"""

#first thing create the container
image = []
image.append([0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
image.append([0, 0, 0, 1, 1, 1, 1, 0, 0, 0])
image.append([0, 0, 1, 1, 1, 1, 1, 1, 0, 0])
image.append([0, 1, 1, 1, 0, 0, 1, 1, 1, 0])
image.append([0, 1, 1, 1, 0, 0, 1, 1, 1, 0])
image.append([0, 1, 1, 1, 0, 0, 1, 1, 1, 0])
image.append([0, 1, 1, 1, 0, 0, 1, 1, 1, 0])
image.append([0, 1, 1, 1, 0, 0, 1, 1, 1, 0])
image.append([0, 1, 1, 1, 0, 0, 1, 1, 1, 0])
image.append([0, 0, 1, 1, 1, 1, 1, 1, 0, 0])
image.append([0, 0, 0, 1, 1, 1, 1, 0, 0, 0])
image.append([0, 0, 0, 0, 0, 0, 0, 0, 0, 0])



f = open('0.png', 'wb')
w = png.Writer(len(image[0]), len(image), greyscale=True, bitdepth=1)
w.write(f, image)
f.close()
