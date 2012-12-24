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
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.ui.Keyboard;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.collections.ICollectionView;
import mx.collections.IList;
import mx.collections.ListCollectionView;
import mx.collections.XMLListCollection;
import mx.controls.ComboBox;
import mx.controls.TextInput;
import mx.controls.listClasses.ListBase;
import mx.core.ClassFactory;
import mx.core.EdgeMetrics;
import mx.core.FlexGlobals;
import mx.core.mx_internal;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.styles.StyleManager;
import mx.styles.StyleProxy;
import mx.utils.ObjectUtil;

use namespace mx_internal;


/** 
 * This event is dispatched before the <code>dataProvider</code> is filtered for AutoComplete Purposes.  Conceptually this is similar to the <code>ListCollectionView.collectionChange</code> event where <code>kind=refresh</code>.  You should listen to this event if for some reason you want to cancel the filter process.
 * 
 * @eventType com.flextras.autoCompleteComboBox.AutoCompleteCollectionEvent.AUTOCOMPLETE_DATAPROVIDER_FILTER_BEGIN
 * @see mx.collections.ListCollectionView#collectionChange
 * @see #autoCompleteDataProviderFiltered
 * @see #autoCompleteEnabled
 */
[Event(name="autoCompleteDataProviderFilterBegin", type="com.flextras.autoCompleteComboBox.AutoCompleteCollectionEvent")]

/** 
 * This event is dispatched after the <code>dataProvider</code> is filtered for AutoComplete Purposes.  Conceptually this is similar to the <code>ListCollectionView.collectionChange</code> event where <code>kind=refresh</code>.  With this event, you know it comes from inside the <code>AutoCompleteComboBox</code>, as opposed to other filtering or sorting mechanisms on your provider.  You should listen to <code>autoCompleteDataProviderFilterBegin</code> if for some reason you want to cancel the filter process.
 * 
 * @eventType com.flextras.autoCompleteComboBox.AutoCompleteCollectionEvent.AUTOCOMPLETE_DATAPROVIDER_FILTERED
 * @see mx.collections.ListCollectionView#collectionChange
 * @see #autoCompleteDataProviderFilterBegin
 * @see #autoCompleteEnabled
 */
[Event(name="autoCompleteDataProviderFiltered", type="com.flextras.autoCompleteComboBox.AutoCompleteCollectionEvent")]


/** 
 * This event is dispatched when AutoComplete is enabled and the dataProvider was just filtered, causing a change in the number of dataProvider items, therefore needing an expansion or contraction of the drop down height.  
 * 
 * @eventType com.flextras.autoCompleteComboBox.AutoCompleteComboBoxResizeEvent.DROPDOWN_HEIGHT_EXPANDED
 * @see #autoCompleteEnabled
 */
[Event(name="dropdownHeightExpanded", type="com.flextras.autoCompleteComboBox.AutoCompleteComboBoxResizeEvent")]


/** 
 * This event is dispatched when <code>expandDropDownToContent</code> is set to <code>true</code> and we're about to expand the <code>width</code> of the drop down. This event is cancellable.  If it is canceled, then the width of the drop down will be set to the width of the <code>AutoCompleteComboBox</code>.
 * 
 * @eventType com.flextras.autoCompleteComboBox.AutoCompleteComboBoxResizeEvent.DROPDOWN_WIDTH_EXPAND_BEGIN
 * @see #expandDropDownToContent
 */
[Event(name="dropdownWidthExpandBegin", type="com.flextras.autoCompleteComboBox.AutoCompleteComboBoxResizeEvent")]


/** 
 * This event is dispatched when <code>expandDropDownToContent</code> is set to true and we just expanded the <code>width of the drop down.
 * 
 * @eventType com.flextras.autoCompleteComboBox.AutoCompleteComboBoxResizeEvent.DROPDOWN_WIDTH_EXPAND_BEGIN
 * @see #expandDropDownToContent
 */
[Event(name="dropdownWidthExpanded", type="com.flextras.autoCompleteComboBox.AutoCompleteComboBoxResizeEvent")]


/** 
 * This event is dispatched when the display label was truncated.  For this to fire, the <code>truncateToFit</code> property must be set to true and the display label must be too large to fit in the <code>width</code> of the <code>AutoCompleteComboBox</code>.  
 * 
 * @eventType com.flextras.autoCompleteComboBox.AutoCompleteComboBoxEvent.LABEL_TRUNCATED
 * @see #truncateToFit
 */
[Event(name="labelTruncated", type="com.flextras.autoCompleteComboBox.AutoCompleteComboBoxEvent")]

/** 
 * This event is dispatched when <code>truncateToFit</code> is set to true, but there was enough room to display the <code>selectedLabel</code> without shortening it.
 * 
 * @eventType com.flextras.autoCompleteComboBox.AutoCompleteComboBoxEvent.LABEL_NOT_TRUNCATED
 * @see #truncateToFit
 */
[Event(name="labelNotTruncated", type="com.flextras.autoCompleteComboBox.AutoCompleteComboBoxEvent")]

/** 
 * This event is dispatched when the <code>selectedValue</code> was set, but not found in the <code>dataProvider</code>.  If this event is cancelled, the <code>selectedValue</code>, <code>selectedIndex</code>, and <code>selectedItem</code> will not change.  If not cancelled, the <code>AutoCompleteComboBox</code> will be put into the unselected state where <code>selectedIndex = -1</code>.  If you want run code when the selected value is found, listen to the change event.
 *  
 * @eventType com.flextras.autoCompleteComboBox.AutoCompleteComboBoxEvent.SELECTED_VALUE_NOT_FOUND
 * @see #selectedValue
 * @see mx.controls.ComboBox#change
 */
[Event(name="selectedValueNotFound", type="flash.events.Event")]

/** 
 * This event is dispatched when the type-ahead timer is complete and the <code>typeAheadText</code> is reset.
 * 
 * @eventType com.flextras.autoCompleteComboBox.TypeAheadTimerEvent.TYPEAHEAD_RELEASETIMER_COMPLETE
 * @see #typeAheadEnabled
 */
[Event(name="typeAheadReleaseTimerComplete", type="com.flextras.autoCompleteComboBox.TypeAheadTimerEvent")]

/** 
 * This event is dispatched when the type-ahead timer is started.  This is caused when the user types a new character.
 * 
 * @eventType com.flextras.autoCompleteComboBox.TypeAheadTimerEvent.TYPEAHEAD_RELEASETIMER_START
 * @see #typeAheadEnabled
 */
[Event(name="typeAheadReleaseTimerStart", type="com.flextras.autoCompleteComboBox.TypeAheadTimerEvent")]


/** 
 * This event is dispatched when the type-ahead timer is stopped without completing.  The most likely cause of this is that the user typed a new key, resetting the count down.
 * 
 * @eventType com.flextras.autoCompleteComboBox.TypeAheadTimerEvent.TYPEAHEAD_RELEASETIMER_STOP
 * @see #typeAheadEnabled
 */
[Event(name="typeAheadReleaseTimerStop", type="com.flextras.autoCompleteComboBox.TypeAheadTimerEvent")]


/** 
 * This event id dispatched when type-ahead text changes.  This will only be relevant if <code>autoCompleteEnabled</code> or 
 * <code>typeAheadEnabled</code> are set to true.
 *  
 * @eventType com.flextras.autoCompleteComboBox.AutoCompleteComboBoxEvent.TYPE_AHEAD_TEXT_CHANGED
 * @see #typeAheadEnabled
 * @see #AutoCompleteEnabled
 */
[Event(name="typeAheadTextChanged", type="com.flextras.autoCompleteComboBox.AutoCompleteComboBoxEvent")]

/**
 *  This style is a pass through style for the AutoComplete TextInput
 * 
 *  @default TextInput
 */
[Style(name="autoCompleteTextInputStyleName",type="String",inherit="yes")]

/**
 * The Flextras AutoCompleteComboBox is an advanced ComboBox, providing AutoComplete functionality, type-ahead functionality, label truncation, a selectedValue option, and an automatic width resize to content.  It is designed to provide some functionality lacking in the standard Flex ComboBox, most prominently autocomplete or autosuggest functionality.  This is complete list of what it offers:
 * 
 * <ul>
 * <li><b>AutoComplete</b>:  AutoComplete is sometimes called AutoSuggest.  This is so that when the user types the list of options, your dataProvider, is filtered and the typed text is highlighted in a drop down list.  If you want to customize styling in the list, you can create your own itemRenderer to do so.  If just want an AutoComplete TextInput you can hide the Down Arrow with downArrowVisible flag.  AutoComplete functionality can be enabled by setting the autoCompleteEnabled property to true.  It is disabled by default.</li>
 * <li><b>Type-Ahead</b>: What happens when you want to jump ahead to an item in the standard ComboBox?  Let’s say you have a list of states and want to move from wherever you are to Arkasas.  So, you type A and go to Alabama.  Then you type R and jump to Rhode Island, then you type K and go to Kansas.  This can be frustrating for your users.  Our AutoCompleteComboBox implemented a multiple key type-ahead.  So, type A and go to Alabama.  Type R and go to Arizona, then type K and you’ll on Arkansas as you wanted.  This can be enabled by setting the typeAheadEnabled property to true.  If AutoComplete is enabled, then the type-ahead functionality will not work.  Type-Ahead is disabled by default.</li>
 * <li><b>Truncate To Fit</b>: The standard ComboBox will cut off the text if it is longer than the display area / width.  This often looks sloppy and there is no easy way for your users to see the full text.  We’ve implemented the truncateToFit functionality, similar to a Label.  If the text needs to be truncated, we’ll truncate it and add a roll over popup.  If you want control over the Truncation text, just use the truncationIndicator property.  Truncate To Fit functionality can be enabled by setting the truncateToFit property to true.  It is disabled by default.</li>
 * <li><b>Expand to Content</b>: There is often one item in your list that makes your ComboBox to big for your form.  The expand to content feature addresses that.  You can shrink the ComboBox to whatever size you need, but when the user opens up the drop down, the drop down will expand to fit all the content.  This can be enabled by setting expandDropDownToContent property to true.  It is disabled by default</li>
 * <li><b>Selected Value</b>:.  The standard ComboBox provides a selectedIndex, a selectedItem, and a read-only selectedLabel.  If you want to set something based on a data value, our AutoCompleteComboBox provides the selectedValue property. Along with the selectedValue you also have a valueField and valueFunction, modeled after the labelField and labelFunction.</li>
 * </ul>  
 * 
 * @see mx.controls.ComboBox 
 * @see com.flextras.autoCompleteComboBox.AutoCompleteCollectionEvent
 * @see com.flextras.autoCompleteComboBox.AutoCompleteComboBoxEvent
 * @see com.flextras.autoCompleteComboBox.AutoCompleteComboBoxResizeEvent
 * @see com.flextras.autoCompleteComboBox.AutoCompleteListData
 * @see com.flextras.autoCompleteComboBox.TypeAheadTimerEvent
 */
public class AutoCompleteComboBox extends ComboBox
{


    /**
     *  Constructor.
     */
	public function AutoCompleteComboBox()
	{
		super();
		this.itemRenderer = new ClassFactory(AutoCompleteItemRenderer);
		this.dropdownFactory = new ClassFactory(AutoCompleteDropDown);

		super.addEventListener('change',onChange);

	}


    //--------------------------------------------------------------------------
    //
    //  Style Setup
    //
    //--------------------------------------------------------------------------

    /**
    * @private
    * Define a static variable.; used for style initialization at a class level 
    */
    private static var classConstructed:Boolean = classConstruct();
    
    /**
    * @private
    * Define a static method for inititalizing styles at the class level
    */
    private static function classConstruct():Boolean {

		// Flex 4.5 Approach--I wonder when this changed
		// but this causing real weird errors; and I don't want to spend time trying to figure it out now 
		// if I set the default style on the autoCompleteTextInputStyleName; then the other mx TextInputs lose their border
		// I bet the problem is with the namespace split and having to specify them in the getStyleDeclaration thing
//		if (!FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("autoCompleteTextInputStyleName")){
//			FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration("autoCompleteTextInputStyleName", 
//				FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("mx.controls.TextInput"),true);
//		}
		
		// if no CSS declaration for the button style, use the default button style 
//		if (!StyleManager.getStyleManager(null).getStyleDeclarations("autoCompleteTextInputStyleName"))
//		{
//			StyleManager.getStyleManager(null).setStyleDeclaration("autoCompleteTextInputStyleName",StyleManager.getStyleManager(null).getStyleDeclaration("mx.controls.TextInput") , true);
//		}
//		Flex 3-ish code 
//        if (!StyleManager.getStyleDeclaration("autoCompleteTextInputStyleName"))
//        {
//            StyleManager.setStyleDeclaration("autoCompleteTextInputStyleName",StyleManager.getStyleDeclaration("mx.controls.TextInput") , true);
//        }

        return true;
    }


