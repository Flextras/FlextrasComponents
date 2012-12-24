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
	import mx.core.UIComponent;

	// Month Change effect metaData 
	include "inc/MonthChangeEffectMetaData.as";
	
	/**
	 * This defines the interface for the MonthDisplay class of the Flextras Calendar Component.  The MonthDisplay class represents the state where a single month is displayed.  
	 * 
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.Calendar
	 * @see com.flextras.calendar.MonthDisplay
	 */	
	public interface IMonthDisplay extends IUIComponent, ICalendarData
	{
		
	    /**
	     *  A method to change the month based on the specified increment.  
		 * You can use a negative value to go back in time or a positive value to go forward.
		 * 
		 * @param value The increment value used to change the month; the default is 1.
	     */
		function changeMonth(value:int = 1):void;


		/**
		 * This is a helper function to force the days to resize and position themselves as needed.
		 */
		function invalidateDays():void



	}
}