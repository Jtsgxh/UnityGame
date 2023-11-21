using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimatorData : MonoBehaviour
{
    public Vector3 animatorSpeed;
    private void OnAnimatorMove()
    {
        animatorSpeed = GetComponent<Animator>().velocity;
    }
}
