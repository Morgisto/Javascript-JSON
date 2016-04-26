package com.waterworld.entities.catchup
{
   import com.kixeye.logging.KXLogger;
   import com.waterworld.entities.ShipYard;
   import com.waterworld.datastores.IOShip;
   import com.waterworld.managers.shipdock.SHIPDOCK;
   import com.waterworld.managers.shipyard.class_334;
   import com.waterworld.core.GLOBAL;
   import com.waterworld.core.BASE;
   import com.waterworld.managers.popups.POPUPS;
   import package_11.class_22;
   import package_11.ShipEvent;
   import package_59.ShipRefitTransactionLogEvent;
   import com.kixeye.utils.json.ActionJSON;
   import package_59.ShipTransactionLogEvent;
   import package_59.class_223;
   import package_176.SessionStats;
   import com.waterworld.resources.BPResourceManager;
   import com.kixeye.popups.PopupManager;
   import package_10.BaseManager;
   import com.waterworld.entities.BuildingFoundationEvent;
   import com.kixeye.logging.class_72;
   
   public class class_251 extends Object
   {
      
      private static var _log:KXLogger = class_72.getLoggerForClass(class_251);
      
      {
         _log = class_72.getLoggerForClass(class_251);
      }
      
      public function class_251()
      {
         super();
      }
      
      public static function catchUp(param1:ShipYard, param2:int) : Boolean
      {
         var _loc7_:* = null;
         var _loc5_:* = null;
         var _loc8_:* = NaN;
         var _loc10_:* = 0;
         var _loc4_:* = 0;
         var _loc9_:* = null;
         var _loc6_:* = null;
         var _loc11_:String = "start";
         var _loc3_:* = false;
         try
         {
            if(param1.buildEndTime && param1.var_37 > 0)
            {
               param1.addTimeToBuildEndTime(param1.var_37);
               param1.addTimeToBuildStartTime(param1.var_37);
            }
            if(param1.isBuildingFunctional())
            {
               _loc11_ = "1";
               if(param1.buildEndTime)
               {
                  _loc11_ = "2";
                  if(param1.shipBuildTimeRemaining <= 0)
                  {
                     _loc11_ = "3";
                     _loc11_ = "4";
                     if(param1.designCurrent)
                     {
                        _loc11_ = "5";
                        _loc5_ = param1.designCurrent.convertToShip();
                     }
                     _loc11_ = "6";
                     if(param1.refitShip)
                     {
                        _loc11_ = "7";
                        _loc5_.id = param1.refitShip.id;
                        _loc11_ = "8";
                        _loc5_.bid = param1.refitShip.bid;
                        _loc11_ = "9";
                        _loc5_.vxp = param1.refitShip.vxp;
                        _loc11_ = "10";
                        _loc5_.fleetId = param1.refitShip.fleetId;
                        _loc11_ = "11";
                        _loc5_.inFleetPos = param1.refitShip.inFleetPos;
                        _loc11_ = "12";
                        _loc5_.inFormationPos = param1.refitShip.inFormationPos;
                        _loc11_ = "14";
                        _loc7_ = SHIPDOCK.addShipFromRefit;
                        _loc11_ = "15";
                     }
                     else
                     {
                        _loc11_ = "16";
                        _loc7_ = SHIPDOCK.addShip;
                        _loc11_ = "17";
                     }
                     _loc11_ = "18";
                     if(_loc7_(_loc5_))
                     {
                        _loc3_ = true;
                        _loc11_ = "19";
                        class_334.buildCompleted(param1);
                        _loc11_ = "21";
                        if(GLOBAL.baseMode == "build")
                        {
                           _loc11_ = "22";
                           if(param1.refitShip)
                           {
                              _loc11_ = "23";
                              _loc8_ = param1.designCurrent.costs.totalCosts - param1.refitShip.costs.totalCosts;
                              _loc11_ = "24";
                              if(_loc8_ > 0)
                              {
                                 _loc11_ = "25";
                                 BASE.pointsAdd(_loc8_,"ship",{"source":"ShipYard.Tick.points"});
                                 _loc11_ = "26";
                              }
                              _loc11_ = "27";
                              class_334.hide();
                              _loc11_ = "28";
                              POPUPS.getInstance().showShipComplete(_loc5_,true);
                              _loc11_ = "29";
                           }
                           else
                           {
                              _loc11_ = "30";
                              class_22.instance.dispatchEvent(new ShipEvent("shipbuilt",_loc5_));
                              _loc11_ = "31";
                              POPUPS.getInstance().showShipComplete(_loc5_);
                              _loc11_ = "32";
                              BASE.pointsAdd(_loc5_.costs.totalCosts,"ship",{"source":"ShipYard.Tick.sh.costs.totalCosts"});
                              _loc11_ = "33";
                           }
                           _loc10_ = param1.buildEndTime - param1.buildStartTime;
                           _loc4_ = param1.refitShip?param1.refitShip.fleetId:-1;
                           if(param1.refitShip)
                           {
                              _loc6_ = param1.refitShip.refitAnalyticExport(param1.designCurrent);
                              _loc9_ = new ShipRefitTransactionLogEvent("refit_finished",_loc5_.id.toString(),_loc5_.hullID.toString(),ActionJSON.encodeJSON(_loc5_.analyticExport()),_loc5_.weight.toString(),_loc5_.armorPoints.toString(),_loc4_.toString(),_loc10_.toString(),param1.buildSpeedUpTime.toString(),"0",ActionJSON.encodeJSON(_loc6_.finalShipConfig),ActionJSON.encodeJSON(_loc6_.refitRemoved),ActionJSON.encodeJSON(_loc6_.refitAdded),ActionJSON.encodeJSON(_loc6_.refitNoChange),ActionJSON.encodeJSON(_loc6_.refitAddTimeCost),ActionJSON.encodeJSON(_loc6_.refitRemoveTimeCost));
                           }
                           else
                           {
                              _loc9_ = new ShipTransactionLogEvent("build_finished",_loc5_.id.toString(),_loc5_.hullID.toString(),ActionJSON.encodeJSON(_loc5_.analyticExport()),_loc5_.weight.toString(),_loc5_.armorPoints.toString(),_loc4_.toString(),_loc10_.toString(),param1.buildSpeedUpTime.toString(),"0");
                           }
                           class_223.sendThroughJavaScript(_loc9_);
                        }
                        _loc11_ = "34";
                        SessionStats.instance().addShipBuilt(_loc5_.export());
                        param1.shipBuildCancel(false);
                        _loc11_ = "35";
                     }
                     else if(!param1.var_3892)
                     {
                        _loc11_ = "36";
                        _loc11_ = "37";
                        if(GLOBAL.baseMode == "build")
                        {
                           _loc11_ = "38";
                           GLOBAL.createMessagePopup(BPResourceManager.getString("bp-flash","entities_buildingshipyard_cannotplace"),PopupManager.getInstance().currentParentId);
                           _loc11_ = "39";
                           param1.var_3892 = true;
                           _loc11_ = "40";
                        }
                        _loc11_ = "41";
                        BaseManager.getInstance().activityQueue.removeActivity("s" + param1.designCurrent.hullID);
                        _loc11_ = "42";
                        param1.dispatchEvent(new BuildingFoundationEvent("producingchange"));
                        _loc11_ = "43";
                     }
                  }
                  var _loc13_:* = true;
                  return _loc13_;
               }
            }
         }
         catch(e:Error)
         {
            _log.logRemote("ERROR.ShipYard.Tick","step: ",_loc11_,"addedShip:",_loc3_,"error:",e.message);
            if(_loc3_)
            {
               param1.shipBuildCancel(false);
            }
         }
         return false;
      }
   }
}
