using Unity.VisualScripting;
using UnityEngine;

public class MoveMethod01:ICharacterMove<IPlayerInputManager>
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


    public void Walk(MovementData data)
    {
        throw new System.NotImplementedException();
    }

    public void Run(MovementData data)
    {
        throw new System.NotImplementedException();
    }

    public void Climb(MovementData data)
    {
        throw new System.NotImplementedException();
    }

    public void Jump(MovementData data)
    {
      
    }

    public bool IsOnGround(MovementData data)
    {
        throw new System.NotImplementedException();
    }

    public bool IsClimbing(MovementData data)
    {
        throw new System.NotImplementedException();
    }

    public bool IsJumping(MovementData data)
    {
        throw new System.NotImplementedException();
    }

    public bool IsFalling(MovementData data)
    {
        throw new System.NotImplementedException();
    }

    public bool IsRunning(MovementData data)
    {
        throw new System.NotImplementedException();
    }

    public bool IsWalking(MovementData data)
    {
        throw new System.NotImplementedException();
    }

    public void Init(IPlayerInputManager t)
    {
        throw new System.NotImplementedException();
    }
    public void LogicUpdate(MovementData data)
    {
        var inputData = mgr.InputManager.GetInputData();
        Physics.gravity = data.gravityDir;
        Vector2 playerInput;
        data.transform.up= CustomGravity.GetGravity(data.transform.position).normalized;;
        playerInput.x = inputData.MoveAxisRight;
        playerInput.y = inputData.MoveAxisForward;
       // UpdateRotation(transform.rotation,Time.deltaTime);
        playerInput=Vector2.ClampMagnitude(playerInput,1f);
        if (mgr.InputManager.GetInputData().inputTransform)
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
            data.desiredVelocity.x= playerInput.x*data.maxSpeed;
            data.desiredVelocity.z= playerInput.y*data.maxSpeed;
        }
        else
        {
            data.rightAxis = ProjectDirectionOnPlane(Vector3.right, data.upAxis);
            data.forwardAxis = ProjectDirectionOnPlane(Vector3.forward, data.upAxis);
            data.desiredVelocity=new Vector3(playerInput.x,0,playerInput.y)*data.maxSpeed;
        }
        data.transform.GetComponent<Renderer>().material.SetColor(
            "_Color", data.OnGround ? Color.black : Color.white
        );
    }

    public void PhysicsUpdate(MovementData data)
    {
        var inputData = mgr.InputManager.GetInputData();
        Vector3 gravity = CustomGravity.GetGravity(data.body.position, out data.upAxis);
        UpdateState();
        AdjustVelocity();
        if (desiredJump)
        {
            desiredJump = false;
            Jump(gravity);
        }
        
        if (data.Climbing) {
            data.velocity -= data.contactNormal * (data.maxClimbAcceleration * Time.fixedDeltaTime);
        }
        else if (OnGround && velocity.sqrMagnitude < 0.01f) {
            velocity +=
                contactNormal *
                (Vector3.Dot(gravity, contactNormal) * Time.fixedDeltaTime);
        }
        else if (desiresClimbing && OnGround) {
            velocity +=
                (gravity - contactNormal * (maxClimbAcceleration * 0.9f)) *
                Time.fixedDeltaTime;
        }
        else
        {
            velocity += gravity * Time.fixedDeltaTime;
        }
        body.velocity = velocity;
        ClearState();
    }
    
    public Vector3 ProjectDirectionOnPlane(Vector3 vector,Vector3 contactNormal)
    {
        return (vector - contactNormal.normalized * Vector3.Dot(vector, contactNormal.normalized)).normalized;
    }
}
