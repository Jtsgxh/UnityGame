/*
using System;
using System.Collections;
using System.Collections.Generic;
using KinematicCharacterController;
using RootMotion.FinalIK;
using UnityEngine;
[RequireComponent(typeof(Animator))]
public class CharacterControllerRootMotion : CharacterControllerLearn
{
    #region AnimatorRegion
    private const float standPos = 0f;
    private const float AirPos=1f;
    public Animator Animator;
    public float forwardAxis;
    public float rightAxis;
    public float forwardSharpness = 15f;
    public float turnAxisSharpness = 10f;
    public float targetForwardAxis;
    public float targetRightAxis;
    public float walkThreadHold=1.89f;
    public float runThreadHold=3.6f;
    public Vector3 _currentVelocity;
    private int _forwardAxisHash;
    private int _rightAxisHash;
    private int _PostureHash;
    private int _verticalPos;
    #region CamearPart
    public Camera playerCamera;
   // public Transform hitPoint;
    #endregion
    #region WeaponPart
    public WeaponManager weaponNanager;
    #endregion
    #region PlayerState
    
    [HideInInspector] public enum PlayerState
    {
        Stand,
        Jumping,
        Landing,
        Falling
    };
    [HideInInspector]public enum LocomotionState
    {
        Idle,
        Walk,
        Run,
    };
    public PlayerState playerState;
    public PlayerState lastPlayerState;
    public LocomotionState locomotionState;
    #endregion
    #region jumpRegion
    public float JumpStartThreshold = 0f;
    public float midAirThreshold=0.5f;
    public float landThreshold = 1f;
    public float verticalPos;
    public bool jumpAnimation;
    #endregion
    #endregion

    public bool OrientTowardsGravity;
    public Vector3 rootMotionPostionDelta;
    public Quaternion rootMotionRotationDelta;
    void Start()
    {
      //  hitPoint = GameObject.Find("AimTarget1").GetComponent<Transform>();
        Motor = this.GetComponent<KinematicCharacterMotor>();
        Motor.CharacterController = this;
        Animator = this.GetComponent<Animator>();
        ManagerList.Instance.animatorController = Animator;
        playerState=PlayerState.Stand;
        locomotionState = LocomotionState.Idle;
        _forwardAxisHash = Animator.StringToHash("forwardAxis");
        _rightAxisHash = Animator.StringToHash("rightAxis");
        _PostureHash = Animator.StringToHash("Posture");
        _verticalPos=Animator.StringToHash("VerticalPos");
        playerCamera = GameObject.FindWithTag("PlayerCamera").GetComponent<Camera>();
        weaponNanager = GetComponent<WeaponManager>();
        weaponNanager.ManagerStart();
        ManagerList.Instance.weaponManager = weaponNanager;
        weaponNanager.ChangeWeapon(0);
    }

    public void SetUpPlayerState()
    {   lastPlayerState = playerState;
        if (!Motor.GroundingStatus.IsStableOnGround)
        {   
            if(Vector3.Dot(_currentVelocity,Gravity)>0)
            {
                playerState=PlayerState.Falling;
            }
            else
            {
                playerState=PlayerState.Jumping;
            }
        }
        else
        {
            if (lastPlayerState == PlayerState.Falling)
            {
                playerState = PlayerState.Landing;
            }
            else
            {
                playerState = PlayerState.Stand;
            }
        }
    }

    public override void SetInputs(ref Player.PlayerCharacterInput inputs)
    {
        if (inputs.rush)
        {
            targetForwardAxis=runThreadHold*inputs.MoveAxisForward;
            targetRightAxis = inputs.MoveAxisRight*runThreadHold;
        }
        else
        {
            targetForwardAxis = walkThreadHold * inputs.MoveAxisForward;
            targetRightAxis = inputs.MoveAxisRight*walkThreadHold;
        }
        forwardAxis = Mathf.Lerp(forwardAxis, targetForwardAxis, 1f - Mathf.Exp(-forwardSharpness * Time.deltaTime));
        rightAxis = Mathf.Lerp(rightAxis, targetRightAxis, 1f - Mathf.Exp(-turnAxisSharpness * Time.deltaTime));
        Vector3 cameraPlanarDirection = Vector3.ProjectOnPlane(inputs.CameraRotation * Vector3.forward, Motor.CharacterUp).normalized;
        if (cameraPlanarDirection.sqrMagnitude == 0)
        {
            cameraPlanarDirection = Vector3.ProjectOnPlane(inputs.CameraRotation * Vector3.up, Motor.CharacterUp).normalized;
        }
        Quaternion cameraPlanarRotation = Quaternion.LookRotation(cameraPlanarDirection, Motor.CharacterUp);
        _moveInputVector =cameraPlanarRotation*new Vector3(rightAxis, 0, forwardAxis);
        _lookInputVector = cameraPlanarDirection;
        if (inputs.JumpDown)
        {
            jumpRequest = true;
        }

    }

    void Update()
    {
        HandleLogic();
    }

    private void HandleLogic()
    {
        RaycastHit hit;
        //射线投射 忽略Player层
        if (Physics.Raycast(playerCamera.transform.position, playerCamera.transform.forward, out hit, 100f, ~(1 << LayerMask.NameToLayer("Player"))))
        {
            ManagerList.Instance.weaponManager.aimTarget.position = hit.point;
            //在被击中的点上画绿点
            Debug.DrawLine(playerCamera.transform.position, hit.point, Color.green);
        }
        else
        {
            ManagerList.Instance.weaponManager.aimTarget.position = playerCamera.transform.position + playerCamera.transform.forward * 100f;
        }
      
        if (ManagerList.Instance.player.characterInputs.reload)
        {
            ManagerList.Instance.weaponManager.Reload();
        }
        else
        {
          ManagerList.Instance.weaponManager.SetShoot(ManagerList.Instance.player.characterInputs.shoot,Time.deltaTime);   
        }
        
    }

    private void HandleAnimation(float deltaTime)
    {
        Animator.SetFloat(_forwardAxisHash, forwardAxis);
        Animator.SetFloat(_rightAxisHash, rightAxis);
        //Animator.SetBool(_RifleHash,isRifle);
        //aimIk.solver.transform=hitPoint;
        switch (playerState)
        {
            case PlayerState.Stand:
                Animator.SetFloat(_PostureHash,standPos,0.5f,deltaTime);
                Animator.SetFloat(_verticalPos,0,1f,deltaTime);
                break;
            case PlayerState.Jumping:
                Animator.SetFloat(_PostureHash,AirPos);
                Animator.SetFloat(_verticalPos,0);
                break;
            case PlayerState.Falling:
                Animator.SetFloat(_PostureHash,AirPos);
                Animator.SetFloat(_verticalPos,0.5f,0.5f,deltaTime);
                break;
            case PlayerState.Landing:
                Animator.SetFloat(_PostureHash,AirPos);
                Animator.SetFloat(_verticalPos,1);
                break;
        }
        //设置aimIk的target对象
    }
    public override void UpdateRotation(ref Quaternion currentRotation, float deltaTime)
    {
        if (_lookInputVector != Vector3.zero && OrientationSharpness > 0f)
        {
            // Smoothly interpolate from current to target look direction
            Vector3 smoothedLookInputDirection = Vector3.Slerp(Motor.CharacterForward, _lookInputVector, 1 - Mathf.Exp(-OrientationSharpness * deltaTime)).normalized;

            // Set the current rotation (which will be used by the KinematicCharacterMotor)
            currentRotation = Quaternion.LookRotation(smoothedLookInputDirection, Motor.CharacterUp);
        }
        if (OrientTowardsGravity)
        {
            // Rotate from current up to invert gravity
            currentRotation = Quaternion.FromToRotation((currentRotation * Vector3.up), -Gravity) * currentRotation;
        }
    }

    protected void JumpWithRootMotion()
    {
        if (jumpRequest)
        {
            jumpAnimation = true;
        }
        JumpWithoutRootMotion();
        
    }

    public override void UpdateVelocity(ref Vector3 currentVelocity, float deltaTime)
    {
        if (Motor.GroundingStatus.IsStableOnGround)
        {
            JumpWithRootMotion();
            if (deltaTime > 0)
            {
                // The final velocity is the velocity from root motion reoriented on the ground plane
                currentVelocity = rootMotionPostionDelta / deltaTime;
                currentVelocity = Motor.GetDirectionTangentToSurface(currentVelocity, Motor.GroundingStatus.GroundNormal) * currentVelocity.magnitude;
                Debug.DrawLine(transform.position,transform.position+currentVelocity,Color.red);
            }
            else
            {
                // Prevent division by zero
                currentVelocity = Vector3.zero;
                Debug.Log(currentVelocity);
            }
        }
        else
        {
           
        }

        if (jumpRequest)
        {
            Motor.ForceUnground(unGroundTime);
        }
        currentVelocity += jumpAddVelocity * deltaTime;
        currentVelocity += Gravity * deltaTime;

        // Drag
        currentVelocity *= (1f / (1f + (Drag * deltaTime)));
        _currentVelocity = currentVelocity;
    }
    
    public override void AfterCharacterUpdate(float deltaTime)
    {
        Debug.Log("AfterCharacterUpdate");
        SetUpPlayerState();
        HandleAnimation(deltaTime);   
        rootMotionPostionDelta=Vector3.zero;
        rootMotionRotationDelta=Quaternion.identity;
        jumpAddVelocity=Vector3.zero;
        jumpRequest = false;
        jumpAnimation=false;
    }

    private void OnAnimatorMove()
    {
        Debug.Log("OnAnimatorMove");
        rootMotionPostionDelta += Animator.deltaPosition;
        rootMotionRotationDelta = Animator.deltaRotation * rootMotionRotationDelta;
    }

    public override void OnGroundHit(Collider hitCollider, Vector3 hitNormal, Vector3 hitPoint, ref HitStabilityReport hitStabilityReport)
    {
    }
}
*/
