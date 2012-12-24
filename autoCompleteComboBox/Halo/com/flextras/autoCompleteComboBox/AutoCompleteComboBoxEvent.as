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
	 *   The AutoCompleteComboBoxEvent class represents generic events associated with the AutoCompleteComboBox.  
	 *
	 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox
	 */
	public class AutoCompleteComboBoxEvent extends Event
	{

	    /**
	     *  The <code>AutoCompleteComboBoxEvent.LABEL_TRUNCATED</code> constant defines the value of the <code>type</code> property of the event object for an event that is dispatched when the <code>AutoCompleteComboBox</code> truncates the label the label.
	     * 
	     * <p>The properties of the event object have the following values.  Not all properties are meaningful for all kinds of events. See the detailed property descriptions for more information. </p>
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
	     *     <tr><td><code>text</code></td><td>The untruncated text</td></tr>
  	     *     <tr><td><code>newText</code></td><td>The truncated text</td></tr>
  	     *     <tr><td><code>type</code></td><td>AutoCompleteComboBoxEvent.LABEL_TRUNCATED</td></tr>
	     *  </table>
	     *
	     *  @eventType labelTruncated
		 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox
  	     */
	    public static const LABEL_TRUNCATED:String = "labelTruncated";

	    /**
	     *  The <code>AutoCompleteComboBoxEvent.LABEL_NOT_TRUNCATED</code> constant defines the value of the <code>type</code> property of the event object for an event that is dispatched when the <code>AutoCompleteComboBox</code> <code>truncateToFit</code> is set to <code>true</code>, but there was enough room to display the <code>selectedLabel</code> without truncating it.
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
	     *     <tr><td><code>text</code></td><td>The untruncated text, same value of the selectedLabel</td></tr>
  	     *     <tr><td><code>newText</code></td><td>The untruncated text, in this case same value of the selectedLabel</td></tr>
  	     *     <tr><td><code>type</code></td><td>AutoCompleteComboBoxEvent.LABEL_NOT_TRUNCATED</td></tr>
	     *  </table>
	     *
	     *  @eventType labelNotTruncated
		 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox
  	     */
	    public static const LABEL_NOT_TRUNCATED:String = "labelNotTruncated";

	    /**
	     *  The <code>AutoCompleteComboBoxEvent.SELECTED_VALUE_NOT_FOUND</code> constant defines the value of the <code>type</code> property of the event object for an event that is dispatched when the <code>AutoCompleteComboBox</code> <code>selectedValue</code> was set, but the value was not found in the <code>dataProvider</code>.
	     * 
	     * If cancelled, the <code>selectedIndex</code> and <code>selectedItem</code> will not change.  If not cancelled, the <code>AutoCompleteComboBox</code> will be put into the unselected state where <code>selectedIndex = -1</code> 
	     *
	     *  <p>The properties of the event object have the following values.
	     *  Not all properties are meaningful for all kinds of events.
		 *  See the detailed property descriptions for more information.</p>
	     *  <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
	     *     <tr><td><code>cancelable</code></td><td>true</td></tr>
	     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
	     *       event listener that handles the event. For example, if you use
	     *       <code>myButton.addEventListener()</code> to register an event listener,
	     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
   	     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
	     *       it is not always the Object listening for the event.
	     *       Use the <code>currentTarget</code> property to always access the
	     *       Object listening for the event.</td></tr>
	     *     <tr><td><code>text</code></td><td>The current selected value of the AutoCompleteComboBox</td></tr>
  	     *     <tr><td><code>newText</code></td><td>The value that was not found in the AutoCompleteComboBox</td></tr>
  	     *     <tr><td><code>type</code></td><td>AutoCompleteComboBoxEvent.SELECTED_VALUE_NOT_FOUND</td></tr>
	     *  </table>
	     *
	     *  @eventType selectedValueNotFound
		 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox
  	     */
	    public static const SELECTED_VALUE_NOT_FOUND:String = "selectedValueNotFound";


	    /**
	     *  The <code>AutoCompleteComboBoxEvent.TYPE_AHEAD_TEXT_CHANGED</code> constant defines the value of the <code>type</code> property of the event object for an event that is dispatched when the type-ahead text is changed.  This event will trigger if <code>autoCompleteEnabled</code> or <code>typeAheadEnabled</code> are set to true.  
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
	     *     <tr><td><code>text</code></td><td>The old text</td></tr>
  	     *     <tr><td><code>newText</code></td><td>The changed value</td></tr>
  	     *     <tr><td><code>type</code></td><td>AutoCompleteComboBoxEvent.TYPE_AHEAD_TEXT_CHANGED</td></tr>
	     *  </table>
	     *
	     *  @eventType typeAheadTextChanged
		 *  @see com.flextras.autoCompleteComboBox.AutoCompleteComboBox
  	     */
	    public static const TYPE_AHEAD_TEXT_CHANGED:String = "typeAheadTextChanged";


		/** 
		 * Constructor
		 */
		public function AutoCompleteComboBoxEvent(type:String, argText : String = null, argnewText : String= null, 
													bubbles:Boolean=false, cancelable:Boolean=false)
		{
			text = argText;
			newText  = argnewText ;
			super(type, bubbles, cancelable);
		}

		/**
		 *  @private
		 *  Storage for the selectedLabel property.
		 */
		private var _text:String;

	    /**
	     *  The <code>selectedLabel</code> property contains the display text of the currently selected item.  This is not truncated.
	     */
		public function get text():String
		{
			return _text;
		}
		
		/**
		 *  @private
		 */
		public function set text(value:String):void
		{
			_text = value;
		}

		/**
		 *  @private
		 *  Storage for the truncated text property.
		 */
		private var _newText:String;

	    /**
	     *  The <code>newText<code> property contains the truncated text of the currently selected item. The text was truncated based on the <code>width</code>  for the display and a truncation indicator was added to it.
	     */
		public function get newText():String
		{
			return _newText;
		}
		
		/**
		 *  @private
		 */
		public function set newText(value:String):void
		{
			_newText = value;
		}

	    /**
	     *  @private
	     */
	    override public function clone():Event
	    {   
	        return new AutoCompleteComboBoxEvent(type, this.text,this.newText,bubbles, cancelable);
	    }



	}
}