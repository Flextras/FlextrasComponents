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
	/**
	 * This class is a default implementation of the IDayHeaderDataVO interface for use with the Flextras Calendar class.
	 * 
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.IDayHeaderDataVO
	 * @see com.flextras.calendar.Calendar
	 * 
	 */	
	public class DayHeaderDataVO extends MonthHeaderDataVO implements IDayHeaderDataVO
	{

		/**
		 *  Constructor.
		 */
		public function DayHeaderDataVO(dayData : IDayDataVO, dayName : Object, displayMonth:int, displayYear:int, monthName:Object, monthSymbol:String, calendarData:ICalendarDataVO)
		{
			this.dayData = dayData;
			this.dayName = dayName;
			super(displayMonth, displayYear, monthName, monthSymbol, calendarData);
		}

		//----------------------------------
		//  dayData
		//----------------------------------
		/**
		 * @private
		 */
		private var _dayData : IDayDataVO;

		/**
		 * @copy com.flextras.calendar.IDayRenderer#dayData
		 */
		public function get dayData() : IDayDataVO{
			return this._dayData;	
		}
		/**
		 * @private
		 */
		public function set dayData(value:IDayDataVO) : void{
			this._dayData = value;
		}
		
		//----------------------------------
		//  dayName
		//----------------------------------
		/**
		 * @private
		 */
		private var _dayName : Object;
		/** 
		 * @see com.flextras.calendar.Calendar#dayNames
		 * @inheritDoc
		 */
		public function get dayName():Object
		{
			return this._dayName;
		}
		/**
		 * @private
		 */
		public function set dayName(value:Object):void
		{
			this._dayName = value;
		}
		
	}
}