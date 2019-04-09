import sys
import os
import glob


## python3 gen_table.py /proj/virus/results/LCH/190405/bbmap_results LCH_episome_mapped_reads.tsv
## python3 gen_table.py sys.argv[1](Pathway to input dir)  sys.argv[2](Output filename)
##


def WriteToFile(newStr, name):
    if not os.path.exists(name):
        str1 = "SampleID" + "\t" + "Reference" + "\t" + "Type" + "\t"  + "n_mapped"  + "\t" + "pct_mapped" + "\n"
        f=open(name, "a+")
        f.write(str1)
        f.close()
    #str1 = FileSampleID + "\t" + Ref + "\t" + FileType + "\t" + nr_mapped + "\t" + proc_mapped + "\n"
    f=open(name, "a+")
    f.write(newStr)
    f.close()
    return None

def parse(fileInput):
    tmpLine = []
    f = open(fileInput)
    line = f.readline()
    tmpLine = line.split()
    #newFileName = sys.argv[2]
    FileName = fileInput
    FileName = FileName.split('/')
    #print(FileName)
    FileName = FileName[len(FileName)-1]
    FileName = FileName.split("_")
    #print(FileName)
    fileType = FileName[3]
    SampleID = FileName[0] + "_" + FileName[1]
    ref = FileName[2]
    while line:
        line = line.strip()
        line = f.readline()
        tmpLine = line.split()
        if tmpLine:
            if tmpLine[3] == "mapped":
                procentage = tmpLine[4].replace('(','')
                procentage = procentage.replace('%','')
                #WriteToFile(tmpLine[0], procentage, fileType, SampleID, ref, newFileName)
                newstr = SampleID + "\t" + ref + "\t" + fileType + "\t" + tmpLine[0] + "\t" + procentage + "\n"
                return newstr
        else:
            break
    f.close()
    return None

def main():
    #newFileName = "LCH_episome_mapped_reads.tsv"
    #files = glob.glob('/proj/virus/results/LCH/190405/bbmap_results/*/*_flagstat.txt')
    newFileName = sys.argv[2]
    files = glob.glob(str(sys.argv[1]+"*_flagstat.txt"))
    #files = glob.glob(str(sys.argv[1]))
    
    for f in files:
        tmp = parse(f)
        WriteToFile(tmp,newFileName)
    return None
main()

