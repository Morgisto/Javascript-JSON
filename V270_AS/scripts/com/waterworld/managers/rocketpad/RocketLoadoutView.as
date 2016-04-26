package com.waterworld.managers.rocketpad
{
   import com.waterworld.managers.popups.AbstractPopup;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import com.waterworld.ui.List2D;
   import package_40.class_301;
   import com.waterworld.utils.movieclip.class_277;
   import com.waterworld.display.ButtonManager;
   import com.waterworld.core.GLOBAL;
   import com.waterworld.datastores.IOShipComponent;
   import package_32.ComponentManager;
   import package_226.SimpleSliderSkin;
   import com.kixeye.ui.list.class_243;
   import com.waterworld.datastores.class_261;
   import package_40.RocketInventoryUpdateEvent;
   import package_40.RocketInventoryManager;
   
   public class RocketLoadoutView extends AbstractPopup
   {
      
      private static const const_685:String = "popups_v2";
      
      private static const ASSET_ID:String = "AssetRocketLoadOutPopup";
       
      protected var var_2240:MovieClip;
      
      protected var var_2586:MovieClip;
      
      protected var var_2523:MovieClip;
      
      protected var var_2806:MovieClip;
      
      protected var var_4598:TextField;
      
      protected var var_3468:TextField;
      
      protected var _tDescription:TextField;
      
      protected var var_4591:TextField;
      
      protected var var_4682:MovieClip;
      
      protected var var_3116:MovieClip;
      
      protected var var_4663:MovieClip;
      
      protected var var_4448:MovieClip;
      
      protected var var_4785:TextField;
      
      protected var var_3402:TextField;
      
      protected var var_4802:TextField;
      
      protected var var_4902:TextField;
      
      protected var var_3371:TextField;
      
      private var _list:List2D;
      
      private var var_1701:RocketBuildButton;
      
      private var var_2318:Vector.<RocketBuildButton>;
      
      private var var_1463:class_301;
      
      private var var_2881:Vector.<class_301>;
      
      private var var_3900:Function;
      
      private var var_3216:Function;
      
      private var var_4096:Function;
      
      private var var_3735:Function;
      
      public function RocketLoadoutView(param1:int = -1)
      {
         super("AssetRocketLoadOutPopup",param1,null,null,"popups_v2");
      }
      
      override protected function initialize() : void
      {
         class_277.setTextOn(_popup,["tWindowHeader"],text("rocket_choose"));
         var_2240 = class_277.getMovieClip(_popup,["btnRemove"]);
         var_2586 = class_277.getMovieClip(_popup,["btnScrap"]);
         var_2523 = class_277.getMovieClip(_popup,["entryGuide"]);
         var_2806 = class_277.getMovieClip(_popup,["mcDetails"]);
         var_4598 = class_277.getTextField(var_2806,["tVXPBonus"]);
         var_3468 = class_277.getTextField(var_2806,["tStats"]);
         _tDescription = class_277.getTextField(var_2806,["tDescription"]);
         var_4591 = class_277.getTextField(var_2806,["tVXPLevel"]);
         var_4682 = class_277.getMovieClip(_popup,["rocketGuide"]);
         var_3116 = class_277.getMovieClip(_popup,["scroll"]);
         var_4663 = class_277.getMovieClip(var_3116,["bg_mc"]);
         var_4448 = class_277.getMovieClip(var_3116,["scroller_mc"]);
         var_4785 = class_277.getTextField(_popup,["tAvailable"]);
         var_3402 = class_277.getTextField(_popup,["tChooseRocket"]);
         var_4802 = class_277.getTextField(_popup,["tPrimary"]);
         var_4902 = class_277.getTextField(_popup,["tRocketLoadout"]);
         var_3371 = class_277.getTextField(_popup,["tSelect"]);
         var_4785.text = text("rocket_available");
         var_3402.text = text("rocket_choose");
         var_4802.text = text("rocket_primary");
         var_4902.text = text("rocket_loadout");
         var_3371.text = text("rocket_select");
         var_4598.text = "";
         var_3468.text = "";
         _tDescription.text = "";
         var_4591.text = "";
         ButtonManager.attach(var_2240,onRemove,text("shipdock_popup_button_remove"));
         ButtonManager.attach(var_2586,onScrap,text("shipdock_shippopup_button_scrap"));
         if(var_3216 == null || !var_1463)
         {
            ButtonManager.setEnabled(var_2240,false,true);
            ButtonManager.setEnabled(var_2586,false,true);
         }
         GLOBAL.rocketInventory.addEventListener("updated",handleUpdatedInventory);
      }
      
      public function setRemoveCallback(param1:Function) : void
      {
         var_3216 = param1;
         if(var_1463)
         {
            ButtonManager.setEnabled(var_2240,true,false);
         }
      }
      
      public function setScrapCallback(param1:Function) : void
      {
         var_3735 = param1;
      }
      
      public function setSelectRocketCallback(param1:Function) : void
      {
         var_4096 = param1;
      }
      
      public function setShownRockets(param1:class_301, param2:Vector.<class_301>) : void
      {
         primaryRocket = param1;
         reserveRockets = param2;
         var_1463 = primaryRocket;
         var_2881 = reserveRockets;
         var_2881 = var_2881.filter(function(param1:class_301, param2:int, param3:Vector.<class_301>):Boolean
         {
            var _loc4_:int = primaryRocket?primaryRocket.id:-1;
            return param1.isComplete && param1.id != _loc4_;
         });
         setupRocketButtons();
      }
      
      private function getComponentsFromRockets() : Vector.<IOShipComponent>
      {
         var _loc5_:* = 0;
         var _loc4_:* = 0;
         var _loc3_:Vector.<class_301> = var_2881.slice();
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length - 1)
         {
            _loc4_ = _loc5_ + 1;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc3_[_loc5_].itemCode === _loc3_[_loc4_].itemCode)
               {
                  _loc3_.splice(_loc4_,1);
                  _loc4_--;
               }
               _loc4_++;
            }
            _loc5_++;
         }
         var _loc1_:Vector.<IOShipComponent> = new Vector.<IOShipComponent>(0);
         var _loc7_:* = 0;
         var _loc6_:* = _loc3_;
         for each(var _loc2_ in _loc3_)
         {
            _loc1_.push(ComponentManager.getInstance().getComponent(_loc2_.itemCode));
         }
         return _loc1_;
      }
      
      private function setupRocketButtons() : void
      {
         var _loc2_:* = null;
         var _loc4_:* = null;
         var _loc7_:MovieClip = var_4663;
         var _loc6_:MovieClip = var_4448;
         if(_list)
         {
            _popup.removeChild(_list.view);
         }
         _list = new List2D(var_2523.width,var_2523.height);
         _list.view.x = var_2523.x;
         _list.view.y = var_2523.y;
         _list.sliderControls.skin = new SimpleSliderSkin(_loc7_,_loc6_);
         _popup.addChild(_list.view);
         class_277.bringToFront(var_3116);
         var _loc5_:Vector.<IOShipComponent> = getComponentsFromRockets();
         _loc5_.sort(sortRockets);
         var _loc3_:Vector.<class_243> = new Vector.<class_243>(0);
         destroyRocketButtons();
         var_2318 = new Vector.<RocketBuildButton>();
         var _loc9_:* = 0;
         var _loc8_:* = _loc5_;
         for each(var _loc1_ in _loc5_)
         {
            _loc2_ = new RocketBuildButton(_loc1_.id,true,onRocketClick);
            _loc3_.push(_loc2_);
            var_2318.push(_loc2_);
         }
         _list.dataProvider = _loc3_;
         if(var_1463)
         {
            var_1701 = new RocketBuildButton(var_1463.itemCode,true);
            _loc4_ = ComponentManager.getInstance().getComponent(var_1463.itemCode);
            var_4682.addChild(var_1701.display);
            _loc9_ = false;
            var_3371.visible = _loc9_;
            var_3402.visible = _loc9_;
            _tDescription.text = _loc4_.desc;
            var_3468.htmlText = class_261.print(_loc4_.stats());
            ButtonManager.setEnabled(var_2240,true,false);
            ButtonManager.setEnabled(var_2586,true,false);
         }
         else
         {
            _loc8_ = true;
            var_3371.visible = _loc8_;
            var_3402.visible = _loc8_;
            var_3468.text = "";
            _tDescription.text = "";
            ButtonManager.setEnabled(var_2240,false,true);
            ButtonManager.setEnabled(var_2586,false,true);
         }
      }
      
      private function handleUpdatedInventory(param1:RocketInventoryUpdateEvent) : void
      {
         var _loc2_:RocketInventoryManager = GLOBAL.rocketInventory;
         setShownRockets(_loc2_.getCurrentRocket(),_loc2_.rocketInventory);
      }
      
      private function destroyRocketButtons() : void
      {
         if(var_2318)
         {
            var _loc3_:* = 0;
            var _loc2_:* = var_2318;
            for each(var _loc1_ in var_2318)
            {
               _loc1_.destroy();
            }
         }
         var_2318 = null;
         if(var_1701)
         {
            var_1701.display.parent.removeChild(var_1701.display);
         }
         var_1701 = null;
      }
      
      private function sortRockets(param1:IOShipComponent, param2:IOShipComponent) : int
      {
         return param1.sortOrder - param2.sortOrder;
      }
      
      private function onRocketClick(param1:String, param2:*, param3:Object = null) : void
      {
         var _loc4_:* = null;
         var _loc5_:IOShipComponent = param3.comp;
         if(var_4096 != null)
         {
            _loc4_ = GLOBAL.rocketInventory.getUniqueRocket(_loc5_.id);
            var_4096(_loc4_);
         }
      }
      
      private function onRemove() : void
      {
         var _loc1_:* = null;
         if(var_3216 != null)
         {
            _loc1_ = var_1463;
            var_3216(_loc1_);
         }
      }
      
      private function onScrap() : void
      {
         if(var_3735 != null)
         {
            var_3735(var_1463);
         }
      }
      
      override public function destroy() : void
      {
         GLOBAL.rocketInventory.removeEventListener("updated",handleUpdatedInventory);
         super.destroy();
      }
   }
}

var text;
