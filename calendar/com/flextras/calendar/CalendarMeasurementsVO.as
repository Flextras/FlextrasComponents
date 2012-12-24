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
	 * This class is a value object class that defines sizing and positioning information used in state changes across the month, week, and day views of the Flextras Calendar class.
	 * 
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.Calendar
	 */
	public class CalendarMeasurementsVO
	{
		/**
		 *  Constructor.
		 */
		public function CalendarMeasurementsVO()
		{
		}
		
		//----------------------------------
		//  monthDayHeight
		//----------------------------------
		/**
		 * This property contains the day height in the month state.
		 */
		public var monthDayHeight : int;

		//----------------------------------
		//  monthHeaderHeight
		//----------------------------------
		/**
		 * This property contains the header height in the month state.  
		 * The header height will encompass the month header and the day name headers. 
		 */
		public var monthHeaderHeight : int;

		//----------------------------------
		//  monthDayWidth
		//----------------------------------
		/**
		 * This property will contain the day width in the month state.
		 */
		public var monthDayWidth : int;

		//----------------------------------
		//  monthDayNameHeaderY
		//----------------------------------
		/**
		 * This property contains the day name header's y position in the month state.
		 */
		public var monthDayNameHeaderY : int;
		
		//----------------------------------
		//  weekDayWidth
		//----------------------------------
		/**
		 * This property contains the day's width in the week state.
		 */
		public var weekDayWidth : int;

		//----------------------------------
		//  weekDayHeight
		//----------------------------------
		/**
		 * This property contains the day's height in the week state.
		 */
		public var weekDayHeight : int;

		//----------------------------------
		//  weekHeaderHeight
		//----------------------------------
		/**
		 * This property contains the header height in the month state.  The header height is the sum of the heights of the month header and the day name headers.
		 */
		public var weekHeaderHeight : int;

	
	
	}
}