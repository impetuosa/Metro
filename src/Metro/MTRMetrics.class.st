Class {
	#name : #MTRMetrics,
	#superclass : #Object,
	#instVars : [
		'model',
		'children',
		'properties',
		'dependancies'
	],
	#category : #'Metro-Model'
}

{ #category : #consolidation }
MTRMetrics >> allDependencies [
	^ self dependencies
		,
			((self dependencies reject: #isArray)
				flatCollect: [ :d | d allDependencies ])
		, (self children flatCollect: #allDependencies)
]

{ #category : #'as yet unclassified' }
MTRMetrics >> allSourcedEntities [

	^ (self children select: [ :a | a isKindOf: MTRSourcedEntity ])
	  , (self children flatCollect: [ :a | a allSourcedEntities ])
]

{ #category : #'as yet unclassified' }
MTRMetrics >> child: aString [
	^ children at: aString
]

{ #category : #'as yet unclassified' }
MTRMetrics >> child: aString put: aChild [
	^ children at: aString put: aChild
]

{ #category : #initialization }
MTRMetrics >> children [
	^ children values flatCollect: #yourself
]

{ #category : #'as yet unclassified' }
MTRMetrics >> dependencies [
	^ dependancies 
]

{ #category : #'as yet unclassified' }
MTRMetrics >> incrementCounterFor: aString [
	| val |
	val := properties at: aString ifAbsentPut: [ 0 ].
	properties at: aString put: val + 1
]

{ #category : #initialization }
MTRMetrics >> initialize [
	super initialize.
	children := Dictionary new.
	properties := Dictionary new.
	dependancies := Set new
]

{ #category : #accessing }
MTRMetrics >> model [
	^ model
]

{ #category : #accessing }
MTRMetrics >> model: anAlcixClass [ 
	model := anAlcixClass
]

{ #category : #accessing }
MTRMetrics >> name [
	<cvs: #name at: 1>
	^ properties at: #Name ifAbsent: nil
]

{ #category : #accessing }
MTRMetrics >> name: aString [

	self register: #Name value: aString
]

{ #category : #initialization }
MTRMetrics >> newEntryForType: anObjectType [
	| metric type |
	type := self class environment
		at: ('MTR{1}Metric' format: {anObjectType}) asSymbol.
	metric := type new.
	metric register: #AccesType value: anObjectType.
	(children at: anObjectType ifAbsentPut: [ OrderedCollection new ])
		add: metric.
	^ metric
]

{ #category : #'as yet unclassified' }
MTRMetrics >> properties [
	^ properties
]

{ #category : #initialization }
MTRMetrics >> register: aName value: aValue [

	properties at: aName put: aValue
]

{ #category : #initialization }
MTRMetrics >> registerDependancy: aDependancy kind: aKindOfDependancy [
	dependancies
		add:
			{aKindOfDependancy.
			aDependancy}
]

{ #category : #'as yet unclassified' }
MTRMetrics >> registeredDependencies [
	^ dependancies
]

{ #category : #'as yet unclassified' }
MTRMetrics >> solveDependanciesWith: aRoot [
	| newDeps |
	dependancies := dependancies reject: #isNil.
	newDeps := (dependancies
		select: #isArray
		thenCollect: [ :d | 
			d
				->
					(aRoot
						perform: ('solveDependencyOn{1}Named:' format: {d first}) asSymbol
						withArguments: {d second}) ]) asDictionary.
	dependancies removeAll: newDeps keys.
	dependancies addAll: newDeps values.
	dependancies := dependancies reject: #isNil.
	self children do: [ :c | c solveDependanciesWith: aRoot ]
]

{ #category : #'as yet unclassified' }
MTRMetrics >> solveDependencyOnCustomControlNamed: aString [
	^ MTRCustomControlType new
		name: aString;
		yourself
]

{ #category : #'as yet unclassified' }
MTRMetrics >> solveDependencyOnDBTypeNamed: aDBTypeName [
	^ MTRDBType for: aDBTypeName
]

{ #category : #'as yet unclassified' }
MTRMetrics >> solveDependencyOnEmbddedQueryNamed: aString [
	^ MTREmbbeddedQuery new
		sql: aString;
		yourself
]

{ #category : #'as yet unclassified' }
MTRMetrics >> solveDependencyOnFormNamed: aString [
	^ self forms
		detect: [ :f | f name asLowercase asSymbol = aString asSymbol ]
		ifNone: [ MTRCrossProjectDependancy new
				type: #Form;
				name: aString;
				yourself ]
]

{ #category : #'as yet unclassified' }
MTRMetrics >> solveDependencyOnQueryNamed: aName [
	aName isEmpty
		ifTrue: [ ^ nil ].
	^ self queries
		detect: [ :t | t name asLowercase asSymbol = aName asLowercase asSymbol ]
]

{ #category : #'as yet unclassified' }
MTRMetrics >> solveDependencyOnTableNamed: aName [
	aName isEmpty
		ifTrue: [ ^ nil ].
	^ self tables
		detect: [ :t | t name asLowercase asSymbol = aName asLowercase asSymbol ]
]

{ #category : #'as yet unclassified' }
MTRMetrics >> value: aString [
	^ properties at: aString
]

{ #category : #'as yet unclassified' }
MTRMetrics >> valueOrEmpty: aString [
	^ properties at: aString ifAbsent: [ '' ]
]

{ #category : #'as yet unclassified' }
MTRMetrics >> valueOrZero: aString [
	^ properties at: aString ifAbsent: [ 0 ]
]
