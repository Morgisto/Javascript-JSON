package com.waterworld.managers.store.storeitem
{
   import com.waterworld.datastores.IOShip;
   import package_170.VXPManager;
   import com.waterworld.managers.store.STORE;
   import com.waterworld.resources.BPResourceManager;
   import com.kixeye.utils.json.ActionJSON;
   import com.waterworld.core.GLOBAL;
   import package_59.ShipRankLogEvent;
   import package_59.class_223;
   import package_11.class_22;
   import package_11.ShipLevelUpEvent;
   import com.waterworld.managers.shipdock.SHIPDOCK;
   
   public class ShipRankStoreItem extends StoreItem
   {
       
      private var _ship:IOShip;
      
      private var var_2775:int;
      
      private var var_4498:uint;
      
      public function ShipRankStoreItem(param1:String)
      {
         super(param1);
      }
      
      public function initToBuy(param1:IOShip, param2:uint) : void
      {
         _ship = param1;
         var_4498 = param2;
         var_18 = param1.uid;
         var _loc5_:int = param1.getVXPMax();
         var _loc4_:int = VXPManager.getInstance().getRequiredVXPForRank(param1.vxp,_loc5_,param1.rank.level + param2);
         var _loc3_:int = VXPManager.getInstance().getRequiredVXPForRank(param1.vxp,_loc5_,param1.rank.level + param2,true);
         var_87.Set(STORE.costForVXP(_loc3_,param2));
         var_2775 = _loc4_;
         setFBCWindowProps(BPResourceManager.getString("bp-flash","store_shiprankstoreitem_title"),BPResourceManager.getString("bp-flash","store_shiprankstoreitem_message"),_loc4_,"InstantRank");
      }
      
      override public function getAnalyticsData() : Object
      {
         var _loc1_:Object = super.getAnalyticsData();
         _loc1_.item_id = _ship.hullID;
         _loc1_.item_level = _ship.rank.level + 1;
         _loc1_.action = "ranked";
         _loc1_.description = {};
         _loc1_.description.vxp_purchased = var_2775;
         _loc1_.description.ranks_purchased = var_4498;
         _loc1_.description = ActionJSON.encodeJSON(_loc1_.description);
         return _loc1_;
      }
      
      override public function apply(param1:Object) : String
      {
         super.apply(param1);
         return this.doApply();
      }
      
      override protected function doApply(param1:String = null) : String
      {
         var _loc4_:* = null;
         var _loc6_:* = null;
         var _loc3_:* = 0;
         var _loc5_:* = 0;
         var _loc2_:* = null;
         if(null == param1)
         {
            var param1:String = "fbc";
         }
         _loc4_ = GLOBAL.bShipDock.getShipByUID(var_18);
         if(_loc4_)
         {
            _loc3_ = _loc4_.rank.level;
            _loc4_.vxp = _loc4_.vxp + var_2775;
            _loc5_ = _loc4_.rank.level;
            _loc2_ = new ShipRankLogEvent(_loc4_,"rank_paid",var_2775,_loc5_ - _loc3_,var_87.Get());
            class_223.sendThroughJavaScript(_loc2_);
            class_22.instance.dispatchEvent(new ShipLevelUpEvent("shiprankchanged",_loc4_,_loc3_,_loc5_,var_2775));
            SHIPDOCK.update(true);
         }
         else
         {
            _loc6_ = BPResourceManager.getString("bp-flash","store_shiprankstoreitem_shipnotfound");
         }
         return _loc6_;
      }
      
      override public function buy(param1:Function = null) : void
      {
         super.buy(param1);
         STORE.purchaseNew(this);
      }
   }
}
