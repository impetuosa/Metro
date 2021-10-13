Class {
	#name : #MTRDBType,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#classInstVars : [
		'pool'
	],
	#category : #'Metro-Model'
}

{ #category : #'instance creation' }
MTRDBType class >> for: aName [
	^ self pool
		at: aName
		ifAbsentPut: [ self new
				name: aName;
				yourself ]
]

{ #category : #'instance creation' }
MTRDBType class >> pool [
	^ pool ifNil: [ pool := Dictionary new ]
]

{ #category : #'as yet unclassified' }
MTRDBType >> allDependencies [
	^ {}
]

{ #category : #accessing }
MTRDBType >> name: aName [
	name := aName
]

{ #category : #accessing }
MTRDBType >> printOn: aStream [
	aStream
		nextPutAll: 'DBType ';
		nextPutAll: name
]
