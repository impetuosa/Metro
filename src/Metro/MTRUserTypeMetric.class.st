Class {
	#name : #MTRUserTypeMetric,
	#superclass : #MTRStructuralMetric,
	#category : #'Metro-Model'
}

{ #category : #'as yet unclassified' }
MTRUserTypeMetric >> grammaticalConsolidatedMetrics [

	^ 0
]

{ #category : #'as yet unclassified' }
MTRUserTypeMetric >> grammaticalConsolidatedRatioMetrics [
	^ 0
]

{ #category : #accessing }
MTRUserTypeMetric >> properties [
	^ properties at:#properties ifAbsent: nil 
]
