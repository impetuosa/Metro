Class {
	#name : #MTRASTAlceMetricsExtractor,
	#superclass : #VBProgramNodeVisitor,
	#instVars : [
		'stack',
		'rootmetric'
	],
	#category : #'Metro-Extractor-VBParser'
}

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> initialize [
	super initialize.
	stack := Stack new.
]

{ #category : #'as yet unclassified' }
MTRASTAlceMetricsExtractor >> loadAstMetrics: aMTRModuleMetric [

	| ast |
	rootmetric := aMTRModuleMetric.
	stack push: aMTRModuleMetric.
	ast := aMTRModuleMetric model ast ifNil: [ self halt ].


	self metrics register: #ASTSize value: ast allNodes size.
	ast acceptVisitor: self
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> metrics [
	^ stack top
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> push: aValue during: aBlock [
	stack push: aValue.
	aBlock
		ensure: [ stack pop ]
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitAsTypeAndNew: aTypeAndNew [
	self metrics
		registerDependancy: (aTypeAndNew source copyReplaceAll: 'As ' with: '')
		kind: #TypeAndNew
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitConcatenationOperation: aConcatenationOperation [ 
	self metrics incrementCounterFor: #Concatenation.
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitDoUntilTrue: anObject [
	self metrics incrementCounterFor: #Loop
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitDoWhileTrue: anObject [
	self metrics incrementCounterFor: #Loop
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitExits: anObject [
	self metrics incrementCounterFor: #Exit
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitForEach:  anObject [
	self metrics incrementCounterFor: #Loop
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitForNext:  anObject [
	self metrics incrementCounterFor: #Loop
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitForStepNext:  anObject [
	self metrics incrementCounterFor: #Loop
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitFunctionDefinition: aFunction [

	| context |
	context := self metrics children
		           detect: [ :c | c name = aFunction selector source ]
		           ifFound: [ :p | 
			           p ]
		           ifNone: [ 
							self halt. 
			           self metrics newFunctionMetrics
				           name: aFunction selector source;
				           yourself ].

	self push: context during: [ 
		self metrics register: #ASTSize value: aFunction allNodes size.
		self metrics register: #LOC value: aFunction source lines size.
		super visitFunctionDefinition: aFunction ]
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitGoSub: anObject [
	self metrics incrementCounterFor: #GoSub
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitIfThenElse: anObject [
	self metrics incrementCounterFor: #Branching
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitModuleProperty: aProperty [

	self metrics children
		detect: [ :c | c name = aProperty variable name source ]
		ifFound: [ :context | 
			self push: context during: [ super visitModuleProperty: aProperty ] ]
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitModulePropertyGet: aProperty [

	| accessorType |
	aProperty getToken ifNotNil: [ accessorType := #Get ].
	aProperty setToken ifNotNil: [ accessorType := #Set ].
	aProperty letToken ifNotNil: [ accessorType := #Let ].
	self assert: accessorType isNotNil.


	self
		push: (self metrics children detect: [ :c | 
				 c name = aProperty selector source and: [ 
					 (c value: #Type) = accessorType ] ])
		during: [ 
			self metrics register: #ASTSize value: aProperty allNodes size.
			self metrics register: #LOC value: aProperty source lines size.
			super visitModuleProperty: aProperty ]
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitOnErrorGoTo: anObject [
	self metrics incrementCounterFor: #OnErrorGoTo
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitOnErrorResumeNext: onErrorResumeNext [
	self metrics incrementCounterFor: #OnErrorResumeNext
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitResumeEmpty: anObject [
	self metrics incrementCounterFor: #ResumeEmpty
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitResumeLabel: anObject [
	self metrics incrementCounterFor: #ResumeLabel
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitResumeNext: anObject [
	self metrics incrementCounterFor: #ResumeNext
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitReturn: anObject [
	self metrics incrementCounterFor: #Return
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitSelect: anObject [
	self metrics incrementCounterFor: #Branching
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitSubDefinition: aSub [

	| context |
	context := self metrics children
		           detect: [ :c | c name = aSub selector source ]
		           ifNone: [ 
			           self metrics newSubMetrics
				           name: aSub selector source;
				           yourself ].

	self push: context during: [ 
		self metrics register: #ASTSize value: aSub allNodes size.
		self metrics register: #LOC value: aSub source lines size.
		super visitSubDefinition: aSub ]
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitTypedThing: aTypedThing [
	self metrics
		registerDependancy: (aTypedThing source copyReplaceAll: 'As ' with: '')
		kind: #Type
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitWhileTrue: anObject [
	self metrics incrementCounterFor: #Loop
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> visitWhileWend:  anObject [
	self metrics incrementCounterFor: #Loop
]
