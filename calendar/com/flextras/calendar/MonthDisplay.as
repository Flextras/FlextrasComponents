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
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.Container;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.effects.Effect;
	import mx.effects.IEffect;
	import mx.effects.effectClasses.PropertyChanges;
	import mx.events.EffectEvent;
	import mx.events.ListEvent;
	import mx.events.ResizeEvent;
	import mx.utils.ObjectUtil;

	use namespace mx_internal;

	// Month Change effect metaData 
	include "inc/MonthChangeEffectMetaData.as";

	/**
	 * This class represents the MONTH_VIEW state of the Flextras Calendar component.  It displays the days that make up the month, the month header, and the day name headers.  
	 * 
	 * @author DotComIt / Flextras
	 * @see com.flextras.calendar.Calendar
	 * 
	 */	
	public class MonthDisplay extends CalendarStateBase implements IMonthDisplay
	{

	    //--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------

		/**
		 *  Constructor.
		 */
		public function MonthDisplay()
		{
			//TODO: implement function
			super();
			
			this.setStyle("backgroundColor","0xFFFFFF");

			this.addEventListener(ResizeEvent.RESIZE, onResize);

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

		if((this.parseDataProvider == true) && (this.calendarData.dataProviderManager)){

			var startDate : Date = new Date(this.calendarData.displayedYear, this.calendarData.displayedMonth, 1)
			var endDate : Date = new Date(this.calendarData.displayedYear, this.calendarData.displayedMonth, DateUtils.daysInMonth(startDate));
			
			this.calendarData.dataProviderManager.parseDateRange(startDate, endDate);
			
			this.parseDataProvider = false;
				
		}
			
		// used in both redoDayRenderer code block and 
		// redoDayData code block
		var tempDayRenderer : IDayRenderer;		

		// based on displayMonth and displayYear figure out how many days we are displaying here
		// Create, or reuse the dayRenderers
		// probably need some dayRenderersBeingUsed array and a dayRenderersFree array
		// redoDayRenderers is not reset here; it is reset in updateDisplayList for display purposes 
		if((this.redoDayRenderers == true) && (this.calendarData.dataProviderManager)){


			// how many days do we need to create?
			// if leadingTrailingDaysVisibible == false; then we create the days in month
			// if leadingTrailingDaysVisible == true then we create the number of weeks the month is spread out over x 7
			var daysToCreate : int = calculateDaysToProcess();
			
			
			// Since we are most likely changing the month or year here, we need to refresh all the dataProviders for all dayRenderers
			var numberOfDaysToBeRefreshed : int = this.dayRenderersInUse.length;

			
			// loop counter when looping over renderers
			var numRenderers : int;
			
			/// temporary storage for the dataPRovider
			var dp : Object ;

			// if daysToCreate is equal to daysRenderersInUse.length do nothing
			// if daysToCreate is greater than daysRenderersInUse.length remove extra children from stage and put them in dayRenderersFree
			// if daysToCreate is less than daysRenderersInUse.length move free renderers from dayRenderersFree to dayRenderersInUse or create more 
			if(daysToCreate < this.dayRenderersInUse.length){
				// if daysToCreate is less than daysRenderersInUse.length remove extra children from stage and put them in dayRenderersFree
				// to test this move from any month with 31 days to a month w/ 30 or less days; July 09 to June 09 for example
				while(daysToCreate != this.dayRenderersInUse.length){
					tempDayRenderer = this.dayRenderersInUse.removeItemAt(this.dayRenderersInUse.length-1) as IDayRenderer;

					if(this.runMonthChangeEffectNextUpdate == true){
						this.cachedMonthChangeEffect.targets = this.cachedMonthChangeEffect.targets.concat([tempDayRenderer]);
						this.cachedMonthChangeEffect.captureMoreStartValues([tempDayRenderer] );
					}
					this.removeChild(DisplayObject(tempDayRenderer));
					this.dayRenderersFree.push(tempDayRenderer);

				}

				// if we removed items, shrink the number of days to be refreshed
				numberOfDaysToBeRefreshed = this.dayRenderersInUse.length;

				
			} else if (daysToCreate > this.dayRenderersInUse.length){
				// if daysToCreate is greater than daysRenderersInUse.length move free renderers from dayRenderersFree to dayRenderersInUse or create more 
				
				// if if leadingTrailingDaysVisible is changed and we're in this block; we are probably creating the leading and trailing days
				// there are three values we care about creating:
				// the missing days from the first displayed week that are in the previous month
				// the missing days from the last displayed week that are in the next month 
				// the missing days from the current month

/*				var numOfLeadingDays : int = 0;
				var numOfTrailingDays : int = 0;
				var numOfMissingMonthDays : int = 0;
				
				if(this.calendarData.leadingTrailingDaysVisible == true){
					// the missing days from the first displayed week that are in the previous month
					var firstDateOfMonth : Date = DateUtilsExtension.firstDateOfWeek(new Date(this.calendarData.displayedYear,this.calendarData.displayedMonth, 1),this.calendarData.firstDayOfWeek )
					numOfLeadingDays = (7 - DateUtilsExtension.daysInFirstWeekOfMonth(firstDateOfMonth, this.calendarData.firstDayOfWeek ) ); 
					
					// the missing days from the last displayed week that are in the next month 
					
					var firstDateOfNextMonth : Date = DateUtils.dateAdd( DateUtils.MONTH, 1, firstDateOfMonth );
					numOfTrailingDays = (7 - DateUtilsExtension.daysInFirstWeekOfMonth(firstDateOfNextMonth, this.calendarData.firstDayOfWeek ) );
				} else {
					numOfLeadingDays = 0;
					numOfTrailingDays = 0 ;
				}
				
				
				// the missing days from the current month
				numOfMissingMonthDays  = daysToCreate - numOfLeadingDays - numOfTrailingDays - this.dayRenderersInUse.length;
*/				
				
				for (numRenderers = this.dayRenderersInUse.length; numRenderers < daysToCreate ; numRenderers++) { 
					// move from the current number of renderers ( this.dayRenderersInUse.length ) to the total number of renderers we need ( daysToCreate )

					// if leadingTrailingDaysVisible is changed and we are in here; then we are creaing days before and after the 
					// days of the month; but at this point we're not sure what
					if(this.calendarData.leadingTrailingDaysVisible == false) {
					dp = this.calendarData.dataProviderManager.getData(new Date(this.calendarData.displayedYear, this.calendarData.displayedMonth, numRenderers+1)); 
					} else {
						dp = new Object();
					}
					tempDayRenderer = getFreeOrNewDayRenderer(numRenderers+1, this.calendarData.displayedMonth, this.calendarData.displayedYear,  dp  ) as IDayRenderer;
					// for effect purposes
					if(this.runMonthChangeEffectNextUpdate == true){
						this.cachedMonthChangeEffect.targets = this.cachedMonthChangeEffect.targets.concat([tempDayRenderer]);
						this.cachedMonthChangeEffect.captureMoreStartValues([tempDayRenderer] );
					}
					this.addChild(DisplayObject(tempDayRenderer));
					
					this.dayRenderersInUse.addItem(tempDayRenderer);

				}
				
				// if leadingTrailingDaysVisible has changed; who knows what day is where; so refresh them all 
				if(this.calendarData.leadingTrailingDaysVisible == true) {
					numberOfDaysToBeRefreshed = this.dayRenderersInUse.length;
				} else {
					// remove sort on dayRenderersInUse so they get processed in order 
					this.dayRenderersInUse.sort = null;
					this.dayRenderersInUse.refresh();
					
					
				}
				
				
			}
			
			var dateCounter : Date;
			if(numberOfDaysToBeRefreshed == this.dayRenderersInUse.length){
				// if number of days to be refreshed is equal to number of dayRenderersInUse then we are refreshing all the days
				// the dateCounter should start at either 
				if(this.calendarData.leadingTrailingDaysVisible == true) {
					// in this condition we're going to update data for all days in dayRenderersInUse Array
					dateCounter = DateUtilsExtension.firstDateOfWeek(new Date(this.calendarData.displayedYear,this.calendarData.displayedMonth, 1),this.calendarData.firstDayOfWeek )
				} else {
					dateCounter = new Date(this.calendarData.displayedYear,this.calendarData.displayedMonth, 1);
				}
				
				// JH DotComIt 7/29/2011 
				// remove sort on dayRenderersInUse so they get processed in order 
				// this is causing an issue when moving from to a month w/ the same number of days
				// and using a custom itemRenderer 
				// (Example July 2011 to August 2011 )
				// it would loop over the days in the next section modify the dayData and the sort would resort the days 
				// causing days to be updated sporadically
				// I have no idea why this issue is not replicatable w/ our sample dayRenderers.  A customer discovered it.
				this.dayRenderersInUse.sort = null;
				this.dayRenderersInUse.refresh();
				
			} else {
				// we aren't refreshing everything; just a few items at the beginning 
				dateCounter = new Date(this.calendarData.displayedYear,this.calendarData.displayedMonth, 1);
			}



			// refresh the dataProvider on the dayRenderers
			for (numRenderers = 0; numRenderers < numberOfDaysToBeRefreshed ; numRenderers++) { 
				tempDayRenderer = this.dayRenderersInUse.getItemAt(numRenderers) as IDayRenderer;

				// move from the current number of renderers ( this.dayRenderersInUse.length ) to the total number of renderers we need ( daysToCreate )
//				dp = this.calendarData.dataProviderManager.getData(new Date(this.calendarData.displayedYear, this.calendarData.displayedMonth, numRenderers+1));
				dp = this.calendarData.dataProviderManager.getData(dateCounter);
								

				// why am I updated this stuff this way as opposed to replacing dayData
				// I changed it to just create a new dayData object and then replace the dayData object since this is the same approach
				// used in week and day Displays.  
//				tempDayRenderer.dayData.dataProvider = dp;
//				tempDayRenderer.dayData.date = numRenderers+1;
//				tempDayRenderer.dayData.date = dateCounter.date;
//				tempDayRenderer.dayData.displayedDateObject = new Date(this.calendarData.displayedYear, this.calendarData.displayedMonth, tempDayRenderer.dayData.date);
//				tempDayRenderer.dayData.displayedDateObject = dateCounter;

				var dayData : DayDataVO = new DayDataVO(dateCounter.date,dp,dateCounter);
				tempDayRenderer.dayData = dayData;
				tempDayRenderer.invalidateDayData();
				// increment dateCounter by 1
				dateCounter = DateUtils.dateAdd(DateUtils.DAY_OF_MONTH ,1, dateCounter);
			}
			
			// do something to invalidate measure and display list 
			// really the size probably won't change; but if the itemRenderer does then it is possible that our ideal measuredWidth and measuredHeight might
			this.invalidateSize();
			// layout may change a lot, though; we'll use the redoDayRenderer variable to recalculate the positioning
			// reuse the redoDayRenderers variable for updateDisplayList functionality because we are assuming that 
			// commitProperties will not run twice before updateDisplayList runs in a normal render event
			// during component setup, it may run twice; but even if it does it should have all the renderers it needs so it's just a condition check
			// and the invalidate methods
			this.invalidateDisplayList()
		}			
		
		
		if(this.calendarDataChanged == true){

			// update the dayRenderers that are not in use just so we don't have to do it later 
			for each ( tempDayRenderer in this.dayRenderersFree ){
				tempDayRenderer.calendarData = this.calendarData;
			}

			// update the dayRenderers that are in use  
			for each ( tempDayRenderer in this.dayRenderersInUse ){
				tempDayRenderer.calendarData = this.calendarData;
				tempDayRenderer.invalidateCalendarData();
			}
			// end dayRenderer updating code 
			
			this.calendarDataChanged = false;
		}

		

		if(this.redoMonthHeader){
			// in this block of code we are dealing the changes to the 
			// monthHeaderVisible, monthHeaderRenderer, monthNames, monthSymbol properties
			// if visible changed, then we either delete or re-create the renderer in which case none of the other stuff applies
			
			// we really have three actions
			// to delete the monthHeader
			// to create the monthHeader
			// to update the monthHeader data
			// so let's store them as variables and consolidate the stuff we have to do
			
			var removeMonthHeader : Boolean = false;
			var newMonthHeader : Boolean = false;
			var updateMonthHeaderData : Boolean = false;
			
			if(this.monthHeaderVisibleChanged == true){
				// if the monthHeader doesn't exist, but it should create it 
				if((!this.monthHeader) && (this.calendarData.monthHeaderVisible == true)){
					newMonthHeader = true;
				} else if((this.monthHeader) && (this.calendarData.monthHeaderVisible == false)){
					// if the monthHeader does exist, but it shouldn't delete it 
					removeMonthHeader = true;
				}
				
			} 

			if(this.monthHeaderRendererChanged == true){
				removeMonthHeader = true;
				newMonthHeader = true;
				this.monthHeaderRendererChanged = false;
			}
			
			if((this.monthNamesChanged == true) || (this.monthSymbolChanged == true) || 
				(this.displayedYearChanged == true) || (this.displayedMonthChanged == true) || 
				(this.redoMonthHeaderData == true))
				{
				updateMonthHeaderData = true;
				this.monthNamesChanged = false;
				this.monthSymbolChanged = false;
				this.displayedYearChanged = false;
				this.displayedMonthChanged = false;
				this.redoMonthHeaderData = false;
			}

			if(removeMonthHeader == true){
				destroyMonthHeader();
			}
			// if we create the header there is no need to update the dat 
			if(newMonthHeader == true){
				this.monthHeader = this.createMonthHeader();
				this.addChild(this.monthHeader);
			} else if (updateMonthHeaderData == true){
				// we only need to update the data if we didn't create the header new
				if(this.monthHeader is IMonthHeader){
					var newMonthData : ICalendarHeaderDataVO = this.createMonthHeaderData();
					(this.monthHeader as IMonthHeader).monthHeaderData = newMonthData;
				}				
			}
			
			this.redoMonthHeader = false;
			// make sure to resize the days if month Header has changed 
			this.redoDayRenderers = true;

		}

	}

	// we can't actually create the days in here because we want to make sure we have the dataProvider, displayMonth, displayYear
	/** 
	 * @private
	 */
	override protected function createChildren():void{
		super.createChildren();
		
		if(this.calendarData){
			// create the monthHeader 
			if(this.calendarData.monthHeaderVisible == true){
				monthHeader = createMonthHeader();
				this.addChild(monthHeader);
			}
			
			// if there is nothing in the dayNameHeader array, create the dayNameHeaders 
			// we need to encapsulate the dayNameHeader create functionality so it can easily be reused in commitProperties
			if(dayNameHeaders.length ==0){
				createDayNameHeadersArray();
			}
		}
		
	}
	
	// calculated measuredHeight and measuredWidth of this component 
	/** 
	 * @private
	 */
	override protected function measure():void{

		if(isCalendarStateNotMonthView()){
			return;
		}

		super.measure();
		
		// day name header calculations moved to CalendarStateBase

		// used to calculate the total ideal height of the component 
		var finalHeight : int = this.measuredHeight ;
		// used to calculate the total width of the component 
		var finalWidth : int = this.measuredWidth;

		
		// remember that days loop from zero to 6 
		if((this.dayRenderersInUse) && (this.dayRenderersInUse.length > 0)){
			
			// be sure that the dayRenderersInUse is properly sorted from day 1 to day last
			// wrap it in a collection to make use of collection sorting
			sortDayRenderersInDateOrder();
	
	
			// find the day of the week that the first day of the month lands on
			// encapsulated this out because the value is different if leading and trailing days are being displayed 
//			var daysInMonth : int = DateUtils.daysInMonth(new Date(this.calendarData.displayedYear, this.calendarData.displayedMonth, 1));	
			// why aren't we using dayRendersInUse.length here? 
			var daysToProcess : int = calculateDaysToProcess();

			// in theory each day will have the same height and width; but just in case someone does something odd w/ DayRenderers, 
			// we aren't going to make that assumption
			// loop over days to find each week's width; save the longest width
			// find the largest height of each renderer in the week and add that to 'total' height

			// used in the loop to find the dayRenderer with the largest height of the current week
			var largestHeightInWeek : int = 0;

			// used in the loop to find the dayRenderer with the width of the current week
			var widthOfWeek : int = 0;

			// used to tell if the last day of the week was a Saturday
			// if the last day of the week was not a saturday we want to perform the height and width calculation 
			// one last time after the loop
			// most likely only the height will change; though.
			var lastDayOfWeekSaturday : Boolean = false;

			for (var currentDay : int = 0; currentDay < daysToProcess ; currentDay++) { 
				lastDayOfWeekSaturday = false;

				var currentDayRenderer : IDayRenderer = this.dayRenderersInUse.getItemAt(currentDay) as IDayRenderer;
				largestHeightInWeek = Math.max(largestHeightInWeek,currentDayRenderer.getExplicitOrMeasuredHeight());
				widthOfWeek += currentDayRenderer.getExplicitOrMeasuredWidth();
				// if it is a Saturday / last day of week
//				if( DateUtils.dayOfWeek(new Date(this.calendarData.displayedYear,this.calendarData.displayedMonth,currentDay)) == 6 ){
				if( DateUtils.dayOfWeek( currentDayRenderer.dayData.displayedDateObject ) == this.calendarData.lastDayOfWeek ){
					finalHeight += largestHeightInWeek;
					largestHeightInWeek = 0;
					
					finalWidth = Math.max(finalWidth,widthOfWeek);
					widthOfWeek = 0;
					lastDayOfWeekSaturday = true;

				}
			}
			
			// once we get out of the loop do one final calculation if the last day of the month was not a a Saturday
			if( lastDayOfWeekSaturday == false ){
				finalHeight += largestHeightInWeek;
				largestHeightInWeek = 0;
				
				finalWidth = Math.max(finalWidth,widthOfWeek);
				widthOfWeek = 0;
			}

		}

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
		
		
		// calculate the height and width of the monthHeader and add that to the final width and height 
		if(this.monthHeader){
			finalWidth = Math.max(finalWidth,this.monthHeader.getExplicitOrMeasuredWidth());
			finalHeight += this.monthHeader.getExplicitOrMeasuredHeight();
		}

		// set the calculated height and width to measruedHeight and measuredWidth
		this.measuredHeight = finalHeight;
		this.measuredWidth = finalWidth;
		// setting these to see if it helps percentage error 
		this.measuredMinWidth = 100;
		this.measuredMinHeight = 100;
		

	}

	/** 
	 * @private
	 */
	override public function styleChanged(styleProp:String):void{
		super.styleChanged(styleProp);

		// this approach modeled after how the itemsChangeEffect is implemented in ListBase for ListBased Classes
		if(styleProp == "monthChangeEffect"){
			cachedMonthChangeEffect = null;
		}
		
	}
	/** 
	 * @private
	 */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {

		if(isCalendarStateNotMonthView() && (this.calendarData.leadingTrailingDaysVisible == false)){
			return;
		}
		
		if((this.cachedMonthChangeEffect) && (this.cachedMonthChangeEffect.isPlaying == true)){
			return;
		}

		// if someone specifies a height and width as percentages; updateDisplayList is called w/ unscaledWidth and unScaledHeight as Nan
		// that screwed up a lot of display thing 
		if(isNaN(unscaledWidth)){
			unscaledWidth = this.measuredWidth;
		}
		if(isNaN(unscaledHeight)){
			unscaledHeight = this.measuredHeight;
		}
		if(isNaN(this.width)){
			this.width = this.measuredWidth;
		}
		if(isNaN(this.height)){
			this.height = this.measuredHeight;
		}

		super.updateDisplayList(unscaledWidth, unscaledHeight);

		// a Date object referencing the first date of the month; used to calculate the days in the first week of the month
		// and thereby the positioning of headers and days 
		var firstDateOfMonth : Date = new Date(this.calendarData.displayedYear,this.calendarData.displayedMonth,1)
		
		// the width for each individual day, split across all days
		var dayWidth : int = Math.floor(unscaledWidth/7);
		this.calendarData.calendarMeasurements.monthDayWidth = dayWidth;

		
		// the x position where we place each item
		var startX : int = 0 ;

		// the y position where we place each item
		var startY : int = 0;

		// modify height to take the monthHeader into account 
		var monthHeaderHeightAdjustment : int = 0;

		// position & size the month header 
		if((this.monthHeader) && (this.calendarData.monthHeaderVisible == true)){
			this.monthHeader.width = unscaledWidth;
			this.monthHeader.height = this.monthHeader.getExplicitOrMeasuredHeight();
			this.monthHeader.x = startX;
			this.monthHeader.y = startY;
			startY += this.monthHeader.height;
			monthHeaderHeightAdjustment = this.monthHeader.getExplicitOrMeasuredHeight();
		}
		


		// the x position where we place each item
		startX = 0 + (dayWidth * (6 - this.calendarData.lastDayOfWeek));

		// size and layout the headers 
		// first run through I'm going to lay them out in order
		// then I'll deal with the first day of the week thing 
		if(this.dayNameHeaders.length > 0){
			
			// loop over days 7 times 
			for (var dayIndex : int = 0; dayIndex < 7; dayIndex++){
				var tempdayNameHeaderRenderer : UIComponent = this.dayNameHeaders[dayIndex]
				tempdayNameHeaderRenderer.setActualSize(dayWidth,this.maxDayNameHeaderHeight);
				tempdayNameHeaderRenderer.x = startX;
				tempdayNameHeaderRenderer.y = startY;
				
				startX += dayWidth;

				if(dayIndex == this.calendarData.lastDayOfWeek){
					startX = 0;
				}
			}
			
			this.calendarData.calendarMeasurements.monthDayNameHeaderY = startY;
			startY += this.maxDayNameHeaderHeight;
			monthHeaderHeightAdjustment += this.maxDayNameHeaderHeight ;
			
		}

		this.calendarData.calendarMeasurements.monthHeaderHeight = monthHeaderHeightAdjustment;

		// set actual size on all itemRenderer days
		if((this.redoDayRenderers == true)){
			
			// find out how many weeks there are in the month
			// it is either going to be 4 or 5 or 6
			var weeksInMonth : int = DateUtilsExtension.weeksInMonth(firstDateOfMonth, this.calendarData.firstDayOfWeek);
			
			// the height for each individual day, split across all weeks
			// should I just use startY for the adjustment? 
			var dayHeight : int = Math.floor(( unscaledHeight - (monthHeaderHeightAdjustment )  )/weeksInMonth);

			this.calendarData.calendarMeasurements.monthDayHeight = dayHeight;

			// the x position where we place each item
			if(this.calendarData.leadingTrailingDaysVisible == false){
			startX = 0 + (dayWidth * (7 - DateUtilsExtension.daysInFirstWeekOfMonth(firstDateOfMonth, this.calendarData.firstDayOfWeek ) ) );
			} else {
				// if leading and trailing days are being displayed; then we are starting at position 0 w/ no offsets 
				startX = 0 ;
			}
			
			for each (var item : Object in this.dayRenderersInUse){
				var tempDayRenderer : IDayRenderer = item as IDayRenderer;

				// position day renderer 
				tempDayRenderer.x = startX;
				tempDayRenderer.y = startY;
				// set size of dayRenderer 
				tempDayRenderer.setActualSize(dayWidth,dayHeight);

				// increment x position
				startX += dayWidth;

				// if we're at the last day of the week, reset x position 
				// and increment y position
//				if(isLastDayOfWeek(tempDayRenderer.dayData.date)){
				if(isLastDayOfWeek(tempDayRenderer.dayData.displayedDateObject)){
					startX = 0;
					startY += dayHeight ;
				}

			}

			this.redoDayRenderers = false;
		}

		if(this.runMonthChangeEffectNextUpdate == true){

			this.cachedMonthChangeEffect.captureEndValues();

			this.cachedMonthChangeEffect.play();
			this.runMonthChangeEffectNextUpdate = false;
		}
	}

		
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  cachedMonthChangeEffect
    //----------------------------------
    /**
	 * @private 
     *  The effect that plays when the month or year changes and days have to be 
     * moved, added, or removed.
     */
    protected var cachedMonthChangeEffect:IEffect = null;


    //----------------------------------
    //  dayRenderersFree
    //	An array of dayRenderers that are not being used in the current month / year display 
	// created for use in commitProperties when changing the month or year.  It will move unused dayRenderers here
	// using this approach because it is similar to what is done with other renderer usage in list based classes
    //----------------------------------
	/** 
	 * This is an array of dayRenderer objects that are not being used in the current month / year display.  
	 * This is used for caching purposes when cycling through months.
	 */
	protected var dayRenderersFree : Array = new Array(0);



    //----------------------------------
    //  monthHeader
    //	An array of dayNameHeader objects 
    //----------------------------------
	/** 
	 * This is a reference to the monthHeader object.
	 */
	protected var monthHeader : UIComponent;

    //----------------------------------
    //  monthHeaderVisibleChanged
    //----------------------------------
	/** 
	 * @private
	 * This is a variable used in conjunction with commitProperties to tell if the month Header visibility has changed. 
	 */
    protected var monthHeaderVisibleChanged : Boolean = false;

    //----------------------------------
    //  monthHeaderRendererChanged
    //----------------------------------
	/** 
	 * @private
	 * This is a variable used in conjunction with commitProperties to tell if the month Header Renderer has changed. 
	 */
    protected var monthHeaderRendererChanged : Boolean = false;

    //----------------------------------
    //  displayedMonthChanged
    //----------------------------------
	/** 
	 * @private
	 * This is a variable used in conjunction with commitProperties to tell if the displayed Month has changed. 
	 */
    protected var displayedMonthChanged : Boolean = false;

    //----------------------------------
    //  displayedYearChanged
    //----------------------------------
	/** 
	 * @private
	 * This is a variable used in conjunction with commitProperties to tell if the display year has changed. 
	 */
    protected var displayedYearChanged : Boolean = false;


    //----------------------------------
    //  runMonthChangeEffectNextUpdate
    //----------------------------------
    /**
	 * @private
     *  A flag that indicates if a date change effect should be initiated
     *  the next time the display is updated.
     */
    protected var runMonthChangeEffectNextUpdate:Boolean = false;

    //----------------------------------
    //  runningMonthChangeEffect
    //----------------------------------
    /**
	 * @private 
     *  A flag indicating if a date change effect is currently running.
     */
    protected var runningMonthChangeEffect:Boolean = false;
    
    //----------------------------------
    //  parseDataProvider
    //  used if dataProvider, displayDay, displayMonth, or displayYear change
    //----------------------------------
	/** 
	 * @private
	 * This is a variable used in conjunction with commitProperties to tell if the dataProvider, displayMonth, or displayYear have changed, 
	 * and therefore the dataProvider needs to be parsed again to find the appropriate days.
	 */
    protected var parseDataProvider : Boolean = true;

    //----------------------------------
    //  redoCalendarData
	// if the itemEditor changes, all the existing dayData objects also needs to change 
    //----------------------------------
	/** 
	 * @private
	 * This is a variable used in conjunction with calendarData that is pass through to the dayRenderes.  
	 * If any of the calendar specific data changes, we need to update the calendarData property in the dayRenderers
	 */
	protected var redoCalendarData : Boolean;

    //----------------------------------
	//  leadingTrailingDaysVisibleChanged
	// if the itemEditor changes, all the existing dayData objects also needs to change 
	//----------------------------------
	/** 
	 * @private
	 * This is a variable used in conjunction with calendarData to figure out if the leadingTrailingDaysVisible value 
	 * has changed.  If it is has; we want to refresh the dataPRovider for all days
	 */
	protected var leadingTrailingDaysVisibleChanged : Boolean;
	
    //----------------------------------
    //  redoMonthHeader
	// if the monthHeaderRenderer changes, or visibility changes, or localization stuff changes we need to redo the MonthHeader 
    //----------------------------------
	/** 
	 * @private
	 * This is a variable used in conjunction with the monthHeader.  IF the MonthHEaderRenderer, or monthHeaderVisible properties 
	 * change the monthHeader may neeed to be recreatd.
 	 */
	protected var redoMonthHeader : Boolean = false;

    //----------------------------------
    //  redoMonthHeaderData
    //----------------------------------
	/**
	 * @private
	 * This is a variable used in conjunction with the monthHeader.  If calendarData needs to be updated for the monthHeader, this forces the 
	 * component to update during the next commitProperties
	 */
	protected var redoMonthHeaderData : Boolean = false;


    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------


    //----------------------------------
    //  calendarData
    //----------------------------------
	/**
	 * @inheritDoc 
	 */
	override public function get calendarData():ICalendarDataVO{
		return super.calendarData;
	}

	/**
	 * @private 
	 */
	override public function set calendarData(value:ICalendarDataVO):void{

		if((this.calendarData.monthHeaderVisible != value.monthHeaderVisible) || 
			(ObjectUtil.compare(this.calendarData.monthHeaderRenderer, value.monthHeaderRenderer) != 0) || 
			(ObjectUtil.compare(this.calendarData.monthNames, value.monthNames) != 0) || 
			(this.calendarData.monthSymbol != value.monthSymbol)){
				this.redoMonthHeader = true;
				
				if(this.calendarData.monthHeaderVisible != value.monthHeaderVisible){
					this.monthHeaderVisibleChanged = true;
				}
				if(ObjectUtil.compare(this.calendarData.monthHeaderRenderer, value.monthHeaderRenderer) != 0){
					this.monthHeaderRendererChanged = true;
				}
		}

		
		if((this.calendarData.displayedMonth != value.displayedMonth) || 
			(this.calendarData.displayedYear != value.displayedYear) || 
			(this.calendarData.firstDayOfWeek != value.firstDayOfWeek) 
		){
			this.redoDayRenderers = true;
			if(this.calendarData.displayedMonth != value.displayedMonth){
				this.redoMonthHeader = true;
				this.displayedMonthChanged = true;
			}
			if(this.calendarData.displayedYear != value.displayedYear){
				this.redoMonthHeader = true;
				this.displayedYearChanged = true;
			}
			
			// do some minimal setup for the dateChange Effect
			this.prepareMonthChangeEffect();
			
		}
		
		// As I refactor; this doesn't make any sense to me
		// why perform this check here?  If MonthHeaderData needs changing, do the interface check when we change it in commitProperties
		// but just in case this is a fringe case; lets leave it.
		if((this.monthHeader) && (this.monthHeader is IMonthHeader)){
			this.redoMonthHeader = true;
			this.redoMonthHeaderData = true;
		}

		// If the leading trailing days visible property changed; make sure we add--or remove--the days 
		if(this.calendarData.leadingTrailingDaysVisible != value.leadingTrailingDaysVisible){
			this.redoDays = true;
			this.leadingTrailingDaysVisibleChanged = true;
		}		
		
		super.calendarData = value;
		this.calendarDataChanged = true;
		// invalidation of properties, size, and display list is in the super


	}
	
	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

	//----------------------------------
	//  changeMonth
	//----------------------------------
	// a function to calculate hte number of days to process 
	// used in commitProperties and measure
	// the number of days to process is equal to the number of days to display; which is different 
	// if we are displaying leading and trailing days (or not ) 
	/**
	 * @private 
	 */
	protected function calculateDaysToProcess():int{
		var results : int
		if(this.calendarData.leadingTrailingDaysVisible == false){
			results = DateUtils.daysInMonth(new Date(this.calendarData.displayedYear,this.calendarData.displayedMonth, 1));
		} else {
			results = DateUtilsExtension.weeksInMonth(new Date(this.calendarData.displayedYear,this.calendarData.displayedMonth, 1), this.calendarData.firstDayOfWeek)*7;
		}
		return results;
		
	}
	
    
    //----------------------------------
    //  changeMonth
    //----------------------------------
	// could be mde tons simplier by doing a:
	//  DateUtils.dateAdd(DateUtils.MONTH, value, currentDate )
	//  then reset displayedMonth and displayedYear and invalidate both
    /**
     *  @inheritDoc
     */
    public function changeMonth(value:int = 1):void{
		if((this.cachedMonthChangeEffect) && (this.cachedMonthChangeEffect.isPlaying)){
			this.cachedMonthChangeEffect.stop();
		}
		
		// If the year changes we want to invalidate it after all the processing of this method is done
		var yearInvalidated : Boolean = false;

   		var result : int = this.calendarData.displayedMonth + value;

		// if value is 12 or -12 don't increment the month
    	if((result >= 0) && (result <= 11) ){
			// if the new month is greater than or equal to 0 (January)  
			// or less or equal to 11 [December] go ahead and do the increment
			// otherwise we have to change the year 
    		this.calendarData.displayedMonth = result;
    	} else {
 
 			// if the value covers more than 12 months, 
 			// slam it back down
			var calculatedValue : int = value; 
    		if(Math.abs(calculatedValue) > 12){
   				calculatedValue = calculatedValue%12;
	   		}

    		// if the new month is less than 0 [January] we need to decrement the year
    		// mod '%' gives the remainder 
    		// div     gives the result w/o the remainder 
			
			var monthIncrement : int = calculatedValue%12;

			var newMonth : int = this.calendarData.displayedMonth + monthIncrement;
			if(newMonth < 0){
				newMonth = newMonth + 12;
			} else if(newMonth > 11){
				newMonth = newMonth - 12;
			}

			this.calendarData.displayedMonth = newMonth;

			// change year once for every 12 values 
			// using floor is effectively a Div 
			// sign of value will take care of incrementing or decrementing
			var yearIncrement : int ;
			if(value < 0){
				yearIncrement = Math.floor(value/12);
				this.calendarData.displayedYear += yearIncrement;
				yearInvalidated  = true;
			} else if (value > 0){
				yearIncrement = Math.ceil(value/12);
				this.calendarData.displayedYear += yearIncrement;
				yearInvalidated  = true;
			}
			
    	}

		// force the month and year to update, as needed.
		this.prepareMonthChangeEffect();
   		this.invalidateMonth();
   		if(yearInvalidated == true){
			this.invalidateYear();
   		}
    }

    //----------------------------------
    //  createMonthHeader
    //----------------------------------
	/**
	 * @private
	 * Helper function to create the month header.
	 */
	protected function createMonthHeader():UIComponent{
		var tempdayNameHeader : UIComponent = this.calendarData.monthHeaderRenderer.newInstance() as UIComponent;
		if(tempdayNameHeader is IMonthHeader){
			(tempdayNameHeader as IMonthHeader).monthHeaderData = this.createMonthHeaderData();
		}

		tempdayNameHeader.addEventListener(CalendarChangeEvent.PREVIOUS_YEAR, onPreviousYear);
		tempdayNameHeader.addEventListener(CalendarChangeEvent.PREVIOUS_MONTH, onPreviousMonth);
		tempdayNameHeader.addEventListener(CalendarChangeEvent.NEXT_MONTH, onNextMonth);
		tempdayNameHeader.addEventListener(CalendarChangeEvent.NEXT_YEAR, onNextYear);

		return tempdayNameHeader;
	}

	//----------------------------------
	//  createMonthHeaderData
	//----------------------------------
	/**
	 * @private
	 * Helper function for creating the month header data object
	 */
	protected function createMonthHeaderData():ICalendarHeaderDataVO{
		var monthName : Object;
		if(this.calendarData.displayedMonth <= this.calendarData.monthNames.length-1){
			monthName = this.calendarData.monthNames[this.calendarData.displayedMonth];
		} else {
			monthName = '';
		}
		return  new MonthHeaderDataVO(this.calendarData.displayedMonth,this.calendarData.displayedYear, monthName, this.calendarData.monthSymbol,this.calendarData);
		
	}	

	//----------------------------------
    //  compareDayRenderers
    //----------------------------------
	/**
	 * @private
	 * 
	 * This function compares two items from the dayRenderersInUse collection in order to sort it so that it is in dateOrder
	 * Creating it as a function because that is more flexible for people extending the component 
	 * 
	 * @param a	 one item; presumably an instance of the dayRenderer class
	 * @param b  One item; presumably an instance of the dayRenderer class
	 * @return -1 if a appears before b; 0 if a=b: and 1 if b appears before A
	 * 
	 */
	protected function compareDayRenderers(a:Object, b:Object):int{
		// if the items passed in aren't dayRenderers we can't compare them, so return 0
		if(!(a is IDayRenderer) || !(b is IDayRenderer)){
			return 0;
		}
		var aDayRenderer : IDayRenderer = a as IDayRenderer;
		var bDayRenderer : IDayRenderer = b as IDayRenderer;
		
		return ObjectUtil.dateCompare(aDayRenderer.dayData.displayedDateObject, bDayRenderer.dayData.displayedDateObject);
		
/*	The old comparison method that only comapred dates.  When dealing with leading / trailing days we need to compare more 
		
		if(aDayRenderer.dayData.date < bDayRenderer.dayData.date){
			return -1;
		} else if (aDayRenderer.dayData.date > bDayRenderer.dayData.date){
			return 1;
		}

		// they must be equal 		
		return 0;
*/
	}

    //----------------------------------
    //  destroyMonthHeader
    //----------------------------------
	/**
	 * @private 
	 * Helper function to remove the monthHeader from the stage w/ removeChild and null them out
	 */
	protected function destroyMonthHeader():void{
		// modded because it tried to remove the monthHEader before it was created if you specify a monthHeaderRenderer and monthHeaderVisible = false
		if(this.monthHeader){
		this.removeChild(this.monthHeader);
		this.monthHeader = null;
		}
	}
	
    //----------------------------------
    //  isCalendarStateMonthView
    //----------------------------------

	/**
	 * @private 
	 * A helper function for deciding if the Calendar component's current state is in the month view;
	 * if it is not we don't want to run updateDisplayList, commitProperties, or measure 
	 * Returns false if the state of the Calendar is equal to Calendar.MONTH_VIEW; true otherwise. False will be returned if calendarData is not defined
	 * 
	 */
	protected function isCalendarStateNotMonthView():Boolean{
		return ((this.calendarData) && (this.calendarData.calendar) && (UIComponent(this.calendarData.calendar).currentState != Calendar.MONTH_VIEW));
	}



    //----------------------------------
    //  isLastDayOfWeek
    //----------------------------------
	/**
	 * @private 
	 * 
	 * given a date, this will tell you whether that date is the last day of a week 
	 * taking into account this component's FirstDayOfWeek
	 * 
	 * @param value
	 * @return 
	 * 
	 */
	protected function isLastDayOfWeek(value:Date):Boolean{
		return (DateUtils.dayOfWeek(value) ==  this.calendarData.lastDayOfWeek);
	}

	/**
	 * @private 
	 * 
	 * given a day of the month [1-31, this will tell you whether that day is the last day of the week 
	 * taking into account this component's displayYear, displayMonth, and FirstDayOfWeek
	 * 
	 * @param value
	 * @return 
	 * 
	 */
	
	//	protected function isLastDayOfWeek(value:int):Boolean{
//		return (DateUtils.dayOfWeek(new Date(this.calendarData.displayedYear,this.calendarData.displayedMonth,value)) ==  this.calendarData.lastDayOfWeek);
//	}

    //----------------------------------
    //  getFreeOrNewDayRenderer
    // returns a dayRenderer.  
    // if there are unusedDayRenderer objects, it returns one of those
    // if there are no unused dayRenderer objects it creates a new one
    //	Conceptually modeled after makeListData method of the List class
    //----------------------------------
	/**
	 * @private 
	 * Helper function to get a dayRenderer.  
	 * if there are unusedDayRenderer objects, it returns one of those.
	 * if there are no unused dayRenderer objects it creates a new one.
	 */
    protected function getFreeOrNewDayRenderer(day:int, month : int, year : int, dataProvider:Object):Object{
		// ,itemEditor
		var nextDayRenderer : DisplayObject;
		if(this.dayRenderersFree.length > 0){
			nextDayRenderer  = this.dayRenderersFree.pop();
		} else {
			nextDayRenderer  = this.calendarData.dayRenderer.newInstance();

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

		}
		if(nextDayRenderer  is IDayRenderer){

			var dayData : DayDataVO = new DayDataVO(day,dataProvider,new Date(year, month, day));
			(nextDayRenderer as IDayRenderer).dayData = dayData;
			(nextDayRenderer as IDayRenderer).calendarData = this.calendarData;
		}
		
		return nextDayRenderer ;

    }
	
	/**
	 * @private 
	 * helper function to invalidate stuff when the year changes
	 */
	protected function invalidateMonth():void{
       	this.parseDataProvider = true;
    	this.redoDayRenderers = true;
    	this.redoMonthHeader = true;
    	this.displayedMonthChanged = true;
    	this.invalidateProperties();
	}	

	/**
	 * @private 
	 * helper function to invalidate stuff when the year changes
	 */
	protected function invalidateYear():void{
		this.parseDataProvider = true;
    	this.redoDayRenderers = true;
    	this.redoMonthHeader = true;
    	this.displayedYearChanged = true;
    	this.invalidateProperties();
	}	

	/**
	 * @inheritDoc 
	 */
	public function invalidateDays():void{
    	this.redoDayRenderers = true;
    	this.invalidateProperties();
    	this.invalidateSize();
    	this.invalidateDisplayList();
	}	
    
    /**
	 * @private 
     *  Prepares the date effect, which relates to changing the month or year.
     */
    protected function prepareMonthChangeEffect():void
    {           
        if (!this.cachedMonthChangeEffect)
        {
            // Style can set itemsChangeEffect to an Effect object
            // or a Class which is a subclass of Effect
            var dce:Object = getStyle("monthChangeEffect");
            var dceClass:Class = dce as Class;
            if (dceClass)
                dce = new dceClass();
            this.cachedMonthChangeEffect = dce as IEffect;
        }

		if(this.cachedMonthChangeEffect){
			this.cachedMonthChangeEffect.targets = this.dayRenderersInUse.source;
			this.cachedMonthChangeEffect.captureStartValues();
			this.runMonthChangeEffectNextUpdate = true;
		}

      }

	
	/**
	 * Encapsulated the sorting algorithm for the dayRenderersInUse 
	 * 
	 * @private 
	 */
	protected function sortDayRenderersInDateOrder():void{
		this.dayRenderersInUse.sort = null;
		this.dayRenderersInUse.refresh();
		
		var dataSortField:SortField = new SortField();
		dataSortField.compareFunction = compareDayRenderers;
		
		this.dayRenderersInUse.sort = new Sort();
		this.dayRenderersInUse.sort.fields = [dataSortField];
		this.dayRenderersInUse.refresh();
		
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
		this.parseDataProvider = true;
		this.redoDayRenderers = true;
		this.invalidateProperties();
	}

	/**
	 * @private 
	 * This listener function for the previousMonth event from the MonthHeader. It will decrement the month by 1
	 * 
	 * @param e The Event instance
	 * 
	 */
    protected function onPreviousMonth(e:CalendarChangeEvent):void{
		this.changeMonth(-1);

		// must create a clone of the event for the redispatch because otherwise
		// the cancel event is not propogated back down; how odd
		var newEvent : CalendarChangeEvent = e.clone() as CalendarChangeEvent;
		this.dispatchEvent(newEvent);
		
    	
    }
	/**
	 * @private 
	 * This listener function for the previousYear event from the MonthHeader. It will decrement the year by 1.
	 * 
	 * @param e The Event instance
	 * 
	 */
    protected function onPreviousYear(e:Event):void{
		if((this.cachedMonthChangeEffect) && (this.cachedMonthChangeEffect.isPlaying)){
			this.cachedMonthChangeEffect.stop();
		}

		
		this.calendarData.displayedYear = this.calendarData.displayedYear - 1;
		this.invalidateYear();
		this.prepareMonthChangeEffect();

		// must create a clone of the event for the redispatch because otherwise
		// the cancel event is not propogated back down; how odd
		var newEvent : CalendarChangeEvent = e.clone() as CalendarChangeEvent;
		this.dispatchEvent(newEvent);

    }

	/**
	 * @private 
	 * This listener function for the NextMonth event from the MonthHeader.  It will increment the month by 1.
	 * 
	 * @param e The Event instance
	 * 
	 */
    protected function onNextMonth(e:Event):void{
		this.changeMonth(1);

		// must create a clone of the event for the redispatch because otherwise
		// the cancel event is not propogated back down; how odd
		var newEvent : CalendarChangeEvent = e.clone() as CalendarChangeEvent;
		this.dispatchEvent(newEvent);

    }
	/**
	 * @private 
	 * This listener function for the nextYear event from the MonthHeader. It will increment the year by 1.
	 * 
	 * @param e The Event instance
	 * 
	 */
    protected function onNextYear(e:Event):void{
		if((this.cachedMonthChangeEffect) && (this.cachedMonthChangeEffect.isPlaying)){
			this.cachedMonthChangeEffect.stop();
		}

		
		this.calendarData.displayedYear = this.calendarData.displayedYear + 1;
		this.invalidateYear();
		this.prepareMonthChangeEffect();
		
		// must create a clone of the event for the redispatch because otherwise
		// the cancel event is not propogated back down; how odd
		var newEvent : CalendarChangeEvent = e.clone() as CalendarChangeEvent;
		this.dispatchEvent(newEvent);

    }

	protected function onResize(e:Event):void{
		this.redoDayRenderers = true;
		this.invalidateDisplayList();
	}
	
	}
}