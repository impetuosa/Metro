Class {
	#name : #MTRPropertyAccessorMetric,
	#superclass : #MTRAstMetric,
	#category : #'Metro-Model'
}

{ #category : #'as yet unclassified' }
MTRPropertyAccessorMetric >> grammaticalConsolidatedMetrics [

	^ self onErrorResumeNext + self onErrorGoTos + self goSubs
	  + self resumes + self resumeNext + self resumeLabels
]

{ #category : #'instance creation' }
MTRPropertyAccessorMetric >> paradigmaticCounts [

	^ {  }
]
