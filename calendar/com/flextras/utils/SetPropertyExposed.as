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
	import mx.core.UIComponent;
	import mx.states.SetProperty;
	
	/**
	 * @private
	 * created so I could fiddle with the 'oldValue' for complicated Calendar state changes 
	 */
	public class SetPropertyExposed extends SetProperty
	{

		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  This is a table of pseudonyms.
		 *  Whenever the property being overridden is found in this table,
		 *  the pseudonym is saved/restored instead.
		 */
		private static const PSEUDONYMS:Object =
		{
			width: "explicitWidth",
			height: "explicitHeight"
		};
		
		/**
		 *  @private
		 *  This is a table of related properties.
		 *  Whenever the property being overridden is found in this table,
		 *  the related property is also saved and restored.
		 */
		private static const RELATED_PROPERTIES:Object =
		{
			explicitWidth: [ "percentWidth" ],
			explicitHeight: [ "percentHeight" ]
		};
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 *  @inheritDoc
		 */
		public function SetPropertyExposed(target:Object=null, name:String=null, value:*=null)
		{
			super(target, name, value);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 *  Storage for the old property value.
		 */
		private var _oldValue:Object;

		/**
		 *  @private
		 */
		public function get oldValue():Object
		{
			return _oldValue;
		}

		/**
		 *  @private
		 */
		public function set oldValue(value:Object):void
		{
			_oldValue = value;
		}
		
		/**
		 *  @private
		 *  Storage for the old related property values, if used.
		 */
		private var oldRelatedValues:Array;

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		// no properties need to be recreated or copied here 
		

		//--------------------------------------------------------------------------
		//
		//  Methods: IOverride
		//
		//--------------------------------------------------------------------------
		// initialize good
		
		// Yes we do; it's not setting those pesky private variables
		/**
		 * @inheritDoc
		 */
		override public function apply(parent:UIComponent) : void{
			var obj:Object = target ? target : parent;

			var propName:String = PSEUDONYMS[name] ?
				PSEUDONYMS[name] :
				name;

			var relatedProps:Array = RELATED_PROPERTIES[propName] ?
				RELATED_PROPERTIES[propName] :
				null;
			
			
			// Remember the current value so it can be restored
			// copied from super.apply so that our public oldValue variable is set
			oldValue = obj[propName];
			
			// Remember the current value so it can be restored
			// copied from super.apply so that this component's private oldRelatedValues is set
			if (relatedProps)
			{
				oldRelatedValues = [];
				
				for (var i:int = 0; i < relatedProps.length; i++)
					oldRelatedValues[i] = obj[relatedProps[i]];
			}
			
			super.apply(parent);
			
		}
		
		
		/**
		 *  @inheritDoc
		 */
		override public function remove(parent:UIComponent):void{
			var obj:Object = target ? target : parent;
			
			var propName:String = PSEUDONYMS[name] ?
				PSEUDONYMS[name] :
				name;
			
			var relatedProps:Array = RELATED_PROPERTIES[propName] ?
				RELATED_PROPERTIES[propName] :
				null;
			// Special case for width and height. Restore the "width" and
			// "height" properties instead of explicitWidth/explicitHeight
			// so they can be kept in sync.
			if ((name == "width" || name == "height") && !isNaN(Number(oldValue)))
			{
				propName = name;
			}

			
			// Restore the old value
			setPropertyValue(obj, propName, oldValue, oldValue);
			
			// Restore related value, if needed
			if (relatedProps)
			{
				for (var i:int = 0; i < relatedProps.length; i++)
				{
					setPropertyValue(obj, relatedProps[i],
						oldRelatedValues[i], oldRelatedValues[i]);
				}
			}
		
		}

	
		/**
		 *  @private
		 *  Sets the property to a value, coercing if necessary.
		 */
		private function setPropertyValue(obj:Object, name:String, value:*,
										  valueForType:Object):void
		{
			if (valueForType is Number)
				obj[name] = Number(value);
			else if (valueForType is Boolean)
				obj[name] = toBoolean(value);
			else
				obj[name] = value;
		}
		/**
		 *  @private
		 *  Converts a value to a Boolean true/false.
		 */

		private function toBoolean(value:Object):Boolean
		{
			if (value is String)
				return value.toLowerCase() == "true";
			
			return value != false;
		}
		
	}
}