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
	import com.flextras.calendar.defaultRenderers.DayHeaderRenderer;
	import com.flextras.calendar.defaultRenderers.DayNameHeaderRenderer;
	import com.flextras.calendar.defaultRenderers.DayRenderer;
	import com.flextras.calendar.defaultRenderers.MonthHeaderRenderer;
	import com.flextras.calendar.defaultRenderers.WeekHeaderRenderer;
	import com.flextras.calendar.utils.DataProviderManager;
	
	import mx.controls.Label;
	import mx.controls.TextInput;
	import mx.controls.listClasses.ListItemRenderer;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.IUIComponent;
	import mx.resources.ResourceManager;
	
	[Bindable]
	/**
	 * This is an implementation of the ICalendarDataVO interface for use with the Flextras Calendar class.
	 * 
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.ICalendarDataVO
	 * @see com.flextras.calendar.Calendar
	 */
	public class CalendarDataVO implements ICalendarDataVO
	{
		// holy argument list batman; that looks like hell in ASDocs. I suspect the Riddler! 
		/**
		 *  Constructor.
		 */
		public function CalendarDataVO(allowMultipleSelection : Boolean = false,  calendar:IUIComponent = null,
									   	calendarMeasurements : CalendarMeasurementsVO = null,
										dataProviderManager : DataProviderManager = null,
										dataTipField : String = null, dataTipFunction : Function = null,
										dayHeaderVisible : Boolean = true, dayHeaderRenderer : IFactory = null,
										dayNameHeadersVisible : Boolean = true, dayNameHeaderRenderer : IFactory = null,
										dayNames : Array = null, dayRenderer : IFactory = null,
										displayedDate : Number = NaN, displayedMonth : Number = NaN, displayedYear : Number = NaN,
										doubleClickEnabled : Boolean = false,
										dragEnabled : Boolean = false,
										dragMoveEnabled : Boolean = false,
										dropEnabled : Boolean = false,
										editable : Boolean=false, editorDataField : String = 'text', 
										editorHeightOffset : Number = 0, editorUsesEnterKey : Boolean = false,
										editorWidthOffset : Number = 0, editorXOffset :Number = 0,
										editorYOffset : Number = 0, 
										firstDayOfWeek : int = 0,
										iconField : String = null, iconFunction : Function = null, 
										imeMode : String = null,
										itemEditor : IFactory = null, itemRenderer : IFactory = null, 
										labelField : String =  "label", labelFunction : Function = null,
										leadingTrailingDaysVisible :Boolean = false,
										monthHeaderVisible :Boolean = true, monthHeaderRenderer : IFactory = null,
										monthNames : Array = null, monthSymbol : String = '',
										nullItemRenderer : IFactory = null,
										offscreenExtraRowsOrColumns : int = 0,
										rendererIsEditor : Boolean = false,
										selectable : Boolean = true,					
										showDataTips : Boolean = false,
										weekHeaderVisible : Boolean = true, weekHeaderRenderer : IFactory = null,
										wordWrap : Boolean = false
										):void
		{




			this.allowMultipleSelection = allowMultipleSelection;
			this.calendar = calendar;
			if(calendarMeasurements){
				this.calendarMeasurements = calendarMeasurements;
			}
			this.dataProviderManager = dataProviderManager;
			this.dataTipField = dataTipField;
			this.dataTipFunction = dataTipFunction;
			this.dayHeaderVisible = dayHeaderVisible;
			if(dayHeaderRenderer){
				this.dayHeaderRenderer = dayHeaderRenderer;
			} else {
				this.dayHeaderRenderer = new ClassFactory(DayHeaderRenderer);
			}

			this.dayNameHeadersVisible = dayNameHeadersVisible;

			if(dayNameHeaderRenderer){
				this.dayNameHeaderRenderer = dayNameHeaderRenderer;
			} else {
				this.dayNameHeaderRenderer = new ClassFactory(DayNameHeaderRenderer);
			}
			if(dayNames){
				this.dayNames = dayNames;
			}
			if(!dayRenderer){
				this.dayRenderer = new ClassFactory(DayRenderer);
			} else {
				this.dayRenderer = dayRenderer;
			}
			if(	isNaN(displayedDate)){
				this.displayedDate = (new Date()).date;
			} else {
				this.displayedDate = displayedDate;
			}
			if(	isNaN(displayedMonth)){
				this.displayedMonth = (new Date()).month;
			} else {
				this.displayedMonth = displayedMonth;
			}
			if(isNaN(displayedYear)){
				this.displayedYear = (new Date()).fullYear;
			} else {
				this.displayedYear = displayedYear;
			}

			this.doubleClickEnabled = doubleClickEnabled;
			this.dragEnabled = dragEnabled;
			this.dragMoveEnabled = dragMoveEnabled;
			this.dropEnabled = dropEnabled
			this.editable = editable;
			this.editorDataField = editorDataField;
			this.editorHeightOffset = editorHeightOffset;
			this.editorUsesEnterKey = editorUsesEnterKey;
			this.editorWidthOffset = editorWidthOffset;
			this.editorXOffset = editorXOffset ;
			this.editorYOffset = editorYOffset;
			this.firstDayOfWeek = firstDayOfWeek
			
			this.iconField = iconField; 
			this.iconFunction = iconFunction; 
			this.imeMode = imeMode;
			if(itemEditor){
				this.itemEditor = itemEditor;
			}
			if(!itemRenderer){
				this.itemRenderer = new ClassFactory(Label)
			} else {
				this.itemRenderer = itemRenderer;
			}
			this.labelField = labelField;
			this.labelFunction = labelFunction;
			
			this.leadingTrailingDaysVisible = leadingTrailingDaysVisible;
			this.monthHeaderVisible = monthHeaderVisible;
			if(!monthHeaderRenderer){
				this.monthHeaderRenderer = new ClassFactory(MonthHeaderRenderer)
			} else {
				this.monthHeaderRenderer = monthHeaderRenderer;
			}
			if(monthNames){
				this.monthNames = monthNames;
			}
			this.monthSymbol = monthSymbol;
			 
			if(nullItemRenderer){
				this.nullItemRenderer = nullItemRenderer;
			}
			this.offscreenExtraRowsOrColumns = offscreenExtraRowsOrColumns;
			this.rendererIsEditor = rendererIsEditor;
			this.selectable = selectable;
			this.showDataTips = showDataTips;

			this.weekHeaderVisible = weekHeaderVisible;
			if(weekHeaderRenderer){
				this.weekHeaderRenderer = weekHeaderRenderer;
			} else {
				this.weekHeaderRenderer = new ClassFactory(WeekHeaderRenderer);
			}
			this.wordWrap = wordWrap;

		}
	    //----------------------------------
	    //  allowMultipleSelection
	    //----------------------------------
		/**
		 * @private
		 */
		private var _allowMultipleSelection : Boolean = false;
	    /**
	     * @copy mx.controls.listClasses.ListBase#allowMultipleSelection 
	     */
		public function get allowMultipleSelection():Boolean
		{
			return this._allowMultipleSelection;
		}
		
		/**
		 * @private
		 */
		public function set allowMultipleSelection(value:Boolean):void
		{
			this._allowMultipleSelection = value;
		}

	    //----------------------------------
	    //  calendar
	    //----------------------------------
		/**
		 * @private
		 */
		private var _calendar : IUIComponent;
		/**
		 * @inheritDoc
		 */
		public function get calendar():IUIComponent
		{
			return this._calendar;
		}
		
		/**
		 * @private
		 */
		public function set calendar(value:IUIComponent):void
		{
			this._calendar = value;
		}

		
		//----------------------------------
		//  calendarMeasurements
		//----------------------------------
		/**
		 * @private
		 */
		private var _calendarMeasurements : CalendarMeasurementsVO = new CalendarMeasurementsVO();
		/**
		 * @inheritDoc
		 */
		public function get calendarMeasurements():CalendarMeasurementsVO
		{
			return this._calendarMeasurements;
		}
		
		/**
		 * @private
		 */
		public function set calendarMeasurements(value:CalendarMeasurementsVO):void
		{
			this._calendarMeasurements = value;
		}
		
		//----------------------------------
		//  dataProviderManager
		//----------------------------------
		/**
		 * @private
		 */
		private var _dataProviderManager : DataProviderManager;
		/**
		 * @copy mx.controls.listClasses.ListBase#dataProvider 
		 */
		public function get dataProviderManager():DataProviderManager{
			return this._dataProviderManager;
		}
		/**
		 * @private
		 */
		public function set dataProviderManager(value:DataProviderManager):void{
			this._dataProviderManager = value;
		}
		
	    //----------------------------------
	    //  dataTipField
	    //----------------------------------
		/**
		 * @private
		 */
		private var _dataTipField : String;
		/**
	     * @copy mx.controls.listClasses.ListBase#dataTipField 
		 */
		public function get dataTipField():String{
			return this._dataTipField;
		}
		/**
		 * @private
		 */
		public function set dataTipField(value:String):void{
			this._dataTipField = value;
		}
		
	    //----------------------------------
	    //  dataTipFunction
	    //----------------------------------
		/**
		 * @private
		 */
		private var _dataTipFunction : Function;
		/**
	     * @copy mx.controls.listClasses.ListBase#dataTipFunction 
		 */
		public function get dataTipFunction():Function{
			return this._dataTipFunction;
		}
		/**
		 * @private
		 */
		public function set dataTipFunction(value:Function):void{
			this._dataTipFunction = value;
		}

		
		//----------------------------------
		//  dayHeaderVisible
		//----------------------------------
		/**
		 * @private
		 */
		private var _dayHeaderVisible : Boolean= true;
		/**
		 * @copy com.flextras.calendar.Calendar#dayHeaderVisible 
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
		}
		
		//----------------------------------
		//  dayHeaderRenderer
		//----------------------------------
		/**
		 * @private
		 */
		private var _dayHeaderRenderer : IFactory =  new ClassFactory(DayHeaderRenderer);
		
		/**
		 * @copy com.flextras.calendar.Calendar#dayHeaderRenderer
		 */
		public function get dayHeaderRenderer():IFactory{
			return this._dayHeaderRenderer;
		}
		
		/**
		 * @private
		 */
		public function set dayHeaderRenderer(value:IFactory):void{
			this._dayHeaderRenderer = value;
		}
		
	    //----------------------------------
	    //  dayNameHeadersVisible
	    //----------------------------------
		/**
		 * @private
		 */
		private var _dayNameHeadersVisible : Boolean = true;
		/**
	     * @copy com.flextras.calendar.Calendar#dayNameHeadersVisible 
		 */
		public function get dayNameHeadersVisible():Boolean
		{
			return this._dayNameHeadersVisible;
		}
		
		/**
		 * @private
		 */
		public function set dayNameHeadersVisible(value:Boolean):void
		{
			this._dayNameHeadersVisible = value;
		}

	    //----------------------------------
	    //  dayNameHeaderRenderer
	    //----------------------------------
		/**
		 * @private
		 */
		private var _dayNameHeaderRenderer : IFactory = new ClassFactory(DayNameHeaderRenderer);
		/**
	     * @copy com.flextras.calendar.Calendar#dayNameHeaderRenderer 
		 */
		public function get dayNameHeaderRenderer():IFactory
		{
			return this._dayNameHeaderRenderer;
		}
		
		/**
		 * @private
		 */
		public function set dayNameHeaderRenderer(value:IFactory):void
		{
			this._dayNameHeaderRenderer = value;
		}

	    //----------------------------------
	    //  dayNames
	    //----------------------------------
		/**
		 * @private
		 */
		private var _dayNames : Array = ResourceManager.getInstance().getStringArray("SharedResources", "dayNames");
		/**
	     * copy com.flextras.calendar.Calendar#dayNames 
		 */ 
		public function get dayNames():Array
		{
			return this._dayNames;
		}
		
		/**
		 * @private
		 */
		public function set dayNames(value:Array):void
		{
			this._dayNames = value;
		}

	    //----------------------------------
	    //  dayRenderer
	    //----------------------------------
		/**
		 * @private
		 */
		private var _dayRenderer : IFactory = new ClassFactory(DayRenderer);
		/**
	     * @copy com.flextras.calendar.Calendar#dayNameHeaderRenderer 
		 */
		public function get dayRenderer():IFactory
		{
			return this._dayRenderer;
		}
		
		/**
		 * @private
		 */
		public function set dayRenderer(value:IFactory):void
		{
			this._dayRenderer = value;
		}

		//----------------------------------
		//  displayedDate
		//----------------------------------
		/**
		 * @private
		 */
		private var _displayedDate : Number =(new Date()).date;
		/**
		 * @copy com.flextras.calendar.Calendar#displayedDate
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
			this._displayedDate = value;
			(this.calendar as Calendar).displayedDate = value;
		}

	    //----------------------------------
	    //  displayedMonth
	    //----------------------------------
		/**
		 * @private
		 */
		private var _displayedMonth : Number =(new Date()).month;
		/**
	     * @copy com.flextras.calendar.Calendar#displayedMonth
		 */
		public function get displayedMonth():Number
		{
			return this._displayedMonth;
		}
		
		/**
		 * @private
		 */
		public function set displayedMonth(value:Number):void
		{
			this._displayedMonth = value;
			(this.calendar as Calendar).displayedMonth = value;
		}

	    //----------------------------------
	    //  displayedYear
	    //----------------------------------
		/**
		 * @private
		 */
		private var _displayedYear  : Number = (new Date()).fullYear;
		/**
	     * @copy com.flextras.calendar.Calendar#displayedYear
		 */
		public function get displayedYear():Number
		{
			return this._displayedYear ;
		}
		
		/**
		 * @private
		 */
		public function set displayedYear(value:Number):void
		{
			this._displayedYear = value;
			(this.calendar as Calendar).displayedYear = value;
		}
		
	    //----------------------------------
	    //  doubleClickEnabled
	    //----------------------------------
		/**
		 * @private
		 */
		private var _doubleClickEnabled : Boolean = false;
		/**
	     * @copy mx.core.UIComponent#doubleClickEnabled 
		 */
		public function get doubleClickEnabled():Boolean
		{
			return this._doubleClickEnabled;
		}
		
		/**
		 * @private
		 */
		public function set doubleClickEnabled(value:Boolean):void
		{
			this._doubleClickEnabled = value;
		}

	    //----------------------------------
	    //  dragEnabled
	    //----------------------------------
		/**
		 * @private
		 */
		private var _dragEnabled : Boolean = false;
		/**
	     * @copy mx.controls.listClasses.ListBase#dragEnabled
		 */
		public function get dragEnabled():Boolean
		{
			return this._dragEnabled;
		}
		
		/**
		 * @private
		 */
		public function set dragEnabled(value:Boolean):void
		{
			this._dragEnabled = value;
		}

	    //----------------------------------
	    //  dragMoveEnabled
	    //----------------------------------
		/**
		 * @private
		 */
		private var _dragMoveEnabled : Boolean = false;
		/**
	     * @copy mx.controls.listClasses.ListBase#dragMoveEnabled
		 */
		public function get dragMoveEnabled():Boolean
		{
			return this._dragMoveEnabled;
		}
		
		/**
		 * @private
		 */
		public function set dragMoveEnabled(value:Boolean):void
		{
			this._dragMoveEnabled = value;
		}

	    //----------------------------------
	    //  dropEnabled
	    //----------------------------------
		/**
		 * @private
		 */
		private var _dropEnabled : Boolean = false;
		/**
	     * @copy mx.controls.listClasses.ListBase#dropEnabled
		 */
		public function get dropEnabled():Boolean
		{
			return this._dropEnabled;
		}
		
		/**
		 * @private
		 */
		public function set dropEnabled(value:Boolean):void
		{
			this._dropEnabled = value;
		}
		
	    //----------------------------------
	    //  editable
	    //----------------------------------
		/**
		 * @private
		 */
		private var _editable : Boolean = false;
		/**
	     * @copy mx.controls.List#editable 
		 */
		public function get editable():Boolean
		{
			return this._editable;
		}
		
		/**
		 * @private
		 */
		public function set editable(value:Boolean):void
		{
			this._editable = value;
		}
		
	    //----------------------------------
	    //  editorDataField
	    //----------------------------------
		/**
		 * @private
		 */
		private var _editorDataField : String= 'text';
		/**
	     * @copy mx.controls.List#editorDataField 
		 */
		public function get editorDataField():String
		{
			return this._editorDataField;
		}
		
		/**
		 * @private
		 */
		public function set editorDataField(value:String):void
		{
			this._editorDataField = value;
		}
		
	    //----------------------------------
	    //  editorHeightOffset
	    //----------------------------------
		/**
		 * @private
		 */
		private var _editorHeightOffset : Number = 0;
		/**
	     * @copy mx.controls.List#editorHeightOffset 
		 */
		public function get editorHeightOffset():Number
		{
			return this._editorHeightOffset;
		}
		
		/**
		 * @private
		 */
		public function set editorHeightOffset(value:Number):void
		{
			this._editorHeightOffset = value;
		}
		
	    //----------------------------------
	    //  editorUsesEnterKey
	    //----------------------------------
		/**
		 * @private
		 */
		private var _editorUsesEnterKey : Boolean= false;
		/**
	     * @copy mx.controls.List#editorUsesEnterKey 
		 */
		public function get editorUsesEnterKey():Boolean
		{
			return this._editorUsesEnterKey;
		}
		
		/**
		 * @private
		 */
		public function set editorUsesEnterKey(value:Boolean):void
		{
			this._editorUsesEnterKey = value;
		}
		
	    //----------------------------------
	    //  editorWidthOffset
	    //----------------------------------
		/**
		 * @private
		 */
		private var _editorWidthOffset : Number= 0;;
		/**
	     * @copy mx.controls.List#editorWidthOffset 
		 */
		public function get editorWidthOffset():Number
		{
			return this._editorWidthOffset;
		}
		
		/**
		 * @private
		 */
		public function set editorWidthOffset(value:Number):void
		{
			this._editorWidthOffset = value;
		}
		
	    //----------------------------------
	    //  editorXOffset
	    //----------------------------------
		/**
		 * @private
		 */
		private var _editorXOffset : Number= 0;
		/**
	     * @copy mx.controls.List#editorXOffset 
		 */
		public function get editorXOffset():Number
		{
			return this._editorXOffset;
		}
		
		/**
		 * @private
		 */
		public function set editorXOffset(value:Number):void
		{
			this._editorXOffset = value;
		}
		
	    //----------------------------------
	    //  editorYOffset
	    //----------------------------------
		/**
		 * @private
		 */
		private var _editorYOffset : Number= 0;
		/**
	     * @copy mx.controls.List#editorYOffset 
		 */
		public function get editorYOffset():Number
		{
			return this._editorYOffset;
		}
		
		/**
		 * @private
		 */
		public function set editorYOffset(value:Number):void
		{
			this._editorYOffset = value;
		}

	    //----------------------------------
	    //  firstDayOfWeek
	    //----------------------------------
		/**
		 * @private
		 */
		private var _firstDayOfWeek : int= 0;
		/**
	     * @copy mx.controls.DateChooser#firstDayOfWeek
		 */
		public function get firstDayOfWeek():int
		{
			return this._firstDayOfWeek;
		}
		
		/**
		 * @private
		 */
		public function set firstDayOfWeek(value:int):void
		{
			this._firstDayOfWeek = value;

			// set the last day of the week
			if(_firstDayOfWeek == 0){
		        this._lastDayOfWeek = 6;
			} else {
		        this._lastDayOfWeek = _firstDayOfWeek-1;
			}
		}

	    //----------------------------------
	    //  iconField
	    //----------------------------------
		/**
		 * @private
		 */
		private var _iconField : String;
		/**
	     * @copy mx.controls.listClasses.ListBase#iconField 
		 */
		public function get iconField():String{
			return this._iconField;
		}
		/**
		 * @private
		 */
		public function set iconField(value:String):void{
			this._iconField = value;
		}
		
	    //----------------------------------
	    //  iconFunction
	    //----------------------------------
		/**
		 * @private
		 */
		private var _iconFunction : Function;
		/**
	     * @copy mx.controls.listClasses.ListBase#iconFunction 
		 */
		public function get iconFunction():Function{
			return this._iconFunction;
		}
		/**
		 * @private
		 */
		public function set iconFunction(value:Function):void{
			this._iconFunction = value;
		}

		
	    //----------------------------------
	    //  imeMode
	    //----------------------------------
		/**
		 * @private
		 */
		private var _imeMode : String= null;
		/**
	     * @copy mx.controls.List#imeMode 
		 */
		public function get imeMode():String
		{
			return this._imeMode;
		}
		
		/**
		 * @private
		 */
		public function set imeMode(value:String):void
		{
			this._imeMode = value;
		}
		
	    //----------------------------------
	    //  itemEditor
	    //----------------------------------
		/**
		 * @private
		 */
		private var _itemEditor : IFactory = new ClassFactory(TextInput);
	
		/**
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
		}


	    //----------------------------------
	    //  itemRenderer
	    //----------------------------------
		/**
		 * @private
		 */
		private var _itemRenderer : IFactory = new ClassFactory(ListItemRenderer);

		/**
	     * @copy mx.controls.listClasses.ListBase#itemRenderer 
		 */
		public function get itemRenderer():IFactory{
			return this._itemRenderer;
		}

	
		/**
		 * @private
		 */
		public function set itemRenderer(value:IFactory):void{
			this._itemRenderer = value;
		}
				
	    //----------------------------------
	    //  labelField
	    //----------------------------------
		/**
		 * @private
		 */
		private var _labelField : String = "label";
		/**
	     * @copy mx.controls.listClasses.ListBase#labelField 
		 */
		public function get labelField():String{
			return this._labelField;
		}
		/**
		 * @private
		 */
		public function set labelField(value:String):void{
			this._labelField = value;
		}
		
	    //----------------------------------
	    //  labelFunction
	    //----------------------------------
		/**
		 * @private
		 */
		private var _labelFunction : Function;
		/**
	     * @copy mx.controls.listClasses.ListBase#labelFunction 
		 */
		public function get labelFunction():Function{
			return this._labelFunction;
		}
		/**
		 * @private
		 */
		public function set labelFunction(value:Function):void{
			this._labelFunction = value;
		}

	    //----------------------------------
	    //  lastDayOfWeek
	    //----------------------------------
		/**
		 * @private
		 */
		private var _lastDayOfWeek : int= 6;
		/**
	     * @copy @copy com.flextras.calendar.Calendar#lastDayOfWeek
		 */
		public function get lastDayOfWeek():int
		{
			return this._lastDayOfWeek;
		}
		
		/**
		 * @private
		public function set lastDayOfWeek(value:int):void
		{
			this._lastDayOfWeek = value;
		}
		 */
		
		//----------------------------------
		//  leadingTrailingDaysVisible
		//----------------------------------
		/**
		 * @private
		 */
		private var _leadingTrailingDaysVisible : Boolean= true;
		/**
		 * @copy com.flextras.calendar.Calendar#leadingTrailingDaysVisible 
		 */
		public function get leadingTrailingDaysVisible():Boolean
		{
			return this._leadingTrailingDaysVisible;
		}
		
		/**
		 * @private
		 */
		public function set leadingTrailingDaysVisible(value:Boolean):void
		{
			this._leadingTrailingDaysVisible = value;
		}
		
	    //----------------------------------
	    //  monthHeaderVisible
	    //----------------------------------
		/**
		 * @private
		 */
		private var _monthHeaderVisible : Boolean= true;
		/**
	     * @copy com.flextras.calendar.Calendar#monthHeaderVisible 
		 */
		public function get monthHeaderVisible():Boolean
		{
			return this._monthHeaderVisible;
		}
		
		/**
		 * @private
		 */
		public function set monthHeaderVisible(value:Boolean):void
		{
			this._monthHeaderVisible = value;
		}

	    //----------------------------------
	    //  monthHeaderRenderer
	    //----------------------------------
		/**
		 * @private
		 */
		private var _monthHeaderRenderer : IFactory =  new ClassFactory(MonthHeaderRenderer);

		/**
		 * @copy com.flextras.calendar.Calendar#monthHeaderRenderer
		 */
		public function get monthHeaderRenderer():IFactory{
			return this._monthHeaderRenderer;
		}

		/**
		 * @private
		 */
		public function set monthHeaderRenderer(value:IFactory):void{
			this._monthHeaderRenderer = value;
		}


	    //----------------------------------
	    //  monthNames
	    //----------------------------------
		/**
		 * @private
		 */
		private var _monthNames : Array = ResourceManager.getInstance().getStringArray("SharedResources", "monthNames");
		/**
	     * @copy mx.controls.DateChooser#monthNames
		 */
		public function get monthNames():Array
		{
			return this._monthNames;
		}
		
		/**
		 * @private
		 */
		public function set monthNames(value:Array):void
		{
			this._monthNames = value;
		}

	    //----------------------------------
	    //  monthSymbol
	    //----------------------------------
		/**
		 * @private
		 */
		private var _monthSymbol : String = "";
		/**
	     * @copy mx.controls.DateChooser#monthSymbol
		 */
		public function get monthSymbol():String{
			return this._monthSymbol;
		}
		/**
		 * @private
		 */
		public function set monthSymbol(value:String):void{
			this._monthSymbol = value;
		}


	    //----------------------------------
	    //  nullItemRenderer
	    //----------------------------------
		/**
		 * @private
		 */
		private var _nullItemRenderer : IFactory = new ClassFactory(ListItemRenderer);
	
		/**
	     * @copy mx.controls.listClasses.ListBase#nullItemRenderer 
		 */
		public function get nullItemRenderer():IFactory{
			return this._nullItemRenderer;
		}

	
		/**
		 * @private
		 */
		public function set nullItemRenderer(value:IFactory):void{
			this._nullItemRenderer = value;
		}

	    //----------------------------------
	    //  offscreenExtraRowsOrColumns
	    //----------------------------------
		private var _offscreenExtraRowsOrColumns : int = 0;
		/**
	     * @copy mx.controls.listClasses.ListBase#selectable 
		 */
		public function get offscreenExtraRowsOrColumns():int
		{
			return this._offscreenExtraRowsOrColumns;
		}
		
		/**
		 * @private
		 */
		public function set offscreenExtraRowsOrColumns(value:int):void
		{
			this._offscreenExtraRowsOrColumns = value;
		}

	    //----------------------------------
	    //  rendererIsEditor
	    //----------------------------------
		/**
		 * @private
		 */
		private var _rendererIsEditor : Boolean = false;
		/**
	     * @copy mx.controls.List#rendererIsEditor 
		 */
		public function get rendererIsEditor():Boolean
		{
			//TODO: implement function
			return this._rendererIsEditor;
		}
		
		/**
		 * @private
		 */
		public function set rendererIsEditor(value:Boolean):void
		{
			this._rendererIsEditor = value;
		}

	    //----------------------------------
	    //  selectable
	    //----------------------------------
		/**
		 * @private
		 */
		private var _selectable : Boolean = true;
		/**
		 * @copy mx.controls.List#selectable 
		 */
		public function get selectable():Boolean
		{
			return this._selectable;
		}
		
		/**
		 * @private
		 */
		public function set selectable(value:Boolean):void
		{
			this._selectable = value;
		}		

	    //----------------------------------
	    //  showDataTips
	    //----------------------------------
		/**
		 * @private
		 */
		private var _showDataTips : Boolean = false;
		/**
	     * @copy mx.controls.listClasses.ListBase#showDataTips 
		 */
		public function get showDataTips():Boolean
		{
			return this._showDataTips;
		}
		
		/**
		 * @private
		 */
		public function set showDataTips(value:Boolean):void
		{
			this._showDataTips = value;
		}		

		
		//----------------------------------
		//  dayHeaderVisible
		//----------------------------------
		/**
		 * @private
		 */
		private var _weekHeaderVisible : Boolean= true;
		/**
		 * @copy com.flextras.calendar.Calendar#weekHeaderVisible 
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
		}
		
		//----------------------------------
		//  dayHeaderRenderer
		//----------------------------------
		/**
		 * @private
		 */
		private var _weekHeaderRenderer : IFactory =  new ClassFactory(WeekHeaderRenderer);
		
		/**
		 * @copy com.flextras.calendar.Calendar#weekHeaderRenderer
		 */
		public function get weekHeaderRenderer():IFactory{
			return this._weekHeaderRenderer;
		}
		
		/**
		 * @private
		 */
		public function set weekHeaderRenderer(value:IFactory):void{
			this._weekHeaderRenderer = value;
		}

		//----------------------------------
	    //  wordWrap
	    //----------------------------------
		/**
		 * @private
		 */
		private var _wordWrap : Boolean = false;
		/**
	     * @copy mx.controls.listClasses.ListBase#wordWrap 
		 */
		public function get wordWrap():Boolean
		{
			return this._wordWrap;
		}
		
		/**
		 * @private
		 */
		public function set wordWrap(value:Boolean):void
		{
			this._wordWrap = value;
		}	
	}
}