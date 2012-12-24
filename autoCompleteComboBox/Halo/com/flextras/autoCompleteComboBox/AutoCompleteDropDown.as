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
package com.flextras.autoCompleteComboBox
{
	import mx.controls.List;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.ListData;
	import mx.core.mx_internal;
	
	use namespace mx_internal;

	
	[ExcludeClass]
	/**
	 * @private
	 */
	public class AutoCompleteDropDown extends List
	{
		/** 
		 * constructor
		 */
		public function AutoCompleteDropDown()
		{
			super();
		}
		
		/** 
		 * the type ahead text; just a place holder really to send to itemRenderers
		 */
		public var typeAheadText : String = '';
		
		/** 
		 * A link to the AutoCompleteComboBox instance that is using this drop down
		 */
		public var autoCompleteComboBox : AutoCompleteComboBox;

	    /**
	     *  @inheritdocs
	     */    
	    override protected function makeListData(data:Object, uid:String,
	                                 rowNum:int):BaseListData
	    {
	        return new AutoCompleteListData( new ListData(itemToLabel(data), itemToIcon(data), labelField, uid, this, rowNum), this.typeAheadText, this.autoCompleteComboBox);
	    }
		
		/**
		 * @private
		 * Created for the AutoCompleteComboBox Flex 3.5 edition 
		 * which is strangely setting the rowHeight to 0 in certain situations; which then always gives the 
		 * drop down a zero height 
		 */
		override protected function setRowHeight(v:Number):void
		{
			if(v == 0){
				return;
			}
			super.setRowHeight(v);
		}		
		
	    
	}
}