    //--------------------------------------------------------------------------
    //
    //  Lifecycle Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function commitProperties():void
    {

        super.commitProperties();

        // the selectedIndexChange in ComboBase.updateDisplayList is resetting the type ahead text
        // when it shouldn't be; in theory this change should address that
/* seems to be having no affect 
        if((this.autoCompleteEnabled == true) && (this.autoCompleteRemoteData == true) && 
        	(this.selectedIndexChanged == true)){
            selectedIndexChanged = false;
        }
*/
		// create AutoCompletTextInput Field;
		if(this._autoCompleteEnabledChanged == true){

			if(this.autoCompleteEnabled){
				if(!this.autoCompleteTextInput){
					createAutoCompleteTextInput();
				}

				// reset the selected Index if enabling AutoComplete. 
				// we want to the selected Index to be -1 as the default
				// that means nothing is selected until user does it
//				if(!selectedIndexChanged){
//					this.selectedIndex = this.autoCompleteResetIndex;
					setAutoCompleteDefault();
//				}

			} else {
				// if autocomplete being disabled 
				// destroy the AutoComplete field
				if(this.autoCompleteTextInput){
					this.removeChild(this.autoCompleteTextInput);
					this.autoCompleteTextInput = null;
				}
			}
			this._autoCompleteEnabledChanged = false;
		}
		
		// if the down Arrow Visiblity Changed, either display it or hide it
		// and change the width of the appropriate text inputs 
		// to accomodate for the missing field

		if(this._downArrowVisibleChanged == true){

			if(this.downArrowButton){
				// with this condition in the textInput width conditional; code would not run if visible was set to false
				// initially
				this.downArrowButton.visible = this.downArrowVisible;
			if(this.textInput.width != 0 ){
			// change visibility
				
				resizeTextInputWidth();
	/* 			// find out new width
			var extraWidth : int = getStyle("arrowButtonWidth");
			if(this.downArrowButton.visible == true){
				extraWidth = -extraWidth;
			}

			// change size of textInput for display and AutoCompleteTextInput
			this.textInput.setActualSize(this.textInput.width + extraWidth,this.textInput.height);
			if(this.autoCompleteTextInput){
				this.autoCompleteTextInput.setActualSize(this.autoCompleteTextInput.width + extraWidth,this.autoCompleteTextInput.height);
				} */
				
			}
			this._downArrowVisibleChanged = false;
		}


			}


		// if TypeAheadEnabled has changed; reset the timer and type ahead text
        if(this._typeAheadEnabledChanged == true){
			this.typeAheadReleaseTimer = null;

			// TypeAhead is mutually exclusive to AutoCompleteEnabled being true, so if AutoComplete is True don't reset the Type Ahead Text
			// will this cause an issue?  Possibly in Fringe cases; not sure.
			// really, how many times in a real world app will people be switching the "AutoCompleteEnabled" and "TypeAheadEnabled" on the fly?
			// probably never
			if(this.autoCompleteEnabled == true){
				this.typeAheadText = '';
			}
			this._typeAheadEnabledChanged = false;
        }

		// code to set the selectedIndex based on the selectedValue
		if(this._selectedValueChanged == true){

			// be sure that the dataPRovider has been specified
			// if not save the checking for another day 
			if(this.dataProvider){
				
				// Find the correct index for the item
				var index : int = 0
				var found : Boolean = false;
				for ( index ; index < this.dataProvider.length; index++) {
					if(this.itemToData(this.dataProvider[index]) == this._selectedValue ){
						found = true;
						break;
					}
				}
				
				if(found == true){
					this.selectedIndex = index;
					if(this.autoCompleteEnabled == true){
						this.autoCompleteTextInput.text = this.itemToLabel(this.selectedItem);
					}
					// launch the event event
			        dispatchEvent(new Event("selectedValueChanged"));
				} else { 
					// launch the not found event
					var selectedValueNotChangedEvent : AutoCompleteComboBoxEvent = new AutoCompleteComboBoxEvent(AutoCompleteComboBoxEvent.SELECTED_VALUE_NOT_FOUND,this.selectedValue,this._selectedValue,false,true);
//			        var selectedValueNotChangedEvent : Event = new Event("selectedValueNotFound",false,true)
			        dispatchEvent(selectedValueNotChangedEvent);
			        // if the event is cancelled, do nothing
			        if(!selectedValueNotChangedEvent.isDefaultPrevented()){
				        // if event is not cancelled, reset selectedindex to -1 and selectedValue to null
						this.selectedIndex = -1;
						this._selectedValue = null;

			        }
				}
				this._selectedValueChanged = true;
				this._selectedValue = null;
				
			}
		}

    }


    /**
     *  @private
     */
    override protected function createChildren():void
    {

    	super.createChildren();
		// create a new text input field strictly for the purposes of the AutoComplete
		// this field will exist on top of the textInput field used for display purposes
		if(this.autoCompleteEnabled == true){
			// create AutoCompletTextInput Field;
			createAutoCompleteTextInput();
		}
    } 
    

    /**
     *  @private
     */ 
    override protected function measure():void
    {
        super.measure();
    }

	/** 
	 * @private
	 * used to check if a style is changed and call invalidateDisplayList to handle style changes 
	 * in the context of this component, style changes just relate to 
	 */
	override public function styleChanged(styleProp:String):void {
	
	    super.styleChanged(styleProp);
	
	    // Check to see if style changed. 
	    if (styleProp=="autoCompleteTextInputStyleName") 
	    {
	        _autoCompleteTextInputStyleDirty=true; 
	        invalidateDisplayList();
	        return;
	    }

	}


    /**
     *  @private
     */ 
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {


		// deal with the AutoCompleteTextInput style change
		if(this._autoCompleteTextInputStyleDirty == true){
			if(this.autoCompleteTextInput){
				if(this.autoCompleteTextInput.styleName != getStyle("autoCompleteTextInputStyleName")){
					this.autoCompleteTextInput.styleName = getStyle("autoCompleteTextInputStyleName");
				}
			}
			this._autoCompleteTextInputStyleDirty = false;
		}	
		
		// in some cases, such as the Flextras Code Generator; an item in the collection may change
		// but the display text is not modified
		// the drop down picks up modifications w/o problems; but we need to force a refresh on the textInput
		// if truncateToFit is true, and the item is truncated, then textInput.text will never equal the selectedItem
		// and that appears to cause some type of loop 
		if(this.truncateToFit == false){
			if(this.textInput.text != itemToLabel(this.selectedItem)){
				this.textInput.text = itemToLabel(this.selectedItem);
			}
			
		}


		// if expandDropDownToContent has changed, we may need to reset the 
		// drop down width
		if(this._expandDropDownToContentChanged == true){
			if(this.dropdown){
				if(this.expandDropDownToContent == false){
					// it changed from true to false, reset to default 
						this.dropdown.width = this.width;
				} else {
					// it changed from false to true, expand it 
					resizeDropDownWidth();
				}
				this._expandDropDownToContentChanged = false;
			}
		}


		// method local flag to tell whether the mx_internal value selectionChanged is true
		// if it was we want to 
		// if the selection changed then the dataProvide changed, and maybe the width changed
		// we want to reset the textInput width after the super is called; so set a flag here
		var selectionChangedFlag : Boolean = mx_internal::selectionChanged;
		
		// if autocomplete is enabled and the drop down is already open we don't want to call super
		// because that will destroy the drop down
		if((this.autoCompleteEnabled == true) && (isDropDownVisible() == true)){
			resizeDropDownHeight();

			// return so that super is never called
			return;
		}


        super.updateDisplayList(unscaledWidth, unscaledHeight);


		if(this.autoCompleteEnabled == true){
			if(this.autoCompleteTextInput){
				// If autoComplete is enabled by default, sometimes the input field may be created before the textInput 
				// has height and width of 0, thus making it effectively invisible 
				// if autoComplete is Enabled, just resize it
				// possibly better in a creationComplete?  Or Initialize? handler 
				// 
				// if AutoComplete is enabled and the width changed, then we need to stretch the AutoCompleteTextInput to match the 
				// new width
				if((this.autoCompleteTextInput.width == 0) || (this.autoCompleteTextInput.height ==0) || 
					((this.downArrowVisible == false) && (this.autoCompleteTextInput.width != (this.textInput.width + getStyle("arrowButtonWidth") ))) || 
					(selectionChangedFlag == true) ){
//						resizeTextInputWidth();
						var extraWidth : int = 0;
						if(this.downArrowButton.visible == false){
							extraWidth  = getStyle("arrowButtonWidth");
				}
						this.autoCompleteTextInput.setActualSize(this.textInput.width + extraWidth,this.textInput.height);
				}
 
			}
		}

		// check wether our display text needs to be re-truncated or not
		// this will have no visible affect if AutoCompleteEnabled is enabled
		var reTruncate : Boolean = false;
		// if truncate to Fit is change on the fly; reset it
		// next if statement will re-truncate it if needed 
		if(this._truncateToFitChanged == true){
			if(truncateToFit == false){
	            textInput.text = selectedLabel;
			} else {
				reTruncate = true;
			}
			this._truncateToFitChanged = false;
		}
		
		if(this._truncationIndicatorChanged == true){
			reTruncate = true;
			this._truncationIndicatorChanged = false;
		}


		//  concept of truncateToFit borrowed from Label and modified  

        // Plain text gets truncated with a "..." 
        // Text gets an automatic tooltip if the full text isn't visible.
        // but only if the user didn't explicitly give the component a tooltip
        if (
        	(truncateToFit && (textInput.text == selectedLabel)) || 
        	(truncateToFit && (reTruncate == true)) 
        	) {
			reTruncate = false;
            // Reset the text in case it was previously
            // truncated with a "...".\  Not needed because we check for it in the condition
            textInput.text = selectedLabel;
            
            // Determine whether the full text needs to be truncated
            // based on the actual size of the TextField.
            // Note that the actual size doesn't change;
            // the text changes to fit within the actual size.

            var truncated : Boolean = this.truncateLabel();

			// set the toolTip
			// but only if no toolTip has been set
			if(this._toolExplicitlySet == false){
				super.toolTip = truncated ? selectedLabel : null;
			}

        }
		//  End borrowed from Label 
		
    }	


    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  autoCompleteRowCount
    //----------------------------------
    /**
     *  @private
     *  an internal row count counter, which does not take into account the length of the dataProvider
     *  used for calculating the height of the drop down for autocomplete purposes
     *  regular rowCount, as implemented, will return the lesser of rowcount or dataProvider.length
     */
	private var _autoCompleteMaxRowCount : int = 5;

    /**
     *  @private
     */
    protected function get autoCompleteRowCount():int
    {
    	return _autoCompleteMaxRowCount;
    }
    
    
    //----------------------------------
    //  AutoCompleteTextInput
    //----------------------------------
	/**
	 * @private
	 * Internal Storage for the AutoCompleteTextInput field
	 */
    private var _autoCompleteTextInput : TextInput;
    
    [Bindable("autoCompleteTextInputChanged")]
	/**
	 * @private
	 */
    protected function get autoCompleteTextInput ():TextInput{
    	return this._autoCompleteTextInput;
    }

	/**
	 * @private
	 */
    protected function set autoCompleteTextInput(value:TextInput):void{
    	this._autoCompleteTextInput = value;
        dispatchEvent(new Event("autoCompleteTextInputChanged"));
    }

    //----------------------------------
    //  AutoCompleteTextInput
    //----------------------------------
    private var _autoCompleteTextInputStyleDirty : Boolean = false;

    //----------------------------------
    //  bCalculateDropDownWidth
    //----------------------------------
    /**
     *  @private
     * used in in calculateDropDownWidth method in conjunction with expandDropDownToContent 
     * If set to true, we will perform the calculation.  If set to false, we will just return the drop down width
     */
    private var bCalculateDropDownWidth:Boolean = true;

    //----------------------------------
    //  bInFocusInHandler
    //----------------------------------
    /**
     *  @private
     * used to tell the close method that we're in the bInFocusInHandler.
     */
    private var bInFocusInHandler : Boolean = false;

    //----------------------------------
    //  bInKeyDown
    //----------------------------------
    /**
     *  @private
     * used in close method; if we're in a key down handler, which somehow triggers the close method we want to ignore it
     */
    private var bInKeyDown:Boolean = false;

    //----------------------------------
    //  cachedRowHeight
    //----------------------------------
    /**
     *  @private
	 * the stored rowHeight; basically a cache to handle the situation were 
	 * the drop down is set to a negative height caused by typing things where the drop down is 
	 * set to a 0 height; then closed because the type ahead text was blanked out at once
     */
	public var cachedRowHeight : int;


    //----------------------------------
    //  typeAheadReleaseTimer 
    //----------------------------------
	/**
	 * @private
	 * The type ahead release timer When this timer is up, we reset the typeAheadText. 
     */
	private var typeAheadReleaseTimer : Timer ;

    //----------------------------------
    //  autoCompleteInput
    //----------------------------------
	/**
	 * @private
	 * Tells the set selectedIndex method not reset the autoCompleteInput when an item is being deselected; used in conjunction with autocmplete filtering
     */
	private var autoCompleteInputSaveOnSelectedIndexChange : Boolean = false;

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  dataProvider
    //----------------------------------

    [Bindable("collectionChange")]
    [Inspectable(category="Data", arrayType="Object")]

    /**
     *  @inheritDoc
     */
     // added to remove'write only' disclaimer in ASDocs.
    override public function get dataProvider():Object
    {
        return super.dataProvider;
    }

