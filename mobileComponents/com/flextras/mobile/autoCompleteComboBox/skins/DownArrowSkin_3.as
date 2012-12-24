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
	import com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile160.DownArrow_down_3;
	import com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile160.DownArrow_up_3;
	import com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile240.DownArrow_down_3;
	import com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile240.DownArrow_up_3;
	import com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile320.DownArrow_down_3;
	import com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile320.DownArrow_up_3;
	
	import mx.core.DPIClassification;

	/**
	 * This is an alternate skin for the open button of the Flextras Mobile AutoComplete Component.
	 * It is not modeled after the mobile ButtonSkin, instead putting all graphical assets in an external FXG file.
	 * 
	 * @author www.flextras.com
	 * 
	 * @see com.flextras.mobile.autoCompleteComboBox.AutoCompleteComboBoxMobile
	 */
	public class DownArrowSkin_3 extends DownArrowSkin_1
	{
		public function DownArrowSkin_3()
		{
			super();
			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					upSkin = com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile320.DownArrow_up_3;
					downSkin = com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile320.DownArrow_down_3;
					
					break;
				}
				case DPIClassification.DPI_240:
				{
					upSkin = com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile240.DownArrow_up_3;
					downSkin = com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile240.DownArrow_down_3;
					
					break;
				}
				default:
				{
					// default DPI_160
					upSkin = com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile160.DownArrow_up_3;
					downSkin = com.flextras.mobile.autoCompleteComboBox.skins.assets.mobile160.DownArrow_down_3;
					
					break;
				}
			}
			

		
		}
	}
}