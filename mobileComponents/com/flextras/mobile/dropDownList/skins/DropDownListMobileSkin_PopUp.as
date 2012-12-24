package com.flextras.mobile.dropDownList.skins
{
	import mx.core.DPIClassification;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	import spark.components.Application;
	import spark.components.Group;
	import spark.components.IItemRenderer;
	import spark.components.Scroller;
	import spark.layouts.VerticalLayout;

	
	
	/**
	 * This style defines the height of the pop up.  If no value is specified, then the width is calculated based on the requestedRowCount style.  
	 * This style will have no affect if used in the default DropDownList skin class.  
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.6
	 *  @productversion Flex 4.5
	 * 
	 * @see DropDownListMobileSkin_Default#style:requestedRowCount
	 */
	[Style(name="popUpHeight", type="Number", format="int")]	

	/**
	 * This style defines the width of the pop up.  If no value is specified, then the width is calculatd at 90% of the application’s width.  
	 * This style will have no affect if used in the default DropDownList skin class.  
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.6
	 *  @productversion Flex 4.5
	 */
	[Style(name="popUpWidth", type="Number", format="int")]	
	
	
	// This is a skin that makes our DropDownList act like a more traditional DropDownList
	// it will show the drop down as a pop up
	// potentially it can also use the RadioButtonRenderer
	/**
	 * This is an alternate skin for the Flextras mobile DropDownList Component.  
	 * It will pop up the drop down over the application instead of displaying it under the component.  
	 * This skin is more consistent with how native mobile drop down lists work.  
	 * 
	 * @author www.flextras.com
	 * 
	 * @see com.flextras.mobile.dropDownList.DropDownList
	 */
	public class DropDownListMobileSkin_PopUp extends DropDownListMobileSkin_Default
	{
		public function DropDownListMobileSkin_PopUp()
		{
			super();
			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					this.borderWidth = 2;
					break;
				}
				case DPIClassification.DPI_240:
				{
					this.borderWidth = 1;
					break;
				}
				default:
				{
					// default DPI_160
					this.borderWidth = 1;
					break;
				}
					
			}
		}
		

		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//-------------------------------------------------------------------------- 		
		/**
		 * @private
		 * This is a helper value so that we don't have to calculate the pop up height multiple times.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		protected var borderWidth:int;
		
		//--------------------------------------------------------------------------
		//
		//  LifeCycle methods
		//
		//--------------------------------------------------------------------------		
		/**
		 * @private 
		 */
		override protected function createChildren():void{
			// copied from parent, but modified
			// because we aren't going to use the PopUpAnchor in thi case; instead use the PopUpManager to cover the full 
			// screen
			super.createChildren();
			
			// null out, effectively destroying the popUpAnchor.
			// sucks to do this; but this gives us benefits of re-use as opposed tohaving to recreate everything in parent
			if(this.popUp){
				this.removeChild(this.popUp);
				this.popUp = null;
			}
			
		}
		
		
		/**
		 * @private 
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			// position and size the PopUp
			if(this.currentState == 'open'){
				var topLevelApplication : Application = FlexGlobals.topLevelApplication as Application;

				// if n popUpWidth is specified; then calcualte it at .90% of the applications' width
				// otherwise use the styles value 
				this.dropDown.width = calculatePopUpWidth();

				// if a popUpHeight is specified as a style; then use that value
				// otherwise calculate the height
				var popUpHeight : int = calculatePopUpHeight();
				if(popUpHeight){
					this.dropDown.height = popUpHeight;
				} // else do nothing
				
				PopUpManager.addPopUp(this.dropDown, topLevelApplication);
				PopUpManager.centerPopUp(this.dropDown);
				
				// modify the scroller height and width to accomodate for the border
				this.scroller.width = this.dataGroup.width = this.dropDown.width-(this.borderWidth*2);
				this.scroller.height = this.dataGroup.height = this.dropDown.height-(this.borderWidth*2);
				

			} else {
				// if the currentState is not open and the PopUp is being displayed, remove it 
				if(this.dropDown.parent){
					PopUpManager.removePopUp(this.dropDown);
				}
			}
			
			
			// the separator line is not showing up in this new skin on first load
			// but this fixes it for some bizarre not understood reason.  
			this.setElementSize(this.separationLine,1,unscaledHeight-2 );
			
		}

		/**
		 * @private 
		 */
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void{
			super.drawBackground(unscaledWidth, unscaledHeight);
			
			// background/border creation approach modeled after List Skin
			if(this.currentState == 'open'){
				this.dropDown.graphics.clear();

				if (getStyle("borderVisible"))
				{
					// changing this code from this.popUp to this.dropDown in order to address issue
					// where border has breaks in it if something is underneath it. (Reported by Jarek S)
					this.dropDown.graphics.lineStyle(this.borderWidth, getStyle("borderColor"), getStyle("borderAlpha"), true); 
					this.dropDown.graphics.drawRect(0, 0, this.dropDown.width - this.borderWidth, this.dropDown.height - this.borderWidth);
				}
			}

		}
		
		/**
		 * @private 
		 * helper function for determining the pop up Width 
		 */
		protected function calculatePopUpWidth():int{

			// if pop up width is specified as a style; then use that
			// otherwise calculate it at 90% of the topLevelApplication
			var popUpWidth : int = this.getStyle('popUpWidth');
			if(popUpWidth){
				return popUpWidth;
			} else {
				var topLevelApplication : Application = FlexGlobals.topLevelApplication as Application;
				return Math.min(topLevelApplication.width*.9);
			}
		}

		/**
		 * @private 
		 * helper function for determining the pop up Height
		 */
		protected function calculatePopUpHeight():int{
			// if a popUpHeight is specified as a style; then use that value
			// otherwise calculate the height
			var popUpHeight : int = this.getStyle('popUpHeight');
			if(popUpHeight){
				return popUpHeight;
			} else {
				// but height I don't want to guess; use the same approach used in skin we're extending
				// get the first renderer and if it exists use that to guess the height
				var firstRenderer : IItemRenderer = this.dataGroup.getElementAt(0) as IItemRenderer;
				if(firstRenderer){
					var singleItemHeight : int = firstRenderer.height;
					var requestedRowCount : int = (this.dataGroup.layout as VerticalLayout).requestedRowCount;
					
					// pop up height adds 2 extra pixels for some reason; we'll leave it like that
					var popUpPadding : int = 2;
					popUpHeight = (singleItemHeight*requestedRowCount) + popUpPadding;
					if(this.hostComponent.dataProvider.length < requestedRowCount){
						popUpHeight = singleItemHeight * this.hostComponent.dataProvider.length + popUpPadding;
					}
					return popUpHeight;
				}
			}
			// In some cases; there will be no firstRenderer defined
			// such as if the dataGroup hasn't been displayed yet
			// by returning NaN; then the pop component automagically sizes itself
			// in the process of rendering renderers 
			return NaN;
			
		}
		
	}
}