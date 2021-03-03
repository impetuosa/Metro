Class {
	#name : #MTRStructuralMetric,
	#superclass : #MTRMetrics,
	#instVars : [
		'loading'
	],
	#category : #Metro
}

{ #category : #accessing }
MTRStructuralMetric >> classModules [
	^ children at: #ClassModule ifAbsent: [ {} ]
]

{ #category : #consolidation }
MTRStructuralMetric >> classModulesMetrics [
	^ self classModules
		ifNotEmpty: [
			 self classModules anyOne columnsHeaders , String crlf
				, (String crlf join: (self classModules collect: #cvs)) ]
		ifEmpty: [ '' ]
]

{ #category : #'as yet unclassified' }
MTRStructuralMetric >> cleanLoading [
	loading := nil
]

{ #category : #consolidation }
MTRStructuralMetric >> columnsHeaders [
	^ ';' join: (self cvsProperties collect: [ :c | c argumentAt: 1 ])
]

{ #category : #consolidation }
MTRStructuralMetric >> cvs [
	^ ';'
		join:
			(self cvsProperties
				collect: [ :c | (c method valueWithReceiver: self arguments: {}) asString ])
]

{ #category : #consolidation }
MTRStructuralMetric >> cvsProperties [
	^ Pragma
		allNamed: #cvs:at:
		from: self class
		to: Object
		sortedUsing: [ :x :y | (x argumentAt: 2) < (y argumentAt: 2) ]
]

{ #category : #accessing }
MTRStructuralMetric >> demographicMetrics [
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
MTRStructuralMetric >> dropAstMetrics [
	self modules do: #dropAstMetrics.
	self classModules do: #dropAstMetrics.
	self forms do: #dropAstMetrics.
	self reports do: #dropAstMetrics
]

{ #category : #consolidation }
MTRStructuralMetric >> exportMetrics: aDirectory sufix: aSufixName [
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
MTRStructuralMetric >> formMetrics [
	^ self forms
		ifNotEmpty: [
			 self forms anyOne columnsHeaders , String crlf
				, (String crlf join: (self forms collect: #cvs)) ]
		ifEmpty: [ '' ]
]

{ #category : #accessing }
MTRStructuralMetric >> forms [
	^ children at: #Form ifAbsent: [ {}]
]

{ #category : #'as yet unclassified' }
MTRStructuralMetric >> loadAstMetrics [
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
MTRStructuralMetric >> macros [
	^ children at: #Macro ifAbsent: [ {} ]
]

{ #category : #consolidation }
MTRStructuralMetric >> macrosMetrics [
	^ self macros
		ifNotEmpty: [
			 self macros anyOne columnsHeaders, String crlf
				, (String crlf join: (self macros collect: #cvs)) ]
		ifEmpty: [ '' ]
]

{ #category : #accessing }
MTRStructuralMetric >> modules [
	^ children at: #Module ifAbsent: [ {} ]
]

{ #category : #consolidation }
MTRStructuralMetric >> modulesMetrics [
	^ self modules
		ifNotEmpty: [
			 self modules anyOne columnsHeaders , String crlf
				, (String crlf join: (self modules collect: #cvs)) ]
		ifEmpty: [ '' ]
]

{ #category : #initialization }
MTRStructuralMetric >> newClassModuleMetric [
	^ self newEntryForType: #ClassModule
]

{ #category : #initialization }
MTRStructuralMetric >> newControlMetric [
	^ self newEntryForType: #Control
]

{ #category : #initialization }
MTRStructuralMetric >> newFormMetric [
	^ self newEntryForType: #Form
]

{ #category : #initialization }
MTRStructuralMetric >> newMacroMetric [
	^ self newEntryForType: #Macro
]

{ #category : #initialization }
MTRStructuralMetric >> newModuleMetric [
	^ self newEntryForType: #Module
]

{ #category : #initialization }
MTRStructuralMetric >> newQueryMetric [
	^ self newEntryForType: #Query
]

{ #category : #initialization }
MTRStructuralMetric >> newReferenceMetric [
	^ self newEntryForType: #Reference
]

{ #category : #initialization }
MTRStructuralMetric >> newReportMetric [
	^ self newEntryForType: #Report
]

{ #category : #initialization }
MTRStructuralMetric >> newTableMetric [
	^ self newEntryForType: #Table
]

{ #category : #'as yet unclassified' }
MTRStructuralMetric >> parserPerformance [
	| codeBased |
	codeBased := self modules , self classModules , self forms
		, self reports collect: #calculatedSourceMetrics.
	codeBased := codeBased reject: #isNil.
	codeBased ifEmpty: [ ^ -1 ].
	^ 100 - ((100 * (codeBased select: [ :m | m hadErrorOnCalculation ]) size
		/ codeBased size) asFloat)
]

{ #category : #accessing }
MTRStructuralMetric >> printOn: aStream [
	aStream nextPutAll: self demographicMetrics
]

{ #category : #accessing }
MTRStructuralMetric >> queries [
	^ children at: #Query ifAbsent:[{}]
]

{ #category : #consolidation }
MTRStructuralMetric >> queriesMetrics [
	^ self queries
		ifNotEmpty: [
			 self queries anyOne columnsHeaders , String crlf
				, (String crlf join: (self queries collect: #cvs)) ]
		ifEmpty: [ '' ]
]

{ #category : #initialization }
MTRStructuralMetric >> references [
	^ children at: #Reference
]

{ #category : #consolidation }
MTRStructuralMetric >> referencesMetrics [
	^ self references
		ifNotEmpty: [
			 self references anyOne columnsHeaders , String crlf
				, (String crlf join: (self references collect: #cvs)) ]
		ifEmpty: [ '' ]
]

{ #category : #'as yet unclassified' }
MTRStructuralMetric >> reportMetrics [
	^ self reportsMetrics
]

{ #category : #accessing }
MTRStructuralMetric >> reports [
	^ children at: #Report ifAbsent: [ {} ]
]

{ #category : #consolidation }
MTRStructuralMetric >> reportsMetrics [
	^ self reports
		ifNotEmpty: [
			 self reports anyOne columnsHeaders , String crlf
				, (String crlf join: (self reports collect: #cvs)) ]
		ifEmpty: [ '' ]
]

{ #category : #initialization }
MTRStructuralMetric >> solveDependancies [
	self children do: [ :c | c solveDependanciesWith: self ]
]

{ #category : #'as yet unclassified' }
MTRStructuralMetric >> solveDependencyOnTypeAndNewNamed: aString [
	^ (MTRLanguageType for: aString)
		isClassType: true;
		yourself
]

{ #category : #'as yet unclassified' }
MTRStructuralMetric >> solveDependencyOnTypeNamed: aString [
	^ MTRLanguageType for: aString
]

{ #category : #accessing }
MTRStructuralMetric >> sourceRelatedEntities [
	^ self forms , self modules , self classModules , self reports
]

{ #category : #accessing }
MTRStructuralMetric >> tables [
	^ children at: #Table
]

{ #category : #consolidation }
MTRStructuralMetric >> tablesMetrics [
	^ self tables
		ifNotEmpty: [
			 self tables anyOne columnsHeaders , String crlf
				, (String crlf join: (self tables collect: #cvs)) ]
		ifEmpty: [ '' ]
]
