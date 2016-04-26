package package_40
{
   import com.waterworld.managers.popups.AbstractPopup;
   import flash.display.MovieClip;
   import com.kixeye.ui.list.List;
   import com.waterworld.utils.movieclip.class_277;
   import com.waterworld.resources.BPResourceManager;
   import package_226.SimpleSliderSkin;
   import com.kixeye.ui.list.class_243;
   import com.waterworld.core.GlobalProperties;
   import com.waterworld.core.GLOBAL;
   import com.waterworld.managers.store.STORE;
   
   public class RocketSpeedupView extends AbstractPopup
   {
       
      protected const const_349:Array = [299,1800,3600];
      
      protected var var_2898:MovieClip;
      
      protected var var_3830:MovieClip;
      
      protected var var_4663:MovieClip;
      
      protected var var_4448:MovieClip;
      
      protected var _list:List;
      
      protected var var_3471:Vector.<RocketSpeedupElement>;
      
      protected var _rocket:class_301;
      
      public function RocketSpeedupView(param1:class_301, param2:int = -1)
      {
         const_349 = [299,1800,3600];
         var_3471 = new Vector.<RocketSpeedupElement>(0);
         _rocket = param1;
         super("AssetRocketPopup_SpeedUps",param2,null,null,"popups_v2");
      }
      
      override protected function initialize() : void
      {
         class_277.setTextOn(_popup,["tWindowHeader"],BPResourceManager.getString("bp-flash","shipdock_shippopup_button_speedup"));
         var_2898 = class_277.getMovieClip(_popup,["EntryPanel"]);
         var_3830 = class_277.getMovieClip(_popup,["Scroll"]);
         var_4663 = class_277.getMovieClip(var_3830,["bg_mc"]);
         var_4448 = class_277.getMovieClip(var_3830,["scroller_mc"]);
         if(!_list)
         {
            _list = new List(var_2898.width,var_2898.height);
            _list.view.x = var_2898.x;
            _list.view.y = var_2898.y;
            _list.sliderControls.skin = new SimpleSliderSkin(var_4663,var_4448);
            _popup.addChild(_list.view);
         }
         populateList();
      }
      
      protected function populateList() : void
      {
         var _loc2_:* = null;
         var _loc1_:* = null;
         var _loc3_:Vector.<class_243> = new Vector.<class_243>(0);
         var _loc6_:* = 0;
         var _loc5_:* = const_349;
         for each(var _loc4_ in const_349)
         {
            _loc2_ = new RocketSpeedupElementModel(_loc4_,_rocket);
            _loc1_ = new RocketSpeedupElement(_loc2_,speedupRocket);
            _loc3_.push(_loc1_);
            var_3471.push(_loc1_);
         }
         _loc2_ = new RocketSpeedupElementModel(_rocket.completeTime - GlobalProperties.gameTime,_rocket);
         _loc1_ = new RocketSpeedupElement(_loc2_,speedupRocket);
         _loc3_.push(_loc1_);
         var_3471.push(_loc1_);
         _list.dataProvider = _loc3_;
      }
      
      public function enableButtons(param1:Boolean) : void
      {
         var _loc4_:* = 0;
         var _loc3_:* = var_3471;
         for each(var _loc2_ in var_3471)
         {
            _loc2_.enableButton(param1);
         }
      }
      
      protected function speedupRocket(param1:int) : void
      {
         GLOBAL.rocketInventory.speedupRocketBuild(_rocket.id,param1,STORE.costForTime(param1),onSpeedupSuccessful,onSpeedupFailure,true);
         enableButtons(false);
      }
      
      protected function onSpeedupSuccessful() : void
      {
         hide();
      }
      
      protected function onSpeedupFailure() : void
      {
         enableButtons(true);
      }
   }
}

import com.waterworld.ui.class_244;
import flash.display.MovieClip;
import flash.text.TextField;
import com.waterworld.display.ButtonManager;
import com.waterworld.resources.BPResourceManager;
import com.waterworld.utils.movieclip.class_277;
import com.waterworld.core.GlobalProperties;
import com.waterworld.managers.store.STORE;

