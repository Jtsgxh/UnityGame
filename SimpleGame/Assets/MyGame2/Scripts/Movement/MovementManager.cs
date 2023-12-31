﻿using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

public class MovementManager:MonoBehaviour
{
    public MovementData MoveData;
    public ICharacterMove  moveMethod;
    public IPlayerInputManager InputManager;
    public Dictionary<string, ICharacterMove> moveMethodMap;
    private void Awake()
    {
        this.MoveData = GetComponent<MovementData>();
        this.InputManager = GetComponent<PlayerInputManager>();
        this.moveMethod = new MoveMethod01(this);
        //设置目标帧率
        Application.targetFrameRate = 60;  
    }

    private void Update()
    {
        moveMethod.LogicUpdate(MoveData);
    }

    private void FixedUpdate()
    {
        moveMethod.PhysicsUpdate(MoveData);
    }
    
    public bool SwitchMoveMethod(ICharacterMove moveMethod)
    {
        if (moveMethod == null)
        {
            return false;
        }
        this.moveMethod = moveMethod;
        return true;
    }
    
    public Vector3 GetMoveVelocity()
    {
        return MoveData.velocity;
    }
}
