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
	import mx.core.IContainer;

	/**
	 * Dispatched when a user presses and releases the main button of the user's pointing device over the list in this dayRenderer.  
	 * this mirrors MouseEvent.CLICK
	 *
	 *  @eventType com.flextras.calendar.CalendarMouseEvent.CLICK_CALENDAR
	 */
	[Event(name="calendarDataClick", type="com.flextras.calendar.CalendarMouseEvent")]	
	
	// day event metadata for switching state events
	include "inc/ExpandEventMetaData.as";

	// event metadata for Drag events 
	include "inc/DragEventMetaData.as";	

	// event metadata from the CalendarEvent and CalendarMoustEvent classes
	include "inc/GenericEventMetaData.as";	
	
	/**
	 *  This defines the interface for the DayRenderers of the Flextras calendar Component.  
	 *  
	 * @author DotComIt / Flextras
	 * 
	 */
	public interface IDayRenderer extends IContainer, ICalendarData
	{
	
		/**
		 * This property contains the day specific data for the day to display.  
		 * This is, conceptually, similar to the data property of an itemRenderer.  It will change for each day object.
		 * 
		 */
		function get dayData():IDayDataVO;
		/**
		 * @private
		 */
		function set dayData(value:IDayDataVO):void;

		
		/**
		 * This method should deselect all items in this day.  
		 * It is used in conjunction with the Calendar’s allowMultipleselection when selecting data across multiple days.
		 * 
		 * @see com.flextras.calendar.Calendar#allowMultipleSelection
		 */
		function deselectItems():void;

		/**
		 * If you update calendarData, this method will force the component to refresh and update its calendarData as appropriate.  
		 * It is conceptually similar to invalidateList on a list based class.
		 */
		function invalidateCalendarData():void;

		/**
		 * If you update the component’s dayData, this method will force the component to refresh and update as appropriate.
		 * It is conceptually similar to invalidateList on a list based class.
		 */
		function invalidateDayData():void;
		
		/**
		 * This method is used in conjunction with selection of data across multiple days. 
		 * If the direction argument is 0, it should select all items in the dataProvider.  If an item is specified and direction is -1, it should select all items in the dataProvider up to and including the specified item. 
		 * If an item is specified and direction is 1, it should select the specified item and all items in the dataProvider after it.
		 * if this.calendarData.allowMultipleSelection is false, this will select the item and finish.
		 * 
		 * @see com.flextras.calendar.Calendar#allowMultipleSelection
		 */
		function selectItems(direction : int = -1, item : Object = null ):void;
		
		/**
		 * This property exposes all the items that are selected in the day.  
		 * The calendar instance will use this value when determining the selectedItems across all displayed days.
		 */
		function get selectedItems():Array
	}
}