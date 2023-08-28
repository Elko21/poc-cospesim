from myFMU import myFMU
from fmpy import *

# define initial values and usefull variables for simulation
initValues = [
    ('cptRentre',True),
    ('cptSorti',False),
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

print("Time \tCptRentre \tCptSorti \tPosition")

while time < stopTime:
    verin.doStep(time,stepSize)
    if time >= 1 and time < 2:
        verin.setB('electroTravail',True)
        verin.setB('electroRetour',False)
    elif time >= 5 and time < 7:
        verin.setB('electroTravail',False)
        verin.setB('electroRetour',True)

    cptRentre = verin.getB('cptRentre')
    cptSorti = verin.getB('cptSorti')
    positionTige = verin.get('positionTige')
    print(str(time) + "\t\t" + str(cptRentre) + "\t\t\t" + str(cptSorti) + "\t\t\t" + str(positionTige))
    time += stepSize

verin.terminate()