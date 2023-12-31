using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class CCPhysics : MonoBehaviour
{
    // Start is called before the first frame update
    public InputManager InputManager;
    public  PlayerData PlayerData;
    public float maxSpeed = 10f;
    public Vector3 velocity;
    public float maxAcceleration = 10f;
    public float  maxAirAcceleration = 1f;
    public Rigidbody body;
    public Vector3 desiredVelocity;
    public bool desiredJump;
    public float jumpHeight;
    public int maxAirJumps = 0;
    public int jumpPhase;
    public float maxGroundAngel = 25f;
    float minGroundDotProduct;
    private Vector3 contactNormal;
    private int groundContactCount;
    private int stepsSinceLastGrounded;
    public float maxSnapSpeed = 100f;
    public float probeDistance = 1f;
    [SerializeField] private LayerMask probeMask = -1;
    public int stepsSinceLastJump;
    
    #region StairsPart
    public  float maxStairsAngle = 50f;
    private float minStartStairsAngle;
    [SerializeField]
    LayerMask stairsMask = -1;
    #endregion
    
    #region SteepPart
    private Vector3 steepNormal;
    private int steepContactCount;
    bool OnSteep => steepContactCount > 0;
    #endregion
    
    #region 
    public Transform playerInputSpace = default;
    #endregion

    #region ClimbPart
    public float maxClimbAngel=140f;
    public float minClimtDotProduct;
    private Vector3 climbNormal;
    public int  climbContactCount; 
    public bool Climbing => climbContactCount > 0&&stepsSinceLastJump>2;
    public LayerMask climbMask = -1;
    public float maxClimbAcceleration;
    public float maxClimbSpeed;
    public bool desiresClimbing;
    public Vector3  lastClimbNormal;
    #endregion

    #region MoveWithPlane

    public Rigidbody connectedBody,previousConnectedBody;
    public Vector3 connectionWorldPosition;
    private Vector3 connectionVelocity,connectionLocalPosition;
    #endregion

    #region gravity
    private Vector3 upAxis,rightAxis,forwardAxis;
    public Vector3 gravityDir = new Vector3(0,-9.8f,0);
    #endregion
    bool OnGround => groundContactCount > 0;

    private void Awake()
    {
        body = GetComponent<Rigidbody>();
        InputManager = GetComponent<InputManager>();
        PlayerData = GetComponent<PlayerData>();
        body.useGravity = false;
        desiredVelocity = new Vector3();
      //  Physics.gravity = gravityDir;
        OnValidate();
    }

    private void OnValidate()
    {
        minGroundDotProduct = Mathf.Cos(maxGroundAngel*Mathf.Deg2Rad);
        minStartStairsAngle = Mathf.Cos(maxStairsAngle * Mathf.Deg2Rad);
        minClimtDotProduct = Mathf.Cos(maxClimbAngel * Mathf.Deg2Rad);
        minClimtDotProduct = Mathf.Cos(maxClimbAngel * Mathf.Deg2Rad);
    }

    void Start()
    {
        
    }
    public virtual void SetInputs()
    { 
        //      Debug.Log("move"+moveInputVector);
        // Calculate camera direction and rotation on the character plane
        transform.up=CustomGravity.GetGravity(transform.position).normalized;
        Vector3 cameraPlanarDirection = Vector3.ProjectOnPlane(PlayerData.inputData.CameraRotation * Vector3.forward, transform.up).normalized;
        if (cameraPlanarDirection.sqrMagnitude == 0f)
        {
            cameraPlanarDirection = Vector3.ProjectOnPlane(PlayerData.inputData.CameraRotation * Vector3.up, transform.up).normalized;
        }
        // Quaternion cameraPlanarRotation = Quaternion.LookRotation(cameraPlanarDirection, transform.up);
        //
        // // Move and look inputs
        // PlayerData.characterControllerData.moveInputVector =(cameraPlanarRotation* moveInputVector);
       // Debug.Log( "MoveInput"+ PlayerData.characterControllerData.moveInputVector);
        PlayerData.characterControllerData.lookInputVector = cameraPlanarDirection;
    }
    // Update is called once per frame
    void Update()
    {
        Physics.gravity = gravityDir;
        Vector2 playerInput;
        SetInputs();
        playerInput.x = PlayerData.inputData.MoveAxisRight;
        playerInput.y = PlayerData.inputData.MoveAxisForward;
        UpdateRotation(transform.rotation,Time.deltaTime);
        playerInput=Vector2.ClampMagnitude(playerInput,1f);
      if (playerInputSpace)
      {
          rightAxis = ProjectDirectionOnPlane(playerInputSpace.right, upAxis);
          forwardAxis = ProjectDirectionOnPlane(playerInputSpace.forward, upAxis);
          Debug.DrawRay(transform.position,forwardAxis*5,Color.black);
          /*Vector3 forward = playerInputSpace.forward;
          forward.y = 0f;
          forward.Normalize();
          Vector3 right = playerInputSpace.right;
          right.y = 0f;
          right.Normalize();*/
          desiredVelocity.x= playerInput.x*maxSpeed;
          desiredVelocity.z= playerInput.y*maxSpeed;
      }
      else
      {
          rightAxis = ProjectDirectionOnPlane(Vector3.right, upAxis);
          forwardAxis = ProjectDirectionOnPlane(Vector3.forward, upAxis);
          desiredVelocity=new Vector3(playerInput.x,0,playerInput.y)*maxSpeed;
      }
      desiredJump=Input.GetButton("Jump");
      desiresClimbing = Input.GetKey(KeyCode.J);
      GetComponent<Renderer>().material.SetColor(
          "_Color", OnGround ? Color.black : Color.white
      );
    }

    private void FixedUpdate()
    {
        //upAxis = -Physics.gravity.normalized;
        Vector3 gravity = CustomGravity.GetGravity(body.position, out upAxis);
        UpdateState();
        AdjustVelocity();
        if (desiredJump)
        {
            desiredJump = false;
            Jump(gravity);
        }
        
        if (Climbing) {
            velocity -= contactNormal * (maxClimbAcceleration * Time.fixedDeltaTime);
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

    void UpdateConnectionState () {
        if (connectedBody == previousConnectedBody) {
            Vector3 connectionMovement =
                connectedBody.transform.TransformPoint(connectionLocalPosition) -
                connectionWorldPosition;
            connectionVelocity = connectionMovement / Time.fixedDeltaTime;
        }
        connectionWorldPosition = body.position;
        connectionLocalPosition = connectedBody.transform.InverseTransformPoint(
            connectionWorldPosition
        );
    }

    void UpdateState () {
        stepsSinceLastGrounded += 1;
        stepsSinceLastJump += 1;
        velocity = body.velocity;
        Debug.Log(velocity);
        if (connectedBody)
        {
            if (connectedBody.isKinematic || connectedBody.mass >= body.mass)
            {
                UpdateConnectionState();
            }
        }
        if (CheckClimbing()||OnGround||SnapToGround()||CheckSteepContacts()) {
            stepsSinceLastGrounded = 0;
            //跳跃后下一步算作接地？
            if (stepsSinceLastJump > 1) {
                jumpPhase = 0;
            }
            if (groundContactCount > 1) {
                contactNormal.Normalize();
            }
        }
        else
        {
            contactNormal = upAxis;
        }
    }
    
    //沿着表面法线的跳跃
    void Jump (Vector3 gravity) {
        Vector3 jumpDirection;
        if (OnGround) {
            jumpDirection = contactNormal;
        }
        else if (OnSteep) {
            jumpDirection = steepNormal;
            jumpPhase = 0;
        }
        else if (maxAirJumps > 0&&jumpPhase <= maxAirJumps) {
            //
            if (jumpPhase == 0) {
                jumpPhase = 1;
            }
            jumpDirection = contactNormal;
        }else {
            return;
        }
        stepsSinceLastJump = 0;
        jumpPhase += 1;
        float jumpSpeed = Mathf.Sqrt(2f * gravity.magnitude * jumpHeight);
        jumpDirection = (jumpDirection + upAxis).normalized;
        float alignedSpeed = Vector3.Dot(velocity, jumpDirection);
        if (alignedSpeed > 0f) {
            jumpSpeed = Mathf.Max(jumpSpeed - alignedSpeed, 0f);
        }
        velocity += jumpDirection * jumpSpeed;
        //}
    }

    private void OnCollisionStay(Collision other)
    {
        EvaluateCollision(other);
    }

    private void OnCollisionEnter(Collision other)
    {
        EvaluateCollision(other);
    }
    
    void EvaluateCollision (Collision collision)
    {
        int layer = collision.gameObject.layer;
        float minDot = GetMinDot(layer);
        for (int i = 0; i < collision.contactCount; i++) {
            Vector3 normal = collision.GetContact(i).normal;
            float upDot = Vector3.Dot(upAxis, normal);
            if (upDot >= minDot) {
                groundContactCount += 1;
                contactNormal += normal;
                connectedBody = collision.rigidbody;
            }else 
            {
                if (upDot > -0.01f)
                {
                    steepContactCount += 1;
                    steepNormal += normal;
                    if (groundContactCount == 0)
                    {
                        connectedBody = collision.rigidbody;
                    }
                }

                if (desiresClimbing &&upDot >= minClimtDotProduct&&
                    (climbMask & (1 << layer)) != 0)
                {
                    climbContactCount += 1;
                    climbNormal += normal;
                    connectedBody = collision.rigidbody;
                }
            }
        }
    }
    
    void ClearState () {
        groundContactCount = steepContactCount = climbContactCount = 0;
        climbNormal=contactNormal = steepNormal = Vector3.zero;
        connectionVelocity= Vector3.zero;
        previousConnectedBody = connectedBody;
        connectedBody = null;

    }
    
    public Vector3 ProjectDirectionOnPlane(Vector3 vector,Vector3 contactNormal)
    {
        return (vector - contactNormal.normalized * Vector3.Dot(vector, contactNormal.normalized)).normalized;
    }
    public void UpdateRotation(Quaternion currentRotation, float deltaTime)
    {
        var _lookInputVector = PlayerData.characterControllerData.lookInputVector;
        if (_lookInputVector != Vector3.zero && PlayerData.characterControllerData.OrientationSharpness > 0f)
        {
            // Smoothly interpolate from current to target look direction
            Vector3 smoothedLookInputDirection = Vector3.Slerp(transform.forward, _lookInputVector, 1 - Mathf.Exp(-PlayerData.characterControllerData.OrientationSharpness * deltaTime)).normalized;

            // Set the current rotation (which will be used by the KinematicCharacterMotor)
            currentRotation = Quaternion.LookRotation(smoothedLookInputDirection, transform.up);
        }
       transform.rotation = currentRotation;
        // if (OrientTowardsGravity)
        // {
        //     // Rotate from current up to invert gravity
        //     currentRotation = Quaternion.FromToRotation((currentRotation * Vector3.up), -Gravity) * currentRotation;
        // }
    }
    void AdjustVelocity () {
        float acceleration, speed;
        Vector3 xAxis, zAxis;
        if (Climbing) {
            acceleration = maxClimbAcceleration;
            speed = maxClimbSpeed;
            xAxis = Vector3.Cross(contactNormal, upAxis);
            zAxis = upAxis;
        }
        else {
            acceleration = OnGround ? maxAcceleration : maxAirAcceleration;
            speed = OnGround && desiresClimbing ? maxClimbSpeed : maxSpeed;
            xAxis = rightAxis;
            zAxis = forwardAxis;
        }
       // Debug.DrawRay(transform.position,forwardAxis*5,Color.magenta);
        xAxis = ProjectDirectionOnPlane(xAxis, contactNormal);
      //  Debug.DrawRay(transform.position,xAxis*5,Color.red);
        zAxis = ProjectDirectionOnPlane(zAxis, contactNormal);
       // Debug.DrawRay(transform.position,zAxis*5,Color.blue);
        Vector3 relativeVelocity = velocity - connectionVelocity;
        float currentX = Vector3.Dot(relativeVelocity, xAxis);
        float currentZ = Vector3.Dot(relativeVelocity, zAxis);

        float maxSpeedChange = acceleration * Time.fixedDeltaTime;

        float newX =
            Mathf.MoveTowards(currentX, desiredVelocity.x * speed, maxSpeedChange);
        float newZ =
            Mathf.MoveTowards(currentZ, desiredVelocity.z * speed, maxSpeedChange);

        velocity += xAxis * (newX - currentX) + zAxis * (newZ - currentZ);
        //Debug.DrawRay(transform.position,velocity*5,Color.green);
    }

    bool SnapToGround()
    {
        if (stepsSinceLastGrounded > 1||stepsSinceLastJump<=2)
        {
            return false;
        }

        float speed = velocity.magnitude;
        if (speed > maxSnapSpeed)
        {
            return false;
        }
        
        if (!Physics.Raycast(body.position, -upAxis,out RaycastHit hit,probeDistance,probeMask))
        {
            return false;
        }
        
        float upDot = Vector3.Dot(upAxis, hit.normal);
        if (upDot < GetMinDot(hit.collider.gameObject.layer)) {
            return false;
        }

        groundContactCount = 1;
        contactNormal = hit.normal;
        float dot = Vector3.Dot(velocity, hit.normal);
        if (dot > 0f)
        {
            velocity = (velocity - hit.normal * dot).normalized * speed;
        }

        connectedBody = hit.rigidbody;
        return true;
    }

    float GetMinDot(int layer)
    {
        return (stairsMask & (1 << layer)) == 0 ? minGroundDotProduct : minStartStairsAngle;
    }

    bool CheckSteepContacts()
    {
        if (steepContactCount > 1) {
            steepNormal.Normalize();
            if (steepNormal.y >= minGroundDotProduct) {
                groundContactCount = 1;
                contactNormal = steepNormal;
                return true;
            }
        }
        return false;
    }
    
    bool CheckClimbing () {
        if (Climbing) {
            groundContactCount = climbContactCount;
            contactNormal = climbNormal;
            return true;
        }
        return false;
    }
}


