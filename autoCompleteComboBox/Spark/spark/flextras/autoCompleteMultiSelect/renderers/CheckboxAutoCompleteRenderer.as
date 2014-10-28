/*
Copyright 2014 DotComIt, LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

*/

package spark.flextras.autoCompleteMultiSelect.renderers
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import spark.components.CheckBox;
	import spark.flextras.autoCompleteComboBox.renderers.DefaultAutoCompleteRenderer;
	
	
	
	/**
	 * An ItemRenderer that includes a label for displaying text and a checkbox.  
	 * Toggling the Checkbox will cause the List this is used in to select, or deselect the item
	 * Built for use with the AutoCompleteMultiSelect, but in theory could be used anywhere
	 * 
	 * @see spark.flextras.autoCompleteComboBox.AutoCompleteMultiSelect
	 * @see spark.flextras.autoCompleteComboBox.renderers.IAutoCompleteRenderer
	 * @see spark.flextras.autoCompleteMultiSelect.renderers.DefaultAutoCompleteRenderer
	 */
	public class CheckboxAutoCompleteRenderer extends DefaultAutoCompleteRenderer
	{

		/**
		 *  Constructor.
		 */
		public function CheckboxAutoCompleteRenderer()
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownClickHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  lifecycle methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 */
		override protected function createChildren():void
		{
			
			super.createChildren();
			
			if(!checkbox){
				checkbox = new CheckBox();
				addChild(checkbox);
			}
			
		}
		
		
		/**
		 *  @private
		 */
		override protected function measure():void
		{
			super.measure();
			
			// label has padding of 3 on left and right and padding of 5 on top and bottom.
			measuredWidth += this.checkbox.getPreferredBoundsWidth() ;
			measuredHeight = Math.max(measuredHeight,this.checkbox.getPreferredBoundsHeight());
			
			measuredMinWidth += this.checkbox.getMinBoundsWidth();
			measuredMinHeight = Math.max(measuredMinHeight,this.checkbox.getMinBoundsHeight() );
		}
		
		
		/**
		 * @private  
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			
			setCheckboxState();
			
			// position and size the checkbox
			var checkboxX :int = 3;
			var checkboxY :int = Math.max((unscaledHeight-checkbox.getPreferredBoundsHeight() )/2);
			
			this.checkbox.setLayoutBoundsSize(this.checkbox.getPreferredBoundsWidth() , this.checkbox.getPreferredBoundsHeight());
			this.checkbox.move(checkboxX, checkboxY );
			
			// call super 
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			// reposition the labelDisplay 
			var labelDisplayX :int = 3+this.checkbox.getPreferredBoundsWidth();
			var labelDisplayY :int = Math.max((unscaledHeight-labelDisplay.getPreferredBoundsHeight() )/2);
			this.labelDisplay.setLayoutBoundsPosition(3+this.checkbox.getPreferredBoundsWidth(), 5);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Skin Parts (or they would be if this was a Skinnable Component)
		//
		//--------------------------------------------------------------------------
		
		/**
		 * This represents the checkbox that will be displayed.  The selected state of the checkbox will be set based on the selected property of the renderer
		 */
		protected var checkbox :CheckBox;

		
		//--------------------------------------------------------------------------
		//
		//  Properties 
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * helper function to set the checkbox state 
		 * @private 
		 * 
		 */
		protected function setCheckboxState():void{
			this.checkbox.selected = this.selected;
		}


		/**
		 * 
		 * This will intercept the mouse click
		 * if the checkbox was clicked and the renderer's item is selected (as told by the selected property) thyen force the ctrlKey to true as part of the event 
		 * which will cause the item to be deselected in the list class
		 * 
		 * @private 
		 * 
		 */
		protected function onMouseDownClickHandler(event:MouseEvent):void
		{
			if(event.target == this.checkbox){
				// always turn on the control key
				// this means other items won't be selected if the user clicks ont he checkbox 
				// but things operate normally if you do click on the checkbox
				event.ctrlKey = true;
			}
		}
		
		
	}
}