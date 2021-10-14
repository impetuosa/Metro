Class {
	#name : #MTRProjectMetric,
	#superclass : #MTRStructuralMetric,
	#category : #'Metro-Model'
}

{ #category : #'instance creation' }
MTRProjectMetric >> accessModules [

	^ children at: #AccessModule ifAbsent: [ {  } ]
]

{ #category : #consolidation }
MTRProjectMetric >> classModulesMetrics [

	^ self accessModules anyOne classModulesMetricsHeaders , String crlf
	  , (String crlf join: (self accessModules collect: #classModulesMetrics))
]

{ #category : #'as yet unclassified' }
MTRProjectMetric >> exportCVS [

	| projectBase |
	projectBase := self model name asFileReference
		               ensureCreateDirectory;
		               yourself.
	self exportMetrics: projectBase sufix: ''
]

{ #category : #'as yet unclassified' }
MTRProjectMetric >> exportMetrics: aDirectory sufix: aSufixName [

	| stream |
	{ #formMetrics. #macrosMetrics. #modulesMetrics. #classModulesMetrics.
	#referencesMetrics. #queriesMetrics. #tablesMetrics. #reportMetrics } 
		do: [ :m | 
			stream := (aDirectory / (aSufixName , m , '.csv')) writeStream.
			stream
				nextPutAll: (self perform: m);
				flush;
				close.
			(aDirectory / (aSufixName , m , '.csv')) readStream upToEnd isEmpty 
				ifTrue: [ (aDirectory / (aSufixName , m , '.csv')) ensureDelete ] ]
]

{ #category : #consolidation }
MTRProjectMetric >> formMetrics [

	^ self accessModules anyOne formMetricsHeaders , String crlf
	  , (String crlf join: (self accessModules collect: #formMetrics))
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

{ #category : #consolidation }
MTRProjectMetric >> macrosMetrics [

	^ self accessModules anyOne macrosMetricsHeader , String crlf
	  , (String crlf join: (self accessModules collect: #macrosMetrics))
]

{ #category : #consolidation }
MTRProjectMetric >> modulesMetrics [

	^ self accessModules anyOne modulesMetricsHeader , String crlf
	  , (String crlf join: (self accessModules collect: #modulesMetrics))
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

{ #category : #consolidation }
MTRProjectMetric >> queriesMetrics [

	^ self accessModules anyOne queriesMetricsHeaders , String crlf
	  , (String crlf join: (self accessModules collect: #queriesMetrics))
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

{ #category : #consolidation }
MTRProjectMetric >> referencesMetrics [
	^ self accessModules anyOne referencesMetricsHeader , String crlf
	  , (String crlf join: (self accessModules collect: #referencesMetrics))
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

{ #category : #consolidation }
MTRProjectMetric >> reportMetrics [

	^ self accessModules anyOne reportMetricsHeaders , String crlf
	  , (String crlf join: (self accessModules collect: #reportMetrics))
]

{ #category : #consolidation }
MTRProjectMetric >> tablesMetrics [

	^ self accessModules anyOne tablesMetricsHeader , String crlf
	  , (String crlf join: (self accessModules collect: #tablesMetrics))
]
