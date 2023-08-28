from myFMU import myFMU
from fmpy import *

# define initial values and usefull variables for simulation
initValues = [
    ('cRentree',True),
    ('cSortie',False),
    ('positionTige',0.0),
    ('pourcentTige',0.0),
    ('valeurIncrement',0.0)]

startTime = 0
stepSize = 0.5
stopTime = 10

# path of the fmu
path = "verin_double_effet.fmu"

dump(path)

# define fmu instance
verin = myFMU(path)

verin.init(startTime,initValues)

time = startTime

print("Time \tCapteur Rentre \tCapteur Sorti \tPosition")

while time < stopTime:
    verin.doStep(time,stepSize)
    if time >= 1 and time < 2:
        verin.setB('pSortir',True)
        verin.setB('pRentrer',False)
    elif time >= 5 and time < 7:
        verin.setB('pSortir',False)
        verin.setB('pRentrer',True)

    cRentree = verin.getB('cRentree')
    cSortie = verin.getB('cSortie')
    positionTige = verin.get('positionTige')
    print(str(time) + "\t\t" + str(cRentree) + "\t\t\t\t" + str(cSortie) + "\t\t\t\t" + str(positionTige))
    time += stepSize

verin.terminate()