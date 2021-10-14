Class {
	#name : #MTRProjectMetric,
	#superclass : #MTRStructuralMetric,
	#category : #'Metro-Model'
}

{ #category : #'instance creation' }
MTRProjectMetric >> accessModules [

	^ children at: #AccessModule ifAbsent: [ {  } ]
]

{ #category : #'as yet unclassified' }
MTRProjectMetric >> exportCVS [

	| projectBase |
	projectBase := self model name asFileReference
		               ensureCreateDirectory;
		               yourself.
	self accessModules do: [ :module | 
		| base |
		base := (projectBase / module model name)
			        ensureCreateDirectory;
			        yourself.

		module exportMetrics: base sufix: '' ]
]

{ #category : #'instance creation' }
MTRProjectMetric >> formsPerProject [

	^ self accessModules collect: [ :m | m model name  -> m forms size ]
]

{ #category : #'as yet unclassified' }
MTRProjectMetric >> grammaticalCounts [
		^ self accessModules collect: [  : m | m model name -> (m grammaticalConsolidatedMetrics ) ]
]

{ #category : #'as yet unclassified' }
MTRProjectMetric >> grammaticalRatios [
		^( self accessModules collect: [  : m | m model name -> (m consolidatedGrammaticalRatios ) ]) asDictionary 
]

{ #category : #'instance creation' }
MTRProjectMetric >> newAccessModuleMetric [
	^ self newEntryForType: #AccessModule
]

{ #category : #'instance creation' }
MTRProjectMetric >> paradigmaticCounts [

	^ self accessModules collect: [ :m | 
		  m model name
		  ->
			  (m forms size + m reports size + m tables size + m queries size
			   + m modules size) ]
]

{ #category : #'instance creation' }
MTRProjectMetric >> paradigmaticRates [

	^ self accessModules collect: [ :m | 
		  m model name -> { 
			  (m forms size + m reports size + m tables size + m queries size
			   + m modules size).

			  m classModules size } ]
]

{ #category : #'instance creation' }
MTRProjectMetric >> paradigmaticRatios [

	^ (self accessModules collect: [ :m | 
		  m model name -> { 
			  (m forms size + m reports size + m tables size + m queries size
			   + m modules size).

			  m classModules size } ]) asDictionary 
]

{ #category : #'as yet unclassified' }
MTRProjectMetric >> referencesCounts [

	^ self accessModules collect: [ :m | 
		  m model name -> m model references size ]
]

{ #category : #'as yet unclassified' }
MTRProjectMetric >> referencesDetailedTangling [

	^ self accessModules collect: [ :m | 
		  m model name -> m referenceDetailedTangling ]
]

{ #category : #'as yet unclassified' }
MTRProjectMetric >> referencesTangling [

	^ self accessModules collect: [ :m | 
		  m model name -> (((self model mooseModel coloringStrategyFor:
			     AlceHorizontalColorPropagation) colorsFor: m model) collect: [ 
			   :c | c dueToChainOnlyFst ]) asSet size ]
]

{ #category : #'as yet unclassified' }
MTRProjectMetric >> referencesTanglingRatios [

	| tags |
	self halt. 
	tags := self accessModules collect: [ :m | 
		        m model name -> { 
			        m allAstSizes sum.
			        (((self model mooseModel coloringStrategyFor:
				           AlceHorizontalColorPropagation) colorsFor: m model) 
				         collect: [ :t | t dueToChainOnlyFst ])asSet size } ].
	^ tags
]
