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

	// day header event metadata 
	include "inc/DayHeaderEventMetaData.as";
	
	/**
	 *  This defines the interface for the DayHeader of the Flextras calendar Component. It will be used in the Calendar.DAY_VIEW state of the Calendar and allow for paging through days and other informational display.
	 *  
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.Calendar
	 * @see com.flextras.calendar.defaultRenderers.DayHeaderRenderer
	 * @see com.flextras.calendar.DayDisplay
	 * @see com.flextras.calendar.IDayHeaderDataVO
	 * @see com.flextras.calendar.DayHeaderDataVO
	 */
	public interface IDayHeader
	{
		/** 
		 * The Day Header data object sent in from the DayDisplay class.
		 */
		function get dayHeaderData (): IDayHeaderDataVO;
		
		/**
		 * @private 
		 */
		function set dayHeaderData (value:IDayHeaderDataVO ): void;

	}
}