Class {
	#name : #BaselineOfMetro,
	#superclass : #BaselineOf,
	#category : #BaselineOfMetro
}

{ #category : #baselines }
BaselineOfMetro >> baseline: spec [
	<baseline>
	spec
		baseline: 'Jindao'
		with: [ spec repository: 'github://impetuosa/jindao' ].
	spec
		baseline: 'VBParser'
		with: [ spec repository: 'github://impetuosa/VBParser' ].
	spec package: 'Metro' with: [ spec requires: #(Jindao VBParser) ]
]
