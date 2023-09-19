/*using System;
using UnityEngine;
using KinematicCharacterController;
namespace MyGame2.Scripts.NewArtitecture
{
    public class CharacterControllerNew:MonoBehaviour,ICharacterController
    {
        public KinematicCharacterMotor Motor;
        public PlayerData playerData;
        public Vector3 velocity;
        private void Start()
        {
            Motor = this.GetComponent<KinematicCharacterMotor>();
            Motor.CharacterController = this;
        }

        private void Update()
        {
            SetInputs();
        }

        public virtual void SetInputs()
        {
            Vector3 moveInputVector = Vector3.ClampMagnitude(new Vector3(playerData.inputData.MoveAxisRight, 0f, playerData.inputData.MoveAxisForward), 1f);
            Debug.Log("move"+moveInputVector);
            // Calculate camera direction and rotation on the character plane
            Vector3 cameraPlanarDirection = Vector3.ProjectOnPlane(playerData.inputData.CameraRotation * Vector3.forward, Motor.CharacterUp).normalized;
            if (cameraPlanarDirection.sqrMagnitude == 0f)
            {
                cameraPlanarDirection = Vector3.ProjectOnPlane(playerData.inputData.CameraRotation * Vector3.up, Motor.CharacterUp).normalized;
            }
            Quaternion cameraPlanarRotation = Quaternion.LookRotation(cameraPlanarDirection, Motor.CharacterUp);

            // Move and look inputs
            playerData.characterControllerData.moveInputVector =(cameraPlanarRotation* moveInputVector).normalized;
            Debug.Log( "MoveInput"+ playerData.characterControllerData.moveInputVector);
            playerData.characterControllerData.lookInputVector = cameraPlanarDirection;
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
        public void UpdateRotation(ref Quaternion currentRotation, float deltaTime)
        {
            var _lookInputVector = playerData.characterControllerData.lookInputVector;
            if (_lookInputVector != Vector3.zero && playerData.characterControllerData.OrientationSharpness > 0f)
            {
                // Smoothly interpolate from current to target look direction
                Vector3 smoothedLookInputDirection = Vector3.Slerp(Motor.CharacterForward, _lookInputVector, 1 - Mathf.Exp(-playerData.characterControllerData.OrientationSharpness * deltaTime)).normalized;

                // Set the current rotation (which will be used by the KinematicCharacterMotor)
                currentRotation = Quaternion.LookRotation(smoothedLookInputDirection, Motor.CharacterUp);
            }
            // if (OrientTowardsGravity)
            // {
            //     // Rotate from current up to invert gravity
            //     currentRotation = Quaternion.FromToRotation((currentRotation * Vector3.up), -Gravity) * currentRotation;
            // }
        }

        public void UpdateVelocity(ref Vector3 currentVelocity, float deltaTime)
        {
            Vector3 targetMovementVelocity = Vector3.zero;
            if (Motor.GroundingStatus.IsStableOnGround)
            {
                // Reorient source velocity on current ground slope (this is because we don't want our smoothing to cause any velocity losses in slope changes)
                currentVelocity = Motor.GetDirectionTangentToSurface(currentVelocity, Motor.CharacterUp) * currentVelocity.magnitude;

                // Calculate target velocity
                Vector3 inputRight = Vector3.Cross(playerData.characterControllerData.moveInputVector, Motor.CharacterUp);
                Vector3 reorientedInput = Vector3.Cross(Motor.GroundingStatus.GroundNormal, inputRight).normalized * playerData.characterControllerData.moveInputVector.magnitude;
                targetMovementVelocity = reorientedInput * playerData.characterControllerData.MaxAirMoveSpeed;
                Debug.Log("targetV"+targetMovementVelocity);
                // Smooth movement Velocity
               // currentVelocity = Vector3.Lerp(currentVelocity, targetMovementVelocity, 1 - Mathf.Exp(-playerData.characterControllerData.StableMovementSharpness * deltaTime));
               currentVelocity = targetMovementVelocity;
            }
            currentVelocity += playerData.characterControllerData.gravity*deltaTime;
        }
     
        public void BeforeCharacterUpdate(float deltaTime)
        {
          
        }

        public void PostGroundingUpdate(float deltaTime)
        {
           
        }

        public void AfterCharacterUpdate(float deltaTime)
        {
            playerData.characterControllerData.jumpAddVelocity = Vector3.zero;
        }

        public bool IsColliderValidForCollisions(Collider coll)
        {
            return true;
        }

        public void OnGroundHit(Collider hitCollider, Vector3 hitNormal, Vector3 hitPoint, ref HitStabilityReport hitStabilityReport)
        {
           
        }

        public void OnMovementHit(Collider hitCollider, Vector3 hitNormal, Vector3 hitPoint,
            ref HitStabilityReport hitStabilityReport)
        {
          
        }

        public void ProcessHitStabilityReport(Collider hitCollider, Vector3 hitNormal, Vector3 hitPoint, Vector3 atCharacterPosition,
            Quaternion atCharacterRotation, ref HitStabilityReport hitStabilityReport)
        {
           
        }

        public void OnDiscreteCollisionDetected(Collider hitCollider)
        {
          
        }
    }
}*/