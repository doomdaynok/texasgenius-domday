package module.roompage.menumodule
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import module.roompage.RoomPage;

	public class MenuController
	{
		private var _vecCallTopSignal:Vector.<Function>;
		private var _vecCallMainSignal:Vector.<Function>;
		private var _vecCallBottomSignal:Vector.<Function>;
		private var _roomPage:RoomPage;
		
		public function MenuController( roomPage:RoomPage )
		{
			_roomPage = roomPage;
			_vecCallTopSignal = new Vector.<Function>
			_vecCallMainSignal = new Vector.<Function>
			_vecCallBottomSignal = new Vector.<Function>
			
			_vecCallMainSignal.push(function menuMain1():void{__callJS("index");});// index 0
			_vecCallMainSignal.push(function menuMain2():void{__callJS("store");});// index 1 store
			_vecCallMainSignal.push(function menuMain3():void{__callJS("levelList");});// index 2 levelList
			_vecCallMainSignal.push(function menuMain4():void{__callJS("invite");});// index 3 invite
			_vecCallMainSignal.push(function menuMain5():void{__callJS("friendList");});// index 4 friendList
			_vecCallMainSignal.push(function menuMain6():void{__callJS("feedback");});// index 5 feedback
			_vecCallMainSignal.push(function menuMain7():void{__callJS("howtoplay");});// index 6 howtoplay
			_vecCallMainSignal.push(function menuMain8():void{});// index 7 th eng
			_vecCallMainSignal.push(function menuMain9():void{__callJS("buyChip");});// index 8 buyChip
			_vecCallMainSignal.push(function menuMain10():void{__callJS("mission");});// index 9 mission
			_vecCallMainSignal.push(function menuMain11():void{__callJS("news");});// index 10 news
			_vecCallMainSignal.push(function menuMain12():void{__callJS("profile");});// index 11 profile
			_vecCallMainSignal.push(function menuMain13():void{});// index 12 setting
				
			_vecCallTopSignal.push(function menuTop1():void{__callJS("top1");});// index 0
			_vecCallTopSignal.push(function menuTop2():void{__callJS("top2");});// index 1
			_vecCallTopSignal.push(function menuTop3():void{__callJS("top3");});// index 2
			_vecCallTopSignal.push(function menuTop4():void{__callJS("luckyWheel");});// index 3 luckyWheel
			
			_vecCallBottomSignal.push(function menuBottom1():void{__callJS("bonus1");});// index 0 bonus1
			_vecCallBottomSignal.push(function menuBottom2():void{__callJS("bonus2");});// index 1 bonus2
			_vecCallBottomSignal.push(function menuBottom3():void{__callJS("bonus3");});// index 2 bonus3
			_vecCallBottomSignal.push(function menuBottom4():void{__callJS("bonus4");});// index 3 bonus4
			_vecCallBottomSignal.push(function menuBottom5():void{__callJS("bonus5");});// index 4 bonus5
			
			menuSetting("btMain_",_vecCallMainSignal)
			menuSetting("btTop_",_vecCallTopSignal)
			menuSetting("btBonus_",_vecCallBottomSignal)
		}
		private function __callJS(s:*,p:* =""):void{
			if(ExternalInterface.available){
				ExternalInterface.call(s,p)
			}
		}
		private function menuSetting(str:String = "",callVec:Vector.<Function>= null) : void {
			if(callVec!=null){
				var max:int = callVec.length;
				for(var i:int = 0;i<max;i++){
					var _bt:MovieClip = _roomPage.getChildByName(str+i) as MovieClip
					_bt.buttonMode = true;
					_bt.addEventListener(MouseEvent.CLICK , function onClick(e:MouseEvent):void{
						var _mc:MovieClip = e.currentTarget as MovieClip
						var _id:Number = _mc.name.toString().split("_")[1]
						if(callVec[_id]!=null){
							callVec[_id]();
						}
					})
					_bt.addEventListener(MouseEvent.MOUSE_OVER , function onOver(e:MouseEvent):void{
						var _mc:MovieClip = e.currentTarget as MovieClip
						_mc.gotoAndStop(e.type);
					})
					_bt.addEventListener(MouseEvent.MOUSE_OUT , function onOut(e:MouseEvent):void{
						var _mc:MovieClip = e.currentTarget as MovieClip
						_mc.gotoAndStop(e.type);
					})
				}
			}
		}
		
	}
}