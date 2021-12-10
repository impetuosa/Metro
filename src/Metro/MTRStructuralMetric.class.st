Class {
	#name : #MTRStructuralMetric,
	#superclass : #MTRMetrics,
	#instVars : [
		'loading'
	],
	#category : #'Metro-Model'
}

{ #category : #consolidation }
MTRStructuralMetric class >> columnsHeaders [

	^ #'Project;'
	  ,
	  (';' join: (self cvsProperties collect: [ :c | c argumentAt: 1 ]))
]

{ #category : #consolidation }
MTRStructuralMetric class >> cvsProperties [
	^ Pragma
		allNamed: #cvs:at:
		from: self 
		to: Object
		sortedUsing: [ :x :y | (x argumentAt: 2) < (y argumentAt: 2) ]
]

{ #category : #'as yet unclassified' }
MTRStructuralMetric >> cleanLoading [
	loading := nil
]

{ #category : #consolidation }
MTRStructuralMetric >> columnsHeaders [

	^ #'Project;'
	  ,
	  (';' join: (self cvsProperties collect: [ :c | c argumentAt: 1 ]))
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

{ #category : #consolidation }
MTRStructuralMetric >> cvsProps [

	^ self cvsProperties collect: [ :c | 
		  c method valueWithReceiver: self arguments: {  } ]
]

{ #category : #'instance creation' }
MTRStructuralMetric >> paradigmaticCounts [

	^ ({ 
		   MTRModuleMetric.
		   MTRTableMetric.
		   MTRQueryMetric.
		   MTRFormMetric.
		   MTRReportMetric } anySatisfy: [ :a | self isKindOf: a ])
		  ifTrue: [ { ((self classNameWithOutMtr: self className) -> 1) } ]
		  ifFalse: [ { ((self classNameWithOutMtr: self className) -> 0) } ]
]

{ #category : #accessing }
MTRStructuralMetric >> printOn: aStream [

	aStream
		nextPutAll: 'Chidlren#';
		nextPutAll: self children size asString
]

{ #category : #consolidation }
MTRStructuralMetric >> referencesTangling [

	^ (((self model mooseModel selectedColoringStrategy colorsFor:
		     self model) collect: #dueToChainOnlyFst) groupedBy: [ :a | 
		   a at: a size - 1 ]) associations collect: [ :a | 
		  a key name -> a value size ]
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
