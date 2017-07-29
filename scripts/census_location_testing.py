#!/usr/bin/python2.7

import sys
import csv

# Convert 2016 to 2011 SA1 data
def load_2011_SA1_to_2016_SA1():
    dict = {}
    with open('CG_SA1_2011_SA1_2016.csv','r') as csvfile:
        spamreader = csv.DictReader(csvfile)
        for row in spamreader:
            dict[row['SA1_MAINCODE_2016']] = row['SA1_MAINCODE_2011']
            
    return dict
    
# Convert 2011 SA1 to UCL data
def load_2011_SA1_to_2011_UCL():
    dict = {}
    with open('SA1_UCL_SOSR_SOS_2011_AUST.csv','r') as csvfile:
        spamreader = csv.DictReader(csvfile)
        for row in spamreader:
            dict[row['SA1_MAINCODE_2011']] = row['UCL_CODE_2011']
            
    return dict
    
# Convert 2016 to 2011 SA2 data
def load_2011_SA2_to_2016_SA2():
    dict = {}
    with open('CG_SA2_2011_SA2_2016.csv','r') as csvfile:
        spamreader = csv.DictReader(csvfile)
        for row in spamreader:
            dict[row['SA2_MAINCODE_2016']] = row['SA2_MAINCODE_2011']
            
    return dict
    
# Convert 2016 SA1 to SA2
def load_2016_SA2_to_2016_SA1():
    dict = {}
    with open('SA1_2016_AUST.csv','r') as csvfile:
        spamreader = csv.DictReader(csvfile)
        for row in spamreader:
            dict[row['SA1_MAINCODE_2016']] = row['SA2_MAINCODE_2016']
            
    return dict
    
def read_data(cfile):
    return

def read_correspondence(cfile):
    dict = {}
    
    with open(cfile,'r') as csvfile:
        spamreader = csv.DictReader(csvfile)
        for row in spamreader:
            dict[row['SA2_MAIN11']] = row['UCL_CODE11']
    
    return dict

def main():
    if (len(sys.argv)<2):
        print 'ERROR: Enter an input file name.'
        return
    
    print str(sys.argv[1])
    
    # SA1
    
    testpts = ['10105153965']
    
    d_sa1_16_11 = load_2011_SA1_to_2016_SA1()
    d_sa1_ucl_11 = load_2011_SA1_to_2011_UCL()
    
    print '2016 SA1, 2011 SA1, 2011 UCL' 
    for tp in testpts:
        print tp,d_sa1_16_11[tp],d_sa1_ucl_11[d_sa1_16_11[tp]]
    
    
    
    d_sa1_sa2 = load_2016_SA1_to_2016_SA2()
    
    testucl = ['303002']
    
    for tp in testucl:
        print 'TP',tp
        for v in d_sa1_16_11.items():
            if d_sa1_ucl_11[v[1]]==tp:
                print v,d_sa1_sa2[v[0]]
    
    # SA2
    d_sa2_16_11 = load_2011_SA2_to_2016_SA2()
    
    d_sa2_ucl = read_correspondence('../town-locations.csv')
    
    ct = 0
    for dkey in d_sa2_16_11.values():
        if not (dkey in d_sa2_ucl):
            ct+=1
            #print dkey,'not in town-locations'
    print ct,' SA2 values not in town-location list'

if __name__ == '__main__':
    main()
