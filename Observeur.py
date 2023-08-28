from pypdevs.DEVS import AtomicDEVS
from pypdevs.infinity import INFINITY

class Observeur(AtomicDEVS):
    def __init__(self):
        AtomicDEVS.__init__(self, "Observeur")
        self.state = ""
        self.processing_time = 1.0
        self.CR = self.addInPort("CR")
        self.CS = self.addInPort("CS")
        self.cmd = ""

    def extTransition(self, inputs):
        if inputs[self.CR]:
            self.state = "verin_rentre"
        elif inputs[self.CS]:
            self.state = "verin_sorti"
        else:
            self.state = ""
            
        return self.state
    
    def outputFnc(self):
        return 