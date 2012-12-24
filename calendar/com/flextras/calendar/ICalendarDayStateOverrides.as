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
	 *  This defines the interface for any class that contains overrides for moving to, or from, the day state of the Flextras Calendar Component.  
	 *  
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.Calendar
	 * @see com.flextras.calendar.DayDisplay
	 */
	public interface ICalendarDayStateOverrides
	{

		/**
		 * This property contains a collection of overrides that should execute when moving to, or from the Calendar.DAY_VIEW state.
		 * 
		 * State changes will be handled by the Calendar class.
		 */
		function get dayStateOverrides():Array
		
	}
}