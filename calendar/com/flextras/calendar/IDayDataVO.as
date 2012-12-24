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
	
	import mx.core.IFactory;
	
	/**
	 * This defines the interface for day specific data which a Calendar will pass into each dayRenderer instance.
	 * 
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.Calendar
	 * @see com.flextras.calendar.DayDataVO
	 * @see com.flextras.calendar.IDayRenderer
	 * @see com.flextras.calendar.defaultRenderers.DayRenderer
	 */	
	public interface IDayDataVO
	{

		/**
		 * This property holds the day of the currently displayed month.  This is included for convenience purposes.  
		 * You can also get this value using displayedDateObject.date.
		 */
		function get date():int;
		/**
		 * @private
		 */
		function set date(value:int):void;
		
	    /**
	     * @copy mx.controls.listClasses.ListBase#dataProvider 
	     */
		function get dataProvider():Object;
		/**
		 * @private
		 */
		function set dataProvider(value:Object):void;

		/**
		 * A Date object that represents the day the renderer is displaying.
		 */
		function get displayedDateObject():Date;
		/**
		 * @private
		 */
		function set displayedDateObject(value:Date):void;

	}
}