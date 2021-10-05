Class {
	#name : #MTRProjectMetric,
	#superclass : #MTRStructuralMetric,
	#category : #'Metro-Model'
}

{ #category : #'instance creation' }
MTRProjectMetric >> accessModules [

	^ children at: #AccessModule ifAbsent: [ {  } ]
]

{ #category : #'instance creation' }
MTRProjectMetric >> formsPerProject [

	^ self accessModules collect: [ :m | m model name  -> m forms size ]
]

{ #category : #'as yet unclassified' }
MTRProjectMetric >> grammaticalCounts [
		^ self accessModules collect: [  : m | m name -> (m grammaticalConsolidatedMetrics ) ]
]

{ #category : #'instance creation' }
MTRProjectMetric >> newAccessModuleMetric [
	^ self newEntryForType: #AccessModule
]

{ #category : #'instance creation' }
MTRProjectMetric >> paradigmaticCounts [

	^ self accessModules collect: [ :m | m model name  ->( m forms size + m reports size + m tables size  + m queries size + m modules size  ) ]
]

{ #category : #'as yet unclassified' }
MTRProjectMetric >> referencesCounts [

	^ self accessModules collect: [ :m | 
		  m model name -> m model references size ]
]

{ #category : #'as yet unclassified' }
MTRProjectMetric >> referencesTangling [

	^ self accessModules collect: [ :m | 
		  m model name
		  ->
			  (self model mooseModel coloringStrategies first colorsFor:
				   m model) size ]
]
