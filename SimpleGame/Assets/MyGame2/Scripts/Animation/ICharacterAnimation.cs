using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface ICharacterAnimation
{
    public void UpdateAnimator();
}

public class AnimatorCtlMtd:ICharacterAnimation
{
    public AnimatorManager Manager;
    
    public AnimatorCtlMtd(AnimatorManager manager)
    {
        Manager = manager;
    }
    public void UpdateAnimator()
    {
        var velocity = Manager.MovementManager.GetMoveVelocity();
        var localVelocity = Manager.MovementManager.InputManager.GetInputData().inputTransform
            .InverseTransformVector(velocity);
        Manager.Animator.SetFloat("velX",localVelocity.x);
        Manager.Animator.SetFloat("velZ",localVelocity.z);
    }
}
