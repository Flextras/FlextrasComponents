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
	import mx.controls.DateChooser;
	
	/**
	 * This class is a default implementation of the IMonthHeaderDataVO interface for use with the Flextras Calendar class.
	 * 
	 * @author DotComIt / Flextras
	 * @see com.flextras.calendar.ICalendarHeaderDataVO
	 * @see com.flextras.calendar.Calendar
	 * 
	 */	
	public class MonthHeaderDataVO implements ICalendarHeaderDataVO
	{
		/**
		 *  Constructor.
		 */
		public function MonthHeaderDataVO(displayMonth : int, displayYear : int, monthName : Object, monthSymbol : String, calendarData : ICalendarDataVO)
		{
			this.displayedMonth = displayMonth;
			this.displayedYear = displayYear;
			this.monthName = monthName;
			this.monthSymbol = monthSymbol;
			this.calendarData = calendarData;
		}

	    //----------------------------------
	    //  calendarData
	    //----------------------------------
		/**
		 * @private
		 * private storage for the calendarData object
		 */
		private var _calendarData : ICalendarDataVO;
	
		/**
		 * @inheritDoc 
		 */
		public function get calendarData():ICalendarDataVO{
			return this._calendarData;
		}
	
		/**
		 * @private 
		 */
		public function set calendarData(value:ICalendarDataVO):void{
			this._calendarData = value;
		}

		//----------------------------------
		//  displayedMonth
		//----------------------------------
		/**
		 * @private
		 */
		private var  _displayMonth : int = 0;
		/** 
		 * @copy com.flextras.calendar.Calendar#displayedMonth 
		 */
		public function get displayedMonth():int
		{
			return this._displayMonth;
		}
		
		/**
		 * @private
		 */
		public function set displayedMonth(value:int):void
		{
			this._displayMonth = value;
		}
		
		//----------------------------------
		//  displayedYear
		//----------------------------------
		/**
		 * @private
		 */
		private var _displayYear : int = 0
		
		/** 
		 * @copy com.flextras.calendar.Calendar#displayedYear 
		 */
		public function get displayedYear():int
		{
			return this._displayYear;
		}
		
		/**
		 * @private
		 */
		public function set displayedYear(value:int):void
		{
			this._displayYear = value;
		}
		

		//----------------------------------
		//  monthName
		//----------------------------------
		/**
		 * @private
		 */
		private var _monthName : Object;
		/** 
		 * @inheritDoc
		 * @see com.flextras.calendar.Calendar#monthNames
		 */
		public function get monthName():Object
		{
			return this._monthName;
		}
		/**
		 * @private
		 */
		public function set monthName(value:Object):void
		{
			this._monthName = value;
		}
		
		//----------------------------------
		//  monthSymbol
		//----------------------------------
		/**
		 * @private
		 */
		private var _monthSymbol : String = '';
		/** 
	     * @copy mx.controls.DateChooser#monthSymbol 
		 */
		public function get monthSymbol():String
		{
			return this._monthSymbol;
		}
		
		/**
		 * @private
		 */
		public function set monthSymbol(value:String):void
		{
			this._monthSymbol = value;
		}

	}
}