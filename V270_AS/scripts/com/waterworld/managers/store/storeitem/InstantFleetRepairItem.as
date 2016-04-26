package com.waterworld.managers.store.storeitem
{
   import com.waterworld.core.GLOBAL;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.utils.class_295;
   import com.waterworld.utils.class_84;
   import com.kixeye.utils.json.ActionJSON;
   import com.waterworld.datastores.IOBuildingCosts;
   import package_59.class_120;
   import com.waterworld.entities.ShipDock;
   import com.waterworld.managers.store.STORE;
   
   public class InstantFleetRepairItem extends StoreItem
   {
       
      private var var_1806:Array;
      
      private var var_5639:Vector.<int>;
      
      public function InstantFleetRepairItem(param1:String)
      {
         super(param1);
      }
      
      public function initToBuy(param1:int, param2:Vector.<int>, param3:Array = null) : void
      {
         var_1806 = param3;
         var_18 = param1;
         var_5639 = param2;
         var_87.Set(GLOBAL.bShipDock.instantRepairCost(param1));
         var _loc4_:int = GLOBAL.bShipDock.repairTimeForFleet(param1);
         setFBCWindowProps(BPResourceManager.getString("bp-flash","store_instantfleetrepairitem_title"),class_295.applyTemplateToKey("store_instantfleetrepairitem_message",{"time":class_84.toTime(_loc4_)}),_loc4_,"RepairFleetInstantly");
      }
      
      override public function getAnalyticsData() : Object
      {
         var _loc1_:* = null;
         var _loc3_:Object = super.getAnalyticsData();
         _loc3_.action = "repaired";
         var _loc6_:int = GLOBAL.bShipDock.repairTimeForFleet(var_18);
         var _loc7_:int = GLOBAL.bShipDock.repairArmorTimeForFleet(var_18);
         var _loc2_:Object = {"speedup_seconds":_loc6_};
         if(_loc6_ != _loc7_)
         {
            _loc2_["armor_seconds"] = _loc7_;
            _loc2_["drone_seconds"] = _loc6_ - _loc7_;
         }
         _loc3_.description = ActionJSON.encodeJSON(_loc2_);
         var _loc5_:IOBuildingCosts = GLOBAL.bShipDock.repairCostForFleet(var_18);
         _loc3_.r1 = _loc5_.r1;
         _loc3_.r2 = _loc5_.r2;
         _loc3_.r3 = _loc5_.r3;
         _loc3_.r4 = _loc5_.r4;
         if(var_1806)
         {
            _loc1_ = [];
            var _loc9_:* = 0;
            var _loc8_:* = var_1806;
            for each(var _loc4_ in var_1806)
            {
               _loc1_.push(_loc4_.toObject());
            }
            _loc3_.logging = ActionJSON.encodeJSON(_loc1_);
         }
         return _loc3_;
      }
      
      override public function apply(param1:Object) : String
      {
         super.apply(param1);
         return doApply();
      }
      
      override protected function doApply(param1:String = null) : String
      {
         var _loc2_:ShipDock = GLOBAL.bShipDock;
         return _loc2_.applyInstantRepair(var_18,true,this);
      }
      
      public function doValidateCost(param1:int, param2:int, param3:int) : void
      {
         validateCost(param1,param2,param3);
      }
      
      override public function buy(param1:Function = null) : void
      {
         super.buy(param1);
         STORE.purchaseNew(this);
      }
      
      public function get shipIDs() : Vector.<int>
      {
         return var_5639;
      }
   }
}
