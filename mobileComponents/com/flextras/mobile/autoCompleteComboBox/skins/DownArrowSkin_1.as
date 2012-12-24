package com.flextras.mobile.autoCompleteComboBox.skins
{
	import flash.display.DisplayObject;
	
	import com.flextras.mobile.autoCompleteComboBox.AutoCompleteComboBoxMobile;
	import com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile160.DownArrow_down_1;
	import com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile160.DownArrow_up_1;
	import com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile240.DownArrow_down_1;
	import com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile240.DownArrow_up_1;
	import com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile320.DownArrow_down_1;
	import com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile320.DownArrow_up_1;
	
	import mx.core.DPIClassification;
	
	import spark.components.supportClasses.ButtonBase;
	import spark.skins.mobile.supportClasses.MobileSkin;
	import spark.skins.mobile160.assets.Button_down;
	import spark.skins.mobile160.assets.Button_up;
	import spark.skins.mobile320.assets.Button_down;
	import spark.skins.mobile320.assets.Button_up;
	
	/**
	 * This is an alternate skin for the open button of the Flextras Mobile AutoComplete Component.
	 * It is not modeled after the mobile ButtonSkin, instead putting all graphical assets in an external FXG file.
	 * 
	 * @author www.flextras.com
	 * 
	 * @see com.flextras.mobile.autoCompleteComboBox.AutoCompleteComboBox
	 */
	public class DownArrowSkin_1 extends MobileSkin
	{
		public function DownArrowSkin_1()
		{
			super();
			// this uses the application DPI to decide which FXG assets to use. 
			// FXG assets are sized differently based on the DPI values.
			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					upSkin = com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile320.DownArrow_up_1;
					downSkin = com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile320.DownArrow_down_1;
					
					break;
				}
				case DPIClassification.DPI_240:
				{
					upSkin = com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile240.DownArrow_up_1;
					downSkin = com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile240.DownArrow_down_1;
					
					break;
				}
				default:
				{
					// default DPI_160
					upSkin = com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile160.DownArrow_up_1;
					downSkin = com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile160.DownArrow_down_1;
					
					break;
				}
			}

		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		// not going to create the iconDisplaySkinPart or labelDisplay skin part
		// neither are required in the Button class and neither are needed for this skin
		
		/**
		 * This is a class to use for the button’s state.  
		 * It will swap between the upSkin value and the downSkin value.
		 * 
		 * @see #upSkin
		 * @see #downSkin
		 *  @see #getButtonClassForCurrentState()
		 */
		protected var buttonClass : Class;

		/**
		 *  This is a reference to the FXG Graphic used for the button’s graphical elements.  
		 * You can use getButtonClassForCurrentState() to specify a graphic per-state.
		 * 
		 */
		protected var buttonSkin:DisplayObject;
		

		
		/**
		 * @private
		 * A change value that tells the button to change ths FXG Skin during the next render event.
		 */
		protected var changeFXGSkin:Boolean = false;
		

		/**
		 *  @private
		 *  Flag that is set when the currentState changes from enabled to disabled.
		 */
		protected var enabledChanged:Boolean = false;


		//-------------------
		// hostComponentProperty
		//-------------------
		/**
		 * @private
		 */
		private var _hostComponent:ButtonBase;
		
		/**
		 * @copy spark.skins.spark.ApplicationSkin#hostComponent
		 */
		public function get hostComponent():ButtonBase
		{
			return _hostComponent;
		}
		
		/**
		 * @private
		 */
		public function set hostComponent(value:ButtonBase):void
		{
			_hostComponent = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Layout variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * This variable contains a reference to the class which contains the FXG asset for this button's up state.
		 */
		protected var upSkin:Class;
		/**
		 * This variable contains a reference to the class which contains the FXG asset for this button's down state.
		 */
		protected var downSkin:Class;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		/**
		 *  @private
		 */
		override public function set currentState(value:String):void
		{
			var isDisabled:Boolean = currentState && currentState.indexOf("disabled") >= 0;
			
			super.currentState = value;
			
			// I only imagine I must have copied this approach from somewhere; most likely the 
			// actual mobile button skin.  
			if (isDisabled != currentState.indexOf("disabled") >= 0)
			{
				enabledChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 *  @private 
		 */
		override protected function commitCurrentState():void
		{   
			super.commitCurrentState();
			
			// get the button class based on the current state
			this.buttonClass = getButtonClassForCurrentState();
			
			// if the buttonSkin has changed, we want to update it in updatedisplayList
			if (!(buttonSkin is buttonClass)){
				changeFXGSkin = true;
			}
			
			// update borderClass and background
			this.invalidateSize();
			this.invalidateDisplayList();
		}
		
		/**
		 *  @private
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (enabledChanged)
			{
				commitDisabled();
				enabledChanged = false;
			}
		}
		
		/**
		 *  @private
		 * This method is here really as a formality; because in the skins that we provide that use the buttons
		 * we are setting the size of the button.
		 */
		override protected function measure():void
		{
			super.measure();

			var w:Number = 0;
			var h:Number = 0;
			if(this.buttonSkin){
				w = this.buttonSkin.width;
				h = this.buttonSkin.height;
			} else {
				// this is kind of a random choice; based on the height of the TextInput in the emulator
//				w = 65;
//				h = 65;
				switch (applicationDPI)
				{
					case DPIClassification.DPI_320:
					{
						w = 64;
						h = 86;
						
						break;
					}
					case DPIClassification.DPI_240:
					{
						// setting these values based on the default button Skin's sizing
						w = 48;
						h = 65;
						
						break;
					}
					default:
					{
						// default DPI_160
						w = 32;
						h = 43;
						
						break;
					}
				}
			}
			// measuredMinHeight for width and height for a square measured minimum size
			measuredMinWidth = h;
			measuredMinHeight = h;
			
			measuredWidth = w
			measuredHeight = h;
			
		}
		
		/**
		 *  @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			// change the FXG assets if they need to change
			if (changeFXGSkin)
			{
				changeFXGSkin = false;
				
				if (this.buttonSkin)
				{
					// destroy the asset
					removeChild(this.buttonSkin);
					this.buttonSkin = null;
				}
				
				if (this.buttonClass)
				{
					// recreate--or create--the asset
					this.buttonSkin = new buttonClass();
					addChildAt(this.buttonSkin, 0);
				}
			}
			
			// size and position the asset if it exists.
			// I'm not sure what the situation is where it wouldn't exist; but better safe than sorry
			if(this.buttonSkin){
				setElementSize(this.buttonSkin, unscaledWidth, unscaledHeight);
				setElementPosition(this.buttonSkin, 0, 0);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		/**
		 * @private
		 *  Commit alpha values for the skin when in a disabled state.
		 *
		 *  @see mx.core.UIComponent#enabled
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		protected function commitDisabled():void
		{
			alpha = hostComponent.enabled ? 1 : 0.5;
		}

		/**
		 *  This method returns the button FXG Asset to use based on the currentState.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5 
		 *  @productversion Flex 4.5
		 */
		protected function getButtonClassForCurrentState():Class
		{
			if (currentState == "down") 
				return this.downSkin;
			else
				return this.upSkin;
		}
		
	}
}