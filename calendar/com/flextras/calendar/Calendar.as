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
	import com.flextras.calendar.defaultRenderers.DayHeaderRenderer;
	import com.flextras.calendar.defaultRenderers.DayNameHeaderRenderer;
	import com.flextras.calendar.defaultRenderers.DayRenderer;
	import com.flextras.calendar.defaultRenderers.MonthHeaderRenderer;
	import com.flextras.calendar.defaultRenderers.WeekHeaderRenderer;
	import com.flextras.calendar.utils.DataProviderManager;
	import com.flextras.utils.DateUtilsExtension;
	import com.flextras.utils.RemoveChildExposed;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import mx.collections.ListCollectionView;
	import mx.controls.DateChooser;
	import mx.controls.TextInput;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.listClasses.ListBase;
	import mx.controls.listClasses.ListItemRenderer;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.effects.IEffect;
	import mx.events.CollectionEvent;
	import mx.events.DragEvent;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	import mx.events.StateChangeEvent;
	import mx.managers.DragManager;
	import mx.states.AddChild;
	import mx.states.RemoveChild;
	import mx.states.SetProperty;
	import mx.states.State;
	import mx.states.Transition;

	[Exclude(name="columnWidth", kind="property")] 
	[Exclude(name="menuSelectionMode", kind="property")] 
	[Exclude(name="rowCount", kind="property")] 
	[Exclude(name="rowHeight", kind="property")] 
	[Exclude(name="variableRowHeight", kind="property")] 

	// Month Change effect metaData 
	include "inc/MonthChangeEffectMetaData.as";

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
	 *  @eventType com.flextras.calendar.CalendarEvent.DATE_CHANGED
	 */
	[Event(name="dateChanged", type="com.flextras.calendar.CalendarEvent")]	
	
	/**
	 * The Flextras Calendar Component gives you the base you need to develop your own Calendar based applications.   Everything you see on screen as part of the Calendar component is implemented with a renderer, providing you with a solid base for which to extend the component to suit your own needs.  
	 * 
	 * The Calendar supports much of the Flex List class API, such as itemEditors, and drag and drop.
	 * 
	 * It also includes elements of the Flex DateChooser such as localization.  
	 * 
	 * The Calendar supports Flex 3 and Flex 4, so <a href="http://www.flextras.com/?event=RegistrationForm">register to download our free 
	 * developer edition today</a>.
	 * 
	 * 
	 * <h2>Uses in the Real World</h2>
	 * 
	 * <ul>
	 * <li>Create a dayRenderer that contains a Gannt chart and you can create apps like Google Calendar.</li>
	 * <li>Convert iCal feeds into Flex and display them as an event Calendar.</li>
	 * <li>Create a Scheduling Application.</li>
	 * <li>Put any dated data into a Calendar format, including press releases, conference schedules, or band gigs.</li>
	 * </ul>
	 * 
	 * 
	 *  @mxml
	 *
	 *  <p>The <code>&lt;flextras:Calendar&gt;</code> tag inherits all the tag attributes
	 *  of its superclass, and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;flextras:Calendar
	 *    <b>Properties</b>
	 * 		dateField="date"
	 * 		dateFunction="null"
	 * 		dayHeaderRenderer="com.flextras.calendar.defaultRenderers.DayHeaderRenderer"
	 * 		dayHeaderVisible="true"
	 * 		dayNameHeaderRenderer="com.flextras.calendar.defaultRenderers.DayNameHeaderRenderer"
	 * 		dayNameHeadersVisible="true"
	 * 		dayNames="[ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ]"
	 * 		dayRenderer="com.flextras.calendar.defaultRenderers.dayRenderer"
	 * 		displayedDate="<i>Current date</i>"
	 * 		displayedMonth="<i>Current month</i>"
	 * 		displayedYear=<i>Current year</i>""
	 * 		editable="false"
	 *  	editedItemPosition="<i>No default</i>"
	 *  	editorDataField="text"
	 *  	editorHeightOffset="0"
	 *  	editorUsesEnterKey="false"
	 *  	editorWidthOffset="0"
	 *  	editorXOffset="0"
	 *  	editorYOffset="0"
	 * 		firstDayOfWeek="0"
	 *  	imeMode="null"    
	 *  	itemEditor="mx.controls.TextInput"
	 *  	itemEditorInstance="<i>Current item editor</i>"
	 * 		monthHeaderRenderer="com.flextras.calendar.defaultRenderers.MonthHeaderRenderer"
	 * 		monthHeaderVisible="true"
	 * 		monthNames="["January", "February", "March", "April", "May","June", "July", "August", "September", "October", "November","December"]"
	 * 		monthSymbol=""
	 *  	rendererIsEditor="true"
	 * 		weekHeaderRenderer="com.flextras.calendar.defaultRenderers.WeekHeaderRenderer"
	 * 		weekHeaderVisible="true"
	 * 
	 *    
	 *    <b>Events</b>
	 * 		change="<i>No default</i>"
	 * 		dayClick="<i>No default</i>"
	 * 		dayDragComplete="<i>No default</i>"
	 * 		dayDragDrop="<i>No default</i>"
	 * 		dayDragEnter="<i>No default</i>"
	 * 		dayDragExit="<i>No default</i>"
	 * 		dayDragOver="<i>No default</i>"
	 * 		dayDragStart="<i>No default</i>"
	 * 		expandDay="<i>No default</i>"
	 * 		expandMonth="<i>No default</i>"
	 * 		expandWeek="<i>No default</i>"
	 * 		itemClick="<i>No default</i>"
	 * 		itemDoubleClick="<i>No default</i>"
	 * 		itemEditBegin="<i>No default</i>"
	 * 		itemEditBeginning="<i>No default</i>"
	 *  	itemEditEnd="<i>No default</i>"
	 *  	itemFocusIn="<i>No default</i>"
	 *  	itemFocusOut="<i>No default</i>"
	 * 		itemRollOut="<i>No default</i>"
	 * 		itemRollOver="<i>No default</i>"
	 * 		nextDay="<i>No default</i>"
	 * 		nextMonth="<i>No default</i>"
	 * 		nextWeek="<i>No default</i>"
	 * 		nextYear="<i>No default</i>"
	 * 		previousDay="<i>No default</i>"
	 * 		previousMonth="<i>No default</i>"
	 * 		previousWeek="<i>No default</i>"
	 * 		previousYear="<i>No default</i>"
	 *  /&gt;
	 *  </pre>	
	 * 
	 * 
	 * 
	 * @author DotComIt / Flextras
	 * 
	 */
	public class Calendar extends ListBase implements IObjectArrayForTransitions
	{
		
		/**
		 * @private
		 * this exists because without the ASDocs that copy from DateChooser won't get their data.   
		 */
//		private var a : DateChooser;

		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * A constant representing the default state of this component.  
		 * All other states extend off this one; and it includes the WeekDisplay, DayDisplay, and MonthDisplay instances 
		 */
		public static const DEFAULT_VIEW : String = "defaultView";

		
		/**
		 * This is a constant representing the single day view state of this component.  
		 * In this state the Calendar is only displaying a single day.
		 * 
		 * @see com.flextras.calendar.DayDisplay
		 */
		public static const DAY_VIEW : String = "dayView";
		
		/**
		 * This is a constant representing the month view state of this component.  
		 * In this state, the calendar displays a single month.  This is the default state.
		 * 
		 * @see com.flextras.calendar.MonthDisplay
		 */
		public static const MONTH_VIEW : String = "monthView";
		
		/**
		 * This is a constant representing the week view state of this component.  
		 * In this state, the calendar displays a single week, or seven consecutive days. 
		 * 
		 * @see com.flextras.calendar.WeekDisplay
		 */
		public static const WEEK_VIEW : String = "weekView";



		/**
		 *  Constructor.
		 */
		public function Calendar()
		{
			super();
						
			// set up defaults for renderers 
			this.itemRenderer =  new ClassFactory(ListItemRenderer);
			this.nullItemRenderer = new ClassFactory(ListItemRenderer);
			this.dayRenderer = new ClassFactory(DayRenderer);
			this.dayNameHeaderRenderer = new ClassFactory(DayNameHeaderRenderer);  
			this.monthHeaderRenderer = new ClassFactory(MonthHeaderRenderer);
			this.dayHeaderRenderer = new ClassFactory(DayHeaderRenderer);
			
			// set up some defaults
			this.columnCount = 7;

			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);

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
		
		// if something happened that causes the calendarData to be changed; we recreate it and send that data to the 
		// children
		if(this.redoCalendarData == true){

			// if in the day view update the approproate move / resize overrides 
			if(this.currentState == Calendar.DAY_VIEW){
				this.dayDisplay.updateOverridesForDateChange(this.cachedPreviousDate, new Date(this.displayedYear,this.displayedMonth, this._displayedDate));
			}
			if(this.currentState == Calendar.WEEK_VIEW){
				this.weekDisplay.updateOverridesForDateChange(this.cachedPreviousDate, new Date(this.displayedYear,this.displayedMonth, this._displayedDate));
			}
			
			
			this.calendarData = this.createCalendarData();
			this.monthDisplay.calendarData = this.calendarData;
			this.dayDisplay.calendarData = this.calendarData;
			this.weekDisplay.calendarData = this.calendarData;
			this.redoCalendarData = false;
		}
		// if the dataProvider has changed; update the dataProviderManager and invalidate the month, week, and day displays
		if(this.dataProviderChanged == true){
			this.dataProviderManager.dataProvider = this.dataProvider;
			this.monthDisplay.invalidateDays();
			this.weekDisplay.invalidateWeek();
			this.dayDisplay.invalidateDay();
			this.dataProviderChanged == false;
		}
		// if the dateField has changed; update the dataProviderManager and invalidate the month, week, and day displays
		if(this.dateFieldChanged == true){
			this.dataProviderManager.dateField = this.dateField;
			this.monthDisplay.invalidateDays();
			this.weekDisplay.invalidateWeek();
			this.dayDisplay.invalidateDay();
			this.dateFieldChanged = false;
		}
		// if the dateField has changed; update the dataProviderManager and invalidate the month, week, and day displays
		if(this.dateFunctionChanged == true){
			this.dataProviderManager.dateFunction = this.dateFunction;
			this.monthDisplay.invalidateDays();
			this.weekDisplay.invalidateWeek();
			this.dayDisplay.invalidateDay();
			this.dateFunctionChanged == false;
		}
		
		// if the allowMultipleSelection changed, or a state was changed
		// we need to clear the currently selected items 
		if(this.clearSelection == true){
			// unselect all items; I'm unsure if this method call is superfluous or not
			this.clearSelected();
			// clearning out the selectedItems array should also cler out selectedIndices, selectedItem, and selectedIndex 
			this.selectedItems = new Array();
			this.clearSelection = false;
		}
		
	}

	/** 
	 * @private
	 */
	override protected function createChildren():void{
		super.createChildren();
		this.createDefaultState();
		this.createMonthViewState();
		this.createDayViewState();
		this.createWeekViewState();
		if((!this.currentState) || (this.currentState == '')){
			this.internalStateChange = true;
			this.currentState = Calendar.MONTH_VIEW;
			this.internalStateChange = false;
		}
	}

	// calculated measuredHeight and measuredWidth of this component 
	/** 
	 * @private
	 */
	override protected function measure():void{

		super.measure();
		if(this.currentState == Calendar.MONTH_VIEW){
			this.measuredWidth = this.monthDisplay.measuredWidth;
			this.measuredHeight = this.monthDisplay.measuredHeight;
			this.measuredMinWidth = this.monthDisplay.measuredMinWidth;
			this.measuredMinHeight = this.monthDisplay.measuredMinHeight;
			
		} else if (this.currentState == Calendar.DAY_VIEW){
			this.measuredWidth = this.dayDisplay.measuredWidth;
			this.measuredHeight = this.dayDisplay.measuredHeight;
			this.measuredMinWidth = this.dayDisplay.measuredMinWidth;
			this.measuredMinHeight = this.dayDisplay.measuredMinHeight;
		} else if (this.currentState == Calendar.WEEK_VIEW){
			this.measuredWidth = this.weekDisplay.measuredWidth;
			this.measuredHeight = this.weekDisplay.measuredHeight;
			this.measuredMinWidth = this.weekDisplay.measuredMinWidth;
			this.measuredMinHeight = this.weekDisplay.measuredMinHeight;
		}
	}

	/** 
	 * @private
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {

		super.updateDisplayList(unscaledWidth,unscaledHeight);
		
		// There was a problem with dayRenderers that did not have transparent backgrounds covering the border around the full Calendar
		// the sizing and positioning of children in this method didn't account for borders on the ListBase class; even though there is 
		// a border by default.  
		// Duuuh, Jeff
		// in theory this code should account for situations where the border is not on all sides; but for the moment it doesn't 
		var borderThickness : int = 0;
		var borderStyle : String = this.getStyle('borderStyle' );
		if(borderStyle != 'none'){
			borderThickness = this.getStyle('borderThickness');
		}
		
		
		this.monthDisplay.setActualSize(unscaledWidth-(borderThickness*2),unscaledHeight-(borderThickness*2));
		this.monthDisplay.x = 0 + borderThickness;
		this.monthDisplay.y = 0 + borderThickness;

		// added for transparency reasons
/*		if(this.currentState != Calendar.MONTH_VIEW){
			this.monthDisplay.visible = false;
		} else {
			this.monthDisplay.visible = true;
		}*/

//		using setActualSize doesn't set explicitWidth or explicitHeight; therefore messing up the getExplicitorMeasuredHeight and getExplicitorMeasuredWidth methods
//		this.dayDisplay.width = unscaledWidth;
//		this.dayDisplay.height = unscaledHeight;
		this.dayDisplay.setActualSize(unscaledWidth-(borderThickness*2),unscaledHeight-(borderThickness*2));
		this.dayDisplay.x = 0+ borderThickness;
		this.dayDisplay.y = 0+ borderThickness;

		// added for transparency reasons
/*		if(this.currentState != Calendar.DAY_VIEW){
			this.dayDisplay.visible = false;
		} else {
			this.dayDisplay.visible = true;
		}*/

//		this.weekDisplay.width = unscaledWidth;
//		this.weekDisplay.height = unscaledHeight;
		this.weekDisplay.setActualSize(unscaledWidth-(borderThickness*2),unscaledHeight-(borderThickness*2));
		this.weekDisplay.x = 0+ borderThickness;
		this.weekDisplay.y = 0+ borderThickness;
		// added for transparency reasons
