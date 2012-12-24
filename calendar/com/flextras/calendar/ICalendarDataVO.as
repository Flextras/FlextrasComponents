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
	import com.flextras.calendar.utils.DataProviderManager;
	
	import mx.core.IFactory;
	import mx.core.IUIComponent;

	/**
	 * This defines the interface that describes all the calendar properties of the Flextras Calendar component.
	 * Used as an easy way to pass properties of the Calendar instance into the dayRenderers.
	 * 
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.Calendar
	 * @see com.flextras.calendar.CalendarDataVO
	 * @see com.flextras.calendar.defaultRenderers.DayRenderer
	 * 
	 */	
	public interface ICalendarDataVO
	{

	    /**
	     * @copy mx.controls.listClasses.ListBase#allowMultipleSelection 
	     */
		function get allowMultipleSelection():Boolean;
		/**
		 * @private
		 */
		function set allowMultipleSelection(value:Boolean):void;

		/**
		 * This is a reference to the Calendar Component instance that created the CalendarDataVO object.
		 */
		function get calendar(): IUIComponent;
		/**
		 * @private
		 */
		function set calendar(value:IUIComponent):void;

		
		/**
		 *  This object contains various measurements from MonthDisplay, DayDisplay, and WeekDisplay that are used by the Calendar as parts of state transitions.
		 */
		function get calendarMeasurements() : CalendarMeasurementsVO;
		/**
		 * @private
		 */
		function set calendarMeasurements(value:CalendarMeasurementsVO):void;

		/**
	     * @copy com.flextras.calendar.Calendar#dataProviderManager 
	     */
		function get dataProviderManager():DataProviderManager;
		/**
		 * @private
		 */
		function set dataProviderManager(value:DataProviderManager):void;

	    /**
	     * @copy mx.controls.listClasses.ListBase#dataTipField 
	     */
		function get dataTipField():String;
		/**
		 * @private
		 */
		function set dataTipField(value:String):void;
		
	    /**
	     * @copy mx.controls.listClasses.ListBase#dataTipFunction 
	     */
		function get dataTipFunction():Function;
		/**
		 * @private
		 */
		function set dataTipFunction(value:Function):void;

		/**
		 * @copy com.flextras.calendar.Calendar#dayHeaderVisible 
		 */
		function get dayHeaderVisible():Boolean;
		/**
		 * @private
		 */
		function set dayHeaderVisible(value:Boolean):void;
		
		/**
		 * @copy com.flextras.calendar.Calendar#dayHeaderRenderer 
		 */
		function get dayHeaderRenderer():IFactory;
		/**
		 * @private
		 */
		function set dayHeaderRenderer(value:IFactory):void;		

	    /**
	     * @copy com.flextras.calendar.Calendar#dayNameHeadersVisible 
	     */
		function get dayNameHeadersVisible():Boolean;
		/**
		 * @private
		 */
		function set dayNameHeadersVisible(value:Boolean):void;

	    /**
	     * @copy com.flextras.calendar.Calendar#dayNameHeaderRenderer 
	     */
		function get dayNameHeaderRenderer():IFactory;
		/**
		 * @private
		 */
		function set dayNameHeaderRenderer(value:IFactory):void;
		
	    /**
	     * @copy com.flextras.calendar.Calendar#dayNames 
	     */
		function get dayNames():Array
		/**
		 * @private
		 */
		function set dayNames(value:Array):void;

	    /**
	     * @copy com.flextras.calendar.Calendar#dayRenderer 
	     */
		function get dayRenderer():IFactory;
		/**
		 * @private
		 */
		function set dayRenderer(value:IFactory):void;

		/**
		 * @copy com.flextras.calendar.Calendar#displayedDate
		 */
		function get displayedDate():Number;
		/**
		 * @private
		 */
		function set displayedDate(value:Number):void;

		/**
	     * @copy com.flextras.calendar.Calendar#displayedMonth 
	     */
		function get displayedMonth():Number;
		/**
		 * @private
		 */
		function set displayedMonth(value:Number):void;

	    /**
	     * @copy com.flextras.calendar.Calendar#displayedYear 
	     */
		function get displayedYear():Number;
		/**
		 * @private
		 */
		function set displayedYear(value:Number):void;

	    /**
	     * @copy mx.core.UIComponent#doubleClickEnabled 
	     */
		function get doubleClickEnabled():Boolean
		/**
		 * @private
		 */
		function set doubleClickEnabled(value:Boolean):void

	    /**
	     *  @copy mx.controls.listClasses.ListBase#dragEnabled
	     */
		function get dragEnabled():Boolean
		/**
		 * @private
		 */
		function set dragEnabled(value:Boolean):void

	    /**
	     *  @copy mx.controls.listClasses.ListBase#dragMoveEnabled
	     */
		function get dragMoveEnabled():Boolean
		/**
		 * @private
		 */
		function set dragMoveEnabled(value:Boolean):void

	    /**
	     *  @copy mx.controls.listClasses.ListBase#dropEnabled
	     */
		function get dropEnabled():Boolean
		/**
		 * @private
		 */
		function set dropEnabled(value:Boolean):void

	    /**
	     * @copy mx.controls.List#editable 
	     */
   		function get editable():Boolean;
		/**
		 * @private
		 */
		function set editable(value:Boolean):void;
		
	    /**
	     * @copy mx.controls.List#editorDataField 
	     */
		function get editorDataField():String;
		/**
		 * @private
		 */
		function set editorDataField(value:String):void;
		
	    /**
	     * @copy mx.controls.List#editorHeightOffset 
	     */
     	function get editorHeightOffset():Number;
		/**
		 * @private
		 */
		function set editorHeightOffset(value:Number):void;

	    /**
	     * @copy mx.controls.List#editorUsesEnterKey 
	     */
		function get editorUsesEnterKey():Boolean;
		/**
		 * @private
		 */
		function set editorUsesEnterKey(value:Boolean):void;

	    /**
	     * @copy mx.controls.List#editorWidthOffset 
	     */
   		function get editorWidthOffset():Number;
		/**
		 * @private
		 */
		function set editorWidthOffset(value:Number):void;

	    /**
	     * @copy mx.controls.List#editorXOffset 
	     */
		function get editorXOffset():Number;
		/**
		 * @private
		 */
		function set editorXOffset(value:Number):void;

	    /**
	     * @copy mx.controls.List#editorYOffset 
	     */
		function get editorYOffset():Number;
		/**
		 * @private
		 */
		function set editorYOffset(value:Number):void;

	    /**
	     *  @copy mx.controls.DateChooser#firstDayOfWeek
	     */
	    function get firstDayOfWeek():int
		/**
		 * @private
		 */
	    function set firstDayOfWeek(value:int):void
		
	    /**
	     * @copy mx.controls.listClasses.ListBase#iconField 
	     */
		function get iconField():String;
		/**
		 * @private
		 */
		function set iconField(value:String):void;
		
	    /**
	     * @copy mx.controls.listClasses.ListBase#iconFunction 
	     */
		function get iconFunction():Function;
		/**
		 * @private
		 */
		function set iconFunction(value:Function):void;
		 
	    /**
	     * @copy mx.controls.List#imeMode 
	     */
	    function get imeMode():String;
		/**
		 * @private
		 */
		function set imeMode(value:String):void;
		
	    /**
	     * @copy mx.controls.List#itemEditor 
	     */
		function get itemEditor():IFactory;
		/**
		 * @private
		 */
		function set itemEditor(value:IFactory):void;

	    /**
	     * @copy mx.controls.listClasses.ListBase#itemRenderer 
	     */
		function get itemRenderer():IFactory;
		/**
		 * @private
		 */
		function set itemRenderer(value:IFactory):void;		

	    /**
	     * @copy mx.controls.listClasses.ListBase#labelField 
	     */
		function get labelField():String;
		/**
		 * @private
		 */
		function set labelField(value:String):void;
		
	    /**
	     * @copy mx.controls.listClasses.ListBase#labelFunction 
	     */
		function get labelFunction():Function;
		/**
		 * @private
		 */
		function set labelFunction(value:Function):void;

	    /**
	     *  @copy com.flextras.calendar.Calendar#lastDayOfWeek
	     */
	    function get lastDayOfWeek():int
			
		
		/**
		 * @copy com.flextras.calendar.Calendar#leadingTrailingDaysVisible 
		 */
		function get leadingTrailingDaysVisible():Boolean;
		/**
		 * @private
		 */
		function set leadingTrailingDaysVisible(value:Boolean):void;

	    /**
	     * @copy com.flextras.calendar.Calendar#monthHeaderVisible 
	     */
		function get monthHeaderVisible():Boolean;
		/**
		 * @private
		 */
		function set monthHeaderVisible(value:Boolean):void;


	    /**
	     * @copy com.flextras.calendar.Calendar#monthHeaderRenderer 
	     */
		function get monthHeaderRenderer():IFactory;
		/**
		 * @private
		 */
		function set monthHeaderRenderer(value:IFactory):void;		

	    /**
	     * @copy mx.controls.DateChooser#monthNames
	     */
		function get monthNames():Array
		/**
		 * @private
		 */
		function set monthNames(value:Array):void;				 

	    /**
	     * @copy mx.controls.DateChooser#monthSymbol
	     */
		function get monthSymbol():String
		/**
		 * @private
		 */
		function set monthSymbol(value:String):void;				 

	    /**
	     * @copy mx.controls.listClasses.ListBase#nullItemRenderer 
	     */
		function get nullItemRenderer():IFactory;
		/**
		 * @private
		 */
		function set nullItemRenderer(value:IFactory):void;		

	    /**
	     * @copy mx.controls.listClasses.ListBase#selectable 
	     */
		function get offscreenExtraRowsOrColumns():int;
		/**
		 * @private
		 */
		function set offscreenExtraRowsOrColumns(value:int):void;

	    /**
	     * @copy mx.controls.List#rendererIsEditor 
	     */
		function get rendererIsEditor():Boolean;
		/**
		 * @private
		 */
		function set rendererIsEditor(value:Boolean):void;

	    /**
	     * @copy mx.controls.listClasses.ListBase#selectable 
	     */
		function get selectable():Boolean;
		/**
		 * @private
		 */
		function set selectable(value:Boolean):void;

	    /**
	     * @copy mx.controls.listClasses.ListBase#showDataTips 
	     */
		function get showDataTips():Boolean;
		/**
		 * @private
		 */
		function set showDataTips(value:Boolean):void;

		
		/**
		 * @copy com.flextras.calendar.Calendar#weekHeaderVisible 
		 */
		function get weekHeaderVisible():Boolean;
		/**
		 * @private
		 */
		function set weekHeaderVisible(value:Boolean):void;
		
		/**
		 * @copy com.flextras.calendar.Calendar#weekHeaderRenderer 
		 */
		function get weekHeaderRenderer():IFactory;
		/**
		 * @private
		 */
		function set weekHeaderRenderer(value:IFactory):void;		

		/**
	     * @copy mx.controls.listClasses.ListBase#wordWrap 
	     */
		function get wordWrap():Boolean;
		/**
		 * @private
		 */
		function set wordWrap(value:Boolean):void;

	}
}