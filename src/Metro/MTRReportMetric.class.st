Class {
	#name : #MTRReportMetric,
	#superclass : #MTRSourcedEntity,
	#category : #'Metro-Model'
}

{ #category : #properties }
MTRReportMetric >> amountTableFields [

	<cvs: #'TableFields used' at: 6>
	^ dependancies count: [ :d | d first = 'TableField' ]
]

{ #category : #properties }
MTRReportMetric >> amountTables [

	<cvs: #'Tables Used' at: 6>
	^ dependancies count: [ :d | d first = 'Table' ]
]

{ #category : #properties }
MTRReportMetric >> companionModule [
	^ (children at: #ClassModule ifAbsent: [ {} ])
		ifEmpty: [ nil ]
		ifNotEmpty: [ :s | s first ]
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
			('Form>> tables:{2} loc:{3} deps:{4} name:{1} '
				format:
					{self name.
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
