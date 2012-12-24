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
	import flash.events.Event;
	
	import mx.controls.listClasses.ListBase;
	import mx.core.DragSource;
	import mx.core.IUIComponent;
	import mx.events.DragEvent;

	/**
	 * This is an event class that defines the static constants for drag and drop events inside a Flextras Calendar component.  This class is a wrapper for the DragEvent with some additional properties to make it easier to drill down into the dayRenderer in your event handler, if needed.  These events are dispatched from the dayRenderers.  
	 * 
	 * You can access the date of this renderer using dayRenderer.dayData.displayedDateObject. 
	 * 
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.Calendar
	 * @see com.flextras.calendar.DayRenderer
	 */
	public class CalendarDragEvent extends DragEvent
	{

	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	/**
	 *  The <code>CalendarDragEvent.DAY_DRAG_COMPLETE</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>dayDragComplete</code> event.
     *
     *  <p>This is a wrapper to the events dispatched by the dayRenderer's of the 
     * Calendar class.</p>
	 * 
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>action</code></td><td>The action that caused the event: 
     *       <code>DragManager.COPY</code>, <code>DragManager.LINK</code>, 
     *       <code>DragManager.MOVE</code>, or <code>DragManager.NONE</code>.</td></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dayRenderer</code></td><td>This is a reference to the dayRenderer that triggered the original DragEvent.</td></tr>
     *     <tr><td><code>dragEvent</code></td><td>This is a reference to the original DragEvent that started the event chain.</td></tr>
     *     <tr><td><code>dragInitiator</code></td><td>The component that initiated the drag.</td></tr>
     *     <tr><td><code>dragSource</code></td><td>The DragSource object containing the 
     *       data being dragged.</td></tr>
     *     <tr><td><code>list</code></td><td>This is a reference to the list based class in the dayRender that triggered the initial DragEvent.  If using the default DayRenderer this will be a List.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
	 *  </table>
	 *
     *  @eventType dayDragComplete
	 */
	public static const DRAG_COMPLETE_DAY:String = "dayDragComplete";

	/**
	 *  The <code>CalendarDragEvent.DRAG_DROP_DAY</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>dayDragDrop</code> event.
     *
     *  <p>This is a wrapper to the events dispatched by the dayRenderer's of the 
     * Calendar class.</p>
	 * 
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>action</code></td><td>The action that caused the event: 
     *       <code>DragManager.COPY</code>, <code>DragManager.LINK</code>, 
     *       <code>DragManager.MOVE</code>, or <code>DragManager.NONE</code>.</td></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dayRenderer</code></td><td>This is a reference to the dayRenderer that triggered the original DragEvent.</td></tr>
     *     <tr><td><code>dragEvent</code></td><td>This is a reference to the original DragEvent that started the event chain.</td></tr>
     *     <tr><td><code>dragInitiator</code></td><td>The component that initiated the drag.</td></tr>
     *     <tr><td><code>dragSource</code></td><td>The DragSource object containing the 
     *       data being dragged.</td></tr>
     *     <tr><td><code>list</code></td><td>This is a reference to the list based class in the dayRender that triggered the initial DragEvent.  If using the default DayRenderer this will be a List.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
	 *  </table>
	 *
     *  @eventType dayDragDrop
	 */
	public static const DRAG_DROP_DAY:String = "dayDragDrop";

	/**
	 *  The <code>CalendarDragEvent.DRAG_ENTER_DAY</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>dayDragEnter</code> event.
     *
     *  <p>This is a wrapper to the events dispatched by the dayRenderer's of the 
     * Calendar class.</p>
     *
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>action</code></td><td>The action that caused the event, which is always
     *       <code>DragManager.MOVE</code>.</td></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dayRenderer</code></td><td>This is a reference to the dayRenderer that triggered the original DragEvent.</td></tr>
     *     <tr><td><code>dragEvent</code></td><td>This is a reference to the original DragEvent that started the event chain.</td></tr>
     *     <tr><td><code>dragInitiator</code></td><td>The component that initiated the drag.</td></tr>
     *     <tr><td><code>dragSource</code></td><td>The DragSource object containing the 
     *       data being dragged.</td></tr>
     *     <tr><td><code>list</code></td><td>This is a reference to the list based class in the dayRender that triggered the initial DragEvent.  If using the default DayRenderer this will be a List.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
	 *  </table>
	 *
     *  @eventType dayDragEnter
	 */
	public static const DRAG_ENTER_DAY:String = "dayDragEnter";

	/**
	 *  The <code>CalendarDragEvent.DRAG_EXIT_DAY</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>dayDragExit</code> event.
     *
     *  <p>This is a wrapper to the events dispatched by the dayRenderer's of the 
     * Calendar class.</p>
     *
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>action</code></td><td>The action that caused the event: 
     *       <code>DragManager.COPY</code>, <code>DragManager.LINK</code>, 
     *       <code>DragManager.MOVE</code>, or <code>DragManager.NONE</code>.</td></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dayRenderer</code></td><td>This is a reference to the dayRenderer that triggered the original DragEvent.</td></tr>
     *     <tr><td><code>dragEvent</code></td><td>This is a reference to the original DragEvent that started the event chain.</td></tr>
     *     <tr><td><code>dragInitiator</code></td><td>The component that initiated the drag.</td></tr>
     *     <tr><td><code>dragSource</code></td><td>The DragSource object containing the 
     *       data being dragged.</td></tr>
     *     <tr><td><code>list</code></td><td>This is a reference to the list based class in the dayRender that triggered the initial DragEvent.  If using the default DayRenderer this will be a List.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
	 *  </table>
	 *
     *  @eventType dayDragExit
	 */
	public static const DRAG_EXIT_DAY:String = "dayDragExit";

	/**
	 *  The <code>CalendarDragEvent.DRAG_OVER_DAY</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>dayDragOver</code> event.
     *
     *  <p>This is a wrapper to the events dispatched by the dayRenderer's of the 
     * Calendar class.</p>
     *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>action</code></td><td>The action that caused the event: 
     *       <code>DragManager.COPY</code>, <code>DragManager.LINK</code>, 
     *       <code>DragManager.MOVE</code>, or <code>DragManager.NONE</code>.</td></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dayRenderer</code></td><td>This is a reference to the dayRenderer that triggered the original DragEvent.</td></tr>
     *     <tr><td><code>dragEvent</code></td><td>This is a reference to the original DragEvent that started the event chain.</td></tr>
     *     <tr><td><code>dragInitiator</code></td><td>The component that initiated the drag.</td></tr>
     *     <tr><td><code>dragSource</code></td><td>The DragSource object containing the 
     *       data being dragged.</td></tr>
     *     <tr><td><code>list</code></td><td>This is a reference to the list based class in the dayRender that triggered the initial DragEvent.  If using the default DayRenderer this will be a List.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
	 *  </table>
	 *
     *  @eventType dayDragOver
	 */
	public static const DRAG_OVER_DAY:String = "dayDragOver";

	/**
	 *  The CalendarDragEvent.DRAG_START_DAY constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>dayDragStart</code> event.
     *
     *  <p>This is a wrapper to the events dispatched by the dayRenderer's of the 
     * Calendar class.</p>
     *
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>action</code></td><td>The action that caused the event: 
     *       <code>DragManager.COPY</code>, <code>DragManager.LINK</code>, 
     *       <code>DragManager.MOVE</code>, or <code>DragManager.NONE</code>.</td></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dayRenderer</code></td><td>This is a reference to the dayRenderer that triggered the original DragEvent.</td></tr>
     *     <tr><td><code>dragEvent</code></td><td>This is a reference to the original DragEvent that started the event chain.</td></tr>
     *     <tr><td><code>dragInitiator</code></td><td>The component that initiated the drag.</td></tr>
     *     <tr><td><code>dragSource</code></td><td>The DragSource object containing the 
     *       data being dragged.</td></tr>
     *     <tr><td><code>list</code></td><td>This is a reference to the list based class in the dayRender that triggered the initial DragEvent.  If using the default DayRenderer this will be a List.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
	 *  </table>
	 *
     *  @eventType dayDragStart
	 */
	public static const DRAG_START_DAY:String = "dayDragStart";


	/**
	 *  Constructor.
	 */
		public function CalendarDragEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=true, dragInitiator:IUIComponent=null, dragSource:DragSource=null, action:String=null, ctrlKey:Boolean=false, altKey:Boolean=false, shiftKey:Boolean=false, 
		 dragEvent : DragEvent = null, list : ListBase = null, dayRenderer : Object = null)
		{
			super(type, bubbles, cancelable, dragInitiator, dragSource, action, ctrlKey, altKey, shiftKey);
			this.dragEvent = dragEvent;
			this.list = list;
			this.dayRenderer = dayRenderer;
		}

	//----------------------------------
	//  dayRenderer
	//----------------------------------
	/**
	 *  This is a reference to the dayRenderer that triggered the original DragEvent.
	 */
	public var dayRenderer : Object;
		
    //----------------------------------
    //  dragEvent
    //----------------------------------
    /**
     *  This is a reference to the original DragEvent that started the event chain.  By default this was fired from a list based class in the dayRenderer.
     */
    public var dragEvent : DragEvent;

    //----------------------------------
    //  list
    //----------------------------------
    /**
     *  This is a reference to the list based class in the dayRender that triggered the initial DragEvent.  If using the default DayRenderer this will be a List.
     */
    public var list: ListBase;


    /**
     *  @private
     */
    override public function clone():Event
    {  
        return new CalendarDragEvent(type, bubbles, cancelable, dragInitiator, dragSource, action, ctrlKey, altKey, shiftKey, dragEvent, list, dayRenderer );
    }
		
	}
}