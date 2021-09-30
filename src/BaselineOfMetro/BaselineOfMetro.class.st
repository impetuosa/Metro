Class {
	#name : #BaselineOfMetro,
	#superclass : #BaselineOf,
	#category : #BaselineOfMetro
}

{ #category : #baselines }
BaselineOfMetro >> baseline: spec [

	<baseline>
	spec
		baseline: 'Alce'
		with: [ spec repository: 'github://impetuosa/Alce' ].
	spec package: 'Metro' with: [ spec requires: #( Alce ) ]
]
