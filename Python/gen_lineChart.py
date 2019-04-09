import matplotlib
matplotlib.use('Agg')
import sys
import matplotlib.pyplot as plt

###install -> sudo apt-get install python3-tk
## to run pyplot

def fun2():

	return None

def main():
	tmpLine = []
	Data = []
	lengthArr = []
	count = 0
	f = open(sys.argv[1])
	line = f.readline()
	tmpLine = line.split()
	FileName = sys.argv[2]
	#pos = int(len(tmpLine))
	#print(pos)
	#print(tmpLine)
	#Data.append(tmpLine[pos])
	while line:
		line = line.strip()
		line = f.readline()
		tmpLine = line.split()
		pos = int(len(tmpLine)) - 1
		if tmpLine:
			lengthArr.append(count)
			Data.append(int(tmpLine[pos]))
			count = count + 1
		else:
			break
	f.close()

	#print(Data)
	#print(len(Data)-1)
	#print(lengthArr)
	plt.subplot(212)
	plt.plot(lengthArr, Data, 'r--')
	#plt.show()
	plt.savefig(sys.argv[2])
	return None
	



main()