class RocketSpeedupElement extends class_244
{
   
   protected static const ASSET_ID:String = "popups_v2";
    
   protected var _SpeedUpIcon:MovieClip;
   
   protected var _btnBuy:MovieClip;
   
   protected var _tDescription:TextField;
   
   protected var _tPurchaseDescription:TextField;
   
   protected var _clickCallback:Function;
   
   function RocketSpeedupElement(param1:RocketSpeedupElementModel, param2:Function, param3:int = -1)
   {
      _model = param1;
      _clickCallback = param2;
      super();
      load(className,"popups_v2");
   }
   
   public function disable() : void
   {
      _asset.alpha = 0.5;
      ButtonManager.setCaption(_btnBuy,BPResourceManager.getString("bp-flash","campaign_status_unavailable"));
      ButtonManager.detach(_btnBuy);
   }
   
   override public function destroy() : void
   {
      super.destroy();
      ButtonManager.detach(_btnBuy);
   }
   
   protected function get className() : String
   {
      return "AssetListEntrySpeedUp";
   }
   
   protected function get typedModel() : RocketSpeedupElementModel
   {
      return model as RocketSpeedupElementModel;
   }
   
   public function enableButton(param1:Boolean) : void
   {
      ButtonManager.setEnabled(_btnBuy,param1,!param1);
      class_277.setTextOn(_btnBuy,["tCost"],goldCost());
   }
   
   override protected function loaded() : void
   {
      super.loaded();
      _SpeedUpIcon = class_277.getMovieClip(_asset,["SpeedUpIcon"]);
      _btnBuy = class_277.getMovieClip(_asset,["btnBuy"]);
      _tDescription = class_277.getTextField(_asset,["tDescription"]);
      _tPurchaseDescription = class_277.getTextField(_asset,["tPurchaseDescription"]);
      ButtonManager.attach(_btnBuy,onBuy,BPResourceManager.getString("bp-flash","shipdock_popup_button_buy"),null,null,null,null,true,true,null,11,true);
      _tDescription.text = model.label;
      _tPurchaseDescription.text = "";
      class_277.setTextOn(_btnBuy,["tCost"],goldCost());
      class_277.gotoAndStop(_btnBuy,["icon"],"gold");
      var _loc1_:int = typedModel.rocket.completeTime - GlobalProperties.gameTime;
      if(_loc1_ < model.value)
      {
         disable();
      }
      if(STORE.costForTime(model.value) <= 0 && STORE.costForTime(_loc1_))
      {
         disable();
      }
   }
   
   protected function goldCost() : String
   {
      if(STORE.costForTime(model.value) > 0)
      {
         return STORE.costForTime(model.value).toString();
      }
      return BPResourceManager.getString("bp-flash","store_popup_free");
   }
   
   protected function onBuy() : void
   {
      if(_clickCallback != null)
      {
         _clickCallback(model.value);
      }
   }
}

import com.kixeye.ui.list.class_209;
import package_40.class_301;
import com.waterworld.resources.BPResourceManager;
import com.waterworld.utils.class_84;

class RocketSpeedupElementModel extends Object implements class_209
{
    
   private var _seconds:int = 0;
   
   private var _rocket:class_301;
   
   function RocketSpeedupElementModel(param1:int, param2:class_301)
   {
      super();
      _seconds = param1;
      _rocket = param2;
   }
   
   public function destroy() : void
   {
   }
   
   public function get label() : String
   {
      if(_seconds < 300)
      {
         return BPResourceManager.getString("bp-flash","store_popup_sp1_closeenough_description_rocket");
      }
      return BPResourceManager.getString("bp-flash","rocket_build_speedup",{"time":class_84.toTime(_seconds)});
   }
   
   public function get value() : *
   {
      return _seconds;
   }
   
   public function get rocket() : class_301
   {
      return _rocket;
   }
}
