using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public interface ICharacterMove
{
    
    public  void LogicUpdate(MovementData data);

    public  void PhysicsUpdate(MovementData data);
    
   
}