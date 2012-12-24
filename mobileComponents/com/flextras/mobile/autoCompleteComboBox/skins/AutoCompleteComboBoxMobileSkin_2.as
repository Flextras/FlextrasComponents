package com.flextras.mobile.autoCompleteComboBox.skins
{
	/**
	 * This is an alternate skin for the Flextras Mobile AutoComplete Component.  
	 * It uses a different FXG asset for the open button.
	 * 
	 * @author www.Flextras.com
	 * @see com.flextras.autoCompleteComboBox.AutoCompleteComboBoxMobile
	 * @see com.flextras.autoCompleteComboBox.skins.DownArrowSkin_2
	 * 
	 */
	public class AutoCompleteComboBoxMobileSkin_2 extends AutoCompleteComboBoxMobileSkin_Default
	{
		public function AutoCompleteComboBoxMobileSkin_2()
		{
			super();
			this.openButtonSkin = com.flextras.mobile.autoCompleteComboBox.skins.DownArrowSkin_2;
		}
	}
}