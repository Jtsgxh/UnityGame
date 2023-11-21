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
    private void Awake()
    {
        AnimatorData = GameTool.FindComponentRecursively<AnimatorData>(this.transform);
        Animator = GameTool.FindComponentRecursively<Animator>(this.transform);
        InputManager = gameObject.GetComponent<InputManager>();
    }
}
