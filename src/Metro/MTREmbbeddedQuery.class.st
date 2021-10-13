Class {
	#name : #MTREmbbeddedQuery,
	#superclass : #Object,
	#instVars : [
		'sql'
	],
	#category : #'Metro-Model'
}

{ #category : #'as yet unclassified' }
MTREmbbeddedQuery >> allDependencies [
	^ {}
]

{ #category : #'as yet unclassified' }
MTREmbbeddedQuery >> sql: aString [ 
	sql := aString
]