/*		if(this.currentState != Calendar.WEEK_VIEW){
			this.weekDisplay.visible = false;
		} else {
			this.weekDisplay.visible = true;
		}*/

	}

	/** 
	 * @private
	 */
	override public function styleChanged(styleProp:String):void{
		super.styleChanged(styleProp);

		if(styleProp == "monthChangeEffect"){
			UIComponent(this.monthDisplay).setStyle('monthChangeEffect',this.getStyle('monthChangeEffect')) ;
		}
		
	}

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

	//----------------------------------
	//  cachedPreviousDate
	// The previous cached date; updated whenever displayedMonth, displayedYear, or DisplayedDate changes
	// used to update overrides in commitProperties if the component is in the week or day state
	//----------------------------------
	/**
	 * @private 
	 */
	protected var cachedPreviousDate : Date;
	
	//----------------------------------
	//  cachedStateTransition
	// used in conjunction with transition from week view to month view 
	//----------------------------------
	/**
	 * @private 
	 */
	protected var cachedStateTransitionEffect : IEffect;

	//----------------------------------
	//  clearSelection
	//----------------------------------
	/**
	 * @private
	 * variable for clearing the selection values when state changes or allowMultipleSelection is swapped
	 */
	protected var clearSelection : Boolean = false;
	
	//----------------------------------
	//  dayDisplay
	//----------------------------------
	/**
	 * @private
	 * an internal variable for the dayDisplay 
	 */
	private var _dayDisplay : IDayDisplay;

	[Bindable(event="dayDisplayObjectChanged")]
	/**
	 * This contains a reference to the component that displays the expanded day and the day header.
	 * 
	 * @see #monthHeaderRenderer
	 * @see #dayRenderer
	 */
	protected function get dayDisplay():IDayDisplay
	{
		return _dayDisplay;
	}

	/**
	 * @private
	 */
	protected function set dayDisplay(value:IDayDisplay):void
	{
		_dayDisplay = value;
		this.dispatchEvent(new Event('dayDisplayObjectChanged'));
	}
	
	//----------------------------------
	//  dayState
	//----------------------------------
	/**
	 * @private
	 * An internal variable for the day expanded state.
	 */
	protected var dayState : State ;
	
	//----------------------------------
	//  defaultState
	//----------------------------------
	/**
	 * @private
	 * An internal variable for the default state 
	 */
	protected var defaultState : State ;

    //----------------------------------
    //  monthDisplay
    //----------------------------------
    /**
	 * @private
     * an internal variable for the monthDisplay 
     */
    private var _monthDisplay : IMonthDisplay;

	[Bindable(event="monthDisplayObjectChanged")]
	/**
     * This is a reference to the component that displays the days in a month layout, the day name headers, and the month header.  
	 * 
	 * @see #monthHeaderRenderer
	 * @see #dayNameHeaderRenderer
	 * @see #dayRenderer
	 */
	protected function get monthDisplay():IMonthDisplay
	{
		return _monthDisplay;
	}

	/**
	 * @private
	 */
	protected function set monthDisplay(value:IMonthDisplay):void
	{
		_monthDisplay = value;
		this.dispatchEvent(new Event('monthDisplayObjectChanged'));
	}


    //----------------------------------
    //  monthState
    //----------------------------------
    /**
	 * @private
     * An internal variable for the month state 
     */
    protected var monthState : State ;

	//----------------------------------
	//  overrideRemoveMonthDisplay
	//----------------------------------
	/**
	 * @private 
	 * override used in the day state
	 */
	protected var overrideRemoveMonthDisplayForDay : RemoveChildExposed; 


	//----------------------------------
	//  overrideRemoveMonthDisplay
	//----------------------------------
	/**
	 * @private 
	 * override used in the week state
	 */
	protected var overrideRemoveMonthDisplayForWeek : RemoveChildExposed;

	//----------------------------------
	//  overrideRemoveWeekDisplay
	//----------------------------------
	/**
	 * @private 
	 * override used in the day state
	 */
	protected var overrideRemoveWeekDisplay : RemoveChildExposed; 
	
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
	//  requestedCurrentState
	//----------------------------------
	/**
	 *  @private
	 *  Pending current state name
	 */
	private var requestedCurrentState:String;    	
	
	//----------------------------------
	//  weekDisplay
	//----------------------------------
	/**
	 * @private
	 * an internal variable for the weekDisplay 
	 */
	private var _weekDisplay : IWeekDisplay;
	
	[Bindable(event="weekDisplayObjectChanged")]
	/**
	 * This is a reference to the component that displays the days in a week layout, the day name headers, and the week header.
	 * 
	 * @see #weekHeaderRenderer
	 * @see #dayNameHeaderRenderer
	 * @see #dayRenderer
	 */
	protected function get weekDisplay():IWeekDisplay
	{
		return _weekDisplay;
	}
	
	/**
	 * @private
	 */
	protected function set weekDisplay(value:IWeekDisplay):void
	{
		_weekDisplay = value;
		this.dispatchEvent(new Event('weekDisplayObjectChanged'));
	}

	//----------------------------------
	//  weekState
	//----------------------------------
	/**
	 * @private
	 * An internal variable for the week expanded state 
	 */
	protected var weekState : State ;

	//----------------------------------
	//  weekStateOverrideBase
	//----------------------------------
	/**
	 * @private
	 * An internal variable for keeping track of the base week state Overrides
	 * defined when the weekState is created; and stored for times when the week state needs to be recreated to 
	 * handle state changes
	 */
	protected var weekStateOverrideBase : Array;
		
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  allowMultipleSelection
    //----------------------------------

	[Inspectable(category="General", enumeration="false,true", defaultValue="false")]
	/**
     * 	This property is passed through to your dayRenderer.
     * 
	 * @default false
     * @copy mx.controls.listClasses.ListBase#allowMultipleSelection 
	 */
	override public function get allowMultipleSelection():Boolean
    {
        return super.allowMultipleSelection;
    }

    /**
     *  @private
     */
    override public function set allowMultipleSelection(value:Boolean):void
    {
        super.allowMultipleSelection = value;
        this.redoCalendarData = true;
		this.deselectItems();
        this.invalidateProperties();
    }
	
    //----------------------------------
    //  calendarData
    //----------------------------------
    /**
     *  @private
     */
	private var _calendarData : ICalendarDataVO ;
	
	[Bindable(event="calendarDataChanged")]
    /**
     *  This is an instance of the CalendarData object, passed into the monthDisplay, dayDisplay, and weekDisplay.  It is a value object encompassing many of the Calendar's properties.  
	 * 
	 * @see com.flextras.calendar.monthDisplay
	 * @see com.flextras.calendar.weekDisplay
	 * @see com.flextras.calendar.dayDisplay
     */
	protected function get calendarData():ICalendarDataVO{
		if(!this._calendarData){
			this._calendarData = createCalendarData(); 
		}
		return this._calendarData;
	}
	
    /**
     *  @private
     */
	protected function set calendarData(value:ICalendarDataVO):void{
		this._calendarData = value;
		this.dispatchEvent(new Event('calendarDataChanged'));
	}

	//----------------------------------
	//  calendarMeasurementVO
	//----------------------------------
	/**
	 *  @private
	 */
	private var _calendarMeasurementVO : CalendarMeasurementsVO = new CalendarMeasurementsVO() ;
	
	[Bindable(event="calendarMeasurementVOChanged")]
	/**
	 *  This is an instace of the CalendarMeasurementsVO object, passed into the monthDisplay, dayDisplay, and weekDisplay.  It is used for sharing sizing for transition states.  
	 * 
	 * @see com.flextras.calendar.MonthDisplay
	 * @see com.flextras.calendar.WeekDisplay
	 * @see com.flextras.calendar.DayDisplay
	 */
	protected function get calendarMeasurementVO():CalendarMeasurementsVO{
		return this._calendarMeasurementVO;
	}
	
	/**
	 *  @private
	 */
	protected function set calendarMeasurementVO(value:CalendarMeasurementsVO):void{
		this._calendarMeasurementVO = value;
		this.dispatchEvent(new Event('calendarMeasurementVOChanged'));
	}

    //----------------------------------
    //  columnCount
    //----------------------------------
    /**
	 * @private
     *  For the Flextras Calendar this value will be 7.
     *  <b>Note</b>: Setting this property has no effect on a Calendar control,
     *  which always has seven days in a week, and one column for each day
     * 
     *  @default 7
     * @inheritDoc
     */
    override public function get columnCount():int
    {
        return super.columnCount;
    }

    /**
     *  @private
     */
    override public function set columnCount(value:int):void
    {
		// ignores the set 
    }
    
    //----------------------------------
    //  columnWidth
    //----------------------------------
    
    /**
	 * @private
	 * In the Calendar component, each column is a day.  This returns the width of the day's in the monthView state.
     *  Setting this property has no effect because column (or Day) width 
     * is calculated to fill the full width of the component.
     * @inheritDoc
	 * never implemented
     */
    override public function get columnWidth():Number
    {
        return -1;
   }

    /**
     *  @private
     */
    override public function set columnWidth(value:Number):void
    {
		// does nothing
    }
    

    //----------------------------------
    //  currentState
    //----------------------------------

    /**
     *  @private
	 * There is a really bizarre state change bug.  If the developer manually changes state from Month to week to day to week 
	 * the component will be blank in the week view.  They seem to have to follow that procedure.  
	 * There seems to be no issue dispatching events up from the dayRenderer.  
     */
    override public function set currentState(value:String):void{
		if(this.inTheMiddleOfAStateChange == true){
			return;
		}
		
		if(value == ''){
    		value = Calendar.MONTH_VIEW;
    	}
		
		// if events were dispathced from the Calendar's children then these state changes are already running 
		// those setup procedures; so ignore them 
		if(this.internalStateChange == false){
			
			if (!initialized)
			{
				this.stateChangedBeforeInitalization = true;
				this.requestedCurrentState = value;
				
				// We need to wait until we're fully initialized before commiting
				// the current state. Otherwise children may not be created
				// (if we're inside a deferred instantiation container), or
				// bindings may not be fired yet.
				addEventListener(FlexEvent.CREATION_COMPLETE, 
					onCreationCompleteStateChange);
				return;
			}
			
			this.inTheMiddleOfAStateChange = true;
			// trying to get this to work when moving between states w/o trying to expand / collapse a day
			var newCalendarChangeEvent : CalendarChangeEvent 
			if(value == Calendar.WEEK_VIEW){
				if(this.currentState  == Calendar.MONTH_VIEW){
					// create calendarChangeEvent and call onWeekExpand
					newCalendarChangeEvent = new CalendarChangeEvent(CalendarChangeEvent.EXPAND_WEEK, false,false);
					newCalendarChangeEvent.dayToExpand = (this.monthDisplay as MonthDisplay).dateToDayRenderer( this.displayedDateObject );
					this.onWeekExpand(newCalendarChangeEvent);
				} else if(this.currentState == Calendar.DAY_VIEW){
					newCalendarChangeEvent = new CalendarChangeEvent(CalendarChangeEvent.EXPAND_WEEK, false,false);
					newCalendarChangeEvent.dayToExpand = (this.dayDisplay as DayDisplay).dateToDayRenderer( this.displayedDateObject );
					this.onWeekExpand(newCalendarChangeEvent);
				}
			} else if(value == Calendar.MONTH_VIEW){
				if(this.currentState  == Calendar.WEEK_VIEW){
					newCalendarChangeEvent = new CalendarChangeEvent(CalendarChangeEvent.EXPAND_MONTH, false,false);
					newCalendarChangeEvent.dayToExpand = (this.weekDisplay as WeekDisplay).dateToDayRenderer( this.displayedDateObject );
					this.onMonthExpand(newCalendarChangeEvent);
				} else if(this.currentState == Calendar.DAY_VIEW){
					newCalendarChangeEvent = new CalendarChangeEvent(CalendarChangeEvent.EXPAND_MONTH, false,false);
					newCalendarChangeEvent.dayToExpand = (this.dayDisplay as DayDisplay).dateToDayRenderer( this.displayedDateObject );
					this.onMonthExpand(newCalendarChangeEvent);
					
				}
			} else if(value == Calendar.DAY_VIEW){
				if(this.currentState  == Calendar.MONTH_VIEW){
					newCalendarChangeEvent = new CalendarChangeEvent(CalendarChangeEvent.EXPAND_DAY, false,false);
					newCalendarChangeEvent.dayToExpand = (this.monthDisplay as MonthDisplay).dateToDayRenderer( this.displayedDateObject );
					this.onDayExpand(newCalendarChangeEvent);
				} else if(this.currentState == Calendar.WEEK_VIEW){
					newCalendarChangeEvent = new CalendarChangeEvent(CalendarChangeEvent.EXPAND_DAY, false,false);
					newCalendarChangeEvent.dayToExpand = (this.weekDisplay as WeekDisplay).dateToDayRenderer( this.displayedDateObject );
					this.onDayExpand(newCalendarChangeEvent);
				}
			}
			this.inTheMiddleOfAStateChange = false;
		}		
		
    	super.currentState = value;

    	// invalidate the days in the monthDisplay to force them to redraw and/or resize as appropriate.
    	this.monthDisplay.invalidateDays();
//		this.weekDisplay.invalidateWeek();
//		this.dayDisplay.invalidateDay();

		// there is a fringe bug if you go from month to week to day to week where day does not display.  This solves the issue
		// I cannot for the life of me figure out why that bug exists
		if(value == Calendar.WEEK_VIEW){
			this.swapChildrenForStateChange(false, false, true, this.weekDisplay as DisplayObject);
    }

    }


    //----------------------------------
    //  dataProvider
    //----------------------------------
	/**
	 * @private 
	 */
	private var dataProviderChanged : Boolean = false;
    
	[Bindable("collectionChange")]
	[Inspectable(category="Data", defaultValue="undefined")]
    /**
     *  @inheritDoc
     */
    override public function get dataProvider():Object{
    	return super.dataProvider;
    }
    
    /**
     *  @private
     */
    override public function set dataProvider(value:Object):void{
		if(this.dataProvider){
			// remove the event listener from the old value so it's not hanging out there preventing the old value 
			// from being garbage collected.
			this.dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onDataProviderChange);
		}
    	super.dataProvider = value;
    	this.dataProviderChanged = true;
		this.dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, onDataProviderChange);
    	this.invalidateProperties();
    }

    //----------------------------------
    //  dataProviderManager
    //----------------------------------
	private var _dataProviderManager : DataProviderManager = new DataProviderManager();
    /**
     *  This is an instance of the dataProvider Manager component, which is used to decide which data should be displayed on which day.
	 * 
	 * @see com.flextras.calendar.utils.DataProviderManager
     */
    protected function get dataProviderManager():DataProviderManager{
    	return this._dataProviderManager;
    }

    //----------------------------------
    //  dataTipField
    //----------------------------------
	[Inspectable(category="Data", defaultValue="label")]
    /**
     * 	This property is passed through to your dayRenderer.
     * 
     * @default null
     * @copy mx.controls.listClasses.ListBase#dataTipField 
     */
    override public function get dataTipField():String{
    	return super.dataTipField
    }
    /**
     * @private
     */
    override public function set dataTipField(value:String):void
    {
        super.dataTipField = value;
		this.redoCalendarData = true;
		this.invalidateProperties();

    }
    //----------------------------------
    //  dataTipFunction
    //----------------------------------
	[Inspectable(category="Data")]
    /**
     * 	This property is passed through to your dayRenderer.
     * 
     * @default null
     * @copy mx.controls.listClasses.ListBase#dataTipFunction 
     */
    override public function get dataTipFunction():Function{
    	return super.dataTipFunction;
    }
    /**
     * @private
     */
    override public function set dataTipFunction(value:Function):void
    {
        super.dataTipFunction = value;
		this.redoCalendarData = true;
		this.invalidateProperties();

    }

    //----------------------------------
    //  dateField
    //----------------------------------
    /**
     *  @private
     */
	private var _dateField : String = 'date';

	/**
	 *  @private
	 */
	private var dateFieldChanged : Boolean = false;

	[Bindable("dateFieldChanged")]
	[Inspectable(category="Calendar", defaultValue="date", name="Date Field",type="String")]
   /**
     *  The is the name of the field in the data provider items that will be used as the date for deciding which day your data provider item should be placed on. 
	 * By default the Calendar looks for a property named <code>date</code> on each item and displays it on that day.  
	 * However, if the data objects do not contain a <code>date</code> property, you can set the <code>dateField</code> property to use a 
	 * different property in the data object.
     *
     *  @default "date"
	 * @see #dateFunction
     */
    public function get dateField():String
    {
        return _dateField;
    }

    /**
     *  @private
     */
    public function set dateField(value:String):void
    {
        _dateField = value;
		this.dateFieldChanged = true;
		this.invalidateProperties();
        dispatchEvent(new Event("dateFieldChanged"));
    }

    //----------------------------------
    //  dateFunction
    //----------------------------------
    /**
     *  @private
     *  Storage for dateFunction property.
     */
    private var _dateFunction:Function;
	
	/**
	 *  @private
	 */
	private var dateFunctionChanged : Boolean = false;

    [Bindable("dateFunctionChanged")]
	[Inspectable(category="Calendar", defaultValue="null", name="Date Function",type="Function")]

    /**
     *  This is a user-supplied function to run on each item to determine its date.  
	 * 
	 * By default the Calendar looks for a property named <code>date</code> on each item and displays it on that day.  
	 * However, some data sets do not have a <code>date</code> property, nor do they have another property that can be 
	 * used for finding the date.
	 * 
	 * An example of this is an XML document whose dates are located in a custom namepsace on the object.
     *
     *  <p>You can supply a <code>dateFunction</code> that finds the appropriate fields and returns a date Object. </p>
     *
     *  <p>The date function takes a single argument
     *  which is the item in the data provider and returns a String.</p>
     *  <pre>
     *  myDateFunction(item:Object):Date</pre>
     *
     *  @default null
	 * @see #dateField
     */
    public function get dateFunction():Function
    {
        return _dateFunction;
    }

    /**
     *  @private
     */
    public function set dateFunction(value:Function):void
    {
        _dateFunction = value;
		this.dateFunctionChanged = true;
		this.invalidateProperties();

        dispatchEvent(new Event("dateFunctionChanged"));
    }

	//----------------------------------
	//  dayHeaderVisible
	//----------------------------------
	/**
	 * @private
	 */
	private var _dayHeaderVisible : Boolean= true;
	[Bindable("dayHeaderVisibleChanged")]
	[Inspectable(category="Calendar", defaultValue="true", name="Display the Day Header",type="Boolean", enumeration="true,false")]
    /**
	 *  This is used to decide whether the Day Header should be displayed in the day expanded state. 
	 * 
	 * A day header is an area to display informationa at the top of the day expanded view state.
	 * 
	 * The header is created by a dayHeaderRenderer, which should be an instance of the IDayHeader interface.  
	 * 
	 * @default true
	 * 
	 * @see #DAY_VIEW
	 * @see #dayHeaderRenderer
	 * @see com.flextras.calendar.IDayHeader
	 * @see com.flextras.calendar.defaultRenderers.DayHeaderRenderer
     */
	public function get dayHeaderVisible():Boolean
	{
		return this._dayHeaderVisible;
	}
	
	/**
	 * @private
	 */
	public function set dayHeaderVisible(value:Boolean):void
	{
		this._dayHeaderVisible = value;
		this.redoCalendarData = true
		this.invalidateProperties();
		
		dispatchEvent(new Event("dayHeaderVisibleChanged"));

	}
	
	//----------------------------------
	//  dayHeaderRenderer
	//----------------------------------
	/**
	 * @private
	 */
	private var _dayHeaderRenderer : IFactory =  new ClassFactory(DayHeaderRenderer);
	
	[Bindable("dayHeaderRendererChanged")]
	[Inspectable(category="Calendar", defaultValue="ClassFactory(com.flextras.calendar.defaultRenderers.DayHeaderRenderer)", name="Day Header Renderer",type="IFactory")]
	/**
	 *  This is a custom renderer for the day header.  The day header will be the header of the component in the day expanded state.
	 * 
	 * @default ClassFactory(com.flextras.calendar.defaultRenderers.DayHeaderRenderer)
	 * 
	 * @see #DAY_VIEW
	 * @see #dayHeaderVisible
	 * @see com.flextras.calendar.IDayHeader
	 * @see com.flextras.calendar.defaultRenderers.DayHeaderRenderer
	 */
	public function get dayHeaderRenderer():IFactory{
		return this._dayHeaderRenderer;
	}
	
	/**
	 * @private
	 */
	public function set dayHeaderRenderer(value:IFactory):void{
		this._dayHeaderRenderer = value;
		this.redoCalendarData = true
		this.invalidateProperties();
		
		dispatchEvent(new Event("dayHeaderRendererChanged"));
	}

    //----------------------------------
    //  dayNameHeadersVisible
    //  used to specify whether or not the dayNameHeaders should be displayed
    //----------------------------------
    /**
     *  @private
	 *  Storage for the dayNameHeadersVisible property.
     */
	private var _dayNameHeadersVisible:Boolean = true; 

	[Bindable("dayNameHeadersVisibleChanged")]
	[Inspectable(category="Calendar", defaultValue="true", name="Day Name Headers Visible",type="Boolean", enumeration="true,false")]
    /**
	 *  This checks to see if the dayNameHeaders should be displayed in the week and month views.  
	 * 
	 * A day header is the text day of the week that can be displayed at the top of each day column.  
	 * You can control the layout or content displayed by creating a dayNameHeaderRenderer
	 * 
	 * @see #dayNameHeaderRenderer
	 * @see #WEEK_VIEW
	 * @see #MONTH_VIEW
     */
    public function get dayNameHeadersVisible():Boolean
    {
        return _dayNameHeadersVisible;
    }

    /**
     *  @private
     */
    public function set dayNameHeadersVisible(value:Boolean):void
    {
        this._dayNameHeadersVisible = value;
        this.redoCalendarData = true;
        this.invalidateProperties();

        dispatchEvent(new Event("dayNameHeadersVisibleChanged"));

    }

    //----------------------------------
    //  dayNameHeaderRenderer
    //----------------------------------
    /**
     *  @private
     *  Storage for itemRenderer property.
     */
    private var _dayNameHeaderRenderer:IFactory;

	[Bindable("dayNameHeaderRendererChanged")]
	[Inspectable(category="Calendar", defaultValue="ClassFactory(com.flextras.calendar.defaultRenderers.dayNameHeaderRenderer)", name="Day Header Renderer",type="IFactory")]
    /**
     *  This is a custom renderer for the day name header.  
	 * It is used to displays the header for each day column in the Calendar component.  

     *
     * @default new ClassFactory(com.flextras.calendar.defaultRenderers.dayNameHeaderRenderer)
	 * 
	 * @see #dayNameHeadersVisible
	 * @see #WEEK_VIEW
	 * @see #MONTH_VIEW
     */
    public function get dayNameHeaderRenderer():IFactory
    { 
        return _dayNameHeaderRenderer;
    }

    /**
     *  @private
     */
    public function set dayNameHeaderRenderer(value:IFactory):void
    {
        _dayNameHeaderRenderer = value;

        this.redoCalendarData  = true;
    	this.invalidateProperties();

        dispatchEvent(new Event("dayNameHeaderRendererChanged"));
    }

    //----------------------------------
    //  dayNames
    //----------------------------------
    /**
     *  @private
     *  Storage for the dayNames property.
     */
    private var _dayNames:Array = [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ];


    [Bindable("dayNamesChanged")]
	[Inspectable(category="Localization", arrayType="String", name="Day Name Array")]

    /**
     * If you set this property to null, it will get the value "dayNames" from the resourceManager .
     *
     *  @default [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ].
     *  @copy mx.controls.DateChooser#dayNames
     */
    public function get dayNames():Array
    {
        return _dayNames;
    }

    /**
     *  @private
     */
    public function set dayNames(value:Array):void
    {
        _dayNames = value != null ?
                    value :
                    resourceManager.getStringArray(
                        "SharedResources", "dayNames");
        
        // _dayNames will be null if there are no resources.
        _dayNames = _dayNames ? _dayNames.slice(0) : null;

        this.redoCalendarData  = true;

        invalidateProperties();
		this.dispatchEvent(new Event('dayNamesChanged'));
    }


    //----------------------------------
    //  dayRenderer
    //----------------------------------
    /**
     *  @private
     *  Storage for itemRenderer property.
     */
    private var _dayRenderer:IFactory;

	[Bindable(event="dayRendererChanged")]
	[Inspectable(category="Calendar", defaultValue="ClassFactory(com.flextras.calendar.defaultRenderers.dayRenderer)", name="Day Renderer",type="IFactory")]
    /**
     *  This is a custom renderer for the days that make up the Calendar Component.  .  
	 * 
	 * It is used to create days that display in the month view, week view, and day view.  If you want to create your own dayRenderer, you should implement IDayRenderer for best results.
     * 
     * @default new ClassFactory(com.flextras.calendar.defaultRenderers.DayRenderer)
     *
	 * @see com.flextras.calendar.defaultRenderers.DayRenderer
	 * @see com.flextras.calendar.IDayRenderer
	 * @see #DAY_VIEW
	 * @see #MONTH_VIEW
	 * @see #WEEK_VIEW
     */
    public function get dayRenderer():IFactory
    {
        return _dayRenderer;
    }

    /**
     *  @private
     */
    public function set dayRenderer(value:IFactory):void
    {
        _dayRenderer = value;

        this.redoCalendarData  = true;
    	this.invalidateProperties();

        dispatchEvent(new Event("dayRendererChanged"));
    }


	//----------------------------------
	//  displayedDate
	//----------------------------------
	/**
	 * @private
	 */
	private var _displayedDate : Number =(new Date()).date;

	[Bindable("displayedDateChanged")]
	[Inspectable(category="Calendar", name="Displayed Date",type="Number", enumeration="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31")]
	/**
	 * This is used in conjunction with the <code>displayedMonth</code> and <code>displayedYear</code> properties to decide what day to display and where to position it.   
	 * If you set this, it will ignore the value if it does not represent a day in the current month.
	 * 
	 * @see #displayedMonth
	 * @see #displayedYear
	 * @see #displayedDateObject
	 */
	public function get displayedDate():Number
	{
		return this._displayedDate;
	}
	
	/**
	 * @private
	 */
	public function set displayedDate(value:Number):void
	{
		// ignore values above 11 [December] or below 0 [January]
		if((value < 1) || 
			(value > DateUtils.daysInMonth(new Date(this.displayedYear,this.displayedMonth,1)))
			){
			return;
		}
		
		// store the previous date before we cahnge it 
		this.cachedPreviousDate = new Date(this.displayedYear,this.displayedMonth, this._displayedDate);
		
		this._displayedDate = value;
		this.redoCalendarData  = true;
		this.invalidateProperties();
		setDisplayedDateObject();
		dispatchEvent(new Event("displayedDateChanged"));
	}
	
    //----------------------------------
	//  displayedDateObject
	//----------------------------------
	/**
	 *  @private
	 */
	private var _displayedDateObject : Date = new Date() ;

	[Bindable("displayedDateObjectChanged")]
	[Bindable("dateChanged")]
	/**
	 * This property will return the currently selected date.  This value is created using the <code>displayedMonth</code> and <code>displayedYear</code> and <code>displayedDate</code> properties.  
	 * 
	 * @see #displayedDate
	 * @see #displayedMonth
	 * @see #displayedYear
	 */
	public function get displayedDateObject():Date
	{
		return _displayedDateObject;
	}
	
	/**
	 * @private  
	 */
	protected function setDisplayedDateObject():void{
		// only execute and fire off the event if something has changed 
		if((this._displayedDateObject.fullYear == this.displayedYear) && (this._displayedDateObject.month == this.displayedMonth) && 
			(this._displayedDateObject.date == this.displayedDate) ){
			return;
		}
		
		var dateChangeEvent : CalendarEvent = new CalendarEvent(CalendarEvent.DATE_CHANGED,false,false);
		dateChangeEvent.oldDate = this._displayedDateObject;
			
		// set the date
		this._displayedDateObject = new Date(this.displayedYear, this.displayedMonth, this.displayedDate);
			
		// fire off the change event 
		dateChangeEvent.newDate = this._displayedDateObject;
		this.dispatchEvent(dateChangeEvent);
		
		this.dispatchEvent(new Event('displayedDateObjectChanged'));
	}
	
	
    //----------------------------------
    //  displayedMonth
    //----------------------------------

    /**
     *  @private
     */
	private var _displayedMonth : Number = (new Date()).month;
	
	[Bindable("displayedMonthChanged")]
	[Inspectable(category="Calendar", name="Displayed Month",type="Number", enumeration="0,1,2,3,4,5,6,7,8,9,10,11")]
    /**
     * Used together with the <code>displayedYear</code> and <code>displayedDate</code> property to decide what days to display and where to position them.  Month numbers are zero-based, so January is 0 and December is 11.
	 * 
	 * @see #displayedDate
	 * @see #displayedYear
	 * @see #displayedDateObject
	 */
    public function get displayedMonth():Number
    {
        return _displayedMonth;
    }

    /**
     *  @private
     */
    public function set displayedMonth(value:Number):void
    {
		// ignore values above 11 [December] or below 0 [January]
    	if((value < 0) || (value > 11)){
    		return;
    	}

		// store the previous date before we cahnge it 
		this.cachedPreviousDate = new Date(this.displayedYear,this.displayedMonth, this._displayedDate);

		
		_displayedMonth = value;
        this.redoCalendarData  = true;
    	this.invalidateProperties();
		setDisplayedDateObject();
        dispatchEvent(new Event("displayMonthChanged"));

    }

    //----------------------------------
    //  displayedYear
    //----------------------------------

    /**
     *  @private
	 */
	private var _displayedYear : Number = (new Date()).fullYear;
	
	[Bindable("displayedYearChanged")]
	[Inspectable(category="Calendar", name="Displayed Year",type="Number")]
    /**
     *  Used together with the <code>displayedMonth</code> and <code>displayedDate</code> property to decide what days to display and where to position them.  
	 * 
	 * @see #displayedDate
	 * @see #displayedMonth
	 * @see #displayedDateObject
	 */
    public function get displayedYear():Number
    {
        return _displayedYear;
    }

    /**
     *  @private
	 */
    public function set displayedYear(value:Number):void
    {
		// store the previous date before we cahnge it 
		this.cachedPreviousDate = new Date(this.displayedYear,this.displayedMonth, this._displayedDate);


		_displayedYear = value;
		this.redoCalendarData = true;
    	this.invalidateProperties();
		setDisplayedDateObject();
        dispatchEvent(new Event("displayYearChanged"));
    }

    //----------------------------------
    //  doubleClickEnabled
    //----------------------------------

	[Inspectable(enumeration="true,false", defaultValue="true")]
    /**
     * 	This property is passed through to your dayRenderer.
     * 
	 * @default false
     * @copy mx.core.UIComponent#doubleClickEnabled 
     */
    override public function get doubleClickEnabled():Boolean
    {
        return super.doubleClickEnabled;
    }

    /**
     *  @private
     *  Propagate to children.
     */
    override public function set doubleClickEnabled(value:Boolean):void
    {
        super.doubleClickEnabled = value;
        
        this.redoCalendarData = true;
        this.invalidateProperties();

    }

    //----------------------------------
    //  dragEnabled
    //----------------------------------
	[Inspectable(defaultValue="false")]
	/**
     * 	This property is passed through to your dayRenderer.
     * 
	 * @default false
     * @copy mx.controls.listClasses.ListBase#dragEnabled 
	 */
	override public function get dragEnabled():Boolean
    {
        return super.dragEnabled;
    }

    /**
     *  @private
     */
    override public function set dragEnabled(value:Boolean):void
    {
        super.dragEnabled = value;
        this.redoCalendarData = true;
        this.invalidateProperties();
    }

    //----------------------------------
    //  dragMoveEnabled
    //----------------------------------
	[Inspectable(defaultValue="false")]
	/**
     * 	This property is passed through to your dayRenderer.
     * 
	 * @default false
     * @copy mx.controls.listClasses.ListBase#dragMoveEnabled 
	 */
	override public function get dragMoveEnabled():Boolean
    {
        return super.dragMoveEnabled;
    }

    /**
     *  @private
     */
    override public function set dragMoveEnabled(value:Boolean):void
    {
        super.dragMoveEnabled = value;
        this.redoCalendarData = true;
        this.invalidateProperties();
    }

    //----------------------------------
    //  dropEnabled
    //----------------------------------
	[Inspectable(defaultValue="false")]
	/**
     * 	This property is passed through to your dayRenderer.
     * 
	 * @default false
     * @copy mx.controls.listClasses.ListBase#dropEnabled 
	 */
	override public function get dropEnabled():Boolean
    {
        return super.dropEnabled;
    }

    /**
     *  @private
     */
    override public function set dropEnabled(value:Boolean):void
    {
        super.dropEnabled = value;
        this.redoCalendarData = true;
        this.invalidateProperties();
    }



    //----------------------------------
    //  editable
    //----------------------------------
    /**
     *  @private
	 */
	private var _editable : Boolean = false;

	[Bindable(event="editableChanged")]
	[Inspectable(category="Item Editor", defaultValue="true", name="Is Edit Enabled",type="Boolean", enumeration="true,false")]
    /**
     * 	This property is passed through to your dayRenderer.
     * 
	 *  @default false
     * @copy mx.controls.List#editable 
     */
	public function get editable():Boolean{
		return this._editable;
	}

	/**
	 * @private
	 */
	public function set editable(value:Boolean):void{
		this._editable = value;
    	this.redoCalendarData = true;
    	this.invalidateProperties();
		this.dispatchEvent(new Event('editableChanged'));
	}

    //----------------------------------
    //  editedItemPosition
    // this is way more complicated than a pass through, especially if we are are allowing multiple selections / editors across days
    // review List implementation at some future point and decide whether it is worth implementing 
    // or not 
    //----------------------------------

    //----------------------------------
    //  editedItemRenderer
	// we're assuming that there is no way to have two items in edit mode at the same time
    //----------------------------------
    /**
     *  @private
	 */
 	private var _editedItemRenderer : IListItemRenderer ;

	[Bindable(event="editedItemRendererChanged")]
	[Inspectable(category="Item Editor", name="Edited Item Renderer",type="IListItemRenderer")]
    /**
     *  @copy mx.controls.List#editedItemRenderer
     */
	public function get editedItemRenderer():IListItemRenderer{
		return this._editedItemRenderer;
	}  
	
	/**
	 * @private 
	 */
	protected function setEditedItemRenderer(value:IListItemRenderer):void{
		this._editedItemRenderer = value;
		this.dispatchEvent(new Event('editedItemRendererChanged'));
	}
	 
    //----------------------------------
    //  editorDataField
    //----------------------------------
    /**
     *  @private
	 */
 	private var _editorDataField : String = 'text';

	[Bindable(event="editorDataFieldChanged")]
	[Inspectable(category="Item Editor", name="itemEditor Data Field",type="String")]
    /**
     * 	This property is passed through to your dayRenderer.
     * 
	 *  @default false
     * @copy mx.controls.List#editorDataField 
     */
	public function get editorDataField():String{
		return this._editorDataField;
	} 

	/**
	 * @private
	 */
 	public function set editorDataField(value:String):void{
		this._editorDataField = value;
    	this.redoCalendarData = true;
    	this.invalidateProperties();
		this.dispatchEvent(new Event('editorDataFieldChanged'));
	}

    //----------------------------------
	// editorHeightOffset
    //----------------------------------
    /**
     *  @private
	 */
 	private var _editorHeightOffset :Number = 0;

	[Bindable(event="editorHeightOffsetChanged")]
	[Inspectable(category="Item Editor", defaultValue="0", name="itemEditor Height Offset",type="Number")]
    /**
     * 	This property is passed through to your dayRenderer.
     * 
	 *  @default 0
     * @copy mx.controls.List#editorHeightOffset 
     */
     public function get editorHeightOffset():Number{
		return this._editorHeightOffset;
	} 

	/**
	 * @private
	 */
 	public function set editorHeightOffset(value:Number):void{
		this._editorHeightOffset = value;
    	this.redoCalendarData = true;
    	this.invalidateProperties();
		this.dispatchEvent(new Event('editorHeightOffsetChanged'));
	}

    //----------------------------------
    //  editorUsesEnterKey
    //----------------------------------
    /**
     *  @private
	 */
	private var _editorUsesEnterKey : Boolean = false;

	[Bindable(event="editorUsesEnterKeyChanged")]
	[Inspectable(category="Item Editor", defaultValue="false", name="itemEditor User Enter Key",type="Boolean", enumeration="true,false")]

    /**
     * 	This property is passed through to your dayRenderer.
     * 
	 *  @default false
     * @copy mx.controls.List#editorUsesEnterKey 
     */
	public function get editorUsesEnterKey():Boolean{
		return this._editorUsesEnterKey;
	}

	/**
	 * @private
	 */
	public function set editorUsesEnterKey(value:Boolean):void{
		this._editorUsesEnterKey = value;
    	this.redoCalendarData = true;
    	this.invalidateProperties();
		this.dispatchEvent(new Event('editorUsesEnterKeyChanged'));
	}

    //----------------------------------
	// editorWidthOffset
    //----------------------------------
    /**
     *  @private
	 */
 	private var _editorWidthOffset :Number = 0;

	[Bindable(event="editorWidthOffsetChanged")]
	[Inspectable(category="Item Editor", defaultValue="0", name="itemEditor Width Offset",type="Number")]
    
    /**
     * 	This property is passed through to your dayRenderer.
     * 
	 *  @default 0
     * @copy mx.controls.List#editorWidthOffset 
     */
     public function get editorWidthOffset():Number{
		return this._editorWidthOffset;
	} 

	/**
	 * @private
	 */
 	public function set editorWidthOffset(value:Number):void{
		this._editorWidthOffset = value;
    	this.redoCalendarData = true;
    	this.invalidateProperties();
		this.dispatchEvent(new Event('editorWidthOffsetChanged'));
	}

    //----------------------------------
	// editorXOffset
    //----------------------------------
    /**
     *  @private
	 */
 	private var _editorXOffset :Number = 0;

	[Bindable(event="editorXOffsetChanged")]
	[Inspectable(category="Item Editor", defaultValue="0", name="itemEditor X Offset",type="Number")]
    
    /**
     * 	This property is passed through to your dayRenderer.
     * 
	 *  @default 0
     * @copy mx.controls.List#editorXOffset 
     */
     public function get editorXOffset():Number{
		return this._editorXOffset ;
	} 

	/**
	 * @private
	 */
 	public function set editorXOffset(value:Number):void{
		this._editorXOffset  = value;
    	this.redoCalendarData = true;
    	this.invalidateProperties();
		this.dispatchEvent(new Event('editorXOffsetChanged'));
	}

    //----------------------------------
	// editorYOffset
    //----------------------------------
    /**
     *  @private
	 */
 	private var _editorYOffset :Number = 0;

	[Bindable(event="editorYOffsetChanged")]
	[Inspectable(category="Item Editor", defaultValue="0", name="itemEditor Y Offset",type="Number")]
    
    /**
     * 	This property is passed through to your dayRenderer.
     * 
	 *  @default 0
     * @copy mx.controls.List#editorYOffset 
     */
     public function get editorYOffset():Number{
		return this._editorYOffset ;
	} 

	/**
	 * @private
	 */
 	public function set editorYOffset(value:Number):void{
		this._editorYOffset  = value;
    	this.redoCalendarData = true;
    	this.invalidateProperties();
		this.dispatchEvent(new Event('editorYOffsetChanged'));
	}

    //----------------------------------
    //  firstDayOfWeek
    //  approach is mainly from CalendarLayout class; but part of it is borrowed from DateChooser
    // I wonder why CalendarLayout is left undocumented? 
    //----------------------------------
    /**
     *  @private
	 *  Storage for the firstDayOfWeek property.
     */
	private var _firstDayOfWeek:int = 0; // Sunday

    [Bindable("firstDayOfWeekChanged")]
	[Inspectable(category="Calendar", defaultValue="0", name="First Day of Week",type="int", enumeration="0,1,2,3,4,5,6")]
	/**
    *  @default 0 (Sunday)
	*  @tiptext Sets the first day of week for DateChooser
    *  @copy mx.controls.DateChooser#firstDayOfWeek
	*/
    public function get firstDayOfWeek():int
    {
        return _firstDayOfWeek;
    }

    /**
     *  @private
     */
    public function set firstDayOfWeek(value:int):void
    {

        if (value < 0 || value > 6)
            return;

        if (value == _firstDayOfWeek)
            return;

        _firstDayOfWeek = value;
        
		// set the last day of the week
		if(_firstDayOfWeek == 0){
	        this.setLastDayOfWeek(6);
		} else {
	        this.setLastDayOfWeek (_firstDayOfWeek-1);
		}

        this.redoCalendarData = true;
        this.invalidateProperties();
        dispatchEvent(new Event('firstDayOfWeekChanged'));
    }

    //----------------------------------
    //  iconField
    //----------------------------------
	[Inspectable(category="Data", defaultValue="")]
    /**
     * 	This property is passed through to your dayRenderer.
     * 
	 *  @default null
     * @copy mx.controls.listClasses.ListBase#iconField 
     */
	override public function get iconField():String{
		return super.iconField;
	}
	/**
	 *  @private
	 */
	override public function set iconField(value:String):void
    {
        super.iconField = value;
		this.redoCalendarData = true;
		this.invalidateProperties();

    }
    //----------------------------------
    //  iconFunction
    //----------------------------------
	[Inspectable(category="Data")]
    /**
     * 	This property is passed through to your dayRenderer.
     * 
	 *  @default null
     * @copy mx.controls.listClasses.ListBase#iconFunction 
     */
     override public function get iconFunction():Function{
     	return super.iconFunction;
     }
    /**
     *  @private
     */
    override public function set iconFunction(value:Function):void
    {
        super.iconFunction = value;
		this.redoCalendarData = true;
		this.invalidateProperties();

    }

    //----------------------------------
    //  imeMode
    //----------------------------------

    /**
     *  @private
     *  Storage for the imeMode property.
     */
    private var _imeMode:String;

	[Bindable(event="imeModeChanged")]
	[Inspectable(category="Item Editor", defaultValue="true", name="itemEditor IME Mode",type="String")]
	/**
     * 	This property is passed through to your dayRenderer.
     * 
	 *  @default null
     * @copy mx.controls.List#imeMode 
     */
    public function get imeMode():String
    {
        return _imeMode;
    }

    /**
     *  @private
     */
    public function set imeMode(value:String):void
    {
        _imeMode = value;
    	this.redoCalendarData = true;
    	this.invalidateProperties();
		this.dispatchEvent(new Event('imeModeChanged'));
    }
	
	//----------------------------------
	//  internalStateChange 
	//----------------------------------
	/**
	 *  @private
	 * a private variable to tell whether this component is processing a state change that was triggered
	 * internally, as opposed to externally by changing the currentState
	 * if triggered internally, then we can ignore some of the setup methods called in the set currentState
	 */
	private var internalStateChange : Boolean = false;

	//----------------------------------
	//  inWeekToMonthStateChange
	//----------------------------------
	/**
	 *  @private
	 * a private variable to tell whether this component is processing a state change via changing the currentState
	 * property.  If it is; that approach may call onMonthExpand or onWeekExpand or onDayExpand which in turn try to change the 
	 * state.  This is used toprevent an infinite loop
	 */
	private var inTheMiddleOfAStateChange : Boolean = false;

	//----------------------------------
	//  inWeekToMonthStateChange
	//----------------------------------
	/**
	 *  @private
	 * a private variable to tell whether this component is processing a state change from week to month 
	 * used in the weekDisplay to prevent displayList changes that may contradict 
	 * state overrides 
	 */
	internal var inWeekToMonthStateChange : Boolean = false;

    //----------------------------------
    //  itemEditor
    //----------------------------------
    /**
     *  @private
     */
	private var _itemEditor : IFactory = new ClassFactory(TextInput);

	[Bindable(event="itemEditorChanged")]
	[Inspectable(category="Item Editor", defaultValue="ClassFactory(mx.controls.TextInput)", name="itemEditor Class",type="IFactory")]
	/**
     * 	This property is passed through to your dayRenderer.
     * 
	 *  @default new ClassFactory(mx.controls.TextInput)
     * @copy mx.controls.List#itemEditor 
     */
	public function get itemEditor():IFactory{
		return this._itemEditor;
	}

	/**
	 * @private
	 */
	public function set itemEditor(value:IFactory):void{
		this._itemEditor = value;
    	this.redoCalendarData = true;
    	this.invalidateProperties();
		this.dispatchEvent(new Event('itemEditorChanged'));
	}

    //----------------------------------
    //  itemEditorInstance
	// we're assuming that there is no way to have two items in edit mode at the same time, so we only need 1 renderer
	//	in the List class this is a read / write variable.  Why would anyone write this publicly?  
    //----------------------------------
    /**
     *  @private
     */
 	private var _itemEditorInstance : IListItemRenderer ;

	[Bindable(event="itemEditorInstanceChanged")]
	[Inspectable(category="Item Editor", defaultValue="null", name="itemEditor Instance",type="IListItemRenderer")]
    /**
     *  @copy mx.controls.List#itemEditorInstance
     */
	public function get itemEditorInstance():IListItemRenderer{
		return this._itemEditorInstance;
	} 

    //----------------------------------
    //  itemRenderer
    //----------------------------------
	[Inspectable(category="Data")]
	/**
     * 	This property is passed through to your dayRenderer.
     * 
	 *  @default new ClassFactory(mx.controls.Label)
     * @copy mx.controls.listClasses.ListBase#itemRenderer 
     */
	override public function get itemRenderer():IFactory{
		return super.itemRenderer
	}
	/**
	 * @private
	 */
	override public function set itemRenderer(value:IFactory):void{
		super.itemRenderer = value;
    	this.redoCalendarData = true;
    	this.invalidateProperties();
	}


    //----------------------------------
    //  labelField
    //----------------------------------
	[Bindable("labelFieldChanged")]
	[Inspectable(category="Data", defaultValue="label")]
    /**
     * 	This property is passed through to your dayRenderer.
     * 
	 *  @default "label"
     * @copy mx.controls.listClasses.ListBase#labelField 
     */
     override public function get labelField():String{
     	return super.labelField;
     }

    /**
     * @private
     */
    override public function set labelField(value:String):void
    {
        super.labelField = value;
		this.redoCalendarData = true;
		this.invalidateProperties();

    }
    //----------------------------------
    //  labelFunction
    //----------------------------------
	[Inspectable(category="Data")]
    /**
     * 	This property is passed through to your dayRenderer.
     * 
	 *  @default null
     * @copy mx.controls.listClasses.ListBase#labelFunction 
     */
    override public function get labelFunction():Function{
    	return super.labelFunction
    }
    /**
     * @private
     */
    override public function set labelFunction(value:Function):void
    {
        super.labelFunction = value;
		this.redoCalendarData = true;
		this.invalidateProperties();

    }

    //----------------------------------
    //  lastDayOfWeek
    //  The last day of the week; used in conjunction with firstDayOfWeek
    //----------------------------------
    /**
     *  @private
	 *  Storage for the lastDayOfWeek property.
     */
	private var _lastDayOfWeek:int = 6; // Saturday

    [Bindable("lastDayOfWeekChanged")]
	[Inspectable(category="Calendar", defaultValue="6", name="Last Day of Week",type="int", enumeration="0,1,2,3,4,5,6")]
    /**
     *  Number representing the last day of the week to display in the
     *  last column of the calendar control.
     *
     *  @default 6 (Saturday)
	 * @see #firstDayOfWeek
     */
