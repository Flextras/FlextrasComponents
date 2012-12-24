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
	 * This defines the interface for the WeekDisplay class of the Flextras Calendar Component.  The WeekDisplay class represents the state where a single week is displayed
	 * 
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.Calendar
	 * @see com.flextras.calendar.WeekDisplay
	 */	
	public interface IWeekDisplay extends IUIComponent, ICalendarData, IObjectArrayForTransitions, ICalendarDayStateOverrides, ICalendarWeekStateOverrides
	{
		
		/**
		 * A method to change the week based on the specified increment.  This increments the displayed day by 7 days.
		 * You can use a negative value to go back in time or a positive value to go forward.
		 * 
		 * @param value The increment value used to change the week; the default is 1.
		 */
		function changeWeek(value:int = 1):void;

		/**
		 * This is a helper function to force the day data to update. 
		 */
		function invalidateWeek():void
		
		/**
		 * A function that prepares the week for a state change transition that includes resize or move effects.
		 * 
		 * @param minimizedDayHeight This property contains the height of the days in their minimized position. 
		 * @param minimizedDayY This property contains the y location for the days in their minimized position. 
		 * @param expandedDate This contains the date that triggered the state change.  If the week is being expanded, it will be used to determine which week to display.
		 * @param repositionDay Specifies whether or not to reposition or resize the days of this component in preparation for the state change.
		 * @param nextStateChange The state that the component is about to enter.
		 * @param minimizedHeightOffset A height offset used for calculate the height of days.  It should be the sum of the header for the next state, and the day name headers, if applicable.
		 * @param minimizedDayNameHeaderY This contains the y location for the day name headers in the next state. 
		 * 
		 */
		function setupStateChange(minimizedDayHeight : int, 
								  minimizedDayY : int, expandedDate : Date, repositionDay : Boolean = false, toState : String = '', 
								  minimizedHeightOffset : int = 0, minimizedDayNameHeaderY : int =0 ):void;


		// same documentation / method signature that is in IDayDisplay
		/**
		 * If the Calendar's displayedYear, displayedMonth, or DisplayedDate are changed via the Calendar's properties, instead of 
		 * by using buttons inside the dayRenderer, this method will update the appropriate overrides. 
		 * 
		 * @param currentDate This is the current date that the Calendar is displaying.
		 * @param newDate This is the new date that the Calendar will be displaying.
		 * 
		 * @see com.flextras.calendar.Calendar#displayedDate
		 * @see com.flextras.calendar.Calendar#displayedMonth
		 * @see com.flextras.calendar.Calendar#displayedYear
		 * 
		 */
		function updateOverridesForDateChange(currentDate:Date, newDate : Date):void;

	}
}