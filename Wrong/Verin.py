from pypdevs.DEVS import AtomicDEVS
from pypdevs.infinity import INFINITY

class VerinState:
    def __init__(self):
        self.name = ""
        self.outputs = {}

class Verin(AtomicDEVS):
    def __init__(self):
        AtomicDEVS.__init__(self,"Verin")
        self.state = VerinState()
        self.processing_time = 1.0
        self.oRentrer = self.addInPort("oRentrer")
        self.oSortir = self.addInPort("oSortir")
        self.eRentre = self.addOutPort("eRentre")
        self.eSorti = self.addOutPort("eSorti")
        self.state.name = "rentre"
        self.state.outputs = {self.eRentre: self.state.name == "rentre", self.eSorti: self.state.name == "sorti"}
        
    def timeAdvance(self):
        if self.state.name is None:
            return INFINITY
        elif self.state.name == "enSorti" or self.state.name == "enRentre":
            return 2.0
        else:
            return self.processing_time
        	
    def outputFnc(self):
        self.state.outputs = {self.eRentre: self.state.name == "rentre", self.eSorti: self.state.name == "sorti"}

        return self.state.outputs
    
    def extTransition(self, inputs):
        if inputs[self.oSortir]:
            self.state.name = "enSorti"
        elif inputs[self.oRentrer]:
            self.state.name = "enRentre"
        
        # Update data
        self.state.outputs = {self.eRentre: self.state.name == "rentre", self.eSorti: self.state.name == "sorti"}

        return self.state
    
    def intTransition(self):
        if self.state.name == "enSorti":
            self.state.name = "sorti"
            # Force default on Capteur Rentre (always True when Capteur Sorti is also True)
            self.state.outputs = {self.eRentre: True, self.eSorti: self.state.name == "sorti"}
        elif self.state.name == "enRentre":
            self.state.name = "rentre"
            self.state.outputs = {self.eRentre: self.state.name == "rentre", self.eSorti: self.state.name == "sorti"}

        # Update data
        # self.state.outputs = {self.eRentre: self.state.name == "rentre", self.eSorti: self.state.name == "sorti"}

        return self.state