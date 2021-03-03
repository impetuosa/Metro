Class {
	#name : #MTRClassModuleMetric,
	#superclass : #MTRSourcedEntity,
	#category : #Metro
}

{ #category : #properties }
MTRClassModuleMetric >> LOC [
	^ properties at:#LOC ifAbsent: nil 
]

{ #category : #properties }
MTRClassModuleMetric >> kind [
	^ 'ClassModule'
]

{ #category : #'as yet unclassified' }
MTRClassModuleMetric >> loc [
	<cvs: #'LOC' at: 2>
	^ self LOC
]

{ #category : #properties }
MTRClassModuleMetric >> name [
	<cvs: #name at: 1>
	^ properties at: #name ifAbsent: nil
]

{ #category : #properties }
MTRClassModuleMetric >> printOn: aStream [
	aStream
		nextPutAll:
			('Class>> loc:{1} name:{2} deps: {3}'
				format:
					{self LOC.
					self name.
					self allDependencies size})
]
