Class {
	#name : #MTRASTMetricsExtractor,
	#superclass : #VBProgramNodeVisitor,
	#instVars : [
		'stack'
	],
	#category : #Metro
}

{ #category : #initialization }
MTRASTMetricsExtractor >> initialize [
	super initialize.
	stack := Stack new.
	stack push: MTRAstMetric new
]

{ #category : #initialization }
MTRASTMetricsExtractor >> metrics [
	^ stack top
]

{ #category : #initialization }
MTRASTMetricsExtractor >> metricsFor: anAST [
	self metrics register: #LOC value: anAST source lines size.
	anAST acceptVisitor: self.
	^ self metrics
]

{ #category : #initialization }
MTRASTMetricsExtractor >> push: aValue during: aBlock [
	stack push: aValue.
	aBlock
		ensure: [ stack pop ]
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitAsTypeAndNew: aTypeAndNew [
	self metrics
		registerDependancy: (aTypeAndNew source copyReplaceAll: 'As ' with: '')
		kind: #TypeAndNew
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitAssignementOrEquals: anObject [
	self metrics incrementCounterFor: #AssignmentOrEquality
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitConcatenationOperation: aConcatenationOperation [ 
	self metrics incrementCounterFor: #Concatenation.
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitDoUntilTrue: anObject [
	self metrics incrementCounterFor: #Loop
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitDoWhileTrue: anObject [
	self metrics incrementCounterFor: #Loop
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitExit: anObject [
	self metrics incrementCounterFor: #Exit
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitExplicitAssignement: anObject [
	self metrics incrementCounterFor: #ExplicitAssignment
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitForEach:  anObject [
	self metrics incrementCounterFor: #Loop
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitForNext:  anObject [
	self metrics incrementCounterFor: #Loop
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitForStepNext:  anObject [
	self metrics incrementCounterFor: #Loop
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitFunctionDefinition: aFunction [
	self
		push: self metrics newFunctionMetrics
		during: [ 
			self metrics register:#Name value: aFunction selector source.
			self metrics register:#LOC value: aFunction source lines size. 
			super visitFunctionDefinition: aFunction ]
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitGoSub: anObject [
	self metrics incrementCounterFor: #GoSub
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitIfThenColon: anObject [
	self metrics incrementCounterFor: #Branching
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitIfThenElse: anObject [
	self metrics incrementCounterFor: #Branching
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitIfThenElseIfElse: anObject [
	self metrics incrementCounterFor: #Branching
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitModuleProperty: aProperty [
	self
		push: self metrics newPropertyMetrics
		during: [ 
			self metrics register: #Name value: aProperty variable name source.
			super visitModuleProperty: aProperty.
		 ]
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitModulePropertyGet: aProperty [
	| accessorType |
	aProperty getToken ifNotNil: [ accessorType := #Get ].
	aProperty setToken ifNotNil: [ accessorType := #Set ].
	aProperty letToken ifNotNil: [ accessorType := #Let ].
	self assert: accessorType isNotNil.
	self
		push: self metrics newPropertyAccessorMetrics
		during: [ self metrics register: #Name value: aProperty selector source.
			self metrics register: #Type value: accessorType.
			super visitModuleProperty: aProperty ]
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitOnErrorGoTo: anObject [
	self metrics incrementCounterFor: #OnErrorGoTo
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitOnErrorResumeNext: onErrorResumeNext [
	self metrics incrementCounterFor: #OnErrorResumeNext
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitResumeEmpty: anObject [
	self metrics incrementCounterFor: #ResumeEmpty
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitResumeLabel: anObject [
	self metrics incrementCounterFor: #ResumeLabel
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitResumeNext: anObject [
	self metrics incrementCounterFor: #ResumeNext
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitReturn: anObject [
	self metrics incrementCounterFor: #Return
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitSelect: anObject [
	self metrics incrementCounterFor: #Branching
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitSubDefinition: aSub [
	self
		push: self metrics newSubMetrics
		during: [ 
			self metrics register: #Name value: aSub selector source.
			self metrics register: #LOC value: aSub source lines size.
			super visitSubDefinition: aSub ]
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitTypedThing: aTypedThing [
	self metrics
		registerDependancy: (aTypedThing source copyReplaceAll: 'As ' with: '')
		kind: #Type
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitWhileTrue: anObject [
	self metrics incrementCounterFor: #Loop
]

{ #category : #initialization }
MTRASTMetricsExtractor >> visitWhileWend:  anObject [
	self metrics incrementCounterFor: #Loop
]
