Class {
	#name : #MTRCrossProjectDependancy,
	#superclass : #Object,
	#instVars : [
		'type',
		'name'
	],
	#category : #'Metro-Model'
}

{ #category : #'as yet unclassified' }
MTRCrossProjectDependancy >> allDependencies [
	^ {}
]

{ #category : #'as yet unclassified' }
MTRCrossProjectDependancy >> name: aString [ 
	name := aString
]

{ #category : #'as yet unclassified' }
MTRCrossProjectDependancy >> type: aString [ 
	type := aString
]
