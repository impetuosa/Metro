Class {
	#name : #MTREmbbeddedQuery,
	#superclass : #Object,
	#instVars : [
		'sql'
	],
	#category : #Metro
}

{ #category : #'as yet unclassified' }
MTREmbbeddedQuery >> allDependencies [
	^ {}
]

{ #category : #'as yet unclassified' }
MTREmbbeddedQuery >> sql: aString [ 
	sql := aString
]
