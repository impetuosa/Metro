Class {
	#name : #MTRSubProcedureMetric,
	#superclass : #MTRAstMetric,
	#category : #'Metro-Model'
}

{ #category : #'as yet unclassified' }
MTRSubProcedureMetric >> grammaticalConsolidatedMetrics [

	^ self onErrorResumeNext + self onErrorGoTos + self goSubs
	  + self resumes + self resumeNext + self resumeLabels
]
