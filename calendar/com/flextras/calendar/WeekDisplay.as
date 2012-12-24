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
	import com.flexoop.utilities.dateutils.DateUtils;
	import com.flextras.utils.DateUtilsExtension;
	import com.flextras.utils.SetPropertyExposed;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.ListEvent;
	import mx.states.AddChild;
	import mx.states.RemoveChild;
	import mx.states.SetProperty;
	import mx.utils.ObjectUtil;

	/**
	 * This class represents the WEEK_VIEW state of the Flextras Calendar component.  It displays the days that make up the week, the week header, and the day name headers.
	 * 
	 * @author DotComIt / Flextras
	 * @see com.flextras.calendar.Calendar
	 * 
	 */	
	public class WeekDisplay extends CalendarStateBase implements IWeekDisplay, IObjectArrayForTransitions
	{
		/**
		 *  Constructor.
		 */
		public function WeekDisplay()
		{
			super();
			this.setStyle("backgroundColor","0xFFFFFF");
			this.setStyle("backgroundAlpha",'0');

			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy="off";
		
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: UIComponent
		//
		//--------------------------------------------------------------------------
/*
		*   dataProviderManager:		to get the data to display in the day		( redoDayData )
		*   dayNameHeadersVisible:		destroy dayNameHeaders if visible			( redoDayNameHeaders, dayNameHeadersVisibleChanged, redoDayRenderers--for positioning )
		*	 dayNameHeaderRenderer:		destroy and re-create dayNameHeaders		( redoDayNameHeaders, dayNameHeaderRendererChanged, redoDayRenderers--for positioning  )
		*   dayNames:					Passed into dayNameHeaders 					( redoDayNameHeaders, dayNamesChanged )
		*   dayRenderer: 				create and destroy the current days			( redoDays )
		*   displayedYear: 			need to change data on days if this changes	( redoDayData, redoWeekHeaderData )
		*   displayedMonth:			need to change data on days if this changes	( redoDayData, redoWeekHeaderData )
		* 	 firstDayOfWeek:			need to update the dayData					( redoDayNameHeaders, redoDayData )
		*   monthNames: 				update dayHeader info if changed			( redoWeekHeaderData, monthNamesChanged )
		* 	 monthSymbol: 				update dayHeader info if changed			( redoWeekHeaderData, monthSymbolChanged )
		*   weekHeaderVisible:			either create or destroy weekHeader			( redoWeekHeader, weekHeaderVisibleChanged, redoDayRenderers--for positioning)
		*   weekHeaderRenderer:		destroy then re-create weekHeader				( redoWeekHeader, weekHeaderRendererChanged., redoDayRenderers--for positioning)
*/
		/**
		 * @inheritDoc 
		 */
		override protected function commitProperties() : void{
			super.commitProperties();
			
			// a loop variable used to access the days
			var day : Object ;

			// do we need to recreate the weekHeader? 
			// this should only trigger if the weekHeaderVisible or weekHeaderRenderer has changed
			if(this.redoWeekHeader == true){
				if(!this.weekHeader && (this.calendarData.weekHeaderVisible == true)){
					this.weekHeader = this.createWeekHeader();
					if((this.parent) && (UIComponent(this.parent).currentState == Calendar.WEEK_VIEW )){
						this.addChild(this.weekHeader);
					}
				} else if(this.weekHeader && (this.calendarData.weekHeaderVisible == false)){
					this.destroyWeekHeader();
					
				} else if ((weekHeaderRendererChanged == true) && (this.calendarData.weekHeaderVisible == true)){
					// if the dayHeaderRenderer changed and the dayHEader should be displayed; destroy it then re-create it
					if(this.weekHeader){
						this.destroyWeekHeader();
					}
					this.weekHeader = this.createWeekHeader();
					if((this.parent) && (UIComponent(this.parent).currentState == Calendar.WEEK_VIEW) ){
						this.addChild(this.weekHeader);
					}
					this.weekHeaderRendererChanged = false;
				}
				
				// swap the flags for updating the weekHeader
				this.redoWeekHeader = false;
				this.redoWeekHeaderData = false;
				this.weekHeaderRendererChanged = false;
				
				// update size and positioning 
				this.invalidateSize();
				this.invalidateDisplayList();
				
				// if we aren't re-doing the dayHeader, but data in it may still need to be updated
				// assuming it exists
			} else if (this.weekHeader){   
				// if dayHeader is not implementing the interface; we won't be changing any data in it
				if(this.weekHeader is IWeekHeader){
					if(this.redoWeekHeaderData == true){
						(this.weekHeader as IWeekHeader).weekHeaderData = this.createWeekHeaderData();
						this.redoWeekHeaderData = false;
					}
					if(this.calendarDataChanged == true ){
						// don't reset calendarDataChanged here because we may need to update the dayRenderer too
						(this.weekHeader as IWeekHeader).weekHeaderData.calendarData = this.calendarData;
					}
				}
			}
			
			// deal with dayNameHeader stuff here
			
			// if needed recreate the day; do it
			if(this.redoDays == true){
				// destroy the days and the relevant add and remove headres
				for each (day in this.dayRenderersInUse){
					if( (day as UIComponent).parent) {
						this.removeChild(DisplayObject(day)); 
					}
				}
				this.overrideDayAddWeekArray = new Array();

				// recreate the days
				this.dayRenderersInUse.source = this.createDayRendererArray();
				this.dispatchEvent(new Event('objectArrayForTransitionsChanged'));
				
				// add the days to the stage
				this.addDays();
				this.updateDayAddRemoveOverrides = false;
				
				this.redoDays = false;
				this.calendarDataChanged == false;
				this.redoDayData = false;

				// update size and positioning 
				this.invalidateSize();
				this.invalidateDisplayList();
				
			}

			// if the dayData needs to be refreshed, do it here
			// it would already have been refreshed on the dayHeader
			// If it did need to be refreshed, but the day was recreated in an above block; the flag was switched to false
			if((this.redoDayData == true) && ((this.calendarData.calendar as Calendar).inWeekToMonthStateChange == false)){

				var dateOfWeek : Date = DateUtilsExtension.firstDateOfWeek(new Date(this.calendarData.displayedYear, this.calendarData.displayedMonth, this.calendarData.displayedDate),this.calendarData.firstDayOfWeek);
				for each (day in this.dayRenderersInUse){
					if(day  is IDayRenderer){
						var dp : Object = this.calendarData.dataProviderManager.getData(dateOfWeek );
						var dayData : DayDataVO = new DayDataVO(dateOfWeek.date,dp,new Date(dateOfWeek.fullYear, dateOfWeek.month, dateOfWeek.date));
						(day as IDayRenderer).dayData = dayData;
						(day as IDayRenderer).calendarData = this.calendarData;
						// added a call to invalidateDayData just to be safe
						// in our default dayRenderer this is not needed as both setting the dayData and invalidateDayData do the same thing
						// basically seting a dayDataChanged value and invalidatingProperties 
						(day as IDayRenderer).invalidateDayData();

					}
					dateOfWeek = DateUtils.dateAdd(DateUtils.DAY_OF_MONTH, 1, dateOfWeek);
					
				}
				
					
				this.redoDayData = false;
				this.calendarDataChanged = false;
			}
			
			// if the calendarData needs to be refreshed, refresh it on each day
			// if the days were recreated; the days will already have refreshed data and the flag would have already been swapped
			if(this.calendarDataChanged == true ){
				for each (day in this.dayRenderersInUse){
					if(day  is IDayRenderer){
						day.calendarData = this.calendarData;
					}
				}
				
				// weekHeader's Calendar Data is updated in the week header section  no need to update it again here 
				
				this.calendarDataChanged = false;
			}
			
			if(this.updateDayAddRemoveOverrides == true){
				if((this.calendarData.calendar as Calendar).inWeekToMonthStateChange == false){
					this.updateDayOverridesForMonth(new Date(this.calendarData.displayedYear, this.calendarData.displayedMonth, this.calendarData.displayedDate ));
				}
				this.updateDayAddRemoveOverrides = false;
			}
		
		}
		
		
		/** 
		 * @private
		 */
		override protected function createChildren():void{
			super.createChildren();
			if(this.calendarData.weekHeaderVisible == true){
				this.weekHeader = createWeekHeader();
				// adding it so it gets measured; but we remove it right before changing the Calendar state to the week state 
				// so it can fade in
				this.addChild(this.weekHeader);
			}
			
			// if there is nothing in the dayNameHeader array, create the dayNameHeaders 
			// we need to encapsulate the dayNameHeader create functionality so it can easily be reused in commitProperties
			if(this.calendarData.dayNameHeadersVisible == true){
				createDayNameHeadersArray();
			}

			
			
			if(this.calendarData.dayRenderer){
				this.dayRenderersInUse.source = this.createDayRendererArray();
				this.dispatchEvent(new Event('objectArrayForTransitionsChanged'));

				this.addDays();
				
			}
		}			
		
		/** 
		 * @private
		 */
		override protected function measure():void{

			if(isCalendarStateNotWeekView() && ((this.measuredWidth != 0) && (this.measuredHeight != 0))){
				return;
			}
			
			super.measure();
			// day name header calculations moved to CalendarStateBase

			// used to calculate the total ideal height of the component 
			var finalHeight : int = this.measuredHeight ;
			// used to calculate the total width of the component 
			var finalWidth : int = this.measuredWidth;
			
			
			if((this.calendarData.weekHeaderVisible == true) && (this.weekHeader)){
				finalWidth +=  this.weekHeader.getExplicitOrMeasuredWidth();
				finalHeight += this.weekHeader.getExplicitOrMeasuredHeight();
			}
			
			
			// this is a really simplified version of the code that happens in monthDisplay
			// we assume there are 7 days in dayRenderersInUse; even though some may not be added to the stage
			if((this.dayRenderersInUse) && (this.dayRenderersInUse.length > 0)){

				// in theory each day will have the same height and width; but just in case someone does something odd w/ DayRenderers, 
				// we aren't going to make that assumption
				// loop over days to find each week's width; save the longest width
				// find the largest height of each renderer in the week and add that to 'total' height
				
				// used in the loop to find the dayRenderer with the largest height of the current week
				var largestHeightInWeek : int = 0;

				// used in the loop to find the dayRenderer with the width of the current week
				var widthOfWeek : int = 0;
				
				for (var currentDay : int = 0; currentDay < this.dayRenderersInUse.length ; currentDay++) { 
					var currentDayRenderer : IDayRenderer = this.dayRenderersInUse.getItemAt(currentDay) as IDayRenderer;
					largestHeightInWeek = Math.max(largestHeightInWeek,currentDayRenderer.getExplicitOrMeasuredHeight());
					widthOfWeek += currentDayRenderer.getExplicitOrMeasuredWidth();
					
				}
				
				finalWidth = Math.max(finalWidth, widthOfWeek);
				finalHeight += largestHeightInWeek;

			}
			
			
			this.measuredWidth =  finalWidth;
			this.measuredHeight = finalHeight;
			
		}

		/** 
		 * @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			if(this.isParentTransitionPlaying() == true){
				// make sure that we don't resize day if a transition is running; I think it is screwing up the effect 
				return;
			}
			
			// if we're switching from week view to month and have a transition
			// and the monthHeader is hidden and weekHeader is not; the dayNameHeaders are getting 
			// in here; thus causing oddities w/ the move effect; essentially negating it
			// an attempt to address this:
			if((this.calendarData.calendar as Calendar).inWeekToMonthStateChange){
				return;
			}

			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			// some variables used for positioning as we look at each child of this component
			var startX : int = 0;
			var startY : int = 0;
			
			// some variables used for sizing as we look at each child of this component
			var widthOffset : int = 0;
			var heightOffset : int = 0;
			
			if(this.calendarData.weekHeaderVisible == true){
				
				if((this.weekHeader)){
					// if the weekHeader should be displayed and exists; size it to the full width of the component, and give it it's 
					// default height
					this.weekHeader.setActualSize(unscaledWidth,this.weekHeader.getExplicitOrMeasuredHeight());
					
					// position the dayHeader; most likely to 0,0
					this.weekHeader.move(startX, startY);
					// increment the startY value so next component (The Day) shows up underneath the dayHEader, not over it
					startY += this.weekHeader.height;
					// increment the heightOffset value so next component (The Day) expands to fill the component
					heightOffset += this.weekHeader.height ;
				}
			}

			// day width is used for both days and dayNameHeaders 
			var dayWidth : int = Math.floor(unscaledWidth/7) ;
			this.calendarData.calendarMeasurements.weekDayWidth = dayWidth;

			
			// the x position where we place each item
			startX = 0 + (dayWidth * (6 - this.calendarData.lastDayOfWeek));
			
			var sp : SetProperty 
			
			// size and layout the headers 
			// first run through I'm going to lay them out in order
			// then I'll deal with the first day of the week thing 
			if(this.dayNameHeaders.length > 0){
				
				// loop over days 7 times 
				for (var dayIndex : int = 0; dayIndex < this.dayNameHeaders.length; dayIndex++){
					var tempdayNameHeaderRenderer : UIComponent = this.dayNameHeaders[dayIndex]
					tempdayNameHeaderRenderer.setActualSize(dayWidth,this.maxDayNameHeaderHeight);
					tempdayNameHeaderRenderer.x = startX;
					tempdayNameHeaderRenderer.y = startY;

					sp = this.overrideDayNameHeaderYWeekArray[dayIndex];
					sp.value = startY;
					
					startX += dayWidth;
					
					if(dayIndex == this.calendarData.lastDayOfWeek){
						startX = 0;
					}
				}
				
				startY += this.maxDayNameHeaderHeight;
				heightOffset += this.maxDayNameHeaderHeight ;
				
			}
			
			// set the header height 
			this.calendarData.calendarMeasurements.weekHeaderHeight = heightOffset;
			

			// I doubt we'll ever be here where there aren't dayRenderers already created, but this is a nice safety blanket
			// we want to set the X and width values of all days; 
			// width = unscaledWidth / 7 
			// x = dayOfWeek*width  (With some respect for the first day of the week)
			// for height and y values we want to update the 
			// we are sizing and positioning all days regardless of whether or not they are added to the stage
			if((this.dayRenderersInUse) && (this.dayRenderersInUse.length > 0)){
				var dayHeight : int = unscaledHeight - heightOffset; 

				this.calendarData.calendarMeasurements.weekDayHeight = dayHeight;
				var dayY : int = startY;

				// we are assuming there can never be more than seven days in the array 
				for (var currentDay : int = 0; currentDay < this.dayRenderersInUse.length ; currentDay++) { 
					var currentDayRenderer : IDayRenderer = this.dayRenderersInUse.getItemAt(currentDay) as IDayRenderer;

					// day width is a constant 
					currentDayRenderer.width = dayWidth;
					
					// this should position the x properly no matter what order the days are in the dayRenderersInUse array
					// even though the days should be in chronological order 
					currentDayRenderer.x = dayWidth * DateUtilsExtension.dayOfWeekLocalized(currentDayRenderer.dayData.displayedDateObject,this.calendarData.firstDayOfWeek );
					
					// we are making the big assumption that the overrides are in the same order as the dayRenderers
					sp = this.overrideDayHeightWeekArray[currentDay];
					sp.value = dayHeight;

					
					sp = this.overrideDayYWeekArray[currentDay];
					sp.value = dayY;

					// this block of code is really only here for the initial set up phase; modeled after DayDisplay code
					// if the parent's initial setup is the day state; the size of the day will cover the dayHeader
					// as the month state values are 
					if((this.parent) && 
						(UIComponent(this.parent).currentState == Calendar.WEEK_VIEW) && 
						(sp.value != currentDayRenderer.height)){
						// Size the day to the full width of the component, and give it the full height, minus the heightOffset for the dayheader
						// if no dayHeader, the heightOffset will most likely be zero

						currentDayRenderer.height = unscaledHeight-heightOffset;
						// position the day
						currentDayRenderer.y = dayY;
						
					} 
					
				}

				
			}
			
			
		}	
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------		

		
		//----------------------------------
		//  monthOrYearChanged
		//----------------------------------
		/**
		 * @private
		 * for state resize purposes; make note that the month or year have changed
		 * the dayHeight measurements in calendarMEasurementVO will be invalid
		 */
		protected var weekChangeModifiedMonthOrYear : Boolean = false;
		
		//----------------------------------
		//  overrideAddWeekHeader
		//----------------------------------
		/**
		 * @private
		 */
		private var _overrideAddWeekHeader : AddChild;
		
		/**
		 * @private
		 * An internal hook to the override that adds the week Header
		 */
		protected function get overrideAddWeekHeader():AddChild
		{
			return _overrideAddWeekHeader;
		}
		
		/**
		 * @private
		 */
		protected function set overrideAddWeekHeader(value:AddChild):void
		{
			_overrideAddWeekHeader = value;
		}

		//----------------------------------
		//  overrideDayNameHeaderRemoveDayArray
		//----------------------------------
		/**
		 * @private
		 */
		private var _overrideDayNameHeaderRemoveDayArray : Array = new Array(0);
		
		/**
		 * @private
		 * An internal hook to the overrides that remove day headers when going to the day state 
		 */
		protected function get overrideDayNameHeaderRemoveDayArray():Array
		{
			return _overrideDayNameHeaderRemoveDayArray;
		}
		
		/**
		 * @private
		 */
		protected function set overrideDayNameHeaderRemoveDayArray(value:Array):void
		{
			_overrideDayNameHeaderRemoveDayArray = value;
		}
		
		
		//----------------------------------
		//  overrideDayNameHeaderYMonthArray
		//----------------------------------
		/**
		 * @private
		 */
		private var _overrideDayNameHeaderYMonthArray : Array = new Array(0);
		
		/**
		 * @private
		 * An internal hook to the overrides that add day headers when entering the week state ; presumably from the day state 
		 */
		protected function get overrideDayNameHeaderYMonthArray():Array
		{
			return _overrideDayNameHeaderYMonthArray;
		}
		
		/**
		 * @private
		 */
		protected function set overrideDayNameHeaderYMonthArray(value:Array):void
		{
			_overrideDayNameHeaderYMonthArray = value;
		}
		
		//----------------------------------
		//  overrideDayNameHeaderYWeekArray
		//----------------------------------
		/**
		 * @private
		 */
		private var _overrideDayNameHeaderYWeekArray : Array = new Array(0);
		
		/**
		 * @private
		 * An internal hook to the overrides that add day headers when entering the week state ; presumably from the day state 
		 */
		protected function get overrideDayNameHeaderYWeekArray():Array
		{
			return _overrideDayNameHeaderYWeekArray;
		}
		
		/**
		 * @private
		 */
		protected function set overrideDayNameHeaderYWeekArray(value:Array):void
		{
			_overrideDayNameHeaderYWeekArray = value;
		}
		//----------------------------------
		//  overrideDayAddWeekArray
		//----------------------------------
		/**
		 * @private
		 */
		private var _overrideDayAddWeekArray : Array = new Array(0);

		/**
		 * @private
		 * An internal hook to the overrides that add days in the WEEK_VIEW state
		 */
		protected function get overrideDayAddWeekArray():Array
		{
			return _overrideDayAddWeekArray;
		}

		/**
		 * @private
		 */
		protected function set overrideDayAddWeekArray(value:Array):void
		{
			_overrideDayAddWeekArray = value;
		}

		
		//----------------------------------
		//  overrideDayAddWeekActiveArray
		//----------------------------------
		/**
		 * @private
		 */
		private var _overrideDayAddWeekActiveArray : Array = new Array(0);
		
		/**
		 * @private
		 * An internal hook to the overrides that ad days that are currently in use
		 * as part of the state transition from MONTH_VIEW to WEEK_VIEW
		 */
		protected function get overrideDayAddWeekActiveArray():Array
		{
			return _overrideDayAddWeekActiveArray;
		}
		
		/**
		 * @private
		 */
		protected function set overrideDayAddWeekActiveArray(value:Array):void
		{
			_overrideDayAddWeekActiveArray = value;
		}
		
		//----------------------------------
		//  overrideDayHeightWeekArray
		//----------------------------------
		/**
		 * @private
		 */
		private var _overrideDayHeightWeekArray : Array = new Array(0);

		/**
		 * @private
		 * An internal hook to the overrides that change days heights in the WEEK_VIEW state
		 */
		protected function get overrideDayHeightWeekArray():Array
		{
			return _overrideDayHeightWeekArray;
		}

		/**
		 * @private
		 */
		protected function set overrideDayHeightWeekArray(value:Array):void
		{
			_overrideDayHeightWeekArray = value;
		}

		//----------------------------------
		//  overrideDayYWeekArray
		//----------------------------------
		/**
		 * @private
		 */
		private var _overrideDayYWeekArray : Array = new Array(0);

		/**
		 * @private
		 * An internal hook to the overrides that change days y position in the WEEK_VIEW state
		 */
		protected function get overrideDayYWeekArray():Array
		{
			return _overrideDayYWeekArray;
		}

		/**
		 * @private
		 */
		protected function set overrideDayYWeekArray(value:Array):void
		{
			_overrideDayYWeekArray = value;
		}

		//----------------------------------
		//  weekHeader
		//----------------------------------
		/**
		 * @private
		 */
		private var _weekHeader : UIComponent 
		
		/**
		 * This is a reference to the weekHeader object.
		 */
		protected function get weekHeader():UIComponent
		{
			return _weekHeader;
		}
		
		/**
		 * @private
		 */
		protected function set weekHeader(value:UIComponent):void
		{
			_weekHeader = value;
			this.dispatchEvent(new Event('objectArrayForTransitionsChanged'));
		}

		
		//----------------------------------
		//  weekHeaderVisibleChanged
		//----------------------------------
		/** 
		 * @private
		 * This is a variable used in conjunction with commitProperties to tell if the week Header visibility has changed. 
		 */
		protected var weekHeaderVisibleChanged : Boolean = false;
		
		//----------------------------------
		//  weekHeaderRendererChanged
		//----------------------------------
		/** 
		 * @private
		 * This is a variable used in conjunction with commitProperties to tell if the week Header Renderer has changed. 
		 */
		protected var weekHeaderRendererChanged : Boolean = false;


		//----------------------------------
		//  redoWeekHeader
		//----------------------------------
		/**
		 * @private
		 */
		private var _redoWeekHeader : Boolean = false;
		
		/**
		 * @private 
		 * Internal variable for figuring out when the WeekHeader needs to change
		 * flag that tells us to recreate or destroy the weekHeader 
		 */
		protected function get redoWeekHeader():Boolean
		{
			return _redoWeekHeader;
		}
		
		/**
		 * @private
		 */
		protected function set redoWeekHeader(value:Boolean):void
		{
			_redoWeekHeader = value;
		}
		
		//----------------------------------
		//  redoWeekHeaderData
		//----------------------------------
		/**
		 * @private
		 */
		private var _redoWeekHeaderData : Boolean = false;
		
		/**
		 * @private
		 * flag that tells if the weekHeaderData needs to be refreshed
		 */
		protected function get redoWeekHeaderData():Boolean
		{
			return _redoWeekHeaderData;
		}
		
		/**
		 * @private
		 */
		protected function set redoWeekHeaderData(value:Boolean):void
		{
			_redoWeekHeaderData = value;
		}

		//----------------------------------
		//  updateDayAddRemoveOverrides
		//----------------------------------
		/**
		 * @private
		 */
		private var _updateDayAddRemoveOverrides : Boolean = false;
		
		/**
		 * @private
		 * flag that tells that the add and remove day overrides needs to be refreshed
		 */
		protected function get updateDayAddRemoveOverrides():Boolean
		{
			return _updateDayAddRemoveOverrides;
		}
		
		/**
		 * @private
		 */
		protected function set updateDayAddRemoveOverrides(value:Boolean):void
		{
			_updateDayAddRemoveOverrides = value;
		}

				
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------		
		
		//----------------------------------
		//  calendarData
		//----------------------------------
		/**
		 * @copy com.flextras.calendar.ICalendarData#calendarData
		 */
		override public function get calendarData():ICalendarDataVO
		{
			return super.calendarData;
		}
		
		/**
		 * @private
		 * Value we care about from the calendarData that relate to changing this component: 
		 *   dataProviderManager:		to get the data to display in the day		( redoDayData )
 		 *   dayNameHeadersVisible:		destroy dayNameHeaders if visible			( redoDayNameHeaders, dayNameHeadersVisibleChanged )
		 *	 dayNameHeaderRenderer:		destroy and re-create dayNameHeaders		( redoDayNameHeaders, dayNameHeaderRendererChanged  )
  		 *   dayNames:					Passed into dayNameHeaders 					( redoDayNameHeaders, dayNamesChanged )
		 *   dayRenderer: 				create and destroy the current days			( redoDays )
		 *   displayedYear: 			need to change data on days if this changes	( redoDayData, redoWeekHeaderData )
		 *   displayedMonth:			need to change data on days if this changes	( redoDayData, redoWeekHeaderData )
		 * 	 firstDayOfWeek:			need to update the dayData					( redoDayNameHeaders, redoDayData )
		 *   monthNames: 				update dayHeader info if changed			( redoWeekHeaderData, monthNamesChanged )
		 * 	 monthSymbol: 				update dayHeader info if changed			( redoWeekHeaderData, monthSymbolChanged )
		 *   weekHeaderVisible:			either create or destroy weekHeader			( redoWeekHeader, weekHeaderVisibleChanged )
		 *   weekHeaderRenderer:		destroy then re-create weekHeader			( redoWeekHeader, weekHeaderRendererChanged)
		 */
		override public function set calendarData(value:ICalendarDataVO):void
		{

			if((this.calendarData.displayedMonth != value.displayedMonth) || 
				(this.calendarData.displayedYear != value.displayedYear) || 
				(this.calendarData.displayedDate != value.displayedDate)
			){
				this.redoDayData = true;
				this.redoWeekHeaderData = true;
				this.updateDayAddRemoveOverrides = true;
			}
			
			
			if(
				(ObjectUtil.compare(this.calendarData.monthNames, value.monthNames) != 0) || 
				(this.calendarData.monthSymbol != value.monthSymbol)){
				this.redoWeekHeaderData = true;
			}
			
			
			if ( (this.calendarData.firstDayOfWeek != value.firstDayOfWeek)  ) {
				this.redoDayData = true;
				this.redoWeekHeaderData = true;
				this.redoDayNameHeaders = true;
			}

			
			if(
				(ObjectUtil.compare(this.calendarData.monthNames, value.monthNames) != 0) || 
				(this.calendarData.monthSymbol != value.monthSymbol) || 
				(this.calendarData.weekHeaderVisible != value.weekHeaderVisible) || 
				(ObjectUtil.compare(this.calendarData.weekHeaderRenderer, value.weekHeaderRenderer) != 0) 
			){
				this.redoWeekHeader = true;
				
				if(this.calendarData.weekHeaderVisible != value.weekHeaderVisible){
					this.weekHeaderVisibleChanged = true;
				}
				if(ObjectUtil.compare(this.calendarData.weekHeaderRenderer, value.weekHeaderRenderer) != 0){
					this.weekHeaderRendererChanged = true;
					this.redoWeekHeader = true;
				}
				
			}

			
			super.calendarData = value;

			this.calendarDataChanged = true;
			// invalidation of properties, size, and display list is in the super
			
		}

		//----------------------------------
		//  objectArrayForTransitions
		//----------------------------------
		[Bindable("objectArrayForTransitionsChanged")]
		/**
		 * @inheritDoc
		 */
		public function get objectArrayForTransitions():Array{
			var resultArray : Array = new Array();
			if(this.weekHeader){
				resultArray.push(this.weekHeader);
			}
			if((this.dayRenderersInUse) && (this.dayRenderersInUse.length > 0)){
				for each ( var day : Object in this.dayRenderersInUse){
					resultArray.push(day);
				}
			}
			if((this.dayNameHeaders) && (this.dayNameHeaders.length >0)){
				for each ( var dayNameHeader : Object in this.dayNameHeaders){
					resultArray.push(dayNameHeader);
				}
				
			}
			return resultArray;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		
		/**
		 * @private
		 * This is a helper function for creating seven days that will be used to create the week.
		 */
		protected function addDays():void{
			// Add the children
			for (var index : int = 0; index< this.dayRenderersInUse.length; index++){
				var currentDay : IDayRenderer  = this.dayRenderersInUse[index]
				// add child if (displayedMonth ==  date.month) 
				if(currentDay.dayData.displayedDateObject.month == this.calendarData.displayedMonth ) {
					this.addChild(currentDay as DisplayObject);
				} else if(this.calendarData.leadingTrailingDaysVisible == true ){
					// weird bug if setting default Calendar state to Calendar.WEEK_VIEW with leadingTrailingDaysVisible set to true
					// then some days don't show up in the default state. 
					this.addChild(currentDay as DisplayObject);
				}
			}
			
		}

		//----------------------------------
		//  updateOverridesForDateChange
		//----------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function updateOverridesForDateChange(currentDate:Date, newDate : Date):void{
			// loop counter used later on in method
			var sp : SetPropertyExposed;
			
			// code to reset the minimizedHeight and minimizedY if applicable
			if((currentDate.fullYear != newDate.fullYear) || (currentDate.month != newDate.month)){
				// we only need to modify the minimizedHeight if the year or month have changed 
				// figure out the new minimized day height 
				// (height - header)/weeksinmonth
				
				this.minimizedDayHeight = calculateMonthDayHeight(newDate, this.calendarData.firstDayOfWeek);
				
				for each (sp in this.overrideDayHeightWeekArray){
					sp.oldValue = this.minimizedDayHeight;
				}
				
				// for state resize purposes; make note that the month or year have changed
				// the dayHeight measurements in calendarMEasurementVO will be invalid
				this.weekChangeModifiedMonthOrYear = true;
				
			}
			
			// y position will change every time week changes 
			// minimizedHeightOffset = ( height - headerheight )   ( or zero position for first week )
			// newY =  minimizedHeightOffset +  (minimizedDayHeight * (WeekOfMonth - 1))
			this.minimizedDayY = calculateMonthDayY(newDate , this.calendarData.firstDayOfWeek);
			
			for each (sp in this.overrideDayYWeekArray){
				sp.oldValue = this.minimizedDayY;
			}
			
		}
		
		
		//----------------------------------
		//  updateDayOverridesForWeekToDay
		//----------------------------------
		
		/**
		 * @private 
		 * Function to update the add and remove dayOverrides for the week or day views. 
		 * Values will depend on the date passed in and will most likely be run in the 
		 * process of setting up an effect
		 * 
		 * @param date
		 * 
		 */
		protected function updateDayOverridesForWeekToDay(date:Date):void{
			
			// remove the day removes from the weekState 
			for each(var removeDay : Object in this.overrideDayAddWeekActiveArray){
				this.weekStateOverrides.splice(this.weekStateOverrides.indexOf(removeDay),1);
			}

			this.overrideDayAddWeekActiveArray = new Array();
			
			// get the first date of the week; used for figuring out what should be added to stage and wht should be removed in the current state
			var currentDateOfWeek : Date = DateUtilsExtension.firstDateOfWeek(date,this.calendarData.firstDayOfWeek);
			
			for (var index : int = 0; index< this.dayRenderersInUse.length; index++){
				var currentDay : IDayRenderer  = this.dayRenderersInUse[index]
				
				
				if(
					(currentDateOfWeek.date != date.date) 
					){
					var ac : AddChild = this.overrideDayAddWeekArray[index] as AddChild;
					ac.mx_internal::added = true;
					this.weekStateOverrides.push(ac);
					this.overrideDayAddWeekActiveArray.push(ac);
					
				} 
				currentDateOfWeek = DateUtils.dateAdd(DateUtils.DAY_OF_MONTH, 1, currentDateOfWeek);
				
			}
			
		}

		//----------------------------------
		//  updateDayOverridesForMonth
		//----------------------------------

		/**
		 * @private
		 * Function to update the add and remove dayOverrides for the week or month views. 
		 * Values will depend on the week displayed and the 
		 * Will most likely be run in the process of setting up an effect
		 * 
		 * @param date
		 * 
		 */
		protected function updateDayOverridesForMonth(date:Date):void{
			
			// remove the day removes from the weekState 
			for each(var removeDay : Object in this.overrideDayAddWeekActiveArray){
				this.weekStateOverrides.splice(this.weekStateOverrides.indexOf(removeDay),1);
			}

			this.overrideDayAddWeekActiveArray = new Array();
			
			// if the leadingTrailingDaysVisible is true then we don't want to add or remove any days as part of the state
			// change because in the month view they'll all be displayed 
			if(this.calendarData.leadingTrailingDaysVisible == true){
				return;
			}
			
			// get the first date of the week; used for figuring out what should be added to stage and wht should be removed in the current state
			var currentDateOfWeek : Date = DateUtilsExtension.firstDateOfWeek(date, this.calendarData.firstDayOfWeek);

			for (var index : int = 0; index< this.dayRenderersInUse.length; index++){
				var currentDay : IDayRenderer  = this.dayRenderersInUse[index]

				if(currentDateOfWeek.month != date.month){
					// if expanded a half week; we'll need to add items to the stage
					// before swaping week and month view be sure that the week matches up with the display week by removing children
					if((UIComponent(this.calendarData.calendar).currentState != Calendar.WEEK_VIEW) && (currentDay.parent)){
						this.removeChild(currentDay as DisplayObject);
					}
						
					var ac : AddChild = this.overrideDayAddWeekArray[index]
					this.weekStateOverrides.push(ac);
					this.overrideDayAddWeekActiveArray.push((ac));
					ac.mx_internal::added = true;

				} else if (currentDateOfWeek.month == date.month ){
					// if expanding a full week after a half week has been expanded, be sure it is added tot he stage 
					if((UIComponent(this.calendarData.calendar).currentState != Calendar.WEEK_VIEW) && (!currentDay.parent)){
						this.addChild(currentDay as DisplayObject);
					}
					
				} 
				currentDateOfWeek = DateUtils.dateAdd(DateUtils.DAY_OF_MONTH, 1, currentDateOfWeek);
				
			}

		}

		//----------------------------------
		//  calculateMonthDayHeight
		//----------------------------------
		/**
		 * @private
		 *  figure out the new minimized day height 
		 *  (height - header)/weeksinmonth
		 * 
		 * @param date
		 * @param firstDayOfWeek
		 * @return 
		 * 
		 */
		protected function calculateMonthDayHeight(date : Date, firstDayOfWeek : int):int{
			// a Date object referencing the first date of the month; used to calculate the days in the first week of the month
			// and thereby the positioning of headers and days 
			var firstDateOfMonth : Date = new Date(date.fullYear,date.month,1);
			
			// find out how many weeks there are in the month
			// it is either going to be 4 or 5 or 6
			var weeksInMonth : int = DateUtilsExtension.weeksInMonth(firstDateOfMonth, firstDayOfWeek);
			
			return Math.floor( (this.height - this.minimizedHeightOffset)/weeksInMonth);
		}
		
		
		//----------------------------------
		//  calculateMonthDayY
		//----------------------------------
		/**
		 * @private
		 * y position will change every time week changes  
		 * @param date
		 * @param firstDayOfWeek
		 * @return 
		 * 
		 */
		protected function calculateMonthDayY(date:Date, firstDayOfWeek : int ):int{
			var weekOfMonth : int = DateUtilsExtension.weekOfMonth(date, firstDayOfWeek);
			return this.minimizedHeightOffset + (this.minimizedDayHeight * (weekOfMonth-1));
			
		}
		
		//----------------------------------
		//  createdayNameHeadersArray
		//----------------------------------
		/**
		 * @private
		 * Helper method used to create all dayNameHeaders array, for use within createChildren() and commitProperies()  
		 * Not calling super method so we only loop once over the arrays
		 * Also in the parent the dayNames are added w/ AddChild something we don't do here. 
		 */
		override protected function createDayNameHeadersArray():void{
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
					var tempDayNameHeader : Object = createDayNameHeader(dayNameHeaderData, this.calendarData.dayNameHeaderRenderer);

					// if parent is already in month State or week state; add the dayNameHeader right away
					if( (this.parent) && (
						( (this.parent as UIComponent).currentState == Calendar.MONTH_VIEW) ||
						( (this.parent as UIComponent).currentState == Calendar.WEEK_VIEW))
						){
						this.addChild(tempDayNameHeader as DisplayObject);
					}
					this.dayNameHeaders.push(tempDayNameHeader);
					
					var dayNameHeaderY : SetPropertyExposed = new SetPropertyExposed(tempDayNameHeader, 'y',  0);
					this.overrideDayNameHeaderYWeekArray.push(dayNameHeaderY);
					this.weekStateOverrides.push(dayNameHeaderY);
					
					var removeDayNameHeader : RemoveChild = new RemoveChild(tempDayNameHeader as DisplayObject);
					this.overrideDayNameHeaderRemoveDayArray.push(tempDayNameHeader);
				}
				this.dispatchEvent(new Event('objectArrayForTransitionsChanged'));
				
			}
			
		}
		
		
		//----------------------------------
		//  createDayRenderer
		//----------------------------------
		/**
		 * @private
		 * Helper function to create a single instance of the day renderer.
		 */
		protected function createDayRenderer(day:int, month : int, year : int, dataProvider:Object):Object{
			var nextDayRenderer : DisplayObject = this.calendarData.dayRenderer.newInstance();


			nextDayRenderer.addEventListener(ListEvent.CHANGE,onDayListEvent);
			nextDayRenderer.addEventListener(ListEvent.ITEM_CLICK,onDayListEvent);
			nextDayRenderer.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,onDayListEvent);
			nextDayRenderer.addEventListener(ListEvent.ITEM_EDIT_BEGIN,onDayListEvent);
			nextDayRenderer.addEventListener(ListEvent.ITEM_EDIT_BEGINNING,onDayListEvent);
			nextDayRenderer.addEventListener(ListEvent.ITEM_EDIT_END,onDayListEvent);
			nextDayRenderer.addEventListener(ListEvent.ITEM_FOCUS_IN,onDayListEvent);
			nextDayRenderer.addEventListener(ListEvent.ITEM_FOCUS_OUT,onDayListEvent);
			nextDayRenderer.addEventListener(ListEvent.ITEM_ROLL_OUT,onDayListEvent);
			nextDayRenderer.addEventListener(ListEvent.ITEM_ROLL_OVER,onDayListEvent);
			
			nextDayRenderer.addEventListener(CalendarMouseEvent.CLICK_DAY,onDayClickEvent);
			nextDayRenderer.addEventListener(CalendarDragEvent.DRAG_COMPLETE_DAY,onDayDragEvent);
			nextDayRenderer.addEventListener(CalendarDragEvent.DRAG_DROP_DAY,onDayDragEvent);
			nextDayRenderer.addEventListener(CalendarDragEvent.DRAG_ENTER_DAY,onDayDragEvent);
			nextDayRenderer.addEventListener(CalendarDragEvent.DRAG_EXIT_DAY,onDayDragEvent);
			nextDayRenderer.addEventListener(CalendarDragEvent.DRAG_OVER_DAY,onDayDragEvent);
			nextDayRenderer.addEventListener(CalendarDragEvent.DRAG_START_DAY,onDayDragEvent); 
			nextDayRenderer.addEventListener(CalendarChangeEvent.EXPAND_DAY,onDayEvent);
			nextDayRenderer.addEventListener(CalendarChangeEvent.EXPAND_WEEK,onDayEvent);
			nextDayRenderer.addEventListener(CalendarChangeEvent.EXPAND_MONTH,onDayEvent);

			
			if(nextDayRenderer  is IDayRenderer){
				var dayData : DayDataVO = new DayDataVO(day,dataProvider,new Date(year, month, day));
				(nextDayRenderer as IDayRenderer).dayData = dayData;
				(nextDayRenderer as IDayRenderer).calendarData = this.calendarData;
			}
			
			// deal with the overrides for sizing and positioning of the day 
			// Will be used when switching between DAY_VIEW and MONTH_VIEW 
			var y : int =0;
			var height : int = this.height
			if(this.weekHeader){
				y = this.weekHeader.height;
				height = this.height - this.weekHeader.height
			}
			return nextDayRenderer;
		}

		//----------------------------------
		//  createDayRendererArray
		//----------------------------------
		/**
		 * @private
		 * helper function for creating the dayRenderer Array
		 * Doesn't add children to the stage
		 */
		protected function createDayRendererArray():Array{
			var results : Array = new Array();
			
			var displayedDate : Date = new Date(this.calendarData.displayedYear, this.calendarData.displayedMonth, this.calendarData.displayedDate);
			var firstDateOfWeek : Date = DateUtilsExtension.firstDateOfWeek(displayedDate,this.calendarData.firstDayOfWeek )
				
			// calculate the day height 	
			var dayHeight : int = this.height;
			var dayYOffset : int = 0;
			if((this.calendarData.weekHeaderVisible == true ) && (this.weekHeader)){
				dayHeight -= this.weekHeader.height;
				dayYOffset += this.weekHeader.height;
			}
			
			// figure out height and Y offset of dayNameHeaders
			if((this.calendarData.dayNameHeadersVisible == true) && (this.dayNameHeaders.length > 0 )){
				var dayNameHeaderLargestHeight : int = 0;
				for each ( var dayNameHeader : UIComponent in this.dayNameHeaders){
					dayNameHeaderLargestHeight = Math.max(dayNameHeader.height,dayNameHeaderLargestHeight);
				}
				dayHeight -= dayNameHeaderLargestHeight;
 				dayYOffset += dayNameHeaderLargestHeight;
			}

			var minimizedDayHeight : int = Math.floor( (this.height-dayYOffset)/DateUtilsExtension.weeksInMonth(displayedDate,this.calendarData.firstDayOfWeek) );
			var minimizedDayY : int = dayYOffset + (minimizedDayHeight * (DateUtilsExtension.weekOfMonth(displayedDate,this.calendarData.firstDayOfWeek)-1) );

			
			// re-initialize the override arrays because they are getting duplicates if dayRenderer changes 
			this.overrideDayYWeekArray = new Array();
			this.overrideDayHeightWeekArray = new Array();
			this.overrideDayHeightWeekArray = new Array();
			this.overrideDayAddWeekArray = new Array();

			// create the dayRendererArray
			for (var x : int = 0;x<=6 ; x++){
				
				var nextDate : Date = DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,x,firstDateOfWeek );

				// get the dataProvider for this day
				var dp : Object;
				if(this.calendarData.dataProviderManager){
					dp = this.calendarData.dataProviderManager.getData( nextDate ); 
				}
				// create the dayRenderer 
				var nextDayRenderer : DisplayObject = this.createDayRenderer(nextDate.date, nextDate.month, nextDate.fullYear, dp ) as DisplayObject;
				results.push(nextDayRenderer);
				// add dayRenderer to dayRenderer array
				this.dayRenderersInUse.addItem(nextDayRenderer);
				
				// set up the overrides 
				var addDayOverride : AddChild= new AddChild(this,nextDayRenderer);
				this.overrideDayAddWeekArray.push(addDayOverride);
				
				var dayHeightOverride : SetPropertyExposed = new SetPropertyExposed(nextDayRenderer,'height', dayHeight );
				this.overrideDayHeightWeekArray.push(dayHeightOverride);

				var dayYOverride : SetPropertyExposed = new SetPropertyExposed(nextDayRenderer,'y', y + dayYOffset);
				this.overrideDayYWeekArray.push(dayYOverride);

				// not adding the day to the override list; but add the rest of the stuff 
				this.weekStateOverrides.push(dayHeightOverride, dayYOverride);
			
			}
			
			return results;
		}
		
		//----------------------------------
		//  createWeekHeader
		//----------------------------------
		/**
		 * @private
		 * Helper function to create the week header.
		 */
		protected function createWeekHeader():UIComponent{
			var tempWeekHeader : UIComponent = this.calendarData.weekHeaderRenderer.newInstance() as UIComponent;
			if(tempWeekHeader  is IWeekHeader){
				(tempWeekHeader as IWeekHeader).weekHeaderData = this.createWeekHeaderData();
			}
			tempWeekHeader.addEventListener(CalendarChangeEvent.NEXT_WEEK, onNextWeek);
			tempWeekHeader.addEventListener(CalendarChangeEvent.PREVIOUS_WEEK, onPreviousWeek);
			
			// create the appropriate dayHeader overrides 
			overrideAddWeekHeader = new AddChild(this, tempWeekHeader, 'firstChild');
			this.weekStateOverrides.push(overrideAddWeekHeader);
			
			return tempWeekHeader;
		}

		//----------------------------------
		//  createWeekHeaderData
		//----------------------------------
		/**
		 * @private
		 * Helper function for creating the week header data object
		 */
		protected function createWeekHeaderData():ICalendarHeaderDataVO{
			var monthName : Object;
			if(this.calendarData.displayedMonth <= this.calendarData.monthNames.length-1){
				monthName = this.calendarData.monthNames[this.calendarData.displayedMonth];
			} else {
				monthName = '';
			}
			
			return new MonthHeaderDataVO(this.calendarData.displayedMonth, this.calendarData.displayedYear, monthName, this.calendarData.monthSymbol,this.calendarData);
		}		
		
		/**
		 * @inheritDoc
		 */
		public function changeWeek(value:int=1):void
		{
			// if the change value is 0; change nothing
			if(value == 0){
				return;
			}
			
			var currentDate : Date = new Date(this.calendarData.displayedYear, this.calendarData.displayedMonth, this.calendarData.displayedDate);
			// we're changing the week, so a single week increment is really 7 days
			var newDate : Date = DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,value*7,currentDate);
			
			this.updateOverridesForDateChange(currentDate, newDate);

			
			// update the calendarData 
			this.calendarData.displayedYear = newDate.fullYear;
			this.calendarData.displayedMonth = newDate.month;
			this.calendarData.displayedDate = newDate.date;

			this.invalidateWeek();
			
			
		}

		//----------------------------------
		//  destroydayNameHeadersArray
		//----------------------------------
		/**
		 * @private 
		 * Helper function used to remove the dayNameHeaders from the stage w/ removeChild and null them out
		 * not calling super due to performance reasons
		 */
