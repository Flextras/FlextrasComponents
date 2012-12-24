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
	 *  This defines the interface for any class that needs to expose objects for transition purposes.   
	 *  
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.Calendar
	 */
	public interface IObjectArrayForTransitions
	{

		/**
		 * This is an array of objects that may have property changes during state changes.  
		 * 
		 * This interface was created for the Flextras Calendar component; and the state changes would be between Calendar.MONTH_VIEW, Calendar.DAY_VIEW, and Calendar.WEEK_VIEW.
		 * Objects in this array may change size properties, such as height and width, and position such as x and y.  They may also be added or removed from their parent container.  
		 * <br/><br/>
		 * If you want to run special effects for children that are removed or added you can do so using effect filters.  
		 * <br/><br/>
		 * For example if you switch from Calendar.MONTH_VIEW to Calendar.DAY_VIEW the MonthDisplay class instance--which contains the month's days, day name headers, and a header will be removed.  The expanded day will be moved and resized to make it larger, and the dayHeader will be added.    
		 * To move from the Calendar.DAY_VIEW to Calendar.MONTH_VIEW the dayHeader is removed, the expanded day will be moved and resized to make it smaller and the monthHeader and day name headers will be added.  
		 * 
		 */
		function get objectArrayForTransitions():Array;				
		
	}
}