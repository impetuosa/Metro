Class {
	#name : #MTRClassModuleMetric,
	#superclass : #MTRSourcedEntity,
	#category : #'Metro-Model'
}

{ #category : #properties }
MTRClassModuleMetric >> kind [
	^ 'ClassModule'
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
