Class {
	#name : #MTRReferenceMetric,
	#superclass : #MTRStructuralMetric,
	#category : #'Metro-Model'
}

{ #category : #properties }
MTRReferenceMetric >> amountOfIncomingPoints [

	<cvs: #AmountOfIncomingPoints at: 5>
	^ properties at: #AmountOfIncomingPoints ifAbsent: 0
]

{ #category : #properties }
MTRReferenceMetric >> amountOfIncomingPoints: aVal [

	self register: #AmountOfIncomingPoints value: aVal
]

{ #category : #properties }
MTRReferenceMetric >> amountOfOutgoingPoints [

	<cvs: #AmountOfOutgoingPoints at: 4>
	^ properties at: #AmountOfOutgoingPoints ifAbsent: 0
]

{ #category : #properties }
MTRReferenceMetric >> amountOfOutgoingPoints: aVal [

	self register: #AmountOfOutgoingPoints value: aVal
]

{ #category : #properties }
MTRReferenceMetric >> amountOfUsages [

	<cvs: #AmountOfUsages at: 3>
	^ properties at: #AmountOfUsages ifAbsent: 0
]

{ #category : #properties }
MTRReferenceMetric >> amountOfUsages: aVal [

	self register: #AmountOfUsages value: aVal
]

{ #category : #properties }
MTRReferenceMetric >> builtIn [
	<cvs: #'Built In' at: 2>
	^ model isBuiltIn 
]

{ #category : #properties }
MTRReferenceMetric >> path [

	<cvs: #path at: 1>
	^ model path
]

{ #category : #properties }
MTRReferenceMetric >> printOn: aStream [
	aStream
		nextPutAll:
			('Ref>> builtIn:{1} path:{2}'
				format:
					{self builtIn asString.
					self path})
]
