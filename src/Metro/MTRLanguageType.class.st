Class {
	#name : #MTRLanguageType,
	#superclass : #Object,
	#instVars : [
		'name',
		'isClassType'
	],
	#classInstVars : [
		'pool'
	],
	#category : #Metro
}

{ #category : #'instance creation' }
MTRLanguageType class >> for: aName [
	^ self pool
		at: aName
		ifAbsentPut: [ self new
				name: aName;
				yourself ]
]

{ #category : #'instance creation' }
MTRLanguageType class >> pool [
	^ pool ifNil: [ pool := Dictionary new ]
]

{ #category : #'as yet unclassified' }
MTRLanguageType >> allDependencies [
	^ {}
]

{ #category : #'as yet unclassified' }
MTRLanguageType >> isClassType: aTrue [ 
	isClassType := aTrue.
]

{ #category : #accessing }
MTRLanguageType >> name: aName [
	name := aName
]

{ #category : #accessing }
MTRLanguageType >> printOn: aStream [
	aStream
		nextPutAll: 'LanguageType ';
		nextPutAll: name
]
