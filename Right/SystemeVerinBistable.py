from pypdevs.DEVS import CoupledDEVS
from pypdevs.infinity import INFINITY
from Verin import Verin
from Distributeur import Distributeur

class SystemeVerinBistable(CoupledDEVS):
    def __init__(self):
        CoupledDEVS.__init__(self,"SystemeVerinBistable")
        self.distributeur = self.addSubModel(Distributeur())
        self.verinBistable = self.addSubModel(Verin())
        self.pSortir = self.addInPort("pSortir")
        self.pRentrer = self.addInPort("pRentrer")
        self.cRentree = self.addOutPort("cRentree")
        self.cSortie = self.addOutPort("cSortie")
        self.processing_time = 1.0

        self.connectPorts(self.pRentrer, self.distributeur.eRentrer)
        self.connectPorts(self.pSortir, self.distributeur.eSortir)
        self.connectPorts(self.verinBistable.eRentre,self.cRentree)
        self.connectPorts(self.verinBistable.eSorti,self.cSortie)
        self.connectPorts(self.distributeur.cRentrer, self.verinBistable.oRentrer)
        self.connectPorts(self.distributeur.cSortir, self.verinBistable.oSortir)
        
    def timeAdvance(self):
        
        return self.processing_time

    def outputFnc(self):
        
        return {self.cRentree: self.verinBistable.state.outputs[self.verinBistable.eRentre] , self.cSortie: self.verinBistable.state.outputs[self.verinBistable.eSorti] }

    def extTransition(self):
        
        return self.state

    def intTransition(self,inputs):

        return self.state

    def defCapteurs(self):
        print("Capteur rentre : " + str(self.verinBistable.state.outputs[self.verinBistable.eRentre]))
        print("Capteur sorti : " + str(self.verinBistable.state.outputs[self.verinBistable.eSorti]))
        
        if (self.verinBistable.state.outputs[self.verinBistable.eRentre] and self.verinBistable.state.outputs[self.verinBistable.eSorti]):
            print("Propriété non satisfaite /!\\")
            return True
        else:
            print("Propriété satisfaite !!!")
            return False