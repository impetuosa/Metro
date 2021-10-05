Class {
	#name : #MTRReportMetric,
	#superclass : #MTRSourcedEntity,
	#category : #'Metro-Model'
}

{ #category : #properties }
MTRReportMetric >> amountCustomControls [
	<cvs: #'Custom Controls' at: 5>
	^ dependancies
		count: [ :d | 
			d isArray
				ifTrue: [ d first = 'CustomControl' ]
				ifFalse: [ d isKindOf: MTRCustomControlType ] ]
]

{ #category : #properties }
MTRReportMetric >> amountTables [
	<cvs: #'Tables Used' at: 6>
	^ dependancies
		count: [ :d | 
			d isArray
				ifTrue: [ d first = 'Table' ]
				ifFalse: [ d isKindOf: MTRTableMetric ] ]
]

{ #category : #properties }
MTRReportMetric >> companionModule [
	^ (children at: #ClassModule ifAbsent: [ {} ])
		ifEmpty: [ nil ]
		ifNotEmpty: [ :s | s first ]
]

{ #category : #properties }
MTRReportMetric >> controls [
	<cvs: #Controls at: 3>
	^ properties at: #Controls ifAbsent: nil
]

{ #category : #properties }
MTRReportMetric >> dropAstMetrics [
	sourceMetrics := nil.
	^ self companionModule ifNotNil: [ :mod | mod dropAstMetrics ]
]

{ #category : #properties }
MTRReportMetric >> hasModule [
	^ properties at:#hasModule ifAbsent: nil 
]

{ #category : #properties }
MTRReportMetric >> kind [
	^ 'Report'
]

{ #category : #properties }
MTRReportMetric >> loc [
	<cvs: #LOC at: 2>
	^ self companionModule ifNil: [ 0 ] ifNotNil: [ :m | m LOC ]
]

{ #category : #properties }
MTRReportMetric >> printOn: aStream [
	aStream
		nextPutAll:
			('Report>> controls:{2} customs:{3} tables:{4} loc:{5} deps:{6} name:{1} '
				format:
					{self name.
					self controls.
					self amountCustomControls.
					self amountTables.
					self loc.
					self allDependencies size})
]

{ #category : #properties }
MTRReportMetric >> properties [
	^ properties at:#properties ifAbsent: nil 
]

{ #category : #properties }
MTRReportMetric >> source [
	^ self companionModule ifNotNil: [ :mod | mod source ]
]

{ #category : #properties }
MTRReportMetric >> sourceMetrics [
	^ self companionModule
		ifNotNil: [ :mod | sourceMetrics := mod sourceMetrics ]
]

{ #category : #properties }
MTRReportMetric >> type [
	<cvs: #Type at: 4>
	^ properties at: #type ifAbsent: nil
]
