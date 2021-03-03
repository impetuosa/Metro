Class {
	#name : #MTRMacroMetric,
	#superclass : #MTRStructuralMetric,
	#category : #Metro
}

{ #category : #accessing }
MTRMacroMetric >> name [
	<cvs: #name at: 1>
	
	^ properties at: #name ifAbsent: nil
]

{ #category : #accessing }
MTRMacroMetric >> printOn: aStream [
	aStream
		nextPutAll: ' Macro >> name: ';
		nextPutAll: self name
]
