# -*- coding: utf-8 -*-
"""
Created on Mon May  3 14:36:13 2021

@author: -
"""

#This script creates a pickle file with data inputs used in the creation of charts

import pickle
import os

#Create path to png folder
filesep = os.path.sep

#Creates variables to be used in all Python plots
"""
Colors used by copying image to MS Paint and using the eye dropper tool
to get RGB values. Made sure to zoom into the picture and extract the color
from the center of the sample color in question. After using the eye dropper
tool, you can see the RGB values by clicking on "Edit Colors" at the top.

We also divide each color by 255.0 because Python stores RGB values as values
between 0 and 1.
"""
universal_params = {'haver_path':'\\\\esdata01\\dlx\\data\\',
                  'standard_size':(12.5,5.5),'standard_size_PPT': (14.83, 7.2/7.5*5.4),
                  'standard_length':12.5,
                  'standard_height':5.5,
                   'blue_1': (22/255.0, 109/255.0, 183/255.0), 'blue_2': (55/255.0, 96/255.0, 146/255.0), 'red_1':(184/255.0, 79/255.0, 76/255.0),
                   'blue_3': (174/255.0, 189/255.0, 217/255.0), 'blue_4': (107/255.0, 142/255.0, 195/255.0), 'blue_5': (98/255.0, 171/255.0, 202/255.0),
                   'grey_1': (182/255.0, 188/255.0, 193/255.0), 'grey_2': (133/255.0, 144/255.0, 151/255.0),
                   'grey_3': (98/255.0, 108/255.0, 115/255.0), 'grey_4': (64/255.0, 70/255.0, 73/255.0), 'recession_grey': (191/255.0, 191/255.0, 191/255.0),
                   'red_shade': (227/255.0, 185/255.0, 183/255.0), 'red_2':(140/255.0, 58/255.0, 55/255.0), 'aquamarine_1': (98/255.0, 171/255.0, 202/255.0),
                   'green_1': (98/255.0, 187/255.0, 71/255.0), 'orange_1':(244/255.0, 120/255.0, 33/255.0),
                   'blue_row_1': (184/255.0, 204/255.0, 228/255.0), 'blue_row_2': (220/255.0, 230/255.0, 241/255.0),
                   'blue_col_header': (79/255.0, 129/255.0, 189/255.0),
                   'stata_recession_grey': (228/255.0, 228/255.0, 228/255.0)
                   }



#This pickle file is called in the beginning of python chart scripts and the variables defined above are used
outfile = open('universal_params', "wb")
pickle.dump(universal_params,outfile)
outfile.close()