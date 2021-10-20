Class {
	#name : #MTRMetricsFinder,
	#superclass : #Object,
	#instVars : [
		'projectMetrics',
		'stack'
	],
	#category : #'Metro-Model'
}

{ #category : #'as yet unclassified' }
MTRMetricsFinder >> findMetricsFor: anAlcixAccessModule [

	anAlcixAccessModule accept: self.
	^ stack top
]

{ #category : #accessing }
MTRMetricsFinder >> initialize [

	super initialize.
	stack := Stack new
]

{ #category : #accessing }
MTRMetricsFinder >> projectMetrics: aMTRProjectMetric [ 
	projectMetrics := aMTRProjectMetric.
	stack push: projectMetrics
]

{ #category : #visiting }
MTRMetricsFinder >> visitAccess: anAlcixAccess [

	anAlcixAccess withAccesses accept: self
]

{ #category : #visiting }
MTRMetricsFinder >> visitAccessModule: anAlcixAccessModule [
	stack push:
		(stack top accessModules detect: [ :a | 
			 a model = anAlcixAccessModule ])
]

{ #category : #visiting }
MTRMetricsFinder >> visitAssignment: anAlcixAssignment [ 
	anAlcixAssignment owner accept: self
]

{ #category : #visiting }
MTRMetricsFinder >> visitAttribute: anAlcixAttribute [

	| specific |
	anAlcixAttribute userType accept: self.
	specific := stack top children
		            detect: [ :a | a model = anAlcixAttribute ]
		            ifNone: [ nil ].
	specific ifNotNil: [ stack push: specific ]
]

{ #category : #visiting }
MTRMetricsFinder >> visitAttributeAccessor: anAlcixAttributeAccessor [

	self visitAttribute: anAlcixAttributeAccessor
]

{ #category : #visiting }
MTRMetricsFinder >> visitClass: anAlcixClass [

	self visitModule: anAlcixClass
]

{ #category : #visiting }
MTRMetricsFinder >> visitConstant: anAlcixConstant [ 
	anAlcixConstant owner accept: self 
]

{ #category : #visiting }
MTRMetricsFinder >> visitExternalFunction: anAlcixExternalFunction [

	self visitAttribute: anAlcixExternalFunction
]

{ #category : #visiting }
MTRMetricsFinder >> visitExternalSubProcedure: anAlcixExternalSubProcedure [

	self visitAttribute: anAlcixExternalSubProcedure
]

{ #category : #visiting }
MTRMetricsFinder >> visitForm: anAlcixForm [

	self visitModule: anAlcixForm
]

{ #category : #visiting }
MTRMetricsFinder >> visitFunction: anAlcixFunction [

	self visitAttribute: anAlcixFunction
]

{ #category : #visiting }
MTRMetricsFinder >> visitInvocation: anAlcixInvocation [ 
	anAlcixInvocation withAccesses accept: self 
]

{ #category : #visiting }
MTRMetricsFinder >> visitLibrary: anAlcixLibrary [ 
	
]

{ #category : #visiting }
MTRMetricsFinder >> visitLocalVariable: anAlcixLocalVariable [ 
	anAlcixLocalVariable invocable accept: self 
]

{ #category : #visiting }
MTRMetricsFinder >> visitModel: anAlcixModel [ 
	
]

{ #category : #visiting }
MTRMetricsFinder >> visitModule: anAlcixModule [

	| spec |
	anAlcixModule container accept: self.
	spec := stack top children
		        detect: [ :a | a model = anAlcixModule ]
		        ifNone: [ nil ].
	spec ifNotNil: [ stack push: spec ]
]

{ #category : #visiting }
MTRMetricsFinder >> visitParameter: anAlcixParameter [

	anAlcixParameter invocable accept: self
]

{ #category : #visiting }
MTRMetricsFinder >> visitQuery: anAlcixQuery [

	self visitModule: anAlcixQuery
]

{ #category : #visiting }
MTRMetricsFinder >> visitReport: anAlcixForm [

	self visitModule: anAlcixForm
]

{ #category : #visiting }
MTRMetricsFinder >> visitReturn: anAlcixReturn [ 

]

{ #category : #visiting }
MTRMetricsFinder >> visitSubProcedure: anAlcixSubProcedure [

	self visitAttribute: anAlcixSubProcedure
]

{ #category : #visiting }
MTRMetricsFinder >> visitTable: anAlcixTable [ 
	self visitModule: anAlcixTable 
]
