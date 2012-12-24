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
package spark.flextras.autoCompleteComboBox
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import flashx.textLayout.operations.CopyOperation;
	import flashx.textLayout.operations.CutOperation;
	import flashx.textLayout.operations.DeleteTextOperation;
	import flashx.textLayout.operations.FlowOperation;
	
	import mx.collections.ListCollectionView;
	import mx.core.ClassFactory;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	
	import spark.components.ComboBox;
	import spark.events.DropDownEvent;
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
	import spark.flextras.autoCompleteComboBox.renderers.DefaultAutoCompleteRenderer;
	import spark.flextras.autoCompleteComboBox.renderers.IAutoCompleteRenderer;

	use namespace mx_internal;
	
	/**
	 * The Flextras AutoCompleteComboBoxLite is a native Spark Flex component built to provide AutoComplete functionality in your Flex Applications.
	 * <br/><br/>
	 * AutoComplete is sometimes called AutoSuggest.  When the user types, a list of options, your dataProvider, is filtered and the typed text is highlighted in the drop down list.  If you want to customize styling in the list, you can create your own itemRenderer to do so.  
	 * <br/><br/>
	 * It is available as a free component, in accordance with the Flextras Licensing Agreement.
	 * 
	 * @see spark.components.ComboBox 
	 * @see spark.flextras.autoCompleteComboBox.renderers.IAutoCompleteRenderer
	 */
	public class AutoCompleteComboBoxLite extends ComboBox
	{
		/**
		 *  Constructor.
		 */
		public function AutoCompleteComboBoxLite()
		{
			super();
			this.addEventListener(IndexChangeEvent.CHANGE, onChange);
			this.itemRenderer = new ClassFactory(DefaultAutoCompleteRenderer);
		}
		
		//--------------------------------------------------------------------------
		//
		//  lifecycle methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @private  
		 */
		override protected function commitProperties():void{
			
			// Keep track of whether selectedIndex was programmatically changed
			// if this condition is true then the textInput.text will be reset in the super method
			// we may not want to blank out textInput.text for autoComplete purposes, so we use this variable to correct that.
			var selectedIndexChanged:Boolean = _proposedSelectedIndex != NO_PROPOSED_SELECTION;

			// do any selectedIndex changes here before we call super
			// if we make selectedIndex changes after calling super, commitProperties will not run again
			// causing all sorts of weird issues allowing users to interact with the values while there are 
			// lingering selectedIndex/selectedItem changes 
			if(filterDataProvider == true){
				// this code block moved out refreshDataProvider method
				// if we're typing new, or more, be sure to reset the selectedIndex 
				// in halo comboBox setting selectedIndex actually changed the selectedIndex
				// here it just sets a proposed index which is then reset in commitProperties 

				// if the selectedIndexChanged then do nothing, it'll reset to it's proper location
				// if the selectedIndex didn't change, then deselect whatever was selected. 
				if(selectedIndexChanged == false){
					if(this.selectedIndex != NO_SELECTION){
						this.selectedIndex = NO_SELECTION;
						// why are there so many versions of what could be the selected Index?  
						// it took me 2 hours to figure out that this is the cause of a bug
						// if selecting an item [however it is selected] and then using backspace to slowly remove characters
						// this stores the selectedItem's index in the "unfiltered" dataProvider
						// then start hitting the backspace key to remove letters
						// once the drop down is large enough to have "selectedItem's index" amount of items 
						// that item would show as if it were selected even though selectedIndex is -1 and nothing is selected
						this.userProposedSelectedIndex = NO_SELECTION;
						// commit the selection immediately
						commitSelection();

					}
				}
			} 

			super.commitProperties();
			
			if(filterDataProvider == true){
				// if the super wiped out the textInput.text value, which it will do if the selectedIndex has changed
				// be sure to reset it before filtering the dataPRovider
				// can probably accomplish this by moving filtering code under next code block which resets the values 
				// actually we can't because textInput.text may be wiped out even if selectedIndex didn't change; not sure why 
				// though, seems to be a side effect of something else that may have occurred.  
				if((this.textInput.text == '') && (this.typeAheadText != '')){
					this.textInput.text = this.typeAheadText;
				}
				
				// refreshing the dataProvider may screw up the selectedIndex values, so store the pendingSelectedItem here
				var tempSelectedItem : *;
				if(this.selectedItem){
					tempSelectedItem = this.selectedItem;
				}
				
				this.refreshDataProvider();
				
				// if the _pendingSelectedItem is not undefined; we may to reset it
				if(tempSelectedItem){
					this.selectedItem = tempSelectedItem;
					// we are manually calling super.commitProperties because that is the best way to reuse the 
					// super code to use the nw selectedItem to set the selectedIndex 
					// thank you private variables 
					super.commitProperties();
				}

				filterDataProvider = false;
			}
			
			// in some situations, the textInput.text will be blanked out
			// This occurs, programatically if the selectedIndex has changed to something other than NO_PROPOSED_SELECTION/-2
			// This is in here b/c of this bug: 
			// select an item from ComboBox 'Alabama' and everything is good
			// then type a q after Alabama. making the typeAheadText 'Alabamaq' which will remove everything from the list; that's good
			// and then also cause this method to reset the textInput.text to '' instead of 'Alabamaq', and that's bad.
			if((selectedIndexChanged) ){
				if (selectedIndex == NO_SELECTION) {
					if((this.textInput.text != this.typeAheadText) ){
						this.textInput.text = this.typeAheadText;
					}
					
				} else if ((selectedIndex >= 0) && (this.textInput.text == '')){
					// in some sitautions, an item is selected, but the textInput.text is not properly updated
					// This happens when selecting something w/ arrow keys and clicking enter.  Internally, we use selectedItem
					// to store that item.  So check should fix that
					updateLabelDisplay();
				}
				
			}
			
		}
		
		/**
		 * @private  
		 * 
		 */
		override protected function partAdded(partName:String, instance:Object):void{
			super.partAdded(partName, instance);
		}
		
		/**
		 * @private  
		 */
		override protected function partRemoved(partName:String, instance:Object):void{
			super.partRemoved(partName, instance);
		}

		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * This tells us to filter the dataProvider during the next renderer event.  
		 */
		protected var filterDataProvider : Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		
		//----------------------------------
		//  filterFunction 
		//----------------------------------
		/**
		 * @private
		 */
		private var _filterFunction : Function = autoCompleteFilter;
		
		[Bindable("filterFunctionChanged")]
		[Inspectable(category="AutoComplete", defaultValue="autoCompleteFilter",name="AutoComplete Filter Function",type="Function")]
		/**
		 * This property defines the filter function used to filter the <code>dataProvider</code> for AutoComplete purposes.  
		 * <br/>
		 * A filterFunction is expected to have the following signature:
		 * <pre>f(item:Object):Boolean</pre>
		 * where the return value is <code>true</code> if the specified item should remain in the drop down.
		 * 
		 *  @default autoCompleteFilter
		 * @see mx.collections.ListCollectionView#filterFunction
		 */
		public function get filterFunction  (): Function {
			return this._filterFunction;
		}
		
		/**
		 * @private
		 */
		public function set filterFunction (value:Function):void{
			this._filterFunction = value;
			dispatchEvent(new Event("filterFunctionChanged"));
		}
		
		//----------------------------------
		//  typeAheadText 
		//----------------------------------
		/**
		 * @private
		 * private holder for the type ahead text 
		 */
		private var _typeAheadText : String = '';
		
		[Bindable("typeAheadTextChanged")]
		/**
		 * This property keeps track of the characters that the user typed.  
		 * This value will reset when the user selects an item from the drop down or when the user clears out the text 
		 * in the AutoComplete input.  
		 * If your itemRenderer implements the IAutoCompleteRenderer interface, you can access this value from 
		 * an <code>itemRenderer</code> using the typeAheadText property.
		 * 
		 *  @default ''
		 * 
		 * @see spark.flextras.autoCompleteComboBox.renderers.IAutoCompleteRenderer
		 */
		public function get typeAheadText():String{
			return this._typeAheadText;
		}
		
		/**
		 * @private 
		 * A helper function for setting the type ahead Text value; 
		 */
		protected function setTypeAheadText(value : String):void{
			this._typeAheadText = value;
			this.dirtyDataProviderFilter();
			this.invalidateProperties();
			this.dispatchEvent(new Event('typeAheadTextChanged'));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/**
		 * This is the default filter function for AutoComplete functionality.  
		 * It uses a regular expression to search through the label text to filter values.
		 * @param item The item from your dataProvider that is going to be investigated for filtering purposes.
		 * 
		 * @return <code>true</code> if the item meets the filter criteria, <code>false</code> otherwise.
		 * 
		 * @see #autoCompleteFilterFunction
		 * @see mx.collections.ListCollectionView#filterFunction
		 */
		protected function autoCompleteFilter ( item:Object):Boolean{
			// regular expression should be: 
			// any number of characters + Our String in sequence + any number of character
			//  The '/' is the literal character
			// the '\' is the escape character
			// '*' is a quantifier specifies any number of X
			//  /i means ignore case sensitivity 
			// 	\						 /typeAheadText/ 
			//		var regEx : RegExp = /  /i
//			var regEx : RegExp = new RegExp('.*' + this.typeAheadText + '.*' ,'i')
//			var regEx : RegExp = new RegExp('.*' + this.textInput.text + '.*' ,'i')
			var regEx : RegExp = new RegExp('.*' + this.typeAheadText + '.*' ,'i')
			
			// probably want to use match on this string
			var label : String = this.itemToLabel(item);
			
			if(label.match(regEx)){
				return true;
			}
			
			return false;
		}
		

		/**
		 * @private
		 * This is a helper function to force the next render event to filter the dataProvider 
		 */
		protected function dirtyDataProviderFilter():void{
			this.filterDataProvider = true;
			this.invalidateProperties();
		}
		
		
		/**
		 * @private
		 * this is an overriden method that will pass data into the renderer
		 * if the renderer implements the IAutoCompleteRenderer interface. 
		 */
		override public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void{
			if(renderer is IAutoCompleteRenderer){
				var acRenderer : IAutoCompleteRenderer =  renderer as IAutoCompleteRenderer;
				acRenderer.autoCompleteComboBox = this;
				acRenderer.typeAheadText = this.typeAheadText;
			}
			super.updateRenderer(renderer, itemIndex, data);
		}
		
		
		/**
		 * @private
		 * Very Loosely based off the Halo ACCB filterDataPRovider method. 
		 * This is a helper function used for filtering the dataProvider.
		 * It dispatches events, but for the purposes of this lite component [and time] they are completely
		 * undocumented. 
		 */	
		protected function refreshDataProvider():void{

			// filter the dataProvider
			var dp : ListCollectionView= ListCollectionView(this.dataProvider);
			dp.filterFunction = this.filterFunction;
			
			var filterBeginEvent : AutoCompleteCollectionEvent = new AutoCompleteCollectionEvent(AutoCompleteCollectionEvent.AUTOCOMPLETE_DATAPROVIDER_FILTER_BEGIN, this.filterFunction,false,true)
			dispatchEvent(filterBeginEvent);
			if(!filterBeginEvent.isDefaultPrevented()){
				
				// if textInput.text is empty it is because an item was just selected and we are resetting the 
				// dataProvider.  Close the drop down if it's open
				if((this.textInput.text == '') && (this.isDropDownOpen)){
					this.closeDropDown(false);
				}
				
				dp.refresh();
				dispatchEvent(new AutoCompleteCollectionEvent(AutoCompleteCollectionEvent.AUTOCOMPLETE_DATAPROVIDER_FILTERED, this.filterFunction));
				
			}
			
		}
		
		/**
		 * @private  
		 * handler for when the index changes, which means something was selected (probably)
		 * If so, then reset the type ahead text, and filter the dataProvider to reset all items.
		 * In the mx AutoComplete we could just store the selectedItem, do the filtering, and reset the selectedItem
		 * But, because changing the selectItem/Index is deferred to commitProperties in this implementation that 
		 * approach doesn't work here.
		 * 
		 * Problem is that this method is triggered from commitProperties and changing the typeAheadText needs to trigger
		 * commitProperties again to force the filter of the dataProvider.  But, invalidating properties from inside 
		 * commitProperties doesn't cause commitProperties to be re-run during the next render event causing me all sort of 
		 * headaches.  
		 */
		protected function onChange(event:IndexChangeEvent):void{
			if((event.oldIndex < 0) && (event.newIndex >= 0)){
				this.setTypeAheadText('');
			}
		}

		/**
		 *  @private 
		 * this is the change handler for when the user types something into the TextInput
		 * Completely rewritten from what happens in the parent.  We don't call super.
		 */ 
		override protected function textInput_changeHandler(event:TextOperationEvent):void
		{  
			
			// if make copy operation; do nothing
			if(event.operation is CopyOperation){
				return;
			}

			
			this.setTypeAheadText(textInput.text);
			
			// turns out in the context of the AutoCompleteComboBox
			// if any text changes we want to open the drop down
			if (openOnInput)
			{
				// JH DotComIt 11/25/2011
				// if someone tabs into the component and deletes all text 
				// the popup shouldn't open 
				if(textInput.text == ''){
					// this fixes a bug where the drop down would not close when all text was 
					// deleted 
					if( isDropDownOpen ){
						closeDropDown(false);
					}
					return;
				}
				

				
				// JH DotComIt 11/25/2011
				// if someone tabs into the component and deletes all text 
				// the popup shouldn't open 
				if ((!isDropDownOpen) )
				{
					// Open the dropDown if it isn't already open
					openDropDown();
					return;
				} else if (this.typeAheadText == ''){
					// if nothing is entered and typeAheadText is empty, close it
					closeDropDown(false);
				}

			}
			
		}
		
		
		/**
		 *  @private
		 *  Weird bug w/ our AutoComplete and this functionality
		 * Flex 4.5 List tries to scroll the list to a certain position and select that 'saved' position after the 
		 * dataProvider is refreshed. 
		 * 
		 * Of coures, in our AutoComplete, we refresh the dataProvider w/ every keystroke; so in certain situations
		 * this causes a bug.  
		 * Doesn't cause a bug in ComboBox because dataProvider is not refreshed internally.
		 * 
		 * For our purposes; we'll just do nothing here.
		 * 
		 */
		override mx_internal function dataProviderRefreshed():void
		{
			// do nothing 
		}
		
		
		/**
		 * @private 
		 * There is a bug if someone hits the escape key  It clears out the text w/o resetting the type ahead text
		 * This makes sure that situation is ignored 
		 */
		override mx_internal function keyDownHandlerHelper(event:KeyboardEvent):void
		{
			
/*			if (event.keyCode == Keyboard.ESCAPE)
			{
				return;
			}*/
			super.keyDownHandler(event);
		}
		
	}
}