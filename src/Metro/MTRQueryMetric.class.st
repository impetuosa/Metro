Class {
	#name : #MTRQueryMetric,
	#superclass : #MTRStructuralMetric,
	#category : #Metro
}

{ #category : #properties }
MTRQueryMetric >> fields [
	<cvs: #fields at: 2>
	^ properties at: #Fields ifAbsent: nil
]

{ #category : #properties }
MTRQueryMetric >> name [
	<cvs: #name at: 1>
	^ properties at: #name ifAbsent: nil
]

{ #category : #properties }
MTRQueryMetric >> printOn: aStream [
	aStream
		nextPutAll:
			('Query>> fields:{1} name:{2}'
				format:
					{self fields asString.
					self name})
]
