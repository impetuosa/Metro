Class {
	#name : #MTRSourcedEntity,
	#superclass : #MTRStructuralMetric,
	#instVars : [
		'source',
		'sourceMetrics'
	],
	#category : #'Metro-Model'
}

{ #category : #accessing }
MTRSourcedEntity >> allDependencies [
	| base |
	base := super allDependencies.
	sourceMetrics
		ifNotNil: [ sourceMetrics hadErrorOnCalculation
				ifFalse: [ base := base , sourceMetrics allDependencies ] ].
	^ base
]

{ #category : #accessing }
MTRSourcedEntity >> ast [

	| semaphore result |
	ast ifNotNil: [ ^ ast ].

	semaphore := Semaphore new.
	[ 
	[ result := (self class environment at: #VBParser) parse: source ]
		on: Error
		do: [ :e | result := e ].
	semaphore signal ] forkAt: Processor userBackgroundPriority.
	semaphore
		wait: 5 minute
		onCompletion: [ 
			result isError
				ifTrue: [ ast := nil ]
				ifFalse: [ ast := result ] ]
		onTimeout: [ TimedOut new signal: 'TimeOut' ].
	^ ast
]

{ #category : #accessing }
MTRSourcedEntity >> branchings [
	<cvs: #Branching at: 11>
	sourceMetrics ifNil: [ ^ 0 ].
	sourceMetrics hadErrorOnCalculation
		ifTrue: [ ^ 'Unknown' ].
	^ sourceMetrics branchings
]

{ #category : #accessing }
MTRSourcedEntity >> calculatedSourceMetrics [
	^ sourceMetrics
]

{ #category : #'as yet unclassified' }
MTRSourcedEntity >> codeElement: aString [
	sourceMetrics ifNil: [ ^ {} ].
	^ sourceMetrics children
		select: [ :c | c properties includesKey: aString asSymbol ]
]

{ #category : #'as yet unclassified' }
MTRSourcedEntity >> codeElementValue: aString [
	sourceMetrics ifNil: [ ^ 0 ].
	^ sourceMetrics children
		select: [ :c | c properties includesKey: aString asSymbol ]
		thenCollect: [ :c | c properties at: aString ]
]

{ #category : #accessing }
MTRSourcedEntity >> dropAstMetrics [
	sourceMetrics := nil
]

{ #category : #accessing }
MTRSourcedEntity >> functions [
	<cvs: #Functions at: 10>
	sourceMetrics ifNil: [ ^ 0 ].
	sourceMetrics hadErrorOnCalculation
		ifTrue: [ ^ 'Unknown' ].
	^ sourceMetrics functions size
]

{ #category : #'as yet unclassified' }
MTRSourcedEntity >> grammaticalConsolidatedMetrics [

	^ (self children collect: [ :c | c grammaticalConsolidatedMetrics ])
		  sum
]

{ #category : #'as yet unclassified' }
MTRSourcedEntity >> hadSyntaxErrorOnCalculation [
	sourceMetrics ifNil: [ ^ false ].
	sourceMetrics hadErrorOnCalculation ifFalse: [ ^ false ].
	^ (sourceMetrics properties at:#ERROR) = 'Token not expected'
]

{ #category : #'as yet unclassified' }
MTRSourcedEntity >> hadTimeOutErrorOnCalculation [
	sourceMetrics ifNil: [ ^ false ].
	sourceMetrics hadErrorOnCalculation ifFalse: [ ^ false ].
	^ ((sourceMetrics properties at:#ERROR) = 'Token not expected') not
]

{ #category : #accessing }
MTRSourcedEntity >> loops [
	<cvs: #Loop at: 11>
	sourceMetrics ifNil: [ ^ 0 ].
	sourceMetrics hadErrorOnCalculation
		ifTrue: [ ^ 'Unknown' ].
	^ sourceMetrics loops
]

{ #category : #accessing }
MTRSourcedEntity >> newFunctionMetrics [
	^ self newEntryForType: #Function
]

{ #category : #accessing }
MTRSourcedEntity >> newPropertyAccessorMetrics [
	^ self newEntryForType: #PropertyAccessor
]

{ #category : #'as yet unclassified' }
MTRSourcedEntity >> newPropertyMetrics [
	^ self newEntryForType: #Property
]

{ #category : #accessing }
MTRSourcedEntity >> newSubMetrics [
	^ self newEntryForType: #SubProcedure
]

{ #category : #accessing }
MTRSourcedEntity >> onErrorGoTos [
	<cvs: #OnErrorGoTo at: 13>
	sourceMetrics ifNil: [ ^ 0 ].
	sourceMetrics hadErrorOnCalculation
		ifTrue: [ ^ 'Unknown' ].
	^ sourceMetrics onErrorGoTos
]

{ #category : #accessing }
MTRSourcedEntity >> onErrorResumeNext [
	<cvs: #ErrorResumeNext at: 13>
	sourceMetrics ifNil: [ ^ 0 ].
	sourceMetrics hadErrorOnCalculation
		ifTrue: [ ^ 'Unknown' ].
	^ sourceMetrics onErrorResumeNext
]

{ #category : #accessing }
MTRSourcedEntity >> propertyAccessors [
	<cvs: #PropertiesAccessors at: 12>
	sourceMetrics ifNil: [ ^ 0 ].
	sourceMetrics hadErrorOnCalculation
		ifTrue: [ ^ 'Unknown' ].
	^ sourceMetrics propertyAccessors size
]

{ #category : #accessing }
MTRSourcedEntity >> propetiesDefined [
	<cvs: #Properties at: 12>
	sourceMetrics ifNil: [ ^ 0 ].
	sourceMetrics hadErrorOnCalculation
		ifTrue: [ ^ 'Unknown' ].
	^ sourceMetrics property size
]

{ #category : #accessing }
MTRSourcedEntity >> resumeLabels [
	<cvs: #ResumeLabel at: 13>
	sourceMetrics ifNil: [ ^ 0 ].
	sourceMetrics hadErrorOnCalculation
		ifTrue: [ ^ 'Unknown' ].
	^ sourceMetrics resumeLabels
]

{ #category : #accessing }
MTRSourcedEntity >> resumeNext [
	<cvs: #ResumeNext at: 13>
	sourceMetrics ifNil: [ ^ 0 ].
	sourceMetrics hadErrorOnCalculation
		ifTrue: [ ^ 'Unknown' ].
	^ sourceMetrics resumeNext
]

{ #category : #accessing }
MTRSourcedEntity >> resumes [
	<cvs: #ResumeEmpty at: 13>
	sourceMetrics ifNil: [ ^ 0 ].
	sourceMetrics hadErrorOnCalculation
		ifTrue: [ ^ 'Unknown' ].
	^ sourceMetrics resumes
]

{ #category : #accessing }
MTRSourcedEntity >> solveDependanciesWith: aRoot [

	super solveDependanciesWith: aRoot.
	sourceMetrics ifNil: [ ^ self ].
	sourceMetrics hadErrorOnCalculation
		ifTrue: [ ^ self ].
	sourceMetrics solveDependanciesWith: aRoot
]

{ #category : #accessing }
MTRSourcedEntity >> source [
	^ source 
]

{ #category : #accessing }
MTRSourcedEntity >> source: aSource [
	source := aSource. 
]

{ #category : #accessing }
MTRSourcedEntity >> sourceCodeMetrixExtractor [
	^ MTRASTJinDaoMetricsExtractor new
]

{ #category : #accessing }
MTRSourcedEntity >> sourceMetrics [
	[ sourceMetrics := self sourceCodeMetrixExtractor
		metricsFor: self ast ]
		on: SmaCCParserError , TimedOut , Win32Error
		do: [ :e | 
			sourceMetrics := MTRAstMetric new
				register: #ERROR value: e messageText;
				yourself ].
	^ sourceMetrics
]

{ #category : #accessing }
MTRSourcedEntity >> sourceMetricsIfError [
	sourceMetrics
		ifNotNil: [ sourceMetrics hadErrorOnCalculation
				ifFalse: [ ^ sourceMetrics ] ].
	sourceMetrics := nil. 
	^ self sourceMetrics
]

{ #category : #accessing }
MTRSourcedEntity >> subs [
	<cvs: #SubProcedures at: 11>
	sourceMetrics ifNil: [ ^ 0 ].
	sourceMetrics hadErrorOnCalculation
		ifTrue: [ ^ 'Unknown' ].
	^ sourceMetrics subs size
]