//      *  Used in updateDisplayList to know when the move day items to the next 'row' for display 
//	*  in theory this is only set by the firstDayOfWeek

	public function get lastDayOfWeek():int
    {
        return _lastDayOfWeek;
    }

    /**
     *  @private
	 * Making this property read only 
     */
    protected function setLastDayOfWeek(value:int):void
    {

        if (value < 0 || value > 6)
            return;

        if (value == _lastDayOfWeek)
            return;

        _lastDayOfWeek = value;
		
		this.redoCalendarData = true;
		this.invalidateProperties();
        dispatchEvent(new Event('lastDayOfWeekChanged'));
    }

	//----------------------------------
	//  leadingTrailingDaysVisible
	//----------------------------------
	/**
	 *  @private
	 *  Storage for the leadingTrailingDaysVisible property.
	 */
	private var _leadingTrailingDaysVisible:Boolean = false; 
	
	[Bindable("leadingTrailingDaysVisibleChanged")]
	[Inspectable(category="Calendar", defaultValue="false", name="Display the Leading and Trailing Days in the Month View",type="Boolean", enumeration="true,false")]
	/**
	 * This is used to determine whether the leading and trailing days should be displayed in the month state.  
	 * 
	 * Leading days are days from the previous month that are included in the week which the current month starts on.  
	 * Trailing days are days in the next month that are included in the week which the current month ends on.
	 * 
	 * @default false
	 */
	public function get leadingTrailingDaysVisible():Boolean
	{
		return _leadingTrailingDaysVisible;
	}
	
	/**
	 *  @private
	 */
	public function set leadingTrailingDaysVisible(value:Boolean):void
	{
		this._leadingTrailingDaysVisible = value;
		this.redoCalendarData = true;
		this.invalidateProperties();
		
		dispatchEvent(new Event("leadingTrailingDaysVisibleChanged"));
		
	}
	

	
    //----------------------------------
    //  monthHeaderVisible
    //  used to specify whether or not the header should be displayed
    // header will include the month, monthSymbol, and potentially forward / next buttons
    //----------------------------------
    /**
     *  @private
	 *  Storage for the headerVisible property.
     */
	private var _monthHeaderVisible:Boolean = true; 

	[Bindable("monthHeaderVisibleChanged")]
	[Inspectable(category="Calendar", defaultValue="true", name="Display the Month Header",type="Boolean", enumeration="true,false")]
    /**
	 * This is used to determine whether the Month Headers should be displayed in the month state.  
	 * 
	 * A month header is an area to display information above the month, such as next and previous buttons the name of the month.  
	 * The header is created by a monthHeaderRenderer, which should be an instance of the IMonthHeader interface.  
	 * 
	 * @default true
	 * 
	 * @see #monthHeaderRenderer
	 * @see com.flextras.calendar.defaultRenderers.MonthHeaderRenderer
     */
    public function get monthHeaderVisible():Boolean
    {
        return _monthHeaderVisible;
    }

    /**
     *  @private
     */
    public function set monthHeaderVisible(value:Boolean):void
    {
        this._monthHeaderVisible = value;
        this.redoCalendarData = true
        this.invalidateProperties();

        dispatchEvent(new Event("monthHeaderVisibleChanged"));

    }

    //----------------------------------
    //  monthHeaderRenderer
    //----------------------------------
    /**
     *  @private
     *  Storage for monthHeaderRenderer property.
     */
    private var _monthHeaderRenderer:IFactory;

	[Bindable("monthHeaderRendererChanged")]
	[Inspectable(category="Calendar", defaultValue="ClassFactory(com.flextras.calendar.defaultRenderers.MonthHeaderRenderer", name="Month Header Renderer",type="IFactory")]
    /**
     *  This is a custom renderer for the month header. 
	 * A month header is an area to display information above the month, such as next and previous buttons the name of the month.  
     * 
     * @default new ClassFactory(com.flextras.calendar.defaultRenderers.MonthHeaderRenderer)
     *
	 * @see #monthHeaderVisible
	 * @see com.flextras.calendar.defaultRenderers.MonthHeaderRenderer
	 * @see com.flextras.calendar.IMonthHeader
     */
    public function get monthHeaderRenderer():IFactory
    {
        return _monthHeaderRenderer;
    }

    /**
     *  @private
     */
    public function set monthHeaderRenderer(value:IFactory):void
    {
        _monthHeaderRenderer = value;

        this.redoCalendarData = true
    	this.invalidateProperties();

        dispatchEvent(new Event("monthHeaderRendererChanged"));
    }

    //----------------------------------
    //  monthNames
    //----------------------------------

    /**
     *  @private
     *  Storage for the monthNames property.
     */
    private var _monthNames:Array = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ];
    
    [Bindable("monthNamesChanged")]
	[Inspectable(category="Localization", arrayType="String", name="Month Name Array")]

    /**
     *  @copy mx.controls.DateChooser#monthNames 
     */
    public function get monthNames():Array
    {
        return _monthNames;
    }

    /**
     *  @private
     */
    public function set monthNames(value:Array):void
    {
        _monthNames = value != null ?
                      value :
                      resourceManager.getStringArray(
                          "SharedResources", "monthNames");
                          
        // _monthNames will be null if there are no resources.
        _monthNames = _monthNames ? monthNames.slice(0) : null;

        this.redoCalendarData = true

        invalidateProperties();
        invalidateSize();
		this.dispatchEvent(new Event('monthNamesChanged'));
    }

    //----------------------------------
    //  monthSymbol
    //----------------------------------
    /**
     *  @private
     *  Storage for the monthSymbol property.
     */
    private var _monthSymbol:String = '';

    [Bindable("monthSymbolChanged")]
	[Inspectable(category="Localization", arrayType="String", defaultValue="", name="Month Symbol")]

    /**
     *  @default ""
     *  @copy mx.controls.DateChooser#monthSymbol 
     */
    public function get monthSymbol():String
    {
        return _monthSymbol;
    }

    /**
     *  @private
     */
    public function set monthSymbol(value:String):void
    {
         _monthSymbol = value != null ?
                       value :
                       resourceManager.getString(
                           "SharedResources", "monthSymbol");

        this.redoCalendarData = true

        invalidateProperties();
		this.dispatchEvent(new Event('monthSymbolChanged'));
    }

    //----------------------------------
    //  nullItemRenderer
    //----------------------------------
    /**
     * 	This property is passed through to your dayRenderer.
     * 
	 *  @default new ClassFactory(mx.controls.Label)
     * @copy mx.controls.listClasses.ListBase#nullItemRenderer 
     */
    override public function get nullItemRenderer():IFactory{
    	return super.nullItemRenderer;
    }
    
    /**
     * @private
     */
    override public function set nullItemRenderer(value:IFactory):void{
    	super.nullItemRenderer = value;
		this.redoCalendarData = true;
		this.invalidateProperties();
    }

	//----------------------------------
	//  objectArrayForTransitions
	//----------------------------------
	/**
	 * @private 
	 */
	private var _objectArrayForTransitions : Array = new Array(0);
	[Bindable("objectArrayForTransitionsChanged")]
	/**
	 * @inheritDoc
	 */ 
	public function get objectArrayForTransitions():Array{
		return this._objectArrayForTransitions;
	}

	/**
	 * @private
	 */
	protected function setObjectArrayForTransitions(value:Array):void{
		this._objectArrayForTransitions = value;
		this.dispatchEvent(new Event('objectArrayForTransitionsChanged'));
	}

	
    //----------------------------------
    //  offscreenExtraRowsOrColumns
    //----------------------------------
	// no inspectable in parent to borrow
    /**
     * 	This property is passed through to your dayRenderer.
     * 
	 *  @default 0
     * @copy mx.controls.listClasses.ListBase#selectable 
     */
    override public function get offscreenExtraRowsOrColumns():int{
    	return super.offscreenExtraRowsOrColumns;
    }
    /**
     * @private
     */
    override public function set offscreenExtraRowsOrColumns(value:int):void
    {
        super.offscreenExtraRowsOrColumns = value;
		this.redoCalendarData = true;
		this.invalidateProperties();

    }

    //----------------------------------
    //  rendererIsEditor
    //----------------------------------

    /**
     *  @private
     *  Storage for the rendererIsEditor property.
     */
    private var _rendererIsEditor:Boolean = false;

	[Bindable(event="rendererIsEditorChanged")]
	[Inspectable(category="Item Editor", defaultValue="false", name="Renderer Is Editor",type="Boolean", enumeration="true,false")]
	/**
     * 	This property is passed through to your dayRenderer.
     * 
	 *  @default false
     * @copy mx.controls.List#rendererIsEditor 
     */
    public function get rendererIsEditor():Boolean
    {
        return _rendererIsEditor;
    }

    /**
     *  @private
     */
    public function set rendererIsEditor(value:Boolean):void
    {
        _rendererIsEditor = value;
    	this.redoCalendarData = true;
    	this.invalidateProperties();
		this.dispatchEvent(new Event('rendererIsEditorChanged'));
    }


    //----------------------------------
    //  selectable
    //----------------------------------
	[Inspectable(defaultValue="true")]
    /**
     * 	This property is passed through to your dayRenderer.
     * 
	 *  @default true
     * @copy mx.controls.listClasses.ListBase#selectable 
     */
     override public function get selectable():Boolean{
     	return super.selectable;
     }
    /**
     * @private
     */
    override public function set selectable(value:Boolean):void
    {
        super.selectable = value;
		this.redoCalendarData = true;
		this.invalidateProperties();

    }

    //----------------------------------
    //  showDataTips
    //----------------------------------
	[Inspectable(category="Data", defaultValue="false")]
    /**
     * 	This property is passed through to your dayRenderer.
     * 
	 *  @default false
     * @copy mx.controls.listClasses.ListBase#showDataTips 
     */
     override public function get showDataTips():Boolean{
     	return super.showDataTips;
     }
    /**
     * @private
     */
    override public function set showDataTips(value:Boolean):void{
        super.showDataTips = value;
		this.redoCalendarData = true;
		this.invalidateProperties();

    }

	
	//----------------------------------
	//  stateChangedBeforeInitalization 
	//----------------------------------
	/**
	 * @private 
	 * variable to tell us that state has changed [from the outside] before the initialization process was finished.
	 * We can't run our "prep for state change" procedures yet because nothing was initialized yet; so we have to do them again on creation complete
	 */
	private var stateChangedBeforeInitalization : Boolean = false
	
	//----------------------------------
	//  weekHeaderVisible
	//----------------------------------
	/**
	 * @private
	 */
	private var _weekHeaderVisible : Boolean= true;
	[Bindable("weekHeaderVisibleChanged")]
	[Inspectable(category="Calendar", defaultValue="true", name="Display the Week Header",type="Boolean", enumeration="true,false")]
	/**
	 * This is used to determine whether the Week Header should be displayed in the week state.  
	 * A week header is an area to display information above the week, such as next and previous buttons the name of the month and the year.  
	 * The header is created by a weekHeaderRenderer, which should be an instance of the IWeekHeader interface.  
	 * 
	 * @default true
	 * 
	 * @see #weekHeaderRenderer
	 * @see com.flextras.calendar.defaultRenderers.WeekHeaderRenderer
	 */
	public function get weekHeaderVisible():Boolean
	{
		return this._weekHeaderVisible;
	}
	
	/**
	 * @private
	 */
	public function set weekHeaderVisible(value:Boolean):void
	{
		this._weekHeaderVisible = value;
		this.redoCalendarData = true
		this.invalidateProperties();
		
		dispatchEvent(new Event("weekHeaderVisibleChanged"));
		
	}
	
	//----------------------------------
	//  weekHeaderRenderer
	//----------------------------------
	/**
	 * @private
	 */
	private var _weekHeaderRenderer : IFactory =  new ClassFactory(WeekHeaderRenderer);
	
	[Bindable("weekHeaderRendererChanged")]
	[Inspectable(category="Calendar", defaultValue="ClassFactory(com.flextras.calendar.defaultRenderers.WeekHeaderRenderer)", name="Week Header Renderer",type="IFactory")]
	/**
	 *  This is a custom renderer for the week header.  
	 * A week header is an area to display information above the week, such as next and previous buttons or the name of the month.  
	 * 
	 * @default ClassFactory(com.flextras.calendar.defaultRenderers.WeekHeaderRenderer)
	 * 
	 * @see #weekHeaderVisible
	 * @see com.flextras.calendar.defaultRenderers.WeekHeaderRenderer
	 */
	public function get weekHeaderRenderer():IFactory{
		return this._weekHeaderRenderer;
	}
	
	/**
	 * @private
	 */
	public function set weekHeaderRenderer(value:IFactory):void{
		this._weekHeaderRenderer = value;
		this.redoCalendarData = true
		this.invalidateProperties();
		
		dispatchEvent(new Event("weekHeaderRendererChanged"));
	}

	//----------------------------------
    //  wordWrap
    //----------------------------------
	[Inspectable(category="General")]
    /**
     * 	This property is passed through to your dayRenderer.
     * 
	 *  @default false
     * @copy mx.controls.listClasses.ListBase#wordWrap 
     * 
     */
     override public function get wordWrap():Boolean{
     	return super.wordWrap;
     }
    /**
     * @private
     */
    override public function set wordWrap(value:Boolean):void
    {
        super.wordWrap = value;
		this.redoCalendarData = true;
		this.invalidateProperties();
    }


    //----------------------------------
    //  variableRowHeight
    //----------------------------------
    /**
     *  @private
     */
    override public function get variableRowHeight():Boolean
    {
        // ignored
        return false;
    }

    /**
     *  @private
     */
    override public function set variableRowHeight(value:Boolean):void
    {
		// ignored
    }


    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
	/**
	 * @private
	 * Internal method used; really should be encapsulated out 
	 * Copied from here: http://livedocs.adobe.com/flex/3/html/help.html?content=10_Lists_of_data_6.html
	 */
	private function clone(source:Object):*
	{
		var myBA:ByteArray = new ByteArray();
		myBA.writeObject(source);
		myBA.position = 0;
		return(myBA.readObject());
	}
	
	
	//----------------------------------
	//  changeDay
	//----------------------------------
	/**
	 *  A method to change the day based on the specified  increment.  
	 * Use a negative value to go back in time or a positive value to go forward.
	 *  Only has an effect if in the DAY_VIEW state.  
	 * 
	 * @param value The increment value used to change the day; the default is 1.
	 * 
	 * @see #DAY_VIEW
	 */
	public function changeDay(value:int = 1):void{
		if(this.currentState == Calendar.DAY_VIEW){
			this.dayDisplay.changeDay(value);
		}
		this.deselectItems();

	}

	//----------------------------------
    //  changeMonth
    //----------------------------------
    /**
     *  A method to change the month based on the specified increment.  
	 * You can use a negative value to go back in time or a positive value to go forward.
	 *  Only has an effect if in the MONTH_VIEW state. 
	 * 
	 * @param value The increment value used to change the month; the default is 1.
	 * 
	 * @see #MONTH_VIEW
     */
    public function changeMonth(value:int = 1):void{
		if(this.currentState == Calendar.MONTH_VIEW){
			this.monthDisplay.changeMonth(value);
		}
		this.deselectItems();
    }
	
	//----------------------------------
	//  changeWeek
	//----------------------------------
	/**
	 * A method to change the week based on the specified increment.  This increments the displayed day by 7 days.
	 * You can use a negative value to go back in time or a positive value to go forward.
	 *  Only has an effect if in the WEEK_VIEW state. 
	 * 
	 * @param value The increment value used to change the week; the default is 1.
	 * 
	 * @see #WEEK_VIEW
	 */
	public function changeWeek(value:int = 1):void{
		if(this.currentState == Calendar.WEEK_VIEW){
			this.weekDisplay.changeWeek(value);
		}
		this.deselectItems();
	}

	/**
	 * @private
	 * A helper function to create the CalendarData Object which is sent to all the dayRender instances
	 */
	protected function createCalendarData():ICalendarDataVO{
		return new CalendarDataVO(this.allowMultipleSelection, this, 
									this.calendarMeasurementVO, 
									this.dataProviderManager,
									this.dataTipField, this.dataTipFunction, 
									this.dayHeaderVisible, this.dayHeaderRenderer,
									this.dayNameHeadersVisible, this.dayNameHeaderRenderer, 
									this.dayNames, this.dayRenderer, 
									this.displayedDate, this.displayedMonth, this.displayedYear,
									this.doubleClickEnabled, 
									this.dragEnabled, 
									this.dragMoveEnabled, 
									this.dropEnabled, 
									this.editable, this.editorDataField, 
									this.editorHeightOffset, this.editorUsesEnterKey, 
									this.editorWidthOffset, this.editorXOffset, 
									this.editorYOffset, 
									this.firstDayOfWeek,
									this.iconField, this.iconFunction, 
									this.imeMode, 
									this.itemEditor, this.itemRenderer, 
									this.labelField, this.labelFunction, 
									this.leadingTrailingDaysVisible, 
									this.monthHeaderVisible, this.monthHeaderRenderer, 
									this.monthNames, this.monthSymbol,
									this.nullItemRenderer, 
									this.offscreenExtraRowsOrColumns, 
								 	this.rendererIsEditor, 
								 	this.selectable, 
								 	this.showDataTips, 
									this.weekHeaderVisible, this.weekHeaderRenderer,
								 	this.wordWrap
								 );
	}

	
	/**
	 * @private
	 * A helper function to create the dayDispay instance and populate it with data
	 */
	protected function createDayDisplay():IDayDisplay{
		var tempDayDisplay : IDayDisplay = new DayDisplay();
		tempDayDisplay.calendarData = this.calendarData;


		tempDayDisplay.addEventListener(CalendarMouseEvent.CLICK_DAY,onDayClickEvent);
		tempDayDisplay.addEventListener(CalendarEvent.CHANGE,onDayListEvent);
		tempDayDisplay.addEventListener(CalendarEvent.ITEM_CLICK,onDayListEvent);
		tempDayDisplay.addEventListener(CalendarEvent.ITEM_DOUBLE_CLICK,onDayListEvent);
		tempDayDisplay.addEventListener(CalendarEvent.ITEM_EDIT_BEGIN,onDayListEvent);
		tempDayDisplay.addEventListener(CalendarEvent.ITEM_EDIT_BEGINNING,onDayListEvent);
		tempDayDisplay.addEventListener(CalendarEvent.ITEM_EDIT_END,onDayListEvent);
		tempDayDisplay.addEventListener(CalendarEvent.ITEM_FOCUS_IN,onDayListEvent);
		tempDayDisplay.addEventListener(CalendarEvent.ITEM_FOCUS_OUT,onDayListEvent);
		tempDayDisplay.addEventListener(CalendarEvent.ITEM_ROLL_OUT,onDayListEvent);
		tempDayDisplay.addEventListener(CalendarEvent.ITEM_ROLL_OVER,onDayListEvent);		
		
		tempDayDisplay.addEventListener(CalendarChangeEvent.EXPAND_DAY,onDayExpand);
		tempDayDisplay.addEventListener(CalendarChangeEvent.EXPAND_MONTH,onMonthExpand);
		tempDayDisplay.addEventListener(CalendarChangeEvent.EXPAND_WEEK,onWeekExpand);
		tempDayDisplay.addEventListener(FlexEvent.CREATION_COMPLETE,onDayDisplayCreationComplete);
		tempDayDisplay.addEventListener(CalendarChangeEvent.NEXT_DAY,onCalendarChangeEvent);
		tempDayDisplay.addEventListener(CalendarChangeEvent.PREVIOUS_DAY,onCalendarChangeEvent);
		tempDayDisplay.addEventListener(CalendarDragEvent.DRAG_COMPLETE_DAY,onDayDragEvent);
		tempDayDisplay.addEventListener(CalendarDragEvent.DRAG_DROP_DAY,onDayDragEvent);
		tempDayDisplay.addEventListener(CalendarDragEvent.DRAG_ENTER_DAY,onDayDragEvent);
		tempDayDisplay.addEventListener(CalendarDragEvent.DRAG_EXIT_DAY,onDayDragEvent);
		tempDayDisplay.addEventListener(CalendarDragEvent.DRAG_OVER_DAY,onDayDragEvent);
		tempDayDisplay.addEventListener(CalendarDragEvent.DRAG_START_DAY,onDayDragEvent);
		
		return tempDayDisplay;
	}
	
	/**
	 * @private
	 * A helper function to create the Calendar.DAY_VIEW state 
	 * @param the day that will be expanded when the view switches into this state; if left blank all instance of the dayRenderer will be removed
	 */
	protected function createDayViewState(dayToExpand : IDayRenderer = null):void{
		// create the new dayState
		dayState = new State();
		dayState.name = Calendar.DAY_VIEW;
		dayState.basedOn = Calendar.DEFAULT_VIEW;

		// creating the state based on month view, o the monthObject must be removed
		this.overrideRemoveMonthDisplayForDay = new RemoveChildExposed(this.monthDisplay as DisplayObject);

		// remove the week display too
		this.overrideRemoveWeekDisplay = new RemoveChildExposed(this.weekDisplay as DisplayObject);
		
		dayState.overrides = [overrideRemoveMonthDisplayForDay ,overrideRemoveWeekDisplay ];

		// set the day state overrides from dayDisplay 
		// may not be created yet here..  :hmmm: 
		// setting them in creationComplete of the dayDisplay is probably a better choice
		if(this.dayDisplay.dayStateOverrides.length > 0){
			this.recreateDayStateOverrides();
		} else { 
			this.dayDisplay.addEventListener(FlexEvent.CREATION_COMPLETE, onDayDisplayCreationCompleteForDayState);
		}

		this.states.push(dayState);
		
	}
	

	/**
	 * @private
	 * A helper function to create the monthDispay instance and populate it with data
	 */
	protected function createMonthDisplay():IMonthDisplay{
		var tempMonthDisplay : MonthDisplay = new MonthDisplay();
		tempMonthDisplay.calendarData = this.calendarData;

		tempMonthDisplay.addEventListener(CalendarEvent.CHANGE,onDayListEvent);
		tempMonthDisplay.addEventListener(CalendarEvent.ITEM_CLICK,onDayListEvent);
		tempMonthDisplay.addEventListener(CalendarEvent.ITEM_DOUBLE_CLICK,onDayListEvent);
		tempMonthDisplay.addEventListener(CalendarEvent.ITEM_EDIT_BEGIN,onDayListEvent);
		tempMonthDisplay.addEventListener(CalendarEvent.ITEM_EDIT_BEGINNING,onDayListEvent);
		tempMonthDisplay.addEventListener(CalendarEvent.ITEM_EDIT_END,onDayListEvent);
		tempMonthDisplay.addEventListener(CalendarEvent.ITEM_FOCUS_IN,onDayListEvent);
		tempMonthDisplay.addEventListener(CalendarEvent.ITEM_FOCUS_OUT,onDayListEvent);
		tempMonthDisplay.addEventListener(CalendarEvent.ITEM_ROLL_OUT,onDayListEvent);
		tempMonthDisplay.addEventListener(CalendarEvent.ITEM_ROLL_OVER,onDayListEvent);		
		
		tempMonthDisplay.addEventListener(CalendarChangeEvent.EXPAND_DAY,onDayExpand);
		tempMonthDisplay.addEventListener(CalendarChangeEvent.EXPAND_MONTH,onMonthExpand);
		tempMonthDisplay.addEventListener(CalendarChangeEvent.EXPAND_WEEK,onWeekExpand);
		tempMonthDisplay.addEventListener(CalendarChangeEvent.NEXT_MONTH,onCalendarChangeEvent);
		tempMonthDisplay.addEventListener(CalendarChangeEvent.NEXT_YEAR,onCalendarChangeEvent);
		tempMonthDisplay.addEventListener(CalendarChangeEvent.PREVIOUS_MONTH,onCalendarChangeEvent);
		tempMonthDisplay.addEventListener(CalendarChangeEvent.PREVIOUS_YEAR,onCalendarChangeEvent);
		tempMonthDisplay.addEventListener(CalendarMouseEvent.CLICK_DAY,onDayClickEvent);
		tempMonthDisplay.addEventListener(CalendarDragEvent.DRAG_COMPLETE_DAY,onDayDragEvent);
		tempMonthDisplay.addEventListener(CalendarDragEvent.DRAG_DROP_DAY,onDayDragEvent);
		tempMonthDisplay.addEventListener(CalendarDragEvent.DRAG_ENTER_DAY,onDayDragEvent);
		tempMonthDisplay.addEventListener(CalendarDragEvent.DRAG_EXIT_DAY,onDayDragEvent);
		tempMonthDisplay.addEventListener(CalendarDragEvent.DRAG_OVER_DAY,onDayDragEvent);
		tempMonthDisplay.addEventListener(CalendarDragEvent.DRAG_START_DAY,onDayDragEvent);

		
		return tempMonthDisplay;
	}

	
	/**
	 * @private
	 * A helper function to create the weekDispay instance and populate it with data
	 */
	protected function createWeekDisplay():IWeekDisplay{
		var tempWeekDisplay : IWeekDisplay = new WeekDisplay();
		tempWeekDisplay.calendarData = this.calendarData;

		tempWeekDisplay.addEventListener(CalendarMouseEvent.CLICK_DAY,onDayClickEvent);
		tempWeekDisplay.addEventListener(CalendarEvent.CHANGE,onDayListEvent);
		tempWeekDisplay.addEventListener(CalendarEvent.ITEM_CLICK,onDayListEvent);
		tempWeekDisplay.addEventListener(CalendarEvent.ITEM_DOUBLE_CLICK,onDayListEvent);
		tempWeekDisplay.addEventListener(CalendarEvent.ITEM_EDIT_BEGIN,onDayListEvent);
		tempWeekDisplay.addEventListener(CalendarEvent.ITEM_EDIT_BEGINNING,onDayListEvent);
		tempWeekDisplay.addEventListener(CalendarEvent.ITEM_EDIT_END,onDayListEvent);
		tempWeekDisplay.addEventListener(CalendarEvent.ITEM_FOCUS_IN,onDayListEvent);
		tempWeekDisplay.addEventListener(CalendarEvent.ITEM_FOCUS_OUT,onDayListEvent);
		tempWeekDisplay.addEventListener(CalendarEvent.ITEM_ROLL_OUT,onDayListEvent);
		tempWeekDisplay.addEventListener(CalendarEvent.ITEM_ROLL_OVER,onDayListEvent);		
		
		
		tempWeekDisplay.addEventListener(CalendarChangeEvent.EXPAND_DAY,onDayExpand);
		tempWeekDisplay.addEventListener(CalendarChangeEvent.EXPAND_MONTH,onMonthExpand);
		tempWeekDisplay.addEventListener(CalendarChangeEvent.EXPAND_WEEK,onWeekExpand);
		tempWeekDisplay.addEventListener(FlexEvent.CREATION_COMPLETE,onWeekDisplayCreationComplete);
		tempWeekDisplay.addEventListener(CalendarChangeEvent.NEXT_WEEK,onCalendarChangeEvent);
		tempWeekDisplay.addEventListener(CalendarChangeEvent.PREVIOUS_WEEK,onCalendarChangeEvent);
		tempWeekDisplay.addEventListener(CalendarDragEvent.DRAG_COMPLETE_DAY,onDayDragEvent);
		tempWeekDisplay.addEventListener(CalendarDragEvent.DRAG_DROP_DAY,onDayDragEvent);
		tempWeekDisplay.addEventListener(CalendarDragEvent.DRAG_ENTER_DAY,onDayDragEvent);
		tempWeekDisplay.addEventListener(CalendarDragEvent.DRAG_EXIT_DAY,onDayDragEvent);
		tempWeekDisplay.addEventListener(CalendarDragEvent.DRAG_OVER_DAY,onDayDragEvent);
		tempWeekDisplay.addEventListener(CalendarDragEvent.DRAG_START_DAY,onDayDragEvent);
		
		return tempWeekDisplay;
	}

	/**
	 * @private
	 * A helper function to create the Calendar.MONTH_VIEW state 
	 */
	protected function createDefaultState():void{
		this.defaultState = new State();
		this.defaultState.name = Calendar.DEFAULT_VIEW;

		if(!this.monthDisplay){
			this.monthDisplay = createMonthDisplay();
		}
		var addMonthDisplay : AddChild = new AddChild(this, this.monthDisplay as DisplayObject);
		
		
		// create and add the Day Display as part of the month State
		if(!this.dayDisplay){
			this.dayDisplay = createDayDisplay();
		}
		var addDayDisplay : AddChild = new AddChild(this, this.dayDisplay as DisplayObject);
		
		// create weekDisplay as part of month State
		if(!this.weekDisplay){
			this.weekDisplay = createWeekDisplay();
		}
		var addWeekDisplay : AddChild = new AddChild(this, this.weekDisplay as DisplayObject);
		
		// add for month state overrides 		
		defaultState.overrides = [addDayDisplay, addWeekDisplay, addMonthDisplay];

		this.recreateObjectArrayForTransitions();
		
		this.states.push(defaultState);

	}

		/**
	 * @private
	 * A helper function to create the Calendar.MONTH_VIEW state 
	 */
	protected function createMonthViewState():void{
		monthState = new State();
		monthState.name = Calendar.MONTH_VIEW;
		monthState.basedOn = Calendar.DEFAULT_VIEW;

		this.states.push(monthState);
	}

	
	
	/**
	 * @private
	 * A helper function to create the Calendar.WEEK_VIEW state 
	 * @param the day that is in the week that will be expanded when the view switches into this state; if left blank all instance of the dayRenderer will be removed
	 */
	protected function createWeekViewState(dayToExpand : IDayRenderer = null):void{
		// create the new dayState
		weekState = new State();
		weekState.name = Calendar.WEEK_VIEW;

		weekState.basedOn = Calendar.DEFAULT_VIEW;
				
		// creating the state based on month view, o the monthObject must be removed
		this.overrideRemoveMonthDisplayForWeek = new RemoveChildExposed(this.monthDisplay as DisplayObject);
		
		weekState.overrides = [this.overrideRemoveMonthDisplayForWeek];
		// make note of the week state override base 
		this.weekStateOverrideBase = [this.overrideRemoveMonthDisplayForWeek];
		
		// set the day state overrides from dayDisplay 
		// may not be created yet here..  :hmmm: 
		// setting them in creationComplete of the dayDisplay is probably a better choice
		if(this.weekDisplay.weekStateOverrides.length > 0){
			this.recreateWeekStateOverrides();
		} else { 
			this.weekDisplay.addEventListener(FlexEvent.CREATION_COMPLETE, onWeekDisplayCreationCompleteForWeekState);
		}
		
		this.states.push(weekState);
		
	}
	
	/**
	 * @private 
	 * method to cause items to be deselected items; just flags clearSelection and invalidates properties; but this is used in abunch of places 
	 */
	protected function deselectItems():void{
		this.clearSelection = true;
		this.invalidateProperties();
	}

	
	
	/**
	 * This method will force the displayed data to update on the next update if you modify the dataProvider.  
	 */
	public function invalidateCalendar():void{
		this.dataProviderChanged = true;
		this.invalidateProperties();
	}

	/** 
	 * @private 
	 * This method takes an object and finds the dayRenderer instance that is currently displaying the item.
	 * Keep in mind that different instances of dayRenderers are used in different states.
	 * I never tested this
	 */
	public function itemToDayRenderer(data:Object):IDayRenderer{
		var resultDay : IDayRenderer;
		if(this.currentState == Calendar.MONTH_VIEW){
			(this.monthDisplay as MonthDisplay).itemToDayRenderer(data);
		}

	
		return resultDay;
	}

	/**
	 *  @private
	 *  Find the appropriate transition to play between two states.
	 * copied from UIComponent
	 */
	private function getTransition(oldState:String, newState:String):IEffect
	{
		var result:IEffect = null;      // Current candidate
		var priority:int = 0;           // Priority     fromState   toState
		//    1             *           *
		//    2           match         *
		//    3             *         match
		//    4           match       match
		
		if (!transitions)
			return null;
		
		if (!oldState)
			oldState = "";
		
		if (!newState)
			newState = "";
		
		for (var i:int = 0; i < transitions.length; i++)
		{
			var t:Transition= transitions[i];
			
			if (t.fromState == "*" && t.toState == "*" && priority < 1)
			{
				result = t.effect;
				priority = 1;
			}
			else if (t.fromState == oldState && t.toState == "*" && priority < 2)
			{
				result = t.effect;
				priority = 2;
			}
			else if (t.fromState == "*" && t.toState == newState && priority < 3)
			{
				result = t.effect;
				priority = 3;
			}
			else if (t.fromState == oldState && t.toState == newState && priority < 4)
			{
				result = t.effect;
				priority = 4;
				
				// Can't get any higher than this, let's go.
				break;
			}
		}
		
		return result;
	}
	
	
	/**
	 * @private
	 * Function to recreate the override array  for the day state
	 * turns out that attemping to update it instead of re-creating from scratch was a nightmare 
	 */
	private function recreateDayStateOverrides(includeMonthDisplay : Boolean = true, includeDayDisplay : Boolean = true, includeWeekDisplay : Boolean = true):void{
		var resultArray : Array = new Array(0);
		
		if(includeMonthDisplay == true){
			resultArray = resultArray.concat(this.overrideRemoveMonthDisplayForDay);
		}
		if(includeWeekDisplay == true){
			resultArray = resultArray.concat(this.overrideRemoveWeekDisplay);
		}

		if((includeDayDisplay == true) && (this.dayDisplay.dayStateOverrides.length > 0)){
			resultArray = resultArray.concat(this.dayDisplay.dayStateOverrides);
		}
		
		dayState.overrides = resultArray;
	}
	
	/**
	 * @private
	 * Helper function to recreate creating the Object Array for transitions.  This will automatically add the monthDisplay, dayDisplay, and 
	 * weekdisplay, along with dayDisplay.objectArrayForTransitions and weekDisplay.objectArrayForTransitions
	 * 
	 */
	protected function recreateObjectArrayForTransitions(includeMonthDisplay : Boolean =true, includeDayDisplay : Boolean = true, includeWeekDisplay : Boolean = true):void{
		var results : Array = new Array(0);
		if(includeMonthDisplay == true){
			results = results.concat(this.monthDisplay);	
		}
			
		if((includeWeekDisplay == true) && (this.weekDisplay)){
			results = results.concat(this.weekDisplay)
			results = results.concat(this.weekDisplay.objectArrayForTransitions );
			
		}
		if((includeDayDisplay == true) && (this.dayDisplay)){
			results = results.concat(this.dayDisplay)
			results = results.concat(this.dayDisplay.objectArrayForTransitions );
		}
		setObjectArrayForTransitions(results);
	}
	
	/**
	 * @private
	 * Function to recreate the override array  for the week state
	 * turns out that attemping to update it instead of re-creating from scratch was a nightmare 
	 */
	private function recreateWeekStateOverrides(includeWeekDisplay : Boolean = true):void{
		var resultArray : Array = new Array(0);
		// add for month state overrides 		
		resultArray = this.weekStateOverrideBase;
		
		if((includeWeekDisplay == true) && (this.weekDisplay.weekStateOverrides.length > 0)){
			resultArray = resultArray.concat(this.weekDisplay.weekStateOverrides);
		}
		
		weekState.overrides = resultArray;
	}

	
	/**
	 * This method is a helper function for changing the current state.  It allows you to specify a date object.
	 * 
	 * @param nextState This argument specifies the state you want to change to.  Most likely this value will be Calendar.MONTH_VIEW, Calendar.WEEK_VIEW, or Calendar.DAY_VIEW.
	 * @param date This argument specifies the date to change the component to before the state change.  If not specified, the current displayedDatObject won't be changed.
	 * 
	 */
	public function changeState(nextState : String, date : Date = null):void{
		if(date){
			this.displayedDate = date.date;
			this.displayedYear = date.fullYear;
			this.displayedMonth = date.month;
		}
		this.currentState = nextState;
	}
	
	/**
	 * @private
	 * Helper function for switching position of the Day and Month 
	 * used in relation to transitions between day view to month view 
	 */
	protected function swapChildrenForStateChange(monthDisplayVisible : Boolean, dayDisplayVisible : Boolean, weekDisplayVisible : Boolean ,compToBringToFront : DisplayObject):void{
		if(compToBringToFront.parent != this){
			this.addChild(compToBringToFront as DisplayObject);
		}
		
		this.setChildIndex(compToBringToFront, this.numChildren-1);

		// hide the week as to not mess up the display
		if(this.monthDisplay.visible != monthDisplayVisible){
			this.monthDisplay.visible = monthDisplayVisible;
		}
		if(this.dayDisplay.visible != dayDisplayVisible){
			this.dayDisplay.visible = dayDisplayVisible;
		}
		if(this.weekDisplay.visible != weekDisplayVisible){
			this.weekDisplay.visible = weekDisplayVisible;
		}
	}
	
	/**
	 * @private
	 * Helper function to recreate creating the Object Array for transitions.  This will automatically add the monthDisplay, dayDisplay, and 
	 * weekdisplay, along with dayDisplay.objectArrayForTransitions and weekDisplay.objectArrayForTransitions
	 * 
	 */
	protected function updateObjectArrayForTransitions(extraObjects : Array):void{
		var results : Array = this.objectArrayForTransitions;
		results = results.concat( extraObjects );
		setObjectArrayForTransitions(results);
	}
	
    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     * For the moment, this is essentially commented out because people don't do drag drop w/ the Calendar, they do dragDrop in the days
     */
    override protected function dragCompleteHandler(event:DragEvent):void{
    } 
    /**
     * @private
     * For the moment, this is essentially commented out because people don't do drag drop w/ the Calendar, they do dragDrop in the days
     */
    override protected function dragDropHandler(event:DragEvent):void{
    }
    /**
     * @private
     * For the moment, this is essentially commented out because people don't do drag drop w/ the Calendar, they do dragDrop in the days
     */
    override protected function dragEnterHandler(event:DragEvent):void{
    }
    /**
     * @private
     * For the moment, this is essentially commented out because people don't do drag drop w/ the Calendar, they do dragDrop in the days
     */
    override protected function dragExitHandler(event:DragEvent):void{
    }
    /**
     * @private
     * For the moment, this is essentially commented out because people don't do drag drop w/ the Calendar, they do dragDrop in the days
     */
    override protected function dragOverHandler(event:DragEvent):void{
    }
    /**
     * @private
     * For the moment, this is essentially commented out because people don't do drag drop w/ the Calendar, they do dragDrop in the days
     */
    override protected function dragStartHandler(event:DragEvent):void{
    }
	
	/**
	 * @private
	 * added for transparency purposes
	 */
	protected function onCreationComplete(event:FlexEvent):void{
		this.weekDisplay.visible = false;
		this.dayDisplay.visible = false; 
	}
	
	
	/**
	 * @private
	 * added for transparency purposes
	 */
	protected function onCreationCompleteStateChange(event:FlexEvent):void{
		this.currentState = this.requestedCurrentState;
		this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompleteStateChange);
	}
		
	
	/**
	 * @private
	 * Default handler for calendar change events from the DayDisplay or MonthDisplay.
	 * It modifies the displayedYear, displayedMonth, and displayedDate and dispatches a new CalendarChangeEvent.
	 */
	protected function onCalendarChangeEvent(event:CalendarChangeEvent):void{
		// the calendarData is updated in either the dayDisplay or monthDisplay component; 
		// be sure to update the exposed variables
		this.displayedYear = this.calendarData.displayedYear;
		this.displayedMonth = this.calendarData.displayedMonth;
		this.displayedDate = this.calendarData.displayedDate;
		
		// must create a clone of the event for the redispatch because otherwise
		// the cancel event is not propogated back down; how odd
		var newEvent : CalendarChangeEvent = event.clone() as CalendarChangeEvent;
		this.dispatchEvent(newEvent);		
	}
	
	
	/**
	 * A helper function for updating the Calendar after the dataProvider is modified.
	 */
	protected function onDataProviderChange(event:CollectionEvent):void{
		this.invalidateCalendar();
	}

	/**
	 * @private
	 * A way to update the objectArrayForTransitions with the dayDisplay objects
	 */
	protected function onDayDisplayCreationComplete(event:FlexEvent):void{
		var changeArray : Array = new Array();
		changeArray = changeArray.concat(this.dayDisplay.objectArrayForTransitions);
		updateObjectArrayForTransitions(changeArray);
		
		this.dayDisplay.removeEventListener(FlexEvent.CREATION_COMPLETE,onDayDisplayCreationComplete);
	}
		
	/**
	 * @private
	 * A way to update the dayState overrides after the dayDisplay is created
	 */
	protected function onDayDisplayCreationCompleteForDayState(event:FlexEvent):void{
		this.recreateDayStateOverrides();
		this.dayDisplay.removeEventListener(FlexEvent.CREATION_COMPLETE,onDayDisplayCreationCompleteForDayState);
	}
	
	
	/**
	 * @private
	 * A way to update the objectArrayForTransitions with the weekDisplay objects
	 */
	protected function onWeekDisplayCreationComplete(event:FlexEvent):void{
		var changeArray : Array = new Array();
		changeArray = changeArray.concat(this.weekDisplay.objectArrayForTransitions);
		updateObjectArrayForTransitions(changeArray);
		
		this.weekDisplay.removeEventListener(FlexEvent.CREATION_COMPLETE,onWeekDisplayCreationComplete);
	}
	
	/**
	 * @private
	 * A way to update the weekState overrides after the weekDisplay is created
	 */
	protected function onWeekDisplayCreationCompleteForWeekState(event:FlexEvent):void{
		this.recreateWeekStateOverrides();
		this.weekDisplay.removeEventListener(FlexEvent.CREATION_COMPLETE,onWeekDisplayCreationCompleteForWeekState);
	}
	
	/**
	 * @private 
	 * A default handler for the CalendarMouseEvent being propogated up from the dayRenderer.
	 * This will handle the multiple selection, if needed.  
	 * 
	 * If applicable this will redispatch the event
	 * 
	 * @param e The CalendarMouseEvent
	 * 
	 */
	protected function onDayClickEvent(e:CalendarMouseEvent):void{
		// this event bubbles; so we don't need to re-dispatch it 
//		var newEvent : CalendarMouseEvent = e.clone() as CalendarMouseEvent;
//		this.dispatchEvent(newEvent);

//		if(newEvent.isDefaultPrevented()){
//			e.preventDefault();
//			return;
//		}
		
		// if no itemRenderer in the event then they didn't click on something that is selectable
		// make no change to selecteditem properties 
		if(e.itemRenderer){
			if((this.calendarData.allowMultipleSelection == false) ) {
				// set the selectedIndex, selectedIndices, selectedItem, and selectedItems
				this.selectedItem = e.list.selectedItem;
			} else {
				this.selectedItems = e.selectedItems;
			}
			
		}

		
		
	}

	/**
	 * @private
	 * This is a generic handler to handle CalendarDragEvents dispatched from a dayRenderer.  
	 * It will redispatch those to the parent object.
	 * 
	 * @param e The CalendarDragEvent
	 * 
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
		
		// In normal circumstances drag drop; or drag complete events may update the dataProvider
		// if that happens; we call the super handlers to address those issues
		// we'll also need to update the dataProviderManager 
		switch (e.type){
			case CalendarDragEvent.DRAG_DROP_DAY:
				super.dragDropHandler(e);
			break;
			case CalendarDragEvent.DRAG_COMPLETE_DAY:
				super.dragCompleteHandler(e);
				// JH DotComIt 5/26/2011
				// if the item is dragged off the Calendar; we need to remove it from the Calendar's dataProvider.
				if(e.action == DragManager.MOVE){
					// if the thing that started the drag was the Calendar; then we want to update the Calendar's dataProvider
					if(!isDropTargetThis(e.dragEvent.relatedObject)){
						for each (var format : String in e.dragSource.formats){
							// this gets an array of allt he items being dragged
							var objectsBeingDragged : Array = e.dragSource.dataForFormat(format) as Array;
							// in this sample the only formats are "items" (AKA Objects), but if you're dataProvider uses something different
							// you'll need to write code to handle that
							for each (var object : Object in objectsBeingDragged){
								// if we are copying a single item the element was added to the last item as the dataProvider; 
								// so update it in that way 
								var dp : ListCollectionView = this.dataProvider as ListCollectionView;
								dp.removeItemAt(dp.getItemIndex(object ));  
							} 				
							
						}						
					}
//					}
					
				}
			break;
		}
		
	}

	
	/**
	 * @private 
	 * A helper function to determine if the parent of the related object is this Calendar
	 */
	protected function isDropTargetThis(relatedObject : Object ):Boolean{
		if(!relatedObject.parent){
			return false;
		} else if (relatedObject.parent == this){
			return true;
		} else {
			return isDropTargetThis(relatedObject.parent);
		}
		
		return false;
	}

	/**
	 * @private
	 * This is a default handler to handle the day expanding and deal with related transition issues 
	 */
	protected function onDayExpand(e:CalendarChangeEvent):void{
		this.internalStateChange = true;
		this.deselectItems();

		this.dayDisplay.invalidateDay();
		if(this.currentState == Calendar.MONTH_VIEW){
			
			// unselect all items in prep for state change 
			this.clearSelected();
			
			this.recreateObjectArrayForTransitions(true,true,false);
			this.recreateDayStateOverrides(true, true, false);

			// in some sitautions, such as moving towards a date not currently displayed via the changeState() method, 
			// the dayToExpand may not be defined
			if(e.dayToExpand){
				
			// update the displayed date property
			this.displayedMonth = e.dayToExpand.dayData.displayedDateObject.month;
			this.displayedYear = e.dayToExpand.dayData.displayedDateObject.fullYear;
			this.displayedDate = e.dayToExpand.dayData.date;
			
			this.dayDisplay.setupStateChange(e.dayToExpand.x,e.dayToExpand.y, 
						new Date(this.calendarData.displayedYear, this.calendarData.displayedMonth, this.calendarData.displayedDate), 
						true, this.currentState );
			}

			if(this.cachedStateTransitionEffect){
				this.cachedStateTransitionEffect.addEventListener(EffectEvent.EFFECT_END , onMonthMinimizeToDayExpandTransitionEffectEnd);
			}
			
			// layer the day on top of the month 
			this.setChildIndex(this.monthDisplay as DisplayObject, this.numChildren-1);
			this.swapChildrenForStateChange(true, true, false, this.dayDisplay as DisplayObject);
			
			this.currentState = Calendar.DAY_VIEW;
			
			// added to handle transparency issues 
			if(!this.cachedStateTransitionEffect){
				this.swapChildrenForStateChange(false, true, false, this.dayDisplay as DisplayObject);
			} 
			
			
		} else if (this.currentState == Calendar.WEEK_VIEW){

			// unselect all items in prep for state change 
			this.clearSelected();

			this.recreateObjectArrayForTransitions(false,true,true);
			this.recreateDayStateOverrides();
			// if using the changeState method with a date set to some future date not currently displayed, the dayToExpand will be null
			// so perform the check below 
			if(e.dayToExpand){
				
			// update the displayed date property
			this.displayedMonth = e.dayToExpand.dayData.displayedDateObject.month;
			this.displayedYear = e.dayToExpand.dayData.displayedDateObject.fullYear;
			this.displayedDate = e.dayToExpand.dayData.date;
			
			this.dayDisplay.setupStateChange(e.dayToExpand.x,e.dayToExpand.y,
						new Date(this.calendarData.displayedYear, this.calendarData.displayedMonth, this.calendarData.displayedDate),
						true, this.currentState );
			}

			
			// need to add the week back to the stage once the effect is over
			// it'll be invisible and added to the back; but if we don't do this there is an 
			// odd display piece
			this.cachedStateTransitionEffect = getTransition(this.currentState, Calendar.DAY_VIEW);
			if(this.cachedStateTransitionEffect){
				this.cachedStateTransitionEffect.addEventListener(EffectEvent.EFFECT_END , onWeekMinimizeToDayExpandTransitionEffectEnd);
			}

			this.swapChildrenForStateChange(false, true, true, this.dayDisplay as DisplayObject);
			
			this.currentState = Calendar.DAY_VIEW 

			if(!this.cachedStateTransitionEffect){
				this.addChildAt(this.weekDisplay as DisplayObject, 0);
				// added this to handle transparency issues; 
				this.weekDisplay.visible = false;
			}
		}
		// else if in day view; do nothing
		if(e.dayToExpand){
		this.displayedDate = e.dayToExpand.dayData.displayedDateObject.date;
		this.displayedMonth = e.dayToExpand.dayData.displayedDateObject.month;
		this.displayedYear = e.dayToExpand.dayData.displayedDateObject.fullYear;
		}
		
		
		// must create a clone of the event for the redispatch because otherwise
		// the cancel event is not propogated back down; how odd
		var newEvent : CalendarChangeEvent = e.clone() as CalendarChangeEvent;
		this.dispatchEvent(newEvent);		
		
		this.internalStateChange = false;
	}

	
	/**
	 * @private 
	 * This is a default handler to handle the month expanding and deal with related transition issues 
	 */
	protected function onMonthExpand(e:CalendarChangeEvent):void{
		this.internalStateChange = true;
		this.deselectItems();

		if(this.currentState == Calendar.DAY_VIEW){
			// unselect all items in prep for state change 
			this.clearSelected();

			this.recreateObjectArrayForTransitions(true,true,false);
			this.recreateDayStateOverrides(true, true, false);
			this.cachedStateTransitionEffect = getTransition(this.currentState, Calendar.MONTH_VIEW);
			if(this.cachedStateTransitionEffect){
				this.cachedStateTransitionEffect.addEventListener(EffectEvent.EFFECT_END , onDayMinimizeMonthExpandTransitionEffectEnd);
			} 
			
			// in some sitautions, such as using the changeState to change to a date not currently displayed, dayToExpand may be null
			// this prevents errors.  move/resize Transitions won't work right in these situations, though
			if(e.dayToExpand){
			this.dayDisplay.setupReverseStateChange( Calendar.MONTH_VIEW, e.dayToExpand.dayData.displayedDateObject);
			}

			// Odd situation when going from month to day to week to day to month
			// where the month isn't on the stage.  Gotta make sure the override knows that.
			if(overrideRemoveMonthDisplayForDay.removed == false){
				overrideRemoveMonthDisplayForDay.removed = true;
				overrideRemoveMonthDisplayForDay.oldParent = this;
			}
			
			if(!this.cachedStateTransitionEffect){
				this.swapChildrenForStateChange(true, true, false, this.monthDisplay as DisplayObject);
			} else {
				this.monthDisplay.visible = true;
				this.dayDisplay.visible = true;
				this.weekDisplay.visible = false;
			}
			
			this.currentState = Calendar.MONTH_VIEW;
			if(!this.cachedStateTransitionEffect){
//				this.swapChildrenForStateChange(true, true, false, this.monthDisplay as DisplayObject);
				// modified to handle state change issues when using transparency 
				this.swapChildrenForStateChange(true, false, false, this.monthDisplay as DisplayObject);
			} 

		} else if(this.currentState == Calendar.WEEK_VIEW){
			// unselect all items in prep for state change 
			this.clearSelected();
			
			this.recreateObjectArrayForTransitions(true,false,true);

			
			// in some sitautions, such as using the changeState to change to a date not currently displayed, dayToExpand may be null
			// this prevents errors.  move/resize Transitions won't work right in these situations, though
			if(e.dayToExpand){
			// if we do month to day to week to month; the week to month is off because we haven't set the month state change yet
			this.weekDisplay.setupStateChange(this.calendarData.calendarMeasurements.monthDayHeight,
				e.dayToExpand.y,e.dayToExpand.dayData.displayedDateObject ,false, Calendar.MONTH_VIEW, this.calendarData.calendarMeasurements.monthHeaderHeight );
			}			
			// re-create the state overrides; because if the week had changed while in the week view
			// the days that we add and remove may have also changed 
			this.recreateWeekStateOverrides();
			// if the AddChild state instance for monthDisplay thinks it's mx_internal value is false; we need to swap it to true
			// situation seems to occur if we do week to day to week then month
			if(overrideRemoveMonthDisplayForWeek.removed == false){
				overrideRemoveMonthDisplayForWeek.removed = true;
				overrideRemoveMonthDisplayForWeek.oldParent = this;
			}
			
			this.cachedStateTransitionEffect = getTransition(this.currentState, Calendar.MONTH_VIEW);
			if(this.cachedStateTransitionEffect){
				this.cachedStateTransitionEffect.addEventListener(EffectEvent.EFFECT_END , onWeekMinimizeMonthExpandTransitionEffectEnd);
				this.inWeekToMonthStateChange = true;
			} 

//			this.displayedDate = e.dayToExpand.dayData.displayedDateObject.date;
//			this.displayedMonth = e.dayToExpand.dayData.displayedDateObject.month;
//			this.displayedYear = e.dayToExpand.dayData.displayedDateObject.fullYear;
			this.currentState = Calendar.MONTH_VIEW;
			
			if(!this.cachedStateTransitionEffect){
//				this.swapChildrenForStateChange(true, false, true, this.monthDisplay as DisplayObject);
				// modified to handle state change issues when transparency is in effect 
				this.swapChildrenForStateChange(true, false, false, this.monthDisplay as DisplayObject);
			} else {
				this.monthDisplay.visible = true;
				this.dayDisplay.visible = false;
				this.weekDisplay.visible = true;
			}

		}
		// else if in month view; do nothing

		// in some sitautions, such as using the changeState to change to a date not currently displayed, dayToExpand may be null
		// this prevents errors.  move/resize Transitions won't work right in these situations, though
		if(e.dayToExpand){
		this.displayedDate = e.dayToExpand.dayData.displayedDateObject.date;
		this.displayedMonth = e.dayToExpand.dayData.displayedDateObject.month;
		this.displayedYear = e.dayToExpand.dayData.displayedDateObject.fullYear;
		}
		this.monthDisplay.invalidateDays();
	
		// must create a clone of the event for the redispatch because otherwise
		// the cancel event is not propogated back down; how odd
		var newEvent : CalendarChangeEvent = e.clone() as CalendarChangeEvent;
		this.dispatchEvent(newEvent);		
		
		this.internalStateChange = false;
		
	}
	/**
	 * @private
	 * This is a default handler to handle the week expanding and deal with related transition issues 
	 */
	protected function onWeekExpand(e:CalendarChangeEvent):void{
		this.internalStateChange = true;
		this.deselectItems();

		this.weekDisplay.invalidateWeek();
		if(this.currentState == Calendar.MONTH_VIEW){
			// unselect all items in prep for state change 
			this.clearSelected();
			
			this.recreateObjectArrayForTransitions(true,false,true);
			// in some sitautions, such as using the changeState to change to a date not currently displayed, dayToExpand may be null
			// this prevents errors.  move/resize Transitions won't work right in these situations, though
			if(e.dayToExpand){
			// update the displayed date property
			this.displayedMonth = e.dayToExpand.dayData.displayedDateObject.month;
			this.displayedYear = e.dayToExpand.dayData.displayedDateObject.fullYear
			this.displayedDate = e.dayToExpand.dayData.date;
			this.weekDisplay.setupStateChange(e.dayToExpand.height,
							e.dayToExpand.y,e.dayToExpand.dayData.displayedDateObject ,true, Calendar.WEEK_VIEW, this.calendarData.calendarMeasurements.monthHeaderHeight );
			}			
			// update week overrides
			this.recreateWeekStateOverrides();

			if(this.cachedStateTransitionEffect){
				this.cachedStateTransitionEffect.addEventListener(EffectEvent.EFFECT_END , onMonthMinimizeToWeekTransitionEffectEnd);
			}
			
			this.swapChildrenForStateChange(true, false, true, this.weekDisplay as DisplayObject);
			
			this.currentState = Calendar.WEEK_VIEW 
			
			// added to handle transparency issues 
			if(!this.cachedStateTransitionEffect){
				this.swapChildrenForStateChange(false, false, true, this.weekDisplay as DisplayObject);
			} 
				
				
		} else if(this.currentState == Calendar.DAY_VIEW){
			// unselect all items in prep for state change 
			this.clearSelected();
			
			this.recreateObjectArrayForTransitions(false,true,true);
			this.recreateDayStateOverrides(false, true, true);

			// if we go from month to day to week 
			// then we get an error w/ the addChild instace that adds the weekHeader
			// addChild instance thinks it is not added, but it is
			// makes sense--in this situation--for us to swap the added flag inside the addChild instance
			// still need the addChild weekHeader instance for moving back and forth between week and month 

			
			// in some sitautions, such as using the changeState to change to a date not currently displayed, dayToExpand may be null
			// this prevents errors.  move/resize Transitions won't work right in these situations, though
			if(e.dayToExpand){
			// update the displayed date property
			this.displayedMonth = e.dayToExpand.dayData.displayedDateObject.month;
			this.displayedYear = e.dayToExpand.dayData.displayedDateObject.fullYear
			this.displayedDate = e.dayToExpand.dayData.date;
			}
			this.cachedStateTransitionEffect = getTransition(this.currentState, Calendar.WEEK_VIEW);
			if(this.cachedStateTransitionEffect){
				this.cachedStateTransitionEffect.addEventListener(EffectEvent.EFFECT_END , onDayMinimizeToWeekTransitionEffectEnd);

				// if week is added to stage; remove it 
				// so that it can be added back in as part of the state change 
				if(this.weekDisplay.parent){
					this.removeChild(this.weekDisplay as DisplayObject);
					this.overrideRemoveWeekDisplay.removed = true;
					this.overrideRemoveWeekDisplay.oldParent = this;
				}
				
			} 
			
			// in some sitautions, such as using the changeState to change to a date not currently displayed, dayToExpand may be null
			// this prevents errors.  move/resize Transitions won't work right in these situations, though
			if(e.dayToExpand){
			this.weekDisplay.setupStateChange(e.dayToExpand.height,
				e.dayToExpand.y,e.dayToExpand.dayData.displayedDateObject ,true, Calendar.WEEK_VIEW, this.calendarData.calendarMeasurements.weekHeaderHeight );
			}
			this.dayDisplay.setupReverseStateChange( Calendar.WEEK_VIEW);
			
			this.recreateWeekStateOverrides(true);
			
			
			if(!this.cachedStateTransitionEffect){
				this.swapChildrenForStateChange(false, true, true, this.weekDisplay as DisplayObject);
				this.removeChild(this.dayDisplay as DisplayObject);
			} else {
				this.monthDisplay.visible = false;
				this.dayDisplay.visible = true;
				this.weekDisplay.visible = true;
			}			

			this.currentState = Calendar.WEEK_VIEW;

			// added to handle transparency issues 
			if(!this.cachedStateTransitionEffect){
				this.swapChildrenForStateChange(false, false, true, this.weekDisplay as DisplayObject);
			} 
			
		}
		// else if in WEEK_VIEW do nothing 

		if(this.currentState != Calendar.WEEK_VIEW){
			
			// in some sitautions, such as using the changeState to change to a date not currently displayed, dayToExpand may be null
			// this prevents errors.  move/resize Transitions won't work right in these situations, though
			if(e.dayToExpand){
			this.displayedDate = e.dayToExpand.dayData.displayedDateObject.date;
			this.displayedMonth = e.dayToExpand.dayData.displayedDateObject.month;
			this.displayedYear = e.dayToExpand.dayData.displayedDateObject.fullYear;
		}
		}

		
		// must create a clone of the event for the redispatch because otherwise
		// the cancel event is not propogated back down; how odd
		var newEvent : CalendarChangeEvent = e.clone() as CalendarChangeEvent;
		this.dispatchEvent(newEvent);		
		
		this.internalStateChange = false;
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
		// set the read only editedItemRenderer property if this is an itemEditor event

		switch (e.type) {
			
			case CalendarEvent.ITEM_EDIT_BEGIN:
				// set the itemEditorInstance 
				if(e.list.hasOwnProperty('itemEditorInstance')){
					this._itemEditorInstance = e.list['itemEditorInstance'];
				}
				this.setEditedItemRenderer(e.itemRenderer);
				
				break;
			case CalendarEvent.ITEM_EDIT_END:
				// reset the itemEditorInstance 
				this._itemEditorInstance = null;
				this.setEditedItemRenderer(null);
				
				break;
			
			default:
				// nothing
		}

		
		// must create a clone of the event for the redispatch because otherwise
		// the cancel event is not propogated back down; how odd
		var newEvent : CalendarEvent = e.clone() as CalendarEvent;
		this.dispatchEvent(newEvent);

		if(newEvent.isDefaultPrevented()){
			e.preventDefault();
			return;
		}
	}

	/**
	 * @private
	 * Used for swap in effect from day to week
	 */
	protected function onDayMinimizeToWeekTransitionEffectEnd(e:EffectEvent):void{
//		this.swapChildrenForStateChange(false, true, true, this.weekDisplay as DisplayObject);
		// modded for transparency support 
		this.swapChildrenForStateChange(false, false, true, this.weekDisplay as DisplayObject);
		this.removeChild(this.dayDisplay as DisplayObject);

		cachedStateTransitionEffect.removeEventListener(EffectEvent.EFFECT_END , onDayMinimizeToWeekTransitionEffectEnd);
	}

	/**
	 * @private
	 * Used for swap after effect from day to month
	 */
	protected function onDayMinimizeMonthExpandTransitionEffectEnd(e:EffectEvent):void{
//		this.swapChildrenForStateChange(true, true, false, this.monthDisplay as DisplayObject);
		// changed for transparency support
		this.swapChildrenForStateChange(true, false, false, this.monthDisplay as DisplayObject);
		cachedStateTransitionEffect.removeEventListener(EffectEvent.EFFECT_END , onDayMinimizeMonthExpandTransitionEffectEnd);
	}
	
	/**
	 * @private 
	 * added strictly for transparency hadnling 
	 */
	protected function onMonthMinimizeToDayExpandTransitionEffectEnd(e:EffectEvent):void{
		this.swapChildrenForStateChange(false, true, false, this.dayDisplay as DisplayObject);
		cachedStateTransitionEffect.removeEventListener(EffectEvent.EFFECT_END , onMonthMinimizeToDayExpandTransitionEffectEnd);
		
	}

	/**
	 * @private 
	 * Created for transparency handling 
	 */
	protected function onMonthMinimizeToWeekTransitionEffectEnd(e:EffectEvent):void{
		this.swapChildrenForStateChange(false, false, false, this.dayDisplay as DisplayObject);
		cachedStateTransitionEffect.removeEventListener(EffectEvent.EFFECT_END , onMonthMinimizeToWeekTransitionEffectEnd);
	}

	

	/**
	 * @private
	 */
	protected function onStateChanging(event:StateChangeEvent):void{
		this.inWeekToMonthStateChange = true;
	}
	/**
	 * @private
	 */
	protected function onStateChanged(event:StateChangeEvent):void{
		this.inWeekToMonthStateChange = false;
	}	
	
	/**
	 * @private
	 * Used for swap after transition is complete
	 */
	protected function onWeekMinimizeMonthExpandTransitionEffectEnd(e:EffectEvent):void{
//		this.swapChildrenForStateChange(true, false, true, this.monthDisplay as DisplayObject);
		// making mods for transparency purposes
		this.swapChildrenForStateChange(true, false, false, this.monthDisplay as DisplayObject);
		cachedStateTransitionEffect.removeEventListener(EffectEvent.EFFECT_END , onWeekMinimizeMonthExpandTransitionEffectEnd);
		this.inWeekToMonthStateChange = false;

	}

	
	/**
	 * @private
	 * Used for swap after transition is complete
	 */
	protected function onWeekMinimizeToDayExpandTransitionEffectEnd(e:EffectEvent):void{
		this.addChildAt(this.weekDisplay as DisplayObject, 0);
		// This Line added this to handle transparency issues; 
		this.weekDisplay.visible = false;

		this.cachedStateTransitionEffect.removeEventListener(EffectEvent.EFFECT_END , onWeekMinimizeToDayExpandTransitionEffectEnd);
	}
	
		
	}
}