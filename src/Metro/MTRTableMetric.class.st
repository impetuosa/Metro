Class {
	#name : #MTRTableMetric,
	#superclass : #MTRStructuralMetric,
	#category : #'Metro-Model'
}

{ #category : #properties }
MTRTableMetric >> fields [
	<cvs: #fields at: 2>
	^ properties at: #Fields ifAbsent: nil
]

{ #category : #'as yet unclassified' }
MTRTableMetric >> grammaticalCounts [

	^ {  }
]

{ #category : #properties }
MTRTableMetric >> members [

	<cvs: #members at: 2>
	^ properties at: #Members
]

{ #category : #properties }
MTRTableMetric >> printOn: aStream [
aStream
		nextPutAll:
			('Table>> name:{1} Members:{2}'
				format:
					{self name .
					self members})
]
