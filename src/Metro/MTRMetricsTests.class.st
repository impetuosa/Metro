Class {
	#name : #MTRMetricsTests,
	#superclass : #JinNorwindBasedTests,
	#instVars : [
		'extractor',
		'metrics'
	],
	#category : #Metro
}

{ #category : #running }
MTRMetricsTests >> setUp [
	super setUp.
	extractor := MTRStructuralMetricsExtractor new.
	metrics := extractor metricsFor: project
]

{ #category : #running }
MTRMetricsTests >> testAllQueriesHaveDependencies [
	self
		assert:
			(metrics queries
				allSatisfy: [ :q | q registeredDependencies isNotEmpty ])
]

{ #category : #running }
MTRMetricsTests >> testAllQueriesHaveFields [
	self
		assert:
			(metrics queries
				allSatisfy: [ :q | (q value:#Fields ) > 0  ])
]

{ #category : #running }
MTRMetricsTests >> testAllTablesHaveDependencies [
	self
		assert:
			(metrics tables
				allSatisfy: [ :q | q registeredDependencies isNotEmpty ])
]

{ #category : #running }
MTRMetricsTests >> testAllTablesHaveFields [
	self
		assert:
			(metrics tables
				allSatisfy: [ :q | (q value:#Fields ) > 0  ])
]

{ #category : #running }
MTRMetricsTests >> testClassModulesAre2 [
	self assert: metrics classModules size equals: 2
]

{ #category : #running }
MTRMetricsTests >> testErrorHandlingModuleMetrics [
	self halt 
]

{ #category : #running }
MTRMetricsTests >> testFormsAre34 [
	self assert: metrics forms size equals: 34
]

{ #category : #running }
MTRMetricsTests >> testMacrosAre2 [
	self assert: metrics macros size equals: 2
]

{ #category : #running }
MTRMetricsTests >> testModulesAre7 [
	self assert: metrics modules size equals: 7
]

{ #category : #running }
MTRMetricsTests >> testQueriesAre27 [
	self assert: metrics queries size equals: 27
]

{ #category : #running }
MTRMetricsTests >> testReportsAre15 [
	self assert: metrics reports size equals: 15
]

{ #category : #running }
MTRMetricsTests >> testTablesAre32 [
	self assert: metrics tables size equals: 32
]
