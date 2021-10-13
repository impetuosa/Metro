Class {
	#name : #MTRAlceMetricsExtractor,
	#superclass : #Object,
	#instVars : [
		'stack',
		'projectMetrics'
	],
	#classInstVars : [
		'metrics'
	],
	#category : #'Metro-Extractor-Alce'
}

{ #category : #'accessing - structure variables' }
MTRAlceMetricsExtractor class >> metrics [

	^ metrics ifNil: [ metrics := Dictionary new ]
]

{ #category : #initialization }
MTRAlceMetricsExtractor class >> metricsFor: anAlcixModel [

	^ self metrics
		  at: anAlcixModel
		  ifAbsentPut: [ self new metricsFor: anAlcixModel ]
]

{ #category : #initialization }
MTRAlceMetricsExtractor >> initialize [
	super initialize.
	stack := Stack new
]

{ #category : #visiting }
MTRAlceMetricsExtractor >> measureInvocable: anAlcixFunction [

	self metrics model: anAlcixFunction.
	self metrics name: anAlcixFunction selector.
	self metrics
		register: #Parameters
		value: anAlcixFunction parameters size.
	self metrics
		register: #Variables
		value: anAlcixFunction localVariables size.
	self metrics
		register: #Assingments
		value: anAlcixFunction assignments size.
	self metrics
		register: #IncomingInvocations
		value: anAlcixFunction incomingInvocations size.
	self metrics
		register: #OutgoingInvocations
		value: anAlcixFunction outgoingInvocations size
]

{ #category : #visiting }
MTRAlceMetricsExtractor >> measureSourcedEntity: anAlcixClass [

	self metrics model: anAlcixClass.
	self metrics name: anAlcixClass name.
	self metrics
		register: #ErrorParsing
		value: anAlcixClass astCannotLoad.
	self metrics source: anAlcixClass stringContent.
	self metrics
		register: #LOC
		value: anAlcixClass stringContent lines size.


	self metrics register: #TypedsBy value: anAlcixClass typeds size.
	self metrics register: #Constants value: anAlcixClass constants size.
	self metrics register: #Members value: anAlcixClass members size.

	self visitCollection: anAlcixClass types.
	self visitCollection: anAlcixClass invocables
]

{ #category : #'as yet unclassified' }
MTRAlceMetricsExtractor >> measureWidget: anAlcixReport [

	self metrics model: anAlcixReport.
	self assert: (anAlcixReport superclass isNil or: [ 
			 { '_Form'. '_Report' } includes: anAlcixReport superclass name ]).
	self metrics
		register: #hasModule
		value: anAlcixReport stringContent isEmptyOrNil.
	self measureSourcedEntity: anAlcixReport
]

{ #category : #'accessing - structure variables' }
MTRAlceMetricsExtractor >> metrics [

	^ stack top
]

{ #category : #initialization }
MTRAlceMetricsExtractor >> metricsFor: anAlcixModel [

	anAlcixModel accept: self.
	projectMetrics allSourcedEntities do: [ :e | 
		e model astCannotLoad ifFalse: [ 
			MTRASTAlceMetricsExtractor new loadAstMetrics: e ].
		[  ] ].

	^ projectMetrics
]

{ #category : #'as yet unclassified' }
MTRAlceMetricsExtractor >> metricsNewUserType [

	^ self metrics newEntryForType: #UserType
]

{ #category : #initialization }
MTRAlceMetricsExtractor >> push: aValue during: aBlock [
	stack push: aValue.
	aBlock
		ensure: [ stack pop ]
]

{ #category : #visiting }
MTRAlceMetricsExtractor >> visitAccessModule: anAlcixAccessModule [

	self push: self metrics newAccessModuleMetric during: [ 
		self metrics model: anAlcixAccessModule.
		self visitCollection: anAlcixAccessModule types.
		self visitReferences: anAlcixAccessModule references ]
]

{ #category : #visiting }
MTRAlceMetricsExtractor >> visitAccessProject: anAlcixAccessProject [

	projectMetrics := MTRProjectMetric new.

	self push: projectMetrics during: [ 
		self metrics model: anAlcixAccessProject.
		self visitCollection: anAlcixAccessProject modules ].
	self
		assert: stack isEmpty
		description:
		'The stack is inconsistent. It is suppose to finish with one element'
]

{ #category : #visiting }
MTRAlceMetricsExtractor >> visitAttributeAccessor: anAlcixAttributeAccessor [

	self push: self metrics newPropertyAccessorMetrics during: [ 
		self measureInvocable: anAlcixAttributeAccessor.
		self metrics register: #Type value: anAlcixAttributeAccessor kind ]
]

{ #category : #visiting }
MTRAlceMetricsExtractor >> visitClass: anAlcixClass [

	self
		push: self metrics newClassModuleMetric
		during: [ self measureSourcedEntity: anAlcixClass ]
]

{ #category : #visiting }
MTRAlceMetricsExtractor >> visitCollection: aCollection [

	aCollection do: [ :a | a accept: self ]
]

{ #category : #visiting }
MTRAlceMetricsExtractor >> visitEnum: anAlcixEnum [ 
	self metrics incrementCounterFor: #Enums
]

{ #category : #visiting }
MTRAlceMetricsExtractor >> visitEvent: anAlcixEvent [ 
	self metrics incrementCounterFor: #EventsDefined
]

{ #category : #visiting }
MTRAlceMetricsExtractor >> visitExternalFunction: anAlcixExternalFunction [

	self push: self metrics newFunctionMetrics during: [ 
		self metrics name: anAlcixExternalFunction selector.
		self metrics register: #isExternal value: true.

		self metrics
			register: #Parameters
			value: anAlcixExternalFunction parameters size.

		self metrics
			register: #IncomingInvocations
			value: anAlcixExternalFunction incomingAccesses size ]
]

{ #category : #visiting }
MTRAlceMetricsExtractor >> visitExternalSubProcedure: anAlcixExternalSubProcedure [

	self push: self metrics newSubMetrics during: [ 
		self metrics name: anAlcixExternalSubProcedure selector.
		self metrics register: #isExternal value: true.

		self metrics
			register: #Parameters
			value: anAlcixExternalSubProcedure parameters size.

		self metrics
			register: #IncomingInvocations
			value: anAlcixExternalSubProcedure incomingAccesses size ]
]

{ #category : #visiting }
MTRAlceMetricsExtractor >> visitForm: anAlcixForm [

	self
		push: self metrics newFormMetric
		during: [ self measureWidget: anAlcixForm ]
]

{ #category : #visiting }
MTRAlceMetricsExtractor >> visitFunction: anAlcixFunction [

	self
		push: self metrics newFunctionMetrics
		during: [ self measureInvocable: anAlcixFunction ]
]

{ #category : #visiting }
MTRAlceMetricsExtractor >> visitModel: anAlcixModel [ 
	anAlcixModel project accept: self 
]

{ #category : #visiting }
MTRAlceMetricsExtractor >> visitModule: anAlcixModule [

	self
		push: self metrics newModuleMetric
		during: [ self measureSourcedEntity: anAlcixModule ]
]

{ #category : #visiting }
MTRAlceMetricsExtractor >> visitQuery: anAlcixQuery [

	self push: self metrics newQueryMetric during: [ 
		self metrics model: anAlcixQuery.
		self metrics name: anAlcixQuery name.
		self metrics register: #Members value: anAlcixQuery members size ]
]

{ #category : #visiting }
MTRAlceMetricsExtractor >> visitReferences: aCollection [ 

]

{ #category : #visiting }
MTRAlceMetricsExtractor >> visitReport: anAlcixReport [

	self
		push: self metrics newReportMetric
		during: [ self measureWidget: anAlcixReport ]
]

{ #category : #visiting }
MTRAlceMetricsExtractor >> visitSubProcedure: anAlcixSubProcedure [

	self
		push: self metrics newSubMetrics
		during: [ self measureInvocable: anAlcixSubProcedure ]
]

{ #category : #visiting }
MTRAlceMetricsExtractor >> visitTable: anAlcixTable [

	self push: self metrics newTableMetric during: [ 
		self metrics name: anAlcixTable name.
		self metrics model: anAlcixTable.
		self metrics register: #Members value: anAlcixTable members size ]
]

{ #category : #visiting }
MTRAlceMetricsExtractor >> visitUserType: anAlcixUserType [

	self assert: anAlcixUserType constants isEmpty.
	self assert: anAlcixUserType invocables isEmpty.

	self push: self metricsNewUserType during: [ 
		self metrics name: anAlcixUserType name.
		self metrics model: anAlcixUserType.
		self metrics register: #TypedsBy value: anAlcixUserType typeds size.
		self metrics
			register: #Constants
			value: anAlcixUserType constants size.
		self metrics register: #Members value: anAlcixUserType members size ]
]
