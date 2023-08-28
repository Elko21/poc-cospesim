from pypdevs.DEVS import AtomicDEVS
from pypdevs.infinity import INFINITY

class Distributeur(AtomicDEVS):
    def __init__(self):
        AtomicDEVS.__init__(self,"Distributeur")
        self.state = "envoiSortir"
        self.waiting_time = 4.0
        self.processing_time = 1.0
        self.eRentrer = self.addInPort("eRentrer")
        self.eSortir = self.addInPort("eSortir")
        self.cRentrer = self.addOutPort("cRentrer")
        self.cSortir = self.addOutPort("cSortir")
        self.position = False

    def timeAdvance(self):
        if self.state is None:
            return INFINITY
        elif self.state == "enAttente":
            return self.waiting_time
        else:
            return self.processing_time
        	
    def outputFnc(self):
        return {self.cRentrer: self.state == "envoiRentrer", self.cSortir: self.state == "envoiSortir"}
    
    def extTransition(self, inputs):
        return self.state
    
    def intTransition(self):
        if self.state == "enAttente" and not self.position:
            self.state = "envoiSortir"
            self.position = True
        elif self.state == "enAttente" and self.position:
            self.state = "envoiRentrer"
            self.position = False
        elif self.state != "enAttente":
            self.state = "enAttente"

        return self.state