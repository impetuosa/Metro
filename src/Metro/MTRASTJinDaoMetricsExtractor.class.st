Class {
	#name : #MTRASTJinDaoMetricsExtractor,
	#superclass : #VBProgramNodeVisitor,
	#instVars : [
		'stack'
	],
	#category : #'Metro-Extractor-VBParser'
}

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> initialize [
	super initialize.
	stack := Stack new.
	stack push: MTRAstMetric new
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> metrics [
	^ stack top
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> metricsFor: anAST [
	self metrics register: #LOC value: anAST source lines size.
	anAST acceptVisitor: self.
	^ self metrics
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> push: aValue during: aBlock [
	stack push: aValue.
	aBlock
		ensure: [ stack pop ]
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitAsTypeAndNew: aTypeAndNew [
	self metrics
		registerDependancy: (aTypeAndNew source copyReplaceAll: 'As ' with: '')
		kind: #TypeAndNew
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitAssignementOrEquals: anObject [
	self metrics incrementCounterFor: #AssignmentOrEquality
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitConcatenationOperation: aConcatenationOperation [ 
	self metrics incrementCounterFor: #Concatenation.
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitDoUntilTrue: anObject [
	self metrics incrementCounterFor: #Loop
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitDoWhileTrue: anObject [
	self metrics incrementCounterFor: #Loop
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitExit: anObject [
	self metrics incrementCounterFor: #Exit
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitExplicitAssignement: anObject [
	self metrics incrementCounterFor: #ExplicitAssignment
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitForEach:  anObject [
	self metrics incrementCounterFor: #Loop
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitForNext:  anObject [
	self metrics incrementCounterFor: #Loop
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitForStepNext:  anObject [
	self metrics incrementCounterFor: #Loop
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitFunctionDefinition: aFunction [
	self
		push: self metrics newFunctionMetrics
		during: [ 
			self metrics register:#Name value: aFunction selector source.
			self metrics register:#LOC value: aFunction source lines size. 
			super visitFunctionDefinition: aFunction ]
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitGoSub: anObject [
	self metrics incrementCounterFor: #GoSub
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitIfThenColon: anObject [
	self metrics incrementCounterFor: #Branching
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitIfThenElse: anObject [
	self metrics incrementCounterFor: #Branching
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitIfThenElseIfElse: anObject [
	self metrics incrementCounterFor: #Branching
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitModuleProperty: aProperty [
	self
		push: self metrics newPropertyMetrics
		during: [ 
			self metrics register: #Name value: aProperty variable name source.
			super visitModuleProperty: aProperty.
		 ]
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitModulePropertyGet: aProperty [
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
MTRASTJinDaoMetricsExtractor >> visitOnErrorGoTo: anObject [
	self metrics incrementCounterFor: #OnErrorGoTo
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitOnErrorResumeNext: onErrorResumeNext [
	self metrics incrementCounterFor: #OnErrorResumeNext
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitResumeEmpty: anObject [
	self metrics incrementCounterFor: #ResumeEmpty
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitResumeLabel: anObject [
	self metrics incrementCounterFor: #ResumeLabel
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitResumeNext: anObject [
	self metrics incrementCounterFor: #ResumeNext
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitReturn: anObject [
	self metrics incrementCounterFor: #Return
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitSelect: anObject [
	self metrics incrementCounterFor: #Branching
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitSubDefinition: aSub [
	self
		push: self metrics newSubMetrics
		during: [ 
			self metrics register: #Name value: aSub selector source.
			self metrics register: #LOC value: aSub source lines size.
			super visitSubDefinition: aSub ]
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitTypedThing: aTypedThing [
	self metrics
		registerDependancy: (aTypedThing source copyReplaceAll: 'As ' with: '')
		kind: #Type
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitWhileTrue: anObject [
	self metrics incrementCounterFor: #Loop
]

{ #category : #initialization }
MTRASTJinDaoMetricsExtractor >> visitWhileWend:  anObject [
	self metrics incrementCounterFor: #Loop
]
