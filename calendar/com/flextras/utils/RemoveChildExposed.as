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
package com.flextras.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.states.RemoveChild;
	
	/**
	 * @private
	 * created so I could fiddle with the 'removed' value for complicated Calendar state changes 
	 */
	public class RemoveChildExposed extends RemoveChild
	{
		public function RemoveChildExposed(target:DisplayObject=null)
		{
			super(target);
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Parent of the removed child.
		 */
		public var oldParent:DisplayObjectContainer;
		
		
		/**
		 *  @private
		 *  Index of the removed child.
		 */
		private var oldIndex:int;

		/**
		 *  @private
		 */
		public var removed:Boolean;

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		// no properties need to be recreated or copied here 

		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @inheritDoc
		 */
		override public function apply(parent:UIComponent):void
		{
			removed = false;
			
			if (target.parent)
			{
				oldParent = target.parent;
				oldIndex = oldParent.getChildIndex(target as DisplayObject);
				oldParent.removeChild(target as DisplayObject);
				removed = true;
			}
		}

		
		/**
		 *  @inheritDoc
		 */
		override public function remove(parent:UIComponent):void
		{
			if (removed)
			{
				oldParent.addChildAt(target as DisplayObject, oldIndex);
				
				// Make sure any changes made while the child was removed are reflected
				// properly.
				if (target is UIComponent)
					UIComponent(target).mx_internal::updateCallbacks();
				
				removed = false;
			}
		}
		
		
		
	
	
	}
}