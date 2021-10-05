Class {
	#name : #MTRFormMetric,
	#superclass : #MTRSourcedEntity,
	#category : #'Metro-Model'
}

{ #category : #properties }
MTRFormMetric >> amountCustomControls [
	<cvs: #'Custom Controls' at: 5>
	^ dependancies
		count: [ :d | 
			d isArray
				ifTrue: [ d first = 'CustomControl' ]
				ifFalse: [ d isKindOf: MTRCustomControlType ] ]
]

{ #category : #properties }
MTRFormMetric >> amountTables [
	<cvs: #'Tables Used' at: 6>
	^ dependancies
		count: [ :d | 
			d isArray
				ifTrue: [ d first = 'Table' ]
				ifFalse: [ d isKindOf: MTRTableMetric ] ]
]

{ #category : #'as yet unclassified' }
MTRFormMetric >> companionModule [
	^ (children at: #ClassModule ifAbsent: [ {} ])
		ifEmpty: [ nil ]
		ifNotEmpty: [ :s | s first ]
]

{ #category : #properties }
MTRFormMetric >> controls [
	<cvs: #'Controls' at: 3>
	^ properties at:#Controls ifAbsent: nil 
]

{ #category : #properties }
MTRFormMetric >> dropAstMetrics [
	sourceMetrics := nil.
	^ self companionModule ifNotNil: [ :mod | mod dropAstMetrics ]
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
MTRFormMetric >> loc [
	<cvs: #LOC at: 2>
	^ self companionModule ifNil: [ 0 ] ifNotNil: [ :m | m LOC ]
]

{ #category : #properties }
MTRFormMetric >> printOn: aStream [
	aStream
		nextPutAll:
			('Form>> controls:{2} customs:{3} tables:{4} loc:{5} deps:{6} name:{1} '
				format:
					{self name.
					self controls.
					self amountCustomControls.
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

{ #category : #properties }
MTRFormMetric >> sourceMetrics [
	^ self companionModule
		ifNotNil: [ :mod | sourceMetrics := mod sourceMetrics ]
]

{ #category : #properties }
MTRFormMetric >> type [
	<cvs: #'Type' at: 4>
	^ properties at:#type ifAbsent: nil 
]
