Class {
	#name : #MTRAccessModuleMetric,
	#superclass : #MTRStructuralMetric,
	#category : #'Metro-Model'
}

{ #category : #'as yet unclassified' }
MTRAccessModuleMetric >> allAstSizes [

	^ self forms , self reports , self modules , self classModules 
		  collect: [ :n | n astSize ]
]

{ #category : #accessing }
MTRAccessModuleMetric >> classModules [
	^ children at: #ClassModule ifAbsent: [ {} ]
]

{ #category : #consolidation }
MTRAccessModuleMetric >> classModulesMetrics [

	^ self classModules
		  ifNotEmpty: [ 
			  String crlf join:
				  (self classModules collect: [ :o | self nameCvs , o cvs ]) ]
		  ifEmpty: [ '' ]
]

{ #category : #'as yet unclassified' }
MTRAccessModuleMetric >> classModulesMetricsHeaders [

	^ MTRClassModuleMetric columnsHeaders
]

{ #category : #'as yet unclassified' }
MTRAccessModuleMetric >> consolidatedGrammaticalRatios [

	| incompatible all compatible |
	incompatible := (self forms , self reports , self modules
	                 , self classModules collect: [ :n | 
		                 n grammaticalConsolidatedRatioMetrics ]) sum.
	all := (self forms , self reports , self modules , self classModules 
		        collect: [ :n | n loc ]) sum.
	compatible := all - incompatible.

	^ { 
		  incompatible.
		  compatible }
]

{ #category : #'as yet unclassified' }
MTRAccessModuleMetric >> counters [

	| counters loc |
	counters := Dictionary new.
	counters at: #Forms put: self forms size.
	counters at: #Reports put: self reports size.
	counters at: #Modules put: self modules size.
	counters at: #Classes put: self classModules size.
	counters at: #Tables put: self tables size.
	counters at: #Queries put: self queries size.

	^ counters associations 
]

{ #category : #accessing }
MTRAccessModuleMetric >> demographicMetrics [

	^ String streamContents: [ :str | 
		  str
			  nextPutAll: ('Forms: {1} LOC:{2} ' format: { 
							   self forms size asString.
							   (self forms collect: #loc) sum asString });
			  nextPutAll: OSPlatform current lineEnding;
			  nextPutAll: ('Reports: {1} LOC:{2} ' format: { 
							   self reports size asString.
							   (self reports collect: #loc) sum asString });
			  nextPutAll: OSPlatform current lineEnding;
			  nextPutAll: ('Modules: {1} LOC:{2} ' format: { 
							   self modules size asString.
							   (self modules collect: #LOC) sum asString });
			  nextPutAll: OSPlatform current lineEnding;
			  nextPutAll: ('Classes: {1} LOC:{2} ' format: { 
							   self classModules size asString.
							   (self classModules collect: #LOC) sum asString });
			  nextPutAll: OSPlatform current lineEnding;
			  nextPutAll:
				  ('Macros: {1}  ' format: { self macros size asString }) ]
]

{ #category : #consolidation }
MTRAccessModuleMetric >> formMetrics [

	^ self forms
		  ifNotEmpty: [ 
			  String crlf join:
				  (self forms collect: [ :o | self nameCvs , o cvs ]) ]
		  ifEmpty: [ '' ]
]

{ #category : #consolidation }
MTRAccessModuleMetric >> formMetricsHeaders [
	^ self forms anyOne columnsHeaders.
	
]

{ #category : #accessing }
MTRAccessModuleMetric >> forms [
	^ children at: #Form ifAbsent: [ {}]
]

{ #category : #'as yet unclassified' }
MTRAccessModuleMetric >> grammaticalConsolidatedMetrics [

	^ (self forms , self reports , self modules , self classModules 
		   collect: [ :n | n grammaticalConsolidatedMetrics ]) sum
]

{ #category : #'as yet unclassified' }
MTRAccessModuleMetric >> grammaticalCounts [

	^ ((self children select: [ :c | c isKindOf: MTRSourcedEntity ]) 
		   groupedBy: #class) associations collect: [ :a | 
		  (self classNameWithOutMtr: a key name)
		  ->
		  (self
			   consolidate: a value
			   message: #grammaticalConsolidatedMetrics) ]
]

{ #category : #'as yet unclassified' }
MTRAccessModuleMetric >> grammaticalRatios [

	^ { self consolidatedGrammaticalRatios }
]

{ #category : #accessing }
MTRAccessModuleMetric >> macros [
	^ children at: #Macro ifAbsent: [ {} ]
]

{ #category : #consolidation }
MTRAccessModuleMetric >> macrosMetrics [

	^ self macros
		  ifNotEmpty: [ 
			  String crlf join:
				  (self macros collect: [ :o | self nameCvs , o cvs ]) ]
		  ifEmpty: [ '' ]
]

{ #category : #consolidation }
MTRAccessModuleMetric >> macrosMetricsHeader [

	^ self macros
		  ifEmpty: [ '' ]
		  ifNotEmpty: [ self macros anyOne columnsHeaders ]
]

{ #category : #'as yet unclassified' }
MTRAccessModuleMetric >> moduleGeneralCounters [

	| ast loc |
	^ { 
		  (#ASTSize
		   ->
			   ((children flatCollect: [ :c | c collect: #astSize ]) select: [ 
				    :a | a isNumber ]) sum).
		  (#LOC
		   ->
			   ((children flatCollect: [ :c | c collect: #loc ]) select: [ :a | 
				    a isNumber ]) sum) }
]

{ #category : #accessing }
MTRAccessModuleMetric >> modules [
	^ children at: #Module ifAbsent: [ {} ]
]

{ #category : #consolidation }
MTRAccessModuleMetric >> modulesMetrics [

	^ self modules
		  ifNotEmpty: [ 
			  String crlf join:
				  (self modules collect: [ :o | self nameCvs , o cvs ]) ]
		  ifEmpty: [ '' ]
]

{ #category : #consolidation }
MTRAccessModuleMetric >> modulesMetricsHeader [

	^ self modules anyOne columnsHeaders
]

{ #category : #accessing }
MTRAccessModuleMetric >> name [

	^ model name
]

{ #category : #accessing }
MTRAccessModuleMetric >> nameCvs [

	^ self name , ';'
]

{ #category : #initialization }
MTRAccessModuleMetric >> newClassModuleMetric [
	^ self newEntryForType: #ClassModule
]

{ #category : #initialization }
MTRAccessModuleMetric >> newControlMetric [
	^ self newEntryForType: #Control
]

{ #category : #initialization }
MTRAccessModuleMetric >> newFormMetric [
	^ self newEntryForType: #Form
]

{ #category : #initialization }
MTRAccessModuleMetric >> newMacroMetric [
	^ self newEntryForType: #Macro
]

{ #category : #initialization }
MTRAccessModuleMetric >> newModuleMetric [
	^ self newEntryForType: #Module
]

{ #category : #initialization }
MTRAccessModuleMetric >> newQueryMetric [
	^ self newEntryForType: #Query
]

{ #category : #initialization }
MTRAccessModuleMetric >> newReferenceMetric [
	^ self newEntryForType: #Reference
]

{ #category : #initialization }
MTRAccessModuleMetric >> newReportMetric [
	^ self newEntryForType: #Report
]

{ #category : #initialization }
MTRAccessModuleMetric >> newTableMetric [
	^ self newEntryForType: #Table
]

{ #category : #'instance creation' }
MTRAccessModuleMetric >> paradigmaticCounts [

	
	^ ((self children reject: [ :c | c isKindOf: MTRClassModuleMetric  ]) 
		   groupedBy: #class) associations collect: [ :a | 
		  (self classNameWithOutMtr: a key name)
		  ->  a value size 
		 ]
]

{ #category : #'instance creation' }
MTRAccessModuleMetric >> paradigmaticRatios [

	^ { { 
		  (self forms size + self reports size + self tables size
		   + self queries size + self modules size).

		  self classModules size } }
]

{ #category : #'as yet unclassified' }
MTRAccessModuleMetric >> printOn: aStream [

	^ aStream nextPutAll: self demographicMetrics
]

{ #category : #accessing }
MTRAccessModuleMetric >> queries [
	^ children at: #Query ifAbsent:[{}]
]

{ #category : #consolidation }
MTRAccessModuleMetric >> queriesMetrics [

	^ self queries
		  ifNotEmpty: [ 
			  String crlf join:
				  (self queries collect: [ :o | self nameCvs , o cvs ]) ]
		  ifEmpty: [ '' ]
]

{ #category : #'as yet unclassified' }
MTRAccessModuleMetric >> queriesMetricsHeaders [

	^ MTRQueryMetric columnsHeaders
]

{ #category : #initialization }
MTRAccessModuleMetric >> references [

	^ children at: #Reference ifAbsent: [ self resolveTanglingReferences ]
]

{ #category : #'as yet unclassified' }
MTRAccessModuleMetric >> referencesDetailedTangling [

	^ ((self model mooseModel coloringStrategyFor:
		    AlceHorizontalColorPropagation) colorsFor: model) groupedBy:
		  #lastLink
]

{ #category : #consolidation }
MTRAccessModuleMetric >> referencesMetrics [

	^ self references
		  ifNotEmpty: [ 
			  String crlf join:
				  (self references collect: [ :o | self nameCvs , o cvs ]) ]
		  ifEmpty: [ '' ]
]

{ #category : #consolidation }
MTRAccessModuleMetric >> referencesMetricsHeader [
	^ MTRReferenceMetric columnsHeaders 

	
]

{ #category : #'as yet unclassified' }
MTRAccessModuleMetric >> referencesTangling [

	^ ((self model mooseModel selectedColoringStrategy colorsFor:
		    self model) groupedBy: #tag) associations collect: [ :a | 
		  a key name -> a value size ]
]

{ #category : #consolidation }
MTRAccessModuleMetric >> reportMetrics [

	^ self reports
		  ifNotEmpty: [ 
			  String crlf join:
				  (self reports collect: [ :o | self nameCvs , o cvs ]) ]
		  ifEmpty: [ '' ]
]

{ #category : #'as yet unclassified' }
MTRAccessModuleMetric >> reportMetricsHeaders [

	^ MTRReportMetric columnsHeaders
]

{ #category : #accessing }
MTRAccessModuleMetric >> reports [
	^ children at: #Report ifAbsent: [ {} ]
]

{ #category : #'as yet unclassified' }
MTRAccessModuleMetric >> resolveTanglingReferences [

	| referencesTangleing metric |
	referencesTangleing := self referencesDetailedTangling.

	referencesTangleing keysAndValuesDo: [ :ref :relations | 
		metric := self newReferenceMetric.
		metric model: ref.
		metric amountOfUsages: relations size.
		metric amountOfOutgoingPoints:
			(relations collect: #secondLink) asSet size.
		metric amountOfIncomingPoints:
			(relations collect: #beforeLastLink) asSet size ].
	^ children at: #Reference
]

{ #category : #accessing }
MTRAccessModuleMetric >> sourceRelatedEntities [
	^ self forms , self modules , self classModules , self reports
]

{ #category : #accessing }
MTRAccessModuleMetric >> tables [
	^ children at: #Table
]

{ #category : #consolidation }
MTRAccessModuleMetric >> tablesMetrics [

	^ self tables
		  ifNotEmpty: [ 
			  String crlf join:
				  (self tables collect: [ :o | self nameCvs , o cvs ]) ]
		  ifEmpty: [ '' ]
]

{ #category : #'as yet unclassified' }
MTRAccessModuleMetric >> tablesMetricsHeader [

	^ MTRTableMetric columnsHeaders
]
