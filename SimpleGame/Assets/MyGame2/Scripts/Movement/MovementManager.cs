using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

public class MovementManager:MonoBehaviour
{
    public MovementData MoveData;
    public ICharacterMove<IPlayerInputManager> moveMethod;
    public IPlayerInputManager InputManager;
    public Dictionary<string, ICharacterMove<IPlayerInputManager>> moveMethodMap;
    private void Awake()
    {
        this.MoveData = GetComponent<MovementData>();
        this.InputManager = GetComponent<PlayerInputManager>();
        this.moveMethod = new MoveMethod01(this);
        
    }

    private void Update()
    {
        moveMethod.LogicUpdate(MoveData);
    }

    private void FixedUpdate()
    {
        moveMethod.PhysicsUpdate(MoveData);
    }
    
    public bool SwitchMoveMethod(ICharacterMove<IPlayerInputManager> moveMethod)
    {
        if (moveMethod == null)
        {
            return false;
        }
        this.moveMethod = moveMethod;
        return true;
    }
}
