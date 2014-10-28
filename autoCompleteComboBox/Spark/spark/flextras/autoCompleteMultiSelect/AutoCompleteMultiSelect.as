package spark.flextras.autoCompleteMultiSelect
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	
	import spark.components.IItemRenderer;
	import spark.components.TextInput;
	import spark.events.DropDownEvent;
	import spark.events.IndexChangeEvent;
	import spark.flextras.autoCompleteComboBox.AutoCompleteComboBoxLite;
	import spark.utils.LabelUtil;

	use namespace mx_internal;

	/**
	 * The Flextras AutoCompleteMultiselect is a native Spark Flex component built to provide a ComboBox that allows multiple items to be selected in your Flex Applications.
	 * <br/><br/>
	 * There are two skins provided for this component: AutoCompleteMultiSelectSkin ComboBoxMultiSelectSkin.  
	 * <br/><br/>
	 * The AutoCompleteMultiSelectSkin provdies autocomplete functionality similar to the AutoCompleteCombobox.  AutoComplete is sometimes called AutoSuggest.  When the user types, a list of options, your dataProvider, is filtered and the typed text is highlighted in the drop down list.  If you want to customize styling in the list, you can create your own itemRenderer to do so.  
	 * <br/><br/>
	 * The ComboBoxMultiSelectSkin works similar to a DropDownList, but allows for multiple items to be selected in the drop down.  It does not provide AutoComplete or look ahead functionality.
	 * <br/><br/>
	 * This package also includes a Checkbox renderer which can be used as an alternate renderer.  It displays a checkbox along with the item's label.  Clicking on the checkbox will select, or deselect the item.
	 * <br/><br/>
	 * It is available as a free component under the Apache 2.0 license.
	 * 
	 * @see spark.components.ComboBox 
	 * @see spark.flextras.autoCompleteComboBox.AutoCompleteComboBoxLite
	 * @see spark.flextras.autoCompleteComboBox.renderers.IAutoCompleteRenderer
	 * @see spark.flextras.autoCompleteMultiSelect.renderers.CheckboxAutoCompleteRenderer
	 * @see spark.flextras.autoCompleteMultiSelect.AutoCompleteMultiSelectSkin
	 * @see spark.flextras.autoCompleteMultiSelect.ComboBoxMultiSelectSkin
	 */
	public class AutoCompleteMultiSelect extends AutoCompleteComboBoxLite
	{
		public function AutoCompleteMultiSelect()
		{
			super();
			this.setStyle('skinClass',spark.flextras.autoCompleteMultiSelect.AutoCompleteMultiSelectSkin);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Lifecycle methods
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 * @private  
		 */
		override protected function commitProperties():void{
			// save the oldFilterDataProvider; if it changes then re-call commitSelection;
			var oldFilterDataProvider :Boolean = this.filterDataProvider;
			
			super.commitProperties();
			
			// If the Fitler dataProvider property changes; then dataProvider was filtered; potentially knocking selectedIndices and savedSelectedItems out of sync 
			// we need to modify selectedIndices and then call commitSelection because commitSelection was bypassed otherwise
			if(oldFilterDataProvider != this.filterDataProvider){
				var newSelectedIndices : Vector.<int> = resetSelectedIndices();
				
				this.setSelectedIndices(newSelectedIndices);
				// setSelectedIndices will inavlidate properties; but since we're in commitProperties commitProperties is not rerun
				// so manually call commitSelection here in order to force the selection to be committed.
				this.commitSelection();
			}
			
			// this will prevent the selected item from ever showing up in the autocomplete textInput, which should only show the type ahead text
			if(this.textInput){
				this.textInput.text = this.typeAheadText;
			}
		}
		
		/**
		 * @private  
		 * 
		 */
		override protected function partAdded(partName:String, instance:Object):void{
			super.partAdded(partName, instance);

			// make sure that the selectedLabelDisplay is not editable
			// it will display all the selected items 
			if(instance == this.selectedLabelDisplay){
				this.selectedLabelDisplay.editable = false;
			}
			
		}
		
		/**
		 * @private  
		 */
		override protected function partRemoved(partName:String, instance:Object):void{
			super.partRemoved(partName, instance);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//--------------------------------------------------------------------------    
		/**
		 *  Optional skin part that holds the input text or the selectedItem text. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4.11
		 */
		[SkinPart(required="false")]
		public var selectedLabelDisplay:TextInput;

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private 
		 * magic stuff so we can have our own _proposedSelectedIndices so we can do override commitMultipleSelection to keep savedSelectedItems up to date 
		 * We can't override or use the paren'ts _proposedSelectedIndices becacuse it is private
		 * Yay private variables 
		 */
		private var _proposedSelectedIndices:Vector.<int> = new Vector.<int>(); 

		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var _delimiter :String = ",";
		
		/**
		 * 
		 * @return 
		 * 
		 */
		[Bindable("delimiterChanged")]
		[Inspectable(category="AutoCompleteMultiselect", defaultValue=",",name="Multiselect Delimiter",type="String")]
		/**
		 * This property specifies the delimiter used to separated multiple selected items in the label display. 
		 * 
		 *  @default ,
		 */
		public function get delimiter():String
		{
			return _delimiter;
		}
		
		/**
		 * @private
		 */
		public function set delimiter(value:String):void
		{
			_delimiter = value;
			this.dispatchEvent(new Event('delimiterChanged'));
		}
		
		
		// store selected items so they don't get get lost when the dataprovider is refreshed for aujto complete purposes
		// this probably cannot be a vector; but I'm not sure yet
		/**
		 * @private
		 */
		private var _savedSelectedItems :ArrayCollection = new ArrayCollection();
		
		[Bindable("storedSelectedItemsChanged")]
		[Inspectable(category="AutoCompleteMultiselect", defaultValue="",name="Selected Items",type="ArrayCollection")]
		/**
		 * This property will store all the items that have been selected.  
		 * This may be different than the selectedItems, because selectedItems will only display items in the dataProvider
		 * Use this property when you need to access selected items that may have been filtered out of the dataProvider by AutoComplete.
		 * <br/><br/>
		 * We did not test the setting of this value progmatically
		 * 
		 *  @default []
		 */
		public function get savedSelectedItems():ArrayCollection
		{
			return _savedSelectedItems;
		}
		
		/**
		 * @private
		 */
		public function set savedSelectedItems(value:ArrayCollection):void
		{
			_savedSelectedItems = value;
			this.dispatchEvent(new Event('storedSelectedItemsChanged'));
		}		
		
		
		/**
		 * 
		 * this is a way to effectively force allowMultipleSelection onto the list in the popup component 
		 * it will always return true 
		 * 
		 * @private
		 */
		override public function get allowMultipleSelection():Boolean
		{
			return true;
		}


		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
				
		
		/**
		 * 	turn off closing of the drop down temporarily
		 * shutting down this method makes drop down work as we want; still closes if you click outside of component
		 * or the dowen arrow
		 * but does not close when clicking on the drop down
		 * @private 
		 */
		override public function closeDropDown(commit:Boolean):void
		{
			// do nothing 
		}
		
		/**
		 * 
		 * This method removes the highlight and adds it back in
		 * we are negating this method completely by doing nothing
		 * I forget why but probably because the super was removing selection highlights when a new item was selected
		 * Since we have multi-select we don't want to remove selections when something new is selected
		 * 
		 * @private 
		 * 
		 */
		override mx_internal function changeHighlightedSelection(newIndex:int, scrollToTop:Boolean = false):void
		{
			// do nothing
		}

		
		
		
		/**
		 * 
		 * for some reason the selected property of previously selected items was causing issues, probably display issues
		 * so overriding this method top find the selectedItem solved it 
		 * We solved it by re-checking the itemIndex in the selectedIndices property; and setting selected to true if applicable
		 * 
		 * @private
		 */
		override public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void{
			super.updateRenderer(renderer, itemIndex, data);	
			
			// is the itemIndex one of the selectedIndices
			var found :Boolean = false;
			for each (var index:int in this.selectedIndices)
			{
				if(index == itemIndex){
					found = true;
					break;
				}
			}
			
			if (renderer is IItemRenderer)
			{
				IItemRenderer(renderer).selected = found;
			}
			if(renderer is UIComponent){
				UIComponent(renderer).invalidateDisplayList();
			}

		}
		

		/**
		 * Overriding this to keep _proposedSelectedIndices in sync with parent 
		 * @private 
		 */
		override mx_internal function setSelectedIndices(value:Vector.<int>, dispatchChangeEvent:Boolean = false, changeCaret:Boolean = true):void{

			if (value)
				_proposedSelectedIndices = value;
			else
				_proposedSelectedIndices = new Vector.<int>();
			
			super.setSelectedIndices(value, dispatchChangeEvent,changeCaret);
		}
		
		
		/**
		 * Overriding this to keep _proposedSelectedIndices in sync with parent 
		 * @private 
		 */
		override public function set dataProvider(value:IList):void
		{
			// Uconditionally clear the selection, see SDK-21645.  Can't wait
			// to commit the selection because it could be set again before
			// commitProperties runs and that selection gets lost.
			if (!isEmpty(_proposedSelectedIndices) || !isEmpty(selectedIndices))
			{
				_proposedSelectedIndices.length = 0;
			}
			super.dataProvider = value;
		}
		
		/**
		 * Overriding this to keep _proposedSelectedIndices in sync with parent 
		 * copied almost verbatim from List class, but still calling super 
		 * @private 
		 */
		override public function set selectedItems(value:Vector.<Object>):void
		{
			var indices:Vector.<int> = new Vector.<int>();
			
			if (value)
			{
				var count:int = value.length;
				
				for (var i:int = 0; i < count; i++)
				{
					var index:int = dataProvider.getItemIndex(value[i]);
					if (index != -1)
					{ 
						indices.splice(0, 0, index);   
					}
					// If an invalid item is in the selectedItems vector,
					// we set selectedItems to an empty vector, which 
					// essentially clears selection. 
					if (index == -1)
					{ 
						indices = new Vector.<int>();
						break;  
					}
				}
			}
			
			_proposedSelectedIndices = indices;
			
			super.selectedItems= value;
		}

		/**
		 * stolen from list class because it changtes _proposedSelectedIndices
		 * modified so this only has the code that changes the _proposedSelectedIndices and then calls super 
		 * Super will in turn call commitMultipleSelection() which we will use to keep track of the selection changes 
		 * 
		 * @private 
		 */
		override protected function commitSelection(dispatchChangedEvents:Boolean = true):Boolean
		{
			
			// if dataProvider is queued for filtering hold off on running this code until that filter is complete
			if(filterDataProvider){
				return false;
			}
		
			_proposedSelectedIndices = _proposedSelectedIndices.filter(isValidIndex);
			// Ensure that multiple selection is allowed and that proposed 
			// selected indices honors it. For example, in the single 
			// selection case, proposedSelectedIndices should only be a 
			// vector of 1 entry. If its not, we pare it down and select the 
			// first item.  
			if (!allowMultipleSelection && !isEmpty(_proposedSelectedIndices))
			{
				var temp:Vector.<int> = new Vector.<int>(); 
				temp.push(_proposedSelectedIndices[0]); 
				_proposedSelectedIndices = temp;  
			}
			// Keep _proposedSelectedIndex in-sync with multiple selection properties. 
			if (!isEmpty(_proposedSelectedIndices))
				_proposedSelectedIndex = getFirstItemValue(_proposedSelectedIndices); 

			// honestly I'm not sure if this is needed
			// In the parent this is called before calling commitMultipleSelection() but because the parent modifies commitMultipleSelection() the change is done after
			// code still seems to work with this hear, so leaving it 
			// 10/21/2014 This is needed to sync explicit sets on selectedIndex with selectedIndices; and must be done before calling super 
			// so moving this before super call whereas previously it was after it 
			if (selectedIndex > NO_SELECTION)
			{
				if (_proposedSelectedIndices && _proposedSelectedIndices.indexOf(selectedIndex) == -1){
					_proposedSelectedIndices.push(selectedIndex);
				}
			}
			
			var retVal:Boolean = super.commitSelection(dispatchChangedEvents); 

			return retVal;
		}

		
		/**
		 *
		 * stolen from the List class and will be modified 
		 * the main purpose for us is to update the savedSelectedItems and keep it in sync with selectedIndices / selectedItems 
		 * taking into account that some items in savedSelectedItems may be valid but may not be in the dataProvider
		 * 
		 * @private  
		 */
		override protected function commitMultipleSelection():void
		{
			

			var removedItems:Vector.<int> = new Vector.<int>();
			var addedItems:Vector.<int> = new Vector.<int>();
			var i:int;
			var count:int;

			// New variable to keep track of the actual item being added or removed 
			var item :Object 
			// new variaable used to keep track of the index for the item being added or removed to the savedSelectedItekms
			// used as loop counter
			var itemIndex :int
			
			//  new variable to keep track of item index from element not being processsed by the loop
			var tempItemIndex :int
			
			// borrowed code from above 
			if (!isEmpty(this.selectedIndices) && !isEmpty(_proposedSelectedIndices))
			{
				// Changing selection, determine which items were added to the 
				// selection interval 
				count = _proposedSelectedIndices.length;
				for (i = 0; i < count; i++)
				{
					if (this.selectedIndices.indexOf(_proposedSelectedIndices[i]) < 0){
						addedItems.push(_proposedSelectedIndices[i]);
					}
				}
				// Then determine which items were removed from the selection 
				// interval 
				count = this.selectedIndices.length; 
				for (i = 0; i < count; i++)
				{
					if (_proposedSelectedIndices.indexOf(this.selectedIndices[i]) < 0){
						removedItems.push(this.selectedIndices[i]);
					}
				}
			}
			else if (!isEmpty(this.selectedIndices))
			{
				// Going to a null selection, remove all
				removedItems = this.selectedIndices;
			}
			else if (!isEmpty(_proposedSelectedIndices))
			{
				// Going from a null selection, add all
				addedItems = _proposedSelectedIndices;
			}
			// end borrowed code from above 

			
			// Custom code for AutoCompleteMultiselect to keep the savedSelectedItems in sync
			for each (itemIndex in addedItems){
				// if item is not already in savedSelectedItems then add it
				item = this.dataProvider[itemIndex];
				tempItemIndex  = this.savedSelectedItems.getItemIndex(item);
				if(tempItemIndex == -1){
					this.savedSelectedItems.addItem(item);
				}
			}
			
			// this section is running before AutoComplete is finished; so is removing these items
			for each (itemIndex in removedItems){
				// Only remove the item from savedSelectedItems if that item is still in the dataprovider 
				// if it is not in the dataProvider then it was autocompleted out and should be kept in
				if(itemIndex < this.dataProvider.length){
					item = this.dataProvider[itemIndex];
					tempItemIndex = this.savedSelectedItems.getItemIndex(item);
					if(tempItemIndex > -1){
						this.savedSelectedItems.removeItemAt(tempItemIndex);
					}
					
				}
			}
			
			// call the suer now that we have the savedSelectedItems properly synced (in theory at least  
			super.commitMultipleSelection();		

			// Put _proposedSelectedIndices back to its default value.  
			_proposedSelectedIndices = new Vector.<int>();

			// weird bug where the userProposedSelectedIndex is being set when the drop down is closed even though nothing is selected
			// so just set it to nothing at this point
			if((this.selectedIndex == NO_SELECTION) && (this.userProposedSelectedIndex != NO_SELECTION)){
				this.userProposedSelectedIndex = NO_SELECTION;
			}
		}

		
		
		/**
		 * 
		 * we aren't calling super in this case; overriding this method completely
		 * the textInput.text will never be written; the user only types into it 
		 * 
		 * Instead we just want to use this to set the text on the selectedLabelDisplay based on delimiter and savedSelectedItems
		 * 
		 * @private
		 * 
		 */
		override mx_internal function updateLabelDisplay(displayItem:* = undefined):void
		{
			// if auto complete is disabled just put all the selected items together with the delimited into one big string
			if (selectedLabelDisplay)
			{
				var newLabel :String = "";
				for each (var item :Object in this.savedSelectedItems){
					newLabel += LabelUtil.itemToLabel(item, labelField, labelFunction) + this.delimiter;
				}
				if(newLabel.length > 1){
					newLabel = newLabel.substring(0,newLabel.length-1);
				}
				selectedLabelDisplay.text = newLabel;

			}
		}
		
		
		/**
		 * weird bug using ComboBoxMultiSelectSkin in which the textInput is hidden
		 * causes infinite loop
		 * this should prevent that 
		 * 
		 * Although during dev the AutoComplete component was modded so the optional skin part was okay if removed
		 * So I'm not sure if this is needed anymore 
		 * 
		 * @private 
		 */
		override mx_internal function keyDownHandlerHelper(event:KeyboardEvent):void
		{
			if((this.textInput) && (event.target == this.textInput.textDisplay)){
				super.keyDownHandlerHelper(event);	
			}
		}
		
		// 
		/**
		 * 
		 * overriden from AutoCompleteComboBox
		 * Do nothing; if something is selected we do not want to refilter the dataPRovider and clear the type ahead text for the multiselect
		 * @private 
		 * 
		 */
		override protected function onChange(event:IndexChangeEvent):void{
			// nothing here 
		}
	
		// 
		/**
		 * the method handler for clicking the button 
		 * Needs to be override and modified beacuse the selectedItems / selectedIndices was being reset in the close process
		 * this fixes that by resyncing the _proposedSelectedItems via a setSelectedIndices call
		 * 
		 * @private 
		 * 
		 */
		override protected function dropDownController_closeHandler(event:DropDownEvent):void
		{
			super.dropDownController_closeHandler(event);
			
			// code to calculate the new selected Indices; because they seem to get reset when the close handler is called
			// if nothing was selected inside the drop down
			// it ignores items already selected 
			var newSelectedIndices : Vector.<int> = resetSelectedIndices();
			
			// callign setSelectedIndices will automatically call commitSelection
			this.setSelectedIndices(newSelectedIndices);

		}

		//--------------------------------------------------------------------------
		//
		//  Private methods copied from up in the hierarchy
		//
		//--------------------------------------------------------------------------
				
		/**
		 * stolen from list class because needed by commitSelection
		 * @private
		 * 
		 */
		protected function isValidIndex(item:int, index:int, v:Vector.<int>):Boolean
		{
			return (dataProvider != null) && (item >= 0) && (item < dataProvider.length); 
		}
		
		/**
		 * stolen from list class because needed by commitSelection
		 * @private
		 * 
		 */
		protected function getFirstItemValue(v:Vector.<int>):int
		{
			if (v && v.length > 0)
				return v[0]; 
			else 
				return -1; 
		}
		
		
		/**
		 * stolen from list class because needed by commitSelection
		 * @private
		 * 
		 */
		protected function isEmpty(v:Vector.<int>):Boolean
		{
			return v == null || v.length == 0;
		}

		
		/**
		 * Helper function to calculate what the selectedIndices should be based on the filtered dataProvider and the savedSelectedIitems
		 * 
		 * @private  
		 */
		protected function resetSelectedIndices():Vector.<int>{
			var newSelectedIndices : Vector.<int> = new Vector.<int>();
			
			for each(var item :Object in this.savedSelectedItems){
				var itemIndex :int = this.dataProvider.getItemIndex(item);
				if(itemIndex > -1){
					newSelectedIndices.push(itemIndex);
				}
			}
			return newSelectedIndices;
			
		}
		
		
		
	}
}