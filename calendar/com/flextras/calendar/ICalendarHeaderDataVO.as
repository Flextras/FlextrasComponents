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
	import mx.core.IUIComponent;
	
	/**
	 * An interface that describes the data sent to the month, day, or week headers from an instance of the MonthDisplay, DayDisplay, or 
	 * WeekDisplay classes, respectively.
	 * 
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.IDayHeaderDataVO
	 * @see com.flextras.calendar.MonthHeaderDataVO
	 * @see com.flextras.calendar.DayHeaderDataVO
	 * @see com.flextras.calendar.defaultRenderers.MonthHeaderRenderer
	 * @see com.flextras.calendar.defaultRenderers.WeekHeaderRenderer
	 * @see com.flextras.calendar.defaultRenderers.DayHeaderRenderer
	 * 
	 */	
	public interface ICalendarHeaderDataVO extends ICalendarData
	{

		/**
		 * @copy com.flextras.calendar.Calendar#displayedMonth 
		 */
		function get displayedMonth() : int;
		/**
		 * @private
		 */
		function set displayedMonth(value:int):void;

		/**
		 * @copy com.flextras.calendar.Calendar#displayedYear 
		 */
		function get displayedYear() : int;
		/**
		 * @private
		 */
		function set displayedYear(value:int):void;

		/**
		 * This property holds the month's name.  It will probably be a String.  It is a single element from the monthNames property of the Calendar class.
		 * 
		 * @see com.flextras.calendar.Calendar#monthNames
		 */
		function get monthName() : Object;
		/**
		 * @private
		 */
		function set monthName(value:Object):void;

		/**
		 * @copy mx.controls.DateChooser#monthSymbol 
		 */ 
		function get monthSymbol() : String;
		/**
		 * @private
		 */ 
		function set monthSymbol(value:String):void;


	}
}