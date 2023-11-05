using System;
using UnityEngine;

public class MovementData : MonoBehaviour
{
    public Rigidbody body;
    public float maxSpeed = 10f;
    public Vector3 velocity;
    public float maxAcceleration = 10f;
    public float maxAirAcceleration = 1f;
    public Vector3 desiredVelocity;
    public float maxGroundAngel = 25f;
    public float minGroundDotProduct;
    public Vector3 contactNormal;
    public int groundContactCount;
    public int stepsSinceLastGrounded;
    public float maxSnapSpeed = 100f;
    public float probeDistance = 1f;
    public bool OnGround => groundContactCount > 0;
    [SerializeField] public  LayerMask probeMask = -1;

    public float jumpHeight;
    public int maxAirJumps = 0;
    public int jumpPhase;
    public int stepsSinceLastJump;

    #region StairsPart

    public float maxStairsAngle = 50f;
    public  float minStartStairsAngle;
    [SerializeField] public LayerMask stairsMask = -1;

    #endregion

    #region SteepPart

    public  Vector3 steepNormal;
    public int steepContactCount;
    public bool OnSteep => steepContactCount > 0;

    #endregion

    #region ClimbPart

    public float maxClimbAngel = 140f;
    public float minClimtDotProduct;
    public  Vector3 climbNormal;
    public int climbContactCount;
    public bool Climbing => climbContactCount > 0 && stepsSinceLastJump > 2;
    public LayerMask climbMask = -1;
    public float maxClimbAcceleration;
    public float maxClimbSpeed;
    public bool desiresClimbing;
    public Vector3 lastClimbNormal;

    #endregion

    #region MoveWithPlane

    public Rigidbody connectedBody, previousConnectedBody;
    public Vector3 connectionWorldPosition;
    public  Vector3 connectionVelocity, connectionLocalPosition;

    #endregion

    #region gravity

    public  Vector3 upAxis, rightAxis, forwardAxis;
    public Vector3 gravityDir = new Vector3(0, -9.8f, 0);

    #endregion


    public void Init()
    {
        OnValidate();
        body = GetComponent<Rigidbody>();
        body.useGravity = false;
        desiredVelocity = new Vector3();
        
    }

    public void OnValidate()
    {
        minGroundDotProduct = Mathf.Cos(maxGroundAngel*Mathf.Deg2Rad);
        minStartStairsAngle = Mathf.Cos(maxStairsAngle * Mathf.Deg2Rad);
        minClimtDotProduct = Mathf.Cos(maxClimbAngel * Mathf.Deg2Rad);
        minClimtDotProduct = Mathf.Cos(maxClimbAngel * Mathf.Deg2Rad);
    }

    private void Start()
    {
        Init();
    }
    
    private void OnCollisionStay(Collision other)
    {
        EvaluateCollision(other);
    }

    private void OnCollisionEnter(Collision other)
    {
        EvaluateCollision(other);
    }
    
    float GetMinDot(int layer)
    {
        return (stairsMask & (1 << layer)) == 0 ? minGroundDotProduct : minStartStairsAngle;
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

}
