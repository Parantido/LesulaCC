package {
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	import mx.events.FlexEvent;
	import mx.preloaders.IPreloaderDisplay;
	import mx.preloaders.Preloader;
	
	/**
	 *<p> Image Preloader</p>
	 * replace the property splashScreenImage of Application,
	 * it can be dynamic changed by splashImageUrl and suppport ActionScript
	 * */
	public class ImagePreloader extends Sprite implements IPreloaderDisplay {
		private const LETTERBOX:String	= "letterbox";
		private const ZOOM:String		= "zoom";
		private const STRETCH:String	= "stretch";
		
		private var splashImage:DisplayObject;     
		private var splashImageWidth:Number;        
		private var splashImageHeight:Number;       
		private var SplashImageClass:Class = null;  
		private var loader:Loader = null;
		private var scaleMode:String = STRETCH;      
		private var minimumDisplayTime:Number = 3000;   
		private var checkWaitTime:Boolean = false;      
		private var displayTimeStart:int = -1;        
		private var _stageHeight:Number;
		private var _stageWidth:Number;
		
		// Main Splash UrI Container
		private var splashImageUrl:String = null;
		
		/**
		 * Class Constructor
		 */
		public function ImagePreloader(imagePath:String=null) {
			// Set up Image Path
			if(imagePath == null) {
				this.splashImageUrl = "/assets/images/splash/splash-1280x853.png";
			} else {
				this.splashImageUrl = imagePath;
			}
			
			// Call Super Class
			super();
		}
		
		/**
		 * Initialize
		 * */
		public function initialize():void {
			checkWaitTime = minimumDisplayTime > 0;
			if (checkWaitTime)
				if(displayTimeStart == -1)
					this.displayTimeStart = flash.utils.getTimer();
			
			loader = new Loader();
			loader.load(new URLRequest(splashImageUrl));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIoEvent);
			
			this.stage.addEventListener(Event.RESIZE, stageResizeHandler, false , 0, true );
		}
		
		private function stageResizeHandler(event:Event):void {
			scaleMatrix();
		}
		
		protected function onIoEvent(event:IOErrorEvent):void{
			trace("IOError has occured : " + event.text);
		}
		
		protected function onComplete(event:Event):void {
			dispose();
			
			// Smooth Loaded Image
			var tmpBitmap:Bitmap	= Bitmap(event.target.content);
			tmpBitmap.smoothing		= true;
			
			// Define as Splash Image
			splashImage = tmpBitmap;
			addChildAt(splashImage, 0);
			
			this.splashImageWidth = splashImage.width;
			this.splashImageHeight = splashImage.height;
			
			scaleMatrix();
		}
		
		
		/**
		 *  Scale matrix of SplashImage
		 */
		private function scaleMatrix():void {
			if (!splashImage)
				return;
			
			var dpiScale:Number = this.root.scaleX;
			var stageWidth:Number = stage.stageWidth / dpiScale;
			var stageHeight:Number = stage.stageHeight / dpiScale;
			var width:Number = splashImageWidth;
			var height:Number = splashImageHeight;
			var m:Matrix = new Matrix();
			var scaleX:Number = 1;
			var scaleY:Number = 1;
			
			switch(scaleMode) {
				case ZOOM:
					scaleX = Math.max( stageWidth / width, stageHeight / height);
					scaleY = scaleX;
					break;
				case LETTERBOX:
					scaleX = Math.min( stageWidth / width, stageHeight / height);
					scaleY = scaleX;
					break;
				case STRETCH:
					scaleX = stageWidth / width;
					scaleY = stageHeight / height;
					break;
			}
			
			if (scaleX != 1 || scaleY != 0) {
				width *= scaleX;
				height *= scaleY;
				m.scale(scaleX, scaleY);
			}
			
			m.translate(-width / 2, -height / 2);
			m.translate(stageWidth / 2, stageHeight / 2);
			
			splashImage.transform.matrix = m;
		}
		
		/**
		 * Get current display time
		 */
		private function get currentDisplayTime():int {
			if (-1 == displayTimeStart)
				return -1;
			
			return flash.utils.getTimer() - displayTimeStart;
		}
		
		/**
		 * Implements
		 */
		public function set preloader(obj:Sprite):void {
			obj.addEventListener(FlexEvent.INIT_COMPLETE, preloader_initCompleteHandler, false, 0, true);
		}
		
		private function preloader_initCompleteHandler(event:Event):void {
			if (checkWaitTime && currentDisplayTime < minimumDisplayTime)
				this.addEventListener(Event.ENTER_FRAME, initCompleteEnterFrameHandler);
			else        
				dispatchComplete();
		}
		
		private function initCompleteEnterFrameHandler(event:Event):void {
			if (currentDisplayTime <= minimumDisplayTime)return;
			dispatchComplete();
		}
		
		private function dispatchComplete():void {
			dispose();
			
			var preloader:Preloader = this.parent as Preloader;
			preloader.removeEventListener(FlexEvent.INIT_COMPLETE, preloader_initCompleteHandler, false);
			this.removeEventListener(Event.ENTER_FRAME, initCompleteEnterFrameHandler);
			
			this.stage.removeEventListener(Event.RESIZE, stageResizeHandler, false);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * Dispose Resource
		 */
		private function dispose():void {
			if(splashImage) {
				if(this.contains(splashImage))
					this.removeChild(splashImage);
				
				var bit:Bitmap = splashImage as Bitmap;
				
				if(bit.bitmapData) {
					bit.bitmapData.dispose();
					bit.bitmapData = null;
				}
			}
		}
		
		// Implements
		public function get backgroundAlpha():Number { return 0; }
		public function set backgroundAlpha(value:Number):void {}
		public function get backgroundColor():uint { return 0; }
		public function set backgroundColor(value:uint):void {}
		public function get backgroundImage():Object { return null; }
		public function set backgroundImage(value:Object):void {}
		public function get backgroundSize():String { return null; }
		public function set backgroundSize(value:String):void {}
		public function get stageHeight():Number { return _stageHeight; }
		public function set stageHeight(value:Number):void { _stageHeight = value; }
		public function get stageWidth():Number { return _stageWidth; }
		public function set stageWidth(value:Number):void { _stageWidth = value; }
	}
}