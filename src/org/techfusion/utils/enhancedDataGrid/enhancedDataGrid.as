package org.techfusion.utils.enhancedDataGrid {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.TitleWindow;
	import mx.controls.DataGrid;
	import mx.controls.Label;
	import mx.controls.TextInput;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.CloseEvent;
	import mx.events.DataGridEvent;
	import mx.events.ListEvent;

	public class enhancedDataGrid extends DataGrid {
		
		// Row Color Function
		private var _rowColorFunction:Function;
		
		// Header Box
		private var _headerBox:TitleWindow = new TitleWindow();

		// Search Text Field
		protected var _textField:TextInput = new TextInput();
		
		// Search Text Field Label
		protected var _lblField:Label = new Label();
		
		// Searchable Columns
		public var serchableFields:Array = [];
		
		// Data Provider Type
		private var _dataProvider:ArrayCollection = new ArrayCollection();
		
		// Enable/Disable Search View
		public var enableSearch:Boolean = true;
		
		// Enable/Disable Add
		public var isAdding:Boolean = false;
		
		// Enable/Disable Edit
		public var isUpdating:Boolean = false;		
		
		// Editable Row/Columg Index
		private var editRowIndex:int = -1;
		private var editColumnIndex:int = -1;
		
		// Old Style Cache
		private var oldStyle:Object = null

		public function enhancedDataGrid() {
			// Return Super Class
			super();
			
			// Handle Key Press
			super.addEventListener(KeyboardEvent.KEY_DOWN, handleKey);
			
			// Handle Item Editing
			super.addEventListener(DataGridEvent.ITEM_EDIT_BEGIN, itemEditCheck);
			
			// Handle Item Click
			super.addEventListener(ListEvent.ITEM_CLICK, itemClicked);
		}
		
    	// Retrieve Some Useful Values
		private function itemClicked(le:ListEvent):void {
			this.editColumnIndex = le.columnIndex;
        }
		
		public function set rowColorFunction(f:Function):void {
			this._rowColorFunction = f;
		}
		
		public function get rowColorFunction():Function {
			return this._rowColorFunction;
		}
		
		private var displayWidth:Number;
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);	    	

			if (displayWidth != unscaledWidth - viewMetrics.right - viewMetrics.left) {
				displayWidth = unscaledWidth - viewMetrics.right - viewMetrics.left;
			}
		}
		
		override protected function drawRowBackground(s:Sprite, rowIndex:int, y:Number, height:Number, color:uint, dataIndex:int):void {
			if(this.rowColorFunction != null) {
				if(dataIndex < (this.dataProvider as ArrayCollection).length) {
					var item:Object = (this.dataProvider as ArrayCollection).getItemAt(dataIndex);					
					color = this.rowColorFunction.call(this, item, color);
				}
			}
			
			super.drawRowBackground(s, rowIndex, y, height, color, dataIndex);
		}
		
		// SET Row Editable 
		public function setRowEdit(rowIndex:int):void {
			if(!isAdding && !isUpdating) {
				
				// Set Datagrid Editable
				super.editable = true;
				this.isUpdating = true;
				
				// Set Editable Row
				this.editRowIndex = rowIndex;
				
				// Set Foucs on Editable Row
				//super.editedItemPosition = {columnIndex:0, rowIndex:editRowIndex};
				
				// Change Look
				this.changeLook();
				
			} else if(isUpdating) {
				
				// Call Event Dispatcher
				this.dataChangeEventDispatcher("rowUpdated");
				
				// Change Look
				this.changeLook();
			}
		}
		
		// Adding a new Row on the Top
		public function addRow():void {
			if(!isAdding && !isUpdating) {
				
				// Create a new Empty Object
				var obj:Object = new Object();
				
				// Add In Top of DataProvider
				_dataProvider.addItemAt(obj, 0);
				
				// Set Updated Data Provider
				super.dataProvider = _dataProvider;
				
				// Notify Row Edit Locally
				this.editRowIndex = 0;
				
				// Set Datagrid Editable
				super.editable = true;
				this.isAdding = true;
				
				// Set Editable First Row
				this.editRowIndex = 0;
				
				// Set Focus on Editable Row
				//super.editedItemPosition = {columnIndex:0, rowIndex:editRowIndex};
				
				// Change Look
				this.changeLook();
				
			} else if(!isUpdating) {
				
				// Call Event Dispatcher
				this.dataChangeEventDispatcher("rowAdded");
				
				// Change Look
				this.changeLook();
			}
		}
		
		private function changeLook():void {
			if(isAdding || isUpdating) {
				// Cache Old Style Layer
				this.oldStyle = super.getStyle('alternatingItemColors');
				
				// Colorize Table
				var bgColors:Array = new Array("#BCB4BA");
				setStyle('alternatingItemColors', bgColors);
				
				// Disable Sorting
				super.sortableColumns = false;
			} else {
				// Remove Color Style
				super.setStyle('alternatingItemColors', this.oldStyle);
				
				// Reset OldStyle Cache
				this.oldStyle = null;
				
				// Re-Enable Sorting
				super.sortableColumns = true;
			}
		}

		private function dataChangeEventDispatcher(eventName:String):void {
			// Set Datagrid Editable
			super.editable = false;
			this.isAdding = false;
			this.isUpdating = false;
			
			// Dispatch Update Event - Passing Updated Row Index
			dispatchEvent(new enhancedDataGridEvent(eventName, false, false, editRowIndex));
			
			// Set Foucs on Correct Updated Row
			super.selectedIndex = editRowIndex;
			
			// Reset Index
			this.editRowIndex = -1;
			this.editColumnIndex = -1;
		}
		
		// Check For Correct Row Editing
		private function itemEditCheck(evt:DataGridEvent):void {		
			if(super.selectedIndex != editRowIndex) {
				// Set Foucs on Correct Cell
				super.editedItemPosition = {columnIndex:(editColumnIndex + 1), rowIndex:editRowIndex};
			}
		}
				
		private function handleKey(event:KeyboardEvent):void {
			// Bind Enable/Disable Find Control on F1 Key
			if(event.keyCode == 114) {
				// Drop/Show box on F3 Key Press
				if(_headerBox.visible == true) {
					_headerBox.visible = false;
					// Data Grid gain Focus
					super.setFocus();
				} else {
					_headerBox.visible = true;
					// Search Text Field gain Focus
					_textField.setFocus();
				}
			} else if(event.keyCode == 115) {
				super.dataProvider.addItem(null);
			} else if(event.keyCode == 27) {
				// Drop box on ESC Key Press
				_headerBox.visible = false;
				// Data Grid gain Focus
				super.setFocus();
			}
		}
		
		public function finderViewToggle():void {
			if(_headerBox.visible == true) {
				_headerBox.visible = false;
			} else {
				_headerBox.visible = true;
			}
		}
		
		private function boxBehavior(event:Event, action:String):void {
			if(action == "hide") {
				_headerBox.visible = false;
			} else if(action == "press") {
				_headerBox.startDrag(false, getRect(super));
			} else {
				_headerBox.stopDrag();
			}
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if(enableSearch){
				// Define Search Title Window
				_headerBox.width = 300;
				_headerBox.height = 150;
				_headerBox.x = 50;
				_headerBox.y = 50;
				_headerBox.title = "Ricerca";
				_headerBox.showCloseButton = true;
				_headerBox.setStyle("verticalAlign", "middle");
				_headerBox.setStyle("horizontalAlign", "center");				
				
				// Drag Action
				_headerBox.addEventListener(MouseEvent.MOUSE_DOWN, function (e:MouseEvent):void { boxBehavior(e, "press"); });
				_headerBox.addEventListener(MouseEvent.MOUSE_UP, function (e:MouseEvent):void { boxBehavior(e, "release"); });
				_headerBox.addEventListener(CloseEvent.CLOSE, function (e:CloseEvent):void { boxBehavior(e, "hide"); });
				
				// Hide Component by Default
				_headerBox.visible = false;		
				
				// Set Text Label
				_lblField.id = "fldSearch";
				_lblField.text = "Ricerca (premere ESC/F3 per chiudere)";
				
				// Set TextField Behavior
				_textField.width = 220;
				_textField.x = 10;
				_textField.addEventListener(Event.CHANGE, handleChange);

				// Add It to Container
				_headerBox.addChild(_lblField);
				_headerBox.addChild(_textField);
				
				// Attach all to Super (DataGrid)
				super.addChild(_headerBox);
				super.y = super.y + 25;
			}
		}

		// Automatically generate Columns from an XML Data Structure
		// Es.: <employees><employee><name>Christina Coenraets</name><phone>555-219-2270</phone><email>ccoenraets@fictitious.com</email><active>true</active></employee><employee><name>Louis Freligh</name><phone>555-219-2100</phone><email>lfreligh@fictitious.com</email><active>true</active></employee></employees>
		private function generateCols(input:XMLList, useAttributes:Boolean = false):Array {
			var e1:XML = input[0];
			var columns:Array = [];
			var children:XMLList ;
			
			if (useAttributes) {
				children = e1.attributes();
			} else {
				children = e1.children();
			}

			for each(var child:XML in children) {
				var col:DataGridColumn = new DataGridColumn();
				col.dataField = useAttributes ? "@" + child.name() : child.name();
		    
		    	var fieldName:String = child.name();
		    	col.headerText = fieldName.charAt(0).toUpperCase() + fieldName.substr(1);
		    	columns.push(col);
		    }
		    
		    return columns;
		}

		private function handleChange(e:Event):void{
			// Refresh Data Provider
			_dataProvider.refresh();
			
			// Dispatch Content Change Event
			dispatchEvent(new Event('textChanged'));
		}
		
		private function myFilterFunction(item:Object):Boolean {
			var r:Boolean = false;
			
			for (var i:String in item) {
				if(serchableFields.length==0) {
					try {
						if( matchCase(item[i].toLowerCase())) return true;
					} catch(e:*) { /*do Nothing*/ }
				} else {
					for(var j:int=0; j<serchableFields.length; j++) {
						if(i == serchableFields[j]) {
							try {
								if(matchCase(item[i].toLowerCase())) return true;
							} catch(e:*) { /* do Nothing */ }
						}
					}
				}
			}
			
			return false;
		}
		
		private function matchCase(str:String):Boolean {
			var pattern:RegExp = new RegExp(_textField.text.toLowerCase());
			return pattern.test(str);
		}
		
		override public function set data(value:Object):void {
			super.data = value;
		}
		
		override public function set dataProvider(value:Object):void {
			
			// Check If Value Exists			
			if(value != null) {
				_dataProvider = ArrayCollection(value);
			} else {
				_dataProvider = new ArrayCollection();
			}
			
			// Add Filter Function
			_dataProvider.filterFunction = myFilterFunction;

			// Set Data Provider
			super.dataProvider = _dataProvider;
		}
	}
}