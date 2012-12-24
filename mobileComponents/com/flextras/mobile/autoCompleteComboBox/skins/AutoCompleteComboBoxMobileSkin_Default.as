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
package com.flextras.mobile.autoCompleteComboBox.skins
{
	import com.flextras.mobile.autoCompleteComboBox.AutoCompleteComboBoxMobile;
	
	import flash.display.DisplayObject;
	
	import mx.core.FlexGlobals;
	import mx.styles.CSSStyleDeclaration;
	
	import spark.components.Button;
	import spark.components.ComboBox;
	import spark.components.DataGroup;
	import spark.components.Group;
	import spark.components.IItemRenderer;
	import spark.components.PopUpAnchor;
	import spark.components.PopUpPosition;
	import spark.components.Scroller;
	import spark.components.TextInput;
	import spark.flextras.autoCompleteComboBox.AutoCompleteCollectionEvent;
	import spark.layouts.VerticalLayout;
	import spark.skins.mobile.ButtonSkin;
	import spark.skins.mobile.TextInputSkin;
	import spark.skins.mobile.supportClasses.MobileSkin;
	
	/**
	 * @copy com.flextras.mobile.autoCompleteComboBox.AutoCompleteComboBoxMobile#stylerequestedRowCount
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
	 * This is the default skin for the Flextras Mobile AutoComplete Component.
	 * 
	 * @author www.flextras.com
	 * 
	 * @see com.flextras.autoCompleteComboBox.AutoCompleteComboBoxMobile
	 */
	public class AutoCompleteComboBoxMobileSkin_Default extends MobileSkin
	{
		public function AutoCompleteComboBoxMobileSkin_Default()
		{
			super();
		}
		
		// use the default method to set styles 
		// using this approach here http://help.adobe.com/en_US/flex/using/WS2db454920e96a9e51e63e3d11c0bf687e7-7ff6.html
		// Define a static variable.
		private static var classConstructed:Boolean = classConstruct();
		
		// Define a static method.
		private static function classConstruct():Boolean {
			if (!FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("com.flextras.mobile.autoCompleteComboBox.skins.AutoCompleteComboBoxMobileSkin_Default"))
			{
				// If there is no CSS definition for this component, then create one define the default style values
				// the ones not defined here are just inherited 
				var myStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
				myStyle.setStyle('requestedRowCount',4);
				
				FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration("com.flextras.mobile.autoCompleteComboBox.skins.AutoCompleteComboBoxMobileSkin_Default", myStyle, true);
				
			}
			
			return true;
		}			
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		//----------------
		//  hostComponent
		//----------------
		/**
		 * @private 
		 */
		private var _hostComponent:AutoCompleteComboBoxMobile;
		/**
		 * @copy spark.skins.spark.ApplicationSkin#hostComponent
		 */
		public function get hostComponent():AutoCompleteComboBoxMobile
		{
			return _hostComponent;
		}
		
		/**
		 * @private
		 */
		public function set hostComponent(value:AutoCompleteComboBoxMobile):void
		{
			if(_hostComponent){
				_hostComponent.removeEventListener(AutoCompleteCollectionEvent.AUTOCOMPLETE_DATAPROVIDER_FILTERED,onAutoCompleteFilter);
			}
			_hostComponent = value;
			_hostComponent.addEventListener(AutoCompleteCollectionEvent.AUTOCOMPLETE_DATAPROVIDER_FILTERED,onAutoCompleteFilter);
		}

		//----------------
		//  openButtonSkin
		//----------------
		/**
		 * This contains a reference to the skin for the down arrow button as part of the component.  
		 * We provide four different default options.
		 * 
		 * @see com.flextras.mobile.autoCompleteComboBox.skins.DownArrowButtonSkin_Default
		 * @see com.flextras.mobile.autoCompleteComboBox.skins.DownArrowButtonSkin_1
		 * @see com.flextras.mobile.autoCompleteComboBox.skins.DownArrowButtonSkin_2
		 * @see com.flextras.mobile.autoCompleteComboBox.skins.DownArrowButtonSkin_3
		 * @see com.flextras.mobile.autoCompleteComboBox.skins.DownArrowButtonSkin_4
		 */
		protected var openButtonSkin : Class = com.flextras.mobile.autoCompleteComboBox.skins.DownArrowSkin_Default;
		
		/**
		 * @private  
		 * A variable to tell when the padding changes, or not.
		 */
		protected var paddingChanged:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//--------------------------------------------------------------------------
		// need to implement the drop down 
		// it starts w/ a popUpAnchor and has a bunch of embedded components; I'm not sure if any are actually 
		// a skin parts.
		/**
		 * This is the PopUpAnchor used to position the drop down.   
		 */
		public var popUp : PopUpAnchor;
		/**
		 * This is a group used as part of the drop down.
		 */
		public var dropDown : Group;
		/**
		 * This is the Scroller instance used in the drop down. 
		 */
		public var scroller : Scroller;
		/**
		 * @copy spark.components.SkinnableDataContainer#dataGroup
		 */
		public var dataGroup : DataGroup;
		
		
		/**
		 * @copy spark.components.supportClasses.DropDownListBase#openButton
		 */
		public var openButton : Button;
		
		/**
		 * @copy spark.components.ComboBox#textInput
		 */
		public var textInput : TextInput;
		
		//--------------------------------------------------------------------------
		//
		//  LifeCycle methods
		//
		//--------------------------------------------------------------------------
		/**
		 * @private 
		 */
		override protected function commitCurrentState():void{
			super.commitCurrentState();
			
			// if this is disabled set the alpha
			// this is consistent with what other skins use 
			alpha = currentState.indexOf("disabled") == -1 ? 1 : 0.5;
			
			// display the popup; or not
			// based on the state
			if(this.currentState == 'open'){
				this.popUp.displayPopUp = true;
				this.invalidateDisplayList();
				
			} else {
				this.popUp.displayPopUp = false;
				this.invalidateDisplayList();
			}
			
		}
		
		/**
		 *  @private
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (paddingChanged && textInput)
			{
				// Push padding styles into the textDisplay
				// copied the approach from the default ComboBoxSkin approach
				var padding:Number;
				
				padding = getStyle("paddingLeft");
				if (textInput.getStyle("paddingLeft") != padding)
					textInput.setStyle("paddingLeft", padding);
				
				padding = getStyle("paddingTop");
				if (textInput.getStyle("paddingTop") != padding)
					textInput.setStyle("paddingTop", padding);
				
				padding = getStyle("paddingRight");
				if (textInput.getStyle("paddingRight") != padding)
					textInput.setStyle("paddingRight", padding);
				
				padding = getStyle("paddingBottom");
				if (textInput.getStyle("paddingBottom") != padding)
					textInput.setStyle("paddingBottom", padding);
				paddingChanged = false;
			}
			
		}
		
		
		/**
		 * @private 
		 */
		override protected function createChildren():void{
			super.createChildren();
			// Globally in this method; some of the properties are copied from the ComboBoxSkin approach
			// but modified for this usage.
			
			// create the open button
			this.openButton = new Button();
			this.openButton.focusEnabled = false;
			this.openButton.right = 0;
			this.openButton.top = 0;
			this.openButton.bottom = 0;
			this.openButton.setStyle('skinClass',openButtonSkin);
			this.addChild(this.openButton);
			
			// create the textInput
			this.textInput = new TextInput();
			this.textInput.left = 0;
			this.textInput.top = 0;
			this.textInput.bottom = 0;
			this.textInput.setStyle('skinClass',spark.skins.mobile.TextInputSkin);
			this.addChild(this.textInput);
			
			
			// create the pop up anchor for the drop down
			this.popUp = new PopUpAnchor();
			this.popUp.left = 0;
			this.popUp.right = 0;
			this.popUp.top = 0;
			this.popUp.bottom = 0;
			this.popUp.setStyle('itemDestructionPolicy','auto');
			this.popUp.popUpPosition = PopUpPosition.TOP_LEFT;
			this.popUp.popUpWidthMatchesAnchorWidth = true;
			
			// create the drop down; this is just a container for other children such as the scroller and data group
			this.dropDown = new Group();
			
			// create the scroller from the drop down
			this.scroller = new Scroller();
			this.scroller.left = 0;
			this.scroller.top = 0;
			this.scroller.right = 0;
			this.scroller.bottom = 0;
			this.scroller.hasFocusableChildren = false;
			this.scroller.minViewportInset = 1;
			
			// create the dataGroup which contains the list elements of the drop down
			this.dataGroup = new DataGroup();
			var dgLayout : VerticalLayout = new VerticalLayout();
			dgLayout.gap = 0;
			dgLayout.horizontalAlign = 'contentJustify';
			dgLayout.requestedRowCount = this.getStyle('requestedRowCount');
			
			this.dataGroup.layout = dgLayout;
			this.scroller.viewport = this.dataGroup;
			
			this.dropDown.addElement(this.scroller);
			
			this.popUp.popUp =  this.dropDown;
			this.addChild(this.popUp);
			
		}
		
		/**
		 * @private 
		 */
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void{
			super.drawBackground(unscaledWidth, unscaledHeight);

			// background creation approach modeled after List Skin
			this.popUp.graphics.clear();
			if(this.popUp.displayPopUp == true){
				var borderWidth:int = getStyle("borderVisible") ? 1 : 0;

				this.popUp.graphics.beginFill(getStyle("contentBackgroundColor"), getStyle("contentBackgroundAlpha"));
				this.popUp.graphics.drawRect(borderWidth, borderWidth, this.popUp.width - 2 * borderWidth, this.popUp.height - 2 * borderWidth);
				this.popUp.graphics.endFill();
				
				// JH DotComIt 10/29/2011
				// adding this code in an attempt to fix the issue where the background is transparent and stuff "under it" shows through
				this.dropDown.graphics.beginFill(getStyle("contentBackgroundColor"), getStyle("contentBackgroundAlpha"));
				this.dropDown.graphics.drawRect(borderWidth, borderWidth, this.popUp.width - 2 * borderWidth, this.popUp.height - 2 * borderWidth);
				this.dropDown.graphics.endFill();
				
				
				if (getStyle("borderVisible"))
				{
					// weird that the DropDownList skin draws the border on the dropDown; but the AutoComplete Skin
					/// draws the background on the PopUp 
					this.popUp.graphics.lineStyle(1, getStyle("borderColor"), getStyle("borderAlpha"), true); 
					this.popUp.graphics.drawRect(0, 0, this.popUp.width - 1, this.popUp.height - 1);
				}
				
			}
			
		}
		
		
		/**
		 * @private 
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			var buttonHeight : int = unscaledHeight;
			this.setElementSize(this.openButton,buttonHeight,buttonHeight );
			this.setElementPosition(this.openButton,unscaledWidth-buttonHeight,0);
			
			this.setElementSize(this.textInput,unscaledWidth-this.openButton.width,unscaledHeight );
			this.setElementPosition(this.textInput,0,0);
			
			// position and size the popUpAnchor 
			this.popUp.width = unscaledWidth;

			// get the first renderer and if it exists use that to guess the height
			var firstRenderer : IItemRenderer = this.dataGroup.getElementAt(0) as IItemRenderer;
			if(firstRenderer){
				var singleItemHeight : int = firstRenderer.height;
				var requestedRowCount : int = (this.dataGroup.layout as VerticalLayout).requestedRowCount;
				
				// pop up height adds 2 extra pixels for some reason; we'll leave it like that
				var popUpHeight : int = (singleItemHeight*requestedRowCount) + 2;
				if(this.hostComponent.dataProvider.length < requestedRowCount){
					popUpHeight = singleItemHeight * this.hostComponent.dataProvider.length + 2;
				}
				this.popUp.height = popUpHeight;
				
			}
			this.popUp.y = this.textInput.y + this.textInput.height;
			
		}

		/**
		 *  @private
		 */
		override protected function measure():void{
			super.measure();

			// later we resize the openButton to match the textInput height; so use that for measured height; without
			// consideration for the openButton's height
			this.measuredHeight = Math.max(this.openButton.getExplicitOrMeasuredHeight(), this.textInput.getExplicitOrMeasuredHeight());
			this.measuredWidth = this.openButton.getExplicitOrMeasuredWidth() + this.textInput.getExplicitOrMeasuredWidth();
		}
		
		/**
		 *  @private
		 */
		override public function styleChanged(styleProp:String):void
		{
			// I believe most of this was copied from default ComboBoxBox Skin 
			// this stuff probably not even modified
			var allStyles:Boolean = !styleProp || styleProp == "styleName";
			
			super.styleChanged(styleProp);
			
			if (allStyles || styleProp.indexOf("padding") == 0)
			{
				paddingChanged = true;
				invalidateProperties();
			}
		}

		/**
		 * @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			// copied from default ComboBoxSkin; and modded to accomodate for simplier background
			if (getStyle("borderVisible") == false)
			{
				if (scroller){
					scroller.minViewportInset = 0;
				}
			}
			else
			{
				if (scroller){
					scroller.minViewportInset = 1;
				}
			}
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		

		/**
		 * @private 
		 * When the AutoComplete is filtered, it may change the length of the drop down
		 * this will force the outline and background and popUpAnchor to be resized appropriately.
		 */
		protected function onAutoCompleteFilter(event:AutoCompleteCollectionEvent):void{
			this.invalidateDisplayList();
		}
		
		
	}
}