package module.roompage
{
	import com.smartfoxserver.v2.entities.Room;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	
	import EXIT.util.JSONLoader;
	
	import __AS3__.vec.Vector;
	
	import model.MainModel;
	
	import module.IPage;
	import module.gamepage.SlotMachineComponent;
	import module.roompage.friendmodule.FriendListController;
	import module.roompage.menumodule.MenuController;
	import module.roompage.roommodule.CreateRoomPopup;
	import module.roompage.roommodule.RoomController;
	import module.roompage.roommodule.RoomPageModel;
	import module.roompage.roommodule.SearchController;
	import module.roompage.usergamemodule.UserGameController;
	
	import net.area80.display.loader.ImageBox;

	public class RoomPage extends roompage implements IPage
	{
		private var serverConnector:ServerConnector;
		private var roomController:RoomController;
		private var searchController:SearchController;
		private var currentZone:Object = normalRoomBtn;
		public function RoomPage()
		{
			super();
		}
		
		public function start():void
		{
			MainModel.getInstance().freeze();
			
			//menu
			
			var menuController:MenuController = new MenuController(this);
			
			serverConnector = ServerConnector.getInstace();
			serverConnector.SIGNAL_ROOM_JOIN.add( onRoomJoined );
			
			//detail
			var image:ImageBox = new ImageBox("https://graph.facebook.com/"+UserData.fbuid+"/picture",50,50);
			profileImage.addChild(image);
			image.load();
			profileImage.mask = profileMask;
			
			//room
			roomController = new RoomController(roomList);
			createRoomBtn.buttonMode=true;
			createRoomBtn.addEventListener(MouseEvent.CLICK , onCreateRoom );
			
			createRoomBtn.addEventListener(MouseEvent.MOUSE_OUT , function onOut(e:MouseEvent):void{
				var _mc:MovieClip = e.currentTarget as MovieClip
				_mc.gotoAndStop(e.type);
			})
			createRoomBtn.addEventListener(MouseEvent.MOUSE_OVER , function onOver(e:MouseEvent):void{
				var _mc:MovieClip = e.currentTarget as MovieClip
				_mc.gotoAndStop(e.type);
			})
			
			var roomBtns:Vector.<Sprite> = new <Sprite>[normalRoomBtn,lnwRoomBtn,roomBtn1,roomBtn2,roomBtn3,roomBtn4,roomBtn5];
			for( var i:int=0 ; i<=roomBtns.length-1 ; i++ ){
				roomBtns[i].buttonMode = true;
				roomBtns[i].addEventListener(MouseEvent.CLICK,changeZone );
				roomBtns[i].addEventListener(MouseEvent.MOUSE_OVER, function onOver(e:MouseEvent):void{
					var _mc:MovieClip = e.currentTarget as MovieClip
					_mc.gotoAndStop(e.type);
				})
				roomBtns[i].addEventListener(MouseEvent.MOUSE_OUT, function onOut(e:MouseEvent):void{
					var _mc:MovieClip = e.currentTarget as MovieClip
					_mc.gotoAndStop(e.type);
				})
			}
			
			
			joinGameBtn.buttonMode=true;
			joinGameBtn.addEventListener(MouseEvent.CLICK , joinGame );
			
			joinGameBtn.addEventListener(MouseEvent.MOUSE_OUT , function onOut(e:MouseEvent):void{
				var _mc:MovieClip = e.currentTarget as MovieClip
				_mc.gotoAndStop(e.type);
			})
			joinGameBtn.addEventListener(MouseEvent.MOUSE_OVER , function onOver(e:MouseEvent):void{
				var _mc:MovieClip = e.currentTarget as MovieClip
				_mc.gotoAndStop(e.type);
			})
			joinGameSpectatorBtn.buttonMode=true;
			joinGameSpectatorBtn.addEventListener(MouseEvent.CLICK , startAsSpectator );
			
			searchController = new SearchController(this);
			
			//friend
			var friendListController:FriendListController = new FriendListController( friendList , this);
			
			var jsonLoader:JSONLoader = new JSONLoader("https://graph.facebook.com/"+UserData.fbuid);
			jsonLoader.signalComplete.add(getUserData);
			jsonLoader.load();
			
			//social
			var userGameController:UserGameController = new UserGameController(gangBtn,socialBtn,gangContainer,socialContainer);
			
		}

		private function getUserData(_json:*):void
		{
			userNameText.text = _json.name;
			serverConnector.start(UserData.fbuid+"_"+_json.name+"_"+Math.random());
		}
		
		private function onRoomJoined(room:Room):void
		{
			Shows.addByClass(this,"onRoomJoin : room="+room.name );
			MainModel.getInstance().unfreeze();
			if( room != null && room.isGame){
				MainModel.getInstance().changePage(MainModel.PAGE_GAME);
			}
		}
		
		protected function startAsSpectator(event:MouseEvent):void
		{
			if( roomController.getSelectedRoomID()!=-1 ){
				MainModel.getInstance().freeze();
				serverConnector.join(roomController.getSelectedRoomID(),true);
			}
		}
		
		protected function joinGame(event:MouseEvent):void
		{
			Shows.addByClass(this," room id="+ roomController.getSelectedRoomID() );
			if( roomController.getSelectedRoomID()!=-1 ){
				MainModel.getInstance().freeze();
				serverConnector.join(roomController.getSelectedRoomID(),false);
			}
		}
		
		protected function changeZone(event:MouseEvent):void
		{
			if( event.currentTarget != currentZone ){
				currentZone = event.currentTarget;
				var zone:String = "";
				if( currentZone == normalRoomBtn ){
					zone = "BasicExamples";
				}else if( currentZone == lnwRoomBtn ){
					zone = "Zone1";
				}else if( currentZone == roomBtn1 ){
					zone = "Zone2";
				}else if( currentZone == roomBtn2 ){
					zone = "Zone3";
				}else if( currentZone == roomBtn3 ){
					zone = "Zone4";
				}else if( currentZone == roomBtn4 ){
					zone = "Zone5";
				}else if( currentZone == roomBtn5 ){
					zone = "Zone6";
				}
				serverConnector.changeZone(zone);
			}
		}
		
		protected function onCreateRoom(event:MouseEvent):void
		{
			var createRoomPopup:CreateRoomPopup = new CreateRoomPopup(
				function(_name:String):void{
					MainModel.getInstance().isCreator = true;
					serverConnector.createRoom(_name);
					MainModel.getInstance().freeze();
				});
			addChild(createRoomPopup);
		}
		
		public function dispose():void
		{
			serverConnector.SIGNAL_ROOM_JOIN.remove( onRoomJoined );
			serverConnector = null;
			roomController.dispose();
		}
	}
}