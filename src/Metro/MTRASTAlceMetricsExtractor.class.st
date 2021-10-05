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

	ast := aMTRModuleMetric ast.
	ast acceptVisitor: self
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> metrics [
	^ stack top
]

{ #category : #initialization }
MTRASTAlceMetricsExtractor >> metricsFor: anAST [
	self metrics register: #LOC value: anAST source lines size.
	anAST acceptVisitor: self.
	^ self metrics
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

	self metrics children
		detect: [ :c | c name = aFunction selector source ]
		ifFound: [ :context | 
			self push: context during: [ 
				self metrics register: #LOC value: aFunction source lines size.
				super visitSubDefinition: aFunction ] ]
		ifNone: [ 
			self push: self metrics newFunctionMetrics during: [ 
				self metrics register: #Name value: aFunction selector source.
				self metrics register: #LOC value: aFunction source lines size.
				super visitFunctionDefinition: aFunction ] ]
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
				 c name = aProperty selector source ])
		during: [ 
			self metrics register: #Type value: accessorType.
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

	self metrics children
		detect: [ :c | c name = aSub selector source ]
		ifFound: [ :context | 
			self push: context during: [ 
				self metrics register: #LOC value: aSub source lines size.
				super visitSubDefinition: aSub ] ]
		ifNone: [ 
			self push: self metrics newFunctionMetrics during: [ 
				self metrics register: #Name value: aSub selector source.
				self metrics register: #LOC value: aSub source lines size.
				super visitFunctionDefinition: aSub ] ]
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
