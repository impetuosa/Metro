Class {
	#name : #MTRQueryMetric,
	#superclass : #MTRStructuralMetric,
	#category : #'Metro-Model'
}

{ #category : #'as yet unclassified' }
MTRQueryMetric >> counters [

	^ properties associations select: [ :a | a value isNumber ]
]

{ #category : #properties }
MTRQueryMetric >> fields [
	<cvs: #fields at: 2>
	^ properties at: #Fields ifAbsent: nil
]

{ #category : #'as yet unclassified' }
MTRQueryMetric >> grammaticalCounts [

	^ {  }
]

{ #category : #properties }
MTRQueryMetric >> members [

	<cvs: #members at: 2>
	^ properties at: #Members
]

{ #category : #properties }
MTRQueryMetric >> printOn: aStream [
	aStream
		nextPutAll:
			('Query>> name:{1} Members:{2}'
				format:
					{self name .
					self members})
]
