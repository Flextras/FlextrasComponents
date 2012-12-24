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
	
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.listClasses.ListBase;
	import mx.events.ListEvent;

	/**
	 * This is an event class that defines the static constants for list based events inside a Flextras Calendar component.  This class is a wrapper for the ListEvent with some additional properties to make it easier to drill down into the dayRenderer in your event handler, if needed.  These events are dispatched from the dayRenderers.  
	 * 
	 *  You can access the date of this renderer using dayRenderer.dayData.displayedDateObject. 
	 * 
	 * @author DotComIt / Flextras
	 * @see com.flextras.calendar.Calendar 
	 * @see com.flextras.calendar.defaultRenderers.DayRenderer
	 */
	public class CalendarEvent extends ListEvent
	{

    /**
     *  The CalendarEvent.CHANGE constant defines the value of the 
     *  <code>type</code> property of the CalendarEvent object for a
     *  <code>change</code> event, which indicates that selection
     *  changed as a result of user interaction.
     * 
     *  <p>This is a wrapper to the events dispatched by the dayRenderer's of the 
     * Calendar class.</p>
     *
     *  <p>The properties of the event object have the following values:</p>
     * 
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>columnIndex</code></td><td> The zero-based index of the 
     *        column associated with the event.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dayRenderer</code></td><td>This is a reference to the dayRenderer that triggered the original event.</td></tr>
     *     <tr><td><code>itemRenderer</code></td><td>The item renderer that was  
     *        clicked.</td></tr>
     *     <tr><td><code>list</code></td><td>This is a reference to the list based class in the dayRender that triggered the initial ListEvent.  If using the default DayRenderer this will be a List.</td></tr>
     *     <tr><td><code>listEvent</code></td><td>This is a reference to the original ListEvent that started the event chain.</td></tr>
     *     <tr><td><code>newDate</code></td><td>null</td></tr>
     *     <tr><td><code>oldDate</code></td><td>null</td></tr>
     *     <tr><td><code>reason</code></td><td>null</td></tr>
     *     <tr><td><code>rowIndex</code></td><td>The zero-based index of the 
     *        item associated with the event.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>Type</code></td><td>CalendarEvent.CHANGE</td></tr>
     *  </table>
     *
     *  @eventType change
     */
    public static const CHANGE:String = "change";

	
	/**
	 *  The CalendarEvent.DATE_CHANGED constant defines the value of the 
	 *  <code>type</code> property of the CalendarEvent object for a
	 *  <code>dateChanged</code> event, which indicates that the Calendar's displayedYear, displayedDate, or displayedMonth 
	 * has changed. 
	 * 
	 *  <p>This is a wrapper to the events dispatched by the dayRenderer's of the 
	 * Calendar class.</p>
	 *
	 *  <p>The properties of the event object have the following values:</p>
	 * 
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
	 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
	 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
	 *     <tr><td><code>columnIndex</code></td><td> The zero-based index of the 
	 *        column associated with the event.</td></tr>
	 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
	 *       event listener that handles the event. For example, if you use 
	 *       <code>myButton.addEventListener()</code> to register an event listener, 
	 *       myButton is the value of the <code>currentTarget</code>. </td></tr>
	 *     <tr><td><code>dayRenderer</code></td><td>This is a reference to the dayRenderer that triggered the original event.</td></tr>
	 *     <tr><td><code>itemRenderer</code></td><td>The item renderer that was  
	 *        clicked.</td></tr>
	 *     <tr><td><code>list</code></td><td>This is a reference to the list based class in the dayRender that triggered the initial ListEvent.  If using the default DayRenderer this will be a List.</td></tr>
	 *     <tr><td><code>listEvent</code></td><td>This is a reference to the original ListEvent that started the event chain.</td></tr>
     *     <tr><td><code>newDate</code></td><td>This is the current date of the Calendar.</td></tr>
     *     <tr><td><code>oldDate</code></td><td>This is the date of the Calendar before the date change.</td></tr>
	 *     <tr><td><code>reason</code></td><td>null</td></tr>
	 *     <tr><td><code>rowIndex</code></td><td>The zero-based index of the 
	 *        item associated with the event.</td></tr>
	 *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
	 *       it is not always the Object listening for the event. 
	 *       Use the <code>currentTarget</code> property to always access the 
	 *       Object listening for the event.</td></tr>
	 *     <tr><td><code>Type</code></td><td>CalendarEvent.DATE_CHANGED</td></tr>
	 *  </table>
	 *
	 *  @eventType dateChanged
	 */
	public static const DATE_CHANGED:String = "dateChanged";
	
    /**
     *  The CalendarEvent.ITEM_CLICK constant defines the value of the 
     *  <code>type</code> property of the CalendarEvent object for an
     *  <code>itemClick</code> event, which indicates that the 
     *  user clicked the mouse over a visual item in the control.
     * 
     *  <p>This is a wrapper to the events dispatched by the dayRenderer's of the 
     * Calendar class.</p>
     *
     *  <p>The properties of the event object have the following values:</p>
     * 
     * 
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>columnIndex</code></td><td> The zero-based index of the 
     *        column associated with the event.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dayRenderer</code></td><td>This is a reference to the dayRenderer that triggered the original event.</td></tr>
     *     <tr><td><code>itemRenderer</code></td><td>The item renderer that was  
     *        clicked.</td></tr>
     *     <tr><td><code>list</code></td><td>This is a reference to the list based class in the dayRender that triggered the initial ListEvent.  If using the default DayRenderer this will be a List.</td></tr>
     *     <tr><td><code>listEvent</code></td><td>This is a reference to the original ListEvent that started the event chain.</td></tr>
     *     <tr><td><code>newDate</code></td><td>null</td></tr>
     *     <tr><td><code>oldDate</code></td><td>null</td></tr>
     *     <tr><td><code>reason</code></td><td>null</td></tr>
     *     <tr><td><code>rowIndex</code></td><td>The zero-based index of the 
     *        item associated with the event.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>Type</code></td><td>CalendarEvent.ITEM_CLICK</td></tr>
     *  </table>
     *
     *  @eventType itemClick
     */
    public static const ITEM_CLICK:String = "itemClick";

    /**
     *  The CalendarEvent.ITEM_DOUBLE_CLICK constant defines the value of the 
     *  <code>type</code> property of the ListEvent object for an
     *  <code>itemDoubleClick</code> event, which indicates that the 
     *  user double clicked the mouse over a visual item in the control.
     * 
     *  <p>To receive itemDoubleClick events, you must set the component's
     *  <code>doubleClickEnabled</code> property to <code>true</code>.</p>
     *
     *  <p>This is a wrapper to the events dispatched by the dayRenderer's of the 
     * Calendar class.</p>
     *
     *  <p>The properties of the event object have the following values:</p>
     * 
     * 
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>columnIndex</code></td><td> The zero-based index of the 
     *        column associated with the event.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dayRenderer</code></td><td>This is a reference to the dayRenderer that triggered the original event.</td></tr>
     *     <tr><td><code>itemRenderer</code></td><td>The item renderer that was  
     *        clicked.</td></tr>
     *     <tr><td><code>list</code></td><td>This is a reference to the list based class in the dayRender that triggered the initial ListEvent.  If using the default DayRenderer this will be a List.</td></tr>
     *     <tr><td><code>listEvent</code></td><td>This is a reference to the original ListEvent that started the event chain.</td></tr>
     *     <tr><td><code>newDate</code></td><td>null</td></tr>
     *     <tr><td><code>oldDate</code></td><td>null</td></tr>
     *     <tr><td><code>reason</code></td><td>null</td></tr>
     *     <tr><td><code>rowIndex</code></td><td>The zero-based index of the 
     *        item associated with the event.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>Type</code></td><td>CalendarEvent.ITEM_DOUBLE_CLICK</td></tr>
     *  </table>
     *
     *  @eventType itemDoubleClick
     */
    public static const ITEM_DOUBLE_CLICK:String = "itemDoubleClick";
    
    /**
     *  The CalendarEvent.ITEM_EDIT_BEGIN constant defines the value of the 
     *  <code>type</code> property of the event object for a 
     *  <code>itemEditBegin</code> event, which indicates that an 
     *  item is ready to be edited.  
     * 
     *  <p>This is a wrapper to the events dispatched by the dayRenderer's of the 
     * Calendar class.</p>
     *
     *  <p>The default listener for this event performs the following actions:</p>
     * 
     *  <ul>
     *    <li>Creates an item editor object via a call to the
     *    <code>list.createItemEditor()</code> method.</li>
     *    <li>Copies the <code>data</code> property
     *    from the item to the editor. By default, the item editor object is an instance 
     *    of the TextInput control. You use the <code>itemEditor</code> property of the 
     *    calendar control to specify a custom item editor class.</li>
     *
     *    <li>Set the <code>itemEditorInstance</code> property of the calendar control 
     *    to reference the item editor instance.</li>
     *  </ul>
     *
     *  <p>You can write an event listener for this event to modify the data passed to 
     *  the item editor. For example, you might modify the data, its format, or other information 
     *  used by the item editor.</p>
     *
     *  <p>You can also create an event listener to specify the item editor used to 
     *  edit the item. For example, you might have two different item editors. 
     *  Within the event listener you can examine the data to be edited or 
     *  other information, and open the appropriate item editor by doing the following:</p>
     * 
     *  <ol>
     *     <li>Call <code>preventDefault()</code> to stop Flex from calling 
     *         the <code>createItemEditor()</code> method as part 
     *         of the default event listener.</li>
     *     <li>Set the <code>list.itemEditor</code> property to the appropriate editor.</li>
     *     <li>Call the <code>list.createItemEditor()</code> method.</li>
     *  </ol>
     *
     *  <p>The properties of the event object have the following values:</p>
     * 
     * 
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>columnIndex</code></td><td> The zero-based index of the 
     *        column associated with the event.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dayRenderer</code></td><td>This is a reference to the dayRenderer that triggered the original ListEvent.</td></tr>
     *     <tr><td><code>itemRenderer</code></td><td>The item renderer that was  
     *        clicked.</td></tr>
     *     <tr><td><code>list</code></td><td>This is a reference to the list based class in the dayRender that triggered the initial ListEvent.  If using the default DayRenderer this will be a List.</td></tr>
     *     <tr><td><code>listEvent</code></td><td>This is a reference to the original ListEvent that started the event chain.</td></tr>
     *     <tr><td><code>newDate</code></td><td>null</td></tr>
     *     <tr><td><code>oldDate</code></td><td>null</td></tr>
     *     <tr><td><code>reason</code></td><td>null</td></tr>
     *     <tr><td><code>rowIndex</code></td><td>The zero-based index of the 
     *        item associated with the event.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>Type</code></td><td>CalendarEvent.ITEM_EDIT_BEGIN</td></tr>
     *  </table>
     *
     *  @eventType itemEditBegin
     */
    public static const ITEM_EDIT_BEGIN:String = "itemEditBegin";

    /**
     *  The ListEvent.ITEM_EDIT_BEGINNING constant defines the value of the 
     *  <code>type</code> property of the event object for a 
     *  <code>itemEditBeginning</code> event, which indicates that the user has 
     *  prepared to edit an item, for example, by releasing the mouse button 
     *  over the item. This happens in a ListBase class in the dayRenderer.
     * 
     *  <p>This is a wrapper to the events dispatched by the dayRenderer's of the 
     * Calendar class.</p>
     *
     *  <p>The default listener for this event sets the <code>List.editedItemPosition</code> 
     *  property to the item that has focus, which starts the item editing session.</p>
     *
     *  <p>You typically write your own event listener for this event to 
     *  disallow editing of a specific item or items. 
     *  Calling the <code>preventDefault()</code> method from within your own 
     *  event listener for this event prevents the default listener from executing.</p>
     *
     *  <p>The properties of the event object have the following values:</p>
     * 
     * 
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>columnIndex</code></td><td> The zero-based index of the 
     *        column associated with the event.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dayRenderer</code></td><td>This is a reference to the dayRenderer that triggered the original ListEvent.</td></tr>
     *     <tr><td><code>itemRenderer</code></td><td>The item renderer that was  
     *        clicked.</td></tr>
     *     <tr><td><code>list</code></td><td>This is a reference to the list based class in the dayRender that triggered the initial ListEvent.  If using the default DayRenderer this will be a List.</td></tr>
     *     <tr><td><code>listEvent</code></td><td>This is a reference to the original ListEvent that started the event chain.</td></tr>
     *     <tr><td><code>newDate</code></td><td>null</td></tr>
     *     <tr><td><code>oldDate</code></td><td>null</td></tr>
     *     <tr><td><code>reason</code></td><td>null</td></tr>
     *     <tr><td><code>rowIndex</code></td><td>The zero-based index of the 
     *        item associated with the event.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>Type</code></td><td>CalendarEvent.ITEM_EDIT_BEGINNING</td></tr>
     *  </table>
     *
     *  @eventType itemEditBeginning
     */
    public static const ITEM_EDIT_BEGINNING:String = "itemEditBeginning";

    /**
     *  The ListEvent.ITEM_EDIT_END constant defines the value of the 
     *  <code>type</code> property of the ListEvent object for a 
     *  <code>itemEditEnd</code> event, which indicates that an edit 
     *  session is ending. 
     *
     *  <p>This is a wrapper to the events dispatched by the dayRenderer's of the 
     * Calendar class.</p>
     * 
     *  <p>The list components have a default handler for this event that copies the data 
     *  from the item editor to the data provider of the list control. 
     *  The default event listener performs the following actions:</p>
     * 
     *  <ul>
     *    <li>Uses the <code>editorDataField</code> property of the list control to determine 
     *    the property of the item editor containing the new data and updates
     *    the data provider item with that new data.  Since the default item editor 
     *    is the TextInput control, the default value of the <code>editorDataField</code> property 
     *    is <code>"text"</code>, to specify that the <code>text</code> property of the 
     *    TextInput contains the new item data.</li>
     *
     *    <li>Calls the <code>list.destroyItemEditor()</code> method to close the item editor.</li>
     *  </ul>
     *
     *  <p>You typically write an event listener for this event to perform the following actions:</p>
     *  <ul>
     *    <li>In your event listener, you can modify the data returned by the editor 
     *    to the list component. For example, you can reformat the data before returning 
     *    it to the list control. By default, an item editor can only return a single value. 
     *    You must write an event listener for the <code>itemEditEnd</code> event 
     *    if you want to return multiple values.</li> 
     *
     *    <li>In your event listener, you can examine the data entered into the item editor. 
     *    If the data is incorrect, you can call the <code>preventDefault()</code> method 
     *    to stop Flex from passing the new data back to the list control and from closing 
     *    the editor. </li>
     *  </ul>
     *
     *  <p>The properties of the event object have the following values:</p>
     * 
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>columnIndex</code></td><td> The zero-based index of the 
     *        column associated with the event.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dayRenderer</code></td><td>This is a reference to the dayRenderer that triggered the original ListEvent.</td></tr>
     *     <tr><td><code>itemRenderer</code></td><td>The item renderer that was  
     *        clicked.</td></tr>
     *     <tr><td><code>list</code></td><td>This is a reference to the list based class in the dayRender that triggered the initial ListEvent.  If using the default DayRenderer this will be a List.</td></tr>
     *     <tr><td><code>listEvent</code></td><td>This is a reference to the original ListEvent that started the event chain.</td></tr>
     *     <tr><td><code>newDate</code></td><td>null</td></tr>
     *     <tr><td><code>oldDate</code></td><td>null</td></tr>
     *     <tr><td><code>reason</code></td><td>null</td></tr>
     *     <tr><td><code>rowIndex</code></td><td>The zero-based index of the 
     *        item associated with the event.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>Type</code></td><td>CalendarEvent.ITEM_EDIT_END</td></tr>
     *  </table>
     *
     *  @eventType itemEditEnd
     */
    public static const ITEM_EDIT_END:String = "itemEditEnd"

    /**
     *  The CalendarEvent.ITEM_FOCUS_IN constant defines the value of the 
     *  <code>type</code> property of the CalendarEvent object for an
     *  <code>itemFocusIn</code> event, which indicates that an item 
     *  has received the focus.
     *
     *  <p>This is a wrapper to the events dispatched by the dayRenderer's of the 
     * Calendar class.</p>
     *
     *  <p>The properties of the event object have the following values:</p>
     * 
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>columnIndex</code></td><td> The zero-based index of the 
     *        column associated with the event.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dayRenderer</code></td><td>This is a reference to the dayRenderer that triggered the original event.</td></tr>
     *     <tr><td><code>itemRenderer</code></td><td>The item renderer that was  
     *        clicked.</td></tr>
     *     <tr><td><code>list</code></td><td>This is a reference to the list based class in the dayRender that triggered the initial ListEvent.  If using the default DayRenderer this will be a List.</td></tr>
     *     <tr><td><code>listEvent</code></td><td>This is a reference to the original ListEvent that started the event chain.</td></tr>
     *     <tr><td><code>newDate</code></td><td>null</td></tr>
     *     <tr><td><code>oldDate</code></td><td>null</td></tr>
     *     <tr><td><code>reason</code></td><td>null</td></tr>
     *     <tr><td><code>rowIndex</code></td><td>The zero-based index of the 
     *        item associated with the event.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>Type</code></td><td>CalendarEvent.ITEM_FOCUS_IN</td></tr>
     *  </table>
     *
     *  @eventType itemFocusIn
     */
    public static const ITEM_FOCUS_IN:String = "itemFocusIn";

    /**
     *  The CalendarEvent.ITEM_FOCUS_OUT constant defines the value of the 
     *  <code>type</code> property of the CalendarEvent object for an
     *  <code>itemFocusOut</code> event, which indicates that an item 
     *  has lost the focus.
     *
     *  <p>This is a wrapper to the events dispatched by the dayRenderer's of the 
     * Calendar class.</p>
     *
     *  <p>The properties of the event object have the following values:</p>
     * 
     * 
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>columnIndex</code></td><td> The zero-based index of the 
     *        column associated with the event.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dayRenderer</code></td><td>This is a reference to the dayRenderer that triggered the original event.</td></tr>
     *     <tr><td><code>itemRenderer</code></td><td>The item renderer that was  
     *        clicked.</td></tr>
     *     <tr><td><code>list</code></td><td>This is a reference to the list based class in the dayRender that triggered the initial ListEvent.  If using the default DayRenderer this will be a List.</td></tr>
     *     <tr><td><code>listEvent</code></td><td>This is a reference to the original ListEvent that started the event chain.</td></tr>
     *     <tr><td><code>newDate</code></td><td>null</td></tr>
     *     <tr><td><code>oldDate</code></td><td>null</td></tr>
     *     <tr><td><code>reason</code></td><td>null</td></tr>
     *     <tr><td><code>rowIndex</code></td><td>The zero-based index of the 
     *        item associated with the event.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>Type</code></td><td>CalendarEvent.ITEM_FOCUS_OUT</td></tr>
     *  </table>
     *
     *  @eventType itemFocusOut
     */
    public static const ITEM_FOCUS_OUT:String = "itemFocusOut";

    /**
     *  The CalendarEvent.ITEM_ROLL_OUT constant defines the value of the 
     *  <code>type</code> property of the ListEvent object for an
     *  <code>itemRollOut</code> event, which indicates that the user rolled 
     *  the mouse pointer out of a visual item in the control.
     *
     *  <p>This is a wrapper to the events dispatched by the dayRenderer's of the 
     * Calendar class.</p>
	 * 
     *  <p>The properties of the event object have the following values:</p>
     * 
     * 
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>columnIndex</code></td><td> The zero-based index of the 
     *        column associated with the event.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dayRenderer</code></td><td>This is a reference to the dayRenderer that triggered the original event.</td></tr>
     *     <tr><td><code>itemRenderer</code></td><td>The item renderer that was  
     *        clicked.</td></tr>
     *     <tr><td><code>list</code></td><td>This is a reference to the list based class in the dayRender that triggered the initial ListEvent.  If using the default DayRenderer this will be a List.</td></tr>
     *     <tr><td><code>listEvent</code></td><td>This is a reference to the original ListEvent that started the event chain.</td></tr>
     *     <tr><td><code>newDate</code></td><td>null</td></tr>
     *     <tr><td><code>oldDate</code></td><td>null</td></tr>
     *     <tr><td><code>reason</code></td><td>null</td></tr>
     *     <tr><td><code>rowIndex</code></td><td>The zero-based index of the 
     *        item associated with the event.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>Type</code></td><td>CalendarEvent.ITEM_ROLL_OUT</td></tr>
     *  </table>
     *
     *  @eventType itemRollOut
     */
    public static const ITEM_ROLL_OUT:String = "itemRollOut";

    /**
     *  The CalendarEvent.ITEM_ROLL_OVER constant defines the value of the 
     *  <code>type</code> property of the ListEvent object for an
     *  <code>itemRollOver</code> event, which indicates that the user rolled 
     *  the mouse pointer over a visual item in the control.
     *
     *  <p>This is a wrapper to the events dispatched by the dayRenderer's of the 
     * Calendar class.</p>
     *
     *  <p>The properties of the event object have the following values:</p>
     * 
     * 
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>columnIndex</code></td><td> The zero-based index of the 
     *        column associated with the event.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dayRenderer</code></td><td>This is a reference to the dayRenderer that triggered the original event.</td></tr>
     *     <tr><td><code>itemRenderer</code></td><td>The item renderer that was  
     *        clicked.</td></tr>
     *     <tr><td><code>list</code></td><td>This is a reference to the list based class in the dayRender that triggered the initial ListEvent.  If using the default DayRenderer this will be a List.</td></tr>
     *     <tr><td><code>listEvent</code></td><td>This is a reference to the original ListEvent that started the event chain.</td></tr>
     *     <tr><td><code>newDate</code></td><td>null</td></tr>
     *     <tr><td><code>oldDate</code></td><td>null</td></tr>
     *     <tr><td><code>reason</code></td><td>null</td></tr>
     *     <tr><td><code>rowIndex</code></td><td>The zero-based index of the 
     *        item associated with the event.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>Type</code></td><td>CalendarEvent.ITEM_ROLL_OVER</td></tr>
     *  </table>
     *
     *  @eventType itemRollOver
     */
    public static const ITEM_ROLL_OVER:String = "itemRollOver";
    
	/**
	 *  Constructor.
	 */
	public function CalendarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, columnIndex:int=-1, rowIndex:int=-1, 
								  reason:String=null, itemRenderer:IListItemRenderer=null, list : ListBase = null, listEvent : ListEvent = null, 
								  dayRenderer : Object = null, newDate :Date = null, oldDate : Date = null)
	{
		super(type, bubbles, cancelable, columnIndex, rowIndex, reason, itemRenderer);
		this.list = list
		this.listEvent = listEvent;
		this.dayRenderer = dayRenderer;
		this.newDate = newDate;
		this.oldDate = oldDate;
	}

	
	//----------------------------------
	//  dayRenderer
	//----------------------------------
	/**
	 *  This is a reference to the dayRenderer that triggered the original ListEvent.
	 */
	public var dayRenderer : Object;
	
	
    //----------------------------------
    //  list
    //----------------------------------
    /**
     *  This is a reference to the list based class in the dayRender that triggered the initial ListEvent.  If using the default DayRenderer this will be a List.
     */
    public var list: ListBase;

    //----------------------------------
    //  listEvent
    //----------------------------------
    /**
     * This is a reference to the original ListEvent that started the event chain.  By default this was fired from a list based class in the dayRenderer.
     */
    public var listEvent : ListEvent;


	//----------------------------------
	//  newDate
	//----------------------------------
	/**
	 *  This is the current date of the Calendar. 
	 */
	public var newDate : Date;

	//----------------------------------
	//  oldDate
	//----------------------------------
	/**
	 *  This is the old date of the Calendar before it was changed.
	 */
	public var oldDate : Date;
	
	
    /**
     *  @private
     */
    override public function clone():Event
    { 
        return new CalendarEvent(type, bubbles, cancelable,
                             columnIndex, rowIndex, reason, itemRenderer,list,listEvent, dayRenderer , newDate , oldDate );
    }

	}
}