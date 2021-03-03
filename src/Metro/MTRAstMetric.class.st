Class {
	#name : #MTRAstMetric,
	#superclass : #MTRMetrics,
	#category : #Metro
}

{ #category : #'instance creation' }
MTRAstMetric >> branchings [
	<cvs: #Branchings at: 15>
	^ (self children collect: [ :c | c valueOrZero: #Branching ]) sum
]

{ #category : #'instance creation' }
MTRAstMetric >> functions [
	^ children at: #Function ifAbsent: [ {} ]
]

{ #category : #'instance creation' }
MTRAstMetric >> goSubs [
	<cvs: #GoSub at: 12>
	^ (self children collect: [ :c | c valueOrZero: #GoSub ]) sum
]

{ #category : #'instance creation' }
MTRAstMetric >> hadErrorOnCalculation [
	^ properties at: #ERROR ifPresent: [ true ] ifAbsent: [ false ]
]

{ #category : #'instance creation' }
MTRAstMetric >> loops [
	<cvs: #Loops at: 15>
	^ (self children collect: [ :c | c valueOrZero: #Loop ]) sum
]

{ #category : #'instance creation' }
MTRAstMetric >> newFunctionMetrics [
	^ self newEntryForType: #Function
]

{ #category : #'instance creation' }
MTRAstMetric >> newPropertyAccessorMetrics [
	^ self newEntryForType: #PropertyAccessor
]

{ #category : #'instance creation' }
MTRAstMetric >> newPropertyMetrics [
	^ self newEntryForType: #Property
]

{ #category : #'instance creation' }
MTRAstMetric >> newSubMetrics [
	^ self newEntryForType: #SubProcedure
]

{ #category : #'instance creation' }
MTRAstMetric >> onErrorGoTos [
	<cvs: #ErrorGoTo at: 13>
	^ (self children collect: [ :c | c valueOrZero: #OnErrorGoTo ]) sum
]

{ #category : #'instance creation' }
MTRAstMetric >> onErrorResumeNext [
	<cvs: #ErrorResumeNext at: 14>
	^ (self children collect: [ :c | c valueOrZero: #OnErrorResumeNext ]) sum
]

{ #category : #'instance creation' }
MTRAstMetric >> printOn: aStream [
	self class = MTRAstMetric
		ifTrue: [ aStream nextPutAll: 'SC Metric'.
			properties
				at: #ERROR
				ifPresent: [ :errorText | 
					aStream nextPutAll: 'Error parsing: ' , errorText.
					^ self ].
			children
				keysAndValuesDo: [ :k :v | 
					aStream
						nextPutAll: k;
						nextPutAll: ':';
						nextPutAll: v size asString;
						nextPutAll: String tab ] ]
		ifFalse: [ aStream
				nextPutAll: (properties at: #AccesType);
				nextPutAll: 'Metric '.
			properties
				keysAndValuesDo: [ :k :v | 
					k = #AccesType
						ifFalse: [ aStream
								nextPutAll: k;
								nextPutAll: ':';
								nextPutAll: v asString;
								nextPutAll: String tab ] ] ]
]

{ #category : #'instance creation' }
MTRAstMetric >> property [
	^ children at: #Property ifAbsent: [ {} ]
]

{ #category : #'instance creation' }
MTRAstMetric >> propertyAccessors [
	^ children at: #PropertyAccessor ifAbsent: [ {} ]
]

{ #category : #'instance creation' }
MTRAstMetric >> resumeLabels [
	<cvs: #ResumeLabel at: 16>
	^ (self children collect: [ :c | c valueOrZero: #ResumeLabel ]) sum
]

{ #category : #'instance creation' }
MTRAstMetric >> resumeNext [
	<cvs: #ResumeNext at: 17>
	^ (self children collect: [ :c | c valueOrZero: #ResumeNext ]) sum
]

{ #category : #'instance creation' }
MTRAstMetric >> resumes [
	<cvs: #ResumeEmpty at: 15>
	^ (self children collect: [ :c | c valueOrZero: #ResumeEmpty ]) sum
]

{ #category : #'instance creation' }
MTRAstMetric >> subs [
	^ children at: #SubProcedure ifAbsent: [ {} ]
]
