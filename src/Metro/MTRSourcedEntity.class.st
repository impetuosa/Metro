Class {
	#name : #MTRSourcedEntity,
	#superclass : #MTRStructuralMetric,
	#instVars : [
		'source',
		'sourceMetrics',
		'ast'
	],
	#category : #'Metro-Model'
}

{ #category : #accessing }
MTRSourcedEntity >> LOC [
	^ properties at:#LOC ifAbsent: nil 
]

{ #category : #accessing }
MTRSourcedEntity >> allDependencies [
	| base |
	base := super allDependencies.
	sourceMetrics
		ifNotNil: [ sourceMetrics hadErrorOnCalculation
				ifFalse: [ base := base , sourceMetrics allDependencies ] ].
	^ base
]

{ #category : #'csv properties' }
MTRSourcedEntity >> amountOfDependenceUsage [
	<cvs: #PointsOfUseOFDependency at: 2>
	self hadErrorOnCalculation ifTrue: [ ^ 'Unknown' ].
	^ properties at: #AmountOfDependenceUsage ifAbsent: [ 
		  self resolveTanglingReferences.
		  properties at: #AmountOfDependenceUsage ]
]

{ #category : #'csv properties' }
MTRSourcedEntity >> amountOfDependenceUsage: aValue [

	^ self register: #AmountOfDependenceUsage value: aValue
]

{ #category : #'csv properties' }
MTRSourcedEntity >> amountOfDependencies [

	<cvs: #DependencyArtefactsUsed at: 2>
	self hadErrorOnCalculation ifTrue: [ ^ 'Unknown' ].
	^ properties at: #AmountOfDependencies ifAbsent: [ 
		  self resolveTanglingReferences.
		  properties at: #AmountOfDependencies ]
]

{ #category : #'csv properties' }
MTRSourcedEntity >> amountOfDependencies: aValue [

	^ self register: #AmountOfDependencies value: aValue
]

{ #category : #'csv properties' }
MTRSourcedEntity >> amountOfLanguageDependency [

	<cvs: #AmountLanguageDependency at: 2>
	self hadErrorOnCalculation ifTrue: [ ^ 'Unknown' ].
	^ properties at: #AmountOfLanguageDependency ifAbsent: [ 
		  self resolveTanglingReferences.
		  properties at: #AmountOfLanguageDependency ]
]

{ #category : #'csv properties' }
MTRSourcedEntity >> amountOfLanguageDependency: aValue [

	^ self register: #AmountOfLanguageDependency value: aValue
]

{ #category : #'csv properties' }
MTRSourcedEntity >> amountOfLanguageUsage [

	<cvs: #LanguageDependency at: 2>
	self hadErrorOnCalculation ifTrue: [ ^ 'Unknown' ].
	^ properties at: #AmountOfLanguageUsage ifAbsent: [ 
		  self resolveTanglingReferences.
		  properties at: #AmountOfLanguageUsage ]
]

{ #category : #'csv properties' }
MTRSourcedEntity >> amountOfLanguageUsage: aValue [

	^ self register: #AmountOfLanguageUsage value: aValue
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

{ #category : #'csv properties' }
MTRSourcedEntity >> astSize [

	<cvs: #ASTSize at: 2>
	self hadErrorOnCalculation ifTrue: [ ^ 'Unknown' ].
	^ properties at: #ASTSize ifAbsent: 0
]

{ #category : #'csv properties' }
MTRSourcedEntity >> branchings [

	<cvs: #Branching at: 11>
	self hadErrorOnCalculation ifTrue: [ ^ 'Unknown' ].
	^ (self invocables collect: #branchings) sum
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

{ #category : #'csv properties' }
MTRSourcedEntity >> functions [

	<cvs: #Functions at: 10>
	self hadErrorOnCalculation ifTrue: [ ^ 'Unknown' ].
	^ (self invocables select: [ :a | a isKindOf: MTRFunctionMetric ])
		  size
]

{ #category : #'as yet unclassified' }
MTRSourcedEntity >> grammaticalConsolidatedMetrics [

	^ (self children collect: [ :c | c grammaticalConsolidatedMetrics ])
		  sum
]

{ #category : #'as yet unclassified' }
MTRSourcedEntity >> grammaticalConsolidatedRatioMetrics [

	^ (self children collect: [ :c | c grammaticalConsolidatedRatioMetrics ])
		  sum
]

{ #category : #'instance creation' }
MTRSourcedEntity >> hadErrorOnCalculation [

	^ properties at: #ErrorParsing ifAbsent: false
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
MTRSourcedEntity >> invocables [

	^ (children values flatCollect: #yourself) select: [ :a | 
		  a model isKindOf: AlcixInvocable ]
]

{ #category : #'as yet unclassified' }
MTRSourcedEntity >> loc [
	<cvs: #'LOC' at: 2>
	^ self LOC
]

{ #category : #'csv properties' }
MTRSourcedEntity >> loops [
	<cvs: #Loop at: 11>
	self hadErrorOnCalculation ifTrue: [ ^ 'Unknown' ].
	^ (self invocables collect: #loops) sum
]

{ #category : #'csv properties' }
MTRSourcedEntity >> members [

	<cvs: #Members at: 10>
	self hadErrorOnCalculation ifTrue: [ ^ 'Unknown' ].
	^ properties at: #Members ifAbsent: 0
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

{ #category : #'csv properties' }
MTRSourcedEntity >> onErrorGoTos [

	<cvs: #OnErrorGoTo at: 13>
	self hadErrorOnCalculation ifTrue: [ ^ 'Unknown' ].
	^ (self invocables collect: #onErrorGoTos) sum
]

{ #category : #'csv properties' }
MTRSourcedEntity >> onErrorResumeNext [
	<cvs: #ErrorResumeNext at: 13>
	self hadErrorOnCalculation ifTrue: [ ^ 'Unknown' ].
	^ (self invocables collect: #onErrorResumeNext) sum
]

{ #category : #'csv properties' }
MTRSourcedEntity >> propertyAccessors [

	<cvs: #PropertiesAccessors at: 12>
	self hadErrorOnCalculation ifTrue: [ ^ 'Unknown' ].
	^ (self invocables select: [ :a | 
		   a isKindOf: MTRPropertyAccessorMetric ]) size
]

{ #category : #'csv properties' }
MTRSourcedEntity >> propetiesDefined [

	<cvs: #Properties at: 12>
	self hadErrorOnCalculation ifTrue: [ ^ 'Unknown' ].
	^ ((children values flatCollect: #yourself) select: [ :a | 
		   a isKindOf: MTRPropertyMetric ]) size
]

{ #category : #'csv properties' }
MTRSourcedEntity >> referencesDetailedTangling [

	| all |
	all := (self model mooseModel coloringStrategyFor:
		        AlceHorizontalColorPropagation) colorsFor: model.


	^ (all select: [ :a | 
		   (a thirdLink respondsTo: #userType) not or: [ 
			   a thirdLink userType = model ] ]) groupedBy: #lastLink
]

{ #category : #'csv properties' }
MTRSourcedEntity >> resolveTanglingReferences [

	| referencesTangleing langRefs |
	referencesTangleing := self referencesDetailedTangling.
	langRefs := referencesTangleing keys select: [ :a | 
		            a name = #VBALang or: [ a name = #VBA ] ].

	self amountOfDependencies: referencesTangleing size.
	self amountOfDependenceUsage:
		((referencesTangleing values flatCollect: #yourself) collect:
			 #secondLink) asSet size.
	self amountOfLanguageDependency: langRefs size.
	self amountOfLanguageUsage:
		((langRefs flatCollect: [ :a | referencesTangleing at: a ]) 
			 collect: #secondLink) asSet size
]

{ #category : #'csv properties' }
MTRSourcedEntity >> resumeLabels [

	<cvs: #ResumeLabel at: 13>
	self hadErrorOnCalculation ifTrue: [ ^ 'Unknown' ].
	^ (self invocables collect: #resumeLabels) sum
]

{ #category : #'csv properties' }
MTRSourcedEntity >> resumeNext [

	<cvs: #ResumeNext at: 13>
	self hadErrorOnCalculation ifTrue: [ ^ 'Unknown' ].
	^ (self invocables collect: #resumeNext) sum
]

{ #category : #'csv properties' }
MTRSourcedEntity >> resumes [
	<cvs: #ResumeEmpty at: 13>
	self hadErrorOnCalculation ifTrue: [ ^ 'Unknown' ].
	^ (self invocables collect: #resumes) sum
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

{ #category : #'csv properties' }
MTRSourcedEntity >> subs [

	<cvs: #SubProcedures at: 11>
	self hadErrorOnCalculation ifTrue: [ ^ 'Unknown' ].
	^ (self invocables select: [ :a | a isKindOf: MTRSubProcedureMetric ])
		  size
]
