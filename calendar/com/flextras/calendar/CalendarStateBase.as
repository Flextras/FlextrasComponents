/*
Copyright 2012 DotComIt, LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Additional Documentation, Samples, and Support may be available at http://www.flextras.com 

*/
package com.flextras.calendar
{
	import com.flextras.calendar.defaultRenderers.DayRenderer;
	import com.flextras.utils.DateUtilsExtension;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.Container;
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	import mx.core.UIComponent;
	import mx.states.Transition;
	import mx.utils.ObjectUtil;

	// day event metadata for switching state events
	include "inc/ExpandEventMetaData.as";

	// event metadata for Drag events 
	include "inc/DragEventMetaData.as";	

	// event metadata from the CalendarEvent and CalendarMoustEvent classes
	include "inc/GenericEventMetaData.as";	

	// month header event metadata 
	include "inc/MonthHeaderEventMetaData.as";
	
	// day header event metadata 
	include "inc/DayHeaderEventMetaData.as";
	
	// week header event metadata 
	include "inc/WeekHeaderEventMetaData.as";	
	
	/**
	 * This is a base class for the state classes that make up the Flextras Calendar component's week, day, and month views.  This is primarily used for sharing items, such as event listeners, between the three options.
	 * 
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.DayDisplay
	 * @see com.flextras.calendar.MonthDisplay
	 * @see com.flextras.calendar.WeekDisplay
	 * 
	 */
	public class CalendarStateBase extends Container implements ICalendarDayStateOverrides, ICalendarWeekStateOverrides
	{
		/**
		 *  Constructor.
		 */
		public function CalendarStateBase()
		{
			super();
			this.setStyle('backgroundAlpha', 0 );
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods: UIComponent
		//
		//--------------------------------------------------------------------------
		
		/** 
		 * @private
		 */
		override protected function commitProperties():void{
			super.commitProperties();
			
			/* These are the values we're dealing with in this block 
			this.dayNameHeaderRenderer
			this.dayNameHeadersVisible
			this.dayNames
			*/
			if(this.redoDayNameHeaders == true){
				var createdDayNameHeaders : Boolean = false;
				
				// if dayNameHeadersVisible == false; destroy the headers
				// if dayNameHeadersVisible == true; and no headers exist; create them
				if(this.dayNameHeadersVisibleChanged == true){
					if(this.calendarData.dayNameHeadersVisible == true){
						// note: the CreatedayNameHeadersArray checks for the existence of headers and will not create them if they exist
						if(this.dayNameHeaders.length == 0){
							this.createDayNameHeadersArray();
							createdDayNameHeaders = true;
						}
					} else {
						this.destroyDayNameHeadersArray();
					}
					this.dayNameHeadersVisibleChanged = false;
				}
				
				// if dayNameHeaderRenderer has changed and dayNameHeadersVisible == true; destroy headers and create new ones
				// if dayNameHeaderRenderer has changed and dayNameHeadersVisible == false; do nothing
				if(this.dayNameHeaderRendererChanged == true){
					if(this.calendarData.dayNameHeadersVisible == true){
						this.destroyDayNameHeadersArray();
						this.createDayNameHeadersArray();
						createdDayNameHeaders = true;
					}
					this.dayNameHeaderRendererChanged = false;
				}
				
				// if dayNames has changed; loop over headers and change the data 
				// we don't need to do this if credatedayNameHeadersArray was called because the renderers will already have the new data
				// actually; if 
				if((this.dayNamesChanged == true)){ 
					if (createdDayNameHeaders  == false){
						if(this.dayNameHeaders.length > 0){
							for (var dayIndex : int = 0; dayIndex < 7; dayIndex++){
								var dayNameHeaderData : Object ;
								if(dayIndex < this.calendarData.dayNames.length){
									dayNameHeaderData = this.calendarData.dayNames[dayIndex]
								}
								this.dayNameHeaders[dayIndex]['data'] = dayNameHeaderData;
							}
						}
					}
					this.dayNamesChanged = false;
				}
				
				
				this.invalidateSize();
				this.invalidateProperties();
				this.redoDayNameHeaders = false;
				// make sure to resize the days if day name headers have changed 
				this.redoDayRenderers = true;
			}

			if(this.clearSelection == true){
				this.cachedSelectedItems = new Array();
				this.dayRenderersSelected = new Array();
				this.clearSelection = false;
				
			}
			
			
		}
		
		/** 
		 * @private
		 */
		override protected function measure():void{
			
			super.measure();
			
			var finalWidth : int = 0;
			var finalHeight : int = 0;
			
			// calculate the height and width of the dayNameHeaders.  
			// largest height should be added to finalHeight
			//Sum of widths should be compared to finalWidth and if bigger, be replaced 
			if(this.dayNameHeaders.length > 0){
				var widthOfHeaders : int = 0;
				var largestHeightofHeader : int = 0;
				
				for(var dayIndex : int = 0; dayIndex < 7; dayIndex++){
					var tempdayNameHeader : UIComponent = this.dayNameHeaders[dayIndex] as UIComponent;
					this.maxDayNameHeaderHeight = Math.max(this.maxDayNameHeaderHeight,tempdayNameHeader.getExplicitOrMeasuredHeight());
					largestHeightofHeader = Math.max(largestHeightofHeader,tempdayNameHeader.getExplicitOrMeasuredHeight());
					widthOfHeaders += tempdayNameHeader.getExplicitOrMeasuredWidth();
				}
				finalWidth = Math.max(finalWidth,widthOfHeaders);
				finalHeight += largestHeightofHeader;
			}
			
			
			this.measuredWidth =  finalWidth;
			this.measuredHeight = finalHeight;
			
		}		
		//--------------------------------------------------------------------------
		//
		//  variables
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  cachedSelectedItems
		//----------------------------------
		
		/**
		 * @private
		 * An array that contains the selected Items across all days. 
		 */
		protected var cachedSelectedItems : Array = new Array(0);

		
		//----------------------------------
		//  clearSelection
		//----------------------------------
		/**
		 * @private
		 * variable for clearing the selection values when state changes or allowMultipleSelection is swapped
		 */
		protected var clearSelection : Boolean = false;
		
		//----------------------------------
		//  dayNamesChanged
		//----------------------------------
		/** 
		 * @private
		 * This is a variable used in conjunction with commitProperties to tell if the day Names Array has changed. 
		 */
		protected var dayNamesChanged : Boolean = false;
		
		//----------------------------------
		//  dayNameHeaders
		//	An array of dayNameHeader objects 
		//----------------------------------
		/** 
		 * This is an array of dayNameHeader objects, for displaying the days of the week.
		 */
		protected var dayNameHeaders : Array = new Array(0);

		//----------------------------------
		//  dayNameHeadersVisibleChanged
		//----------------------------------
		/** 
		 * @private
		 * This is a variable used in conjunction with commitProperties to tell if the day Headers visibility has changed. 
		 */
		protected var dayNameHeadersVisibleChanged : Boolean = false;
		
		//----------------------------------
		//  dayNameHeaderRendererChanged
		//----------------------------------
		/** 
		 * @private
		 * This is a variable used in conjunction with commitProperties to tell if the day Headers Renderer has changed. 
		 */
		protected var dayNameHeaderRendererChanged : Boolean = false;
		
		
		//----------------------------------
		//  dayRenderersInUse
		//	An array of dayRenderers that are being used in the current month / year display 
		//----------------------------------
		/** 
		 * This is an array of dayRenderer instances that are being used in the current display.  
		 */
		protected var dayRenderersInUse : ArrayCollection = new ArrayCollection();

		
		//----------------------------------
		//  dayRenderersSelected
		//----------------------------------
		
		/**
		 * @private 
		 * an array that contains dayRenderers who have something selected 
		 */
		protected var dayRenderersSelected : Array = new Array(0);
		
		//----------------------------------
		//  minimizedDayHeight
		//----------------------------------
		/**
		 * @private 
		 */
		private var _minimizedDayHeight: int = 100;
		/**
		 * @private
		 * an internal variable for keeping track of the day height when the component is not in the expanded day state
		 * primarily used for sizing purposes in updateDisplayList if not in DAY_VIEW state
		 * @see #setupStateChange()
		 */ 
		protected function get minimizedDayHeight():int{
			return _minimizedDayHeight;
		}
		/**
		 * @private
		 */
		protected function set minimizedDayHeight(value:int):void{
			this._minimizedDayHeight = value;
		}
		
		
		//----------------------------------
		//  minimizedDayY
		//----------------------------------
		/**
		 * @private 
		 */
		private var _minimizedDayY: int = 0;
		/**
		 * @private
		 * an internal variable for keeping track of the day's x location when the component is not in the expanded day state
		 * primarily used for sizing purposes in updateDisplayList if not in DAY_VIEW state
		 * @see #setupStateChange()
		 */ 
		protected function get minimizedDayY():int{
			return _minimizedDayY;
		}
		
		/**
		 * @private
		 */
		protected function set minimizedDayY(value:int):void{
			this._minimizedDayY = value;
		}		
		//----------------------------------
		//  minimizedHeightOffset
		//----------------------------------
		/**
		 * @private 
		 */
		private var _minimizedHeightOffset: int = 0;
		/**
		 * @private
		 * used in conjunction w/ week to month state changes to test whether we need to setup the "reverse" values or not;
		 */
		protected var minimizedHeightOffsetInitialized : Boolean = false;
		
		/**
		 * @private
		 * an internal variable for keeping track of the space for the header in the month view; which may be different 
		 * than the needed space for the header in the day expanded view.  
		 * Calculated in the setupStateChange method. using formula:  
		 * Height of Days = (minimizedDayHeight * weeks in month)
		 * minimizedHeightOffset = height - Height of days 
		 * @see #setupStateChange()
		 */ 
		protected function get minimizedHeightOffset():int{
			return _minimizedHeightOffset;
		}
		/**
		 * @private
		 */
		protected function set minimizedHeightOffset(value:int):void{
			this._minimizedHeightOffset = value;
			this.minimizedHeightOffsetInitialized = true;
		}
		
		//----------------------------------
		//  monthNamesChanged
		//----------------------------------
		/** 
		 * @private
		 * This is a variable used in conjunction with commitProperties to tell if the monthNames Array has changed. 
		 */
		protected var monthNamesChanged : Boolean = false;
		
		//----------------------------------
		//  monthSymbolChanged
		//----------------------------------
		/** 
		 * @private
		 * This is a variable used in conjunction with commitProperties to tell if the month symbol has changed. 
		 */
		protected var monthSymbolChanged : Boolean = false;

		//----------------------------------
		//  redoDayData
		//----------------------------------
		/**
		 * @private
		 */
		private var _redoDayData : Boolean = false;
		
		/**
		 * @private
		 */
		protected function get redoDayData():Boolean
		{
			return _redoDayData;
		}
		
		/**
		 * @private
		 */
		protected function set redoDayData(value:Boolean):void
		{
			_redoDayData = value;
		}

		//----------------------------------
		//  redoDays
		//----------------------------------
		/**
		 * @private
		 */
		private var _redoDays : Boolean = false;
		
		/**
		 * @private
		 * flag that tells if the day's need to be either recreated or have their data refreshed
		 */
		protected function get redoDays():Boolean
		{
			return _redoDays;
		}
		
		/**
		 * @private
		 */
		protected function set redoDays(value:Boolean):void
		{
			_redoDays = value;
		}

		//----------------------------------
		//  redodayNameHeaders
		//  used if dayNameHeadersVisible, dayNameHeaderRenderer, or dayNames change 
		//----------------------------------
		/** 
		 * @private
		 * This is a variable used in conjunction with dayNameHeaders and commitProperties.  If the dayHadersVisible, dayNameHeaderRenderer, or dayNames change 
		 * then dayNameHeaders need to be recreated.
		 */
		protected var redoDayNameHeaders : Boolean = false;		

		//----------------------------------
		//  redoDayRenderers
		//  used if dataProvider, displayMonth, or displayYear change and we have to reshuffle renderer locations
		//  remove renderers, or create new renderers
		//----------------------------------
		/** 
		 * @private
		 * This is a variable used in conjunction with commitProperties to tell if the dataProvider, displayMonth, or displayYear have changed, therefore
		 * forcing dayRenderers to be moved around.
		 */
		protected var redoDayRenderers : Boolean = true;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  calendarData
		//----------------------------------
		/**
		 * @private
		 * private storage for the calendarData object
		 */
		private var _calendarData : ICalendarDataVO = new CalendarDataVO();
		/**
		 * @private
		 * Flag that lets us know that the calendarData object has changed or not
		 */
		protected var calendarDataChanged : Boolean = false;		

		[Bindable(event="calendarDataChanged")]
		/**
		 * @private
		 * made private instead of @inheritDoc so the children will inherit from the interface; not from the parent class
		 * really just a place holder; needs to be implemented in more detail in children
		 */
		public function get calendarData():ICalendarDataVO{
			return this._calendarData;
		}
		
		/**
		 * @private 
		 * really just a place holder; needs to be implemented in more detail in children
		 */
		public function set calendarData(value:ICalendarDataVO):void{

			if( 
				(ObjectUtil.compare(this._calendarData.dayNameHeaderRenderer,value.dayNameHeaderRenderer) != 0) || 
				(this._calendarData.dayNameHeadersVisible != value.dayNameHeadersVisible) || 
				(ObjectUtil.compare(this._calendarData.dayNames,value.dayNames) != 0)
			){
				
				this.redoDayNameHeaders = true;
				// in state changes we'll want to reset the minimizedHeightOffset if the day Name headers are removed or added
				// so switching this flag makes that happen 
				this.minimizedHeightOffsetInitialized = false;
				
				if(this._calendarData.dayNameHeadersVisible != value.dayNameHeadersVisible){
					this.dayNameHeadersVisibleChanged = true;
				}		
				
				if(ObjectUtil.compare(this._calendarData.dayNameHeaderRenderer,value.dayNameHeaderRenderer) != 0){
					this.dayNameHeaderRendererChanged = true;
				}
				if(ObjectUtil.compare(this._calendarData.dayNames,value.dayNames) != 0){
					this.dayNamesChanged = true;
				}
				
			}

			
			if(ObjectUtil.compare(this._calendarData.monthNames, value.monthNames) != 0){
				this.monthNamesChanged = true;
			}
			if(this._calendarData.monthSymbol != value.monthSymbol){
				this.monthSymbolChanged = true;
			}

			
			if((ObjectUtil.compare(this._calendarData.dayRenderer,value.dayRenderer) != 0) ){
				this.redoDays = true;
				this.redoDayData = true;
			}
			
			// before we change the calendarData internal variable
			// check to see if the dataProviderManager changed 
			// set a change handler event after we set it
			var dataProviderManagerChanged : Boolean = false;
			if( 
				((this._calendarData.dataProviderManager) && (value.dataProviderManager) &&
				(ObjectUtil.compare(this._calendarData.dataProviderManager.dataProvider,value.dataProviderManager.dataProvider) != 0))
				|| 
				( (!this._calendarData.dataProviderManager) && (value.dataProviderManager))
				
				){
				dataProviderManagerChanged = true;
			}
			
			// set the clearSelection value if allowMultipleSelection changes 
			if(this._calendarData.allowMultipleSelection != value.allowMultipleSelection){
				this.clearSelection = true;
			}
			
			
			this._calendarData= value;
			this.invalidateProperties();
			this.invalidateSize();
			this.invalidateDisplayList();

			
			// set up the listener for the dataProvider. dateField, or dateChange events
			// we want the add the listener if:
			// 1) the dataProviderManager has changed
			// 2) no listener exists on the current dataProviderManager
			if((dataProviderManagerChanged) 
				){
				this._calendarData.dataProviderManager.addEventListener('change',onDataProviderManagerChange);
			}

			this.dispatchEvent(new Event('calendarDataChanged'));
			
		}
		
		//----------------------------------
		//  dayStateOverrides
		//----------------------------------
		/**
		 * @private
		 */
		private var _dayStateOverrides : Array = new Array(0);
		
		[Bindable(event="dayStateOverridesChanged")]
		/**
		 * @inheritDoc
		 */
		public function get dayStateOverrides():Array
		{
			return _dayStateOverrides;
		}
		
		/**
		 * @private
		 */
		public function set dayStateOverrides(value:Array):void
		{
			_dayStateOverrides = value;
			this.dispatchEvent(new Event('dayStateOverridesChanged'));
		}

		//----------------------------------
		//  maxdayNameHeaderHeight
		//	The height of the longest dayNameHeader; set in measure, and reused in DisplayList
		//----------------------------------
		/** 
		 * @private
		 */
		private var _maxDayNameHeaderHeight : int = 0;
		/** 
		 * @private
		 * a function that will get the maxdayNameHeaderHeight.  If it is zero, it will calculate the maxdayNameHeaderHeight
		 * This property is used in updateDisplayList for layout.  It is caclulated in measure, or if measure is never executed because an explicit 
		 * height / width was set, it is calculated here.
		 */
		protected function get maxDayNameHeaderHeight(): int {
			// if return value is zero, then calculate it
			// if explicit height / width was set then measure never run setting it 
			if(this._maxDayNameHeaderHeight == 0){
				// calculate the maxdayNameHeaderHeight
				if(this.dayNameHeaders.length > 0){
					for each ( var tempHeader : UIComponent in this.dayNameHeaders){
						this._maxDayNameHeaderHeight = Math.max(this._maxDayNameHeaderHeight, tempHeader.getExplicitOrMeasuredHeight())	
					}
				}
			}
			
			return this._maxDayNameHeaderHeight;
		}
		
		/** 
		 * @private
		 */
		protected function set maxDayNameHeaderHeight(value:int): void{
			this._maxDayNameHeaderHeight = value;
		}
		
		//----------------------------------
		//  weekStateOverrides
		//----------------------------------
		/**
		 * @private
		 */
		private var _weekStateOverrides : Array= new Array(0);
		
		[Bindable(event="weekStateOverridesChanged")]
		/**
		 * @inheritDoc
		 */
		public function get weekStateOverrides():Array
		{
			return _weekStateOverrides;
		}
		
		/**
		 * @private
		 */
		public function set weekStateOverrides(value:Array):void
		{
			_weekStateOverrides = value;
			this.dispatchEvent(new Event('weekStateOverridesChanged'));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------		
		
		//----------------------------------
		//  createdayNameHeader
		//----------------------------------
		/**
		 * @private
		 * Helper method used to create a single dayNameHeader 
		 * @param data presumably a string which represents the day name; but in theory could be anything 
		 * @return The new dayNameHeader instace
		 * 
		 */
		protected function createDayNameHeader(data:Object, dayNameHeaderRenderer : IFactory):Object{
			var tempdayNameHeader : Object = dayNameHeaderRenderer.newInstance();
			if(tempdayNameHeader is IDataRenderer){
				tempdayNameHeader['data'] = data;
			}
			return tempdayNameHeader;
		}

		//----------------------------------
		//  createdayNameHeadersArray
		//----------------------------------
		/**
		 * @private
		 * Helper method used to create all dayNameHeaders array, for use within createChildren and commitProperies  
		 * Also adds the dayNameHeaders to the stage w/ addChild
		 * Implemented in Children ?
		 */
		protected function createDayNameHeadersArray():void{
			// only create headers if they aren't already created
			// and we assume none exist if length is 0
			// if length is greater than 0; assume all seven headers exist 
			if(this.dayNameHeaders.length == 0){
				// enforce the fact that we have 7 days even if someone messed w/ the dayNames value to make it an array of less than 7 values
				for (var dayIndex : int = 0; dayIndex < 7; dayIndex++){
					var dayNameHeaderData : Object ;
					if(dayIndex <= this.calendarData.dayNames.length-1){
						dayNameHeaderData = this.calendarData.dayNames[dayIndex]
					}
					var tempdayNameHeader : Object = createDayNameHeader(dayNameHeaderData, this.calendarData.dayNameHeaderRenderer);
					this.addChild(tempdayNameHeader as DisplayObject);
					this.dayNameHeaders.push(tempdayNameHeader);
				}
			}
			
		}
		
		
		//----------------------------------
		//  dateToDayRenderer
		//----------------------------------
		/** 
		 * This method takes a date and finds the dayRenderer instance that is currently displaying the item.
		 */
		public function dateToDayRenderer(date:Date):IDayRenderer{
			var result : IDayRenderer;
			
			var dataProvider : Object = this.calendarData.dataProviderManager.getData(date ,false);
			
			// loop over all the dayRenderers in Use until one matches the dataProvider
			for each ( var dayRenderer : IDayRenderer in this.dayRenderersInUse){
				if(dayRenderer.dayData.dataProvider == dataProvider){
					result = dayRenderer;
					break;
				}
			}
			
			return result;
		}		
		
		//----------------------------------
		//  deselectedSelectedDays
		//----------------------------------
		/**
		 * @private
		 * helper function to loop over all days with items selected and de select them.
		 * 3/11/2011 JH DotComIT
		 * But, we don't want to deselect days in the day we're currently selecting. Threw errors for client using our Spark Renderers
		 * added the dayToIgnore property 
		 */
		protected function deselectedSelectedDays(dayToIgnore:Object=null):void{
			if(this.dayRenderersSelected){
				for each (var dayRenderer : Object in this.dayRenderersSelected){
					// and then dayRenderer.deselectItems function
					if((dayRenderer is IDayRenderer) && (dayRenderer != dayToIgnore)){
						dayRenderer.deselectItems();
					}
				}
			}

			this.dayRenderersSelected = new Array();
			this.cachedSelectedItems = new Array();
			
		}
		
		//----------------------------------
		//  destroydayNameHeadersArray
		//----------------------------------
		/**
		 * @private 
		 * Helper function used to remove the dayNameHeaders from the stage w/ removeChild and null them out
		 */
		protected function destroyDayNameHeadersArray():void{
			for (var dayIndex : int = 0; dayIndex < 7 ; dayIndex++){
				var tempdayNameHeader : DisplayObject = this.dayNameHeaders.pop();
				if((tempdayNameHeader) && (tempdayNameHeader.parent)){
					this.removeChild(tempdayNameHeader);
				}
			}
		}
		
		//----------------------------------
		//  isParentTransitionPlaying
		//----------------------------------
		/**
		 * @private 
		 * Function to tell whether a transition is playing in the component's parent
		 * This is used to prevent updateDisplayList from resizing a component's children during a state transition
		 * This makes the absolutely [potentially horrible] assumption that the parent transition is running it affects this 
		 * component 
		 */
		protected function isParentTransitionPlaying():Boolean{

			if(!this.parent){
				return false;
			}
			var parent : UIComponent = this.parent as UIComponent;
			if(parent.transitions){
				for each(var transition : Transition in parent.transitions){
					if(transition.effect.isPlaying){
						return true;
					}
				}
			}

			return false;
		}
		
		//----------------------------------
		//  itemToDayRenderer
		//----------------------------------
		// this method must be override i the dayDisplay since it doesn't use dayRenderersInUse
		/** 
		 * This method takes an object and finds the dayRenderer instance that is currently displaying the item.
		 */
		public function itemToDayRenderer(data:Object):IDayRenderer{
			var result : IDayRenderer;
			// find the dataProvider for the day using the dataProviderDictionary 
			var date : Date = this.calendarData.dataProviderManager.itemToDate(data);
			
			var dataProvider : Object = this.calendarData.dataProviderManager.getData(date ,false);
			
			// loop over all the dayRenderers in Use until one matches the dataProvider
			for each ( var dayRenderer : IDayRenderer in this.dayRenderersInUse){
				if(dayRenderer.dayData.dataProvider == dataProvider){
					result = dayRenderer;
					break;
				}
			}
			
			return result;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------		
		/**
		 * @private 
		 * Handler function for when the dataProvider Manager has a change that affects the days
		 * overriden in sub classes to handle dataProvider change as appropriate 
		 */
		protected function onDataProviderManagerChange(e:Event):void{
			
		}

		/**
		 * @private
		 * 
		 * A default handler for the CalendarMouseEvent being propogated up from the dayRenderer.
		 * 
		 * If applicable this will redispatch the event
		 * 
		 * @param e The CalendarMouseEvent object
		 * 
		 */
		protected function onDayClickEvent(e:CalendarMouseEvent):void{
			
			// used in various places in the following code
			var dayRenderer : Object 
			
			// if the user did not click on an itemRenderer we should not do any selection work
			// do that by checking the e.itemRenderer 
			// one example of this may be clicking a scroll bar in a renderer 
			if(e.itemRenderer){
				
				// create a variable for holding all selected items 
				var selectedItems : Array ;
				
				// set the selectedItem, selectedIndex, and if relevant selectedIndices and selectedItems
				// we have the items (via e.list.selectedItems), so if we just use those, it should figure out the indexes for us
				// and this portion of code should be before the re-dispatch the event
				if((this.calendarData.allowMultipleSelection == false) ) {
					// if an item is selected; be sure to deselect it before resetting it
					// this is for visual purposes 
					// we need a "data to DayRenderer" function 
					deselectedSelectedDays(e.dayRenderer);
					this.dayRenderersSelected.push(e.dayRenderer);
					
					// then select the new item 
					//				this.selectedItem = e.list.selectedItem;
				} else {
					// if multiple selection is allowed 
					if((e.ctrlKey == false) && (e.shiftKey == false)){
						deselectedSelectedDays();
						// this block of code encapsulated into deselectSelectedDays and changed due to no longer having selectedItems; but rather an array of selected Days
						//					for each (var item : Object in this.selectedItems){
						//						dayRenderer = this.itemToDayRenderer(item);
						// and then dayRenderer.deselectItems function
						//						if(dayRenderer){
						//							dayRenderer.deselectItems();
						//						}
						//					}
						
						// then select the new item 
						//					this.selectedItem = e.list.selectedItem;
						selectedItems = new Array();
						selectedItems.push(e.list.selectedItem);
						//					this.cachedSelectedItems = selectedItems;
						this.dayRenderersSelected.push(e.dayRenderer);
						
					} else if(e.ctrlKey == true){
						
						// if the control key is selected then we are adding to the 'selectedItems' list not removing anything
						// and not parsing over multiple days to select multiple items 
						
						var nextArray : Array = this.cachedSelectedItems;
						
						// throwing errors if nextArray is null; which really should never occur
						if(!nextArray){
							nextArray = new Array();
						}
						if(e.list.selectedItem){
							nextArray.unshift(e.list.selectedItem);
						} else {
							// we need to remove all items from e.list.dataProvider from the nextArray 
							for each( var tempItem : Object in e.list.dataProvider){
								var tempIndex : int = nextArray.indexOf(tempItem);
								if(tempIndex >= 0){
									nextArray.splice(tempIndex,1);
								}
							}
						}
						selectedItems = nextArray;
						//					this.cachedSelectedItems = nextArray;; 
						this.dayRenderersSelected.push(e.dayRenderer);
						
					} else if (e.shiftKey == true){
						// if there is no current selectedItem, the List control will just return; in essence ignoring the event
						// If you shift select with nothing selected; nothing is selected
						// except at this stage, we're not going to return; we still want to bubble up the event
						if(this.cachedSelectedItems){
							
							// if the shift key is true...
							// we need to find the dayRenderer of the current selectedItem (this.selectedItem) 
							//						var currentDayRenderer : IDayRenderer = this.itemToDayRenderer(this.selectedItem);
							var currentDayRenderer : Object = this.dayRenderersSelected[this.dayRenderersSelected.length-1];
							// and the dayRenderer of the new selectedItem (e.list.selectedIem)
							//						var newDayRenderer : IDayRenderer = this.itemToDayRenderer(e.itemRenderer.data);
							var newDayRenderer : Object = e.dayRenderer;
							// temporary holder for direction of selection inside day renderers
							var direction : int = 0;
							
							
							if(currentDayRenderer == newDayRenderer){
								selectedItems = e.list.selectedItems;
								this.dayRenderersSelected.push(currentDayRenderer);
							} else {
								
								var newSelectedItemsArray : Array = new Array(0);
								
								// if new is after current, select from this.selectedItem down in current dayRenderer and e.list.selectedItem up in new dayRenderer
								// if new is before current select from this.selectedItem up in current dayRenderer and e.list.selectedItem down in new dayRenderer
								for each ( dayRenderer in this.dayRenderersInUse){
									if(dayRenderer == currentDayRenderer){
										if(newDayRenderer.dayData.displayedDateObject > currentDayRenderer.dayData.displayedDateObject){
											direction = 1;
										} else {
											direction = -1;
										}
										// using e.list.selectedItem makes no sense here because it won't be in the first renderer
										// it'll be in the last renderer
										// we need the selected item in the firstRenderer and then pick a direction from there 
										dayRenderer.selectItems(direction,dayRenderer.selectedItems[0]);
										newSelectedItemsArray = dayRenderer.selectedItems.concat(newSelectedItemsArray);
										this.dayRenderersSelected.push(dayRenderer);
									} else if (dayRenderer == newDayRenderer){
										if(newDayRenderer.dayData.displayedDateObject < currentDayRenderer.dayData.displayedDateObject){
											direction = 1;
										} else {
											direction = -1;
										}
										dayRenderer.selectItems(direction,e.itemRenderer.data);
										newSelectedItemsArray = dayRenderer.selectedItems.concat(newSelectedItemsArray);
										this.dayRenderersSelected.push(dayRenderer);
									} else if (DateUtilsExtension.dateBetween(currentDayRenderer.dayData.displayedDateObject, newDayRenderer.dayData.displayedDateObject, dayRenderer.dayData.displayedDateObject) == 1){
										dayRenderer.selectItems();
										newSelectedItemsArray = dayRenderer.selectedItems.concat(newSelectedItemsArray);
										this.dayRenderersSelected.push(dayRenderer);
									} else {
										// else be sure nothing is selected in dayRenderer
										// this is consistent w/ ListClass in which when you use shift to select a range all previously selected 
										// items outside of the range are ignored 
										dayRenderer.deselectItems();
										var indexToRemove : int = this.dayRenderersSelected.indexOf(dayRenderer);
										if(indexToRemove != -1){
											this.dayRenderersSelected.splice(indexToRemove,1 );
										}
									}
								}
								selectedItems = newSelectedItemsArray;
								
								
							}
						}
						
					}
				}
				
				// if any selectedItems were created; go ahead and add them to the event before redispatching them 
				if(selectedItems){
					e.selectedItems = selectedItems;
					this.cachedSelectedItems = selectedItems;
				}
			}
			
			
			// re-dispatch the event for folks on the outside
			// this event bubbles; so no need to redispatch 
//			var newEvent : CalendarMouseEvent = e.clone() as CalendarMouseEvent;
//			this.dispatchEvent(newEvent);
			
		}		
		
		// a generic event for handling drag drop functions broadcast from the dayRenderer
		/**
		 * @private
		 */
		protected function onDayDragEvent(e:CalendarDragEvent):void{
			// must create a clone of the event for the redispatch because otherwise
			// the cancel event is not propogated back down; how odd
			var newEvent : CalendarDragEvent = e.clone() as CalendarDragEvent;
			this.dispatchEvent(newEvent);
			
			if(newEvent.isDefaultPrevented()){
				e.preventDefault();
				return;
			}
			
		}	

		
		/**
		 * @private 
		 * This function is called when a dayRenderer fires the expandDay event.
		 * @param e The DayEvent 
		 * 
		 */
		protected function onDayEvent(e:CalendarChangeEvent):void{

			// must create a clone of the event for the redispatch because otherwise
			// the cancel event is not propogated back down; how odd
			var newEvent : CalendarChangeEvent = e.clone() as CalendarChangeEvent;
			this.dispatchEvent(newEvent);
			
			if(newEvent.isDefaultPrevented()){
				e.preventDefault();
				return;
			}
			
			if (
				( (e.type == CalendarChangeEvent.EXPAND_DAY) && ((this.calendarData.calendar as UIComponent).currentState != Calendar.DAY_VIEW ) ) || 
				( (e.type == CalendarChangeEvent.EXPAND_MONTH) && ((this.calendarData.calendar as UIComponent).currentState != Calendar.MONTH_VIEW ) ) || 
				( (e.type == CalendarChangeEvent.EXPAND_WEEK) && ((this.calendarData.calendar as UIComponent).currentState != Calendar.WEEK_VIEW ) )  
			){
				this.clearSelection = true;
				this.invalidateProperties();
			}
		}

		// a generic event for handling edit functions broadcast from the dayRenderer
		/**
		 * @private 
		 * This is a generic handler to handle CalendarEvents dispatched from a dayRenderer.  
		 * It will redispatch those to the parent object.
		 * 
		 * @param e The CalendarEvent
		 * 
		 */
		protected function onDayListEvent(e:CalendarEvent):void{		
			// must create a clone of the event for the redispatch because otherwise
			// the cancel event is not propogated back down; how odd
			var newEvent : CalendarEvent = e.clone() as CalendarEvent;
			this.dispatchEvent(newEvent);
			
			if(newEvent.isDefaultPrevented()){
				e.preventDefault();
				return;
			}
			
			
		}
		
	}
		
}