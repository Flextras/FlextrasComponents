package com.flextras.mobile.shared.renderers
{
	import spark.components.LabelItemRenderer;
	import spark.components.RadioButton;
	import spark.components.supportClasses.StyleableTextField;

	import mx.core.mx_internal;
	use namespace mx_internal;

	
	/**
	 * This is an alternate renderer, created for the Flextras Mobile DropDownList Component.  
	 * In addition to the label, it also displays a radio button, similar to native mobile DopDownList components.
	 * 
	 * @author jhouser
	 * 
	 * @see com.flextras.mobile.dropDownList.DropDownList
	 * 
	 */
	public class RadioButtonRenderer extends LabelItemRenderer
	{
		public function RadioButtonRenderer()
		{
			super();
		}

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		// radio Button
		/**
		 * This is the radioButton used in the renderer. 
		 */
		protected var radioButton : RadioButton;

		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 *  @private
		 */
		override protected function createChildren():void{
			super.createChildren();
			// create the radio button and add it
			this.radioButton = new RadioButton();
			this.addChild(this.radioButton);
		}
		
		/**
		 * @private 
		 */
		override protected function measure():void{
			super.measure();

			// modifying the ideal sizing to accomodate for the radio button 
			if(this.radioButton){
				
				var verticalPadding:Number = getStyle("paddingTop") + getStyle("paddingBottom");
				
				this.measuredHeight = Math.max(this.measuredHeight, this.getElementPreferredHeight(this.radioButton) + verticalPadding);
				this.measuredWidth += this.getElementPreferredWidth(this.radioButton);
			}
			
		}
		
		/**
		 * @private 
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			// we're gonna skip calling the super for the purposes of this implementation
			// we copy most of the code and change it anyway.
			//			super.layoutContents(unscaledWidth,unscaledHeight);
			
			if ( (unscaledWidth == 0) || (unscaledHeight == 0) ){
				return;
			}
			
			
			// only do the sizing if we have both components defined
			if(!this.labelDisplay || !this.radioButton){
				return;
			}

			
			// copied from parent
			// helper variables to the related padding styles
			var paddingLeft:Number   = getStyle("paddingLeft"); 
			var paddingRight:Number  = getStyle("paddingRight");
			var paddingTop:Number    = getStyle("paddingTop");
			var paddingBottom:Number = getStyle("paddingBottom");
			var verticalAlign:String = getStyle("verticalAlign");

			// copied from parent
			// find the spacing size, minus the padding
			var viewWidth:Number  = unscaledWidth  - paddingLeft - paddingRight;
			var viewHeight:Number = unscaledHeight - paddingTop  - paddingBottom;

			
			// copied from parent
			var vAlign:Number;
			if (verticalAlign == "top")
				vAlign = 0;
			else if (verticalAlign == "bottom")
				vAlign = 1;
			else // if (verticalAlign == "middle")
				vAlign = 0.5;
			

			// this part isn't copied from the parent.
			var radioButtonWidth : Number = this.getElementPreferredWidth(this.radioButton);
			var radioButtonHeight : Number = this.getElementPreferredHeight(this.radioButton);

			// measure the label component
			// text should take up the rest of the space width-wise, but only let it take up
			// its measured textHeight so we can position it later based on verticalAlign
			// I wonder what situation would put the viewWidth below 0?  
			// probably if the unscaledWidth and unscaledHeight are not set yet; and the padding values are set
			var labelWidth:Number = Math.max(viewWidth-radioButtonWidth, 0) -StyleableTextField.TEXT_WIDTH_PADDING
			var labelHeight:Number = 0;
			
			if (label != "")
			{
				labelDisplay.commitStyles();
				
				// reset text if it was truncated before.
				if (labelDisplay.isTruncated){
					labelDisplay.text = label;
				}
				
				labelHeight = getElementPreferredHeight(labelDisplay);
			}
			
			// bizarrely the label will add stuff to the labelWidth that we pass in.  
			// We accomodate for that by using the StyleableTextField.TEXT_WIDTH_PADDING when we set the labelWidth
			setElementSize(this.labelDisplay, labelWidth, labelHeight);    
			setElementSize(this.radioButton, radioButtonWidth, radioButtonHeight);    
			
			// We want to center using the "real" ascent
			var labelY:Number = Math.round(vAlign * (viewHeight - labelHeight))  + paddingTop;
			setElementPosition(labelDisplay, paddingLeft, labelY);

			// this positioning buts the radio button right up against the radio button;
			// this rendition doesn't pad it all; but there does't seem to be a problem so we're gonna stick with it
			var radioButtonY:Number = Math.round(vAlign * (viewHeight - radioButtonHeight))  + paddingTop;
			setElementPosition(this.radioButton, this.labelDisplay.x + this.labelDisplay.width, radioButtonY);
			
			// attempt to truncate the text now that we have its official width
			labelDisplay.truncateToFit();
			
		}
		
		/**
		 * @private 
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			// select the Radio Button
			this.radioButton.selected = this.selected
		}
		
	}
}