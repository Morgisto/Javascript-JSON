package com.waterworld.managers.store.storeitem
{
   import com.waterworld.datastores.ComponentRetrofitGroup;
   import package_64.InventoryController;
   import package_32.ComponentManager;
   import com.waterworld.datastores.IOBuildingCosts;
   import package_97.RESEARCH;
   import com.waterworld.datastores.class_118;
   import com.waterworld.core.GLOBAL;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.utils.class_295;
   import com.waterworld.utils.class_84;
   import package_59.class_120;
   import com.kixeye.utils.json.ActionJSON;
   import com.waterworld.entities.BuildingGenericResearch;
   import com.waterworld.core.GlobalProperties;
   import package_59.ResearchLogEvent;
   import package_59.class_223;
   import com.waterworld.managers.store.STORE;
   
   public class ResearchStoreItem extends StoreItem
   {
       
      private var _time:int;
      
      private var var_1806:Array;
      
      public function ResearchStoreItem(param1:String)
      {
         super(param1);
      }
      
      public function initToBuy(param1:int, param2:Array = null) : void
      {
         var _loc5_:* = null;
         var _loc6_:* = 0;
         var _loc4_:* = 0;
         var _loc7_:* = null;
         var _loc8_:* = null;
         var _loc3_:* = null;
         if(ComponentRetrofitGroup.isValidID(param1))
         {
            _loc4_ = InventoryController.getInstance().getItemLevelForCompID(param1) + 1;
            _loc7_ = ComponentManager.getInstance().getCRGroupById(param1);
            _loc8_ = _loc7_.calcIOBuildingCosts(_loc4_);
            _time = _loc8_.time;
            _loc6_ = _loc8_.totalCosts;
            var_87.Set(RESEARCH.instantCostForGroup(param1,_loc4_));
            _loc5_ = _loc7_.fullName();
         }
         else
         {
            _loc3_ = ComponentManager.getInstance().getComponent(param1);
            if(!_loc3_)
            {
               _loc3_ = GLOBAL.const_9.getRepairSpecialistByID(param1);
            }
            var_87.Set(RESEARCH.instantCost(_loc3_));
            _time = RESEARCH.researchTime(_loc3_);
            _loc5_ = _loc3_.name;
            _loc6_ = _loc3_.researchCosts.totalCosts;
         }
         var_18 = param1;
         var_1806 = param2;
         setFBCWindowProps(BPResourceManager.getString("bp-flash","store_researchstoreitem_researchinstantly_title"),class_295.applyTemplateToKey("store_researchstoreitem_researchinstantly_message",{
            "componentName":_loc5_,
            "time":class_84.toTime(_time)
         }),_loc6_ + _time,"ResearchInstantly");
      }
      
      override public function getAnalyticsData() : Object
      {
         var _loc6_:* = null;
         var _loc2_:* = 0;
         var _loc1_:* = null;
         var _loc3_:* = null;
         var _loc4_:Object = super.getAnalyticsData();
         _loc4_.item_id = var_18;
         _loc4_.item_level = 1;
         _loc4_.action = "researched";
         _loc4_.speedup_seconds = _time;
         if(ComponentRetrofitGroup.isValidID(var_18))
         {
            _loc2_ = InventoryController.getInstance().getItemLevelForCompID(var_18);
            _loc6_ = ComponentManager.getInstance().getCRGroupById(var_18).calcIOBuildingCosts(_loc2_);
         }
         else
         {
            _loc1_ = ComponentManager.getInstance().getComponent(var_18);
            if(!_loc1_)
            {
               _loc1_ = GLOBAL.const_9.getRepairSpecialistByID(var_18);
            }
            _loc6_ = _loc1_.researchCosts;
         }
         _loc4_.r1 = _loc6_.r1;
         _loc4_.r2 = _loc6_.r2;
         _loc4_.r3 = _loc6_.r3;
         _loc4_.r4 = _loc6_.r4;
         if(var_1806)
         {
            _loc3_ = [];
            var _loc8_:* = 0;
            var _loc7_:* = var_1806;
            for each(var _loc5_ in var_1806)
            {
               _loc3_.push(_loc5_.toObject());
            }
            _loc4_.logging = ActionJSON.encodeJSON(_loc3_);
         }
         return _loc4_;
      }
      
      override public function apply(param1:Object) : String
      {
         super.apply(param1);
         return doApply();
      }
      
      override protected function doApply(param1:String = null) : String
      {
         var _loc7_:* = null;
         var _loc5_:* = null;
         var _loc2_:* = null;
         var _loc10_:* = 0;
         var _loc9_:* = 0;
         var _loc3_:* = null;
         var _loc8_:* = null;
         if(null == param1)
         {
            var param1:String = "fbc";
         }
         var _loc4_:class_118 = RESEARCH.getResearchComp(var_18);
         var _loc6_:* = 0;
         if(ComponentRetrofitGroup.isValidID(var_18))
         {
            _loc5_ = GLOBAL.bRetrofitLab;
            _loc2_ = ComponentManager.getInstance().getCRGroupById(var_18);
            _loc6_ = InventoryController.getInstance().getItemLevelForCompID(_loc2_.id) + 1;
         }
         else if(!_loc4_)
         {
            _loc7_ = BPResourceManager.getString("bp-flash","store_researchstoreitem_error_badresearchid");
         }
         else
         {
            _loc5_ = RESEARCH.getResearchBuildingByType(_loc4_);
         }
         if(!_loc7_)
         {
            if(!_loc5_)
            {
               _loc7_ = BPResourceManager.getString("bp-flash","store_researchstoreitem_error_nobuildingfortype");
            }
            _loc5_.researchStart(var_18,false);
         }
         if(!_loc7_)
         {
            try
            {
               _loc10_ = _loc5_.researchEndTime - GlobalProperties.gameTime;
               _loc9_ = _loc5_.researchEndTime - _loc5_.researchStartTime;
               _loc5_.researchSpeedUp(_loc5_.researchTimeRemaining);
               _loc3_ = _loc4_?_loc4_.type:"componentRetrofit";
               _loc8_ = new ResearchLogEvent("instant",_loc5_._buildingProps.id,var_18,_loc3_,_loc6_,0,_loc9_,_loc10_,cost,0,0,0,0,0);
               class_223.sendThroughJavaScript(_loc8_);
            }
            catch(e:Error)
            {
               _loc7_ = BPResourceManager.getString("bp-flash","store_researchstoreitem_error_instantpurchase");
            }
         }
         return _loc7_;
      }
      
      override public function buy(param1:Function = null) : void
      {
         super.buy(param1);
         STORE.purchaseNew(this);
      }
   }
}
