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
package com.flextras.autoCompleteComboBox
{
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	/**
	 *   The <code>TypeAheadTimerEvent</code> class represents time events related to the type-ahead functionality of the AutoCompleteComboBox.  
	 * 
	 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox
  	 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox#typeAheadEnabled
  	 */	
	public class TypeAheadTimerEvent extends TimerEvent
	{

	    /**
	     *  The <code>TypeAheadTimerEvent.TYPEAHEAD_RELEASETIMER_COMPLETE</code> constant defines the value of the <code>type</code> property of the TypeAheadTimerEvent object for an <code>TYPEAHEAD_RELEASETIMER_COMPLETE</code> event, which indicates that the type-ahead timer is complete, therefore setting the <code>typeAheadText</code> property of the <code>AutoCompleteComboBox</code> to an empty string.
	     *
	     *  <p>The properties of the event object have the following values:</p>
	     * 
	     *  <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
	     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
	     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
	     *       event listener that handles the event. For example, if you use 
	     *       <code>myButton.addEventListener()</code> to register an event listener, 
	     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
	     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
	     *       it is not always the Object listening for the event. 
	     *       Use the <code>currentTarget</code> property to always access the 
	     *       Object listening for the event.</td></tr>
	     *     <tr><td><code>Type</code></td><td>TypeAheadTimerEvent.TYPEAHEAD_RELEASETIMER_COMPLETE</td></tr>
	     *     <tr><td><code>typeAheadText</code></td><td>Contains the text before the type-ahead string was made empty.</td></tr>
  	     *  </table>
	     *
	     *  @eventType typeAheadReleaseTimerComplete
		 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox
	  	 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox#typeAheadEnabled
	  	 */	
	    public static const TYPEAHEAD_RELEASETIMER_COMPLETE:String = "typeAheadReleaseTimerComplete";

	    /**
	     *  The <code>TypeAheadTimerEvent.TYPEAHEAD_RELEASETIMER_START</code> constant defines the value of the <code>type</code> property of the <code>TypeAheadTimerEvent</code> object for a <code>TYPEAHEAD_RELEASETIMER_START</code> event.  This most likely means that the user has typed a new character and the type-ahead timer has either started, or reset it self.
	     *
	     *  <p>The properties of the event object have the following values:</p>
	     * 
	     *  <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
	     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
	     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
	     *       event listener that handles the event. For example, if you use 
	     *       <code>myButton.addEventListener()</code> to register an event listener, 
	     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
	     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
	     *       it is not always the Object listening for the event. 
	     *       Use the <code>currentTarget</code> property to always access the 
	     *       Object listening for the event.</td></tr>
	     *     <tr><td><code>Type</code></td><td>TypeAheadTimerEvent.TYPEAHEAD_RELEASETIMER_START</td></tr>
	     *     <tr><td><code>typeAheadText</code></td><td>Contains the current type-ahead text string</td></tr>
  	     *  </table>
	     *
	     *  @eventType typeAheadReleaseTimerStart
		 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox
	  	 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox#typeAheadEnabled
	  	 */	
	    public static const TYPEAHEAD_RELEASETIMER_START:String = "typeAheadReleaseTimerStart";

	    /**
	     *  The <code>TypeAheadTimerEvent.TYPEAHEAD_RELEASETIMER_STOP</code> constant defines the value of the <code>type</code> property of the <code>TypeAheadTimerEvent</code> object for an <code>TYPEAHEAD_RELEASETIMER_STOP</code> event, which indicates that the type-ahead timer has been stopped.  The most likely cause of this is that the user typed another character and the timer needs to start anew.
	     *
	     *  <p>The properties of the event object have the following values:</p>
	     * 
	     *  <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
	     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
	     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
	     *       event listener that handles the event. For example, if you use 
	     *       <code>myButton.addEventListener()</code> to register an event listener, 
	     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
	     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
	     *       it is not always the Object listening for the event. 
	     *       Use the <code>currentTarget</code> property to always access the 
	     *       Object listening for the event.</td></tr>
	     *     <tr><td><code>Type</code></td><td>TypeAheadTimerEvent.TYPEAHEAD_RELEASETIMER_STOP</td></tr>
	     *     <tr><td><code>typeAheadText</code></td><td>Contains the current type-ahead text string.</td></tr>
  	     *  </table>
	     *
	     *  @eventType typeAheadReleaseTimerStop
		 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox
	  	 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox#typeAheadEnabled
	  	 */	
	    public static const TYPEAHEAD_RELEASETIMER_STOP:String = "typeAheadReleaseTimerStop";


		/**
		 * constructor
		 */
		public function TypeAheadTimerEvent(argTypeAheadText:String, type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.typeAheadText = argTypeAheadText;
			super(type, bubbles, cancelable);
		}



		/**
		 *  @private
		 *  Storage for the typeAhead Text property.
		 */
		private var _typeAheadText:String;

	    /**
	     *  The <code>typeAheadText</code> property contains the text the user typed.  If we're at the <code>TYPEAHEAD_RELEASETIMER_START</code> event, it contains the current <code>typeAheadText</code>.  If we're at <code>TYPEAHEAD_RELEASETIMER_COMPLETE</code>, it is the text before the string was emptied.  
	     */
		public function get typeAheadText():String
		{
			return _typeAheadText;
		}
		
		/**
		 *  @private
		 */
		public function set typeAheadText(value:String):void
		{
			_typeAheadText = value;
		}

	    /**
	     *  @private
	     */
	    override public function clone():Event
	    { 
	        return new TypeAheadTimerEvent(typeAheadText,type, bubbles, cancelable);
	    }

	}
}