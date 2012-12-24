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

	/**
	 * An event class that defines the static constants for events that reflect a change in displayed date of the Calendar.
	 * 
	 * @author DotComIt / Flextras
	 * 
	 * @see com.flextras.calendar.Calendar
	 */
	public class CalendarChangeEvent extends Event
	{
		
		/**
		 * The CalendarChangeEvent.EXPAND_DAY constant defines the value of the <code>type</code> property of the CalendarChangeEvent object for a <code>expandDay</code> event, which indicates that the user requested the component change to the day state.  By default this is dispatched by clicking a button in the dayRenderer.
		 *
		 *  <p>The properties of the event object have the following values:</p>
		 * 
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the event listener that handles the event.
		 * 		For example, if you use <code>myButton.addEventListener()</code> to register an event listener, 
		 * 		myButton is the value of the <code>currentTarget</code>. 
		 * </td></tr>
		 *     <tr><td><code>dayToExpand</code></td><td>This is a reference to the dayRenderer that fired off the original event.</td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
		 *       it is not always the Object listening for the event. 
		 *       Use the <code>currentTarget</code> property to always access the 
		 *       Object listening for the event.</td></tr>
		 *     <tr><td><code>Type</code></td><td>CalendarChangeEvent.EXPAND_DAY</td></tr>
		 *  </table>
		 *
		 *  @eventType expandDay
		 */
		public static const EXPAND_DAY : String = 'expandDay';
		
		/**
		 *  The CalendarChangeEvent.EXPAND_MONTH constant defines the value of the <code>type</code> property of the CalendarChangeEvent object for a <code>expandMonth</code> event, which indicates that the user requested the component change to the month state.  By default this is dispatched by clicking a button in the dayRenderer.  
		 *
		 *  <p>The properties of the event object have the following values:</p>
		 * 
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the event listener that handles the event.
		 * 		For example, if you use <code>myButton.addEventListener()</code> to register an event listener, 
		 * 		myButton is the value of the <code>currentTarget</code>. 
		 * </td></tr>
		 *     <tr><td><code>dayToExpand</code></td><td>This is a reference to the dayRenderer that fired off the original event.</td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
		 *       it is not always the Object listening for the event. 
		 *       Use the <code>currentTarget</code> property to always access the 
		 *       Object listening for the event.</td></tr>
		 *     <tr><td><code>Type</code></td><td>CalendarChangeEvent.EXPAND_MONTH</td></tr>
		 *  </table>
		 *
		 *  @eventType expandMonth
		 */
		public static const EXPAND_MONTH : String = 'expandMonth';

		
		/**
		 *  The CalendarChangeEvent.EXPAND_WEEK constant defines the value of the <code>type</code> property of the CalendarChangeEvent object for a <code>expandWeek</code> event, which indicates that the user requested the component change to the week state.  By default this is dispatched by clicking a button in the dayRenderer.  
		 *
		 *  <p>The properties of the event object have the following values:</p>
		 * 
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the event listener that handles the event.
		 * 		For example, if you use <code>myButton.addEventListener()</code> to register an event listener, 
		 * 		myButton is the value of the <code>currentTarget</code>. * </td></tr>
		 *     <tr><td><code>dayToExpand</code></td><td>This is a reference to the dayRenderer that fired off the original event.</td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
		 *       it is not always the Object listening for the event. 
		 *       Use the <code>currentTarget</code> property to always access the 
		 *       Object listening for the event.</td></tr>
		 *     <tr><td><code>Type</code></td><td>CalendarChangeEvent.EXPAND_WEEK</td></tr>
		 *  </table>
		 *
		 *  @eventType expandWeek
		 */
		public static const EXPAND_WEEK : String = 'expandWeek';
		
	    /**
	     * The CalendarChangeEvent.NEXT_DAY constant defines the value of the <code>type</code> property of the CalendarChangeEvent object for a <code>nextDay</code> event, which indicates that the user requested that the Calendar component’s displayedDate value increment.  By default this value is dispatched from the dayHeaderRenderer.  
		 * 
	     *  <p>The properties of the event object have the following values:</p>
	     * 
	     *  <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
	     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
	     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
	     *       event listener that handles the event.For example, if you use 
	     *       <code>myButton.addEventListener()</code> to register an event listener, 
	     *       myButton is the value of the <code>currentTarget</code>.</td></tr>
		 *     <tr><td><code>dayToExpand</code></td><td>This is a reference to the dayRenderer that fired off the original event.</td></tr>
	     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
	     *       it is not always the Object listening for the event.
	     *       Use the <code>currentTarget</code> property to always access the 
	     *       Object listening for the event.</td></tr>
	     *     <tr><td><code>Type</code></td><td>CalendarChangeEvent.NEXT_DAY</td></tr>
	     *  </table>
	     *
	     *  @eventType nextDay
	     */
		public static const NEXT_DAY : String = 'nextDay'

	    /**
	     *  The CalendarChangeEvent.NEXT_DAY constant defines the value of the <code>type</code> property of the CalendarChangeEvent object for a <code>nextMonth</code> event, which indicates that the user requested that the Calendar component’s displayedMonth value increment.  By default this value is dispatched from the monthHeaderRenderer.  
		 * 
	     *  <p>The properties of the event object have the following values:</p>
	     * 
	     *  <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
	     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
	     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the event listener that handles the event.
	     * 		For example, if you use <code>myButton.addEventListener()</code> to register an event listener, 
	     * 		myButton is the value of the <code>currentTarget</code>. 
	     * </td></tr>
		 *     <tr><td><code>dayToExpand</code></td><td>This is a reference to the dayRenderer that fired off the original event.</td></tr>
	     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
	     *       it is not always the Object listening for the event. 
	     *       Use the <code>currentTarget</code> property to always access the 
	     *       Object listening for the event.</td></tr>
	     *     <tr><td><code>Type</code></td><td>CalendarChangeEvent.NEXT_MONTH</td></tr>
	     *  </table>
	     *
	     *  @eventType nextMonth
	     */
		public static const NEXT_MONTH : String = 'nextMonth'

		
		/**
		 *  The CalendarChangeEvent.NEXT_WEEK constant defines the value of the <code>type</code> property of the CalendarChangeEvent object for a <code>nextWeek</code> event, which indicates that the user requested that the Calendar component’s displayedDate  value increment by seven days.  By default this value is dispatched from the weekHeaderRenderer.  
		 * 
		 *  <p>The properties of the event object have the following values:</p>
		 * 
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
		 *       event listener that handles the event.For example, if you use 
		 *       <code>myButton.addEventListener()</code> to register an event listener, 
		 *       myButton is the value of the <code>currentTarget</code>.</td></tr>
		 *     <tr><td><code>dayToExpand</code></td><td>This is a reference to the dayRenderer that fired off the original event.</td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
		 *       it is not always the Object listening for the event.
		 *       Use the <code>currentTarget</code> property to always access the 
		 *       Object listening for the event.</td></tr>
		 *     <tr><td><code>Type</code></td><td>CalendarChangeEvent.NEXT_WEEK</td></tr>
		 *  </table>
		 *
		 *  @eventType nextWeek
		 */
		public static const NEXT_WEEK : String = 'nextWeek'
			
	    /**
	     *  The CalendarChangeEvent.NEXT_YEAR constant defines the value of the <code>type</code> property of the CalendarChangeEvent object for a <code>nextYear</code> event, which indicates that the user requested that the Calendar component’s displayedYear value increment.  By default this value is dispatched from the monthHeaderRenderer.  
	     *
	     *  <p>The properties of the event object have the following values:</p>
	     * 
	     *  <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
	     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
	     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
	     *       event listener that handles the event.For example, if you use 
	     *       <code>myButton.addEventListener()</code> to register an event listener, 
	     *       myButton is the value of the <code>currentTarget</code>.</td></tr>
		 *     <tr><td><code>dayToExpand</code></td><td>This is a reference to the dayRenderer that fired off the original event.</td></tr>
	     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
	     *       it is not always the Object listening for the event.
	     *       Use the <code>currentTarget</code> property to always access the 
	     *       Object listening for the event.</td></tr>
	     *     <tr><td><code>Type</code></td><td>CalendarChangeEvent.NEXT_YEAR</td></tr>
	     *  </table>
	     *
	     *  @eventType nextYear
	     */
		public static const NEXT_YEAR : String = 'nextYear'

		
		/**
		 *  The CalendarChangeEvent. PREVIOUS_DAY constant defines the value of the <code>type</code> property of the CalendarChangeEvent object for a <code>previousDay</code> event, which indicates that the user requested that the Calendar component’s displayedDate value decrement.  By default this value is dispatched from the dayHeaderRenderer.  
		 *
		 *  <p>The properties of the event object have the following values:</p>
		 * 
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
		 *       event listener that handles the event.For example, if you use 
		 *       <code>myButton.addEventListener()</code> to register an event listener, 
		 *       myButton is the value of the <code>currentTarget</code>.</td></tr>
		 *     <tr><td><code>dayToExpand</code></td><td>This is a reference to the dayRenderer that fired off the original event.</td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
		 *       it is not always the Object listening for the event.
		 *       Use the <code>currentTarget</code> property to always access the 
		 *       Object listening for the event.</td></tr>
		 *     <tr><td><code>Type</code></td><td>CalendarChangeEvent.PREVIOUS_DAY</td></tr>
		 *  </table>
		 *
		 *  @eventType previousDay
		 */
		public static const PREVIOUS_DAY : String = 'previousDay'
			
	    /**
	     *  The CalendarChangeEvent. PREVIOUS_DAY constant defines the value of the <code>type</code> property of the CalendarChangeEvent object for a <code>previousMonth</code> event, which indicates that the user requested that the Calendar component’s displayedMonth value decrement.  By default this value is dispatched from the monthHeaderRenderer.  
	     *
	     *  <p>The properties of the event object have the following values:</p>
	     * 
	     *  <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
	     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
	     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
	     *       event listener that handles the event.For example, if you use 
	     *       <code>myButton.addEventListener()</code> to register an event listener, 
	     *       myButton is the value of the <code>currentTarget</code>.</td></tr>
		 *     <tr><td><code>dayToExpand</code></td><td>This is a reference to the dayRenderer that fired off the original event.</td></tr>
	     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
	     *       it is not always the Object listening for the event.
	     *       Use the <code>currentTarget</code> property to always access the 
	     *       Object listening for the event.</td></tr>
	     *     <tr><td><code>Type</code></td><td>CalendarChangeEvent.PREVIOUS_MONTH</td></tr>
	     *  </table>
	     *
	     *  @eventType previousMonth
	     */
		public static const PREVIOUS_MONTH : String = 'previousMonth'

		
		/**
		 *  The CalendarChangeEvent. PREVIOUS_WEEK constant defines the value of the <code>type</code> property of the CalendarChangeEvent object for a <code>previousWeek</code> event, which indicates that the user requested that the Calendar component’s displayedDate value decrement by seven days.  By default this value is dispatched from the weekHeaderRenderer.  
		 *
		 *  <p>The properties of the event object have the following values:</p>
		 * 
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
		 *       event listener that handles the event.For example, if you use 
		 *       <code>myButton.addEventListener()</code> to register an event listener, 
		 *       myButton is the value of the <code>currentTarget</code>.</td></tr>
		 *     <tr><td><code>dayToExpand</code></td><td>This is a reference to the dayRenderer that fired off the original event.</td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
		 *       it is not always the Object listening for the event.
		 *       Use the <code>currentTarget</code> property to always access the 
		 *       Object listening for the event.</td></tr>
		 *     <tr><td><code>Type</code></td><td>CalendarChangeEvent.PREVIOUS_WEEK</td></tr>
		 *  </table>
		 *
		 *  @eventType previousWeek
		 */
		public static const PREVIOUS_WEEK : String = 'previousWeek'
			
	    /**
	     *  The CalendarChangeEvent.NEXT_YEAR constant defines the value of the <code>type</code> property of the CalendarChangeEvent object for a <code>previousYear</code> event, which indicates that the user requested that the Calendar component’s displayedYear value decrement.  By default this value is dispatched from the monthHeaderRenderer.  
	     *
	     *  <p>The properties of the event object have the following values:</p>
	     * 
	     *  <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
	     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
	     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
	     *       event listener that handles the event.For example, if you use 
	     *       <code>myButton.addEventListener()</code> to register an event listener, 
	     *       myButton is the value of the <code>currentTarget</code>.</td></tr>
		 *     <tr><td><code>dayToExpand</code></td><td>This is a reference to the dayRenderer that fired off the original event.</td></tr>
	     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
	     *       it is not always the Object listening for the event.
	     *       Use the <code>currentTarget</code> property to always access the 
	     *       Object listening for the event.</td></tr>
	     *     <tr><td><code>Type</code></td><td>CalendarChangeEvent.PREVIOUS_YEAR</td></tr>
	     *  </table>
	     *
	     *  @eventType previousYear
	     */
		public static const PREVIOUS_YEAR : String = 'previousYear'



		/**
		 *  Constructor.
		 */
		public function CalendarChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, dayToExpand : IDayRenderer = null)
		{
			super(type, bubbles, cancelable);
			this.dayToExpand = dayToExpand;
		}
		
		
		//----------------------------------
		//  dayToExpand
		//----------------------------------
		/**
		 * @private
		 */
		private var _dayToExpand : IDayRenderer = null;
		/**
		 * This contains a reference to the day that triggered the event.
		 */
		public function get dayToExpand():IDayRenderer
		{
			return this._dayToExpand;
		}
		/**
		 * @private
		 */
		public function set dayToExpand(value:IDayRenderer):void
		{
			this._dayToExpand = value;
		}
		
	    /**
	     *  @private
	     */
	    override public function clone():Event
	    { 
	        return new CalendarChangeEvent(this.type, this.bubbles, this.cancelable, this.dayToExpand );
	    }
		
	}
}