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
	/**
	 * This is an alternate skin for the Flextras Mobile AutoComplete Component.  
	 * It uses a different FXG asset for the open button.
	 * 
	 * @author www.Flextras.com
	 * @see com.flextras.autoCompleteComboBox.AutoCompleteComboBoxMobile
	 * @see com.flextras.autoCompleteComboBox.skins.DownArrowSkin_3
	 * 
	 */
	public class AutoCompleteComboBoxMobileSkin_3 extends AutoCompleteComboBoxMobileSkin_Default
	{

		public function AutoCompleteComboBoxMobileSkin_3()
		{
			super();
			this.openButtonSkin = com.flextras.mobile.autoCompleteComboBox.skins.DownArrowSkin_3;
		}
	}
}