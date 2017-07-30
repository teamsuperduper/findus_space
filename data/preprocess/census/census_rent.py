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

def load_median_table():
    medians = {
    'R_0_74_Tot': 37,
    'R_75_99_Tot': 87,
    'R_100_149_Tot': 125,
    'R_150_199_Tot': 175,
    'R_200_224_Tot': 212,
    'R_225_274_Tot': 250,
    'R_275_349_Tot': 312,
    'R_350_449_Tot': 400,
    'R_450_549_Tot': 500,
    'R_550_649_Tot': 600,
    'R_650_749_Tot': 700,
    'R_750_849_Tot': 800,
    'R_850_949_Tot': 900,
    'R_950_over_Tot': 1000,
    'Rent_ns_Tot': 0,
    'Tot_Tot': 0
    }
    
    return medians

def main():
    
    # if (len(sys.argv)<2):
#         print 'ERROR: Enter input and output file name.'
#         return
#     if (len(sys.argv)<3):
#         print 'ERROR: Enter both an input and output file name.'
#         return
#     
#     print str(sys.argv[1])
    
    # SA1
    
    datafile = '2016Census_G36_AUS_SA2.csv'
    outfile = 'prefs-rent.csv'
    
    d_SA2_16_UCL_11 = load_correspondence('../../town-locations.csv')
    
    medians = load_median_table()
    
    with open(datafile,'r') as csvfile:
        with open(outfile,'w') as csvfile2:
            spamreader = csv.reader(csvfile)
            writer = csv.writer(csvfile2)
            oheaders = next(spamreader, None)
            i = 0
            totals = []
            for h in oheaders:
                if h[-3:] == 'Tot':
                    if (h!='Tot_Tot') and (h!='Rent_ns_Tot'):
                        totals.append(int(i))
                        print i,h
                    #hs = h.split('_')
                    #print (int(hs[1])+int(hs[2]))/2
                    if h=='Tot_Tot':
                        tot_tot = i-1
                i+=1
            headers = ['UCL_CODE11','score_rent']
            print headers
            print totals
            print tot_tot
            writer.writerow(headers)
            
            uclids = []
            rentmeans = []
            for row in spamreader:
                if (len(row[0])>0):
                    if (row[0] in d_SA2_16_UCL_11):
                        med = tot_tot/2
                        
                        total = 0.0
                        totalct = 0
                        for i in totals:
                            #print i,oheaders[i],row[i]
                            #print int(row[i])*medians[oheaders[i]]
                            totalct += int(row[i])
                            total += int(row[i]) * medians[oheaders[i]]
                            #print total,totalct
                        if totalct>0:
                            uclids.append(d_SA2_16_UCL_11[row[0]])
                            rentmeans.append(int(total/totalct))
            minr = min(rentmeans)
            maxr = max(rentmeans)
            print minr,maxr
            
            for i in range(0,len(uclids)):
                #print uclids[i],((maxr-rentmeans[i])*100/(maxr-minr))/100.0
                writer.writerow([uclids[i],((maxr-rentmeans[i])*100/(maxr-minr))/100.0])
                    

if __name__ == '__main__':
    main()
