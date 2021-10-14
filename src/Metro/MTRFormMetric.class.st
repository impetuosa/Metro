Class {
	#name : #MTRFormMetric,
	#superclass : #MTRSourcedEntity,
	#category : #'Metro-Model'
}

{ #category : #properties }
MTRFormMetric >> amountTableFields [

	<cvs: #'TableFields used' at: 6>
	^ dependancies count: [ :d | d first = 'TableField' ]
]

{ #category : #properties }
MTRFormMetric >> amountTables [

	<cvs: #'Tables Used' at: 6>
	^ dependancies count: [ :d | d first = 'Table' ]
]

{ #category : #'as yet unclassified' }
MTRFormMetric >> companionModule [
	^ (children at: #ClassModule ifAbsent: [ {} ])
		ifEmpty: [ nil ]
		ifNotEmpty: [ :s | s first ]
]

{ #category : #properties }
MTRFormMetric >> hasModule [
	^ properties at:#hasModule ifAbsent: nil 
]

{ #category : #properties }
MTRFormMetric >> kind [
	^ 'Form'
]

{ #category : #properties }
MTRFormMetric >> printOn: aStream [
	aStream
		nextPutAll:
			('Form>> tables:{2} loc:{3} deps:{4} name:{1} '
				format:
					{self name.
					self amountTables.
					self loc.
					self allDependencies size})
]

{ #category : #properties }
MTRFormMetric >> properties [
	^ properties at:#properties ifAbsent: nil 
]

{ #category : #properties }
MTRFormMetric >> source [
	^ self companionModule ifNotNil: [ :mod | mod source ]
]
