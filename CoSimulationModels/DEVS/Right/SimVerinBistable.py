from pypdevs.simulator import Simulator
from SystemeVerinBistable import SystemeVerinBistable

def termFunc(clock, model):
    if model.defCapteurs():
        return True
    elif clock[0] >= 10:
        return True
    else:
        return False

model = SystemeVerinBistable()
# print(model.generator.state)    # print True
sim = Simulator(model)
# sim.removeTracers()

# sim.setVerbose("SimVerinResult.txt") # export result into txt file
sim.setVerbose(None)

# Required to set Classic DEVS, as we simulate in Parallel DEVS otherwise
sim.setClassicDEVS()

# Termination time
# sim.setTerminationTime(10.0)

# Termination Condition of the simulation
sim.setTerminationCondition(termFunc)

sim.simulate()  # start simulation
# print(model.generator.state)    # print False