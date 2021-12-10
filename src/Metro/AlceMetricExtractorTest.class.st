Class {
	#name : #AlceMetricExtractorTest,
	#superclass : #TestCase,
	#instVars : [
		'stack',
		'testingModel',
		'metrics'
	],
	#category : #'Metro-Extractor-Alce'
}

{ #category : #'as yet unclassified' }
AlceMetricExtractorTest class >> egrcModel [ 
	^ AlcixModel allInstances first 
]

{ #category : #'as yet unclassified' }
AlceMetricExtractorTest >> computeMetrics: anAlcixModel [

	^ MTRAlceMetricsExtractor metricsFor: anAlcixModel
]

{ #category : #initialization }
AlceMetricExtractorTest >> runCaseManaged [ 
	^ self runCase 
]

{ #category : #initialization }
AlceMetricExtractorTest >> setUp [
	super setUp.
	testingModel := self class egrcModel.
	metrics := self computeMetrics: testingModel. 
]

{ #category : #initialization }
AlceMetricExtractorTest >> testEgrcHas8Modules [

	self assert: metrics accessModules size equals: 8
]
