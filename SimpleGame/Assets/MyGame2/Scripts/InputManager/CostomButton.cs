using System;
using System.Collections.Generic;
using UnityEngine;

public class CustomButton   
{  
    // 其他成员变量...  
  
    // 用于在Update和FixedUpdate之间同步的状态标志  
    public bool isButtonDownInUpdate;  
    private bool wasButtonDownInLastFixedUpdate;  
  
    public Action listenInput;
    
    public void RegisterListenInput(Action action)
    {
        listenInput += action;
    }  
    public event Action onButtonPressed;  
    
    public void RegisterOnPressed(Action action)
    {
        onButtonPressed += action;
    }
    
    public event Action onButtonReleased;  
    
    public void RegisterOnReleased(Action action)
    {
        onButtonReleased += action;
    }
    public event Action onButtonHeld;  
    
    public void RegisterOnHeld(Action action)
    {
        onButtonHeld += action;
    }
    public virtual void OnPressed()  
    {  
        onButtonPressed?.Invoke();  
    }  
  
    public virtual void OnReleased()  
    {  
        onButtonReleased?.Invoke();  
    }  
  
    public virtual void OnHeld()  
    {  
        onButtonHeld?.Invoke();  
    }  
    // 用于存储按钮按下事件的信息的队列  
    private Queue<bool> buttonPressQueue = new Queue<bool>();  
  
    public  void Update()  
    {  
        // 检测按钮状态，例如：  
        // isButtonDownInUpdate = Input.GetButton("ButtonName");  
        listenInput?.Invoke();
        // 将按钮状态信息添加到队列中  
        buttonPressQueue.Enqueue(isButtonDownInUpdate);  
    }  
  
    public void FixedUpdate()  
    {  
        // 在FixedUpdate中处理队列中的信息  
        while (buttonPressQueue.Count > 0)  
        {  
            bool isButtonDown = buttonPressQueue.Dequeue();  
  
            // 根据isButtonDown的值处理按钮按下、松开或持续按下的逻辑...  
            // 例如:  
            if (isButtonDown && !wasButtonDownInLastFixedUpdate)  
            {  
                OnPressed();  
            }  
            else if (!isButtonDown && wasButtonDownInLastFixedUpdate)  
            {  
                OnReleased();  
            }  
            else if (isButtonDown)  
            {  
                OnHeld();  
            }  
  
            wasButtonDownInLastFixedUpdate = isButtonDown;  
        }  
    }  
  
    // 其他方法和事件...  
}