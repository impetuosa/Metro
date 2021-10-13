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
			 self classModules anyOne columnsHeaders , String crlf
				, (String crlf join: (self classModules collect: #cvs)) ]
		ifEmpty: [ '' ]
]

{ #category : #'as yet unclassified' }
MTRAccessModuleMetric >> consolidatedGrammaticalRatios [

	| incompatible all compatible |
	incompatible := (self forms , self reports , self modules
	                 , self classModules collect: [ :n | 
		                 n grammaticalConsolidatedRatioMetrics ]) sum.
	all := (self forms , self reports , self modules , self classModules 
		        collect: [ :n | n astSize ]) sum.
	compatible := all - incompatible.

	^ { 
		  incompatible.
		  compatible }
]

{ #category : #accessing }
MTRAccessModuleMetric >> demographicMetrics [
	^ String
		streamContents: [ :str | 
			str
				nextPutAll:
					('Forms: {1} LOC:{2} CustomControls: {3} '
						format:
							{self forms size asString.
							(self forms collect: #loc) sum asString.
							(self forms collect: #amountCustomControls) sum asString});
				nextPutAll: OSPlatform current lineEnding;
				nextPutAll:
					('Reports: {1} LOC:{2} CustomControls: {3} '
						format:
							{self reports size asString.
							(self reports collect: #loc) sum asString.
							(self reports collect: #amountCustomControls) sum asString});
				nextPutAll: OSPlatform current lineEnding;
				nextPutAll:
					('Modules: {1} LOC:{2} '
						format:
							{self modules size asString.
							(self modules collect: #LOC) sum asString});
				nextPutAll: OSPlatform current lineEnding;
				nextPutAll:
					('Classes: {1} LOC:{2} '
						format:
							{self classModules size asString.
							(self classModules collect: #LOC) sum asString});
				nextPutAll: OSPlatform current lineEnding;
				nextPutAll: ('Macros: {1}  ' format: {self macros size asString}) ]
]

{ #category : #'as yet unclassified' }
MTRAccessModuleMetric >> dropAstMetrics [
	self modules do: #dropAstMetrics.
	self classModules do: #dropAstMetrics.
	self forms do: #dropAstMetrics.
	self reports do: #dropAstMetrics
]

{ #category : #consolidation }
MTRAccessModuleMetric >> exportMetrics: aDirectory sufix: aSufixName [
	| stream |
	{#formMetrics . #macrosMetrics . #modulesMetrics . #classModulesMetrics.
	#referencesMetrics . #queriesMetrics . #tablesMetrics . #reportMetrics}
		do: [ :m | 
			stream := (aDirectory / (aSufixName , m , '.csv')) writeStream.
			stream
				nextPutAll: (self perform: m);
				flush;
				close.
			(aDirectory / (aSufixName , m , '.csv')) readStream upToEnd isEmpty
				ifTrue: [ (aDirectory / (aSufixName , m , '.csv')) ensureDelete ] ]
]

{ #category : #consolidation }
MTRAccessModuleMetric >> formMetrics [
	^ self forms
		ifNotEmpty: [
			 self forms anyOne columnsHeaders , String crlf
				, (String crlf join: (self forms collect: #cvs)) ]
		ifEmpty: [ '' ]
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
MTRAccessModuleMetric >> loadAstMetrics [
	loading := (self modules collect: [ :m | [ m sourceMetrics ] future ])
		asOrderedCollection.
	loading
		addAll: (self classModules collect: [ :m | [ m sourceMetrics ] future ]).
	loading
		addAll: (self forms collect: [ :m | [ m sourceMetrics ] future ]).
	loading
		addAll: (self reports collect: [ :m | [ m sourceMetrics ] future ])
]

{ #category : #accessing }
MTRAccessModuleMetric >> macros [
	^ children at: #Macro ifAbsent: [ {} ]
]

{ #category : #consolidation }
MTRAccessModuleMetric >> macrosMetrics [
	^ self macros
		ifNotEmpty: [
			 self macros anyOne columnsHeaders, String crlf
				, (String crlf join: (self macros collect: #cvs)) ]
		ifEmpty: [ '' ]
]

{ #category : #accessing }
MTRAccessModuleMetric >> modules [
	^ children at: #Module ifAbsent: [ {} ]
]

{ #category : #consolidation }
MTRAccessModuleMetric >> modulesMetrics [
	^ self modules
		ifNotEmpty: [
			 self modules anyOne columnsHeaders , String crlf
				, (String crlf join: (self modules collect: #cvs)) ]
		ifEmpty: [ '' ]
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

{ #category : #'as yet unclassified' }
MTRAccessModuleMetric >> parserPerformance [
	| codeBased |
	codeBased := self modules , self classModules , self forms
		, self reports collect: #calculatedSourceMetrics.
	codeBased := codeBased reject: #isNil.
	codeBased ifEmpty: [ ^ -1 ].
	^ 100 - ((100 * (codeBased select: [ :m | m hadErrorOnCalculation ]) size
		/ codeBased size) asFloat)
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
			 self queries anyOne columnsHeaders , String crlf
				, (String crlf join: (self queries collect: #cvs)) ]
		ifEmpty: [ '' ]
]

{ #category : #initialization }
MTRAccessModuleMetric >> references [
	^ children at: #Reference
]

{ #category : #consolidation }
MTRAccessModuleMetric >> referencesMetrics [
	^ self references
		ifNotEmpty: [
			 self references anyOne columnsHeaders , String crlf
				, (String crlf join: (self references collect: #cvs)) ]
		ifEmpty: [ '' ]
]

{ #category : #'as yet unclassified' }
MTRAccessModuleMetric >> reportMetrics [
	^ self reportsMetrics
]

{ #category : #accessing }
MTRAccessModuleMetric >> reports [
	^ children at: #Report ifAbsent: [ {} ]
]

{ #category : #consolidation }
MTRAccessModuleMetric >> reportsMetrics [
	^ self reports
		ifNotEmpty: [
			 self reports anyOne columnsHeaders , String crlf
				, (String crlf join: (self reports collect: #cvs)) ]
		ifEmpty: [ '' ]
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
			 self tables anyOne columnsHeaders , String crlf
				, (String crlf join: (self tables collect: #cvs)) ]
		ifEmpty: [ '' ]
]
