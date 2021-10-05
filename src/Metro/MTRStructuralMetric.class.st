Class {
	#name : #MTRStructuralMetric,
	#superclass : #MTRMetrics,
	#instVars : [
		'loading'
	],
	#category : #'Metro-Model'
}

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
MTRStructuralMetric >> printOn: aStream [

	aStream
		nextPutAll: 'Chidlren#';
		nextPutAll: self children size asString
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
