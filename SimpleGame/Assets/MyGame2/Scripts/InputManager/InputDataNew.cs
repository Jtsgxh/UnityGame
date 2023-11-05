using System;
using UnityEngine;
using UnityEngine.Events;

public class InputDataNew:MonoBehaviour
{
    public Transform inputTransform;
    public float MoveAxisForward;
    public float MoveAxisRight;
    public Quaternion CameraRotation;
    public bool desiredJump;
    public bool CrouchDown;
    public bool CrouchUp;
    public bool rush;
    public int  weapon;
    public bool shoot;
    public bool reload;
    public float rotatex;
    public float rotatey;

    public void Clear()
    {
        MoveAxisForward = 0;
        MoveAxisRight = 0;
        desiredJump = false;
        CrouchDown = false;
        CrouchUp = false;
        rush = false;
        weapon = 0;
        shoot = false;
        reload = false;
        rotatex = 0;
        rotatey = 0;
        CameraRotation = Quaternion.identity;
    }
}

public  class Button
{
    //刚刚按下
    
    private bool isLastFramePressed;

    public void Update()
    {
        listenInput?.Invoke();
    }

    public void Press(bool isPressed)
    {
        if (isPressed && !isLastFramePressed)
        {
            OnPressed();
        }
        else if (!isPressed && isLastFramePressed)
        {
            OnReleased();
        }
        else if (isPressed)
        {
            OnHeld();
        }

        isLastFramePressed = isPressed;
    }
    public virtual void OnPressed()
    {
        onPressed?.Invoke();
    }
    //刚刚松开
    public virtual void OnReleased()
    {
        onReleased?.Invoke();
    }
    //按住
    public virtual void OnHeld()
    {
        onHeld?.Invoke();
    }
    
    public Action onPressed;
    
    public Action onReleased;
    
    public Action onHeld;

    public Action listenInput;
    
    public void RegisterListenInput(Action action)
    {
        listenInput += action;
    }
    
    public void RegisterOnPressed(Action action)
    {
        onPressed += action;
    }
    
    public void RegisterOnReleased(Action action)
    {
        onReleased += action;
    }
    
    public void RegisterOnHeld(Action action)
    {
        onHeld += action;
    }
    
    public void UnRegisterOnPressed(Action action)
    {
        onPressed -= action;
    }
}