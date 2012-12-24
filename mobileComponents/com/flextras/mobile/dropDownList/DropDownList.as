package com.flextras.mobile.dropDownList
{
	import com.flextras.mobile.dropDownList.skins.DropDownListMobileSkin_Default;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.ClassFactory;
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.core.InteractionMode;
	import mx.core.mx_internal;
	import mx.styles.CSSStyleDeclaration;
	
	import spark.components.Button;
	import spark.components.DropDownList;
	import spark.components.Label;
	import spark.components.LabelItemRenderer;
	import spark.components.supportClasses.TextBase;
	import spark.events.RendererExistenceEvent;

	use namespace mx_internal;
	

	/**
	 * @copy com.flextras.mobile.dropDownList.skins.DropDownListMobileSkin_PopUp#style:popUpHeight
	 */
	[Style(name="popUpHeight", type="Number", format="int")]	
	
	/**
	 * @copy com.flextras.mobile.dropDownList.skins.DropDownListMobileSkin_PopUp#style:popUpWidth
	 */
	[Style(name="popUpWidth", type="Number", format="int")]	
	
	//	When the drop down is open with an item selected, the component class will scroll the drop down so that the selected item 
	// is at the top of the view.  If the last item in the dataProvider is selected, by default, only one item 
	// is shown on screen.  This style is used in the component class to modify the scroll value in these 
	// situations, so that more than one item is shown.
	/**
	 * @copy com.flextras.mobile.autoCompleteComboBox.AutoCompleteComboBoxMobile#style:requestedRowCount
	 * 
	 *  @default 4
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.6
	 *  @productversion Flex 4.5
	 */
	[Style(name="requestedRowCount", type="Number", format="int")]	
	
	/**
	 * The Flextras Mobile DropDownList is a native Spark Flex component built to provide ComboBox functionality in your mobile Flex Applications.
	 * 
	 * @author www.flextras.com
	 * 
	 * @see spark.flextras.autoCompleteComboBox.AutoCompleteComboBoxLite 
	 * @see spark.components.ComboBox 
	 * @see com.flextras.mobile.dropDownList.skins.DropDownListMobileSkin_Default
	 * @see com.flextras.mobile.dropDownList.skins.DropDownListMobileSkin_PopUp
	 * @see com.flextras.mobile.dropDownList.skins.DropDownListMobileSkin_PopUp_2
	 */
	public class DropDownList extends spark.components.DropDownList
	{

		/**
		 * Constructor. 
		 */
		public function DropDownList()
		{
			super();
			itemRenderer = new ClassFactory(spark.components.LabelItemRenderer);

		}
		
		// use the default method to set styles 
		// using this approach here http://help.adobe.com/en_US/flex/using/WS2db454920e96a9e51e63e3d11c0bf687e7-7ff6.html
		// Define a static variable.
		private static var classConstructed:Boolean = classConstruct();
		
		// Define a static method.
		private static function classConstruct():Boolean {
			if (!FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("com.flextras.mobile.dropDownList.DropDownList"))
			{
				// If there is no CSS definition for this component, then create one define the default style values
				// the ones not defined here are just inherited 

				var myStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
				myStyle.setStyle("interactionMode", InteractionMode.TOUCH);
				myStyle.setStyle("borderVisible", true);
				myStyle.setStyle('skinClass',com.flextras.mobile.dropDownList.skins.DropDownListMobileSkin_Default);
				// used for the drop down in the mobile skin 
				myStyle.setStyle('requestedRowCount',4);
				
				FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration("com.flextras.mobile.dropDownList.DropDownList", myStyle, true);
				
			}
			
			return true;
		}			

		//--------------------------------------------------------------------------
		//
		//  Skin parts
		//
		//--------------------------------------------------------------------------    		
		//----------------------------------
		// closeButton
		//----------------------------------
		[SkinPart(required="no")]
		/**
		 * This is a close button that shows up in the pop up as part of the DropDownListMobileSkin_PopUp_2 mobile skin.
		 * You can specify the button's text using the closeButtonLabel property.	
		 * 
		 * @see com.flextras.mobile.dropDownList.skins.DropDownListMobileSkin_PopUp_2
		 * @see #closeButtonLabel
		 */
		public var closeButton : Button;
		
		
		//----------------------------------
		// headerLabelDisplay
		//----------------------------------
		[SkinPart(required="no")]
		/**
		 * This skin part refers to a label used to display a header in the pop up list.  
		 * It is implemented as part of the DropDownListMobileSkin_PopUp_2 mobile skin, or you can specify the header’s text using the label 
		 * property.
		 * 
		 * @see com.flextras.mobile.dropDownList.skins.DropDownListMobileSkin_PopUp_2
		 * @see #label
		 */
		public var headerLabelDisplay : TextBase;
		
		//--------------------------------------------------------------------------
		//
		//  Lifecycle Methods
		//
		//--------------------------------------------------------------------------    		
		
		/**
		 *  @private
		 */
		override protected function commitProperties():void{
			super.commitProperties();
			
			// if the label has changed; then update the labelDisplay
			if(this.labelChanged == true){
				if(this.headerLabelDisplay){
					this.headerLabelDisplay.text = this.label;
				}
				
				this.labelChanged = false;
			}
			
			// if the close button label changed; update the label on the close button
			if(this.closeButtonLabelChanged == true){
				if(this.closeButton){
					this.closeButton.label = this.closeButtonLabel;
				}
				this.closeButtonLabelChanged = false;
			}
		}
		
		/**
		 *  @private
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == dataGroup)
			{
				// Similar methods were added in super; but these are private methods and we want to 
				// do our own thing here 
				dataGroup.addEventListener(RendererExistenceEvent.RENDERER_ADD, dataGroup_rendererAddHandler_Extended);
				dataGroup.addEventListener(RendererExistenceEvent.RENDERER_REMOVE, dataGroup_rendererRemoveHandler_Extended);
				
			} else if (instance == closeButton){
				this.closeButton.addEventListener(MouseEvent.CLICK,onCloseButtonClick);
				this.closeButton.label = this.closeButtonLabel
			} else if (instance == headerLabelDisplay){
				this.headerLabelDisplay.text = this.label;
			}
			
		}
		
		/**
		 *  @private
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if (instance == dataGroup)
			{
				// similar methods were removed in Super; but we want to do our own thing here
				dataGroup.removeEventListener(RendererExistenceEvent.RENDERER_ADD, dataGroup_rendererAddHandler_Extended);
				dataGroup.removeEventListener(RendererExistenceEvent.RENDERER_REMOVE, dataGroup_rendererRemoveHandler_Extended);
			} else if (instance == closeButton){
				this.closeButton.removeEventListener(MouseEvent.CLICK,onCloseButtonClick);
			}
			
			super.partRemoved(partName, instance);
		}		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------    		
		
		//----------------------------------
		// closeButtonLabel
		//----------------------------------
		private var _closeButtonLabel : String = 'Cancel';
		/**
		 * @private 
		 */
		protected var closeButtonLabelChanged : Boolean = false;

		[Bindable(event="closeButtonLabelChange")]
		[Inspectable(category="Mobile DropDownList", defaultValue="Cancel",format="String",name="Close Button Label",type="String")]
		/**
		 * This property specifies the label to be displayed on the closeButton skin part.
		 * 
		 * @see #closeButton
		 */
		public function get closeButtonLabel():String
		{
			return _closeButtonLabel;
		}

		/**
		 * @private 
		 */
		public function set closeButtonLabel(value:String):void
		{
			if( _closeButtonLabel !== value)
			{
				_closeButtonLabel = value;
				dispatchEvent(new Event("closeButtonLabelChange"));
				closeButtonLabelChanged = true;
				this.invalidateProperties();
			}
		}

		
		//----------------------------------
		// label
		//----------------------------------
		private var _label : String;
		/**
		 * @private 
		 */
		protected  var labelChanged : Boolean = false;

		[Inspectable(category="Mobile DropDownList", defaultValue="",format="String",name="Header Text",type="String")]
		[Bindable(event="labelChange")]
		/**
		 * This property specifies the label to be displayed as part of the header label display skin part.
		 */
		public function get label():String
		{
			return _label;
		}

		/**
		 * @private 
		 */
		public function set label(value:String):void
		{
			if( _label !== value)
			{
				_label = value;
				dispatchEvent(new Event("labelChange"));
				labelChanged = true;
				this.invalidateProperties();
			}
		}

		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------    		
		/**
		 *  @private
		 *  Called when an item has been added to this component.
		 * this method is similar to the private dataGroup_RendererAddHandler; but adds a listener for 
		 * our click handler instead of the mouse down event
		 * In mobile the mouse down handler was causing all sorts of issues
		 */
		protected function dataGroup_rendererAddHandler_Extended(event:RendererExistenceEvent):void
		{
			var index:int = event.index;
			var renderer:IVisualElement = event.renderer;
			
			if (!renderer)
				return;
			
			renderer.addEventListener(MouseEvent.CLICK, item_clickHandler);
		}
		
		/**
		 *  @private
		 *  Called when an item has been removed from this component.
		 * This method is similar to the private dataGroup_RendererRemoveHandler in our parent; but removes
		 * our click handler instead of the mouse down handler.
		 * In mobile the mouse down handler was causing all sorts of issues
		 */
		protected function dataGroup_rendererRemoveHandler_Extended(event:RendererExistenceEvent):void
		{
			var index:int = event.index;
			var renderer:Object = event.renderer;
			
			if (!renderer)
				return;
			
			renderer.removeEventListener(MouseEvent.CLICK, item_clickHandler);
		}
		
		/**
		 * @private
		 * This is our replacement for the mouseDown and mouseUp handlers
		 * Mobile works a lot better w/ click events than it does w/ mouse down / mouse up events
		 */
		protected function item_clickHandler(event:MouseEvent):void{
			// this is a replacement for the mouse down handler;
			// so we do actualy want to run the mouse down handler code in this mouse click event
			super.item_mouseDownHandler(event);
			
			// immediately call the mouse up handler; because it seems to be holding off selection until the 
			// mouse up event fires; which doesn't appear to happen 
			super.mouseUpHandler(event);
		}
		
		/**
		 * @private 
		 */
		override protected function item_mouseDownHandler(event:MouseEvent):void
		{
			// do nothing because mouse up and mouse down handlers don't work quite right on mobile devices 
			// rewrote all of this to use the click event 
		}			

		
		
		/**
		 * @private  
		 * This method will switch to normal; effectively hiding the drop down.  
		 */
		protected function onCloseButtonClick(event:MouseEvent):void{
			closeDropDown(false);
		}
		
		/**
		 *  @private 
		 * If you select the last item in the list; close the drop down and re open it only a single 
		 * item was being displayed, startig w/ selected item; we want to be sure to display all of 'em.
		 * We do this by overriding this method and modding the index to position in the view.  
		 */ 
		override mx_internal function positionIndexInView(index:int, topOffset:Number = NaN, 
														  bottomOffset:Number = NaN, 
														  leftOffset:Number = NaN,
														  rightOffset:Number = NaN):void
		{
			var requestedRowCount : int = this.getStyle('requestedRowCount');
			// added check for dataProvider not being null 
			if((this.dataProvider) && (index >= this.dataProvider.length-requestedRowCount)){
				// if the index is one of the last four items in the list 
				// then w make sure not to scroll to the last item in the list
				// that 'four' number shouldn't be hard coded
				index = this.dataProvider.length-requestedRowCount;
			}
			
			super.positionIndexInView(index, topOffset, bottomOffset, leftOffset, rightOffset);
			
		}		
		
	}
}