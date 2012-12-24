package com.flextras.mobile.autoCompleteComboBox
{
	import com.flextras.mobile.autoCompleteComboBox.renderers.DefaultAutoCompleteRenderer;
	import com.flextras.mobile.autoCompleteComboBox.skins.AutoCompleteComboBoxMobileSkin_Default;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.core.ClassFactory;
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.core.InteractionMode;
	import mx.core.mx_internal;
	import mx.styles.CSSStyleDeclaration;
	
	import spark.events.RendererExistenceEvent;
	import spark.events.TextOperationEvent;
	import spark.flextras.autoCompleteComboBox.AutoCompleteComboBoxLite;

	use namespace mx_internal;
	
	
	//	When the drop down is open with an item selected, the component class will scroll the drop down so that the selected item 
	// is at the top of the view.  If the last item in the dataProvider is selected, by default, only one item 
	// is shown on screen.  This style is used in the component class to modify the scroll value in these 
	// situations, so that only one item is shown.
	/**
	 * A style used in the default skin to specify the number of items to display in the drop down.  
	 * <br/><br/>
	 * The default value is four, because this seemed like a good list size on a touch screen with the soft 
	 * keyboard displayed.
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
	 * The Flextras Mobile AutoCompleteComboBoxLite is a native Spark Flex component built to provide AutoComplete functionality in your mobile Flex Applications.
	 * <br/><br/>
	 * AutoComplete is sometimes called AutoSuggest.  
	 * When the user types, a list of options, your dataProvider, is filtered and the typed text is highlighted in the drop down list.  
	 * If you want to customize styling in the list, you can create your own itemRenderer to do so.  
	 * 
	 * @author www.flextras.com
	 * 
	 * @see spark.flextras.autoCompleteComboBox.AutoCompleteComboBoxLite 
	 * @see spark.components.ComboBox 
	 * @see spark.flextras.autoCompleteComboBox.renderers.IAutoCompleteRenderer
	 */
	public class AutoCompleteComboBoxMobile extends AutoCompleteComboBoxLite
	{ 
		public function AutoCompleteComboBoxMobile()
		{
			super();
			itemRenderer = new ClassFactory(com.flextras.mobile.autoCompleteComboBox.renderers.DefaultAutoCompleteRenderer);
		}
		
		// use the default method to set styles 
		// using this approach here http://help.adobe.com/en_US/flex/using/WS2db454920e96a9e51e63e3d11c0bf687e7-7ff6.html
		// Define a static variable.
		private static var classConstructed:Boolean = classConstruct();
		
		// Define a static method.
		private static function classConstruct():Boolean {
			if (!FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("com.flextras.mobile.autoCompleteComboBox.AutoCompleteComboBoxMobile"))
			{
				// If there is no CSS definition for this component, then create one define the default style values
				// the ones not defined here are just inherited 
				
				var myStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
				myStyle.setStyle("interactionMode", InteractionMode.TOUCH);
				myStyle.setStyle("borderVisible", true);
				myStyle.setStyle('contentBackgroundColor',0xFFFFFF);
				myStyle.setStyle('skinClass',com.flextras.mobile.autoCompleteComboBox.skins.AutoCompleteComboBoxMobileSkin_Default);
				// used for the drop down in the mobile skin 
				myStyle.setStyle('requestedRowCount',4);
				
				FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration("com.flextras.mobile.autoCompleteComboBox.AutoCompleteComboBoxMobile", myStyle, true);
				
			}
			
			return true;
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
			}
			
			super.partRemoved(partName, instance);
		}		
		
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
		 * 
		 */
		override protected function item_mouseDownHandler(event:MouseEvent):void
		{
			// do nothing because mouse up and mouse down handlers don't work quite right on mobile devices 
			// rewrote all of this to use the click event 
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
			// throws error if no dataProvider specified
			if(this.dataProvider){
				if(index >= this.dataProvider.length-requestedRowCount){
					// if the index is one of the last four items in the list 
					// then w make sure not to scroll to the last item in the list
					// that 'four' number shouldn't be hard coded
					index = this.dataProvider.length-requestedRowCount;
				}
			}
			
			super.positionIndexInView(index, topOffset, bottomOffset, leftOffset, rightOffset);

		}		
		
		
		/**
		 *  @private 
		 * If the user is deleting a character, leaving no type ahead text; the drop down is still opening.  It shouldn't!
		 * We should verify this isn't a bug in the Spark AutoComplete that we just found now; as opposed to a 
		 * mobile specific bug 
		 */ 
		override protected function textInput_changeHandler(event:TextOperationEvent):void
		{  
			
			if(openOnInput){
				if(!isDropDownOpen){
					// can't check against type ahead text because it isn't set yet; so check directly against the actual typed text
					if(textInput.text == ''){
						return;
					}
				}
			}
			super.textInput_changeHandler(event);
			
		}		
		
	}
}