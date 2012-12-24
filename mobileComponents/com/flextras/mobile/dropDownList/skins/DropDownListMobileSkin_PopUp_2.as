package com.flextras.mobile.dropDownList.skins
{
	import com.flextras.mobile.shared.skins.ButtonSkinSquare;
	
	import flash.display.GradientType;
	
	import mx.core.DPIClassification;
	import mx.core.FlexGlobals;
	import mx.core.mx_internal;
	import mx.managers.PopUpManager;
	import mx.utils.ColorUtil;
	
	import spark.components.Application;
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.IItemRenderer;
	import spark.components.Label;
	import spark.layouts.BasicLayout;
	import spark.layouts.VerticalLayout;
	import spark.skins.mobile.ButtonSkin;

	use namespace mx_internal;
	
	/**
	 * This is an alternate skin for the Flextras mobile DropDownList Component.   
	 * It will pop up the drop down over the application instead of displaying it under the component.  
	 * The pop up includes a title area, above the list, and a cancel button below it.  
	 * This skin is modeled after how native mobile drop down Lists work.
	 * 
	 * @author www.flextras.com
	 * 
	 * @see com.flextras.mobile.dropDownList.DropDownList
	 */
	public class DropDownListMobileSkin_PopUp_2 extends DropDownListMobileSkin_PopUp
	{
		public function DropDownListMobileSkin_PopUp_2()
		{
			super();
			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					
					headerPaddingTop = 20;
					headerPaddingBottom = 20;
					this.closeButtonOffset = 0;
					this.borderWidth = 1;

					break;
				}
				case DPIClassification.DPI_240:
				{
					
					headerPaddingTop = 15;
					headerPaddingBottom = 15;
					this.closeButtonOffset = 0;
					
					break;
				}
				default:
				{
					// default DPI_160
					headerPaddingTop = 10;
					headerPaddingBottom = 10;
					this.closeButtonOffset = 1;
					
					break;
				}
				
			}

		}
		
		//--------------------------------------------------------------------------
		//
		//  Skin parts
		//
		//-------------------------------------------------------------------------- 		

		/**
		 * @copy com.flextras.mobile.dropDownList.DropDownList#closeButton
		 */
		public var closeButton : Button;


		// this is the components used for the header
		// the group is going to be used primarily as a container to hold the background and the header display
		/**
		 * This is a group used to contain the header of the pop up.
		 */
		public var headerGroup : Group;
		
		
		// the headerDisplay is the text.  For these purposes, we're going to use a label 
		/**
		 * @copy com.flextras.mobile.dropDownList.DropDownList#headerLabelDisplay
		 */
		public var headerLabelDisplay : Label;
		

		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//-------------------------------------------------------------------------- 		

		/**
		 * @private
		 * For some bizarre reason setting the closeButton to the wdith of the popup doesn't line it up properly with the border causing
		 * a weird display issue.  
		 * 
		 * I haven't figured out if the issue is with our FXG elements or something else.  
		 * 
		 * This value will contain the offset used to extend the border for differet DPI values and will make things look right.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		protected var closeButtonOffset:int;
		
		/**
		 * @private
		 * This is a helper value so that we don't have to calculate the pop up height multiple times. 
		 * Partly for perfromance; partly to solve an odd issue with the list would vanish after the first time you bring up the popup
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		protected var cachedPopUpHeight:int = 0;

		/**
		 * @private
		 * This approach copied from mobile ButtonSkin
		 * Top padding for headerDisplay.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		protected var headerPaddingTop:int;
		
		/**
		 * @private
		 * This approach copied from mobile ButtonSkin
		 * Bottom padding for headerDisplay.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		protected var headerPaddingBottom:int;

		
		//--------------------------------------------------------------------------
		//
		//  LifeCycle methods
		//
		//--------------------------------------------------------------------------		
		/**
		 * @private 
		 */
		override protected function createChildren():void{
			super.createChildren();
			
			// create the close button
			this.closeButton = new Button();
			this.closeButton.setStyle('skinClass',com.flextras.mobile.shared.skins.ButtonSkinSquare);
			this.closeButton.setStyle('borderColor',getStyle("borderColor"));
			this.closeButton.setStyle('borderAlpha', getStyle("borderAlpha"));
			
			// give the drop down a vertical layout
			// for some reason we had serious issues w/ basic layout and absolute positioning
			var ddLayout : VerticalLayout = new VerticalLayout();
			ddLayout.gap = 0;
			this.dropDown.layout = ddLayout;
			this.dropDown.addElement(closeButton);

			// create the header group and headerLabel
			this.headerGroup = new Group();
			this.headerLabelDisplay = new Label();
			this.headerGroup.addElement(this.headerLabelDisplay);

			// add the header so it is the first element in the drop down
			// we care about this because the veritcal layout will make sure it displays at the top
			this.dropDown.addElementAt(this.headerGroup,0);
			
		}
		/**
		 * @private 
		 */
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void{

			super.drawBackground(unscaledWidth, unscaledHeight);
			if(this.currentState == 'open'){
				// it kind of bugs me that this is redrawn every time the screen refreshes 
				// should something be done to not draw it again? 
				// consistent w/ how the Flex Framework seems to do things; so we'll leave it for now.
				
				// gonna create the background for the Header Group identical to background for button
				// this makes the bottom and top using the same gradient 
				this.headerGroup.graphics.clear();
				
				// get the chrome color of the close button for visual consistency
				// I don't think chromeColor would be a style on the DropDownList
				var chromeColor:uint = this.closeButton.getStyle("chromeColor");

				var colors:Array = [];
				// color matrix is defined in MobileSkin but not used anywhere in it
				// since we don't use it in our custom skin we can make use of here just like the button skin does to create the 
				// background for the header; copying what the button does
				colorMatrix.createGradientBox(this.headerGroup.width, this.headerGroup.height, Math.PI / 2, 0, 0);
				colors[0] = ColorUtil.adjustBrightness2(chromeColor, 70);
				colors[1] = chromeColor;
				
				this.headerGroup.graphics.beginGradientFill(GradientType.LINEAR, colors, ButtonSkin.CHROME_COLOR_ALPHAS, ButtonSkin.CHROME_COLOR_RATIOS, colorMatrix);
				this.headerGroup.graphics.drawRect(borderWidth,borderWidth, this.headerGroup.width-(borderWidth*2), this.headerGroup.height-(borderWidth*2));
				this.headerGroup.graphics.endFill();

				var borderVisible:Boolean = getStyle("borderVisible") ? true : false;

				// draw the border on the header group
				if (borderVisible)
				{
					// changing this code from this.popIp to this.dropDown in order to address issue
					// where border has breaks in it if something is underneath it. (Reported by Jarek S)

					this.headerGroup.graphics.lineStyle(this.borderWidth, getStyle("borderColor"), getStyle("borderAlpha"), true); 
					if(borderWidth == 1){
						this.headerGroup.graphics.drawRect(0, 0, this.headerGroup.width - this.borderWidth, this.headerGroup.height - this.borderWidth);
					} else {
						// border width must be 2
						// draw two borders.. that's how we did it in the FXG for 360DPI.  
						// crazy stuff; we shouldn't have to do this.
						this.headerGroup.graphics.drawRect(0, 0, this.headerGroup.width - 1, this.headerGroup.height - 1);
						this.headerGroup.graphics.drawRect(1, 1, this.headerGroup.width - 2, this.headerGroup.height - 2);
					}
				}
			}
		}
		
		/**
		 * @private 
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			if(this.currentState == 'open'){

				// temp variables for the width and height of the popUp 
				var popUpWidth : int= this.calculatePopUpWidth();
				var popUpHeight : int= this.calculatePopUpHeight();
				
				// store the borderWidth; used for positioning and sizing the elements 
				var borderVisible:Boolean = getStyle("borderVisible") ? true : false;
				
				
				// reset drop down height since it probably changed 
				// once we jhave a good calculation 
				this.dropDown.width = popUpWidth;
				this.dropDown.height = popUpHeight;

				// position and size the header label within the headerGroup 
				// if we do this before the super is called; then the headerDisplay will have no size because the pop up hasn't been added 
				// and therefore it's measure hasn't run and therefore it's width is zero

				// size and position the headerDisplay label inside the headerGroup
				// We want to center it
				var headerDisplayWidth : int = this.getElementPreferredWidth(this.headerLabelDisplay);
				if(headerDisplayWidth >= popUpWidth){
					headerDisplayWidth = popUpWidth;
				}
				this.setElementSize(this.headerLabelDisplay, headerDisplayWidth, this.getElementPreferredHeight(this.headerLabelDisplay));

				// size the header group 
				// calculate header group height in relation to the label and the padding 
				var headerGroupHeight : int = this.getElementPreferredHeight(this.headerLabelDisplay) + this.headerPaddingBottom + this.headerPaddingTop;
				
				// if we use setElementSize then the group seems to want to resize it later; so we width and height 
				// directly on our header group's children 
				this.headerGroup.width = popUpWidth;
				this.headerGroup.height = headerGroupHeight;

				// position the header label inside the header group; essentially centering it
				var headerDisplayX : int = Math.round((popUpWidth - headerDisplayWidth)/2);
				// add the top and bottom padding to prevent resizing later; which shrinks down the whole header group
				// or would if we continued to use set element size on it 
				this.headerLabelDisplay.top = this.headerPaddingTop;
				this.headerLabelDisplay.bottom = this.headerPaddingBottom;
				this.setElementPosition(this.headerLabelDisplay,headerDisplayX,this.headerPaddingTop);
				
				
				// size the close button
				// we need to size the close button before the scroller/dataGroup because the scroller/DataGroup
				// will fill whatever space is left 
				// adding 1 to width for border line up 
				this.closeButton.width = popUpWidth+this.closeButtonOffset;
				this.closeButton.height = this.getElementPreferredHeight(this.closeButton);

				// resize the dataGroup and scroller to accomodate for the button
				this.scroller.width = popUpWidth -(borderWidth*2);
				this.scroller.height = popUpHeight-this.headerGroup.height-this.closeButton.height-(borderWidth*4);
				this.dataGroup.width = this.scroller.width
				this.dataGroup.height = this.scroller.height;
				

				// cache the final drop down height if we haven't yet.
				if(this.cachedPopUpHeight == 0){
					this.dropDown.height = this.cachedPopUpHeight = this.headerGroup.height + this.scroller.height + this.closeButton.height;
				}
				this.dropDown.height = this.headerGroup.height + this.scroller.height + this.closeButton.height;

				// recenter the popup because we just resized a bunch of stuff
				PopUpManager.centerPopUp(this.dropDown);

			}
			
			// I think we're going to want to do some code wrangling here if the dropDown height is greater than unscaledHeight 
			// basically, we'll want to artifically lower the requested row count and reset size for 
			// scroller and dataGroup 
			// in theory this will only happen if someone sets the popUpHeight manually to something greater thant he apps height
			// or if the rowCount 
			// seems like that could be a fringe case; so we're not going to implement any code against it.
			
		}		
		
		/**
		 * @private 
		 * helper function for determining the pop up Height
		 */
		override protected function calculatePopUpHeight():int{
			// if a popUpHeight is specified as a style; then use that value
			// otherwise calculate the height
			var popUpHeight : int = this.getStyle('popUpHeight');
			if(popUpHeight){
				return Math.floor(popUpHeight);
			} else if (cachedPopUpHeight != 0){
				return Math.floor(cachedPopUpHeight);
			} else {

				var listHeight : int = super.calculatePopUpHeight();
				
				if(!listHeight){
					return NaN;
				}
				// add in height of close button and header
				listHeight += this.closeButton.getExplicitOrMeasuredHeight();
				// instad of using the header group; let's use the calculation for the header group 
				listHeight += this.getElementPreferredHeight(this.headerLabelDisplay) + this.headerPaddingBottom + this.headerPaddingTop ;
				// + this.getElementPreferredHeight(this.closeButton)
				return Math.floor(listHeight);
			}
			// In some cases; there will be no firstRenderer defined
			// such as if the dataGroup hasn't been displayed yet
			// by returning NaN; then the pop component automagically sizes itself
			// in the process of rendering renderers 
			return NaN;
			
		}
	}
}