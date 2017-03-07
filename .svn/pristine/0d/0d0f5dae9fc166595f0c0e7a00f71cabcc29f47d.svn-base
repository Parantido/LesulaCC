package org.techfusion.view.mediators {
	
	// Import default mx Classes
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.techfusion.controller.AsteriskCommand;
	import org.techfusion.controller.DatabaseCommand;
	import org.techfusion.controller.DisconnectCommand;
	import org.techfusion.controller.OnMessageCommand;
	import org.techfusion.events.GenericViewEvent;
	import org.techfusion.events.LoginViewEvent;
	import org.techfusion.model.proxies.DatabaseProxy;
	import org.techfusion.view.components.LoginView;
	import org.techfusion.view.components.MainView;

	public class LoginViewMediator extends Mediator implements IMediator {
		
		public static const NAME:String		= "LoginViewMediator";
		
		public function LoginViewMediator(viewComponent:Object = null) {
			// Debug
			trace(NAME + " ==> Constructor");
			
			// Pass the viewComponent to the superclass where it will be stored in the inherited viewComponent property
			super(NAME, viewComponent);
			
			// Add EventListener
			loginView.addEventListener(LoginViewEvent.LOGIN, onLoginClick);
		}
		
		// Send Notification OnLogin Click
		private function onLoginClick(loginViewEvent:LoginViewEvent):void {
			// Lock Interface
			loginView.mainLoginWindow.enabled = false;
			
			// Notify Event
			sendNotification(ApplicationFacade.LOGIN, loginViewEvent);
		}
		
		private function get loginView():LoginView {
			return viewComponent as LoginView;
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.CLOSED,
				ApplicationFacade.IOERROR,
				ApplicationFacade.SECERROR,
				ApplicationFacade.DISCONNECT,
				ApplicationFacade.VALID_LOGIN,
				ApplicationFacade.INVALID_LOGIN,
				ApplicationFacade.DB_INITIALIZED,
				ApplicationFacade.DB_GETCREDENTS_OK
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			// Define a credentials object
			var credentials:Object	= new Object();
			
			switch (notification.getName()) {
				case ApplicationFacade.VALID_LOGIN:
					// Store Credentials if Requested
					if(loginView.storeCredentials) {
						// Dispatch Credentials Store Notification
						databaseCredentialsHandler(new Event(ApplicationFacade.DB_SETCREDENTS));
						// Reset Flag
						loginView.storeCredentials = false;
						// Reset Check box
						loginView.chkSaveBox.selected = false;
					}
					// Fillout Credentials Object
					credentials.username	= loginView.txtUsername.text;
					credentials.passwd		= loginView.txtPassword.text;
					credentials.server		= loginView.txtServer.text;
					// Instanciate Environment Facade
					var facade:ApplicationFacade = ApplicationFacade.getInstance();
					// Store LoggedIN credentials
					facade._credentials = credentials;
					// Push on Main View
					loginView.navigator.pushView(MainView);
					break;
				case ApplicationFacade.CLOSED:
					// Notify Error Status
					sendNotification(
						ApplicationFacade.INFO_MESSAGE_KO,
						new GenericViewEvent(
							GenericViewEvent.INFO_MESSAGE_KO, 
							"Connection Closed by Remote Host\nWrong Credentials or Manager ACL?!"
						),
						GenericViewEvent.INFO_MESSAGE_KO
					);
					break;
				case ApplicationFacade.INVALID_LOGIN:
					// Notify Error Status
					sendNotification(
						ApplicationFacade.INFO_MESSAGE_KO,
						new GenericViewEvent(
							GenericViewEvent.INFO_MESSAGE_KO, 
							"Invalid Username or Password!"
						),
						GenericViewEvent.INFO_MESSAGE_KO
					);
					break;
				case ApplicationFacade.IOERROR:
					// Notify Error Status
					sendNotification(
						ApplicationFacade.INFO_MESSAGE_KO,
						new GenericViewEvent(
							GenericViewEvent.INFO_MESSAGE_KO, 
							"Network error: " + String(notification.getBody())
						),
						GenericViewEvent.INFO_MESSAGE_KO
					);
					break;
				case ApplicationFacade.SECERROR:
					// Notify Error Status
					sendNotification(
						ApplicationFacade.INFO_MESSAGE_KO,
						new GenericViewEvent(
							GenericViewEvent.INFO_MESSAGE_KO, 
							"Security error: " + String(notification.getBody())
						),
						GenericViewEvent.INFO_MESSAGE_KO
					);
					break;
				case ApplicationFacade.DISCONNECT:
					// Change State
					loginView.currentState = "Base";
					break;
				case ApplicationFacade.DB_INITIALIZED:
					// Cleanup previuosly stored credentials
					loginView.credentialsDataProvider = new ArrayCollection();
					// Define a dummy credentials object
					credentials = new Object();
					credentials.username	= "";
					credentials.password	= "";
					credentials.server		= "";
					// Add Dummy credential at 0
					loginView.credentialsDataProvider.addItemAt(credentials, 0);
					// Search for stored Credentials
					sendNotification(ApplicationFacade.DBCMD, null, ApplicationFacade.DB_GETCREDENTS);
					break;
				case ApplicationFacade.DB_GETCREDENTS_OK:
					// Get Notification Body
					credentials = notification.getBody();
					
					// Fill Spinner Data Provider
					if(credentials) {
						// Add Entry
						loginView.credentialsDataProvider.addItem(credentials);
						loginView.credentialsDataProvider.refresh();
						
						// Select List Dummy Credential
						loginView.ddlSavedCredentials.selectedIndex = 0;
						
						// Update Form
						loginView.credentialSelect();
						
						// Set Credentials as Saved
						loginView.chkSaveBox.selected = true;
					}
					break;
				default:
					break;
			}
			
			// UnLock Interface
			loginView.mainLoginWindow.enabled = true;
		}
		
		/**
		 * Handle Credentials Save Toggle Action
		 */
		protected function databaseCredentialsHandler(event:Event):void {
			// Define a credentials object
			var credentials:Object	= new Object();
			credentials.username	= loginView.txtUsername.text;
			credentials.password	= loginView.txtPassword.text;
			credentials.server		= loginView.txtServer.text;
			
			switch(event.type) {			
				case ApplicationFacade.DB_SETCREDENTS:
					sendNotification(ApplicationFacade.DBCMD, credentials, ApplicationFacade.DB_SETCREDENTS);
					break;
				case ApplicationFacade.DB_DELCREDENTS:
					sendNotification(ApplicationFacade.DBCMD, credentials, ApplicationFacade.DB_DELCREDENTS);
					break;
			}
		}
		
		override public function onRegister():void {
			// Register Proxy
			if(!facade.hasProxy(DatabaseProxy.NAME)) {
				facade.registerProxy(new DatabaseProxy());
			}
			
			// Register Commands
			if(!facade.hasCommand(ApplicationFacade.DBCMD)) {
				facade.registerCommand(ApplicationFacade.DBCMD, DatabaseCommand);
			}

			if(!facade.hasCommand(ApplicationFacade.ASTEVENT)) {
				facade.registerCommand(ApplicationFacade.ASTEVENT, AsteriskCommand);
			}
			
			if(!facade.hasCommand(ApplicationFacade.DISCONNECT)) {
				facade.registerCommand(ApplicationFacade.DISCONNECT, DisconnectCommand);
			}
			
			if(!facade.hasCommand(ApplicationFacade.ONMESSAGE)) {
				facade.registerCommand(ApplicationFacade.ONMESSAGE, OnMessageCommand);
			}

			// Register Mediator
			if(!facade.hasMediator(GrowlNotificationMediator.NAME)) {
				facade.registerMediator(new GrowlNotificationMediator(loginView));
			}
			
			// Register Event Listener
			loginView.addEventListener(ApplicationFacade.DB_SETCREDENTS, databaseCredentialsHandler);
			loginView.addEventListener(ApplicationFacade.DB_DELCREDENTS, databaseCredentialsHandler);

			// Debug
			trace(NAME + " ==> LoginViewMediator Registered");
		}

		override public function onRemove():void {
			// UnRegister Event Listener
			loginView.removeEventListener(ApplicationFacade.DB_DELCREDENTS, databaseCredentialsHandler);
			loginView.removeEventListener(ApplicationFacade.DB_SETCREDENTS, databaseCredentialsHandler);
			
			// UnRegister Mediator
			if(facade.hasMediator(GrowlNotificationMediator.NAME)) {
				facade.removeMediator(GrowlNotificationMediator.NAME);
			}
			
			// UnRegister Commands
			if(facade.hasCommand(ApplicationFacade.ONMESSAGE)) {
				facade.removeCommand(ApplicationFacade.ONMESSAGE);
			}
			
			if(facade.hasCommand(ApplicationFacade.DISCONNECT)) {
				facade.removeCommand(ApplicationFacade.DISCONNECT);
			}

			if(facade.hasCommand(ApplicationFacade.ASTEVENT)) {
				facade.removeCommand(ApplicationFacade.ASTEVENT);
			}
			
			// HINT -- DO NOT DEREGISTER DATABASE PROXY/COMMAND
			
			// Debug
			trace(NAME + " ==> LoginViewMediator Unegistered");
		}
	}
}