Class {
	#name : #MTRReferenceMetric,
	#superclass : #MTRStructuralMetric,
	#category : #'Metro-Model'
}

{ #category : #properties }
MTRReferenceMetric >> builtIn [
	<cvs: #'Built In' at: 2>
	^ properties at:#BuiltIn ifAbsent: nil 
]

{ #category : #properties }
MTRReferenceMetric >> major [
	^ properties at:#Major ifAbsent: nil 
]

{ #category : #properties }
MTRReferenceMetric >> minor [
	^ properties at:#Minor ifAbsent: nil 
]

{ #category : #properties }
MTRReferenceMetric >> path [
	<cvs: #path at: 1>
	^ (properties at:#Path ifAbsent: nil )
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
