package com.waterworld.comm
{
   import com.waterworld.core.GlobalProperties;
   
   public class class_464 extends class_74
   {
      
      public static const const_3182:String = "setNickname.php";
      
      public static const const_1836:String = "PCSNN";
       
      public function class_464()
      {
         super();
      }
      
      public static function saveNickname(param1:String, param2:int, param3:int, param4:Function, param5:Function) : void
      {
         sendRequest(GlobalProperties.worldMapURL + "setNickname.php","073c187f8a02f626210bbcb7f55a4cee",["nickname",param1,"userid",param2,"baseid",param3],"PCSNN",param4,param5);
      }
   }
}
