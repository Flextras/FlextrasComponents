package com.flextras.mobile.autoCompleteComboBox.renderers
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import spark.components.LabelItemRenderer;
	import spark.flextras.autoCompleteComboBox.AutoCompleteComboBoxLite;
	import spark.flextras.autoCompleteComboBox.renderers.IAutoCompleteRenderer;
	
	/**
	 * @private 
	 * 
	 * This is an alternate renderer for the Flextras Mobile DropDownList Component.  
	 * In addition to the label, it also displays a radio button, similar to native mobile DopDownList components.
	 * 
	 * @author www.flextras.com
	 * 
	 */
	public class DefaultAutoCompleteRenderer extends LabelItemRenderer implements IAutoCompleteRenderer
	{
		public function DefaultAutoCompleteRenderer()
		{
			super();
			this.addEventListener(FlexEvent.DATA_CHANGE, onDataChange);
		}
		
		//----------------------------------
		//  autoCompleteComboBox
		//----------------------------------
		/**
		 * @private
		 */
		private var _autoCompleteComboBox : AutoCompleteComboBoxLite;
		
		[Bindable("autoCompleteCombooxChanged")]
		/**
		 * @inheritDoc
		 */
		public function get autoCompleteComboBox():AutoCompleteComboBoxLite
		{
			return this._autoCompleteComboBox;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set autoCompleteComboBox(value:AutoCompleteComboBoxLite):void
		{
			this._autoCompleteComboBox = value;
			this.dispatchEvent(new Event('autoCompleteCombooxChanged'));
		}
		
		
		//----------------------------------
		//  typeAheadText
		//----------------------------------
		/**
		 * @private
		 */
		private var _typeAheadText : String;
		
		[Bindable("typeAheadTextChanged")]
		/**
		 * @inheritDoc
		 */
		public function get typeAheadText():String
		{
			return this._typeAheadText;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set typeAheadText(value:String):void
		{
			this._typeAheadText = value;
			this.dispatchEvent(new Event('typeAheadTextChanged'));
		}
		
		/**
		 * @private
		 * Helper function for changing the data and updating the 
		 */
		protected function onDataChange(event:FlexEvent):void{
			
			if(this.typeAheadText != ''){
				// the mobile approach; which is same as Halo approach; because TLF in Mobile is bad;
				// how strange that things have come full circle to some extent 
				// adding G flag to the RegExp would replace all instances instead of just first one 
				// removed it because it does not seem to be standard 
				var regEx : RegExp = new RegExp(this.typeAheadText ,'i');
				//					this.htmlText = data.label.replace(regEx , '<b>$&</b>');
				this.labelDisplay.htmlText = this.autoCompleteComboBox.itemToLabel(data).replace(regEx , '<b>$&</b>');
				
			} else {
				if(this.autoCompleteComboBox){
					this.labelDisplay.text = this.autoCompleteComboBox.itemToLabel(data);
				} else {
					// this situation should never occur 
					this.labelDisplay.text = 'Unknown Error'
				}
			}
			
			
		}
		
		override protected function measure():void{
			super.measure();
			// how bizarre that measure is removing the HTML formatting.
			// So if you close the drop down w/ text typed; then open it you lose all formatting
			// based on typeAheadText
			// it occurs in the StyleableTextField.setTextFormat() method.  
			// but this fixes it
			this.onDataChange(new FlexEvent('dummyEvent'));
			
		}

		
	}
}