    /**
     *  @inheritDoc
     */
    override public function set dataProvider(value:Object):void
    {
		if(this.autoCompleteRemoteData == false){
	        super.dataProvider = value;
			// Bug where drop down is not getting refreshed when the dataProvider changes 
			if( 
				(this.dropdown) && 
				(ObjectUtil.compare(this.dropdown.dataProvider,value) != 0)
			){ 
				this.dropdown.dataProvider = value;
			}
		} else {
	        selectionChanged = true;

	        var oldDataProvider : ICollectionView = collection;

			/// copied ComboBase dataProvider method 
	        if (value is Array)
	        {
	            collection = new ArrayCollection(value as Array);
	        } 
	        else if (value is ICollectionView)
	        {
	            collection = ICollectionView(value);
	        }
	        else if (value is IList)
	        { 
	            collection = new ListCollectionView(IList(value));
	        }
	        else if (value is XMLList)
	        { 
	            collection = new XMLListCollection(value as XMLList);
	        } else if(!value){
	        	// added 12/2/09 because otherwise if set to null it creates an array of 1 null value
	        	// which forces the drop down o a width of 1; which is one of the bug issues 
	        	collection  = new ArrayCollection();
	        }
	        else
	        {
	            // convert it to an array containing this one item
	            var tmp:Array = [value];
	            collection = new ArrayCollection(tmp);
	        }
	        // get an iterator for the displaying rows.  The CollectionView's
	        // main iterator is left unchanged so folks can use old DataSelector
	        // methods if they want to
	        iterator = collection.createCursor();
	        collectionIterator = collection.createCursor(); //IViewCursor(collection);
	        
	
	        // trace("ListBase added change listener");
	        // weak listeners to collections and dataproviders
	        collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler, false, 0, true);

			// JH added 
			if(value){
		        this.dropdown.dataProvider = collection;
			} else {
				this.dropdown.dataProvider = null
			}
/* 	        this.dropdown.invalidateSize();
	        this.dropdown.invalidateDisplayList();
	        this.dropdown.invalidateList();
 */	
	        var event:CollectionEvent =
	            new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
	        event.kind = CollectionEventKind.RESET;
			// if the original data provider is nul and we call the collectionChangeHandler 
			// then the default is reset; which is blanking out what the user typed 
			// should we be calling the change handler at all in this case? 

//	        if(oldDataProvider){
	        collectionChangeHandler(event);
//	        }

	        dispatchEvent(event);
			// end comboBase dataProvider method 	

//	        super.destroyDropdown();
//	        _showingDropdown = false;

	        invalidateProperties();
	        invalidateSize();
	        this.invalidateDisplayList();


			// modify the row count to force the drop down height to expand if the row count is smaller the 
			// the length
			if((this.isDropDownVisible() == true)){
				if(this.dropdown.rowCount <= ListCollectionView(this.dropdown.dataProvider).length){
					this.dropdown.rowCount = rowCount;
//					this.dropdown.dataProvider = this.dataProvider;
				}
			}
			// open the drop down if 
			// there are items in dataProvider
			// there is type ahead text 
			// it isn't already open
			if( (this.isDropDownVisible() == false) && (this.typeAheadText != '') && (this.collection.length >0)
				){
        		this.open();
			}

		}


    }

    //----------------------------------
    //  dropdown
    //----------------------------------
    /**
     *  @inheritDoc 
     */
    override public function get dropdown():ListBase
    { 
       var tempDropDown : ListBase = super.dropdown;
       if(tempDropDown){
	       tempDropDown.addEventListener("change", dropdown_changeHandler,false,0,true);
	       AutoCompleteDropDown(tempDropDown).autoCompleteComboBox = this;
	       AutoCompleteDropDown(tempDropDown).typeAheadText = this.typeAheadText;
       }
       return tempDropDown;
    }


    //----------------------------------
    //  rowcount
    //----------------------------------
    // only reason that the get method is in here is because asDocs appears to mark it as read only if only one method is here
    // even though parent has the other method

	// adding this for bindable reasons; apparently not inheriting metadata from parent
    [Bindable("resize")]
    [Inspectable(category="General", defaultValue="5")]
    /**
     *  @inheritDoc
     */
    override public function get rowCount():int
    {
    	return super.rowCount;
    }
    /**
     *  @private
     */
    override public function set rowCount(value:int):void
    {
    	_autoCompleteMaxRowCount = value;
    	super.rowCount = value;
    }

    //----------------------------------
    //  selectedIndex
    //----------------------------------
    // added get method to remove the write only designation in ASDocs.
    // copied bindable and metadata stuff from parent for purposes of bindable not working
    [Bindable("change")]
    [Bindable("collectionChange")]
    [Bindable("valueCommit")]
    [Inspectable(category="General", defaultValue="0")]
    /**
     *  @inheritDoc
     */
    override public function get selectedIndex():int
    {
        return super.selectedIndex;
    }

    /**
     *  @inheritDoc
     */
    override public function set selectedIndex(value:int):void
    {
		// added because it may fix issue where type ahead text is being reset if autoCompleteREmoteData is on
    	if(super.selectedIndex == value){
    		return;
    	}
    	super.selectedIndex = value;

		// odd bug w/ changing the dataProvider caused dropdown to have different selectedIndex than component
		// causing selection issues; what happens if we change it here? 
		if(this.dropdown){
    	this.dropdown.selectedIndex = value;
		}

    	if(this.autoCompleteEnabled == true){

				if((value != -1)){
				
				// if setting selectedIndex to an item out of the dataPRovider, then ignore it 
				// kind of ignore it at least.  
				if( (this.dataProvider) && 
					( (this.dataProvider as ListCollectionView).length > value ) ){
					
					var localLabel : String = this.itemToLabel(this.dataProvider[value]);
					// 
					// if ACCB is disabled, then there may be no AutoCompleteTextInput
					// if it doesn't exist, don't modify it
					if((this.autoCompleteTextInput) && (this.autoCompleteTextInput.text != localLabel)){
						this.autoCompleteTextInput.text = localLabel;
						// JH DotComIt 11/10/2011 
						// the cursor location was not being changed if the mouse was used to select items; only the keyboard
						// this should hopefully fix it 
//						this.setAutoCompleteCursorLocation();
					}

				}
			} else if(this.autoCompleteInputSaveOnSelectedIndexChange == false){
				if(this.autoCompleteTextInput){
					this.autoCompleteTextInput.text = '';
				}
    	}
    }
    }

	//----------------------------------
	//  selectedItem
	//----------------------------------
	
	/**
	 *  @private
	 */
	override public function set selectedItem(value:Object):void
	{
		super.selectedItem = value;
		
		if(this.autoCompleteEnabled == true){
			
			if((this.selectedIndex != -1)){
				
				// if setting selectedIndex to an item out of the dataPRovider, then ignore it 
				// kind of ignore it at least.  
				if( (this.dataProvider) && 
					( (this.dataProvider as ListCollectionView).length > this.selectedIndex ) ){
					
					var localLabel : String = this.itemToLabel(value);
					// 
					// if ACCB is disabled, then there may be no AutoCompleteTextInput
					// if it doesn't exist, don't modify it
					if((this.autoCompleteTextInput) && (this.autoCompleteTextInput.text != localLabel)){
						this.autoCompleteTextInput.text =  localLabel;
						// JH DotComIt 11/10/2011 
						// the cursor location was not being changed if the mouse was used to select items; only the keyboard
						// this should hopefully fix it 
//						this.setAutoCompleteCursorLocation();
					}
					
				}
			} /* else if(this.autoCompleteInputSaveOnSelectedIndexChange == false){
				this.autoCompleteTextInput.text = '';
			} */
		}
	}
	

    //----------------------------------
    //  text
    //  modeled after text property in ComboBase
    //----------------------------------

    [Bindable("collectionChange")]
    [Bindable("valueCommit")]
    [Bindable("typeAheadTextChanged")]
    [Inspectable(category="General", defaultValue="")]
    [NonCommittingChangeEvent("change")]

    /**
	 * This property keeps track of the characters in the the AutoComplete input.  
	 * If you want to acces the characters that are being used to filter the AutoComplete list, 
	 * look at the typeAheadTextValue property.
	 * If an item is selected, the autoComplete filter is removed.  In that situation, typeAheadTextValue will return 
	 * an empty string, but text will return the display text for that item.
	 * If autoCompleteEnabled is false; then this property will act just like text property on the the ComboBox.
	 * 
     *  @default ""
     *  @see #typeAheadTextValue
     *  @see #typeAheadText
     */
    override public function get text():String
    {
		if(this.autoCompleteEnabled == true){
			return this.autoCompleteTextInput.text;
		}
        return super.text;
    }

    /**
     *  @private
     */
    override public function set text(value:String):void
    {
		if(this.autoCompleteEnabled == true){
			this.autoCompleteSetTypeAheadText(value);
			return;
		}
		super.text = value;
		
    }


    //----------------------------------
    //  tooltip
    //----------------------------------

	// flag to tell whether the tooltop was explicitly set, or not
	// if it was explicitly set we won't set it ourselves when truncateToFit is on and the item is truncated
	private var _toolExplicitlySet : Boolean = false;

	// metadata not inherited; this is copied from parent 
    [Bindable("toolTipChanged")]
    [Inspectable(category="General", defaultValue="null")]
    /**
     * If you explicitly set a tooltop then it will not be reset when truncateToFit is on and the item is truncated
     *  @inheritDoc
     */
    override public function get toolTip():String
    {
        return super.toolTip;
    }

    /**
     *  @private
     */
    override public function set toolTip(value:String):void
    {

		super.toolTip = value;
		if(value){
			_toolExplicitlySet = true;
		} else {
			_toolExplicitlySet = false;
		}
    }

	// metadata not inherited; this is copied from parent 
    [Bindable("widthChanged")]
    [Inspectable(category="General")]
    [PercentProxy("percentWidth")]
     /** 
      *  @inheritDoc
      */
     override public function get width():Number{
     	return super.width;
     }
    
     /** 
      *  @inheritDoc
      */
    override public function set width(value:Number):void{
    	super.width = value;

		// If we change the width then we must also have to change the truncation of the appropriate event
		// but only need to do this if TruncateToFit is enabled
    	if(this.truncateToFit == true){
	    	this._truncateToFitChanged =true;
	    	this.invalidateDisplayList();
    	}
    	
    }


    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

	//----------------------------------
	//  autoCompleteCursorBeginning
	//----------------------------------
	/** 
	 * @private
	 * Private storage to tell us whether cursor position should be put at the beginning or end of the component after an item is selected.
	 * Default is true
	 */
	private var _autoCompleteCursorLocationOnSelect : Boolean = true;

	
	[Bindable("_autoCompleteCursorLocationOnSelectChanged")]
	[Inspectable(category="AutoComplete", defaultValue="false",enumeration="true,false",name="AutoComplete Cursor Position Beginning",type="Boolean")]
	/**
	 *  This property specifies where the cursor position will end up after an item is selected.
	 * If true, the cursor will be placed at the beginning of the selectedItem's label. 
	 * If false, the cursor will be placed at the end of the selectedItem's label.  
	 * 
	 *  @default true
	 */
	public function get autoCompleteCursorLocationOnSelect():Boolean{
		return this._autoCompleteCursorLocationOnSelect;
	}
	
	/** 
	 * @private
	 */
	public function set autoCompleteCursorLocationOnSelect(value:Boolean):void{
		this._autoCompleteCursorLocationOnSelect = value;
		dispatchEvent(new Event("_autoCompleteCursorLocationOnSelectChanged"));
	}
	

    //----------------------------------
    //  autoCompleteEnabled 
    //----------------------------------
	/** 
	 * @private
	 * Private storage to tell us whether AutoComplete should be enabled or not 
	 */
	private var _autoCompleteEnabled : Boolean = false;
	/** 
	 * @private
	 * Private storage to tell if the AutoCompleteEnabledChanged value is true 
	 */
	private var _autoCompleteEnabledChanged : Boolean = false;
	
    [Bindable("autoCompleteEnabledChanged")]
	[Inspectable(category="AutoComplete", defaultValue="false",enumeration="true,false",name="AutoComplete Enabled",type="Boolean")]
	/**
	 *  This property enables the AutoComplete functionality.  If you set it to <code>true</code> it will filter the list of items based on 
	 * the user's typed input.  It is worth nothing that if this property is set to <code>true</code>, then type-ahead functionality will have 
	 * no affect.  If this property is set to <code>false</code>, no AutoComplete functionality will be available.
	 * 
     *  @default false 
     *  @see #typeAheadEnabled
     */
	public function get autoCompleteEnabled():Boolean{
		return this._autoCompleteEnabled
	}

	/** 
	 * @private
	 */
	public function set autoCompleteEnabled(value:Boolean):void{
		this._autoCompleteEnabled = value;
		this._autoCompleteEnabledChanged = true;
		this.invalidateProperties();
        dispatchEvent(new Event("autoCompleteEnabledChanged"));
	}

    //----------------------------------
    //  autoCompleteHighlightOnFocus 
    //----------------------------------
    /**
    * @private
    */
	private var _autoCompleteHighlightOnFocus : Boolean = false;

    [Bindable("autoCompleteHighlightOnFocusChanged")]
	[Inspectable(category="AutoComplete", defaultValue="false",enumeration="true,false",name="AutoComplete Highlight on Focus",type="Boolean")]
	/**
	 * Use this property if you want to select all characters in the autoCompleteTextInput when it gains focus.  
	 * If nothing is entered into the input, then nothing will be highlighted.  
	 * If you are using a prompt and the prompt, then the prompt will be removed when the component gains focus.  
	 * If nothing is typed or selected, then the prompt will be returned when the component loses focus.
	 * 
     *  @default false
     */
	public function get autoCompleteHighlightOnFocus(): Boolean {
		return this._autoCompleteHighlightOnFocus;
	}

    /**
    * @private
    */
	public function set autoCompleteHighlightOnFocus(value : Boolean):void{
		this._autoCompleteHighlightOnFocus = value;
        dispatchEvent(new Event("autoCompleteHighlightOnFocusChanged"));
	}


    //----------------------------------
    //  autoCompleteFilterFunction 
    //----------------------------------
    /**
    * @private
    */
	private var _autoCompleteFilterFunction : Function = autoCompleteFilter;

    [Bindable("autoCompleteFilterFunctionChanged")]
	[Inspectable(category="AutoComplete", defaultValue="autoCompleteFilter",name="AutoComplete Filter Function",type="Function")]
	/**
	 * This property defines the filter function used to filter the <code>dataProvider</code> for AutoComplete purposes.  
	 * The <code>dataProvider</code> is converted to a <code>ListCollectionView</code> internally.
	 * 
     *  @default autoCompleteFilter
     *  @see mx.collections.ListCollectionView 
     */
	public function get autoCompleteFilterFunction (): Function {
		return this._autoCompleteFilterFunction;
	}

    /**
    * @private
    */
    public function set autoCompleteFilterFunction(value:Function):void{
    	this._autoCompleteFilterFunction = value;
        dispatchEvent(new Event("autoCompleteFilterFunctionChanged"));
    }

    //----------------------------------
    //  autoCompleteResetIndex
    //----------------------------------
    /**
    * @private
    */
	private var _autoCompleteResetIndex : int = -1;

    [Bindable("autoCompleteResetIndexChanged")]
	[Inspectable(category="AutoComplete", defaultValue="false",enumeration="-1,0",name="AutoComplete Reset Index",type="Boolean")]
	/**
	 * This property allows you to specify a default selectedIndex when the dataProvider is set or reset.
	 * 
	 * When we built this component we made the assumption that the default AutoComplete state would be the unselected state,
	 * where selectedIndex = -1, selectedItem = null, and no text is displayed in the AutoComplete input.  Just in case you 
	 * want the AutoComplete to select a default value, this property allows you to do that.
	 * 
	 * Although this is a numerical property, presumably you will only want to set this value to -1 (unselected state) or 0
	 * (first item in dataProvider).
	 * 
     *  @default -1
     */
	public function get autoCompleteResetIndex (): int {
		return this._autoCompleteResetIndex;
	}
    /**
    * @private
    */
    public function set autoCompleteResetIndex(value:int):void{
    	this._autoCompleteResetIndex = value;
        dispatchEvent(new Event("autoCompleteResetIndexChanged"));
    }

    //----------------------------------
    //  autoCompleteRemoteData 
    //----------------------------------
    /**
    * @private
    */
	private var _autoCompleteRemoteData : Boolean = false;

    [Bindable("autoCompleteRemoteDataChanged")]
	[Inspectable(category="AutoComplete", defaultValue="false",enumeration="true,false",name="AutoComplete Remote Data",type="Boolean")]
	/**
	 * Use this property if you are populating the dataProvider from a remote data source and want to change the dataProvider
	 * with each character the user types.  
	 * It will prevent the drop down from being destroyed and recreated each time the dataProvider changes, which causes 
	 * display oddities.
	 * 
     *  @default false
     */
	public function get autoCompleteRemoteData (): Boolean {
		return this._autoCompleteRemoteData;
	}
    /**
    * @private
    */
    public function set autoCompleteRemoteData(value:Boolean):void{
    	this._autoCompleteRemoteData = value;
        dispatchEvent(new Event("autoCompleteRemoteDataChanged"));
    }

    
    //----------------------------------
    //  autoCompleteSelectOnEnter 
    //----------------------------------
    /**
    * @private
    */
	private var _autoCompleteSelectOnEnter : Boolean = false;

    [Bindable("autoCompleteSelectOnEnterChanged")]
	[Inspectable(category="AutoComplete", defaultValue="false",enumeration="true,false",name="AutoComplete Select on Enter",type="Boolean")]
	/**
	 * Use this property if you want to select the first item in the AutoComplete's filtered drop down list when the user 
	 * presses the enter key.  
	 * If enter is pressed and nothing is selected, the first item in the first will not be selected unless you set the 
	 * autoCompleteSelectOnEnterIfEmpty to true.
	 * 
     *  @default false
     * @see #autoCompleteSelectOnEnterIfEmpty
     */
	public function get autoCompleteSelectOnEnter(): Boolean {
		return this._autoCompleteSelectOnEnter;
	}

    /**
    * @private
    */
	public function set autoCompleteSelectOnEnter(value : Boolean):void{
		this._autoCompleteSelectOnEnter = value;
        dispatchEvent(new Event("autoCompleteSelectOnEnterChanged"));
	}


    //----------------------------------
    //  autoCompleteSelectOnEnterIfEmpty
    //----------------------------------
    /**
    * @private
    */
	private var _autoCompleteSelectOnEnterIfEmpty : Boolean = false;

    [Bindable("autoCompleteSelectOnEnterIfEmptyChanged")]
	[Inspectable(category="AutoComplete", defaultValue="false",enumeration="true,false",name="AutoComplete Select on Enter if Empty",type="Boolean")]
	/**
	 * If set to true, the top item in the drop down will be selected when the user presses enter without having entered 
	 * any text.  
	 * This is used in conjunction with autoCompleteSelectOnEnter and only has an effect if autoCompleteSelectOnEnter is true.  
	 * 
     *  @default false
     * @see #autoCompleteSelectOnEnter
     */
	public function get autoCompleteSelectOnEnterIfEmpty(): Boolean {
		return this._autoCompleteSelectOnEnterIfEmpty;
	}

    /**
    * @private
    */
	public function set autoCompleteSelectOnEnterIfEmpty(value : Boolean):void{
		this._autoCompleteSelectOnEnterIfEmpty = value;
        dispatchEvent(new Event("autoCompleteSelectOnEnterIfEmptyChanged"));
	}

    //----------------------------------
    //  autoCompleteSelectOnEqual 
    //----------------------------------
    /**
    * @private
    */
	private var _autoCompleteSelectOnEqual : Boolean = false;

    [Bindable("autoCompleteSelectOnEqualChanged")]
	[Inspectable(category="AutoComplete", defaultValue="false",enumeration="true,false",name="AutoComplete Select on Equal",type="Boolean")]
	/**
	 * Use this property if you want to select an item in the AutoComplete's filtered drop down list 
	 * if that item is equal to the text you typed.  This is a case sensitive comparison by default.  If you want to perform 
	 * case insensitive comparison the autoCompleteSelectOnEqualCaseSensitivity property
	 * 
     *  @default false
     *  @see #autoCompleteSelectOnEqualCaseSensitivity
     */
	public function get autoCompleteSelectOnEqual(): Boolean {
		return this._autoCompleteSelectOnEqual;
	}

    /**
    * @private
    */
	public function set autoCompleteSelectOnEqual(value : Boolean):void{
		this._autoCompleteSelectOnEqual = value;
        dispatchEvent(new Event("autoCompleteSelectOnEqualChanged"));
	}

    //----------------------------------
    //  autoCompleteSelectOnEqualCaseSensitivity 
    //----------------------------------
    /**
    * @private
    */
	private var _autoCompleteSelectOnEqualCaseSensitivity : Boolean = false;

    [Bindable("autoCompleteSelectOnEqualCaseSensitivityChanged")]
	[Inspectable(category="AutoComplete", defaultValue="false",enumeration="true,false",name="AutoComplete Select on Equal Case Sensitivity",type="Boolean")]
	/**
	 * This controls the case sensitivity of the autoCompleteSelectOnEqual comparison.
	 * If set to true the comparison will be case sensitive.  IF set to false the comparison will be case insensitive.
	 * 
     *  @default false
     * @see #autoCompleteSelectOnEqual
     */
	public function get autoCompleteSelectOnEqualCaseSensitivity(): Boolean {
		return this._autoCompleteSelectOnEqualCaseSensitivity;
	}

    /**
    * @private
    */
	public function set autoCompleteSelectOnEqualCaseSensitivity(value : Boolean):void{
		this._autoCompleteSelectOnEqualCaseSensitivity = value;
        dispatchEvent(new Event("autoCompleteSelectOnEqualCaseSensitivityChanged"));
	}

    //----------------------------------
    //  autoCompleteSelectOnOne 
    //----------------------------------
    /**
    * @private
    */
	private var _autoCompleteSelectOnOne : Boolean = false;

    [Bindable("autoCompleteSelectOnOneChanged")]
	[Inspectable(category="AutoComplete", defaultValue="false",enumeration="true,false",name="AutoComplete Select on One",type="Boolean")]
	/**
	 * Use this property if you want to select an item in the AutoComplete's filtered drop down list 
	 * if there is only a single item remaining.  
	 * 
     *  @default false
     */
	public function get autoCompleteSelectOnOne(): Boolean {
		return this._autoCompleteSelectOnOne;
	}

    /**
    * @private
    */
	public function set autoCompleteSelectOnOne(value : Boolean):void{
		this._autoCompleteSelectOnOne = value;
        dispatchEvent(new Event("autoCompleteSelectOnOneChanged"));
	}
	

	//----------------------------------
	//  autoCompleteSelectOnSpecial
	//----------------------------------
	/**
	 * @private
	 */
	private var _autoCompleteSelectOnSpecial : Boolean = false;
	
	[Bindable("autoCompleteSelectOnSpecialChanged")]
