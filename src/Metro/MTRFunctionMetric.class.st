Class {
	#name : #MTRFunctionMetric,
	#superclass : #MTRAstMetric,
	#category : #'Metro-Model'
}

{ #category : #'as yet unclassified' }
MTRFunctionMetric >> grammaticalConsolidatedMetrics [

	^ self onErrorResumeNext + self onErrorGoTos + self goSubs
	  + self resumes + self resumeNext + self resumeLabels
]

{ #category : #'instance creation' }
MTRFunctionMetric >> paradigmaticCounts [
	^ {}
]

{ #category : #'instance creation' }
MTRFunctionMetric >> paradigmaticRatios [

	^ {  }
]
