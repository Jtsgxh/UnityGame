using Unity.VisualScripting;
using UnityEngine;

public class MoveMethod01:ICharacterMove
{
    public MovementManager mgr;

    private InputDataNew InputData
    {
        get => mgr.InputManager.GetInputData();
    }
    public MoveMethod01(MovementManager mrg)
    {
        this.mgr = mrg;
    }
    
    public void UpdateRotation( float deltaTime,MovementData data)
    {
        Quaternion currentRotation = data.transform.rotation;
        var inputData = mgr.InputManager.GetInputData();
        Vector3 cameraPlanarDirection = Vector3.ProjectOnPlane(inputData.inputTransform.rotation * Vector3.forward, data.transform.up).normalized;
        if (cameraPlanarDirection.sqrMagnitude == 0f)
        {
            cameraPlanarDirection = Vector3.ProjectOnPlane(inputData.inputTransform.rotation * Vector3.up, data.transform.up).normalized;
        }
        var _lookInputVector = cameraPlanarDirection;
        if (_lookInputVector != Vector3.zero && data.OrientationSharpness > 0f)
        {
            // Smoothly interpolate from current to target look direction
            Vector3 smoothedLookInputDirection = Vector3.Slerp(data.transform.forward, _lookInputVector, 1 - Mathf.Exp(-data.OrientationSharpness * deltaTime)).normalized;

            // Set the current rotation (which will be used by the KinematicCharacterMotor)
            currentRotation = Quaternion.LookRotation(smoothedLookInputDirection, data.transform.up);
        }
        data.transform.rotation = currentRotation;
        // if (OrientTowardsGravity)
        // {
        //     // Rotate from current up to invert gravity
        //     currentRotation = Quaternion.FromToRotation((currentRotation * Vector3.up), -Gravity) * currentRotation;
        // }
    }
    public virtual void LogicUpdate(MovementData data)
    {
        var inputData = mgr.InputManager.GetInputData();
        Physics.gravity = data.gravityDir;
        Vector2 playerInput;
        //data.transform.up= -CustomGravity.GetGravity(data.transform.position).normalized;;
        playerInput.x = inputData.MoveAxisRight;
        playerInput.y = inputData.MoveAxisForward;
        UpdateRotation(Time.deltaTime,data);
        playerInput=Vector2.ClampMagnitude(playerInput,1f);
        if (inputData.inputTransform)
        {
            var playerInputSpace = inputData.inputTransform;
            data.rightAxis = ProjectDirectionOnPlane(playerInputSpace.right, data.upAxis);
            data.forwardAxis = ProjectDirectionOnPlane(playerInputSpace.forward, data.upAxis);
            Debug.DrawRay(data.transform.position,data.forwardAxis*5,Color.black);
            /*Vector3 forward = playerInputSpace.forward;
            forward.y = 0f;
            forward.Normalize();
            Vector3 right = playerInputSpace.right;
            right.y = 0f;
            right.Normalize();*/
            data.desiredVelocity.x= playerInput.x;
            data.desiredVelocity.z= playerInput.y;
        }
        else
        {
            data.rightAxis = ProjectDirectionOnPlane(Vector3.right, data.upAxis);
            data.forwardAxis = ProjectDirectionOnPlane(Vector3.forward, data.upAxis);
            data.desiredVelocity=new Vector3(playerInput.x,0,playerInput.y)*data.maxSpeed;
        }
        /*data.transform.GetComponent<Renderer>().material.SetColor(
            "_Color", data.OnGround ? Color.black : Color.white
        );*/
    }
    void UpdateConnectionState (MovementData data) {
        if (data.connectedBody == data.previousConnectedBody) {
            Vector3 connectionMovement =
                data.connectedBody.transform.TransformPoint(data.connectionLocalPosition) -
                data.connectionWorldPosition;
            data. connectionVelocity = connectionMovement / Time.fixedDeltaTime;
        }
        data.connectionWorldPosition =data.body.position;
        data. connectionLocalPosition = data.connectedBody.transform.InverseTransformPoint(
            data.connectionWorldPosition
        );
    }
    
    bool CheckClimbing (MovementData data) {
        if (data.Climbing) {
            data.groundContactCount = data.climbContactCount;
            data.contactNormal = data.climbNormal;
            return true;
        }
        return false;
    }
    
    float GetMinDot(int layer,MovementData data)
    {
        return (data.stairsMask & (1 << layer)) == 0 ?data. minGroundDotProduct : data.minStartStairsAngle;
    }

    bool CheckSteepContacts(MovementData data)
    {
        if (data.steepContactCount > 1) {
            data.steepNormal.Normalize();
            if (data.steepNormal.y >= data.minGroundDotProduct) {
                data.groundContactCount = 1;
                data.contactNormal = data.steepNormal;
                return true;
            }
        }
        return false;
    }
    
    bool SnapToGround(MovementData data)
    {
        if (data.stepsSinceLastGrounded > 1||data.stepsSinceLastJump<=2)
        {
            return false;
        }

        float speed = data.velocity.magnitude;
        if (speed >data. maxSnapSpeed)
        {
            return false;
        }
        
        if (!Physics.Raycast(data.body.position, -data.upAxis,out RaycastHit hit,data.probeDistance,data.probeMask))
        {
            return false;
        }
        
        float upDot = Vector3.Dot(data.upAxis, hit.normal);
        if (upDot < GetMinDot(hit.collider.gameObject.layer,data)) {
            return false;
        }

        data.groundContactCount = 1;
        data.contactNormal = hit.normal;
        float dot = Vector3.Dot(data.velocity, hit.normal);
        if (dot > 0f)
        {
            data.velocity = (data.velocity - hit.normal * dot).normalized * speed;
        }

        data.connectedBody = hit.rigidbody;
        return true;
    }
    
