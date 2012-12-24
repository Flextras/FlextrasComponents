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
package com.flextras.mobile.dropDownList.skins
{
	import com.flextras.mobile.autoCompleteComboBox.skins.DownArrowSkin_Default;
	import com.flextras.mobile.dropDownList.DropDownList;
	
	import flash.display.Sprite;
	import flash.text.TextLineMetrics;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.styles.CSSStyleDeclaration;
	
	import spark.components.Button;
	import spark.components.DataGroup;
	import spark.components.Group;
	import spark.components.IItemRenderer;
	import spark.components.Label;
	import spark.components.PopUpAnchor;
	import spark.components.PopUpPosition;
	import spark.components.Scroller;
	import spark.layouts.VerticalLayout;
	import spark.skins.mobile.supportClasses.MobileSkin;

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
	
	// the dropDownListMobileSkin is almost exactly like the AutoCompleteComboBox Mobile Skin 
	// except the textInput is actualy a label named labelDisplay
	// and the button is extended tot he full height / width and sits behind the labelDisplay
	// and we added a link to separate the label from the button down Arrow
	// okay maybe they aren't almost exactly like each other, but they started out that way
	/**
	 * This is the default skin for the Flextras mobile DropDownList Component.
	 * 
	 * @author www.flextras.com
	 * 
	 * @see com.flextras.mobile.dropDownList.DropDownList
	 * 
	 */
	public class DropDownListMobileSkin_Default extends MobileSkin
	{
		public function DropDownListMobileSkin_Default()
		{
			super();
		}
		
		
		// use the default method to set styles 
		// using this approach here http://help.adobe.com/en_US/flex/using/WS2db454920e96a9e51e63e3d11c0bf687e7-7ff6.html
		// Define a static variable.
		private static var classConstructed:Boolean = classConstruct();

		// Define a static method.
		private static function classConstruct():Boolean {
			if (!FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("com.flextras.mobile.dropDownList.skins.DropDownListMobileSkin_Default"))
			{
				// If there is no CSS definition for this component, then create one define the default style values
				// the ones not defined here are just inherited 
				var myStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
				myStyle.setStyle('requestedRowCount',4);
				
				FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration("com.flextras.mobile.dropDownList.skins.DropDownListMobileSkin_Default", myStyle, true);
				
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
		private var _hostComponent:DropDownList;
		/**
		 * @copy spark.skins.spark.ApplicationSkin#hostComponent
		 */
		public function get hostComponent():DropDownList
		{
			return _hostComponent;
		}
		
		/**
		 * @private
		 */
		public function set hostComponent(value:DropDownList):void
		{
			_hostComponent = value;
		}
		
		//----------------
		//  openButtonSkin
		//----------------
		/**
		 * This contains a reference to the skin for the down arrow button as part of the component.  
		 * 
		 * @see com.flextras.mobile.autoCompleteComboBox.skins.DownArrowButtonSkin_Default
		 */
		protected var openButtonSkin : Class = com.flextras.mobile.autoCompleteComboBox.skins.DownArrowSkin_Default;

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
		 * @copy spark.components.DropDownList#labelDisplay
		 */
		public var labelDisplay : Label;

		/**
		 * This component represents a line that is used to separate the label from the down arrow.
		 */
		public var separationLine : Sprite;
		
		
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
				if(this.popUp){
					this.popUp.displayPopUp = true;
				}
				this.invalidateDisplayList();
				
			} else {
				if(this.popUp){
					this.popUp.displayPopUp = false;
				}
				this.invalidateDisplayList();
			}
			
		}

		/**
		 * @private 
		 */
		override protected function createChildren():void{
			// JH DotComIt 8/4/2011 
			// modified this method to only create the children if they already exist
			// this is to make extensibility a bit easier; we can extend the component; create the children before calling super 
			// and then this code won't run; recreating the children
			
			super.createChildren();
			// Globally in this method; some of the properties are copied from the DropDownListSkin approach
			// but modified for this usage.
			
			// create the open button
			if(!this.openButton){
				this.openButton = new Button();
				this.openButton.focusEnabled = false;
				this.openButton.right = 0;
				this.openButton.top = 0;
				this.openButton.bottom = 0;
				this.openButton.setStyle('skinClass',openButtonSkin);
				this.addChild(this.openButton);
			}
			
			// create the textInput
			if(!this.labelDisplay){
				this.labelDisplay = new Label();
				this.labelDisplay.setStyle('verticalAlign','middle');
				this.labelDisplay.maxDisplayedLines = 1;
				this.labelDisplay.mouseEnabled = false;
				this.labelDisplay.mouseChildren = false;
				this.labelDisplay.left = 7;
				this.labelDisplay.right = 30;
				this.labelDisplay.top = 2;
				this.labelDisplay.bottom = 2;
				this.labelDisplay.verticalCenter = 1;
				this.addChild(this.labelDisplay);
			}
			
			
			// create the pop up anchor for the drop down
			if(!this.popUp){
				this.popUp = new PopUpAnchor();
				this.popUp.left = 0;
				this.popUp.right = 0;
				this.popUp.top = 0;
				this.popUp.bottom = 0;
				this.popUp.setStyle('itemDestructionPolicy','auto');
				this.popUp.popUpPosition = PopUpPosition.TOP_LEFT;
				this.popUp.popUpWidthMatchesAnchorWidth = true;
				this.popUp.depth = 100;
			}
			
			// create the drop down; this is just a container for other children such as the scroller and data group
			if(!this.dropDown){
				this.dropDown = new Group();
			}
			
			// create the scroller from the drop down
			if(!this.scroller){
				this.scroller = new Scroller();
				this.scroller.left = 0;
				this.scroller.top = 0;
				this.scroller.right = 0;
				this.scroller.bottom = 0;
				this.scroller.hasFocusableChildren = false;
				this.scroller.minViewportInset = 1;
			}
			
			// create the dataGroup which contains the list elements of the drop down
			if(!this.dataGroup){
				this.dataGroup = new DataGroup();
				var dgLayout : VerticalLayout = new VerticalLayout();
				dgLayout.gap = 0;
				dgLayout.horizontalAlign = 'contentJustify';
				dgLayout.requestedRowCount = this.getStyle('requestedRowCount');
				this.dataGroup.layout = dgLayout;

				if(this.scroller){
					this.scroller.viewport = this.dataGroup;
				}
				
			}
			
			
			if(this.dropDown){
				this.dropDown.addElement(this.scroller);

				if(this.popUp){
					this.popUp.popUp =  this.dropDown;
				}
			}
			
			if((this.popUp) && (!this.popUp.parent)){
				this.addChild(this.popUp);
			}

			
			// create the line that separates the label from the down arrow of the button
			if(!this.separationLine){
				this.separationLine = new Sprite();
				this.addChild(this.separationLine);
			}
		}
		
		/**
		 * @private 
		 */
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void{
			super.drawBackground(unscaledWidth, unscaledHeight);
			
			// background creation approach modeled after List Skin
			if(this.popUp){
				this.popUp.graphics.clear();
				this.dropDown.graphics.clear();
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
						// changing this code from this.popIp to this.dropDown in order to address issue
						// where border has breaks in it if something is underneath it. (Reported by Jarek S)
						this.dropDown.graphics.lineStyle(1, getStyle("borderColor"), getStyle("borderAlpha"), true); 
						this.dropDown.graphics.drawRect(0, 0, this.popUp.width - 1, this.popUp.height - 1);
					}
					
				}
				
			}
			
		}

		/**
		 * @private 
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			// down arrow button should extend behind the whole component 
			// although we don't want the down arrow--just one asset on the button--to do so
			// in the ComboBox; the button extends the full width; 
			// this is different than the AutoComplete
			var downArrowHeight : int = unscaledHeight;

			var openButtonSkin : DownArrowSkin_Default = this.openButton.skin as DownArrowSkin_Default;
			this.openButton.setStyle('downArrowWidth',downArrowHeight);
			this.openButton.setStyle('downArrowHeight',downArrowHeight);
			
			// size and position the openButton
			this.setElementSize(this.openButton, unscaledWidth,unscaledHeight );
			this.setElementPosition(this.openButton,0,0);

			// Draw a line to the left of the down arrow
			// in some situations on iOS setting the element size on the sprite before drawing 
			// was making it freakin' huge.  How bizarre.  Moved the "set size" to after the drawing 
			this.setElementPosition(this.separationLine,unscaledWidth-downArrowHeight-1 ,1);
			this.separationLine.graphics.clear();
			this.separationLine.graphics.lineStyle(1,0x000000);
			this.separationLine.graphics.beginFill(0x000000);
			this.separationLine.graphics.drawRect(0,0 , 1, unscaledHeight);
			this.separationLine.graphics.endFill();
			this.setElementSize(this.separationLine,1,unscaledHeight-2 );
			
			
			// position the label display; which is all the way to the left of the component
			// and up to the start of the separation line
			// width is unscaledWidth - the downArrowHeight (Down Arrow is always square) - the SeparationLine.Width 
			// -1 [padding between button and separationLine -7 (x indentation of labelDisplay) - 1 (Padding between labelDisplay and SeparationLine)
			this.setElementSize(this.labelDisplay,unscaledWidth-downArrowHeight- this.separationLine.width -1-7-1,unscaledHeight );
//			this.setElementSize(this.labelDisplay,unscaledWidth-downArrowHeight- this.separationLine.width -1-1,unscaledHeight );
			this.setElementPosition(this.labelDisplay,7,2);
			
			
			// position and size the popUpAnchor 
			if(this.popUp){
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
				this.popUp.y = this.labelDisplay.y + this.labelDisplay.height;
				
			}
			
		}
		
		/**
		 *  @private
		 */
		override protected function measure():void{
			super.measure();

			
			this.measuredHeight = Math.max(this.openButton.getExplicitOrMeasuredHeight(), this.labelDisplay.getExplicitOrMeasuredHeight());
			
			// if no width is specifeid labelDisplay has 0 width; and that causes layout problems because only the down arrow button
			// is displayed
			var labelDisplayWidth : int = this.labelDisplay.getExplicitOrMeasuredWidth();
			if(labelDisplayWidth <= 0){
				
				// get the typical item and measure it's text width and use that to size the label
				// if the label has no other width
				// is this a performance intensive operation?  Or should I be caching this value?  
				// for now; I'm going to leae it.
				// if you're reading this after the fact; remember you'll get best performanceby manually setting the size.  
				var _typicalItem : Object = this.hostComponent.typicalItem;
				if(!_typicalItem){
					if((this.hostComponent.dataProvider) && (this.hostComponent.dataProvider.length >0)){
						_typicalItem = this.hostComponent.dataProvider.getItemAt(0);
					}
				}
				if(_typicalItem){
					var typicalItemLbel : String = this.hostComponent.itemToLabel(_typicalItem);
					var itemLabelMetrics : TextLineMetrics= this.measureText(typicalItemLbel);
					labelDisplayWidth = itemLabelMetrics.width;
				} else {
					// if ll else fails; use a default value
					// 100 was chosen slightly at random. 
					labelDisplayWidth = 100;
				}
				
			}
			
			this.measuredWidth = this.openButton.getExplicitOrMeasuredWidth() + labelDisplayWidth;
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
		
		
	}
}