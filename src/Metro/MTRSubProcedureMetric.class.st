Class {
	#name : #MTRSubProcedureMetric,
	#superclass : #MTRAstMetric,
	#category : #'Metro-Model'
}

{ #category : #'instance creation' }
MTRSubProcedureMetric >> astSize [

	<cvs: #ASTSize at: 2>
	^ properties at: #ASTSize ifAbsent: 1
]

{ #category : #'as yet unclassified' }
MTRSubProcedureMetric >> grammaticalConsolidatedMetrics [

	^ self onErrorResumeNext + self onErrorGoTos + self goSubs
	  + self resumes + self resumeNext + self resumeLabels
]

{ #category : #'instance creation' }
MTRSubProcedureMetric >> paradigmaticCounts [
	^ {}
]
