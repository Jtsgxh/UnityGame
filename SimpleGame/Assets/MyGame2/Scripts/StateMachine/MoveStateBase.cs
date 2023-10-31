public class MoveStateBase:StateBase {
   public virtual void Jump()
   {
      
   }

   public virtual void Walk()
   {
      
   }

   public virtual void Run()
   {
      
   }

   public virtual void Climb()
   {
      
   }

   public virtual void Fly()
   {
      
   }

   public virtual void LogicMove(MovementManager mgr)
   {
      
   }
   
   public virtual void PhysicsMove(MovementManager mgr)
   {
      
   }
   
   public override void BeforeEnter()
   {
      throw new System.NotImplementedException();
   }

   public override void AfterExit()
   {
      throw new System.NotImplementedException();
   }
}
