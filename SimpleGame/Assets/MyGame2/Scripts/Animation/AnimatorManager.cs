using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimatorManager : MonoBehaviour
{
    // Start is called before the first frame update
    public AnimatorData AnimatorData;
    public Animator Animator;
    public InputManager InputManager;
    public MovementManager MovementManager;
    public ICharacterAnimation AnimationMethod;
    private void Awake()
    {
        AnimatorData = GameTool.FindComponentRecursively<AnimatorData>(this.transform);
        Animator = GameTool.FindComponentRecursively<Animator>(this.transform);
        InputManager = gameObject.GetComponent<InputManager>();
        MovementManager = gameObject.GetComponent<MovementManager>();
        AnimationMethod = new AnimatorCtlMtd(this);
    }

    private void Update()
    {
        
        AnimationMethod.UpdateAnimator();
    }
    
    //应该有一个动态切换animator的方法并且更改相应的动画控制方法
}
