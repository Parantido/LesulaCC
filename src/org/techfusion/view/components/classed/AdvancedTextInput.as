package org.techfusion.view.components.classed {
	
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import mx.core.UIComponent;
	
	public class AdvancedTextInput extends UIComponent  {
		
		private var myTextBox:TextField = new TextField(); 
		private var myOutputBox:TextField = new TextField(); 
		private var myText:String = "Type your text here."; 
		
		public function AdvancedTextInput() { 
			captureText(); 
		} 
		
		public function captureText():void {
			myTextBox.type = TextFieldType.INPUT; 
			myTextBox.background = true; 
			addChild(myTextBox); 
			myTextBox.text = myText; 
			myTextBox.addEventListener(TextEvent.TEXT_INPUT, textInputCapture); 
		} 
		
		public function textInputCapture(event:TextEvent):void {
			var str:String = myTextBox.text; 
			createOutputBox(str); 
		} 
		
		public function createOutputBox(str:String):void { 
			myOutputBox.background = true; 
			myOutputBox.x = 200; 
			addChild(myOutputBox); 
			myOutputBox.text = str; 
		} 
	} 
}