//	[Inspectable(category="AutoComplete", defaultValue="false",enumeration="true,false",name="AutoComplete Select on a Special Key",type="Boolean")]
	/**
	 * @private 
	 * 
	 * Use this property if you want to select the first item in the AutoComplete's filtered drop down list when the user 
	 * presses the specified key.  
	 * If enter is pressed and nothing is selected, the first item in the first will not be selected unless you set the 
	 * autoCompleteSelectOnSpecialIfEmpty to true.
	 * 
	 *  @default false
	 * @see #autoCompleteSelectOnSpecialIfEmpty
	 * @see #autoCompleteSelectOnSpecialKey
	 */
	public function get autoCompleteSelectOnSpecial(): Boolean {
		return this._autoCompleteSelectOnSpecial;
	}
	
	/**
	 * @private
	 */
	public function set autoCompleteSelectOnSpecial(value : Boolean):void{
		this._autoCompleteSelectOnSpecial = value;
		dispatchEvent(new Event("autoCompleteSelectOnSpecialChanged"));
	}
	
	
	//----------------------------------
	//  autoCompleteSelectOnSpecialIfEmpty
	//----------------------------------
	/**
	 * @private
	 */
	private var _autoCompleteSelectOnSpecialIfEmpty : Boolean = false;
	
	[Bindable("autoCompleteSelectOnSpecialIfEmptyChanged")]
//	[Inspectable(category="AutoComplete", defaultValue="false",enumeration="true,false",name="AutoComplete Select on Special if Empty",type="Boolean")]
	/**
	 * @private 
	 * If set to true, the top item in the drop down will be selected when the user presses special key without having entered 
	 * any text.  
	 * 
	 * This is used in conjunction with autoCompleteSelectOnSpecial and only has an effect if autoCompleteSelectOnSpecial is true.  
	 * 
	 *  @default false
	 * @see #autoCompleteSelectOnSpecial
	 * @see #autoCompleteSelectOnSpecialKey
	 */
	public function get autoCompleteSelectOnSpecialIfEmpty(): Boolean {
		return this._autoCompleteSelectOnSpecialIfEmpty;
	}
	
	/**
	 * @private
	 */
	public function set autoCompleteSelectOnSpecialIfEmpty(value : Boolean):void{
		this._autoCompleteSelectOnSpecialIfEmpty = value;
		dispatchEvent(new Event("autoCompleteSelectOnSpecialfEmptyChanged"));
	}

	
	//----------------------------------
	//  autoCompleteSelectOnSpecialKey
	//----------------------------------
	/**
	 * @private
	 */
	private var _autoCompleteSelectOnSpecialKey : int = Keyboard.TAB;
	
	[Bindable("autoCompleteSelectOnSpecialKeyChanged")]
