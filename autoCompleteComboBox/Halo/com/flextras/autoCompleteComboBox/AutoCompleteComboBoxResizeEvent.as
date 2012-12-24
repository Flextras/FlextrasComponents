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
	import flash.events.Event;
	
	/**
	 *   The <code>AutoCompleteComboBoxResizeEvent</code> class represents drop down resize events associated with the <code>AutoCompleteComboBox</code>, either when the <code>height</code> is changed for AutoComplete purposes, or when the <code>width</code> is expanded for <ode>expandDropDownToContent</code> purposes.
	 *
	 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox
	 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox#autoCompleteEnabled
  	 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox#expandDropDownToContent
  	 */	
	public class AutoCompleteComboBoxResizeEvent extends Event
	{


	    /**
	     *  The <code>AutoCompleteComboBoxEvent.DROPDOWN_WIDTH_EXPAND_BEGIN</code> constant defines the value of the <code>type</code> property of the event object for an event that is dispatched when the <code>AutoCompleteComboBox</code> <code>expandDropDownToContent</code> is set to <code>true</code> and we're about to set a new <code>width</code>.  If this event is cancelled, the <code>width</code> will be set to the <code>width</code> of the <code>AutoCompleteComboBox</code> instance.
	     *
	     *  <p>The properties of the event object have the following values.
	     *  Not all properties are meaningful for all kinds of events.
		 *  See the detailed property descriptions for more information.</p>
	     *  <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
	     *     <tr><td><code>cancelable</code></td><td>true</td></tr>
	     *     <tr><td><code>currentSize</code></td><td>The current width of the drop down</td></tr>
 	     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
	     *       event listener that handles the event. For example, if you use
	     *       <code>myButton.addEventListener()</code> to register an event listener,
	     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
	     *     <tr><td><code>newSize</code></td><td>The new width we're about to set the drop down to</td></tr>
   	     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
	     *       it is not always the Object listening for the event.
	     *       Use the <code>currentTarget</code> property to always access the
	     *       Object listening for the event.</td></tr>
   	     *     <tr><td><code>type</code></td><td>AutoCompleteComboBoxResizeEvent.DROPDOWN_WIDTH_EXPAND_BEGIN</td></tr>
	     *  </table>
	     *
	     *  @eventType dropdownWidthExpandBegin
		 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox
	  	 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox#expandDropDownToContent
	  	 */	
	    public static const DROPDOWN_WIDTH_EXPAND_BEGIN:String = "dropdownWidthExpandBegin";

	    /**
	     *  The <code>AutoCompleteComboBoxEvent.DROPDOWN_WIDTH_EXPANDED</code> constant defines the value of the <code>type</code> property of the event object for an event that is dispatched when the <code>AutoCompleteComboBox</code> <code>expandDropDownToContent</code> is set to true and we just expanded the <code>width</code> of the drop down.
	     *
	     *  <p>The properties of the event object have the following values.
	     *  Not all properties are meaningful for all kinds of events.
		 *  See the detailed property descriptions for more information.</p>
		 * 
	     *  <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
	     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
	     *     <tr><td><code>currentSize</code></td><td>The current width of the drop down. This will be the same as the newSize</td></tr>
  	     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
	     *       event listener that handles the event. For example, if you use
	     *       <code>myButton.addEventListener()</code> to register an event listener,
	     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
	     *     <tr><td><code>newSize</code></td><td>The width the drop down was just set to.</td></tr>
   	     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
	     *       it is not always the Object listening for the event.
	     *       Use the <code>currentTarget</code> property to always access the
	     *       Object listening for the event.</td></tr>
   	     *     <tr><td><code>type</code></td><td>AutoCompleteComboBoxResizeEvent.DROPDOWN_WIDTH_EXPANDED</td></tr>
	     *  </table>
	     *
	     *  @eventType dropdownWidthExpanded
		 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox
	  	 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox#expandDropDownToContent
	  	 */	
	    public static const DROPDOWN_WIDTH_EXPANDED:String = "dropdownWidthExpanded";

	    /**
	     *  The <code>AutoCompleteComboBoxEvent.DROPDOWN_WIDTH_EXPAND_CANCELLED</code> constant defines the value of the <code>type</code> property of the event object for an event that is dispatched when the <code>AutoCompleteComboBox</code> <code>expandDropDownToContent</code> is set to true and the <code>AutoCompleteComboBoxEvent.DROPDOWN_WIDTH_EXPAND_BEGIN</code> event was cancelled.  This means that the drop down was reset to the <code>width</code> of the <code>AutoCompleteComboBox</code>
	     * 
	     *
	     *  <p>The properties of the event object have the following values.
	     *  Not all properties are meaningful for all kinds of events.
		 *  See the detailed property descriptions for more information.</p>
		 * 
	     *  <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
	     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
	     *     <tr><td><code>currentSize</code></td><td>The current width of the drop down. This will be the same as the newSize</td></tr>
  	     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
	     *       event listener that handles the event. For example, if you use
	     *       <code>myButton.addEventListener()</code> to register an event listener,
	     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
	     *     <tr><td><code>newSize</code></td><td>The width the drop down was just set to.</td></tr>
   	     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
	     *       it is not always the Object listening for the event.
	     *       Use the <code>currentTarget</code> property to always access the
	     *       Object listening for the event.</td></tr>
   	     *     <tr><td><code>type</code></td><td>AutoCompleteComboBoxResizeEvent.DROPDOWN_WIDTH_EXPAND_CANCELLED</td></tr>
	     *  </table>
	     *
	     *  @eventType dropdownWidthExpandCancelled
		 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox
	  	 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox#expandDropDownToContent
	  	 */	
	    public static const DROPDOWN_WIDTH_EXPAND_CANCELLED:String = "dropdownWidthExpandCancelled";

	    /**
	     *  The <code>AutoCompleteComboBoxEvent.DROPDOWN_HEIGHT_EXPANDED</code> constant defines the value of the <code>type</code> property of the event object for an event that is dispatched when the <code>AutoCompleteComboBox</code> <code>autoCompleteEnabled</code> is set to <code>true</code> and we just shrank or expanded the <code>height</code> of the drop down to accommodate filtering, which either removed or added items or added items.  Not every filtering action will cause this event to fire.
	     *
	     *  <p>The properties of the event object have the following values.
	     *  Not all properties are meaningful for all kinds of events.
		 *  See the detailed property descriptions for more information.</p>
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
	     *     <tr><td><code>currentSize</code></td><td>The current height of the drop down</td></tr>
	     *     <tr><td><code>newSize</code></td><td>The new height of the drop down</td></tr>
   	     *     <tr><td><code>type</code></td><td>AutoCompleteComboBoxResizeEvent.DROPDOWN_HEIGHT_EXPANDED</td></tr>
	     *  </table>
	     *
	     *  @eventType dropdownHeightExpanded
		 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox
		 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox#autoCompleteEnabled
	  	 */	
	    public static const DROPDOWN_HEIGHT_EXPANDED:String = "dropdownHeightExpanded";

	    
		/** 
		 * constructor
		 */
		public function AutoCompleteComboBoxResizeEvent(type:String, argcurrentSize : int = -1, 
													argnewSize : int = -1,
													bubbles:Boolean=false, cancelable:Boolean=false)
		{
			currentSize = argcurrentSize;
			newSize = argnewSize;
			super(type, bubbles, cancelable);
		}


		/**
		 *  @private
		 *  Storage for the current width property.
		 */
		private var _currentSize:int;

	    /**
	     *  The <code>currentSize</code> property contains the current size of the AutoCompleteComboBox drop down, either <code>height</code> or <code>width</code>, depending on the event type.
	     */
		public function get currentSize():int
		{
			return _currentSize;
		}
		
		/**
		 *  @private
		 */
		public function set currentSize(value:int):void
		{
			_currentSize = value;
		}

		/**
		 *  @private
		 *  Storage for the new width property.
		 */
		private var _newSize:int;

	    /**
	     *  The <code>newSize</code> property contains the new size of the <code>AutoCompleteComboBox</code> drop down, either <code>height</code> or <code>width</code>, depending on the event type.
	     */
		public function get newSize():int
		{
			return _newSize;
		}
		
		/**
		 *  @private
		 */
		public function set newSize(value:int):void
		{
			_newSize = value;
		}

	    /**
	     *  @private
	     */
	    override public function clone():Event
	    {   
	        return new AutoCompleteComboBoxResizeEvent(type,this.currentSize,this.newSize ,bubbles, cancelable);
	    }

	}
}