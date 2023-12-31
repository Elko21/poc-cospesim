/*
 * generated by Xtext 2.18.0.M3
 */
package org.omg.sysml.xtext.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
// import org.omg.sysml.adapter.PartDefinitionAdapter
import org.omg.sysml.lang.sysml.*
import org.omg.sysml.lang.sysml.impl.ConnectionDefinitionImpl
import org.omg.sysml.xtext.services.SysMLGrammarAccess.ConnectionUsageElements
import org.omg.sysml.xtext.services.SysMLGrammarAccess.ConnectorEndMemberElements
import org.omg.sysml.lang.sysml.impl.ConnectorImpl
import org.omg.sysml.delegate.ConnectorAsUsage_sourceFeature_SettingDelegate
import org.omg.sysml.lang.sysml.impl.SubsettingImpl
import org.omg.sysml.xtext.services.SysMLGrammarAccess.FeatureChainPrefixElements
import org.omg.sysml.adapter.FeatureAdapter
import org.omg.kerml.xtext.services.KerMLGrammarAccess.BinaryConnectorDeclarationElements

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class SysMLGenerator extends AbstractGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		println("Begin to generate code here ...")
		for (PartDefinition p : resource.allContents.toIterable.filter(typeof(PartDefinition))) {
			val pName = p.declaredName
			 
			if (!p.documentation.empty) { 
				val coSimType = p.documentation.head.body
				println("\tType de co-simulation : " + coSimType)
				if (coSimType.contains("PyPDEVS")) {
					if(p.ownedPart.empty){ 
						println(pName + " is an atomic model")
						fsa.generateFile(pName + ".py", AtomicPyPDEVS(p))
						println(p.ownedPort)
					} else {
						
						println(pName + " is a coupled model")
						println(p.ownedRequirement.head.definition.head.documentation.head.body)
						println(p.ownedRequirement.head.definition.map[membership])
						println(p.ownedPart.filter(typeof(PartUsage)).map[owningDefinition])
						println(resource.allContents.toIterable.filter(typeof(BinaryConnectorDeclarationElements)))
						println(p.ownedPort)
						fsa.generateFile(pName + ".py", CoupledPyPDEVS(p))
					}
				}
				if (coSimType.contains("FMI") || coSimType.contains("FMU")){
					println(pName + "is a FMU model")
					fsa.generateFile(pName + "_fmu.py", simpleFMU(p))
				}
			}
			else {
				println("No documentation for the " + pName + " part.")
			}
			/*
			if(p.ownedPart.empty){ 
				println(pName + " is an atomic model")
			} else { 
				println(pName + " is a coupled model and it contains the following parts : ")
				val iCon = p.ownedElement.filter(typeof(Connector))
				println(iCon)
				for (i : 0 ..< iCon.length) { 
					println(iCon.get(i).ownedFeatureMembership)
					// println(p.ownedPart.get(i).declaredName + " part from part definition " + p.ownedPart.get(i).definition.head.declaredName)
					//println(p.ownedPart.get(i))
					// println(iCon) //p.ownedInterface.get(i).definition.head.ownedFeatureMembership)
				}
				
				val con = resource.allContents.toIterable.filter(typeof(FeatureValue))
				println(con)
				
				for (i : 0 ..< con.length) {
					// println(con.get(i))
				}
				
				
				
				if (!p.ownedConnection.empty){
					println("Connections inside the model are : ")
					for (i : 0 ..< p.ownedConnection.length) { 
						println(p.ownedConnection.get(i))
					}
				}
				
				// p.directedUsage.get(i)
			}
				
			if(p.ownedPort.length > 0) {
				println("\tPorts are : ")
				for (i : 0 ..< p.ownedPort.length) { 
					println("\t" + p.ownedPort.get(i).declaredName + " is an " + p.ownedPort.get(i).direction + "port")
				}
			} else {
				println("\tNo port in here !")
			}
			// p.ownedPort.
			// fsa.generateFile(pName + ".py", AtomicPyPDEVS)
			// fsa.generateFile(pName + ".py", CoupledPyPDEVS)
		}
		*/
		
		}
		//fsa.generateFile("test.py", py)
