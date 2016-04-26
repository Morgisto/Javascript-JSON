package com.waterworld.managers.rocketpad
{
   import com.waterworld.managers.popups.AbstractPopup;
   import com.kixeye.popups.IPopupBehavior;
   import com.waterworld.datastores.IOShipComponent;
   import flash.display.MovieClip;
   import com.waterworld.display.ScrollSet;
   import package_259.EnhancedCostsComponent;
   import com.waterworld.display.ButtonManager;
   import package_166.OfficerManager;
   import package_32.ComponentManager;
   import com.waterworld.utils.movieclip.class_277;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.core.GLOBAL;
   import flash.text.TextField;
   import package_166.BuildingOfficerTray;
   import com.waterworld.datastores.IOBuildingCosts;
   import package_10.BaseManager;
   import com.waterworld.entities.RocketLaunchPad;
   import com.waterworld.utils.class_84;
   import com.waterworld.utils.class_295;
   import com.waterworld.managers.store.STORE;
   import package_40.RocketInventoryManager;
   import package_97.RESEARCH;
   import com.waterworld.entities.BuildingFoundation;
   import com.waterworld.ui.ComponentIcon;
   import com.waterworld.display.TooltipManager;
   import com.waterworld.ui.ComponentTooltip;
   import com.waterworld.datastores.class_261;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import com.waterworld.utils.SoftwareDisplay;
   import com.waterworld.utils.class_165;
   import flash.geom.Rectangle;
   import flash.events.TimerEvent;
   import flash.events.Event;
   import package_23.OneButtonMessagePopup;
   import com.waterworld.core.GlobalProperties;
   import com.waterworld.core.BASE;
   import package_23.MessagePopup;
   import com.waterworld.core.PurchaseManager;
   import com.waterworld.managers.store.StoreManager;
   
   public class RocketPopupInfo extends AbstractPopup implements IPopupBehavior
   {
      
      private static const const_18:String = "AssetRocketPopupInfo_V2";
      
      protected static const const_764:int = 3;
       
      private var var_1030:int;
      
      private var var_5:IOShipComponent;
      
      private var var_1961:int;
      
      private var var_600:MovieClip;
      
      private var var_448:MovieClip;
      
      private var var_254:ScrollSet;
      
      private var var_85:EnhancedCostsComponent;
      
      public function RocketPopupInfo(param1:int, param2:int, param3:int)
      {
         var_1030 = param1;
         var_1961 = param3;
         super("AssetRocketPopupInfo_V2",param2);
      }
      
      override public function destroy() : void
      {
         var_5 = null;
         ButtonManager.detach(var_600);
         var_600 = null;
         ButtonManager.detach(var_448);
         var_448 = null;
         var_254 = null;
         OfficerManager.getInstance().removeEventListener("officerassigned",officerAssigned);
         var_85.destroy();
         var_85 = null;
         super.destroy();
      }
      
      override protected function initialize() : void
      {
         var_5 = ComponentManager.getInstance().getComponent(var_1030);
         centerPopup();
         var_600 = class_277.getMovieClip(_popup,["bAction"]);
         var_448 = class_277.getMovieClip(_popup,["bInstant"]);
         var_85 = new EnhancedCostsComponent("TYPE_BUILD",_popup,id,var_5.costs,topoffB);
         class_277.setTextOn(_popup,["tWindowHeader"],BPResourceManager.getString("bp-flash","rocketpad_popupinfo_title"));
         class_277.setTextOn(_popup,["costsComponent","costTitle"],BPResourceManager.getString("bp-flash","rocketpad_popupinfo_cost"));
         class_277.setTextOn(_popup,["mcBlocker","tBlocker"],"");
         var _loc1_:int = GLOBAL.rocketInventory.getNumRocketsOfType(var_1030);
         var _loc2_:TextField = class_277.getTextField(_popup,["tCount"]);
         if(_loc1_ >= 0)
         {
            class_277.setTextOnTextField(_loc2_,"x" + _loc1_);
         }
         updateRocketInfoDisplay();
         updateCostsDisplay();
         ButtonManager.attach(var_448,onBuyClicked);
         startTimer();
         var _loc3_:OfficerManager = OfficerManager.getInstance();
         if(_loc3_.isBuildingOfficerEnabled(var_1961))
         {
            view.addChildAt(new BuildingOfficerTray(var_1961,view),0);
            _loc3_.addEventListener("officerassigned",officerAssigned,false,0,true);
         }
         checkRocketCapacity();
      }
      
      private function updateCostsDisplay() : void
      {
         var _loc6_:* = 0;
         var _loc5_:IOBuildingCosts = var_5.costs;
         var _loc1_:Array = [BaseManager.getInstance().oil,BaseManager.getInstance().metal,BaseManager.getInstance().energy,BaseManager.getInstance().zynthium];
         _loc6_ = 0;
         while(_loc6_ < 4)
         {
            var_85.setCostText(_loc6_ + 1,_loc5_["r" + (_loc6_ + 1)],_loc5_["r" + (_loc6_ + 1)] > _loc1_[_loc6_]);
            _loc6_++;
         }
         var _loc2_:Number = RocketLaunchPad.getBuildTime(var_1030);
         if(_loc2_ && _loc2_ > 0)
         {
            var_85.setTimeCost(class_84.toTime(_loc2_,true));
         }
         var _loc3_:int = BaseManager.getInstance().checkCost(_loc5_);
         ButtonManager.setEnabled(var_600,true,false);
         if(_loc3_)
         {
            _popup.mcBlocker.tBlocker.htmlText = class_295.applyTemplateToKey("research_popup_info_not_enough",{"badResource":GLOBAL.getResourceName(_loc3_)});
            ButtonManager.attach(var_600,topoff,BPResourceManager.getString("bp-flash","rocketpad_popupinfo_button_getresources"));
         }
         else
         {
            ButtonManager.attach(var_600,onActionStart);
         }
         if(!STORE.canBuy)
         {
            ButtonManager.setEnabled(var_448,false,true);
         }
         else
         {
            ButtonManager.setEnabled(var_448,true);
         }
         checkRocketCapacity();
         var _loc4_:int = GLOBAL.bRocketPad.getInstantRocketCost(var_1030);
         var_85.setBuyNowButton(_loc4_);
      }
      
      private function checkRocketCapacity() : void
      {
         var _loc3_:RocketInventoryManager = GLOBAL.rocketInventory;
         var _loc4_:int = _loc3_.numRockets;
         var _loc2_:int = _loc3_.capacity;
         var _loc1_:* = _loc3_.getBuildingRocket() != null;
         if(_loc4_ >= _loc2_ || _loc1_)
         {
            ButtonManager.setEnabled(var_600,false,true);
            ButtonManager.setEnabled(var_448,false,true);
         }
      }
      
      private function updateRocketInfoDisplay() : void
      {
         var _loc7_:* = null;
         var _loc10_:* = 0;
         var _loc5_:* = null;
         var _loc1_:BuildingFoundation = RESEARCH.getResearchBuildingForType(var_5.type);
         var _loc2_:String = "";
         if(var_5.desc)
         {
            _loc2_ = _loc2_ + var_5.desc;
         }
         var _loc8_:* = true;
         if(!RESEARCH.isResearched(id))
         {
            if(var_5.labLevel > _loc1_.level)
            {
               _loc8_ = false;
               _loc2_ = _loc2_ + class_295.applyTemplateToKey("research_popup_info_not_researched",{
                  "labLevel":var_5.labLevel,
                  "name":_loc1_._buildingProps.name
               });
            }
         }
         var _loc4_:MovieClip = new MovieClip();
         if(var_5 is IOShipComponent)
         {
            _loc7_ = RESEARCH.getPrerequisites(var_5);
         }
         var _loc13_:* = true;
         _loc7_.sortOn("weight",16);
         _loc10_ = 0;
         while(_loc10_ < _loc7_.length)
         {
            _loc13_ = false;
            _loc5_ = new ComponentIcon();
            _loc5_.update(_loc7_[_loc10_]);
            _loc4_.addChild(_loc5_);
            _loc5_.x = _loc10_ * _loc5_.width - Math.floor(_loc10_ / 3) * _loc5_.width * 3;
            _loc5_.y = Math.floor(_loc10_ / 3) * _loc5_.height;
            TooltipManager.getInstance().addStaticVisualTooltip(_loc5_,ComponentTooltip.showForComp(var_5));
            _loc10_++;
         }
         if(_loc8_ && !_loc13_)
         {
            _loc2_ = _loc2_ + BPResourceManager.getString("bp-flash","research_popup_info_requirements");
         }
         if(!_loc8_ || !_loc13_)
         {
            class_277.setTextOn(_popup,["mcBlocker","tBlocker"],BPResourceManager.getString("bp-flash","research_popup_info_b_req_not_met"));
         }
         var _loc9_:String = BPResourceManager.getString("bp-flash","research_popup_info_stats");
         _loc9_ = _loc9_ + class_261.print(var_5.stats());
         var _loc3_:TextField = class_277.getTextField(_popup,["mcDetails","tDescription"]);
         var _loc11_:TextField = class_277.getTextField(_popup,["mcDetails","tStats"]);
         var _loc14_:* = false;
         _loc11_.mouseEnabled = _loc14_;
         _loc3_.mouseEnabled = _loc14_;
         _loc3_.autoSize = "left";
         _loc11_.autoSize = "left";
         _loc3_.htmlText = _loc2_;
         _loc4_.x = _loc3_.x;
         _loc4_.y = _loc3_.y + _popup.mcDetails.tDescription.textHeight + 10;
         _loc11_.htmlText = _loc9_;
         _loc11_.y = _loc4_.y + _loc4_.height + 10;
         _popup.mcDetails.addChild(_loc4_);
         var _loc6_:TextField = class_277.getTextField(_popup,["mcDetails","tVXPLevel"]);
         _loc6_.visible = false;
         var _loc12_:TextField = class_277.getTextField(_popup,["mcDetails","tVXPBonus"]);
         _loc12_.visible = false;
         class_277.setTextOn(_popup,["mcContentHeader","tContentHeader"],var_5.fullName);
         GLOBAL.assets.getImageByURLAsync(var_5.iconlarge,onMainImage,null,true);
         if(RESEARCH.isResearched(var_5.id))
         {
            var_85.showCostIcons();
            var_85.setCosts(var_5.costs);
         }
         else
         {
            var_85.hideCostIcons();
         }
      }
      
      protected function onMainImage(param1:Vector.<String>) : void
      {
         if(!_popup)
         {
            return;
         }
         var _loc2_:BitmapData = GLOBAL.assets.getBitmapData(param1[0]);
         var _loc3_:Bitmap = new Bitmap(_loc2_,"auto",true);
         formatMainImage(new SoftwareDisplay(_loc3_));
      }
      
      protected function formatMainImage(param1:class_165) : void
      {
         param1.addToContainer(_popup);
         var _loc2_:Rectangle = param1.getBounds(_popup);
         param1.x = _popup.imageMask.x + (_popup.imageMask.width - _loc2_.width) / 2 - _loc2_.x;
         param1.y = _popup.imageMask.y + (_popup.imageMask.height - _loc2_.height) / 2 - _loc2_.y;
         SoftwareDisplay(param1).mask = _popup.imageMask;
      }
      
      override protected function timerUpdate(param1:TimerEvent) : void
      {
         updateCostsDisplay();
      }
      
      private function officerAssigned(param1:Event = null) : void
      {
         updateCostsDisplay();
      }
      
      private function onBuyClicked() : void
      {
         GLOBAL.bRocketPad.buildRocketInstantly(var_1030);
         hide();
      }
      
      protected function onActionStart() : void
      {
         var _loc1_:int = var_1030;
         hide();
         if(!GLOBAL.bRocketPad.isBuildingRocket)
         {
            GLOBAL.bRocketPad.startRocketBuild(_loc1_);
         }
      }
      
      private function topoff(param1:String, param2:*, param3:Object = null) : void
      {
         var _loc4_:* = 0;
         var _loc11_:* = 0;
         var _loc10_:* = null;
         var _loc8_:* = null;
         var _loc5_:* = 0;
         var _loc7_:* = false;
         var _loc9_:IOBuildingCosts = ComponentManager.getInstance().getComponent(var_1030).costs;
         var _loc6_:Array = [0,0,0,0];
         _loc11_ = 1;
         while(_loc11_ < 5)
         {
            if(_loc9_["r" + _loc11_] > 0)
            {
               if(_loc9_["r" + _loc11_] > BaseManager.getInstance().getResourceMaxCapacity(_loc11_))
               {
                  _loc7_ = true;
               }
               else if(_loc9_["r" + _loc11_] > BaseManager.getInstance().getResource(_loc11_))
               {
                  _loc5_ = _loc5_ + (_loc9_["r" + _loc11_] - BaseManager.getInstance().getResource(_loc11_));
                  _loc6_[_loc11_ - 1] = _loc9_["r" + _loc11_] - BaseManager.getInstance().getResource(_loc11_);
               }
            }
            _loc11_++;
         }
         _loc4_ = STORE.costForResources(_loc5_);
         if(_loc7_)
         {
            new OneButtonMessagePopup(BPResourceManager.getString("bp-flash","generic_popup_title"),BPResourceManager.getString("bp-flash","rocketpad_popupoptions_needcapacity_message"),null,BPResourceManager.getString("bp-flash","generic_popup_ok"),null,this.id);
         }
         else
         {
            _loc10_ = GlobalProperties.currency == "fbc"?"global_fbc_name":"global_gold_name";
            _loc8_ = GLOBAL.createMessagePopup(class_295.applyTemplateToKey("rocketpad_popupoptions_purchaseextra_message",{
               "cost":GLOBAL.formatNumber(_loc5_),
               "shinyCost":_loc4_,
               "goldName":BPResourceManager.getString("bp-flash",BASE.credits >= _loc4_?"global_gold_name":_loc10_)
            }),id,BPResourceManager.getString("bp-flash","rocketpad_popupoptions_button_buy"),topoffB,[_loc4_,_loc6_]);
            if(BASE.credits < _loc4_ && GlobalProperties.currency == "fbc")
            {
               _loc8_.addIconToBuyButton();
            }
         }
      }
      
      private function topoffB(param1:int, param2:Array) : void
      {
         var _loc3_:* = 0;
         var _loc7_:* = 0;
         var _loc5_:* = null;
         var _loc4_:IOShipComponent = ComponentManager.getInstance().getComponent(var_1030);
         var _loc6_:IOBuildingCosts = _loc4_.costs;
         if(!PurchaseManager.hasPendingPurchase() && !STORE.var_283)
         {
            _loc3_ = 0;
            _loc7_ = 0;
            while(_loc7_ < param2.length)
            {
               _loc3_ = _loc3_ + param2[_loc7_];
               _loc7_++;
            }
            _loc5_ = "RocketPopupInfo:" + var_1030;
            StoreManager.getInstance().getMultipleResourcesItem("RTOPUP",_loc5_,param2[0],param2[1],param2[2],param2[3],topoffC,[_loc6_]).buy();
         }
      }
      
      private function topoffC(param1:IOBuildingCosts) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 1;
         while(_loc2_ < 5)
         {
            if(param1["r" + _loc2_] > 0 && param1["r" + _loc2_] > BaseManager.getInstance().getResource(_loc2_))
            {
               BaseManager.getInstance().setResource(_loc2_,param1["r" + _loc2_]);
            }
            _loc2_++;
         }
         updateCostsDisplay();
      }
   }
}
