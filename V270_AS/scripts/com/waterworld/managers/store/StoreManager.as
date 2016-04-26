package com.waterworld.managers.store
{
   import flash.utils.Dictionary;
   import com.waterworld.core.GLOBAL;
   import com.waterworld.managers.update.UpdateManager;
   import com.waterworld.managers.store.storeitem.InstantFleetRepairItem;
   import com.waterworld.managers.store.storeitem.BaseRepairAllBuildingsStoreItem;
   import com.waterworld.managers.store.storeitem.InstantTurretStoreItem;
   import com.waterworld.entities.DefensivePlatform;
   import com.waterworld.managers.store.storeitem.RenameStoreItem;
   import com.waterworld.managers.store.storeitem.InstantRocketStoreItem;
   import com.waterworld.managers.store.storeitem.BlueprintStoreItem;
   import com.waterworld.managers.store.storeitem.InstantShipStoreItem;
   import com.waterworld.datastores.IOShipDesign;
   import com.waterworld.datastores.IOBuildingCosts;
   import com.waterworld.datastores.IOShip;
   import com.waterworld.managers.store.storeitem.BuildingDesignStoreItem;
   import com.waterworld.datastores.IOBuildingDesign;
   import com.waterworld.entities.BuildingFoundation;
   import com.waterworld.managers.store.storeitem.ShipRankStoreItem;
   import com.waterworld.managers.store.storeitem.BuildingUpgradeInstantStoreItem;
   import com.waterworld.managers.store.storeitem.BuildingFortificationStoreItem;
   import com.waterworld.managers.store.storeitem.ResearchStoreItem;
   import com.waterworld.managers.store.storeitem.MultipleResourcesStoreItem;
   import com.waterworld.managers.store.storeitem.MultipleWallUpgradeStoreItem;
   import package_63.Wall;
   import com.waterworld.managers.store.storeitem.SpeedupStoreItem;
   import com.waterworld.managers.store.storeitem.RelocateSpeedupStoreItem;
   import com.waterworld.managers.store.storeitem.FacebookCreditPromotionStoreItem;
   import com.waterworld.managers.store.storeitem.SendGiftsStoreItem;
   import com.waterworld.managers.store.storeitem.StoreItem;
   import com.waterworld.managers.store.storeitem.ResourceStoreItem;
   import com.waterworld.managers.store.storeitem.DamageProtectionStoreItem;
   import com.waterworld.managers.store.storeitem.LimitedOfferStoreItem;
   
   public class StoreManager extends Object
   {
      
      public static const const_3343:String = "protection";
      
      public static const const_2384:String = "resources";
      
      public static const const_3500:String = "speedups";
      
      public static const const_2816:String = "roguecrews";
      
      public static const const_380:Vector.<String> = generateStoreCategories();
      
      public static const const_4285:String = "SP1";
      
      public static const const_915:String = "SP2";
      
      public static const const_1333:String = "SP3";
      
      public static const const_2065:String = "SP4";
      
      public static const const_2913:String = "SPT";
      
      public static const const_686:String = "BR11";
      
      public static const const_2516:String = "BR12";
      
      public static const const_2379:String = "BR13";
      
      public static const const_3103:String = "BR21";
      
      public static const const_1716:String = "BR22";
      
      public static const const_1668:String = "BR23";
      
      public static const const_3897:String = "BR31";
      
      public static const const_2882:String = "BR32";
      
      public static const const_2013:String = "BR33";
      
      public static const const_2189:String = "BR41";
      
      public static const const_1801:String = "BR42";
      
      public static const const_698:String = "BR43";
      
      public static const const_720:String = "PRO1";
      
      public static const const_3747:String = "PRO2";
      
      public static const const_4217:String = "PRO3";
      
      public static const const_3504:String = "IUP";
      
      public static const const_2868:String = "WIUP";
      
      public static const const_4492:String = "IFUP";
      
      public static const const_1861:String = "IRES";
      
      public static const const_1733:String = "IRANK";
      
      public static const const_4174:String = "ISHIP";
      
      public static const const_931:String = "IBDB";
      
      public static const const_892:String = "IBLUEPRINT";
      
      public static const const_2739:String = "IROC";
      
      public static const const_2305:String = "RENAME";
      
      public static const const_4623:String = "RTOPUP";
      
      public static const const_2411:String = "ITUR";
      
      public static const const_1649:String = "IREP";
      
      public static const const_3972:String = "IFREP";
      
      public static const const_3411:String = "RSPD";
      
      public static const const_850:String = "NCP";
      
      public static const const_729:String = "PREMGIFT";
      
      public static const const_3575:String = "ILIMITED";
      
      private static var name_3:StoreManager;
       
      private var var_2298:Dictionary;
      
      public function StoreManager()
      {
         super();
         if(name_3 != null)
         {
            throw new Error("Attempt to instantiate a Singleton: StoreManager");
         }
      }
      
      private static function generateStoreCategories() : Vector.<String>
      {
         return Vector.<String>(["protection","resources","speedups","roguecrews"]);
      }
      
      public static function getInstance() : StoreManager
      {
         if(name_3 == null)
         {
            name_3 = new StoreManager();
         }
         return name_3;
      }
      
      public static function isSpeedup(param1:String) : Boolean
      {
         var _loc2_:* = false;
         var _loc3_:* = param1;
         if("SP1" !== _loc3_)
         {
            if("SP2" !== _loc3_)
            {
               if("SP3" !== _loc3_)
               {
                  if("SP4" !== _loc3_)
                  {
                     if("SPT" !== _loc3_)
                     {
                        _loc2_ = false;
                     }
                     addr35:
                     return _loc2_;
                  }
                  addr11:
                  _loc2_ = true;
                  §§goto(addr35);
               }
               addr10:
               §§goto(addr11);
            }
            addr9:
            §§goto(addr10);
         }
         §§goto(addr9);
      }
      
      public static function getStoreItemName(param1:String) : String
      {
         var _loc2_:* = param1;
         if("SP1" !== _loc2_)
         {
            if("SP2" !== _loc2_)
            {
               if("SP3" !== _loc2_)
               {
                  if("SP4" !== _loc2_)
                  {
                     if("BR11" !== _loc2_)
                     {
                        if("BR12" !== _loc2_)
                        {
                           if("BR13" !== _loc2_)
                           {
                              if("BR21" !== _loc2_)
                              {
                                 if("BR22" !== _loc2_)
                                 {
                                    if("BR23" !== _loc2_)
                                    {
                                       if("BR31" !== _loc2_)
                                       {
                                          if("BR32" !== _loc2_)
                                          {
                                             if("BR33" !== _loc2_)
                                             {
                                                if("BR41" !== _loc2_)
                                                {
                                                   if("BR42" !== _loc2_)
                                                   {
                                                      if("BR43" !== _loc2_)
                                                      {
                                                         if("PRO1" !== _loc2_)
                                                         {
                                                            if("PRO2" !== _loc2_)
                                                            {
                                                               if("PRO3" !== _loc2_)
                                                               {
                                                                  return null;
                                                               }
                                                            }
                                                            addr38:
                                                            return "damage protection";
                                                         }
                                                         §§goto(addr38);
                                                      }
                                                   }
                                                   addr32:
                                                   return "zynthium";
                                                }
                                                §§goto(addr32);
                                             }
                                          }
                                          addr26:
                                          return "energy";
                                       }
                                       §§goto(addr26);
                                    }
                                 }
                                 addr20:
                                 return "metal";
                              }
                              §§goto(addr20);
                           }
                        }
                        addr14:
                        return "oil";
                     }
                     §§goto(addr14);
                  }
               }
               addr8:
               return "Speedup";
            }
            addr7:
            §§goto(addr8);
         }
         §§goto(addr7);
      }
      
      public function get storeGroupings() : Dictionary
      {
         return var_2298;
      }
      
      public function refreshStoreGroupings() : void
      {
         var_2298 = new Dictionary();
         if(GLOBAL.flagManager.hasFlag("blockrespurch") && GLOBAL.flagManager.getFlagInt("blockrespurch") > 0)
         {
            var_2298["resources"] = [];
         }
         else
         {
            var_2298["resources"] = ["BR11","BR12","BR13","BR21","BR22","BR23","BR31","BR32","BR33","BR41","BR42","BR43"];
         }
         var_2298["speedups"] = ["SP1","SPT","SP2","SP3","SP4"];
         var_2298["protection"] = ["PRO1","PRO2","PRO3"];
      }
      
      public function purchaseCancelled() : void
      {
         GLOBAL.waitHide();
         STORE.busy = false;
         UpdateManager.getInstance().stopPollingForUpdates();
      }
      
      public function createStoreItemObject() : Object
      {
         return {};
      }
      
      public function getInstantFleetRepairItem(param1:String, param2:int, param3:Vector.<int>, param4:Array = null) : InstantFleetRepairItem
      {
         var _loc5_:InstantFleetRepairItem = new InstantFleetRepairItem(param1);
         _loc5_.initToBuy(param2,param3,param4);
         return _loc5_;
      }
      
      public function getBaseRepairAllBuildingsItem(param1:String) : BaseRepairAllBuildingsStoreItem
      {
         var _loc2_:BaseRepairAllBuildingsStoreItem = new BaseRepairAllBuildingsStoreItem(param1);
         _loc2_.initToBuy();
         return _loc2_;
      }
      
      public function getInstantTurretItem(param1:String, param2:DefensivePlatform, param3:Object, param4:Array = null) : InstantTurretStoreItem
      {
         var _loc5_:InstantTurretStoreItem = new InstantTurretStoreItem(param1);
         _loc5_.initToBuy(param2,param3,param4);
         return _loc5_;
      }
      
      public function getRenameItem(param1:String, param2:String) : RenameStoreItem
      {
         var _loc3_:RenameStoreItem = new RenameStoreItem(param1);
         _loc3_.initToBuy(param2);
         return _loc3_;
      }
      
      public function getInstantRocketItem(param1:String, param2:int, param3:Array = null) : InstantRocketStoreItem
      {
         var _loc4_:InstantRocketStoreItem = new InstantRocketStoreItem(param1);
         _loc4_.initToBuy(param2,param3);
         return _loc4_;
      }
      
      public function getBlueprintCompleteItem(param1:String, param2:int) : BlueprintStoreItem
      {
         var _loc3_:BlueprintStoreItem = new BlueprintStoreItem(param1);
         _loc3_.initToBuy(param2);
         return _loc3_;
      }
      
      public function getInstantShipitem(param1:String, param2:IOShipDesign, param3:int, param4:int, param5:IOBuildingCosts, param6:int, param7:IOShip, param8:Array = null) : InstantShipStoreItem
      {
         var _loc9_:InstantShipStoreItem = new InstantShipStoreItem(param1);
         _loc9_.initToBuy(param2,param3,param4,param5,param6,param7,param8);
         return _loc9_;
      }
      
      public function getInstantBuildingDesignItem(param1:String, param2:IOBuildingDesign, param3:int, param4:IOBuildingCosts, param5:int, param6:BuildingFoundation, param7:Array = null) : BuildingDesignStoreItem
      {
         var _loc8_:BuildingDesignStoreItem = new BuildingDesignStoreItem(param1);
         _loc8_.initToBuy(param2,param3,param4,param5,param6._id,param7);
         return _loc8_;
      }
      
      public function getInstantRankItem(param1:String, param2:IOShip, param3:uint) : ShipRankStoreItem
      {
         var _loc4_:ShipRankStoreItem = new ShipRankStoreItem(param1);
         _loc4_.initToBuy(param2,param3);
         return _loc4_;
      }
      
      public function getInstantUpgradeItem(param1:String, param2:BuildingFoundation, param3:Array = null) : BuildingUpgradeInstantStoreItem
      {
         var _loc4_:BuildingUpgradeInstantStoreItem = new BuildingUpgradeInstantStoreItem(param1);
         _loc4_.initToBuy(param2._id,param3);
         return _loc4_;
      }
      
      public function getInstantFortificationStoreItem(param1:String, param2:BuildingFoundation, param3:Array = null) : BuildingFortificationStoreItem
      {
         var _loc4_:BuildingFortificationStoreItem = new BuildingFortificationStoreItem(param1);
         _loc4_.initToBuy(param2._id,param3);
         return _loc4_;
      }
      
      public function getInstantResearchitem(param1:String, param2:int, param3:Array = null) : ResearchStoreItem
      {
         var _loc4_:ResearchStoreItem = new ResearchStoreItem(param1);
         _loc4_.initToBuy(param2,param3);
         return _loc4_;
      }
      
      public function getMultipleResourcesItem(param1:String, param2:String, param3:int, param4:int, param5:int, param6:int, param7:Function = null, param8:Array = null) : MultipleResourcesStoreItem
      {
         var _loc9_:MultipleResourcesStoreItem = new MultipleResourcesStoreItem(param1,param2);
         _loc9_.initToBuy(param3,param4,param5,param6,param7,param8);
         return _loc9_;
      }
      
      public function getMultipleWallUpgradeStoreItem(param1:String, param2:BuildingFoundation, param3:Vector.<Wall>, param4:int, param5:Array = null) : MultipleWallUpgradeStoreItem
      {
         var _loc6_:MultipleWallUpgradeStoreItem = new MultipleWallUpgradeStoreItem(param1);
         _loc6_.initToBuy(param2,param3,param4,param5);
         return _loc6_;
      }
      
      public function getSpeedupStoreItem(param1:String, param2:BuildingFoundation, param3:Array = null) : SpeedupStoreItem
      {
         var _loc4_:SpeedupStoreItem = new SpeedupStoreItem(param1);
         SpeedupStoreItem(_loc4_).initToBuy(param2,param3);
         return _loc4_;
      }
      
      public function getRelocateSpeedupStoreItem(param1:String) : RelocateSpeedupStoreItem
      {
         var _loc2_:RelocateSpeedupStoreItem = new RelocateSpeedupStoreItem(param1);
         _loc2_.initToBuy();
         return _loc2_;
      }
      
      public function getNCPStoreItem() : FacebookCreditPromotionStoreItem
      {
         var _loc1_:FacebookCreditPromotionStoreItem = new FacebookCreditPromotionStoreItem("NCP");
         _loc1_.initToBuy();
         return _loc1_;
      }
      
      public function getSendGiftsStoreItem(param1:String, param2:Array, param3:int, param4:int = -3) : SendGiftsStoreItem
      {
         var _loc5_:SendGiftsStoreItem = new SendGiftsStoreItem("PREMGIFT");
         _loc5_.initToBuy(param1,param2,param3,param4);
         return _loc5_;
      }
      
      public function getBuyableStoreItem(param1:String, param2:Array = null) : StoreItem
      {
         var _loc3_:* = null;
         var _loc4_:* = param1;
         if("SP1" !== _loc4_)
         {
            if("SP2" !== _loc4_)
            {
               if("SP3" !== _loc4_)
               {
                  if("SP4" !== _loc4_)
                  {
                     if("SPT" !== _loc4_)
                     {
                        if("BR11" !== _loc4_)
                        {
                           if("BR12" !== _loc4_)
                           {
                              if("BR13" !== _loc4_)
                              {
                                 if("BR21" !== _loc4_)
                                 {
                                    if("BR22" !== _loc4_)
                                    {
                                       if("BR23" !== _loc4_)
                                       {
                                          if("BR31" !== _loc4_)
                                          {
                                             if("BR32" !== _loc4_)
                                             {
                                                if("BR33" !== _loc4_)
                                                {
                                                   if("BR41" !== _loc4_)
                                                   {
                                                      if("BR42" !== _loc4_)
                                                      {
                                                         if("BR43" !== _loc4_)
                                                         {
                                                            if("PRO1" !== _loc4_)
                                                            {
                                                               if("PRO2" !== _loc4_)
                                                               {
                                                                  if("PRO3" !== _loc4_)
                                                                  {
                                                                  }
                                                               }
                                                               addr50:
                                                               _loc3_ = new DamageProtectionStoreItem(param1);
                                                               DamageProtectionStoreItem(_loc3_).initToBuy();
                                                            }
                                                            §§goto(addr50);
                                                         }
                                                      }
                                                      addr36:
                                                      _loc3_ = new ResourceStoreItem(param1);
                                                      ResourceStoreItem(_loc3_).initToBuy();
                                                   }
                                                   addr35:
                                                   §§goto(addr36);
                                                }
                                                addr34:
                                                §§goto(addr35);
                                             }
                                             addr33:
                                             §§goto(addr34);
                                          }
                                          addr32:
                                          §§goto(addr33);
                                       }
                                       addr31:
                                       §§goto(addr32);
                                    }
                                    addr30:
                                    §§goto(addr31);
                                 }
                                 addr29:
                                 §§goto(addr30);
                              }
                              addr28:
                              §§goto(addr29);
                           }
                           addr27:
                           §§goto(addr28);
                        }
                        §§goto(addr27);
                     }
                     addr125:
                     return _loc3_;
                  }
                  addr11:
                  _loc3_ = new SpeedupStoreItem(param1);
                  SpeedupStoreItem(_loc3_).initToBuy(null,param2);
                  §§goto(addr125);
               }
               addr10:
               §§goto(addr11);
            }
            addr9:
            §§goto(addr10);
         }
         §§goto(addr9);
      }
      
      public function getStoreItem(param1:String) : StoreItem
      {
         var _loc2_:* = param1;
         if("SP1" !== _loc2_)
         {
            if("SP2" !== _loc2_)
            {
               if("SP3" !== _loc2_)
               {
                  if("SP4" !== _loc2_)
                  {
                     if("BR11" !== _loc2_)
                     {
                        if("BR12" !== _loc2_)
                        {
                           if("BR13" !== _loc2_)
                           {
                              if("BR21" !== _loc2_)
                              {
                                 if("BR22" !== _loc2_)
                                 {
                                    if("BR23" !== _loc2_)
                                    {
                                       if("BR31" !== _loc2_)
                                       {
                                          if("BR32" !== _loc2_)
                                          {
                                             if("BR33" !== _loc2_)
                                             {
                                                if("BR41" !== _loc2_)
                                                {
                                                   if("BR42" !== _loc2_)
                                                   {
                                                      if("BR43" !== _loc2_)
                                                      {
                                                         if("PRO1" !== _loc2_)
                                                         {
                                                            if("PRO2" !== _loc2_)
                                                            {
                                                               if("PRO3" !== _loc2_)
                                                               {
                                                                  if("IUP" !== _loc2_)
                                                                  {
                                                                     if("WIUP" !== _loc2_)
                                                                     {
                                                                        if("IFUP" !== _loc2_)
                                                                        {
                                                                           if("IRES" !== _loc2_)
                                                                           {
                                                                              if("IRANK" !== _loc2_)
                                                                              {
                                                                                 if("ISHIP" !== _loc2_)
                                                                                 {
                                                                                    if("IBLUEPRINT" !== _loc2_)
                                                                                    {
                                                                                       if("IROC" !== _loc2_)
                                                                                       {
                                                                                          if("RENAME" !== _loc2_)
                                                                                          {
                                                                                             if("RTOPUP" !== _loc2_)
                                                                                             {
                                                                                                if("ITUR" !== _loc2_)
                                                                                                {
                                                                                                   if("IREP" !== _loc2_)
                                                                                                   {
                                                                                                      if("IFREP" !== _loc2_)
                                                                                                      {
                                                                                                         if("NCP" !== _loc2_)
                                                                                                         {
                                                                                                            if("PREMGIFT" !== _loc2_)
                                                                                                            {
                                                                                                               if("ILIMITED" !== _loc2_)
                                                                                                               {
                                                                                                                  return null;
                                                                                                               }
                                                                                                               return new LimitedOfferStoreItem(param1);
                                                                                                            }
                                                                                                            return new SendGiftsStoreItem(param1);
                                                                                                         }
                                                                                                         return new FacebookCreditPromotionStoreItem(param1);
                                                                                                      }
                                                                                                      return new InstantFleetRepairItem(param1);
                                                                                                   }
                                                                                                   return new BaseRepairAllBuildingsStoreItem(param1);
                                                                                                }
                                                                                                return new InstantTurretStoreItem(param1);
                                                                                             }
                                                                                             return new MultipleResourcesStoreItem(param1,"StoreManager.getStoreItem");
                                                                                          }
                                                                                          return new RenameStoreItem(param1);
                                                                                       }
                                                                                       return new InstantRocketStoreItem(param1);
                                                                                    }
                                                                                    return new BlueprintStoreItem(param1);
                                                                                 }
                                                                                 return new InstantShipStoreItem(param1);
                                                                              }
                                                                              return new ShipRankStoreItem(param1);
                                                                           }
                                                                           return new ResearchStoreItem(param1);
                                                                        }
                                                                        return new BuildingFortificationStoreItem(param1);
                                                                     }
                                                                     return new MultipleWallUpgradeStoreItem(param1);
                                                                  }
                                                                  return new BuildingUpgradeInstantStoreItem(param1);
                                                               }
                                                            }
                                                            addr33:
                                                            return new DamageProtectionStoreItem(param1);
                                                         }
                                                         §§goto(addr33);
                                                      }
                                                   }
                                                   addr25:
                                                   return new ResourceStoreItem(param1);
                                                }
                                                addr24:
                                                §§goto(addr25);
                                             }
                                             addr23:
                                             §§goto(addr24);
                                          }
                                          addr22:
                                          §§goto(addr23);
                                       }
                                       addr21:
                                       §§goto(addr22);
                                    }
                                    addr20:
                                    §§goto(addr21);
                                 }
                                 addr19:
                                 §§goto(addr20);
                              }
                              addr18:
                              §§goto(addr19);
                           }
                           addr17:
                           §§goto(addr18);
                        }
                        addr16:
                        §§goto(addr17);
                     }
                     §§goto(addr16);
                  }
               }
               addr8:
               return new SpeedupStoreItem(param1);
            }
            addr7:
            §§goto(addr8);
         }
         §§goto(addr7);
      }
   }
}
