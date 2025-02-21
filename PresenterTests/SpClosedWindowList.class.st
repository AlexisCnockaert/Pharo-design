Class {
	#name : 'SpClosedWindowList',
	#superclass : 'SpPresenter',
	#instVars : [
		'title',
		'list',
		'unhideButton',
		'removeButton',
		'unhideItemBlock',
		'okBlock',
		'label',
		'removeItemBlock'
	],
	#category : 'PresenterTests',
	#package : 'PresenterTests'
}

{ #category : 'layout' }
SpClosedWindowList class >> defaultLayout [
	^ self layoutWithOrdering
]

{ #category : 'as yet unclassified' }
SpClosedWindowList class >> exampleClosedWindowsList [

	<sampleInstance>
	| presenter |
	presenter := self new
		             items: self selectors asOrderedCollection;
		             unhideItemBlock: [ 1 ];
		             openWithLayout: self layoutWithOrdering;
		             yourself.

	presenter withWindowDo: [ :w | w title: 'Last Closed Windows' ].

	^ presenter
]

{ #category : 'layout' }
SpClosedWindowList class >> layoutWithOrdering [

	| listLayout |
	listLayout := SpBoxLayout newLeftToRight
		              add: #list;
		              yourself.

	^ SpBoxLayout newTopToBottom
		  add: listLayout;
		  add: (SpBoxLayout newLeftToRight
				   addLast: #unhideButton expand: false;
				   addLast: #removeButton expand: false;
				   yourself)
		  expand: false;
		  yourself
]

{ #category : 'initialization' }
SpClosedWindowList >> connectPresenters [
	super connectPresenters.
	unhideButton action: [ 
		| newItem |
		newItem := unhideItemBlock cull: self selectedItem ].
	removeButton 
		action: [ removeItemBlock cull: self selectedItem ].
]

{ #category : 'api' }
SpClosedWindowList >> display: aBlock [

	list display: aBlock
]

{ #category : 'initialization' }
SpClosedWindowList >> initialize [

	super initialize.
	title := 'Title'.
	okBlock := [  ].
	removeItemBlock := [ :item |
	                   item ifNotNil: [
		                   self items remove: item.
		                   item closeBoxHit.
		                   self refresh ] ].
	unhideItemBlock := [ :item |
	                   item ifNotNil: [ item visible: true ].
	                   self items remove: item.
	                   self refresh ]
]

{ #category : 'initialization' }
SpClosedWindowList >> initializeDialogWindow: aWindow [

	aWindow addDefaultButton: 'Ok' do: [ :presenter | 
		self performOkAction. 
		presenter close ].

	
]

{ #category : 'initialization' }
SpClosedWindowList >> initializePresenters [

	label := self newLabel.
	list := self newList.
	unhideButton := self newButton.
	removeButton := self newButton.
	unhideButton
		addStyle: 'small';
		addStyle: 'flat';
		icon: (self iconNamed: #undo);
		help: 'Unhide an item from the list'.
	removeButton
		addStyle: 'small';
		addStyle: 'flat';
		icon: (self iconNamed: #remove);
		help: 'Remove a item from the list'.
]

{ #category : 'initialization' }
SpClosedWindowList >> initializeWindow: aWindowPresenter [
	aWindowPresenter title: self title;
	initialExtent: 310@185.
]

{ #category : 'accessing' }
SpClosedWindowList >> items [
	^ list model items
]

{ #category : 'private' }
SpClosedWindowList >> items: anItemList [
	list items: anItemList.
]

{ #category : 'accessing' }
SpClosedWindowList >> label: aString [
	label label: aString 
]

{ #category : 'accessing' }
SpClosedWindowList >> list [
	^ list
]

{ #category : 'private' }
SpClosedWindowList >> moveElementAt: index to: newIndex [
	"WARNING: this method can only be used if the model is an OrderedCollection"
	| elementToMove |
	
	(newIndex between: 1 and: self items size) 
		ifFalse: [ ^ self ].
		
	elementToMove := list itemAt: index.
	self items 
		remove: elementToMove;
		add: elementToMove beforeIndex: newIndex.
	
	self refresh.
	self list selectIndex: newIndex
]

{ #category : 'initialization' }
SpClosedWindowList >> newList [
	"Default list collection is an Array.
	As this presenter aims to add / remove items from the list, we need a growable collection"
	^ super newList
		items: OrderedCollection new;
		yourself
]

{ #category : 'api' }
SpClosedWindowList >> okAction: aBlock [

	okBlock := aBlock
]

{ #category : 'private' }
SpClosedWindowList >> performOkAction [

	okBlock value
]

{ #category : 'api' }
SpClosedWindowList >> refresh [
	self resetSelection.
	self items: self items.
	list selectIndex: 0
]

{ #category : 'accessing' }
SpClosedWindowList >> removeButton [
	^ removeButton
]

{ #category : 'api' }
SpClosedWindowList >> removeItem: anObject [

	self items remove: anObject.
	"self resetSelection "
]

{ #category : 'api' }
SpClosedWindowList >> removeItemBlock: aBlock [
	removeItemBlock := aBlock.
]

{ #category : 'api' }
SpClosedWindowList >> resetSelection [
	list selectIndex: 0
]

{ #category : 'api' }
SpClosedWindowList >> selectIndex: anIndex [
	list selectIndex: anIndex
]

{ #category : 'api' }
SpClosedWindowList >> selectItem: anObject [
	list selectItem: anObject
]

{ #category : 'api' }
SpClosedWindowList >> selectedIndex [
	^ list selection selectedIndex
]

{ #category : 'api' }
SpClosedWindowList >> selectedItem [
	^ list selection selectedItem
]

{ #category : 'accessing' }
SpClosedWindowList >> title [
	^ title
]

{ #category : 'accessing' }
SpClosedWindowList >> title: aTitle [
	title := aTitle 
]

{ #category : 'accessing' }
SpClosedWindowList >> unhideButton [
	^ unhideButton 
]

{ #category : 'api' }
SpClosedWindowList >> unhideItemBlock: aBlock [
	unhideItemBlock := aBlock.
]

{ #category : 'api' }
SpClosedWindowList >> whenSelectionChangedDo: aBlock [
	list whenSelectionChangedDo: aBlock
]
