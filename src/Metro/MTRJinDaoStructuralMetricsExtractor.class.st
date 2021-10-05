Class {
	#name : #MTRJinDaoStructuralMetricsExtractor,
	#superclass : #JinStackVisitor,
	#classInstVars : [
		'generalMetrics',
		'extractor',
		'proj',
		'metrics'
	],
	#category : #'Metro-Extractor-JinDao'
}

{ #category : #'as yet unclassified' }
MTRJinDaoStructuralMetricsExtractor class >> egrcMetrics [
	| projects |
	projects := 'C:\WMagnus' asFileReference allEntries
		select: [ :s | 
			s extension = 'accdb'
				and: [ ({'AttacheAuto.accdb' . 'SupprimerActe.accdb' . 'accueil.accdb'.
					'magact_Backup_Backup.accdb' . 'magact_Backup.accdb'}
						includes: s basename) not ] ].
	generalMetrics
		ifNotNil: [ self
				halt:
					'There are calulated metrics. to calculate again will destroy the older metrics ' ].
	generalMetrics := Dictionary new.
	projects
		do: [ :p | 
			generalMetrics
				at: p asFileReference fullName
				ifAbsent: [ extractor := MTRJinDaoStructuralMetricsExtractor new.
					proj := JinAccessApplication default open: p asFileReference.
					metrics := extractor metricsFor: proj.
					generalMetrics
						at: proj projectPath asFileReference fullName
						put: metrics.
					proj closeAndQuit ] ]
]

{ #category : #'as yet unclassified' }
MTRJinDaoStructuralMetricsExtractor class >> exportCVS [
	generalMetrics
		keysAndValuesDo: [ :k :v | 
			| base |
			base := (k copyReplaceAll: '.accdb' with: '') asFileReference
				basename.
			v
				exportMetrics:
					(base asFileReference
						ensureCreateDirectory;
						yourself)
				sufix: '' ]
]

{ #category : #'as yet unclassified' }
MTRJinDaoStructuralMetricsExtractor class >> generalMetrics [
	^ generalMetrics
]

{ #category : #'as yet unclassified' }
MTRJinDaoStructuralMetricsExtractor class >> load: aFileRef [
	generalMetrics := STON fromStream: aFileRef readStream
]

{ #category : #'visit-first-objects' }
MTRJinDaoStructuralMetricsExtractor >> initialize [ 
	super initialize. 
	stack push: MTRStructuralMetric new.
]

{ #category : #'visit-first-objects' }
MTRJinDaoStructuralMetricsExtractor >> loadMetricsFromFormOrReport: aForm [
	| dataSource |
	self metrics register: #name value: aForm name.
	self metrics register: #type value: aForm formType.
	self metrics register: #properties value: aForm properties size.
	self metrics register: #hasModule value: aForm hasModule.
	dataSource := aForm recordSourceFull.
	dataSource isString
		ifTrue: [ self metrics registerDependancy: dataSource kind: #EmbddedQuery ]
		ifFalse: [ dataSource
				ifNotNil: [ self metrics
						registerDependancy: dataSource name
						kind: (dataSource class name copyReplaceAll: 'Jin' with: '') ] ]
]

{ #category : #'visit-first-objects' }
MTRJinDaoStructuralMetricsExtractor >> metrics [
	^ stack top
]

{ #category : #'visit-first-objects' }
MTRJinDaoStructuralMetricsExtractor >> metricsFor: aProject [
	aProject acceptVisitor: self.
	self
		assert: stack size = 1
		description: 'The stack is inconsistent. It is suppose to finish with one element'.
	^ self metrics
]

{ #category : #'visit-first-objects' }
MTRJinDaoStructuralMetricsExtractor >> sourceCodeMetrixExtractor [
	^ MTRASTJinDaoMetricsExtractor new
]

{ #category : #'visit-first-objects' }
MTRJinDaoStructuralMetricsExtractor >> visitAccessProperty: aProperty [
	self metrics incrementCounterFor: #Properties
]

{ #category : #'as yet unclassified' }
MTRJinDaoStructuralMetricsExtractor >> visitCustomControl: aControl [
	" 
	Some controls arrive here by accident...
	JinControl delegate bydefault to visitCustomControl:. Probably is a bad decision . Should change it 
	"
	 "Can we get the class of this custom control? "

	aControl isCustomControl
		ifTrue: [ [ self metrics
				registerDependancy: aControl name
				kind: 'CustomControl' ]
				on: Error
				do: [ self metrics
						registerDependancy: 'ErrorGettingName'
						kind: 'CustomControl' ] ]
]

{ #category : #'visit-first-objects' }
MTRJinDaoStructuralMetricsExtractor >> visitForm: aForm [
	self
		push: self metrics newFormMetric
		during: [ 
			self loadMetricsFromFormOrReport: aForm.
			super visitForm: aForm 
		].
	aForm ensureUnload
]

{ #category : #'visit-first-objects' }
MTRJinDaoStructuralMetricsExtractor >> visitFormControl: aControl [
	self metrics incrementCounterFor: #Controls
]

{ #category : #'visit-first-objects' }
MTRJinDaoStructuralMetricsExtractor >> visitIndex: aJinIndex [
	"Should we include this?"
]

{ #category : #'visit-first-objects' }
MTRJinDaoStructuralMetricsExtractor >> visitMacro: anObject [

	self metrics newMacroMetric register:#name value: anObject name 
]

{ #category : #'visit-first-objects' }
MTRJinDaoStructuralMetricsExtractor >> visitModule: anObject [
	| mtrx |
	mtrx := anObject isClassModule
		ifTrue: [ self metrics newClassModuleMetric ]
		ifFalse: [ self metrics newModuleMetric ].
	mtrx register: #name value: anObject name.
	self push: mtrx during: [ super visitModule: anObject ].
	anObject ensureUnload
]

{ #category : #'visit-first-objects' }
MTRJinDaoStructuralMetricsExtractor >> visitProject: aJinAccessProject [
	self visitCollection: aJinAccessProject references.
	self visitCollection: aJinAccessProject tables.
	self visitCollection: aJinAccessProject queries.
	self visitCollection: aJinAccessProject modules.
	self visitCollection: aJinAccessProject macros
]

{ #category : #'visit-first-objects' }
MTRJinDaoStructuralMetricsExtractor >> visitQuery: anObject [
	self
		push: self metrics newQueryMetric
		during: [ 
			self metrics register: #name value: anObject name.
			self metrics register: #Fields value: anObject fields size.
			(anObject fields collect: [ :f | f sourceTableName ]) asSet
				do: [ :n | self metrics registerDependancy: n kind: #Table].
			(anObject fields collect: [ :f | f typeName ]) asSet
				do: [ :n | self metrics registerDependancy: n kind: #DBType].
			super visitQuery: anObject ].
	anObject ensureUnload
]

{ #category : #'visit-first-objects' }
MTRJinDaoStructuralMetricsExtractor >> visitReference: aRef [
	| metric |
	metric := self metrics newReferenceMetric.
	metric register: #BuiltIn value: aRef isBuiltIn.
	metric register: #Path value: aRef path.
	metric register: #Major value: aRef major.
	metric register: #Minor value: aRef minor.
]

{ #category : #'visit-first-objects' }
MTRJinDaoStructuralMetricsExtractor >> visitReport: aReport [
	self
		push: self metrics newReportMetric
		during: [ 
			self loadMetricsFromFormOrReport: aReport.
			super visitReport: aReport. ].
	aReport ensureUnload
]

{ #category : #'visit-first-objects' }
MTRJinDaoStructuralMetricsExtractor >> visitSourceCode: aSourceCode [
	self metrics register: #LOC value: aSourceCode amountOfLines.
	self metrics source: aSourceCode contents
]

{ #category : #'visit-first-objects' }
MTRJinDaoStructuralMetricsExtractor >> visitSubForm: aSubform [
	self metrics registerDependancy: aSubform name kind: #Form.
	super visitSubForm: aSubform
]

{ #category : #'visit-first-objects' }
MTRJinDaoStructuralMetricsExtractor >> visitTable: anObject [
	self
		push: self metrics newTableMetric
		during: [ 
			self metrics register: #name value: anObject name.
			self metrics register: #Fields value: anObject fields size.
			(anObject fields collect: [ :f | f typeName ]) asSet
				do: [ :n | self metrics registerDependancy: n kind: #DBType ].
].
	anObject ensureUnload
]

{ #category : #'visit-first-objects' }
MTRJinDaoStructuralMetricsExtractor >> visitTableRelation: aJinTableRelation [
	"Should we include this?"
]