//		fsa.generateFile('greetings.txt', 'People to greet: ' + 
//			resource.allContents
//				.filter(Greeting)
//				.map[name]
//				.join(', '))
	}
	
	private def AtomicPyPDEVS(PartDefinition p) '''
	from pypdevs.DEVS import AtomicDEVS
	from pypdevs.infinity import INFINITY
	
	class «p.declaredName»(AtomicDEVS):
	    def __init__(self):
	        AtomicDEVS.__init__(self,"«p.declaredName»")
	        «println("About to scan ports ...")»
	        «FOR ownedPort : p.ownedPort»
	        «println("Port : " + ownedPort.declaredName + "\t| Direction : " + ownedPort.direction)»
        	«IF ownedPort.direction == "in"»
	        «println("Inside InPort")»
	        self.«ownedPort.declaredName» = self.addInPort("«ownedPort.declaredName»")
        	«ELSEIF ownedPort.direction == "out"»
	        «println("Inside OutPort")»
	        self.«ownedPort.declaredName» = self.addOutPort("«ownedPort.declaredName»")
        	«ENDIF»
	        «ENDFOR»
        	«IF p.ownedPort.get(0).direction == "in"»
	        «println("Inside InPort")»
	        self.«p.ownedPort.get(0).declaredName» = self.addInPort("«p.ownedPort.get(0).declaredName»")
        	«ELSEIF p.ownedPort.get(0).direction  == "out"»
	        «println("Inside OutPort")»
	        self.«p.ownedPort.get(0).declaredName» = self.addOutPort("«p.ownedPort.get(0).declaredName»")
        	«ENDIF»
	        # Add processing time if wish

	    def timeAdvance(self):
	    	if self.state is None:
	    		return INFINITY
	        else:
	        	return self.processing_time
	        	
	    def outputFnc(self):
	    	# TO DO
	        return self.state
	    
	    def extTransition(self, inputs):
	        # TO DO
	        return self.state
	    
	    def intTransition(self):
	        # TO DO
	        return self.state
	'''
	
	private def CoupledPyPDEVS(PartDefinition p) '''
	from pypdevs.DEVS import CoupledDEVS
	from pypdevs.infinity import INFINITY
	«FOR i : 0 ..< p.ownedPart.length»
	from «p.ownedPart.get(i).definition.head.declaredName» import «p.ownedPart.get(i).definition.head.declaredName»
	«ENDFOR»
	
	class «p.declaredName»(CoupledDEVS):
	    def __init__(self):
	        CoupledDEVS.__init__(self,"«p.declaredName»")
	        «FOR i : 0 ..< p.ownedPart.length»
	        self.«p.ownedPart.get(i).declaredName» = self.addSubModel(«p.ownedPart.get(i).definition.head.declaredName»())
	        «ENDFOR»
	        self.connectPorts(self."""OUTPORT"""«», self."""INPORT"""«»)
	
	    def timeAdvance(self):
	    	# TO DO
	    	return INFINITY
	            	
	    def outputFnc(self):
	    	# TO DO
	        return self.state
	    
	    def extTransition(self, inputs):
	        # TO DO
	        return self.state
	    
	    def intTransition(self):
	        # TO DO
	        return self.state
	'''
	
	private def simpleFMU(PartDefinition p)'''
	from myFMU import myFMU
	from fmpy import *
	
	# TO DO : Define initial values and useful variables for simulation
	# initValues = []
	
	# TO DO : Define the start and stop time and also the step size (delta)
	# startTime = ...
	# stopTime = ...
	# stepSize = ...
	
	# TO DO : Complete the path to the fmu file
	# path = ""
	
	# Define the fmu instance
	«p.declaredName» = myFMU(path)
	«p.declaredName».init(startTime,initValues)
	
	time = startTime
	
	while time < stopTime:
		# TO DO : Define the system behavior
		«p.declaredName».doStep(time,stepSize)
		
		time += stepSize
		
	«p.declaredName».terminate()
	'''
	
}