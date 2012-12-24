package com.flextras.mobile.shared.skins
{
	import com.flextras.mobile.shared.skins.assets.mobile160.ButtonRectangleBorder_down;
	import com.flextras.mobile.shared.skins.assets.mobile160.ButtonRectangleBorder_up;
	import com.flextras.mobile.shared.skins.assets.mobile240.ButtonRectangleBorder_down;
	import com.flextras.mobile.shared.skins.assets.mobile240.ButtonRectangleBorder_up;
	import com.flextras.mobile.shared.skins.assets.mobile320.ButtonRectangleBorder_down;
	import com.flextras.mobile.shared.skins.assets.mobile320.ButtonRectangleBorder_up;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	
	import mx.core.DPIClassification;
	import mx.core.mx_internal;
	import mx.utils.ColorUtil;
	
	import spark.skins.mobile.ButtonSkin;

	use namespace mx_internal;

	
	/**
	 * This is a custom mobile button skin that generates a square button without any rounded corners.
	 */
	public class ButtonSkinSquare extends ButtonSkin
	{
		public function ButtonSkinSquare()
		{
			super();
			// just by changing this value we turn the button into a square
			// however the border is in a 
			this.layoutCornerEllipseSize = 0;

			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					trace('button 320');
					upBorderSkin = com.flextras.mobile.shared.skins.assets.mobile320.ButtonRectangleBorder_up;
					downBorderSkin = com.flextras.mobile.shared.skins.assets.mobile320.ButtonRectangleBorder_down;

					break;
				}
				case DPIClassification.DPI_240:
				{
					trace('button 240');
					upBorderSkin = com.flextras.mobile.shared.skins.assets.mobile240.ButtonRectangleBorder_up;
					downBorderSkin = com.flextras.mobile.shared.skins.assets.mobile240.ButtonRectangleBorder_down;
					
					break;
				}
				default:
				{
					// default DPI_160
					trace('button 160');
					upBorderSkin = com.flextras.mobile.shared.skins.assets.mobile160.ButtonRectangleBorder_up;
					downBorderSkin = com.flextras.mobile.shared.skins.assets.mobile160.ButtonRectangleBorder_down;


					break;
				}
			}
			
			
		}
		
		
		// what a horrible kludgy fix
		// I assume it could be fixed w/ some other approach related to scale nine / FXG scaleGrid properties 
		override mx_internal function layoutBorder(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var widthExtra : int = 0;
			if(unscaledWidth > 909){
				widthExtra++;
			}
			if(unscaledWidth > 1200){
				widthExtra++
			}
			if(unscaledWidth>1491){
				widthExtra++
			}
			setElementSize(border, unscaledWidth+widthExtra, unscaledHeight);
			setElementPosition(border, 0, 0);
		}
		
	}
}