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
package com.flextras.calendar.defaultRenderers
{
	import com.flextras.calendar.Calendar;
	import com.flextras.calendar.CalendarChangeEvent;
	import com.flextras.calendar.CalendarDragEvent;
	import com.flextras.calendar.CalendarEvent;
	import com.flextras.calendar.CalendarMouseEvent;
	import com.flextras.calendar.ICalendarDataVO;
	import com.flextras.calendar.IDayDataVO;
	import com.flextras.calendar.IDayRenderer;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ListCollectionView;
	import mx.controls.Button;
	import mx.controls.List;
	import mx.controls.Text;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.listClasses.ListBase;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.DragEvent;
	import mx.events.ListEvent;
	
	use namespace mx_internal;


	// day event metadata for switching state events
	include "../inc/ExpandEventMetaData.as";

	// event metadata for Drag events 
	include "../inc/DragEventMetaData.as";

	// event metadata from the CalendarEvent and CalendarMoustEvent classes
	include "../inc/GenericEventMetaData.as";	

	/**
	 * This class is a default implementation of the IDayRenderer interface for use with the Flextras Calendar component.  It displays a list of the dataProvider data for this day, buttons to switch to the month, day, or week state, and the day number.
	 * 
	 * @author DotComIt / Flextras
	 * @see com.flextras.calendar.Calendar
	 * @see com.flextras.calendar.IDayRenderer
	 * 
	 */
	public class DayRenderer extends Container implements IDayRenderer
	{
		/**
		 *  Constructor.
		 */
		public function DayRenderer()
		{
			super();

			this.setStyle('borderStyle','solid');
			this.setStyle('paddingRight',1);
			this.setStyle('paddingLeft',1);
			this.setStyle('paddingTop',1);
			this.setStyle('paddingBottom',1);
			this.setStyle("backgroundColor","0xFFFFFF");
			
		}
		
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

	/**
	 * @private
	 */
	override protected function commitProperties():void{
		super.commitProperties();

		// if the dayData was null when createChildren ran, then the dayTextField and dataList were not created, so 
		// recreate them here if we can 
		if(this.dayData){
			createDayTextField();
			createDataList();
		}

		// if the dayData was null when createChildren ran, we may not have created the dataList yet
		// this code will cover that situation while still leaving 'dataProviderDirty' true 
		if((!this.dataList) || (!this.dayTextField)){
			return;
		}

		if(this.dayDataChanged == true){
			if(this.dayData.date.toString() != this.dayTextField.text){
				this.dayTextField.text = this.dayData.date.toString();
			}
			if(this.dataList.dataProvider != this.dayData.dataProvider ){
				this.dataList.dataProvider = this.dayData.dataProvider;
			}
			
			this.dayDataChanged = false;
			
		}
		
		// update all the edit related info in the dataList 
		if(this.calendarDataChanged == true){
			if(this.calendarData){
				
				if(this.dataList.allowMultipleSelection != this.calendarData.allowMultipleSelection ){
					this.dataList.allowMultipleSelection = this.calendarData.allowMultipleSelection;
				}
				if(this.dataList.dataTipField != this.calendarData.dataTipField ){
					this.dataList.dataTipField = this.calendarData.dataTipField;
				}
				if(this.dataList.dataTipFunction != this.calendarData.dataTipFunction ){
					this.dataList.dataTipFunction = this.calendarData.dataTipFunction;
				}
				if(this.dataList.doubleClickEnabled != this.calendarData.doubleClickEnabled ){
					this.dataList.doubleClickEnabled = this.calendarData.doubleClickEnabled;
				}
				if(this.dataList.dragEnabled != this.calendarData.dragEnabled ){
					this.dataList.dragEnabled = this.calendarData.dragEnabled;
				}
				if(this.dataList.dragMoveEnabled != this.calendarData.dragMoveEnabled ){
					this.dataList.dragMoveEnabled = this.calendarData.dragMoveEnabled;
				}
				if(this.dataList.dropEnabled != this.calendarData.dropEnabled ){
					this.dataList.dropEnabled = this.calendarData.dropEnabled;
				}

				if(this.dataList.hasOwnProperty('editable')){
					if(this.dataList['editable'] != this.calendarData.editable ){
						this.dataList['editable'] = this.calendarData.editable;
					}
				}
				if(this.dataList.hasOwnProperty('editorDataField')){
					if(this.dataList['editorDataField'] != this.calendarData.editorDataField ){
						this.dataList['editorDataField'] = this.calendarData.editorDataField;
					}
				}
				if(this.dataList.hasOwnProperty('editorHeightOffset')){
					if(this.dataList['editorHeightOffset'] != this.calendarData.editorHeightOffset ){
						this.dataList['editorHeightOffset'] = this.calendarData.editorHeightOffset;
					}
				}
				if(this.dataList.hasOwnProperty('editorUsesEnterKey')){
					if(this.dataList['editorUsesEnterKey'] != this.calendarData.editorUsesEnterKey ){
						this.dataList['editorUsesEnterKey'] = this.calendarData.editorUsesEnterKey;
					}
				}
				if(this.dataList.hasOwnProperty('editorWidthOffset')){
					if(this.dataList['editorWidthOffset'] != this.calendarData.editorWidthOffset ){
						this.dataList['editorWidthOffset'] = this.calendarData.editorWidthOffset;
					}
				}
				if(this.dataList.hasOwnProperty('editorXOffset')){
					if(this.dataList['editorXOffset'] != this.calendarData.editorXOffset ){
						this.dataList['editorXOffset'] = this.calendarData.editorXOffset;
					}
				}
				if(this.dataList.hasOwnProperty('editorYOffset')){
					if(this.dataList['editorYOffset'] != this.calendarData.editorYOffset ){
						this.dataList['editorYOffset'] = this.calendarData.editorYOffset;
					}
				}
				if(this.dataList.iconField != this.calendarData.iconField ){
					this.dataList.iconField = this.calendarData.iconField;
				}
				if(this.dataList.iconFunction != this.calendarData.iconFunction ){
					this.dataList.iconFunction = this.calendarData.iconFunction;
				}

				if(this.dataList.hasOwnProperty('imeMode')){
					if(this.dataList['imeMode'] != this.calendarData.imeMode ){
						this.dataList['imeMode'] = this.calendarData.imeMode;
					}
				}
				if(this.dataList.hasOwnProperty('itemEditor')){
					if(this.dataList['itemEditor'] != this.calendarData.itemEditor ){
						this.dataList['itemEditor'] = this.calendarData.itemEditor;
					}
				}
				if(this.dataList.itemRenderer != this.calendarData.itemRenderer ){
					this.dataList.itemRenderer = this.calendarData.itemRenderer;
				}
				if(this.dataList.labelField != this.calendarData.labelField ){
					this.dataList.labelField = this.calendarData.labelField;
				}
				if(this.dataList.labelFunction != this.calendarData.labelFunction ){
					this.dataList.labelFunction = this.calendarData.labelFunction;
				}
				if(this.dataList.nullItemRenderer != this.calendarData.nullItemRenderer ){
					this.dataList.nullItemRenderer = this.calendarData.nullItemRenderer;
				}
				if(this.dataList.offscreenExtraRowsOrColumns != this.calendarData.offscreenExtraRowsOrColumns ){
					this.dataList.offscreenExtraRowsOrColumns = this.calendarData.offscreenExtraRowsOrColumns;
				}
				if(this.dataList.hasOwnProperty('rendererIsEditor')){
					if(this.dataList['rendererIsEditor'] != this.calendarData.rendererIsEditor ){
						this.dataList['rendererIsEditor'] = this.calendarData.rendererIsEditor;
					}
				}
				if(this.dataList.selectable != this.calendarData.selectable ){
					this.dataList.selectable = this.calendarData.selectable;
				}
				if(this.dataList.showDataTips != this.calendarData.showDataTips ){
					this.dataList.showDataTips = this.calendarData.showDataTips;
				}
				if(this.dataList.wordWrap != this.calendarData.wordWrap ){
					this.dataList.wordWrap = this.calendarData.wordWrap;
				}
			}
			this.calendarDataChanged = false;
			
		}
		
		
	}

    /**
     *  @private
     */
	override protected function createChildren():void{
		super.createChildren();
		
		createDayTextField();
		createDataList();
		createExpandDayButton();
		createExpandMonthButton();
		createExpandWeekButton();

	}

	/**
	 * @private
	 */
	override protected function measure():void{
		super.measure();
		
		// if the dayData was null when createChildren ran, we may not have created the dataList yet
		// this code will cover that situation while still leaving 'dataProviderDirty' true 
		if((!this.dataList) || (!this.dayTextField) || (!this.expandDayButton) || (!this.expandMonthButton) || (!this.expandWeekButton)){
			return;
		}
		
		this.measuredHeight = this.dataList.measuredHeight + Math.max(this.dayTextField.measuredHeight,this.expandDayButton.measuredHeight,this.expandMonthButton.measuredHeight,this.expandWeekButton.measuredHeight) + (this.getStyle('borderThickness')*2)  + this.getStyle('paddingTop') + this.getStyle('paddingBottom');
		this.measuredWidth = Math.max(this.dataList.measuredWidth, this.dayTextField.measuredWidth + this.expandDayButton.measuredWidth + this.expandMonthButton.measuredWidth + this.expandWeekButton.measuredWidth ) + (this.getStyle('borderThickness')*2)  + this.getStyle('paddingLeft') + this.getStyle('paddingRight');  


	}

	/**
	 * @private
	 */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		// if the dayData was null when createChildren ran, we may not have created the dataList yet
		// this code will cover that situation while still leaving 'dataProviderDirty' true 
		if((!this.dataList) || (!this.dayTextField)){
			return;
		}
		
		if(this.dayTextField){
			var calculatedDayTextFieldWidth : int = unscaledWidth;
			if(this.expandDayButton){
				calculatedDayTextFieldWidth = calculatedDayTextFieldWidth -this.expandDayButton.measuredWidth
			}
			if(this.expandMonthButton){
				calculatedDayTextFieldWidth = calculatedDayTextFieldWidth -this.expandMonthButton.measuredWidth
			}
			if(this.expandWeekButton){
				calculatedDayTextFieldWidth = calculatedDayTextFieldWidth -this.expandWeekButton.measuredWidth
			}
			
/*			this.dayTextField.setActualSize(Math.min(this.dayTextField.measuredWidth,
				(unscaledWidth-this.expandDayButton.measuredWidth-this.expandMonthButton.measuredWidth-this.expandWeekButton.measuredWidth)),
				this.dayTextField.measuredHeight);*/
			this.dayTextField.setActualSize(Math.min(this.dayTextField.measuredWidth,calculatedDayTextFieldWidth),
											this.dayTextField.measuredHeight);
			
			this.dayTextField.x = 0  + this.getStyle('paddingLeft'); 
			this.dayTextField.y = 0  + this.getStyle('paddingTop'); 
			
		}
		if(this.expandDayButton){
			this.expandDayButton.setActualSize(this.expandDayButton.measuredWidth ,this.expandDayButton.measuredHeight);
			this.expandDayButton.x = unscaledWidth - this.expandDayButton.width - this.getStyle('paddingRight') - (this.getStyle('borderThickness')*2);
			this.expandDayButton.y = 0 + this.getStyle('paddingTop');
		}
		if(this.expandWeekButton){
			this.expandWeekButton.setActualSize(this.expandWeekButton.measuredWidth ,this.expandWeekButton.measuredHeight);
			
			var expandWeekButtonXOffset : int = this.expandWeekButton.width;
			if(this.expandDayButton){
				expandWeekButtonXOffset = expandWeekButtonXOffset + this.expandDayButton.width;
			}
			
			
			//			this.expandWeekButton.x = unscaledWidth - this.expandWeekButton.width - this.expandDayButton.width - this.getStyle('paddingRight') - (this.getStyle('borderThickness')*2);
			this.expandWeekButton.x = unscaledWidth - expandWeekButtonXOffset - this.getStyle('paddingRight') - (this.getStyle('borderThickness')*2);
			this.expandWeekButton.y = 0 + this.getStyle('paddingTop');
		}
		if(this.expandMonthButton){
			this.expandMonthButton.setActualSize(this.expandMonthButton.measuredWidth ,this.expandMonthButton.measuredHeight);

			var expandMonthButtonXOffset : int = this.expandMonthButton.width;
			if(this.expandWeekButton){
				expandMonthButtonXOffset = expandMonthButtonXOffset + this.expandWeekButton.width;
			}
			if(this.expandDayButton){
				expandMonthButtonXOffset = expandMonthButtonXOffset + this.expandDayButton.width;
			}
			
//			this.expandMonthButton.x = unscaledWidth - this.expandMonthButton.width - this.expandWeekButton.width - this.expandDayButton.width - this.getStyle('paddingRight') - (this.getStyle('borderThickness')*2);
			this.expandMonthButton.x = unscaledWidth - expandMonthButtonXOffset - this.getStyle('paddingRight') - (this.getStyle('borderThickness')*2);
			this.expandMonthButton.y = 0 + this.getStyle('paddingTop');
		}

		if(this.dataList){
			var calculatedDataListHeightOffset : int = 0;
			if(this.expandDayButton){
				calculatedDataListHeightOffset = Math.max(calculatedDataListHeightOffset, this.expandDayButton.height)
			}
			if(this.expandMonthButton){
				calculatedDataListHeightOffset = Math.max(calculatedDataListHeightOffset, this.expandMonthButton.height)
			}
			if(this.expandWeekButton){
				calculatedDataListHeightOffset = Math.max(calculatedDataListHeightOffset, this.expandWeekButton.height)
			}
			if(this.dayTextField){
				calculatedDataListHeightOffset = Math.max(calculatedDataListHeightOffset, this.dayTextField.height)
			}
			
			// the minus 2 is just some arbitrary padding 
/*			this.dataList.setActualSize(unscaledWidth - (this.getStyle('borderThickness')*2) - this.getStyle('paddingLeft') - this.getStyle('paddingRight'), 
														unscaledHeight - Math.max(this.dayTextField.height, this.expandDayButton.height) - (this.getStyle('borderThickness')*2) - this.getStyle('paddingTop') - this.getStyle('paddingBottom') -2);
*/
			this.dataList.setActualSize(unscaledWidth - (this.getStyle('borderThickness')*2) - this.getStyle('paddingLeft') - this.getStyle('paddingRight'), 
				unscaledHeight - calculatedDataListHeightOffset - (this.getStyle('borderThickness')*2) - this.getStyle('paddingTop') - this.getStyle('paddingBottom') -2);
			
			this.dataList.x = 0 + this.getStyle('paddingLeft');
			// the extra 2 is just some arbitrary spacing 
//			this.dataList.y = Math.max(this.dayTextField.height,this.expandDayButton.height, this.expandWeekButton.height, this.expandMonthButton.height) + this.getStyle('paddingTop') + 2;
			this.dataList.y = calculatedDataListHeightOffset + this.getStyle('paddingTop') + 2;
			
		}
	}

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
	// the list based component that will display all of the component's day items
	/**
	 * This variable contains the list based component that will display everything in the dataProvider for this day.
	 */
	protected var dataList : ListBase;

	// the day Number text field component
	/**
	 * This variable contains the text filed that will display the number of today’s date.  
	 */
	protected var dayTextField : Text;

	// the day Number text field component
	/**
	 * This is a reference to the button that can be used to move to the day state.	
	 */
	protected var expandDayButton : UIComponent;

	/**
	 * This is a reference to the button that can be used to move to the month state.	
	 */
	protected var expandMonthButton : UIComponent;

	/**
	 * This is a reference to the button that can be used to move to the week state.	
	 */
	protected var expandWeekButton : UIComponent;


    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

	
	//----------------------------------
	//  calendarData
	//----------------------------------
	/**
	 * @private
	 * private storage for the calendarData object
	 */
	private var _calendarData : ICalendarDataVO;
	/**
	 * @private
	 * Flag that lets us know that the calendarData object has changed or not
	 */
	private var calendarDataChanged : Boolean = false;
	/**
	 * @inheritDoc 
	 */
	public function get calendarData() : ICalendarDataVO{
		return this._calendarData;
	}
	
	/**
	 * @private 
	 */
	public function set calendarData(value:ICalendarDataVO):void{
		this._calendarData = value;
		this.calendarDataChanged = true;
		this.invalidateProperties();
	}
	
    //----------------------------------
    //  dayData
    //----------------------------------
	/**
	 * @private
	 * private storage for the dayData object
	 */
	private var _dayData : IDayDataVO;
	/**
	 * @private
	 * private variable that checks when the dayDataChanged
	 */
	private var dayDataChanged : Boolean = false;

	/**
	 * @inheritDoc 
	 */
	public function get dayData():IDayDataVO{
		return this._dayData;
	}

	/**
	 * @private
	 */
	public function set dayData(value:IDayDataVO):void{
		this._dayData = value;
		this.dayDataChanged = true;
		this.invalidateProperties();
		this.invalidateSize();
		this.invalidateDisplayList();
	}
	
	/**
	 * @inheritDoc 
	 */
	public function get selectedItems():Array{
		return this.dataList.selectedItems
	}

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

	/**
	 * This is a helper function that creates the text field that will display the day number.  
	 */
	protected function createDayTextField():void{
		
		if((!this.dayTextField) && (this.dayData)){
			this.dayTextField = new Text();
			this.dayTextField.text = this.dayData.date.toString();
			this.addChild(this.dayTextField);
		}
	}
	
	/**
	 * This is a helper function for the creating the list based class that will display all the elements of this day's dataProvider.
	 */
	protected function createDataList():void{
		
		if((!this.dataList) && (this.dayData)){
			this.dataList = new List();
			if(this.calendarData){
				this.dataList.allowMultipleSelection = this.calendarData.allowMultipleSelection;
				this.dataList.dataTipField = this.calendarData.dataTipField;
				this.dataList.dataTipFunction = this.calendarData.dataTipFunction;
				this.dataList.doubleClickEnabled = this.calendarData.doubleClickEnabled;
				this.dataList.dragEnabled = this.calendarData.dragEnabled;
				this.dataList.dragMoveEnabled = this.calendarData.dragMoveEnabled;
				this.dataList.dropEnabled = this.calendarData.dropEnabled;
				if(this.dataList.hasOwnProperty('editable')){
					this.dataList['editable'] = this.calendarData.editable;
				}
				if(this.dataList.hasOwnProperty('editorDataField')){
					this.dataList['editorDataField'] = this.calendarData.editorDataField;
				}
				if(this.dataList.hasOwnProperty('editorHeightOffset')){
					this.dataList['editorHeightOffset'] = this.calendarData.editorHeightOffset;
				}


				if(this.dataList.hasOwnProperty('editorUsesEnterKey')){
					this.dataList['editorUsesEnterKey'] = this.calendarData.editorUsesEnterKey;
				}
				if(this.dataList.hasOwnProperty('editorWidthOffset')){
					this.dataList['editorWidthOffset'] = this.calendarData.editorWidthOffset;
				}
				if(this.dataList.hasOwnProperty('editorXOffset')){
					this.dataList['editorXOffset'] = this.calendarData.editorXOffset;
				}
				if(this.dataList.hasOwnProperty('editorYOffset')){
					this.dataList['editorXOffset'] = this.calendarData.editorXOffset;
				}
				if(this.dataList.hasOwnProperty('iconField')){
					this.dataList['iconField'] = this.calendarData.iconField;
				}

				if(this.dataList.hasOwnProperty('iconFunction')){
					this.dataList['iconFunction'] = this.calendarData.iconFunction;
				}

				if(this.dataList.hasOwnProperty('imeMode')){
					this.dataList['imeMode'] = this.calendarData.imeMode;
				}
				if(this.dataList.hasOwnProperty('itemEditor')){
					this.dataList['itemEditor'] = this.calendarData.itemEditor;
				}
				this.dataList.itemRenderer = this.calendarData.itemRenderer;
				if(this.dataList.hasOwnProperty('labelField')){
					this.dataList['labelField'] = this.calendarData.labelField;
				}

				if(this.dataList.hasOwnProperty('labelFunction')){
					this.dataList['labelFunction'] = this.calendarData.labelFunction;
				}
				if(this.dataList.hasOwnProperty('nullItemRenderer')){
					this.dataList['nullItemRenderer'] = this.calendarData.nullItemRenderer;
				}
				if(this.dataList.hasOwnProperty('offscreenExtraRowsOrColumns')){
					this.dataList['offscreenExtraRowsOrColumns'] = this.calendarData.offscreenExtraRowsOrColumns;
				}
				if(this.dataList.hasOwnProperty('rendererIsEditor')){
					this.dataList['rendererIsEditor'] = this.calendarData.rendererIsEditor;
				}
				if(this.dataList.hasOwnProperty('selectable')){
					this.dataList['selectable'] = this.calendarData.selectable;
				}
				if(this.dataList.hasOwnProperty('showDataTips')){
					this.dataList['showDataTips'] = this.calendarData.showDataTips;
				}

				if(this.dataList.hasOwnProperty('wordWrap')){
					this.dataList['wordWrap'] = this.calendarData.wordWrap;
				}
			}
			this.dataList.dataProvider = this.dayData.dataProvider;
			this.dataList.addEventListener(ListEvent.CHANGE,onListEvent);
			this.dataList.addEventListener(ListEvent.ITEM_CLICK,onListEvent);
			this.dataList.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,onListEvent);
			this.dataList.addEventListener(ListEvent.ITEM_EDIT_BEGIN,onListEvent);
			this.dataList.addEventListener(ListEvent.ITEM_EDIT_BEGINNING,onListEvent);
			this.dataList.addEventListener(ListEvent.ITEM_EDIT_END,onListEvent);
			this.dataList.addEventListener(ListEvent.ITEM_FOCUS_IN,onListEvent);
			this.dataList.addEventListener(ListEvent.ITEM_FOCUS_OUT,onListEvent);
			this.dataList.addEventListener(ListEvent.ITEM_ROLL_OUT,onListEvent);
			this.dataList.addEventListener(ListEvent.ITEM_ROLL_OVER,onListEvent);
			this.dataList.addEventListener(MouseEvent.CLICK,onMouseClick);
			this.dataList.addEventListener(DragEvent.DRAG_COMPLETE,onDragEvent);
			this.dataList.addEventListener(DragEvent.DRAG_DROP,onDragEvent);
			this.dataList.addEventListener(DragEvent.DRAG_ENTER,onDragEvent);
			this.dataList.addEventListener(DragEvent.DRAG_EXIT,onDragEvent);
			this.dataList.addEventListener(DragEvent.DRAG_OVER,onDragEvent);
			this.dataList.addEventListener(DragEvent.DRAG_START,onDragEvent);

			this.addChild(this.dataList);
		}
	}

	/**
	 * This is a helper function for the creating the expand day button.
	 */
	protected  function createExpandDayButton()	:void{
		if((!this.expandDayButton)){
			this.expandDayButton = new Button();
			(this.expandDayButton as Button).label = "D";
			this.expandDayButton.addEventListener(MouseEvent.CLICK,onExpandDayButtonClick);
			this.addChild(this.expandDayButton);
		}		
	}

	/**
	 * This is a helper function for the creating the expand month button.
	 */
	protected  function createExpandMonthButton()	:void{
		if((!this.expandMonthButton)){
			this.expandMonthButton = new Button();
			(this.expandMonthButton as Button).label = "M";
			this.expandMonthButton.addEventListener(MouseEvent.CLICK,onExpandMonthButtonClick);
			this.addChild(this.expandMonthButton);
		}		
	}

	/**
	 * This is a helper function for the creating the expand week button.
	 */
	protected function createExpandWeekButton()	:void{
		if((!this.expandWeekButton)){
			this.expandWeekButton = new Button();
			(this.expandWeekButton as Button).label = "W";
			this.expandWeekButton.addEventListener(MouseEvent.CLICK,onExpandWeekButtonClick);
			this.addChild(this.expandWeekButton);
		}		
	}

	/**
	 * @inheritDoc 
	 */
	 public function deselectItems():void{
		this.dataList.selectedIndex = -1;
	}

	/**
	 * @inheritDoc 
	 */
	public function invalidateCalendarData():void{
		this.calendarDataChanged = true;
		this.invalidateProperties();
		this.invalidateSize();
		this.invalidateDisplayList();
	}

	/**
	 * @inheritDoc 
	 */
	public function invalidateDayData():void{
		this.dayDataChanged = true;
		this.invalidateProperties();
		this.invalidateSize();
		this.invalidateDisplayList();
	}


	/**
	 * @inheritDoc 
	 */
	public function selectItems(direction : int = 0, item : Object = null):void{

		if(this.calendarData.allowMultipleSelection == false){
			this.dataList.selectedItem = item;
			return;
		}

		var newSelectionArray : Array = new Array(0);
		var dp : ListCollectionView = this.dayData.dataProvider as ListCollectionView;

		var startIndex : int = 0;
		var endIndex : int = dp.length-1;
		
		if(direction == -1){
			endIndex = this.dataList.itemRendererToIndex(this.dataList.itemToItemRenderer(item));
		} else if(direction == 1){
			startIndex = this.dataList.itemRendererToIndex(this.dataList.itemToItemRenderer(item));
		}
		
		for(var index : int = startIndex; index<=endIndex; index++){
			newSelectionArray.unshift(dp.getItemAt(index) );
		}

		this.dataList.selectedItems = newSelectionArray;
 	}

    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------



	// this is a generic event handler for all the drag events on the list class
	// it just creates the CalendarDragEvent wrapper to the DragEvent and dispatches
	/**
	 * This is a default handler for the list based drag events dispatched by the dataList object.    
	 * It converts the DragEvents into CalendarDragEvents and redispatches them.
	 * 
	 * @see com.flextras.calendar.CalendarDragEvent
	 * 
	 */
	protected function onDragEvent(e:DragEvent):void{
		// find out the new event type
		var newType : String = '';
		switch (e.type){
			case (DragEvent.DRAG_COMPLETE): {
				newType = CalendarDragEvent.DRAG_COMPLETE_DAY;
				break;
			}
			case (DragEvent.DRAG_DROP): {
				newType = CalendarDragEvent.DRAG_DROP_DAY;
				break;
			}
			case (DragEvent.DRAG_ENTER): {
				newType = CalendarDragEvent.DRAG_ENTER_DAY;
				break;
			}
			case (DragEvent.DRAG_EXIT): {
				newType = CalendarDragEvent.DRAG_EXIT_DAY;
				break;
			}
			case (DragEvent.DRAG_OVER): {
				newType = CalendarDragEvent.DRAG_OVER_DAY;
				break;
			}
			case (DragEvent.DRAG_START): {
				newType = CalendarDragEvent.DRAG_START_DAY;
				break;
			}
		}

		var calendarDragEvent : CalendarDragEvent = new CalendarDragEvent(newType,
												e.bubbles,e.cancelable,e.dragInitiator,e.dragSource,e.action,e.ctrlKey,e.altKey,e.shiftKey, e, this.dataList, this );
		this.dispatchEvent(calendarDragEvent);
		if(calendarDragEvent.isDefaultPrevented()){
			e.preventDefault();
		}
	}


	// this is a generic event handler for all the edit events on the list class
	// it just creates the CalendarEvent wrapper tothe ListEvent and dispatches
	/**
	 * This is a default handler for the list based events dispatched by the dataList object.    
	 * It converts the ListEvents into CalendarEvents and redispatches them.
	 * 
	 * @see com.flextras.calendar.CalendarDragEvent
	 */
	protected function onListEvent(e:ListEvent):void{
		var calendarEvent : CalendarEvent = new CalendarEvent(e.type,
												e.bubbles,e.cancelable,e.columnIndex,e.rowIndex,e.reason,e.itemRenderer, this.dataList, e, this );
		this.dispatchEvent(calendarEvent);
		if(calendarEvent.isDefaultPrevented()){
			e.preventDefault();
		}
		
	}

	/**
	 * This is the default handler for the expand day button’s click event.  It dispatches the CalendarChangeEvent.EXPAND_DAY event.  
	 * 
	 * @see com.flextras.calendar.CalendarChangeEvent#EXPAND_DAY
	 * @see #expandDayButton
	 */
	protected function onExpandDayButtonClick(e:MouseEvent):void{
		this.dispatchEvent(new CalendarChangeEvent(CalendarChangeEvent.EXPAND_DAY,false,false,this));
	}

	/**
	 * This is the default handler for the expand month button’s click event.  It dispatches the CalendarChangeEvent.EXPAND_MONTH event.  
	 * 
	 * @see com.flextras.calendar.CalendarChangeEvent#EXPAND_MONTH
	 * @see #expandMonthButton
	 */
	protected function onExpandMonthButtonClick(e:MouseEvent):void{
		this.dispatchEvent(new CalendarChangeEvent(CalendarChangeEvent.EXPAND_MONTH,false,false,this));
	}

	/**
	 * This is the default handler for the expand week button’s click event.  It dispatches the CalendarChangeEvent.EXPAND_WEEK event.  
	 * 
	 * @see com.flextras.calendar.CalendarChangeEvent#EXPAND_WEEK
	 * @see #expandWeekButton
	 */
	protected function onExpandWeekButtonClick(e:MouseEvent):void{
		this.dispatchEvent(new CalendarChangeEvent(CalendarChangeEvent.EXPAND_WEEK,false,false,this));
	}

	/**
	 * This is a default handler for the mouse click events dispatched by the dataList object.    
	 * It converts the MouseEvents into CalendarEvents and redispatches them.
	 * 
	 * @see com.flextras.calendar.CalendarMouseEvent
	 */
	protected function onMouseClick(e:MouseEvent):void{
		// find renderer and put it in the event 
		var itemRenderer:IListItemRenderer = this.dataList.mx_internal::mouseEventToItemRendererOrEditor(e);
		var calendarMouseEvent : CalendarMouseEvent = new CalendarMouseEvent(CalendarMouseEvent.CLICK_DAY, e.bubbles, e.cancelable,e.localX, e.localY, 
															e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta, this.dataList,e, itemRenderer, this)
		this.dispatchEvent(calendarMouseEvent);

	}
		
	}
}