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
    private MovementData moveMentData;
    private AnimationMotionState animationState;
    private AnimationMotionState lastAnimationState;
    private float climbAnimationProgress;
    
    private void AddClimbAnimationProgress(float value)
    {
        climbAnimationProgress += value;
        if (climbAnimationProgress > 1)
        {
            climbAnimationProgress = 0;
        }
    }
    public enum AnimationMotionState
    {
        Stand,
        Jumping,
        Landing,
        Falling,
        Climbing
    }

    void SetUpPlayerState()
    {
        lastAnimationState = animationState;
        if (moveMentData.OnGround)
        {  
            if (lastAnimationState == AnimationMotionState.Falling)
            {
                animationState = AnimationMotionState.Landing;
            }
            else
            {
                animationState = AnimationMotionState.Stand;
            }
        }else if (moveMentData.Climbing)
        {
            animationState = AnimationMotionState.Climbing;
        }
        else
        {
            if(Vector3.Dot(moveMentData.velocity,CustomGravity.GetGravity(moveMentData.transform.position))>0)
            {
                animationState=AnimationMotionState.Falling;
            }
            else
            {
                animationState=AnimationMotionState.Jumping;
            }
        }
    }
    
    public AnimatorCtlMtd(AnimatorManager manager)
    {
        Manager = manager;
        moveMentData = manager.MovementManager.MoveData;
    }
    public void UpdateAnimator()
    {
        SetUpPlayerState();
        var velocity = Manager.MovementManager.GetMoveVelocity();
        var localVelocity = Manager.MovementManager.InputManager.GetInputData().inputTransform
            .InverseTransformVector(velocity);
        Manager.Animator.SetFloat("velX",localVelocity.x);
        Manager.Animator.SetFloat("velZ",localVelocity.z);
        switch (animationState)
        {
              
            case AnimationMotionState.Stand:
                Manager.Animator.SetFloat("posTure",0);
                Manager.Animator.SetFloat("verticalPos",0,0.5f,Time.deltaTime);
                break;                                             
            case AnimationMotionState.Jumping:
                Manager.Animator.SetFloat("posTure",1);
                Manager.Animator.SetFloat("verticalPos",0);
                break;
            case AnimationMotionState.Falling:
                Manager.Animator.SetFloat("posTure",1);
                Manager.Animator.SetFloat("verticalPos",0.5f,0.5f,Time.deltaTime);
                break;
            case AnimationMotionState.Landing:
                Manager.Animator.SetFloat("posTure",1);
                Manager.Animator.SetFloat("verticalPos",1);
                Manager.Animator.Play("AirLocation");
                break;
            case AnimationMotionState.Climbing:
                Manager.Animator.SetFloat("posTure",1.5f);
                Manager.Animator.Play("BaseMotion",0,climbAnimationProgress);
                var temp = moveMentData.velocity;
                temp.z=0;
                if (temp.magnitude > 0.5f)
                {
                     AddClimbAnimationProgress(Time.deltaTime);
                }
                break;
        }
    }
}
