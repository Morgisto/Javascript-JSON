package package_40
{
   import flash.events.Event;
   
   public class RocketInventoryUpdateEvent extends Event
   {
      
      public static const const_495:String = "updated";
       
      public function RocketInventoryUpdateEvent(param1:String)
      {
         super(param1);
      }
      
      override public function clone() : Event
      {
         return super.clone();
      }
   }
}
