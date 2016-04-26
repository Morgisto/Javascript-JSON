package com.waterworld.managers.rocketpad
{
   import com.waterworld.core.GLOBAL;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.datastores.IOShipComponent;
   import package_134.MessageImagePopup;
   import package_32.ComponentManager;
   import com.kixeye.popups.PopupManager;
   import com.waterworld.managers.popups.POPUPS;
   import com.waterworld.core.LOGIN;
   import com.waterworld.utils.javascript.class_46;
   import com.waterworld.utils.class_295;
   import com.waterworld.entities.RocketLaunchPad;
   import package_10.BaseManager;
   import com.waterworld.datastores.IOBuilding;
   import package_97.RESEARCH;
   import package_40.RocketInventoryManager;
   import package_40.class_301;
   
   public class class_173 extends Object
   {
      
      private static var var_2142:int;
       
      public function class_173()
      {
         super();
      }
      
      public static function show() : void
      {
         if(!GLOBAL.bWeaponLab)
         {
            GLOBAL.createMessagePopup(BPResourceManager.getString("bp-flash","rocketpad_noweaponslab_message"),-1,null,null,null,BPResourceManager.getString("bp-flash","rocketpad_noweaponslab_title"));
            return;
         }
         var _loc1_:RocketPopup = getPopup();
         if(null == _loc1_)
         {
            var_2142 = new RocketPopup().id;
         }
      }
      
      public static function showRocketComplete(param1:int) : void
      {
         compId = param1;
         var comp:IOShipComponent = ComponentManager.getInstance().getComponent(compId);
         var imgStr:String = comp.icon;
         var popup:MessageImagePopup = new MessageImagePopup(BPResourceManager.getString("bp-flash","popups_showrocketcomplete_title"),BPResourceManager.getString("bp-flash","popups_showrocketcomplete_message"),comp.fullName,imgStr,null,null,PopupManager.getInstance().currentParentId);
         popup.setLeftButton(false);
         if(GLOBAL.const_13.isFeatureAvailable("brag"))
         {
            onRocketBrag = function():void
            {
               var _loc1_:int = compId - compId % 10;
               var _loc3_:String = POPUPS.getInstance().getRandomStreamImage();
               var _loc2_:Object = {};
               _loc2_["#fname#"] = LOGIN.firstNameForBrag;
               if(GLOBAL.ROOT.stage.displayState != "normal")
               {
                  GLOBAL.toggleFullScreen();
               }
               class_46.CallJS("sendFeed",["rocket-completed-" + _loc3_.split(".")[0],BPResourceManager.getString("bp-flash","stream_rck" + _loc1_ + "_title"),class_295.applyTemplate(BPResourceManager.getString("bp-flash","stream_rck" + _loc1_ + "_body",{"v1":comp.fullName}),_loc2_),_loc3_,0]);
               popup.hide();
            };
            popup.setRightButton(true,BPResourceManager.getString("bp-flash","popups_showrocketcomplete_button_brag"),onRocketBrag);
         }
         else
         {
            popup.setRightButton(false);
         }
      }
      
      public static function canBuild(param1:int) : Object
      {
         var _loc2_:Object = {};
         var _loc3_:IOShipComponent = ComponentManager.getInstance().getComponent(param1);
         var _loc4_:RocketLaunchPad = GLOBAL.bRocketPad;
         var _loc5_:IOBuilding = BaseManager.getInstance().getBuilding(73);
         if(_loc4_)
         {
            if(_loc4_.level < _loc3_.padLevel)
            {
               _loc2_.error = true;
               _loc2_.errorMessage = class_295.applyTemplateToKey("rocketpad_needupgrade_message",{
                  "level":_loc3_.padLevel,
                  "props":_loc5_.name
               });
               _loc2_.errorPad = true;
            }
            else if(!RESEARCH.isResearched(param1))
            {
               _loc2_.error = true;
               _loc2_.errorMessage = BPResourceManager.getString("bp-flash","rocketpad_needresearch_message");
               _loc2_.errorResearch = true;
            }
         }
         else
         {
            _loc2_.error = true;
            _loc2_.errorMessage = class_295.applyTemplateToKey("rocketpad_needprop_message",{"props":_loc5_.name});
         }
         return _loc2_;
      }
      
      public static function hide() : void
      {
         var _loc1_:RocketPopup = getPopup();
         if(null != _loc1_)
         {
            _loc1_.hide();
         }
      }
      
      public static function tick() : void
      {
         var _loc1_:RocketPopup = getPopup();
         if(null != _loc1_)
         {
            _loc1_.update();
         }
      }
      
      public static function hideInfo() : void
      {
         var _loc1_:RocketPopup = getPopup();
         if(null != _loc1_)
         {
            _loc1_.hideInfo();
         }
      }
      
      public static function getComponents(param1:Boolean = false) : Vector.<IOShipComponent>
      {
         var _loc2_:Vector.<IOShipComponent> = new Vector.<IOShipComponent>();
         var _loc4_:Array = ComponentManager.getInstance().getComponentsAsArray();
         var _loc6_:* = 0;
         var _loc5_:* = _loc4_;
         for each(var _loc3_ in _loc4_)
         {
            if(_loc3_.type == "r" && "npc" != _loc3_.category)
            {
               if(param1)
               {
                  if(RESEARCH.isResearched(_loc3_.id))
                  {
                     _loc2_.push(_loc3_);
                  }
               }
               else
               {
                  _loc2_.push(_loc3_);
               }
            }
         }
         return _loc2_;
      }
      
      private static function getPopup() : RocketPopup
      {
         return PopupManager.getInstance().getPopupById(var_2142) as RocketPopup;
      }
      
      public static function showLoadoutPopup(param1:int = -1) : void
      {
         var _loc2_:RocketInventoryManager = GLOBAL.rocketInventory;
         var _loc3_:RocketLoadoutView = new RocketLoadoutView(param1);
         _loc3_.setShownRockets(_loc2_.getCurrentRocket(),_loc2_.rocketInventory);
         _loc3_.setSelectRocketCallback(prepareRocket);
         _loc3_.setScrapCallback(scrapRocket);
         _loc3_.setRemoveCallback(unprepareCurrentRocket);
      }
      
      private static function prepareRocket(param1:class_301) : void
      {
         GLOBAL.rocketInventory.prepareRocket(param1.id,updateRocketPadVisual,null,true);
      }
      
      private static function scrapRocket(param1:class_301) : void
      {
         GLOBAL.bRocketPad.scrapRocket(param1.id,PopupManager.getInstance().currentParentId);
      }
      
      private static function unprepareCurrentRocket(param1:class_301) : void
      {
         if(param1)
         {
            GLOBAL.rocketInventory.unprepareRocket(param1.id,updateRocketPadVisual,null,true);
         }
      }
      
      private static function updateRocketPadVisual() : void
      {
         GLOBAL.bRocketPad.setupRocket();
      }
   }
}
