using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface ICharacterMove<T> where T:IPlayerInputManager
{
    
    public void Init(T t);
    public void LogicUpdate(MovementData data);

    public void PhysicsUpdate(MovementData data);
}