//	[Inspectable(category="AutoComplete", defaultValue="false",enumeration="true,false",name="AutoComplete Select on Special Key",type="Boolean")]
	/**
	 * @private 
	 * 
	 * This is the key that is used for comparison sake with the autoCompleteSelectOnSpecialKey propeties.  
	 * 
	 *  @default Keyboard.TAB
	 * 
	 * @see #autoCompleteSelectOnSpecial
	 * @see #autoCompleteSelectOnSpecialIfEmpty
	 */
	public function get autoCompleteSelectOnSpecialKey(): int {
		return this._autoCompleteSelectOnSpecialKey;
	}
	
	/**
	 * @private
	 */
	public function set autoCompleteSelectOnSpecialKey(value : int):void{
		this._autoCompleteSelectOnSpecialKey = value;
		dispatchEvent(new Event("autoCompleteSelectOnSpecialKeyChanged"));
	}

    
    //----------------------------------
    // downArrowVisible
    //----------------------------------
	/** 
	 * @private
	 */
	private var _downArrowVisible : Boolean = true;
	/** 
	 * @private
	 */
	private var _downArrowVisibleChanged : Boolean = false;
	
    [Bindable("downArrowVisibleChanged")]
	[Inspectable(category="AutoComplete", defaultValue="true",enumeration="true,false",name="Display Down Arrow",type="Boolean")]
	/**
	 * This property will control the visibility of the down arrow.  Presumably you'll want to use this in conjunction with AutoComplete to 
	 * create an AutoCompleteTextInput, as opposed to an AutoCompleteDropDown.   Although you can use this if AutoComplete is not enabled, it 
	 * will most likely cause odd results and we do not recommend it.
	 * 
	 * @default true
	 */
	public function get downArrowVisible():Boolean {
		return this._downArrowVisible;
	}
	
	/** 
	 * @private
	 */
	public function set downArrowVisible(value:Boolean):void{
		// not sure why I had to hard this manually
		// but seems to be triggering the change even if we set it to the same value 
		if(this._downArrowVisible == value){
			return;
		}
		this._downArrowVisible = value;
		this._downArrowVisibleChanged = true;
		this.invalidateProperties();
        dispatchEvent(new Event("downArrowVisibleChanged"));
	}

    //----------------------------------
    //  restrict
    //----------------------------------
    /**
     *  @private
     */
    override public function set restrict(value:String):void
    {
        super.restrict = value;
		setAutoCompleteTextInputRestrict(value);

    }

	//----------------------------------
	//  enabled
	//----------------------------------
	/**
	 *  @private
	 * added to help solve issues where disabled ACCB w/ AutoCompletEnabled = true did not disable the AutoCompleteTextInput
	 */
	override public function set enabled(value:Boolean):void
	{
		super.enabled = value;
		if(this.autoCompleteTextInput ){
			this.autoCompleteTextInput.enabled = value;
		}
		
	}
	

	//----------------------------------
	//  errorString 
	//----------------------------------
	
	/**
	 * @private  
	 */
	override public function set errorString(value:String):void{
		super.errorString = value;
		if(this.autoCompleteEnabled == true){
			if(this.autoCompleteTextInput){
				this.autoCompleteTextInput.errorString = value;
			}
		}
	}

	

    //----------------------------------
    //  expandDropDownToContent 
    //----------------------------------
	/**
	 * @private
	 * private storage for the _expandDropDownToContent flag 
	 */
	private var _expandDropDownToContent : Boolean = false;
	/**
	 * @private
	 * private storage to check if the expandDropDownTocontent has changed flag 
	 */
	private var _expandDropDownToContentChanged : Boolean = false;

    [Bindable("expandDropDownToContentChanged")]
	[Inspectable(category="Expand Drop Down To Content", defaultValue="false",enumeration="true,false",name="Expand Drop Down to Content?",type="Boolean")]
	/**
	 * 
	 * This property specifies whether or not the drop down list will expand its’ <code>width</code> to make sure that none of it’s content will 
	 * be truncated.  If the drop down does not need to expand to fit the content, it will set itself to the specified width of 
	 * the <code>AutoCompleteComboBox</code>.  The Drop Down will never be smaller than the <code>width</code> of
	 * the <code>AutoCompleteComboBox</code>.  Only makes a change if content in the drop down will be truncated due to 
	 * the <code>width</code> of the <code> AutoCompleteComboBox </code>. 
	 * 
     *  @default false 
     */
	public function get expandDropDownToContent():Boolean{
		return this._expandDropDownToContent;
	}

	public function set expandDropDownToContent(value :Boolean):void{
		this._expandDropDownToContent = value;
		this._expandDropDownToContentChanged = true;
		this.invalidateDisplayList();
        dispatchEvent(new Event("expandDropDownToContentChanged"));
	}

    //----------------------------------
    //  selectedValue
    //----------------------------------
	/** 
	 * @private
	 * this is temporary storage for the selectedValue
	 */
    private var _selectedValue : String;
	/** 
	 * @private
	 * The Selected Value Changed
	 */
    private var _selectedValueChanged : Boolean = false;
    
    [Bindable("selectedValueChanged")]
	[Inspectable(category="Selected Value", name="Set the Selected Item Based on the value",type="String")]
    /**
     *  In HTML select boxes, you have a display piece, or label, and the value, or data.  The Flex <code>ComboBox</code> does not provide an 
     * easy way to deal with the value concept of an HTML select.  If you want to set the <code>ComboBox</code> to a value you can 
     * use <code>selectedIndex</code> to specify the <code>dataProvider</code> index, or <code>selectedItem</code> to specify the 
     * full object.  But, there is no way to select an item using one piece of behind the scenes data.  The <code>selectedValue</code> 
     * property is your answer for that.  You can use it to drill down to a specific <code>valueField</code> in your <code>dataProvider</code>.
     * 
     * @see #valueLabel
     * @see #valueFunction
     */
    public function get selectedValue():String{
		return this.itemToData(this.selectedItem);
    } 

	/** 
	 * @private
	 */
    public function set selectedValue(value:String):void{
    	this._selectedValue = value;
    	this._selectedValueChanged = true;
    	this.invalidateProperties();
    }


    //----------------------------------
    //  truncationIndicator
    //----------------------------------

	/**
	 * @private
	 *  implemented differently in Label; grabbing the value from some resource class
     *  Just adding a property seems easily flexible for users 
	 */
	private var _truncationIndicator : String = '...';
	/**
	 * @private
	 */
	private var _truncationIndicatorChanged : Boolean = false;

    [Bindable("truncationIndicatorChanged")]
	[Inspectable(category="Truncate to Fit", defaultValue="...",name="Truncation Indicator",type="String")]
	/**
	 * When the display text is too long for the space it can be showed in, this is the text used to truncate in display piece is too 
	 * long for the space, it will be truncated, and the <code>truncationIndicator</code> text appended to the end.  
	 * This property works works in 
	 * conjunction with <code>truncateToFit</code>.
	 * 
     *  @default '...' 
     *  @see #truncateToFit
     */
	public function get truncationIndicator():String{
		return this._truncationIndicator;
	}
	
	/**
	 * @private
	 */
	public function set truncationIndicator(value:String):void{
		this._truncationIndicator = value;
		this.invalidateDisplayList();
		this._truncationIndicatorChanged = true;
        dispatchEvent(new Event("truncationIndicatorChanged"));
	}


    //----------------------------------
    //  truncateToFit -- Modeled After Label
    //----------------------------------

	/**
	 * @private
	 * private storage for the Truncate to Fit flag 
	 */
    private var _truncateToFit:Boolean = false;

	/**
	 * @private
	 * private storage for the Truncate to Fit value changed flag 
	 */
    private var _truncateToFitChanged:Boolean = false;
    
    [Bindable("truncateToFitChanged")]
	[Inspectable(category="Truncate to Fit", defaultValue="false",enumeration="true,false",name="Truncate Content to Fit?",type="Boolean")]
    /**
     *  If the <code>truncateToFit</code> property is <code>true</code>, and the <code>ComboBox</code> control size is smaller than the 
     * text it needs to display, the text of the <code>Label</code> control is truncated using the text specified by 
     * <code>truncationIndicator</code>.  A <code>toolTip</code> is also created with the full text.  If this property is <code>false</code>, 
     * text that does not fit is clipped.
     * 
     *  @default false
     */
    public function get truncateToFit():Boolean{
    	return _truncateToFit;
    }

	/** 
	 * @private
	 */
    public function set truncateToFit(value : Boolean):void{
    	_truncateToFit = value;
    	_truncateToFitChanged = true;
    	this.invalidateDisplayList();
        dispatchEvent(new Event("truncateToFitChanged"));
    }

    //----------------------------------
    //  typeAheadEnabled 
    //----------------------------------
	/** 
	 * @private
	 */
	private var _typeAheadEnabled : Boolean = false;
	/** 
	 * @private
	 */
	private var _typeAheadEnabledChanged : Boolean = false;
	
    [Bindable("typeAheadEnabledChanged")]
	[Inspectable(category="Type Ahead", defaultValue="false",enumeration="true,false",name="Enable Type Ahead?",type="Boolean")]
	/**
	 * This property specifies whether the user can type-ahead with multiple characters. The default <code>ComboBox</code> only supports type-ahead functionality with a single character.  If <code>autoCompleteEnabled</code> is set to <code>true</code>, type-ahead functionality will be ignored.  Type-ahead and AutoComplete are mutually exclusive.
	 * 
     *  @default false 
     *  @see #typeAheadResetDelay
     */
	public function get typeAheadEnabled():Boolean{
		return _typeAheadEnabled;
	}	
	
	/** 
	 * @private
	 */
	public function set typeAheadEnabled(value:Boolean):void{
		_typeAheadEnabled = value
		this.invalidateProperties();
        dispatchEvent(new Event("typeAheadEnabledChanged"));
	}


    //----------------------------------
    //  typeAheadResetDelay 
    //----------------------------------
	/** 
	 * @private
	 */
	private var _typeAheadResetDelay : int = 4000;

    [Bindable("typeAheadResetDelayChanged")]
	[Inspectable(category="Type Ahead", defaultValue="4000",name="Type Ahead Reset Delay",type="int",format="Length")]
	/**
	 * This property specifies the number of milliseconds before the type-ahead text is reset to an empty string.  
	 * It has no effect if <code>typeAheadEnabled</code> is set to <code>false</code>.
	 * 
     *  @default 4000 
     */
	public function get typeAheadResetDelay (): int {
		return this._typeAheadResetDelay;
	}
	/** 
	 * @private
	 */
	public function set typeAheadResetDelay(value:int):void{
		this._typeAheadResetDelay = value;
        dispatchEvent(new Event("typeAheadResetDelayChanged"));
	}

    //----------------------------------
    //  typeAheadText 
    //----------------------------------
	/**
	 * @private
	 * private holder for the type ahead text 
	 */
	private var _typeAheadText : String = '';

    [Bindable("typeAheadTextChanged")]
	/**
	 * This property keeps track of the characters that the user typed.  It works with both type-ahead and AutoComplete functionality.  
	 * If <code>typeAheadEnabled</code> is set to <code>true</code>, then this will be reset on a timer based on 
	 * the <code>typeAheadResetDelay</code>.  If <code>autoCompleteEnabled</code> is <code>true</code>, this will be reset when the user 
	 * selects an item from the drop down or when the user clears out the text in the AutoComplete input.  
	 * You can access this value from an <code>itemRenderer</code> using 
	 * <pre>AutoCompleteListData(this.listData).typeAheadText</pre> , however it will always be an empty string 
	 * if <code>AutoCompleteEnabled</code> is <code>false</code>.  This value is exposed publicly using the <code>typeAheadTextValue</code> 
	 * property.
	 * 
     *  @default ''
     *  @see #typeAheadTextValue
     */
	protected function get typeAheadText():String{
		return this._typeAheadText;
	}
	
	// this was originally protected; we kind of want to do something about it 
	/** 
	 * @private
	 */
	protected function set typeAheadText(value:String):void{
		var changeEvent : AutoCompleteComboBoxEvent = new AutoCompleteComboBoxEvent(AutoCompleteComboBoxEvent.TYPE_AHEAD_TEXT_CHANGED,this._typeAheadText,value);
		this._typeAheadText = value;
		if(this.dropdown){
	       	// set the drop down type ahead text 
	       	// if AutoComplete is not enabled, don't set the typeAheadText
	       	if(this.autoCompleteEnabled == true){
		       	AutoCompleteDropDown(this.dropdown).typeAheadText = value;
	       	}
		}
        dispatchEvent(changeEvent);
	}


    //----------------------------------
    //  typeAheadTextValue 
	// This function exists because an ASDoc bug didn't allow us to make the getter for typeAheadText public while making the setter protected
	// So, typeAheadText was relegated to a protected property, and we expose it with typeAheadTextValue 
    //----------------------------------
	[Bindable("typeAheadTextChanged")]
	/**
	 * Exposes the type ahead text value that is used in both both typeAhead and AutoComplete functionality.
	 * if type ahead functionality is enabled then this will be reset each time the typeAheadResetDelay is counted down
	 * If autocompleteEnabled is true, this will not be reset.
	 * 
	 * If you want to reset this value you can use the autoCompleteSetTypeAheadText() method.
	 * 
	 * You can access the type ahead value from an itemRenderer using 
	 * <pre>
	 * AutoCompleteListData(this.listData).typeAheadText 
     * </pre>
     * 
	 * however it will always be an empty string if AutoComplete is not enabled 
	 * 
     *  @default ''
     *  @see #typeAheadText
     *  @see #autoCompleteSetTypeAheadText
     */
	public function get typeAheadTextValue():String{
		return this.typeAheadText;
	}

	/**
	 * @private
	 */
	public function set typeAheadTextValue(value:String):void{
		var changeEvent : AutoCompleteComboBoxEvent = new AutoCompleteComboBoxEvent(AutoCompleteComboBoxEvent.TYPE_AHEAD_TEXT_CHANGED,this._typeAheadText,value);
		this.autoCompleteSetTypeAheadText(value);
		dispatchEvent(changeEvent);
	}

    //----------------------------------
    //  valueField
    //----------------------------------
    // valueField is used, conceptually similar to labelField and is related to selectedValue

    /**
     *  @private
     *  Storage for the valueField property.
     */
    private var _valueField:String = "data";

    /**
     *  @private
     */
    private var valueFieldChanged:Boolean;

    [Bindable("valueFieldChanged")]
    [Inspectable(category="Selected Value", defaultValue="data",name="Value Field",type="String")]

    /**
     *  This property contains the name of the data in the items in the <code>dataProvider</code> Array that will be used for setting or 
     * getting the selectedValue.
     * 
     * <p>It defaults to <code>data</code>.  However, if the <code>dataProvider</code> items do not contain a <code>data</code> property, 
     * you can set the <code>valueField</code> property to use a different property.</p>
     *
     *  @default data
     * @see #selectedValue
     */
    public function get valueField():String
    {
        return _valueField;
    }

    /**
     *  @private
     */
    public function set valueField(value:String):void
    {
        _valueField = value;
        valueFieldChanged = true;

        dispatchEvent(new Event("valueFieldChanged"));
    }

    //----------------------------------
    //  valueFunction
    //----------------------------------
    // valueFunction is used, conceptually similar to labelFunction and is related to selectedValue

    /**
     *  @private
     *  Storage for the labelFunction property.
     */
    private var _valueFunction:Function;

    /**
     *  @private
     */
    private var valueFunctionChanged:Boolean;

    [Bindable("valueFunctionChanged")]
	[Inspectable(category="Selected Value", name="Value Function",type="Function")]
    /**
     *  This property represents a user-supplied function to run on each item to determine its value, or data.  By default the control uses 
     * a property named <code>data</code> on each <code>dataProvider</code> item to determine its data. 
     * However, some data sets do not have a <code>data</code> property, or do not have another property that can be used for selecting an 
     * item.
     * 
     * <p>The valueFunction takes a single argument which is the item  in the dataProvider and returns a String:</p>
     * <pre>
     * myLabelFunction(item:Object):String
     * </pre>
     *
     */
    public function get valueFunction():Function
    {
        return _valueFunction;
    }

    /**
     *  @private
     */
    public function set valueFunction(value:Function):void
    {
        _valueFunction = value;
        valueFunctionChanged = true;

        dispatchEvent(new Event("valueFunctionChanged"));
    }


    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    /**
     *  @inheritDoc
     */
    override public function close(trigger:Event = null):void{
    	if((!bInKeyDown) && (!bInFocusInHandler)){

	    	super.close(trigger);

			// adding this for this memory leak bug 
			// https://bugs.adobe.com/jira/browse/SDK-25384
			PopUpManager.removePopUp(super.dropdown); 

    	}
    	
    }
    

    /**
     *  @inheritDoc
     */	
    override public function open():void{
		// recalculate the width of the drop down if ExpandDropDownToContent is enabled 
		if(expandDropDownToContent == true){
			// code copied conceptually from updateDisplayList
			// if we can cancel it there, must be able to cancel it here too
			this.resizeDropDownWidth();
		}

    	super.open();

    	return;

    }
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

   	
	/**
	 * @private
	 * Private helper function to add a listener to the drop down change handler
	 */
   	private function addDropDownChangeListener():void{
        if(this.dropdown){
        	this.addEventListener('change',dropdown_changeHandler);
        }
   	}

	/**
	 * This is the default filter function for AutoComplete functionality.  It uses a regular expression to search through the label text to filter values.
	 * @param item The item that is going to be investigated for filtering purposes
	 * 
	 * @return <code>true</code> if the item meets the filter criteria, <code>false</code> otherwise.
 	 * 
	 * @see #autoCompleteEnabled
	 * @see #autoCompleteFilterFunction
     */
	protected function autoCompleteFilter ( item:Object):Boolean{
		// regular expression should be: 
		// any number of characters + Our String in sequence + any number of character
		//  The '/' is the literal character
		// the '\' is the escape character
		// '*' is a quantifier specifies any number of X
		//  /i means ignore case sensitivity 
		// 	\						 /typeAheadText/ 
//		var regEx : RegExp = /  /i
		var regEx : RegExp = new RegExp('.*' + this.typeAheadText + '.*' ,'i')
		
		// probably want to use match on this string
		var label : String = this.itemToLabel(item);
		
		if(label.match(regEx)){
			return true;
		}

		return false;
	}

	/**
	 * @private 
	 * 
	 * This method performs the autoCompleteSelectOnEqual comparison operation, with consideration for the 
	 * autoCompleteSelectOnEqualCaseSensitivity property.
	 * 
	 * @return Returns true if the typeAheadText is equal to the dataProvider's item label; false otherwise
	 * 
	 */
	protected function autoCompleteSelectOnEqualComparison():Boolean{
		autoCompleteSelectOnEqualCaseSensitivity
		if(autoCompleteSelectOnEqualCaseSensitivity == true){
			return (this.typeAheadTextValue == this.itemToLabel(ListCollectionView(this.dataProvider)[0]));
		}
		return (this.typeAheadTextValue.toLowerCase() == this.itemToLabel(ListCollectionView(this.dataProvider)[0]).toLowerCase());
	}


	/**
	 * This method lets you reset the AutoComplete Type Ahead Text. Using this method will cause the AutoComplete dataProvider to perform its filtering again.
	 * 
	 * @param value The value you want to set the TypeAhead to; by default this is blank, or an empty string
	 */
	public function autoCompleteSetTypeAheadText(value : String = ''):void{
		// JH DotCmIt 10/4/2010 Added to make sure we didn't try to set the text before the autoComplete was created
		if(this.autoCompleteTextInput){
			// JH DotComIt 10/5/2010 added to make sure we don'tset the typeAheadText to the same item it already is; 
			// which would cause an infinite loop
			if(this.autoCompleteTextInput.text != value){
		this.autoCompleteTextInput.text = value;
		this.filterDataProvider();
	}
		}
	}
    
	/**
	 * @private
	 * function to calculate the drop down width 
	 * Used as a helper function when expandDropDownContent is True and we may want to change the width from the default 
	 */	
    private function calculateDropDownWidth():Number{

		// calculate the width of the longest item in the dataProvider
		// code to do this already exists in measureWidthOfItems 
		// could be a potentially time consuming; make sure that we only 
		// execute this if it needs to be changed 
		if(bCalculateDropDownWidth == false){
			return this.width;
		} else {
			var tempWidth : int = this.dropdown.measureWidthOfItems( 0,0 );
	
	    	if(tempWidth + this.dropdown.viewMetrics.right > this.width){
		        return tempWidth + this.dropdown.viewMetrics.right;
	    	} else {
	    		return this.width;
	    	}
	    	bCalculateDropDownWidth = false;
		}

    }

	/** 
	 *  @private
	 * Creates the Text Input
	 */
    private function createAutoCompleteTextInput():void{

		if(autoCompleteTextInput){
			// sometimes this field may be created before the textInput for display 
			// if we're back here and the size is zero, reset it
			if((autoCompleteTextInput.width == 0) || (autoCompleteTextInput.height ==0)){
				autoCompleteTextInput.setActualSize(this.textInput.width,this.textInput.height);
			}
			return;
		}

		// a lot of this copied from createChildren code for creating the textInput
		var textInputStyleName:Object = this.getStyle('autoCompleteTextInputStyleName');
		if (!textInputStyleName)
		    textInputStyleName = new StyleProxy(this, textInputStyleFilters);

		autoCompleteTextInput = new TextInput();		
//		autoCompleteTextInput.styleDeclaration = this.getStyle('autoCompleteTextInputStyleName');
		autoCompleteTextInput.editable = true;
		autoCompleteTextInput.enabled = this.enabled;

		// JH added 10/4/2010 to default the autoComplete text to the text property 
		autoCompleteTextInput.text = this.text;
		
		setAutoCompleteTextInputRestrict(this.restrict );

		autoCompleteTextInput.focusEnabled = false;
		autoCompleteTextInput.imeMode = this.imeMode;
		autoCompleteTextInput.styleName = textInputStyleName;
		if(this.errorString != ''){
			autoCompleteTextInput.errorString = this.errorString;
		}
		autoCompleteTextInput.addEventListener(KeyboardEvent.KEY_DOWN,autoCompleteKeyDownHandler);
		autoCompleteTextInput.addEventListener(KeyboardEvent.KEY_UP,autoCompleteKeyUpHandler);
		autoCompleteTextInput.addEventListener(FocusEvent.FOCUS_IN,autoCompleteFocusIn);
		autoCompleteTextInput.addEventListener(FocusEvent.FOCUS_OUT,autoCompleteFocusOut);

		// JH DotComIt 11/10/2011
		// testing some code for when the text changes to make sure the location of the cursor is proper
		autoCompleteTextInput.addEventListener(FlexEvent.VALUE_COMMIT,autoCompleteTextInputTextChange);
		
		addChild(autoCompleteTextInput);
		// testing this 
		autoCompleteTextInput.setActualSize(this.textInput.width,this.textInput.height);
		
		autoCompleteTextInput.move(0, 0);

		autoCompleteTextInput.parentDrawsFocus = true;
		
    }

    /**
     *  @private
     */
    protected function isDropDownVisible():Boolean{
    	if(this.dropdown){
	    	return this.dropdown.visible;
    	}
    	return false;
    }

    /**
     *  Returns a string representing the <code>data</code> parameter, Modeled, conceptually, after <code>itemToLabel</code> 
     * 
     * @param item The item we want to pull the data out of .
     * 
     *  <p>This method checks in the following order to find a value to return:</p>
     *  
     *  <ol>
     *    <li>If you have specified a <code>valueFunction</code> property,
     *  returns the result of passing the item to the function.</li>
     *    <li>If the item is a String, Number, Boolean, or Function, returns
     *  the item.</li>
     *    <li>If the item has a property with the name specified by the control's
     *  <code>valueField</code> property, returns the contents of the property.</li>
     *    <li>If the item has a data property, returns its value.</li>
     *  </ol>
     * 
     */
    public function itemToData(item:Object):String
    {
        // we need to check for null explicitly otherwise
        // a numeric zero will not get properly converted to a string.
        // (do not use !item)
        if (item == null)
            return "-1";

        if (valueFunction != null)
            return valueFunction(item);

        if (typeof(item) == "object")
        {
            try
            {
                if (item[valueField] != null)
                    item = item[valueField];
            }
            catch(e:Error)
            {
            }
        }
        else if (typeof(item) == "xml")
        {
            try
            {
                if (item[valueField].length() != 0)
                    item = item[valueField];
            }
            catch(e:Error)
            {
            }
        }

        if (typeof(item) == "string")
            return String(item);

        try
        {
            return item.toString();
        }
        catch(e:Error)
        {
        }

        return "-1";
    }

	/** 
	 * @private
	 * Created out of AutoCompleteKeyUpHandler to make the filtering process a bit more usable
	 * created so that the autoCompleteSetTypeAhead text would properly filter the dataProvider 
	 * @param event
	 * 
	 */	
	protected function filterDataProvider(event:KeyboardEvent = null):void{
		// if we're typing new, be sure to reset the selectedIndex 
		// odd situation if you manually set selectedIndex to -1 [not inside this component] it does not refresh the 
		// AutoCompleteTextInput.text.  We added code in selectedIndex to address that; however this was screwing up the 
		// AutoComplete functionality here; so re-working this code a bit
		
       	this.typeAheadText = this.autoCompleteTextInput.text ;
		this.autoCompleteInputSaveOnSelectedIndexChange = true;
		this.selectedIndex = -1;
		this.autoCompleteInputSaveOnSelectedIndexChange = false;
//       	this.autoCompleteTextInput.text = this.typeAheadText  ;

		// filter the dataProvider
		var dp : ListCollectionView = ListCollectionView(this.dataProvider);
		dp.filterFunction = this.autoCompleteFilterFunction;

		var filterBeginEvent : AutoCompleteCollectionEvent = new AutoCompleteCollectionEvent(AutoCompleteCollectionEvent.AUTOCOMPLETE_DATAPROVIDER_FILTER_BEGIN, this.autoCompleteFilterFunction,false,true)
		dispatchEvent(filterBeginEvent);
		if(!filterBeginEvent.isDefaultPrevented()){
			
			// JH added 4/16/09 
			// fixes a visual display oddity that I noticed when dealing with a custom FilterFunction
			// and erasing all the text 
			if(this.typeAheadText  == ''){
				// seems to be an odd case if we are here and autoCompleteSelectOnEqual is true then
				// selectedIndex and dropDown.selectedIndex are out of sync, causing the selectedIndex to be reset
				if(this.autoCompleteSelectOnEqual == true){
					this.dropdown.selectedIndex = this.selectedIndex;
				}
	        		this.close(event);
			}
			
			dp.refresh();
			dispatchEvent(new AutoCompleteCollectionEvent(AutoCompleteCollectionEvent.AUTOCOMPLETE_DATAPROVIDER_FILTERED, this.autoCompleteFilterFunction));
			
		}

		// drop down would pop open if this function was called via autoCompleteSetTypeAheadText and the component did not have focus
		// so only do these open / close changes if the current component has focus 
		if(this.focusManager.getFocus() == this){
	    	if(this.typeAheadText  != ''){
				if(isDropDownVisible() == false ){
					// we aren't expanding the drop down w/ the button
					// autocompleteRemoteData is true and there is no data in the collection we don't want to
					// open the drop down yet
					if( (this.autoCompleteRemoteData == false) || (this.collection.length != 0) ){
						// it can't be right to check this condition twice
						// but if nothing in collection [filtered or not], no reason to open the drop down
						if((this.collection.length != 0)){
	        			this.open();
					}
		        		
					}
				}
	    	} else {
		    		this.close(event);
	    	}
			
		}
		
	}

	/** 
	 * @private
	 * This function exists only for the purpose of repositioning the drop down.
	 * If the drop down opens up because it is near the bottom of the screen, 
	 * the resize of the drop down when items are removed from the list could position the list in aweird place,
	 * spaced out from the drop down.
	 *  
	 * 
	 */
	protected function repositionDropDown():void{
		
		// if autoComplete is not enabled, we don't care about running this function
		if(this.autoCompleteEnabled == false){
			return;
		}
		
		// first figure out the y location the drop down should be at if opened down
//		var globalPointAC : Point = this.localToGlobal(new Point(x, y));
//		var contentPointAC : Point = this.localToContent(new Point(x, y));

//		var globalPointDD : Point = this.localToGlobal(new Point(this.dropdown.x, this.dropdown.y));
//		var contentPointDD : Point = this.localToContent(new Point(this.dropdown.x, this.dropdown.y));
		
		var dropDownLoc : Point = new Point(0, unscaledHeight);
		dropDownLoc = localToGlobal(dropDownLoc);
		
//		var dropDownYIfOpenedDown : int = this.y + this.height;
		var dropDownYIfOpenedDown : int = dropDownLoc.y;
		
		// then figure out the current y location of the drop down
		var dropDownYCurrent : int = this.dropdown.y;
		
		// if they currentY location is different than the downdropY location, then reposition the drop down
		// reposition formula will be something like 
		// newDropDownY = ACCB.y-dropdownHeight
		if(dropDownYIfOpenedDown != dropDownYCurrent){
//			trace('drop down opened up, reposition it');

			// this segment copied from the ComboBox open method
			var point:Point = new Point(0, unscaledHeight);
			point = localToGlobal(point);
			// this copied from the drop down open method
			point.y -= (unscaledHeight + this.dropdown.height);

			// this copied from drop down open method 
			// weird it is doing local to Global, performing calculations, and then going bakc
			// is this even needed?
			// isn't the drop down's parent the ComboBox?  Perhaps not since it is positioned w/ the pop up Manager
			if(this.dropdown.parent){
				point = this.dropdown.parent.globalToLocal(point);
			}
//			point = this.globalToLocal(point);
	
			// this approach works, but I'm testing the other, simplier approach too 
			this.dropdown.move(point.x, point.y);

	
			// a much simpler method than the controls above; seems to work pretty well 
//			var newDropDownY : int = this.y - this.dropdown.height;
//			this.dropdown.move(this.dropdown.x,newDropDownY);
		}
		
	}

	/** 
	 * @private
	 * resizes the textInput and the AutoCompleteTextInput with regards to whether or not the down arrow button is visible
	 * used from commitProperties
	 */
	protected function resizeTextInputWidth():void{
		// find out new width
		var extraWidth : int = getStyle("arrowButtonWidth");
		if(this.downArrowButton.visible == true){
			extraWidth = -extraWidth;
		}
	
		// change size of textInput for display and AutoCompleteTextInput
		this.textInput.setActualSize(this.textInput.width + extraWidth,this.textInput.height);
		if(this.autoCompleteTextInput){
			this.autoCompleteTextInput.setActualSize(this.autoCompleteTextInput.width + extraWidth,this.autoCompleteTextInput.height);
		}
	}


	/** 
	 * @private
	 * The functionality to resize the drop down height was pulld out of the updateDisplayList method, 
	 * height was not calculating properly after selecting an item in keyup event using 
	 * autoCompleteSelectOnEnter or autoCompleteSelectOnOne or autoCompleteSelectOnEqual
	 * this encapsulates the logic and we can call it in the downarrowbuttonHandler method
	 */
	protected function resizeDropDownHeight():void{
		
		
		// if the number of items in the list have a shorter Height than the dropdown List height
		// we want to make he list smaller so we don't have the 'stuff' hanging out there 
		// The list height if all items are being displayed
		var oldHeight : int = this.dropdown.height ;
		// the newListHeight is not accounting for top and bottom padding 
		// never had a problem before Flex 3.5 because sizing was always reset when things were re-created 
		var o:EdgeMetrics = this.dropdown.viewMetrics;
		var newListHeight : int = this.dropdown.rowHeight * this.dataProvider.length  + o.top + o.bottom;
		var maxRowHeight : int = this.dropdown.rowHeight * this.autoCompleteRowCount + o.top + o.bottom;;
//		trace(oldHeight);
//		trace(newListHeight);
//		trace(maxRowHeight);
		var dropdownHeightChanged : Boolean = false;
		if( (newListHeight < this.dropdown.height) ||  
			( (newListHeight < maxRowHeight) && (newListHeight > this.dropdown.height)) ||  
			// 3rd condition which is really the second condition w/ a <= option
			// adding new condition instead of modifying previous one because the error only showed up
			// when remoteData was set to true... and no easy way to test all other conditions 
			( (this.autoCompleteRemoteData == true) && (newListHeight <= maxRowHeight) && (newListHeight > this.dropdown.height))  
		){
			this.dropdown.height = newListHeight;
			dropdownHeightChanged = true;
			dispatchEvent(new AutoCompleteComboBoxResizeEvent(AutoCompleteComboBoxResizeEvent.DROPDOWN_HEIGHT_EXPANDED,oldHeight,this.dropdown.height));
		} else if ((newListHeight > maxRowHeight) && (this.dropdown.height < maxRowHeight) ){
			this.dropdown.height = maxRowHeight;
			dropdownHeightChanged = true;
			dispatchEvent(new AutoCompleteComboBoxResizeEvent(AutoCompleteComboBoxResizeEvent.DROPDOWN_HEIGHT_EXPANDED,oldHeight,this.dropdown.height));
		}
//		trace(this.dropdown.height);
		//			this doesn't seem to be changing / calculating the width properly when it should shrink 
		//			Not sure why; kinda gave up on it 
		//			No precedent for AutoCompleteDrop Downs that expand past the drop down / imput field
		//			this.dropdown.width = calculateDropDownWidth();
		
		if(dropdownHeightChanged == true){
			this.dropdown.invalidateDisplayList();
			dropdownHeightChanged = false;
			this.repositionDropDown();
		}
		
		// at this point the autoCompleteTextInput display value is not always being updated properly; so just reset it manually here
		// only reset it if there is a selectedLabel because otherwise things just work all screwy like 
		if(this.selectedLabel !=''){
			this.autoCompleteTextInput.text = this.selectedLabel;
		}
		
	}
	

	/** 
	 * @private
	 * The functionality to resize the drop down width was the same in both updateDisplayList and the Close method, so we 
	 * encapsulated it out here
	 */
	private function resizeDropDownWidth():void{
		
		var newWidth : int = calculateDropDownWidth();	
		var dropdownWidthExpandedEvent : AutoCompleteComboBoxResizeEvent = new AutoCompleteComboBoxResizeEvent(AutoCompleteComboBoxResizeEvent.DROPDOWN_WIDTH_EXPAND_BEGIN,this.dropdown.width,newWidth,false,true);
		dispatchEvent(dropdownWidthExpandedEvent);
		
		if(!dropdownWidthExpandedEvent.isDefaultPrevented()){
			this.dropdown.width = newWidth	
			dispatchEvent(new AutoCompleteComboBoxResizeEvent(AutoCompleteComboBoxResizeEvent.DROPDOWN_WIDTH_EXPANDED,this.dropdown.width,this.dropdown.width));
		} else {
			this.dropdown.width = this.width;
			dispatchEvent(new AutoCompleteComboBoxResizeEvent(AutoCompleteComboBoxResizeEvent.DROPDOWN_WIDTH_EXPAND_CANCELLED,this.dropdown.width,this.dropdown.width));
		}
	}
    
	/** 
	 * @private
	 */
	 // used by commitProperties and collection chage to set the default selectedIndex on a dataProvider change
    protected function setAutoCompleteDefault():void{
    	if(this.autoCompleteEnabled == false){
    		return;
    	} else if(this.autoCompleteRemoteData == true){
    		return;
    	}
    	if(this.autoCompleteResetIndex > ListCollectionView(this.dataProvider).length-1){
			this.selectedIndex = -1;
    	} else {
			this.selectedIndex = this.autoCompleteResetIndex;
    	}

/*  		if(this.selectedIndex == -1){
				// added prompt setting 
				this.autoCompleteTextInput.text = this.prompt;
 		}
 */
		if(this.selectedIndex != -1){
			// this code is now in the selectedIndex; not needed here 
			this.autoCompleteTextInput.text = this.itemToLabel(this.dataProvider[this.selectedIndex]);
		} else {
			// added prompt setting 
			this.autoCompleteTextInput.text = this.prompt;
		}
    }

	/**
	 * helper function for setting the restrict on the AutoCompletTextInput
	 * @private
	 */
	protected function setAutoCompleteTextInputRestrict(value:String):void{
		// Don't show ESC characters in the text field.
		if((!this.restrict) || (this.restrict == '')){
			autoCompleteTextInput.restrict = "^\u001b";
		} else {
			autoCompleteTextInput.restrict = this.restrict;
		}

    }

	/**
	 * helper function for setting the cursor location in the AutoCompleteTextInput
	 * @private
	 */
	protected function setAutoCompleteCursorLocation():void{

		if(this.autoCompleteCursorLocationOnSelect == true){
			this.autoCompleteTextInput.setSelection(0,0);
		} else {
			this.autoCompleteTextInput.setSelection(this.autoCompleteTextInput.text.length,this.autoCompleteTextInput.text.length);
		}
		
	}

    /**
     *  This method truncates text to make it fit horizontally in the area defined for the control, and append 
     * the <code>trunctationIndicator</code> to the text.  By default, the <code>truncationIndicator</code> is an ellipse, three periods (...) 
     * 
     * @param truncationIndicator The text to be appended after truncation.
     * If you pass <code>null</code>, a localizable string such as <code>"..."</code> will be used.
     * 
     * @return <code>true</code> if the text was truncated, <code>false</code> otherwise.
     */
	// Copied / borrowed from UITextField [and then modified]  
    protected function truncateLabel():Boolean
    {
                
        // Ensure that the proper CSS styles get applied to the textField
        // before measuring text.
        // Otherwise the callLater(validateNow) in styleChanged()
        // can apply the CSS styles too late.
        // commented this out because it causes the text to go full length and then be truncated again
//        validateNow();
        
        var originalText:String = selectedLabel;

        var w:Number = textInput.width;
        // the extra width added by styles and padding
        var extraWidth : Number = 
						this.textInput.getStyle('paddingRight') + this.textInput.getStyle('paddingLeft' ) +
						this.getStyle('paddingRight') + this.getStyle('paddingLeft')  ;


		// Comment from copied code; didn't test this w/ alternate fonts 
        // Need to check if we should truncate, but it 
        // could be due to rounding error.  Let's check that it's not.
        // Examples of rounding errors happen with "South Africa" and "Game"
        // with verdana.ttf.
        if (originalText != "" && ((TextInput(textInput).textWidth + extraWidth)  > w + 0.00000000000001))
        {

            // This should get us into the ballpark.
            var s:String = textInput.text = originalText;
			s = originalText.slice(0, Math.floor((w / (TextInput(textInput).textWidth + extraWidth)) * originalText.length));

            while (s.length > 1 && (this.measureText(textInput.text).width + extraWidth)  > w)
            {
                s = s.slice(0, -1);
                textInput.text = s + truncationIndicator;
            }

			dispatchEvent(new AutoCompleteComboBoxEvent(AutoCompleteComboBoxEvent.LABEL_TRUNCATED,this.selectedLabel,this.textInput.text));
            return true;
        }

		dispatchEvent(new AutoCompleteComboBoxEvent(AutoCompleteComboBoxEvent.LABEL_NOT_TRUNCATED,this.selectedLabel,this.textInput.text));

        return false;
    }


    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function collectionChangeHandler(event:Event):void{

    	if((this.expandDropDownToContent == true) && (event is CollectionEvent)){
	    	// set the flag to recalculate the drop down width if the dataProvider has changed
	    	this.bCalculateDropDownWidth = true;
			// no need for invalidation methods	because it will automatically be resized and reset the next time the 
			// drop down is requested
    	}

		// had to make changes here because the super.CollectionChangeHandler was destorying and re-creating the drop down every time
		// that the collection was filtered.  this made for visual display oddities
		// took me two weeks to figure this out; really why are they destroying it as opposed to just changing the visibility?  
		// I don't get it 
    	if((this.autoCompleteEnabled == true) && (event is CollectionEvent)){
    		var ce : CollectionEvent = CollectionEvent(event);
			if (ce.kind == CollectionEventKind.RESET)
            {
//            	if(this.autoCompleteRemoteData == false){
	            	// this section works because it does not set the collectionChanged variable to false 
	            	// therefore drop down is not destroyed in commitProperties 
	                if (!selectedIndexChanged && !selectedItemChanged){
//	                    this.selectedIndex = this.autoCompleteResetIndex;
						setAutoCompleteDefault();
	                }
	                invalidateProperties();
/* 
            	} else {
            		// autoCompleteRemoteData == true; so be sure not to destroy the drop down; unless the new dataProvider length is 0
            		// 
            		
            	}
 */

            } else if (ce.kind == CollectionEventKind.REFRESH){
				// actions copied from ComboBase 
	            selectedItemChanged = true;
	            // Sorting always changes the selection array
	            this.invalidateDisplayList();
                dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));


	    	} else if((ce.kind == CollectionEventKind.ADD) || 
						(ce.kind == CollectionEventKind.REMOVE)
					){
				
				// JH DotComIt 12/15/010 adding condition here
				// if someone adds items directly to the dataProvider with AutoComplete on e sure to 
				// resize the drop own.  
				this.invalidateDisplayList();
	    	}
			return;
    	} 

    	super.collectionChangeHandler(event);
    }

    /**
     *  @private
     * This handles the opening of the drop down menu
     * we modified it here to change the size of the drop down window to fit the content
     */
    override protected function downArrowButton_buttonDownHandler(
                                    event:FlexEvent):void
    {


		// problem with drop down disappearing 
		// Flex 3.5 doesn't destroy / recreate it every time; it keeps it hanging out in memory
		// so if it exists and has no data elements don't resize the drop down; just return  
		if( 
			(this.dropdown) && 
			((this.dropdown.dataProvider as ListCollectionView).length ==0 )
			){
			return;
		}

		// do we want to expand the drop down to the content
		// super.dropdown bypasses open method ( No idea why ) so we have to do the calculation here
		// in addition to the open method 
	
		if(expandDropDownToContent == true){
			resizeDropDownWidth();
//			if we don't use the method call resizeDropDownWidth the events don't fire correctly 
//			this.dropdown.width = calculateDropDownWidth();
		}

		
		// in some cases the size of the drop down is wrong when it opens
		// if it was selected something and closed as part of 
		//  autoCompleteSelectOnEnter or autoCompleteSelectOnOne  or autoCompleteSelectOnEqual
//		trace('Opening w/ Down Arrow');
		this.resizeDropDownHeight();

//		trace(this.dropdown);

    	super.downArrowButton_buttonDownHandler(event);
    	
    	// added trying to diagnose the negative rowHeight bug in Flex 4
//    	if(this.dropdown.height == 0){
//    		this.dropdown.explicitHeight = NaN;
//   		this.dropdown.invalidateProperties();
//  		this.dropdown.invalidateDisplayList();
    		this.invalidateDisplayList();
//   	}

		addDropDownChangeListener();
    		
   	}

    /**
     *  @private
     * 
     * if AutoComplete is enabled, send focus to the textInput
     * JH DotComIt 4/28/09
     */
    override protected function focusInHandler(event:FocusEvent):void{

    	super.focusInHandler(event);

/*
    	if(bInFocusInHandler == true){
    		return;
    	}
*/
    	if(this.autoCompleteEnabled == true){
    		// using bInFocusInHandler modeled after bInKeyDown 
    		// kinda kludgy way to prevent the ComboBox from closing
    		this.bInFocusInHandler = true;
    		this.autoCompleteTextInput.setFocus();
    		this.bInFocusInHandler = false;
       	}
    }


    /**
     *  @private
     * It is a real pain to debug w/ the focus out handler in and uncommented
     */
    override protected function focusOutHandler(event:FocusEvent):void
    { 
		if((this.autoCompleteEnabled == true) && (event.relatedObject == this)){
			event.stopImmediatePropagation();
			event.stopPropagation();
			return; 
		} else if ((this.autoCompleteEnabled == true) && (event.relatedObject) && 
					(event.relatedObject.parent == this.autoCompleteTextInput)){
			event.stopImmediatePropagation();
			event.stopPropagation();
			return; 
		}

    	super.focusOutHandler(event);
    }

    // handles pressing of a key 
    /**
     *  @private
     */
    override protected function keyDownHandler(event:KeyboardEvent):void{
		
		if(autoCompleteEnabled == true ){
			// if autocompete is enabled then all key down / key up handling is done 
			// in the AutoCompleteKeyUpHandler and autoCompleteKeyDownHandler 
			// just stop the propogation and return

			event.stopPropagation();
			return;
			
		} else if(this.typeAheadEnabled == true){
			// if dealing with type ahead
			 this.bInKeyDown = true;
			 
             if (!editable && 
            	((event.keyCode == Keyboard.BACKSPACE ) || 
            	 (event.charCode >= 32 && (event.charCode < 127)) )
            	)
            {
            	if(event.keyCode != Keyboard.BACKSPACE){
					// if back space cut a character from type ahead text
					this.typeAheadText += String.fromCharCode(event.charCode);
            	} else {
					// otherwise add the new character to the type ahead text
					this.typeAheadText = this.typeAheadText.slice(0,this.typeAheadText.length-1);
            	}
            	
				// if the type ahead text does not change the selection; don't do the search 
            	if(this.typeAheadText.toLowerCase() != this.selectedLabel.substr(0,this.typeAheadText.length).toLowerCase()){
            		
					var foundString : Boolean = this.dropdown.findString(this.typeAheadText);
					if (foundString == false){
						// some weird recursion magic to delete the last character because nothing was found 
						// this also prevents the currently selected item from changing to the next item that meets the 
						// current criteria 
						event.keyCode = Keyboard.BACKSPACE;
						keyDownHandler(event);
						return;
						
					} 
            	}
				// if timer is running, stop it
				if((this.typeAheadReleaseTimer) && (this.typeAheadReleaseTimer.running)){
					this.typeAheadReleaseTimer.stop()
				dispatchEvent(new TypeAheadTimerEvent(this.typeAheadText,TypeAheadTimerEvent.TYPEAHEAD_RELEASETIMER_STOP));
				}
				// Create a new timer and start it running again
				this.typeAheadReleaseTimer = new Timer(this.typeAheadResetDelay,1);
				this.typeAheadReleaseTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onTypeAheadReleaseTimerComplete);
				this.typeAheadReleaseTimer.start();
				dispatchEvent(new TypeAheadTimerEvent(this.typeAheadText,TypeAheadTimerEvent.TYPEAHEAD_RELEASETIMER_START));

            } else {
				// if user didn't modify the current text; blank it out and call super tohandle other situations
				// like arrows or page up / page down
   				this.typeAheadText = '';
   				super.keyDownHandler(event);
            }
			
		} else {
			// if no autocomplete and no type ahead; just call super to handle whatever is going on
			super.keyDownHandler(event);
		}

		 this.bInKeyDown = false;

    }


    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    protected function autoCompleteFocusIn(event:FocusEvent):void{
    	if((this.autoCompleteHighlightOnFocus == true) && (this.autoCompleteTextInput.text.length >0)){
			if(this.autoCompleteTextInput.text == this.prompt){
				this.autoCompleteTextInput.text = '';
			}
    		this.autoCompleteTextInput.setSelection(0, this.autoCompleteTextInput.text.length);
    	}
    }

    /**
     *  @private
     */
     protected function autoCompleteFocusOut(event:FocusEvent):void{
    	if(this.autoCompleteHighlightOnFocus == true){
    		if((this.autoCompleteTextInput.text.length == 0) && (this.prompt)){
				this.autoCompleteTextInput.text = prompt;
    		}
    		this.autoCompleteTextInput.setSelection(0, 0);
    	}
    }
    
	 
	 /**
	  * @private 
	  */
	 protected function autoCompleteTextInputTextChange(event:FlexEvent):void{
//		 trace('autoCompleteTextInputTextChange');
		 this.setAutoCompleteCursorLocation();
	 }
	 
    /**
     *  @private
     */
    protected function autoCompleteKeyDownHandler(event:KeyboardEvent):void{
		// if we are in here then it must be AutoComplete 

		if ((event.keyCode == Keyboard.UP ) || ( event.keyCode == Keyboard.DOWN) ||
			(event.keyCode == Keyboard.PAGE_UP) || (event.keyCode == Keyboard.PAGE_DOWN)
	    		){
	    	// only do this stuff if there is an item in the dataProvider
	    	// otherwise can throw a fringe error up the inheritance chain in some cases 
	    	if((this.dataProvider as ListCollectionView).length > 0){
			// copied a bit from ComboBox keyDownHandler
			// and modified as always 
			// implement code here to traverse up and down the list             	
	
	        // Make sure we know we are handling a keyDown,
	        // so if the dropdown sends out a "change" event
	        // (like when an up-arrow or down-arrow changes
	        // the selection) we know not to close the dropdown.
	        bInKeyDown = this.isDropDownVisible();
	        // Redispatch the event to the dropdown
	        // and let its keyDownHandler() handle it.
	
	        dropdown.dispatchEvent(event.clone());
	        event.stopPropagation();
	        bInKeyDown = false;
	        
			// make sure that the cursor is at the end of the selection 
				//		        this.autoCompleteTextInput.setSelection(0,0);	
				// encapsualted into a function.  Oddly the line did the exact opposite of what the comment said
				this.setAutoCompleteCursorLocation();
	        // could not figure out a way to programatically put cursor at end of ComboBox while displaying the front
	//	        this.autoCompleteTextInput.setSelection(this.autoCompleteTextInput.text.length,this.autoCompleteTextInput.text.length);	
	        this.autoCompleteTextInput.invalidateDisplayList();

	    	}

			return; 	
	    }

    	keyDownHandler(event);


		// JH DotComIt 6/15/2010 added to support selecting the item on any given key press 
		// autoCompleteKeyUpHandler was not firing if the tab key was pressed because the up Event probably fires on 
		// some alternate object; so make sure that it fires here
		if((this.autoCompleteSelectOnSpecial == true ) && 
			(this.autoCompleteSelectOnSpecialKey == Keyboard.TAB) && 
			(event.charCode == Keyboard.TAB)

		){
			autoCompleteKeyUpHandler(event);
		}
		
		

    }

    /**
     *  @private
     * this function finds the new type ahead text and filters the dataProvider if applicable
     * if we're in here, then AutoComplete must be enabled
     */
   protected function autoCompleteKeyUpHandler(event:KeyboardEvent):void{
		
        if ( (event.currentTarget == this.autoCompleteTextInput) ){

			// JH DotComIt 6/15/2010 added to support selecting the item on any given key press 
			if ((this.autoCompleteSelectOnSpecial == true ) && 
				(event.charCode == this.autoCompleteSelectOnSpecialKey)){
				
				// be sure that there is at least one item in the dataProvider before trying to select it
				if( (ListCollectionView(this.dataProvider).length >= 1) && 
					(
						((this.autoCompleteSelectOnSpecialIfEmpty == false ) && (this.typeAheadText != '')) ||
						(this.autoCompleteSelectOnSpecialIfEmpty == true ) 
					)
					
				){

					// if user presses enter key close drop down 
					this.close(event);
					
					this.dropdown.commitSelectedIndex(0);
					this.selectedIndex = 0;
					this.dropdown.selectedIndex = 0;
					dispatchEvent(new ListEvent(ListEvent.CHANGE));


//					this.autoCompleteTextInput.setSelection(0,0);
					this.setAutoCompleteCursorLocation();
					
					//						this.dropdown.verticalScrollPosition = Math.max(0,this.selectedIndex-1);
					this.typeAheadText = '';
				}
				
			} else 

			if ( (event.keyCode == Keyboard.BACKSPACE ) || 
	        	 (event.keyCode == Keyboard.DELETE ) || 
	        	 (event.charCode >= 32 && (event.charCode < 127)  ) ) 
            {
				filterDataProvider(event);

				// JH DotComIt 8/4/09 
				// if there is only item left in the dataProvider and it is equavelent to the typeAhead text 
				// go ahead and select it
				// JH DotComIt 3/13/2010
				// if there is only item left in the dataProvider and autoCompleteSelectOnOne is true 
				// go ahead and select it
				if( ( 	(this.autoCompleteSelectOnEqual == true) && 
						(this.autoCompleteTextInput.text != '') && 
						(ListCollectionView(this.dataProvider).length == 1) &&
						( autoCompleteSelectOnEqualComparison() )
					)
					){
					
							this.close(event);

							this.dropdown.commitSelectedIndex(0);
 							this.selectedIndex = 0;
							this.dropdown.selectedIndex = 0;
							dispatchEvent(new ListEvent(ListEvent.CHANGE));
							this.dropdown.verticalScrollPosition = Math.max(0,this.selectedIndex-1);
							
							// reset the type ahead text to blank to prevent highlighting in the itemRenderer
							this.typeAheadText = '';
					

							
				} else if ( (this.autoCompleteSelectOnOne == true) && 
					(ListCollectionView(this.dataProvider).length == 1)){

						// if user selecting an item close the drop down
						this.close(event);
					
// display hasn't changed yet; so selectOnOne is causing issues because list apparently uses a 'visibleData' property
// which is containming more elements thant he dataProvider; try selecting by the item 
							this.dropdown.commitSelectedIndex(0);
 							this.selectedIndex = 0;
							this.dropdown.selectedIndex = 0;
//						this.selectedItem = this.dataProvider[0];
//						this.dropdown.selectedItem = this.dataProvider[0];
							dispatchEvent(new ListEvent(ListEvent.CHANGE));
//						this.autoCompleteTextInput.setSelection(0,0);
						this.setAutoCompleteCursorLocation();
						
//						this.dropdown.verticalScrollPosition = Math.max(0,this.selectedIndex-1);
						
							this.typeAheadText = '';

            	}
            } else if (event.charCode == Keyboard.ENTER){
//			
//			if drop down is open and keycode is Keyboard.ENTER; then select the first item in the list
				if(this.autoCompleteSelectOnEnter == true){
					// be sure that there is at least one item in the dataProvider before trying to select it
			 		if( (ListCollectionView(this.dataProvider).length >= 1) && 
			 			(
			 			((this.autoCompleteSelectOnEnterIfEmpty == false ) && (this.typeAheadText != '')) ||
			 			 (this.autoCompleteSelectOnEnterIfEmpty == true ) ||
						 // condition where user is using down arrows to traverse the list
						 // if they hit enter we still want to close 
						 ( (this.autoCompleteSelectOnEnterIfEmpty == false ) && (this.selectedIndex >-1) )
			 			)

			 			){
						
						// drop down wasn't closing in this case
						// manually resetting bInKeyDown and bInFocusHandller to false 
						// to force the drop down to close when called 
						this.bInKeyDown = false;
						this.bInFocusInHandler = false;
						// if user presses enter key close drop down 
		           		this.close(event);

						this.dropdown.commitSelectedIndex(0);
						this.selectedIndex = 0;
						this.dropdown.selectedIndex = 0;
						dispatchEvent(new ListEvent(ListEvent.CHANGE));
//						this.autoCompleteTextInput.setSelection(0,0);
						this.setAutoCompleteCursorLocation();

//						this.dropdown.verticalScrollPosition = Math.max(0,this.selectedIndex-1);
						this.typeAheadText = '';
			 			
			 		}
					
				} else {

				// if user presses enter key close drop down 
           		this.close(event);
					
				}
            }
				
		} 

    }

    /**
     *  @private
     */
    private function dropdown_changeHandler(e:ListEvent):void{
		// if auto complete enabled
		// when an item is selected change the value of the AutoCompleteTextInput box
		if(this.autoCompleteEnabled){
			this.autoCompleteTextInput.text = this.selectedLabel;
			this.typeAheadText = '';
//			trace('dropdown_changeHandler');
			// this solves the issue when autoCompleteSelectCursorLocation is set to put the cursor at the beginning of the line
			// but it wasn't if things were selected via mouse because this line resetting the cursor to the end. 
			this.setAutoCompleteCursorLocation();
//	        this.autoCompleteTextInput.setSelection(this.autoCompleteTextInput.text.length,this.autoCompleteTextInput.text.length);	

		}
		
    }

    /**
     * @private
     * if AutoComplete is enabled and we're in the onChange Event; we do some fancy footwork
     */
    private var _autoCompleteChangeEventOccuring : Boolean = false;

    /**
     *  @private
     *  created to try to prevent change from firing twice when an item from a filtered list is selected; 
     * selectedItem gets set, and then selectedIndex is changed 
     */
    private function onChange(e:ListEvent):void{

		if(this.autoCompleteEnabled){
			if(this._autoCompleteChangeEventOccuring == true){
				this._autoCompleteChangeEventOccuring = false;
				return;
			}
			// moved this code here from the close event 
			if(this.selectedIndex != -1){

				var refreshEvent : AutoCompleteCollectionEvent = new AutoCompleteCollectionEvent(AutoCompleteCollectionEvent.AUTOCOMPLETE_DATAPROVIDER_FILTER_BEGIN, null,false,true);
				dispatchEvent(refreshEvent);
				if(!refreshEvent.isDefaultPrevented()){
					// stop propogation so the other Change handlers don't fire yet 
					e.stopImmediatePropagation();

					
					// store the selected Item temporary
					var tempSelectedItem : Object = this.selectedItem;
						
					var dp : ListCollectionView = ListCollectionView(this.dataProvider);
					dp.filterFunction = null;
					dp.refresh();
						
						// now that the filter function was reset, we need to fix the selectedIndex 
	//				this approach had no affect on variables bound to selectedIndex; not sure why; had to force
	// 				a change event to fire for binding to change
					this.selectedItem = tempSelectedItem;

					this._autoCompleteChangeEventOccuring = true;
					dispatchEvent(e);
					dispatchEvent(new AutoCompleteCollectionEvent(AutoCompleteCollectionEvent.AUTOCOMPLETE_DATAPROVIDER_FILTERED, this.autoCompleteFilterFunction));
					}
				}


		}
		
    }
    
    /** 
    * @private
    * When the typeAheadTimer is released reset the type ahead text 
    */
    private function onTypeAheadReleaseTimerComplete(event: TimerEvent):void{
    	var releaseEvent : TypeAheadTimerEvent = new TypeAheadTimerEvent(this.typeAheadText, TypeAheadTimerEvent.TYPEAHEAD_RELEASETIMER_COMPLETE ); 
    	this.typeAheadText = '';
    	dispatchEvent(releaseEvent);
    }
    

			
} // end Class


} // end package