package com.waterworld.managers.store.storeitem
{
   import package_23.ZeroButtonMessagePopup;
   import package_155.class_290;
   import package_32.ComponentManager;
   import com.waterworld.datastores.IOShipComponent;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.utils.class_295;
   import com.kixeye.popups.PopupManager;
   import com.waterworld.managers.store.STORE;
   import com.waterworld.core.BASE;
   import package_23.OneButtonMessagePopup;
   
   public class BlueprintStoreItem extends StoreItem
   {
       
      private var var_1732:ZeroButtonMessagePopup;
      
      public function BlueprintStoreItem(param1:String)
      {
         super(param1);
      }
      
      public function initToBuy(param1:int) : void
      {
         var_18 = param1;
         var_87.Set(class_290.instantCompleteCost(param1));
         var _loc2_:IOShipComponent = ComponentManager.getInstance().getComponent(param1);
         setFBCWindowProps(BPResourceManager.getString("bp-flash","store_blueprintstoreitem_title"),class_295.applyTemplateToKey("store_blueprintstoreitem_message",{"componentName":_loc2_.fullName}),class_290.numPiecesLeftForComp(param1),"BuildingBlueprints");
      }
      
      override public function getAnalyticsData() : Object
      {
         var _loc2_:Object = super.getAnalyticsData();
         _loc2_.item_id = var_18;
         _loc2_.action = "researched";
         var _loc1_:IOShipComponent = ComponentManager.getInstance().getComponent(var_18);
         _loc2_.speedup_seconds = _loc1_.costs.time;
         _loc2_.r1 = _loc1_.costs.r1;
         _loc2_.r2 = _loc1_.costs.r2;
         _loc2_.r3 = _loc1_.costs.r3;
         _loc2_.r4 = _loc1_.costs.r4;
         return _loc2_;
      }
      
      override public function buy(param1:Function = null) : void
      {
         super.buy(param1);
         var _loc2_:String = BPResourceManager.getString("bp-flash","inventory_controller_save_title");
         var _loc3_:String = BPResourceManager.getString("bp-flash","inventory_controller_save_message");
         var _loc4_:int = PopupManager.getInstance().currentParentId;
         var_1732 = new ZeroButtonMessagePopup(_loc2_,_loc3_,_loc4_);
         STORE.purchaseNew(this);
         BASE.save(0,true,handleSaveComplete);
      }
      
      private function handleSaveComplete(param1:Boolean) : void
      {
         var _loc2_:* = 0;
         if(param1)
         {
            BASE.checkForUpdates(handleUpdatesProcessed);
         }
         else
         {
            var_1732.hide();
            var_1732 = null;
            _loc2_ = PopupManager.getInstance().currentParentId;
            new OneButtonMessagePopup(null,BPResourceManager.getString("bp-flash","store_blueprintstoreitem_error_couldntcreate"),null,null,null,_loc2_);
         }
      }
      
      private function handleUpdatesProcessed() : void
      {
         class_290.hideInfo();
         var_1732.hide();
         var_1732 = null;
      }
   }
}
