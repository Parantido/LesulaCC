package org.techfusion.view.components.classed {
	
	import spark.components.TextInput;

	public class CustomTextInput extends TextInput {
		
		[Bindable] public var sideImage:Object = null;
		
		public function CustomTextInput() {
			super();
		}
	}
}