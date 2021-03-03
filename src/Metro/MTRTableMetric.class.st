Class {
	#name : #MTRTableMetric,
	#superclass : #MTRStructuralMetric,
	#category : #Metro
}

{ #category : #properties }
MTRTableMetric >> fields [
	<cvs: #fields at: 2>
	^ properties at: #Fields ifAbsent: nil
]

{ #category : #properties }
MTRTableMetric >> name [
	<cvs: #name at: 1>
	^ properties at: #name ifAbsent: nil
]

{ #category : #properties }
MTRTableMetric >> printOn: aStream [
	aStream
		nextPutAll:
			('Table>> fields:{1} name:{2}'
				format:
					{self fields asString.
					self name})
]
