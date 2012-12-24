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
	 *  This defines the interface for the DayDisplay class used by the Flextras Calendar Component.  The DayDisplay class represents the state where a single day is displayed.  
	 *  
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.Calendar
	 * @see com.flextras.calendar.DayDisplay
	 */
	public interface IDayDisplay extends IUIComponent, ICalendarData, ICalendarDayStateOverrides, IObjectArrayForTransitions
	{

		/**
		 * A method to change the day based on the specified increment.  
		 * You can use a negative value to go back in time or a positive value to go forward.
		 * 
		 * @param value The increment value used to change the day; the default is 1.
		 */
		function changeDay(value:int = 1):void;
		

		/**
		 * This is a helper function to force the day or day header to change when calendar data changes.
		 */
		function invalidateDay():void;


		/**
		 * A function that sets up the state change away from the day expanded state.
		 * 
		 * @param toState The state we are moving to.
		 * @param expandedDate The date that is expanded; which will be used to calculate the y location of the day inside the month state.
		 * 
		 * @see com.flextras.calendar.Calendar#DAY_VIEW
		 * @see com.flextras.calendar.Calendar#MONTH_VIEW
		 * @see com.flextras.calendar.Calendar#WEEK_VIEW
		 */
		function setupReverseStateChange(toState : String = '', expandedDate : Date = null  ):void;
		
		/**
		 * A function that prepares the day for a state change transition that includes resize or move effects.
		 * 
		 * @param minimizedDayX The x location for the day when it is resized smaller.
		 * @param minimizedDayY The y location for the day when it is resized smaller.
		 * @param expandedDate The date that is being expanded; which will be used to determine which week the component should be displaying.
		 * @param repositionDay Specifies whether or not to reposition the day of this component in preparation for the state change.
		 * @param fromState The state change the component is currently in.
		 * 
		 * @see com.flextras.calendar.Calendar#DAY_VIEW
		 * @see com.flextras.calendar.Calendar#MONTH_VIEW
		 * @see com.flextras.calendar.Calendar#WEEK_VIEW
		 * 
		 */
		function setupStateChange(minimizedDayX : int, minimizedDayY : int, expandedDate : Date = null, 
										 repositionDay : Boolean = false, fromState : String = ''):void;	

		
		// same documentation / method signature that is in IWeekDisplay
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