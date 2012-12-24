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
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.listClasses.ListBase;

	/**
	 * This is an event class that defines the static constants for list based events inside a Flextras Calendar component.  This class is a wrapper for the MouseEvent with some additional properties to make it easier to drill down into the dayRenderer in your event handler, if needed.  These events are dispatched from the dayRenderers.  
	 * 
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.Calendar
	 * @see com.flextras.calendar.defaultRenderers.DayRenderer
	 */
	public class CalendarMouseEvent extends MouseEvent
	{

	    /**
	     *  The CalendarMouseEvent.CLICK_DAY constant defines the value of the 
	     *  <code>type</code> property of the CalendarMouseEvent object for a
	     *  <code>dayClick</code> event, which indicates that the user clicked in the DayRenderer of a calendar class.
	     * <p>
	     * Dispatched when a user presses and releases the main button of the user's pointing device over the same <code>InteractiveObject</code>. 
	     * For a click event to occur, it must always follow this series of events in the order of occurrence: mouseDown event, then mouseUp. The 
	     * target object must be identical for both of these events; otherwise the <code>click</code> event does not occur. 
	     * Any number of other mouse events can occur at any time between the <code>mouseDown</code> or <code>mouseUp</code> events; 
	     * the <code>click</code> event still occurs. 
	     * </p>
	     * 
	     *
	     *  <p>This is a wrapper to the events dispatched by the dayRenderer's of the 
	     * Calendar class.</p>
	     *
	     *  <p>The properties of the event object have the following values:</p>
	     * 
	     *  <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr><td><code>altKey</code></td><td>true if the Alt key is active (Windows or Linux).</td></tr>
	     *     <tr><td><code>bubbles</code></td><td>true</td></tr>
	     *     <tr><td><code>buttonDown</code></td><td>true if the primary mouse button is pressed; false otherwise.</td></tr>
	     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
	     *     <tr><td><code>commandKey</code></td><td>true on the Mac if the Command key is active; false if it is inactive. Always false on Windows.</td></tr>
	     *     <tr><td><code>controlKey</code></td><td>true if the Ctrl or Control key is active; false if it is inactive.</td></tr>
	     *     <tr><td><code>ctrlKey</code></td><td>true on Windows or Linux if the Ctrl key is active. true on Mac if either the Ctrl key or the Command key is active. Otherwise, false.</td></tr>
 	     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
	     *       event listener that handles the event. For example, if you use 
	     *       <code>myButton.addEventListener()</code> to register an event listener, 
	     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
	     *     <tr><td><code>dayRenderer</code></td><td>This is a reference to the dayRenderer that triggered the original MouseEvent.</td></tr>
	     *     <tr><td><code>itemRenderer</code></td><td>This is the itemRenderer that the mouse was over when it was clicked.</td></tr>
	     *     <tr><td><code>list</code></td><td>This is a reference to the list based class in the dayRender that triggered the initial MouseEvent.  
		 * If using the default DayRenderer this will be a List.</td></tr>
	     *     <tr><td><code>localX</code></td><td>The horizontal coordinate at which the event occurred relative to the containing sprite.</td></tr>
	     *     <tr><td><code>localY</code></td><td>The vertical coordinate at which the event occurred relative to the containing sprite.</td></tr>
	     *     <tr><td><code>mouseEvent</code></td><td>This is a reference to the original MouseEvent that started the event chain.</td></tr>
	     *     <tr><td><code>shiftKey</code></td><td>true if the Shift key is active; false if it is inactive.</td></tr>
	     *     <tr><td><code>stageX</code></td><td>The horizontal coordinate at which the event occurred in global stage coordinates.</td></tr>
	     *     <tr><td><code>stageY</code></td><td>The vertical coordinate at which the event occurred in global stage coordinates.</td></tr>
	     *     <tr><td><code>selectedItems</code></td><td>This is the items from the dataProvider that are now selected based on the click.</td></tr>
	     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
	     *       it is not always the Object listening for the event. 
	     *       Use the <code>currentTarget</code> property to always access the 
	     *       Object listening for the event.</td></tr>
	     *     <tr><td><code>Type</code></td><td>CalendarMouseEvent.CLICK_DAY</td></tr>
	     *  </table>
	     *
	     *  @eventType dayClick
	     */
		public static const CLICK_DAY:String = "dayClick";

		/**
		 *  Constructor.
		 */
		public function CalendarMouseEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false, 
											localX:Number=NaN, localY:Number=NaN, relatedObject:InteractiveObject=null, 
											ctrlKey:Boolean=false, altKey:Boolean=false, shiftKey:Boolean=false, buttonDown:Boolean=false, 
											delta:int=0, list : ListBase = null, mouseEvent : MouseEvent = null, itemRenderer : IListItemRenderer = null,
											dayRenderer : Object = null, selectedItems : Array = null)
		{
			super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
			this.list = list;
			this.mouseEvent = mouseEvent;
			this.itemRenderer = itemRenderer;
			this.dayRenderer = dayRenderer;
			this.selectedItems = selectedItems;
		}

		
	//----------------------------------
	//  dayRenderer
	//----------------------------------
	/**
	 * This is a reference to the dayRenderer that triggered the original MouseEvent.
	 */
	public var dayRenderer : Object;
		
	
	//----------------------------------
	//  itemRenderer
	//----------------------------------
	/**
	 * This is the itemRenderer that the mouse was over when it was clicked.
	 */
	public var itemRenderer : IListItemRenderer;

	//----------------------------------
    //  list
    //----------------------------------
    /**
     *  This is a reference to the list based class in the dayRender that triggered the initial MouseEvent.  If using the default DayRenderer this will be a List.
     */
    public var list: ListBase;

    //----------------------------------
    //  mouseEvent
    //----------------------------------
    /**
     *  This is a reference to the original MouseEvent that started the event chain.  By default this was fired from a list based class in the dayRenderer.
     */
    public var mouseEvent : MouseEvent;
	
	//----------------------------------
	//  selectedItems
	//----------------------------------
	/**
	 *  This is the items from the dataProvider that are now selected based on the click.  If you are using allowMultipleSelection then this array may contain more than one value.  
	 */
	public var selectedItems : Array;


    /**
     *  @private
     */
    override public function clone():Event
    { 
        return new CalendarMouseEvent(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta, list, mouseEvent, itemRenderer, dayRenderer, selectedItems);
    }
		
	}
}