//		override protected function destroyDayNameHeadersArray():void{
//			for (var dayIndex : int = 0; dayIndex < 7; dayIndex++){
//				var tempdayNameHeader : DisplayObject = this.dayNameHeaders.pop();
//				this.removeChild(tempdayNameHeader);
				
//			}
		
//		}
		
		
		//----------------------------------
		//  destroyWeekHeader
		//----------------------------------
		/**
		 * @private
		 * Helper function to destroy the week header.
		 */
		protected function destroyWeekHeader():void{
			this.weekHeader.removeEventListener(CalendarChangeEvent.NEXT_WEEK, onNextWeek);
			this.weekHeader.removeEventListener(CalendarChangeEvent.PREVIOUS_WEEK, onPreviousWeek);
			if(this.weekHeader && this.weekHeader.parent){
				this.removeChild(this.weekHeader);
			}
			
			// remove from overrides 
//			this.weekStateOverrides.splice(this.weekStateOverrides.indexOf(this.overrideRemoveWeekHeader),1);
			this.weekStateOverrides.splice(this.weekStateOverrides.indexOf(this.overrideAddWeekHeader),1);
			
			// remove the appropriate dayHeader overrides 
			this.weekHeader = null;
			overrideAddWeekHeader = null;
//			overrideRemoveWeekHeader = null;
			
		}
		
		
		//----------------------------------
		//  invalidateWeek
		//----------------------------------
		/**
		 * @inheritDoc
		 */
		public function invalidateWeek():void{
			this.redoDayData = true;
			this.redoWeekHeaderData = true;
			// update the add and remove day overrides also 			
			this.updateDayAddRemoveOverrides = true;
			this.invalidateProperties();
		}			
		
		/**
		 * @private 
		 * A helper function for deciding if the Calendar component's current state is in the week view;
		 * if it is not we don't want to run updateDisplayList, commitProperties, or measure 
		 * Returns false if the state of the Calendar is equal to Calendar.WEEK_VIEW; true otherwise. False will be returned if calendarData is not defined
		 * 
		 */
		protected function isCalendarStateNotWeekView():Boolean{
			return ((this.calendarData) && (this.calendarData.calendar) && (UIComponent(this.calendarData.calendar).currentState != Calendar.WEEK_VIEW));
		}
		

		// this has become a huge mish mash nightmare and perhaps can be optimized 
		/**
		 * @inheritDoc
		 */
		public function setupStateChange(minimizedDayHeight : int, 
										 minimizedDayY : int, expandedDate : Date, repositionDay : Boolean = false, toState : String = '', 
										 minimizedHeightOffset : int = 0, minimizedDayNameHeaderY : int =0 ):void{

			// just a variable used in various spots throughout the method
			var sp : SetPropertyExposed ;
			var day : UIComponent ;
			
			// loop counter used in various places 
			var currentDay : int

			
			// this function should set the minimizedDayHeight and minizedDayY values
			// it should also accept the date and add the "Add Child" and "Remove Child" properties on the override list 
			this.minimizedDayHeight = minimizedDayHeight;
			this.minimizedDayY = minimizedDayY;
			

			// set up the reverse state change'
			// this only occurs if we're going from week to month, but have never went from month to week 
			var setupReverseStateChange : Boolean = false;

			var currentCalendarState : String = (this.calendarData.calendar as UIComponent).currentState;
			// doing some magic w/ the weekHeader
			// it was added to the stage on createChildren for default measurement purposes
			// but before we change into the week view we want to make sure it isn't on the stage 
			// due to the layering of states
			if(toState == Calendar.WEEK_VIEW ){
				if((this.weekHeader) && (this.weekHeader.parent == this)){
					this.removeChild(this.weekHeader);
				}
				
				// if there is a * to * transition then the dayHeaders are removed during the initial setup; be sure to add them back 
				if(this.calendarData.dayNameHeadersVisible == true){
					for each ( var tempDayHeader  : DisplayObject in this.dayNameHeaders){
						if(!tempDayHeader.parent){
							this.addChild(tempDayHeader);
						}
					}
				}
				
				// if going to the week view from the dayView; return
				if(currentCalendarState == Calendar.DAY_VIEW){
					// if going to a week where some of the days are off the month; they fade in at the wrong size
					// so gotta make sure that all the days are sized and positioned correctly
					for (currentDay = 0; currentDay < this.dayRenderersInUse.length ; currentDay++) { 
						day = this.dayRenderersInUse[currentDay] as UIComponent;
						day.height = minimizedDayHeight;
					}
					

					
					
					return;
				}
			} else if ((toState == Calendar.MONTH_VIEW) && (currentCalendarState == Calendar.WEEK_VIEW) && 
						(this.minimizedHeightOffsetInitialized == true)){

					if( 
						(this.weekChangeModifiedMonthOrYear == false) && 
						(
							(this.calendarData.displayedYear != expandedDate.fullYear) || 
							(this.calendarData.displayedMonth != expandedDate.month)
						) 
						){
						var currentDate : Date = new Date(this.calendarData.displayedYear, this.calendarData.displayedMonth, this.calendarData.displayedDate);
						this.updateOverridesForDateChange(currentDate, expandedDate);
					}
//					this approach don't seem to be working 					
//					if(this.monthOrYearChanged == false){
//						var currentDate : Date = new Date(this.calendarData.displayedYear, this.calendarData.displayedMonth, this.calendarData.displayedDate);
//						this.updateOverridesForNewMonth(currentDate, expandedDate);
//					}
				
					if(this.weekChangeModifiedMonthOrYear == false){

						
						// here to solve ths situation that occurs when moving from month to day to week to month
						// dayHeaders are not moving in week to month transition
						for (currentDay = 0; currentDay < this.dayRenderersInUse.length ; currentDay++) { 
	
							sp = this.overrideDayHeightWeekArray[currentDay];
							sp.value = (sp.target as UIComponent).height;
	
	
							// if the monthOrYearChanged [by changig the week with the changeWeek method] we don't want to reset the minimizedDayHeight
							// because it was reset in the changeWeek method
	//						if(this.monthOrYearChanged == false){
								sp.oldValue= minimizedDayHeight;
								
	//						} 
	
							// make sure that the Y values are correct 
							sp = this.overrideDayYWeekArray[currentDay];
							sp.value = (sp.target as UIComponent).y;
	//						if(this.monthOrYearChanged == false){
								sp.oldValue = calculateMonthDayY(expandedDate, this.calendarData.firstDayOfWeek);
	//						}
							
							if(this.overrideDayNameHeaderYWeekArray.length > currentDay){
									sp = this.overrideDayNameHeaderYWeekArray[currentDay];
									sp.oldValue= this.calendarData.calendarMeasurements.monthDayNameHeaderY;
							}
						}
						
						// update the overrides (nope; they are updated in the 
//						this.updateDayOverridesForMonth(expandedDate)
						// just in csecommitProperties is planning to re-update the dayAddRemoveOverrides; tell it not to
						// by switching this flag; otherwise what was done in the previous method call will be undone
						// for the transitions
//						this.updateDayAddRemoveOverrides = false;
					}

					this.weekChangeModifiedMonthOrYear = false;
					return;
			}

			if((toState == Calendar.MONTH_VIEW) && (currentCalendarState == Calendar.WEEK_VIEW) && 
				(this.minimizedHeightOffsetInitialized == false)){
				setupReverseStateChange = true;
			}
			
			
			if(minimizedHeightOffset == 0){
				// calculate the minimizedHeightOffset; which is the space for the header in the month view
				// instead of sending it in we calculate it 
				var weeksInMonth : int = DateUtilsExtension.weeksInMonth(expandedDate, this.calendarData.firstDayOfWeek) 
				// subtracting the 1 to count for the offset in the 0 based coordinate system 
				this.minimizedHeightOffset = this.height - (weeksInMonth * minimizedDayHeight) -1; 
			} else {
				this.minimizedHeightOffset = minimizedHeightOffset; 
			}
			
			// calculate the Y position of the dayNameHeaders which is the total header height  (minimizedHeightOffset) - is the maxDayNameHeaderHeight
			if(minimizedDayNameHeaderY == 0){
				minimizedDayNameHeaderY  = this.minimizedHeightOffset - this.maxDayNameHeaderHeight;
			}
			
			
			// this function should set the minimizedDayHeight and minizedDayY values
			// it should also accept the date and add the "Add Child" and "Remove Child" properties on the override list 
// moved higher in method so these values are defined earlier 
//			this.minimizedDayHeight = minimizedDayHeight;
//			this.minimizedDayY = minimizedDayY;
			

			// get the first date of the week; used for figuring out what should be added to stage and wht should be removed in the current state
			var currentDateOfWeek : Date = DateUtilsExtension.firstDateOfWeek(expandedDate, this.calendarData.firstDayOfWeek);
			
			// modify the overrides for sizing and positioning the days 
			// will be used when switching between the WEEK_VIEW and the MONTH_VIEW 
			// Gonna make the big assumption that the dayRenderersInUse and DayNameHeaderWeekArray and dayNameHEaders arrays will be of same length [7]

			for (currentDay = 0; currentDay < this.dayRenderersInUse.length ; currentDay++) { 
				
				// prep the dayHeight for the state change 
				if(setupReverseStateChange == true){
					sp = this.overrideDayHeightWeekArray[currentDay];
					sp.value = (sp.target as UIComponent).height;
					sp.oldValue= minimizedDayHeight;
				}

				// prep the day's Y Position for the state change 
				if(setupReverseStateChange == true){
					sp = this.overrideDayYWeekArray[currentDay];
					sp.value = (sp.target as UIComponent).y;
					sp.oldValue = calculateMonthDayY(expandedDate, this.calendarData.firstDayOfWeek);
				}

				if(this.overrideDayNameHeaderYWeekArray.length > currentDay){
					sp = this.overrideDayNameHeaderYWeekArray[currentDay];
					if(setupReverseStateChange == true){
						sp.oldValue = this.calendarData.calendarMeasurements.monthDayNameHeaderY;
					} else {
						sp.value = minimizedDayNameHeaderY;
					}
				}
				
				if(repositionDay == true){
					day = this.dayRenderersInUse[currentDay] as UIComponent;
					day.height = minimizedDayHeight;
					day.y = this.minimizedDayY;
					// width and x don't need to be changed in the minimized state 
					
					if(this.dayNameHeaders.length > currentDay){
						var tempDayNameHeader : UIComponent= this.dayNameHeaders[currentDay];
						tempDayNameHeader.y = minimizedDayNameHeaderY;
					}
					
				}
				
				currentDateOfWeek = DateUtils.dateAdd(DateUtils.DAY_OF_MONTH, 1, currentDateOfWeek);
				
				
			}
			
			if((currentCalendarState == Calendar.MONTH_VIEW) && (toState == Calendar.WEEK_VIEW)){
				this.updateDayOverridesForMonth(expandedDate);
			} else if((currentCalendarState == Calendar.WEEK_VIEW) && (toState == Calendar.DAY_VIEW)){
				this.updateDayOverridesForWeekToDay(expandedDate);
			}
		}

		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		/**
		 * @private
		 */
		override protected function onDayEvent(e:CalendarChangeEvent):void{
			// specify the 'reverse' size based on CalendarData.CalendarMeasurements
			if(e.type == CalendarChangeEvent.EXPAND_MONTH){
				// figure out which days need to be adjusted / removed from the stage 
				updateDayOverridesForMonth(e.dayToExpand.dayData.displayedDateObject);

			} else if (e.type == CalendarChangeEvent.EXPAND_DAY){
			}
			
			
			// call the super
			super.onDayEvent(e);
		}
		
		/**
		 * @private
		 * Handler function for when the dataProvider Manager has a change that affects the days
		 */ 
		override protected function onDataProviderManagerChange(e:Event):void{
			invalidateWeek();
		}				
		
		/**
		 * @private
		 * This listener function for the NextWeek event from the WeekHeader.  It will increment the week by 1.
		 * 
		 * @param e The Event instance
		 */
		protected function onNextWeek(e:Event):void{
			this.changeWeek(1);
			
			// must create a clone of the event for the redispatch because otherwise
			// the cancel event is not propogated back down; how odd
			var newEvent : CalendarChangeEvent = e.clone() as CalendarChangeEvent;
			this.dispatchEvent(newEvent);
		}	

		/**
		 * @private
		 * This listener function for the Previous Week event from the WeekHeader.  It will decrement the week by 1.
		 * 
		 * @param e The Event instance
		 */
		protected function onPreviousWeek(e:Event):void{
			this.changeWeek(-1);
			
			// must create a clone of the event for the redispatch because otherwise
			// the cancel event is not propogated back down; how odd
			var newEvent : CalendarChangeEvent = e.clone() as CalendarChangeEvent;
			this.dispatchEvent(newEvent);
		}	
		
	
	}
}