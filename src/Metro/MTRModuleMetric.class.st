Class {
	#name : #MTRModuleMetric,
	#superclass : #MTRSourcedEntity,
	#category : #'Metro-Model'
}

{ #category : #properties }
MTRModuleMetric >> LOC [
	^ properties at:#LOC ifAbsent: nil 
]

{ #category : #properties }
MTRModuleMetric >> kind [
	^ 'Module'
]

{ #category : #'as yet unclassified' }
MTRModuleMetric >> loc [
	<cvs: #LOC at: 2>
	^ self LOC
]

{ #category : #properties }
MTRModuleMetric >> printOn: aStream [
	aStream
		nextPutAll:
			('Module>> loc:{1} name:{2} deps: {3}'
				format:
					{self LOC.
					self name.
					self allDependencies size})
]
