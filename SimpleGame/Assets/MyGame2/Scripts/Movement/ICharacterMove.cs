using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface ICharacterMove<T> where T:IPlayerInputManager
{
    public void Walk(MovementData data);
    public void Run(MovementData data);
    public void Climb(MovementData data);
    public void Jump(MovementData data);
    public bool IsOnGround(MovementData data);
    public bool IsClimbing(MovementData data);
    public bool IsJumping(MovementData data);
    public bool IsFalling(MovementData data);
    public bool IsRunning(MovementData data);
    public bool IsWalking(MovementData data);
    
    public void Init(T t);
    public void LogicUpdate(MovementData data);

    public void PhysicsUpdate(MovementData data);
}