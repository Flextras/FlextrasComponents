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
	import mx.events.FlexEvent;
	import mx.events.ItemClickEvent;
	import mx.events.ListEvent;
	import mx.states.AddChild;
	import mx.states.RemoveChild;
	import mx.states.SetProperty;
	import mx.states.SetStyle;
	import mx.states.State;
	import mx.utils.ObjectUtil;
	
	/**
	 * This class represents the DAY_VIEW state of the Flextras Calendar component.  It displays the day and day header.
	 * 
	 * @author  DotComIt / Flextras
	 * @see com.flextras.calendar.Calendar
	 * @see com.flextras.calendar.defaultRenderers.DayRenderer
	 * @see com.flextras.calendar.defaultRenderers.DayHeaderRenderer
	 * 
	 */	
	public class DayDisplay extends CalendarStateBase implements IDayDisplay
	{
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------

		/**
		 *  Constructor.
		 */
		public function DayDisplay()
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
		
		/** 
		 * @private
		 */
		override protected function commitProperties():void{
			super.commitProperties();

			// if we need to recreate the Day Data; go ahead and do it here
			// day data needs to be reset for both the day and the dayHeader
			// don't reset the flag because we'll use it later to update the dayHeader and day at the same time that other associate properties
			// are being created
			// Also, if the day or dayHeader are being destroyed and recreated; re-creating creating the dayData here will automatically create 
			// those component instances w/ the updated dayData
			if(this.redoDayData == true){
				this._dayData = this.createDayData();
			}
			
			// do we need to recreate the dayHeader? 
			// this should only trigger if the dayHeaderVisible or dayHeaderRenderer has changed
			if(this.redoDayHeader == true){
				if(!this.dayHeader && (this.calendarData.dayHeaderVisible == true)){
					this.dayHeader = this.createDayHeader();
					if((this.parent) && (UIComponent(this.parent).currentState == Calendar.DAY_VIEW )){
						this.addChild(this.dayHeader);
					}
				} else if(this.dayHeader && (this.calendarData.dayHeaderVisible == false)){
					this.destroyDayHeader();

				} else if ((dayHeaderRendererChanged == true) && (this.calendarData.dayHeaderVisible == true)){
					// if the dayHeaderRenderer changed and the dayHEader should be displayed; destroy it then re-create it
					if(this.dayHeader){
						this.destroyDayHeader();
					}
					this.dayHeader = this.createDayHeader();
					if((this.parent) && (UIComponent(this.parent).currentState == Calendar.DAY_VIEW) ){
						this.addChild(this.dayHeader);
					}
					this.dayHeaderRendererChanged = false;
				}

				// swap the flags for updating the dayHeader
				this.redoDayHeader = false;
				this.redoDayHeaderData = false;
				this.dayHeaderRendererChanged = false;
				
			// if we aren't re-doing the dayHeader, but data in it may still need to be updated
			// assuming it exists
			} else if (this.dayHeader){   
				// if dayHeader is not implementing the interface; we won't be changing any data in it
				if(this.dayHeader is IDayHeader){
					if(this.redoDayHeaderData == true){
						(this.dayHeader as IDayHeader).dayHeaderData = this.createDayHeaderData();
						this.redoDayHeaderData = false;
					}
					if(this.calendarDataChanged == true ){
						// don't reset calendarDataChanged here because we may need to update the dayRenderer too
						(this.dayHeader as IDayHeader).dayHeaderData.calendarData = this.calendarData;
					}
				}
			}
			
			// if needed recreate the day; do it
			// this assumes that there will be a situation where a day is not added to the stage of this component 
			if(this.redoDays == true){
				this.removeChild(DisplayObject(this.day)); 
				this.day = this.createDayRenderer() as IDayRenderer;
				this.addChild(DisplayObject(this.day));
				this.redoDays = false;
				this.redoDayData = false;
				this.calendarDataChanged == false;
			}
			
			// if the dayData needs to be refreshed, do it here
			// it would already have been refreshed on the dayHeader
			// If it did need to be refreshed, but the day was recreated in an above block; the flag was switched to false
			if(this.redoDayData == true){
				this.day.dayData = this.dayData;
				// added a call to invalidateDayData just to be safe
				// in our default dayRenderer this is not needed as both setting the dayData and invalidateDayData do the same thing
				// basically seting a dayDataChanged value and invalidatingProperties 
				this.day.invalidateDayData();
				this.redoDayData = false;
			}

			// if the calendarData needs to be refreshed, refresh it on the day
			// it would already have been refreshed on the dayHeader
			// if the day was recreated; the day will already have refreshed data and the flag would have already been swapped
			if(this.calendarDataChanged == true ){
				this.day.calendarData = this.calendarData;
				this.calendarDataChanged = false;
			}
				
		}
		
		/** 
		 * @private
		 */
		override protected function createChildren():void{
			super.createChildren();
			
			if(this.calendarData.dayHeaderVisible == true){
				this.dayHeader = createDayHeader();
			}

			if(this.calendarData.dayRenderer){
				this.day = createDayRenderer() as IDayRenderer;
				this.addChild(this.day as DisplayObject);
			}
			
		}			

		/** 
		 * @private
		 */
		override protected function measure():void{
			
			super.measure();
			
			// no day name headers, so we should be fine resetting the height and width to 0 in this case
			var finalWidth : int = 0;
			var finalHeight : int = 0;
			
			if(this.calendarData.dayHeaderVisible == true){
				finalWidth +=  this.dayHeader.getExplicitOrMeasuredWidth();
				finalHeight += this.dayHeader.getExplicitOrMeasuredHeight();
			}				

			finalWidth +=  UIComponent(this.day).getExplicitOrMeasuredWidth();
			finalHeight += UIComponent(this.day).getExplicitOrMeasuredHeight();

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
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			

			// some variables used for positioning as we look at each child of this component
			var startX : int = 0;
			var startY : int = 0;

			// some variables used for sizing as we look at each child of this component
			var widthOffset : int = 0;
			var heightOffset : int = 0;

			if(this.calendarData.dayHeaderVisible == true){

				if((this.dayHeader)){
					// if the dayHeader should be displayed and exists; size it to the full width of the component, and give it it's default height
					this.dayHeader.setActualSize(unscaledWidth,this.dayHeader.getExplicitOrMeasuredHeight());

					// position the dayHeader; most likely to 0,0
					this.dayHeader.move(startX, startY);
					// increment the startY value so next component (The Day) shows up underneath the dayHEader, not over it
					startY += this.dayHeader.height;
					// increment the heightOffset value so next component (The Day) expands to fill the component
					heightOffset += this.dayHeader.height ;
				}
			}
			
			// we don't want to resize or move if we're in the WEEK_VIEW or MONTH_VIEW state
			if((this.day)){
				var day : UIComponent = this.day as UIComponent;

				overrideDayWidthDay.value = unscaledWidth;
				overrideDayHeightDay.value = unscaledHeight-heightOffset;
				overrideDayXDay.value = startX;
				overrideDayYDay.value = startY;
				
				// this block of code is really only here for the initial set up phase
				// if the paren'ts initial setup is the day state; the size of the day will cover the dayHeader
				// as the month state values are 
				if((this.parent) && 
					(UIComponent(this.parent).currentState == Calendar.DAY_VIEW) && 
					(overrideDayHeightDay.value != day.height)){
					// Size the day to the full width of the component, and give it the full height, minus the heightOffset for the dayheader
					// if no dayHeader, the heightOffset will most likely be zero
//					day.setActualSize(unscaledWidth,unscaledHeight-heightOffset);
					day.width = unscaledWidth;
					day.height = unscaledHeight-heightOffset;
					// position the day
					day.move(startX, startY);
										
				} 
			}
		
		}		

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------		

		//----------------------------------
		//  overrideAddDayHeader
		//----------------------------------
		/**
		 * @private
		 */
		private var _overrideAddDayHeader : AddChild;

		/**
		 * @private 
		 * An internal hook to the override that adds the day Header
		 */
		protected function get overrideAddDayHeader():AddChild
		{
			return _overrideAddDayHeader;
		}

		/**
		 * @private
		 */
		protected function set overrideAddDayHeader(value:AddChild):void
		{
			_overrideAddDayHeader = value;
		}

		//----------------------------------
		//  overrideDayHeightDay
		//----------------------------------
		/**
		 * @private
		 */
		private var _overrideDayHeightDay : SetPropertyExposed;

		/**
		 * @private 
		 * An internal hook to the Day state day.height override 
		 */
		protected function get overrideDayHeightDay():SetPropertyExposed
		{
			return _overrideDayHeightDay;
		}

		/**
		 * @private
		 */
		protected function set overrideDayHeightDay(value:SetPropertyExposed):void
		{
			_overrideDayHeightDay = value;
		}

		//----------------------------------
		//  overrideDayWidthDay
		//----------------------------------
		/**
		 * @private
		 */
		private var _overrideDayWidthDay : SetProperty;

		/**
		 * @private 
		 * An internal hook to the Day state day.width override 
		 */
		protected function get overrideDayWidthDay():SetProperty
		{
			return _overrideDayWidthDay;
		}

		/**
		 * @private
		 */
		protected function set overrideDayWidthDay(value:SetProperty):void
		{
			_overrideDayWidthDay = value;
		}

		//----------------------------------
		//  overrideDayXDay
		//----------------------------------
		/**
		 * @private
		 */
		private var _overrideDayXDay : SetPropertyExposed;

		/**
		 * @private 
		 * An internal hook to the Day state day.X override 
		 */
		protected function get overrideDayXDay():SetPropertyExposed
		{
			return _overrideDayXDay;
		}

		/**
		 * @private
		 */
		protected function set overrideDayXDay(value:SetPropertyExposed):void
		{
			_overrideDayXDay = value;
		}

		//----------------------------------
		//  overrideDayYDay
		//----------------------------------
		/**
		 * @private
		 */
		private var _overrideDayYDay : SetPropertyExposed;

		/**
		 * @private 
		 * An internal hook to the Day state day.Y override 
		 */
		protected function get overrideDayYDay():SetPropertyExposed
		{
			return _overrideDayYDay;
		}

		/**
		 * @private
		 */
		protected function set overrideDayYDay(value:SetPropertyExposed):void
		{
			_overrideDayYDay = value;
		}

		//----------------------------------
		//  redoDayHeader
		//----------------------------------
		/**
		 * @private
		 */
		private var _redoDayHeader : Boolean = false;

		/**
		 * @private 
		 * Internal variable for figuring out when the DayHeader needs to change
		 * flag that tells us to recreate or destroy the dayHeader 
		 */
		protected function get redoDayHeader():Boolean
		{
			return _redoDayHeader;
		}

		/**
		 * @private
		 */
		protected function set redoDayHeader(value:Boolean):void
		{
			_redoDayHeader = value;
		}

		//----------------------------------
		//  redoDayHeaderData
		//----------------------------------
		/**
		 * @private
		 */
		private var _redoDayHeaderData : Boolean = false;

		/**
		 * @private
		 * flag that tells if the dayHeaderData needs tob e refreshed
		 */
		protected function get redoDayHeaderData():Boolean
		{
			return _redoDayHeaderData;
		}

		/**
		 * @private
		 */
		protected function set redoDayHeaderData(value:Boolean):void
		{
			_redoDayHeaderData = value;
		}


		//----------------------------------
		//  dayHeaderRendererChanged
		//----------------------------------
		/**
		 * @private
		 */
		private var _dayHeaderRendererChanged : Boolean = false;

		/**
		 * @private
		 */
		protected function get dayHeaderRendererChanged():Boolean
		{
			return _dayHeaderRendererChanged;
		}

		/**
		 * @private
		 */
		protected function set dayHeaderRendererChanged(value:Boolean):void
		{
			_dayHeaderRendererChanged = value;
		}


		//----------------------------------
		//  dayHeader
		//----------------------------------
		/**
		 * @private
		 */
		private var _dayHeader : UIComponent 

		/**
		 * This is an internal reference to the instance of the dayHeader.  
		 */
		protected function get dayHeader():UIComponent
		{
			return _dayHeader;
		}

		/**
		 * @private
		 */
		protected function set dayHeader(value:UIComponent):void
		{
			_dayHeader = value;
			this.dispatchEvent(new Event('dayHeaderObjectChanged'));
			this.dispatchEvent(new Event('objectArrayForTransitionsChanged'));
		}

		//----------------------------------
		//  day
		//----------------------------------
		/**
		 * @private
		 */
		private var _day : IDayRenderer;

		/**
		 * This is an internal reference to the instance of the dayRenderer.  
		 */
		protected function get day():IDayRenderer
		{
			return _day;
		}

		/**
		 * @private
		 */
		protected function set day(value:IDayRenderer):void
		{
			_day = value;
			this.dispatchEvent(new Event('objectArrayForTransitionsChanged'));
			
		}

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------		
		
		//----------------------------------
		//  currentState
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function set currentState(value:String):void{
			if(value == ''){
				value = Calendar.DAY_VIEW;
			}
			super.currentState = value;
			
		}

		//----------------------------------
		//  calendarData
		//----------------------------------
//		* @copy com.flextras.calendar.ICalendarData#calendarData
		/**
		 * @inheritDoc
		 */
		override public function get calendarData():ICalendarDataVO
		{
			return super.calendarData;
		}
		
		/**
		 * @private
		 * Value we care about from the calendarData that relate to changing this component: 
		 *   dataProviderManager:		to get the data to display in the day
		 *   dayNames:					a single item from this passed into dayHeader; and updated as paging through days
		 *   dayRenderer: 				create and destroy the current day
		 *   displayedYear: 			need to change data on day if this changes
		 *   displayedMonth:			need to change data day if this changes
		 *   displayedDate:				update dayHeaderData and dayData
		 *   dayHeaderVisible:			either create or destroy dayHeader
		 *   dayHeaderRenderer:			destroy then re-create dayHeader
		 *   monthNames: 				update dayHeader info if changed
		 * 	 monthSymbol: 				update dayHeader info if changed
		 */
		override public function set calendarData(value:ICalendarDataVO):void
		{

			if((ObjectUtil.compare(this.calendarData.dayNames,value.dayNames) != 0) || 
				(this.calendarData.monthNames != value.monthNames) ||
				(this.calendarData.monthSymbol != value.monthSymbol)){
				this.redoDayHeaderData = true;
			}

			if((ObjectUtil.compare(this.calendarData.dayRenderer,value.dayRenderer) != 0) ){
				this.redoDayHeaderData = true;
			}

			
			if( (this.calendarData.dayHeaderVisible != value.dayHeaderVisible) || 
				(ObjectUtil.compare(this.calendarData.dayHeaderRenderer,value.dayHeaderRenderer) != 0)){
				this.redoDayHeader = true;
				
				if((ObjectUtil.compare(this.calendarData.dayHeaderRenderer,value.dayHeaderRenderer) != 0)){
					this.dayHeaderRendererChanged = true;
				}
			}

			if( (this.calendarData.displayedYear != value.displayedYear) || 
				(this.calendarData.displayedMonth != value.displayedMonth) || 
				(this.calendarData.displayedDate != value.displayedDate) ){
				this.redoDayData = true;
				this.redoDayHeaderData = true;
			}

			super.calendarData = value;
			this.calendarDataChanged = true;
			this.invalidateProperties();

		}

		//----------------------------------
		//  dayData
		//----------------------------------
		/**
		 * @private 
		 */
		private var _dayData : IDayDataVO;
		
		/**
		 * @private 
		 * Helper function for retrieving the dayData to be passed into the day.  If _dayData is null, it will create it
		 */
		protected function get dayData (): IDayDataVO{
			if(!this._dayData){
				this._dayData = this.createDayData();
			}			
			return this._dayData
		}

		
		//----------------------------------
		//  minimizedDayXMonth
		//----------------------------------
		/**
		 * @private 
		 */
		private var _minimizedDayXMonth: int = 0;
		/**
		 * @private
		 * an internal variable for keeping track of the day's x location in the month display when the component is in the expanded day state
		 * primarily used for sizing purposes in updateDisplayList if not in DAY_VIEW state
		 * @see #setupStateChange()
		 */ 
		protected function get minimizedDayXMonth():int{
			return _minimizedDayXMonth;
		}
		
		/**
		 * @private
		 */
		protected function set minimizedDayXMonth(value:int):void{
			this._minimizedDayXMonth = value;
		}
		
		//----------------------------------
		//  minimizedDayYMonth
		//----------------------------------
		/**
		 * @private 
		 */
		private var _minimizedDayYMonth: int = 0;
		/**
		 * @private
		 * an internal variable for keeping track of the day's y location in the month view state when the component is in the expanded day state
		 * primarily used for sizing purposes in updateDisplayList if not in DAY_VIEW state
		 * @see #setupStateChange()
		 */ 
		protected function get minimizedDayYMonth():int{
			return _minimizedDayYMonth;
		}
		
		/**
		 * @private
		 */
		protected function set minimizedDayYMonth(value:int):void{
			this._minimizedDayYMonth = value;
		}

		
		//----------------------------------
		//  minimizedDayXWeek
		//----------------------------------
		/**
		 * @private 
		 */
		private var _minimizedDayXWeek: int = 0;
		/**
		 * @private
		 * an internal variable for keeping track of the day's x location in the week display when the component is in the expanded day state
		 * primarily used for sizing purposes in updateDisplayList if not in DAY_VIEW state
		 * @see #setupStateChange()
		 */ 
		protected function get minimizedDayXWeek():int{
			return _minimizedDayXWeek;
		}
		
		/**
		 * @private
		 */
		protected function set minimizedDayXWeek(value:int):void{
			this._minimizedDayXWeek = value;
		}
		
		//----------------------------------
		//  minimizedDayYWeek
		//----------------------------------
		/**
		 * @private 
		 */
		private var _minimizedDayYWeek : int = 0;
		/**
		 * @private
		 * an internal variable for keeping track of the day's y location in the week view state when the component is in the expanded day state
		 * primarily used for sizing purposes in updateDisplayList if not in DAY_VIEW state
		 * @see #setupStateChange()
		 */ 
		protected function get minimizedDayYWeek():int{
			return _minimizedDayYWeek;
		}
		
		/**
		 * @private
		 */
		protected function set minimizedDayYWeek(value:int):void{
			this._minimizedDayYWeek = value;
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
			if(this.dayHeader){
				resultArray.push(this.dayHeader);
			}
			if(this.day){
				resultArray.push(this.day);
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
		 * function to encapsualte calculating the month Y values for the day in question 
		 */
		protected function calculateMinimizedDayYMonth(date:Date):int{
			var weekOfMonth : int = DateUtilsExtension.weekOfMonth(date, this.calendarData.firstDayOfWeek);
			return this.calendarData.calendarMeasurements.monthHeaderHeight + (this.calendarData.calendarMeasurements.monthDayHeight * (weekOfMonth-1));
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function changeDay(value:int=1):void
		{
			
			// if the change value is 0; change nothing
			if(value == 0){
				return;
			}

			var currentDate : Date = new Date(this.calendarData.displayedYear, this.calendarData.displayedMonth, this.calendarData.displayedDate);
			var newDate : Date = DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,value,currentDate);

			updateOverridesForDateChange(currentDate, newDate);

			// update the calendarData 
			this.calendarData.displayedYear = newDate.fullYear;
			this.calendarData.displayedMonth = newDate.month;
			this.calendarData.displayedDate = newDate.date;
			
			this.invalidateDay();

		}
		
		//----------------------------------
		//  createDayHeader
		//----------------------------------
		/**
		 * @private
		 * Helper function to create the day header.
		 */
		protected function createDayHeader():UIComponent{
			var tempdayHeader : UIComponent = this.calendarData.dayHeaderRenderer.newInstance() as UIComponent;
			if(tempdayHeader  is IDayHeader){
				(tempdayHeader as IDayHeader).dayHeaderData = this.createDayHeaderData();
			}
			tempdayHeader.addEventListener(CalendarChangeEvent.NEXT_DAY, onNextDay);
			tempdayHeader.addEventListener(CalendarChangeEvent.PREVIOUS_DAY, onPreviousDay);

			// create the appropriate dayHeader overrides 
			overrideAddDayHeader = new AddChild(this, tempdayHeader, 'firstChild');
			this.dayStateOverrides.push(overrideAddDayHeader);
//			overrideRemoveDayHeader = new RemoveChild(tempdayHeader);
//			this.monthStateOverrides.push(overrideRemoveDayHeader);
			
			return tempdayHeader;
		}

		
		//----------------------------------
		//  createDayData
		//----------------------------------
		/**
		 * @private
		 * Helper function for creating the day data object
		 */
		protected function createDayData():IDayDataVO{
			var todayDate : Date = new Date(this.calendarData.displayedYear, this.calendarData.displayedMonth, this.calendarData.displayedDate);
			var dp : Object;
			if(this.calendarData.dataProviderManager){
				dp = this.calendarData.dataProviderManager.getData(todayDate)
			}
			var dayData : IDayDataVO = new DayDataVO(this.calendarData.displayedDate, dp,todayDate );
			return dayData;
		}
		
		//----------------------------------
		//  createDayHeaderData
		//----------------------------------
		/**
		 * @private
		 * Helper function for creating the day header data object
		 */
		protected function createDayHeaderData():IDayHeaderDataVO{
			var monthName : Object;
			if(this.calendarData.displayedMonth <= this.calendarData.monthNames.length-1){
				monthName = this.calendarData.monthNames[this.calendarData.displayedMonth];
			} else {
				monthName = '';
			}

			var dayName : Object;
			// figure out the day of week 
			var dayOfWeek : int = this.dayData.displayedDateObject.day;
			dayName = this.calendarData.dayNames[dayOfWeek];
			
			return  new DayHeaderDataVO(this.dayData , dayName, this.calendarData.displayedMonth,this.calendarData.displayedYear, monthName, this.calendarData.monthSymbol,this.calendarData);
			
		}		

		
		//----------------------------------
		//  createDayNameHeadersArray
		//----------------------------------
		/**
		 * @private
		 * Helper function to create the day header.
		 */
		override protected function createDayNameHeadersArray():void{
			// don't create day name headers in the day view
		}
		//----------------------------------
		//  createDayRenderer
		//----------------------------------
		/**
		 * @private
		 * Helper function to create the day renderer.
		 */
		protected function createDayRenderer():Object{
			var nextDayRenderer : DisplayObject  = this.calendarData.dayRenderer.newInstance();

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
				
				(nextDayRenderer as IDayRenderer).dayData = this.dayData;
				(nextDayRenderer as IDayRenderer).calendarData = this.calendarData;
			}
			
			// deal with the overrides for sizing and positioning of the day 
			// Will be used when switching between DAY_VIEW and MONTH_VIEW 
			var y : int =0;
			var height : int = this.height
			if(this.dayHeader){
				y = this.dayHeader.height;
				height = this.height - this.dayHeader.height
			}

			overrideDayWidthDay = new SetProperty(nextDayRenderer,'width', this.width);
			overrideDayHeightDay= new SetPropertyExposed(nextDayRenderer,'height', height) ;
			overrideDayXDay = new SetPropertyExposed(nextDayRenderer,'x', 0);
			overrideDayYDay = new SetPropertyExposed(nextDayRenderer,'y', y);
			this.dayStateOverrides.push(overrideDayHeightDay, overrideDayWidthDay, overrideDayXDay, overrideDayYDay);
			
			return nextDayRenderer;
		}

		
		//----------------------------------
		//  dateToDayRenderer
		//----------------------------------
		// this method must be override i the dayDisplay since it doesn't use dayRenderersInUse
		/** 
		 * @inheritDoc
		 */
		override public function dateToDayRenderer(date:Date):IDayRenderer{
			var result : IDayRenderer;
			
			if((date.fullYear == this.dayData.displayedDateObject.fullYear) && 
				(date.month == this.dayData.displayedDateObject.month) &&
				(date.date == this.dayData.displayedDateObject.date) 
				){
				result = this.day;
			}
			return result;
		}		
		
		//----------------------------------
		//  destroyDayHeader
		//----------------------------------
		/**
		 * @private
		 * Helper function to destroy the day header.
		 */
		protected function destroyDayHeader():void{
			this.dayHeader.removeEventListener(CalendarChangeEvent.NEXT_DAY, onNextDay);
			this.dayHeader.removeEventListener(CalendarChangeEvent.PREVIOUS_DAY, onPreviousDay);
			if(this.dayHeader.parent){
				this.removeChild(this.dayHeader);
			}
			
			// remove from overrides 
			
			this.dayStateOverrides.splice(this.dayStateOverrides.indexOf(this.overrideAddDayHeader),1);
				
			// remove the appropriate dayHeader overrides 
			this.dayHeader = null;
			overrideAddDayHeader = null;
			
		}


		//----------------------------------
		//  invalidateDay
		//----------------------------------
		/**
		 * @inheritDoc
		 */
		public function invalidateDay():void{
			this.redoDayData = true;
			this.redoDayHeaderData = true;
			this.invalidateProperties();
		}	
		
		
		//----------------------------------
		//  itemToDayRenderer
		//----------------------------------
		// this method must be override i the dayDisplay since it doesn't use dayRenderersInUse
		/** 
		 * This method takes an object and finds the dayRenderer instance that is currently displaying the item.
		 */
		override public function itemToDayRenderer(data:Object):IDayRenderer{
			var result : IDayRenderer;
			// find the dataProvider for the day using the dataProviderDictionary 
			var date : Date = this.calendarData.dataProviderManager.itemToDate(data);
			
			if(date == this.dayData.displayedDateObject){
				result = this.day;
			}
			return result;
		}		
		
		/**
		 * @inheritDoc
		 */
		public function setupReverseStateChange(toState : String = '', expandedDate : Date = null ):void{
			if((toState  == Calendar.WEEK_VIEW )){
				this.overrideDayYDay.oldValue = this.minimizedDayYWeek;
				this.overrideDayHeightDay.oldValue = this.calendarData.calendarMeasurements.weekDayHeight;
				
			} else if(toState  == Calendar.MONTH_VIEW){
				// if leadingTrailingDaysVisible is true; and the day being reversed is not in the current month 
				// then we need to re-calculate the minimizedDayYMonth
				if((this.calendarData.leadingTrailingDaysVisible == true) && (expandedDate)){
					this.minimizedDayYMonth  = calculateMinimizedDayYMonth(expandedDate);
				}

				this.overrideDayYDay.oldValue = this.minimizedDayYMonth;
				this.overrideDayHeightDay.oldValue = this.calendarData.calendarMeasurements.monthDayHeight;
				
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function setupStateChange(minimizedDayX : int, minimizedDayY : int, expandedDate : Date = null, 
										 repositionDay : Boolean = false, fromState : String = ''):void{

			
			// the day inside the DayDisplay is getting removed during the initial state change if using * to * state changes
			// I'm not sure why; but that is the way it is
			// as such we need to make sure that it is addeed back in if appropriate 
			if(!(this.day as UIComponent).parent){
				this.addChild(this.day as DisplayObject);
			}

			
			if(!expandedDate){
				expandedDate = new Date(this.calendarData.displayedYear, this.calendarData.displayedMonth, this.calendarData.displayedDate);
			}
			
			// modify the overrides for sizing and positioning of the day 
			// Will be used when switching between DAY_VIEW and MONTH_VIEW 
//			overrideDayXMonth.value = minimizedDayX;
			this.minimizedDayXMonth = minimizedDayX;
			this.minimizedDayXWeek = minimizedDayX;
//			overrideDayYMonth.value = minimizedDayY;

			if((fromState == Calendar.WEEK_VIEW )){
				// even though we are changing to the month view; 
				// calculate the minimizedDayYMonth value for later state change purposes
//				var weekOfMonth : int = DateUtilsExtension.weekOfMonth(expandedDate , this.calendarData.firstDayOfWeek);
//				this.minimizedDayYMonth = this.calendarData.calendarMeasurements.monthHeaderHeight + (this.calendarData.calendarMeasurements.monthDayHeight * (weekOfMonth-1));
				this.minimizedDayYMonth  = calculateMinimizedDayYMonth(expandedDate);
				
				this.minimizedDayYWeek = minimizedDayY;
				
			} else if(fromState == Calendar.MONTH_VIEW){
				this.minimizedDayYMonth = minimizedDayY;
				
				// even though we are changing to the month view; calculate to the minmizedDayY for the week 
				// just in casewe need it for later state change purpsoes
				this.minimizedDayYWeek = this.calendarData.calendarMeasurements.weekHeaderHeight;

			}


			
			if(repositionDay == true){

				if((fromState == Calendar.WEEK_VIEW )){
					this.day.width = this.calendarData.calendarMeasurements.weekDayWidth;
					this.day.height = this.calendarData.calendarMeasurements.weekDayHeight;
					
				} else if(fromState == Calendar.MONTH_VIEW){
					this.day.width = this.calendarData.calendarMeasurements.monthDayWidth;
					this.day.height = this.calendarData.calendarMeasurements.monthDayHeight;

				}
				
				
				this.day.move(minimizedDayX,minimizedDayY);
			}
			
			
		}


		/**
		 * @inheritDoc
		 */
		public function updateOverridesForDateChange(currentDate : Date, newDate : Date):void{
			// code to reset the minimizedWidth, minimizedHeight, minimizedX, and minimizedY 
			// if year changed or month changed 
			//  calculate the new day height 
			//  find out number of weeks in the new month then newMinimizedHeight = (full height - height of header)/NumberOfWeeks
			if((currentDate.fullYear != newDate.fullYear) || (currentDate.month != newDate.month)){
				
				// a Date object referencing the first date of the month; used to calculate the days in the first week of the month
				// and thereby the positioning of headers and days 
				var firstDateOfMonth : Date = new Date(newDate.fullYear,newDate.month,1)
				
				// find out how many weeks there are in the month
				// it is either going to be 4 or 5 or 6
				var weeksInMonth : int = DateUtilsExtension.weeksInMonth(firstDateOfMonth, this.calendarData.firstDayOfWeek);
				
				this.minimizedDayHeight = Math.floor( (this.height - this.calendarData.calendarMeasurements.monthHeaderHeight)/weeksInMonth);
				
				this.overrideDayHeightDay.oldValue = this.minimizedDayHeight;
				this.calendarData.calendarMeasurements.monthDayHeight = this.minimizedDayHeight;
				
			}
			
			// calculate the new minimizedX and minimizedY values
			// X = (minimizedWidth * Day of week)
			// y = (WeekThisDayIsIn) * MinimizedHeight;
			
			// in theory the two formulas will calculate the same number 
			this.minimizedDayXMonth = (this.calendarData.calendarMeasurements.monthDayWidth * (newDate.day));
			this.minimizedDayXWeek = (this.calendarData.calendarMeasurements.weekDayWidth * (newDate.day));
			this.overrideDayXDay.oldValue = this.minimizedDayXMonth;
			
			//			adding week of month to accomodate for the fact that day's don't overlap in month view; so height of previous rows does not equate position exactly
//			var weekOfMonth : int = DateUtilsExtension.weekOfMonth(newDate , this.calendarData.firstDayOfWeek);
			
//			this.minimizedDayYMonth = this.calendarData.calendarMeasurements.monthHeaderHeight + (this.calendarData.calendarMeasurements.monthDayHeight * (weekOfMonth-1));
			this.minimizedDayYMonth  = calculateMinimizedDayYMonth(newDate);
			// minimizedDayYWeek won't be changing no matter now many times the day changes in the day state 
			// but we do want to store that original value at some point; probably in setupStateChange 
			this.overrideDayYDay.oldValue = this.minimizedDayYMonth;
			
		}		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private 
		 * Handler function for when the dataProvider Manager has a change that affects the days
		 */ 
		override protected function onDataProviderManagerChange(e:Event):void{
			invalidateDay();
		}		
		
		/**
		 * @private 
		 */
		override protected function onDayClickEvent(e:CalendarMouseEvent):void{
			// if the user did not click on an itemRenderer we should not do any selection work
			// do that by checking the e.itemRenderer 
			// one example of this may be clicking a scroll bar in a renderer 
			if(e.itemRenderer){
				e.selectedItems = e.list.selectedItems;
			}

			// re-dispatch the event for folks on the outside
			// don't need o redispatch this because it bubbles 
//			var newEvent : CalendarMouseEvent = e.clone() as CalendarMouseEvent;
//			this.dispatchEvent(newEvent);
			
			// note: Do not call super; which does a lot of stuff for allowMultipleSelection which is not needed when there is only one day

		}

		/**
		 * @private 
		 */
		override protected function onDayEvent(e:CalendarChangeEvent):void{
			// specify the 'reverse' size based on CalendarData.CalendarMeasurements
			if(e.type == CalendarChangeEvent.EXPAND_MONTH){
//				this.overrideDayWidthMonth.value = this.calendarData.calendarMeasurements.monthDayWidth;
//				this.overrideDayHeightMonth.value = this.calendarData.calendarMeasurements.monthDayHeight;
				this.overrideDayYDay.oldValue = this.minimizedDayYMonth;
				this.overrideDayXDay.oldValue = this.minimizedDayXMonth;
			} else if (e.type == CalendarChangeEvent.EXPAND_WEEK){
//				this.overrideDayWidthMonth.value = this.calendarData.calendarMeasurements.weekDayWidth;
//				this.overrideDayHeightMonth.value = this.calendarData.calendarMeasurements.weekDayHeight;
				this.overrideDayYDay.oldValue = this.minimizedDayYWeek;
				this.overrideDayXDay.oldValue = this.minimizedDayXWeek;
			}
			
			// call the super
			super.onDayEvent(e);
		}
		
		/**
		 * @private 
		 * This listener function for the NextDay event from the MonthHeader.  It will increment the month by 1.
		 * 
		 * @param e The Event instance
		 */
		protected function onNextDay(e:Event):void{
			this.changeDay(1);

			// must create a clone of the event for the redispatch because otherwise
			// the cancel event is not propogated back down; how odd
			var newEvent : CalendarChangeEvent = e.clone() as CalendarChangeEvent;
			this.dispatchEvent(newEvent);
			
		}	

		/**
		 * @private 
		 * This listener function for the previousDay event from the MonthHeader.  It will increment the month by 1.
		 * 
		 * @param e The Event instance
		 */
		protected function onPreviousDay(e:Event):void{
			this.changeDay(-1);

			// must create a clone of the event for the redispatch because otherwise
			// the cancel event is not propogated back down; how odd
			var newEvent : CalendarChangeEvent = e.clone() as CalendarChangeEvent;
			this.dispatchEvent(newEvent);

		}
	
	}
}