    void UpdateState (MovementData data) {
        data.stepsSinceLastGrounded += 1;
        data.stepsSinceLastJump += 1;
        data.velocity = data.body.velocity;
        //Debug.Log(data.velocity);
        if (data.connectedBody)
        {
            if (data.connectedBody.isKinematic ||data. connectedBody.mass >= data.body.mass)
            {
                UpdateConnectionState(data);
            }
        }
        if (CheckClimbing(data)||data.OnGround||SnapToGround(data)||CheckSteepContacts(data)) {
            data.stepsSinceLastGrounded = 0;
            //跳跃后下一步算作接地？
            if (data.stepsSinceLastJump > 1) {
                data.jumpPhase = 0;
            }
            if (data.groundContactCount > 1) {
                data. contactNormal.Normalize();
            }
        }
        else
        {
            data.contactNormal = data.upAxis;
        }
    }

    void AdjustVelocity (MovementData data) {
        float acceleration, speed;
        Vector3 xAxis, zAxis;
        if (data.Climbing) {
            acceleration = data.maxClimbAcceleration;
            speed = data.maxClimbSpeed;
            xAxis = Vector3.Cross(data.contactNormal, data.upAxis);
            zAxis = data.upAxis;
        }
        else {
            acceleration =data. OnGround ? data.maxAcceleration : data.maxAirAcceleration;
            speed = data.OnGround && data.desiresClimbing ?data. maxClimbSpeed : data.maxSpeed;
            xAxis = data.rightAxis;
            zAxis =data. forwardAxis;
        }
        // Debug.DrawRay(transform.position,forwardAxis*5,Color.magenta);
        xAxis = ProjectDirectionOnPlane(xAxis,data. contactNormal);
        //  Debug.DrawRay(transform.position,xAxis*5,Color.red);
        zAxis = ProjectDirectionOnPlane(zAxis, data.contactNormal);
        // Debug.DrawRay(transform.position,zAxis*5,Color.blue);
        Vector3 relativeVelocity = data.velocity -data. connectionVelocity;
        float currentX = Vector3.Dot(relativeVelocity, xAxis);
        float currentZ = Vector3.Dot(relativeVelocity, zAxis);

        float maxSpeedChange = acceleration * Time.fixedDeltaTime;

        float newX =
            Mathf.MoveTowards(currentX, data.desiredVelocity.x * speed, maxSpeedChange);
        float newZ =
            Mathf.MoveTowards(currentZ, data.desiredVelocity.z * speed, maxSpeedChange);
         
       
        data.velocity += xAxis * (newX - currentX) + zAxis * (newZ - currentZ);
     //    Debug.Log("data velocity is"+data.velocity);
    }
    
    void ClearState (MovementData data) {
        data.groundContactCount =  data.steepContactCount =  data.climbContactCount = 0;
        data. climbNormal= data.contactNormal =  data.steepNormal = Vector3.zero;
        data. connectionVelocity= Vector3.zero;
        data.previousConnectedBody =  data.connectedBody;
        data. connectedBody = null;

    }
    
    void Jump (Vector3 gravity,MovementData data) {
        Vector3 jumpDirection;
        if (data.OnGround) {
            jumpDirection = data.contactNormal;
        }
        else if (data.OnSteep) {
            jumpDirection =data. steepNormal;
            data.jumpPhase = 0;
        }
        else if (data.maxAirJumps > 0&&data.jumpPhase <= data.maxAirJumps) {
            //
            if (data.jumpPhase == 0) {
                data.jumpPhase = 1;
            }
            jumpDirection = data.contactNormal;
        }else {
            return;
        }
        data.stepsSinceLastJump = 0;
        data.jumpPhase += 1;
        float jumpSpeed = Mathf.Sqrt(2f * gravity.magnitude * data.jumpHeight);
        jumpDirection = (jumpDirection + data.upAxis).normalized;
        float alignedSpeed = Vector3.Dot(data.velocity, jumpDirection);
        if (alignedSpeed > 0f) {
            jumpSpeed = Mathf.Max(jumpSpeed - alignedSpeed, 0f);
        }
        data.velocity += jumpDirection * jumpSpeed;
        //}
    }

    public virtual void PhysicsUpdate(MovementData data)
    {
        var inputData = mgr.InputManager.GetInputData();
        Vector3 gravity = CustomGravity.GetGravity(data.body.position, out data.upAxis);
        UpdateState(data);
        AdjustVelocity(data);
        if (inputData.desiredJump)
        {
            inputData. desiredJump = false;
            Jump(gravity,data);
        }
        
        if (data.Climbing) {
            data.velocity -= data.contactNormal * (data.maxClimbAcceleration * Time.fixedDeltaTime);
        }
        else if (data.OnGround && data.velocity.sqrMagnitude < 0.01f) {
            data.velocity +=
                data.contactNormal *
                (Vector3.Dot(gravity, data.contactNormal) * Time.fixedDeltaTime);
        }
        else if (data.desiresClimbing && data.OnGround) {
            data.velocity +=
                (gravity - data.contactNormal * (data.maxClimbAcceleration * 0.9f)) *
                Time.fixedDeltaTime;
        }
        else
        {
            data.velocity += gravity * Time.fixedDeltaTime;
        }
        data.body.velocity = data.velocity;
        ClearState(data);
    }
    
    public Vector3 ProjectDirectionOnPlane(Vector3 vector,Vector3 contactNormal)
    {
        return (vector - contactNormal.normalized * Vector3.Dot(vector, contactNormal.normalized)).normalized;
    }

    public void UpdateAnimationState()
    {
        
    }
}
