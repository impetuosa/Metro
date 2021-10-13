Class {
	#name : #MTRMacroMetric,
	#superclass : #MTRStructuralMetric,
	#category : #'Metro-Model'
}

{ #category : #accessing }
MTRMacroMetric >> printOn: aStream [
	aStream
		nextPutAll: ' Macro >> name: ';
		nextPutAll: self name
]
