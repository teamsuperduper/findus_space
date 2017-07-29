#!/usr/bin/python2.7

import sys
import csv

def load_correspondence(cfile):
    dict = {}
    
    with open(cfile,'r') as csvfile:
        spamreader = csv.DictReader(csvfile)
        for row in spamreader:
            dict[row['SA2_MAIN16']] = row['UCL_CODE11']
    
    return dict

def main():
    if (len(sys.argv)<2):
        print 'ERROR: Enter input and output file name.'
        return
    if (len(sys.argv)<3):
        print 'ERROR: Enter both an input and output file name.'
        return
    
    print str(sys.argv[1])
    
    # SA1
    
    d_SA2_16_UCL_11 = load_correspondence('../../town-locations_16.csv')
    
    with open(sys.argv[1],'r') as csvfile:
        with open(sys.argv[2],'w') as csvfile2:
            spamreader = csv.reader(csvfile)
            writer = csv.writer(csvfile2)
            headers = next(spamreader, None)
            headers[0] = 'UCL_CODE11'
            print headers
            writer.writerow(headers)
            for row in spamreader:
                #print row
                if (len(row[0])>0):
                    if (row[0] in d_SA2_16_UCL_11):
                        row[0] = (d_SA2_16_UCL_11[row[0]])
                        writer.writerow(row)
                    

if __name__ == '__main__':
    main()
