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
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile160.DownArrow_down_default;
	import com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile160.DownArrow_up_default;
	import com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile240.DownArrow_down_default;
	import com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile240.DownArrow_up_default;
	import com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile320.DownArrow_down_default;
	import com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile320.DownArrow_up_default;
	
	import mx.core.DPIClassification;
	
	import spark.skins.mobile.ButtonSkin;
	
	
	/**
	 * This style gives the component the ability to specify the width of the down Arrow.  
	 * If the width is not specified; the unscaledWidth will be used to size the down arrow.  
	 * This style was added to the component skin to easily allow code reuse between the mobile 
	 * AutoComplete and mobile ComboBox components.  
	 * <br/><br/>
	 * In the AutoComplete component, the down arrow is sized to the full height and width of the openButton.  
	 * In the ComboBox; the open button extends the full component, and the down arrow is just over one part 
	 * of the Button. If you use our default skins; only the Combobox sets this style.
	 */
	[Style(name="downArrowWidth", type="Number", format="int")]	

	/**
	 * This style gives the component the ability to specify the height of the down Arrow.  
	 * If the height is not specified, then the unscaledHeight will be used.  
	 * This style was added to the component skin to easily allow code reuse between the mobile AutoComplete and 
	 * the mobile ComboBox components.
	 * <br/><br/>
	 * In the AutoComplete component, the down arrow is sized to the full height and width of the openButton.  
	 * In the ComboBox; the open button extends the full component, and the down arrow is just over one part of 
	 * the Button.  If you use our default skins; only the Combobox sets this style.
	 */
	[Style(name="downArrowHeight", type="Number", format="int")]	
	
	/**
	 * This skin is the default skin for the open button of the Flextras Mobile AutoCompleteComboBox and 
	 * DropDownList.  It is modeled after the mobile ButtonSkin.  
	 * 
	 * @author www.flextras.com
	 * 
	 * @see com.flextras.mobile.autoCompleteComboBox.AutoCompleteComboBoxMobile
	 * @see com.flextras.mobile.dropDownList.DropDownList
	 */
	public class DownArrowSkin_Default extends ButtonSkin
	{
		public function DownArrowSkin_Default()
		{
			super();
			
			// this uses the application DPI to decide which FXG assets to use. 
			// FXG assets are sized differently based on the DPI values.
			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					downArrowDownSkin = com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile320.DownArrow_down_default;
					downArrowUpSkin = com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile320.DownArrow_up_default;
					
					break;
				}
				case DPIClassification.DPI_240:
				{
					downArrowDownSkin = com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile240.DownArrow_down_default;
					downArrowUpSkin = com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile240.DownArrow_up_default;
					
					break;
				}
				default:
				{
					// default DPI_160
					downArrowDownSkin = com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile160.DownArrow_down_default;
					downArrowUpSkin = com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile160.DownArrow_up_default;
					
					break;
				}
			}
			
		}
	

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------	

	/**
	 * @private 
	 * A change value that tells the button to change ths FXG Skin during the next render event.
	 */
	private var changeFXGSkin:Boolean = false;		
	
	/**
	 * @private 
	 * a reference to the instance of the downArrow; which is an FXG Object
	 */
	protected var downArrow:DisplayObject;
	
	
	/**
	 *  This is a class to use for the down arrow down state.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5 
	 *  @productversion Flex 4.5
	 * 
	 *  @default Button_up
	 */  
	protected var downArrowDownSkin:Class;

	/**
	 *  This is a class to use for the down arrow state; will swap between downArrowDownSkin and downArrowUpSkin.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5 
	 *  @productversion Flex 4.5
	 * 
	 *  @see #downArrowDownState
	 *  @see #downArrowUpState
	 */  
	protected var downArrowSkin:Class;
	
	/**
	 *  This is the class to use for the down arrow up state.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5 
	 *  @productversion Flex 4.5
	 * 
	 *  @default Button_up
	 */  
	protected var downArrowUpSkin:Class;
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private 
	 */
	override protected function commitCurrentState():void
	{   
		super.commitCurrentState();

		// get the downArrowSkin based on the current state
		this.downArrowSkin = getDownArrowClassForCurrentState();
		
		// if the skin needs to be changed; change the flag propety
		// change will take place in updateDisplayList()
		if (!(this.downArrow is this.downArrowSkin)){
			changeFXGSkin = true;
		}
		
		invalidateDisplayList();
		
	}
	
	
	/**
	 *  @private
	 */
	override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
	{
		super.layoutContents(unscaledWidth, unscaledHeight);
		
		// if the FXG skin needs to change; then destroy the down arrow and recreate it.
		if (changeFXGSkin)
		{
			changeFXGSkin = false;
			
			if (this.downArrow)
			{
				// destroy the down arrow instance
				removeChild(this.downArrow);
				this.downArrow = null;
			}
			
			if (this.downArrowSkin)
			{
				// create the new down arrow instance
				this.downArrow = new downArrowSkin();
				addChild(this.downArrow);
				this.setDownArrowSizeAndPosition(unscaledWidth,unscaledHeight);
			}
		}
		
		// if the down arrow is width or height is 0; be sure to resize it
		// this is here so we can reuse this skin in the ComboBox; where the down arrow does not extend the full
		// width of the button 
		if((this.downArrow) && 
			( ((this.downArrow.width == 0) || (this.downArrow.height == 0)) ||
			// in some situations, the down arrow will be sized with an unscaledWidth == 0;
			// if that happens. down arrow will be placed off screen 
			// This condition will solve that; re positioning the down arrow if 
			// it is off screen
			// this could solve the issue that the person had on the iPad too; with the down arrow appearing in 
			// "random spots" until you click the button
			// this situation appeared to occur when the height was set to a specific value and the width was 100%.
			 (this.downArrow.x <0) || 
			 // just to be sure add one more condition if the downArrow.x is less than unscaledWidth-downArrow.width
			 (this.downArrow.x < (unscaledWidth-downArrow.width)) ||
			 
			 // 4/12/2012
			 // Some issue is happening when the second time you rotate the screen the arrow doesn't move w/ it
			 // works fine the first time
			 // so this condition will make sure that the down arrow's X value is smaller than the unscaledWidth of the comp
			 // if the x position is greater than the unscaledWidth of the comp, it means it will display out of comp and 
			 // needs to be resized 
			 (this.downArrow.x > (unscaledWidth))
			)  
			
		){
			this.setDownArrowSizeAndPosition(unscaledWidth,unscaledHeight);
		}
		
	}
	
	/**
	 * @private
	 * This is a helper function for sizing and position the down arrow. 
	 */
	protected function setDownArrowSizeAndPosition(unscaledWidth:Number, unscaledHeight:Number):void{

		// get the down arrow width; if the style is not specified; then use unscaledWidth
		var downArrowWidth : int = this.getStyle('downArrowWidth');
		var daWidth : int = downArrowWidth ? downArrowWidth : unscaledWidth;
		// get the down arrow height; if the style is not specified; then use unscaledHeight
		var downArrowHeight : int = this.getStyle('downArrowHeight');
		var daHeight : int = downArrowHeight ? downArrowHeight : unscaledHeight;

		// set the down arrows size
		setElementSize(this.downArrow, daWidth, daHeight);

		// always position on the right
		var xPosition : int = 0;
		if(daWidth != unscaledWidth){
			xPosition = unscaledWidth - daWidth;
		}
		this.setElementPosition(this.downArrow,xPosition ,0  );
		
	}

	/**
	 * @private
	 *  This method returns the downArrowClass to use based on the currentState.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5 
	 *  @productversion Flex 4.5
	 */
	protected function getDownArrowClassForCurrentState():Class
	{
		if (currentState == "down") 
			return this.downArrowDownSkin;
		else
			return this.downArrowUpSkin;
	}		
	
	
	}
	
}