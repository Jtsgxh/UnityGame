/*
using System.Collections;
using System.Collections.Generic;
using KinematicCharacterController;
using KinematicCharacterController.Examples;
using UnityEngine;

public class CharacterControllerLearn : MonoBehaviour,ICharacterController
{
    // Start is called before the first frame update
    public KinematicCharacterMotor Motor;
    [Header("Stable Movement")]
    public float MaxStableMoveSpeed = 10f;
    public float StableMovementSharpness = 15;
    public float OrientationSharpness = 10;
    [Header("Air Movement")]
    public float MaxAirMoveSpeed = 10f;
    public float AirAccelerationSpeed = 5f;
    public float Drag = 0.1f;
    [Header("Misc")]
    public bool RotationObstruction;
    public Vector3 Gravity = new Vector3(0, -30f, 0);
    public Transform MeshRoot;
    protected Vector3 _moveInputVector;
    protected Vector3 _lookInputVector;
    protected bool jumpRequest = false;
    protected Vector3 jumpAddVelocity=Vector3.zero;
    public CharacterController characterController;
    [Header("Animation Part")]
    public float unGroundTime=0.1f;
    public float JumpSpeed = 20f;
    public void Start()
    {
        Motor = this.GetComponent<KinematicCharacterMotor>();
        Motor.CharacterController = this;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    public virtual void SetInputs(ref Player.PlayerCharacterInput inputs)
    {
       Vector3 moveInputVector = Vector3.ClampMagnitude(new Vector3(inputs.MoveAxisRight, 0f, inputs.MoveAxisForward), 1f);
       Vector3 cameraPlanarDirection = Vector3.ProjectOnPlane(inputs.CameraRotation * Vector3.forward, Motor.CharacterUp).normalized;
       if (cameraPlanarDirection.sqrMagnitude == 0)
       {
           cameraPlanarDirection = Vector3.ProjectOnPlane(inputs.CameraRotation * Vector3.up, Motor.CharacterUp).normalized;
       }
       Quaternion cameraPlanarRotation = Quaternion.LookRotation(cameraPlanarDirection, Motor.CharacterUp);
       Debug.DrawLine(transform.position,transform.position+cameraPlanarDirection*300,Color.red);
       // Move and look inputs
       _moveInputVector = cameraPlanarRotation * moveInputVector;
       Debug.DrawLine(transform.position,transform.position+_moveInputVector*150,Color.blue);
     //  _lookInputVector = cameraPlanarDirection;
       Debug.DrawLine(transform.position,transform.position+_lookInputVector*200,Color.green);
       if (inputs.JumpDown)
       {
           jumpRequest = true;
       }
       
    }

    protected void HandleRotation()
    {
        
    }

    protected void JumpWithoutRootMotion()
    {
        if (jumpRequest)
        {
            jumpAddVelocity = -Gravity *JumpSpeed;
        }
        else
        {
            jumpAddVelocity = Vector3.zero;
        }
    }
    public virtual void UpdateRotation(ref Quaternion currentRotation, float deltaTime)
    {
    }

    public virtual void UpdateVelocity(ref Vector3 currentVelocity, float deltaTime)
    {
           Vector3 targetMovementVelocity = Vector3.zero;
            if (Motor.GroundingStatus.IsStableOnGround)
            {  
                // Reorient source velocity on current ground slope (this is because we don't want our smoothing to cause any velocity losses in slope changes)
                currentVelocity = Motor.GetDirectionTangentToSurface(currentVelocity, Motor.GroundingStatus.GroundNormal) * currentVelocity.magnitude;
                Debug.DrawLine(transform.position, transform.position + currentVelocity * 100, Color.magenta);
                Vector3  inputRight = Vector3.Cross(_moveInputVector,Motor.CharacterUp);
                Vector3 reorientedInput = Vector3.Cross(Motor.GroundingStatus.GroundNormal,inputRight).normalized * _moveInputVector.magnitude;
                Debug.DrawLine(transform.position, transform.position + reorientedInput * 200, Color.yellow);
                targetMovementVelocity = reorientedInput * MaxStableMoveSpeed;
                currentVelocity = Vector3.Lerp(currentVelocity, targetMovementVelocity, 1 - Mathf.Exp(-StableMovementSharpness * deltaTime));
            }
            // Gravity
                currentVelocity += Gravity * deltaTime;
            
    }

    public virtual void BeforeCharacterUpdate(float deltaTime)
    {
  
    }

    public virtual void PostGroundingUpdate(float deltaTime)
    {

    }

    public virtual void AfterCharacterUpdate(float deltaTime)
    {
      jumpAddVelocity=Vector3.zero;
    }

    public virtual bool IsColliderValidForCollisions(Collider coll)
    {
        return true;
    }

    public virtual void OnGroundHit(Collider hitCollider, Vector3 hitNormal, Vector3 hitPoint, ref HitStabilityReport hitStabilityReport)
    {
 
    }

    public virtual void OnMovementHit(Collider hitCollider, Vector3 hitNormal, Vector3 hitPoint,
        ref HitStabilityReport hitStabilityReport)
    {
 
    }

    public virtual void ProcessHitStabilityReport(Collider hitCollider, Vector3 hitNormal, Vector3 hitPoint, Vector3 atCharacterPosition,
        Quaternion atCharacterRotation, ref HitStabilityReport hitStabilityReport)
    {
   
    }

    public virtual void OnDiscreteCollisionDetected(Collider hitCollider)
    {
    
    }
}
*/
