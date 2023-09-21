using System;
using UnityEngine;

public class MyCharacterController:MonoBehaviour
{
    public CharacterController CharacterController;
    public float Speed = 10f;
    public PlayerData playerData;
    public bool isOnGround;
    public Vector3 characterUp;
    public Vector3 currentVelocity;
    public Quaternion currentRotation;
    public float GroundCheckOffSet;
    private void Awake()
    {
        playerData=GetComponent<PlayerData>();
        CharacterController=GetComponent<CharacterController>();
        currentVelocity = new Vector3();
        currentRotation = new Quaternion();
    }
    
    private void Update()
    {
        characterUp= transform.up;
        SetInputs();
    }

    private void FixedUpdate()
    {
        
        UpdateVelocity(ref currentVelocity, Time.fixedDeltaTime);
        UpdateRotation(ref currentRotation,Time.fixedDeltaTime);
    }

    public virtual void SetInputs()
    {
        Vector3 moveInputVector = Vector3.ClampMagnitude(new Vector3(playerData.inputData.MoveAxisRight, 0f, playerData.inputData.MoveAxisForward), 1f);
        Debug.Log("move"+moveInputVector);
        // Calculate camera direction and rotation on the character plane
        Vector3 cameraPlanarDirection = Vector3.ProjectOnPlane(playerData.inputData.CameraRotation * Vector3.forward, characterUp).normalized;
        if (cameraPlanarDirection.sqrMagnitude == 0f)
        {
            cameraPlanarDirection = Vector3.ProjectOnPlane(playerData.inputData.CameraRotation * Vector3.up, characterUp).normalized;
        }
        Quaternion cameraPlanarRotation = Quaternion.LookRotation(cameraPlanarDirection, characterUp);

        // Move and look inputs
        playerData.characterControllerData.moveInputVector =(cameraPlanarRotation* moveInputVector).normalized;
        Debug.Log( "MoveInput"+ playerData.characterControllerData.moveInputVector);
        playerData.characterControllerData.lookInputVector = cameraPlanarDirection;
        playerData.characterControllerData.jumpAddVelocity = Vector3.zero;
    }
    
    public void UpdateRotation(ref Quaternion currentRotation, float deltaTime)
    {
        var _lookInputVector = playerData.characterControllerData.lookInputVector;
        if (_lookInputVector != Vector3.zero && playerData.characterControllerData.OrientationSharpness > 0f)
        {
            // Smoothly interpolate from current to target look direction
            Vector3 smoothedLookInputDirection = Vector3.Slerp(transform.forward, _lookInputVector, 1 - Mathf.Exp(-playerData.characterControllerData.OrientationSharpness * deltaTime)).normalized;

            // Set the current rotation (which will be used by the KinematicCharacterMotor)
            currentRotation = Quaternion.LookRotation(smoothedLookInputDirection, transform.up);
        }
        CharacterController.transform.rotation = currentRotation;
        // if (OrientTowardsGravity)
        // {
        //     // Rotate from current up to invert gravity
        //     currentRotation = Quaternion.FromToRotation((currentRotation * Vector3.up), -Gravity) * currentRotation;
        // }
    }
    
    protected void JumpWithoutRootMotion()
    {
        if (playerData.inputData.JumpDown)
        {
            playerData.characterControllerData.jumpAddVelocity = -playerData.characterControllerData.gravity *playerData.characterControllerData.JumpSpeed;
        }
        else
        {
            playerData.characterControllerData.jumpAddVelocity = Vector3.zero;
        }
    }
    
    public void UpdateVelocity(ref Vector3 currentVelocity, float deltaTime)
    {
        Vector3 targetMovementVelocity = Vector3.zero;
        var groundNormal =   CheckGround();
        if (isOnGround)
        {
            JumpWithoutRootMotion();
            // Reorient source velocity on current ground slope (this is because we don't want our smoothing to cause any velocity losses in slope changes)
            currentVelocity = GetDirectionTangentToSurface(currentVelocity, characterUp) * currentVelocity.magnitude;
            // Calculate target velocity
            Vector3 inputRight = Vector3.Cross(playerData.characterControllerData.moveInputVector, characterUp);
            Debug.DrawLine(transform.position,transform.position+playerData.characterControllerData.moveInputVector*100,Color.red);
            Vector3 reorientedInput = Vector3.Cross(groundNormal, inputRight).normalized * playerData.characterControllerData.moveInputVector.magnitude;
            targetMovementVelocity = reorientedInput * playerData.characterControllerData.walkSpeed;
           Debug.DrawLine(transform.position,transform.position+targetMovementVelocity*100,Color.green);
            // Smooth movement Velocity
            // currentVelocity = Vector3.Lerp(currentVelocity, targetMovementVelocity, 1 - Mathf.Exp(-playerData.characterControllerData.StableMovementSharpness * deltaTime));
            currentVelocity = targetMovementVelocity;
            this.currentVelocity += playerData.characterControllerData.jumpAddVelocity * deltaTime;
        }
        else
        {
            currentVelocity += playerData.characterControllerData.gravity*deltaTime;
        }
        CharacterController.Move(currentVelocity);
        
    }
    
    public Vector3 GetDirectionTangentToSurface(Vector3 direction, Vector3 surfaceNormal)
    {
        Vector3 directionRight = Vector3.Cross(direction, characterUp);
        return Vector3.Cross(surfaceNormal, directionRight).normalized;
    }

    public void SnapToGround()
    {
       // CharacterController.Move()
    }
    
    Vector3 CheckGround()
    {
        Debug.DrawRay(transform.position+(characterUp * GroundCheckOffSet),Vector3.down,Color.black,GroundCheckOffSet - CharacterController.radius + 2 * CharacterController.skinWidth);
        if (Physics.SphereCast(transform.position + (characterUp * GroundCheckOffSet), CharacterController.radius,
                Vector3.down, out RaycastHit hit, CharacterController.height/2 -CharacterController.radius + 2 * CharacterController.skinWidth))
        {
            isOnGround = true;
            Debug.DrawLine(transform.position, transform.position + hit.normal * 100, Color.blue);
            return hit.normal;
        }
        else
        {
            isOnGround = false;
            return Vector3.up;
        }
    }
}
