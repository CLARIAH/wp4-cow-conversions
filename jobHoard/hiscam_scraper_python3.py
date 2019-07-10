#!/usr/bin/env python
# coding: utf-8

import pandas as pd

hiscamVersion = {'u1','u2','u3','e','l','nl','de','fr','se','gb','ca','be'}

for version in hiscamVersion:
    page = 'http://www.camsis.stir.ac.uk/hiscam/v1_3_1/hiscam_' + version + '.dat'
    df = pd.read_csv(page, sep='\t')
    df['version'] = version
    df.to_csv('./hiscam_'+ version + '.csv')
