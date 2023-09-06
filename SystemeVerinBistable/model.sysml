package Exigences {
	import ScalarValues::*;
	
	// 1.1 Definition des Exigences
	requirement def DefautCapteurs {
		doc /* Les capteurs de fin de course ne doivent pas être actifs en même temps 
		 * capteurRentre xor capteurSorti
		 * */
		 
		attribute capteurRentre : Boolean;
		attribute capteurSorti : Boolean;
		
		require constraint { capteurRentre xor capteurSorti }
	}
}

package 'StructureSysteme' {	
	import Exigences::*;
	
	// 1.2 Defintion Structure Systeme
	part def Verin {
		// 3. Spécification Standard Co-Simulation
		doc /* PyPDEVS */
		
		attribute position : Real;
		
		// 1.3 Definition des Ports
		in port oRentrer;
		in port oSortir;
		out port eRentree;
		out port eSortie;
	}
	
	// 1.2 Defintion Structure Systeme
	part def Distributeur {
		// 3. Spécification Standard Co-Simulation
		doc /* PyPDEVS */
		
		attribute position : Real;
		
		// 1.3 Definition des Ports
		in port eRentrer;
		in port eSortir;
		out port cRentrer;
		out port cSortir;
	}
	
	// 1.2 Defintion Structure Systeme
	part def SystemeVerinBistable {
		// 3. Spécification Standard Co-Simulation
		doc /* PyPDEVS */
		
		part verinBistable : Verin;
		part distriBistable : Distributeur;
		
		// attribute capteurR : Boolean;
		// attribute capteurS : Boolean;
		
		// out port cRentree;
		// out port cSortie;
		
		//interface A connect distriBistable.cRentrer to verinBistable.oRentrer;
		//interface B connect distriBistable.cSortir to verinBistable.oSortir;
		
		/*
		 * interface def SystemeInterface {
			end suppliedBy : PortEPO {
				port o : PortEPO;
			}
			
			end deliveredTo : PortEPO {
				port i : PortEPO;
			}
			
			connect suppliedBy.o to deliveredTo.i;
		}
		*/
		
		// 1.4 Connexion des Ports
		connect distriBistable.cRentrer to verinBistable.oRentrer; 
		connect distriBistable.cSortir to verinBistable.oSortir;	
		
		// 1.7 Liaison Exigences au Système
		requirement defCapteurs : DefautCapteurs;
	}
}