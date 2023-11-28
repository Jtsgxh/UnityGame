using System;
using UnityEngine;

public class CameraManager:MonoBehaviour
{
    public Transform focus;
    public float distance;
    public Vector3 focusPoint;
    public InputDataNew playerData;
    [SerializeField, Min(0f)]
    float focusRadius = 1f;
    [SerializeField, Range(0f, 1f)]
    float focusCentering = 0.5f;
    Vector2 orbitAngles = new Vector2(45f, 0f);
    Quaternion gravityAlignment = Quaternion.identity;
    Quaternion orbitRotation;
    [SerializeField,Range(-90,0)]
    private float minAngle = -90;
    [SerializeField,Range(0,150)]
    private float maxAngle = 90;
    private void Awake()
    {
        focusPoint = focus.position;
        transform.localRotation = orbitRotation = Quaternion.Euler(orbitAngles);
    }

    private void Start()
    {
        
    }

    private void Update()
    {
        // RaycastHit hit;
        // if (Physics.Raycast(transform.position, transform.forward, out hit, 100))
        // {
        //     playerData.cameraData.aimPoint=hit.point;
        // }
        // else
        // {
        //     playerData.cameraData.aimPoint = transform.position + transform.forward * 100;
        // }
      //  GameObject.CreatePrimitive(PrimitiveType.Sphere).transform.position = playerData.cameraData.aimPoint;
      //  Debug.DrawLine(transform.position,transform.position+transform.forward*100,Color.red);
       // Debug.Log(playerData.cameraData.aimPoint);

    }

    private void LateUpdate()
    {   orbitAngles = new Vector2(playerData.rotatey, playerData.rotatex);
        orbitAngles.x = Mathf.Clamp(orbitAngles.x, minAngle, maxAngle);
        orbitRotation=Quaternion.Euler(orbitAngles);
        Quaternion lookRotation = gravityAlignment * orbitRotation;
        gravityAlignment =
            Quaternion.FromToRotation(
                gravityAlignment * Vector3.up,  -CustomGravity.GetGravity(focusPoint)
            ) * gravityAlignment;
        UpdateFocusPoint();
      //-  Quaternion lookRotation = Quaternion.Euler(orbitAngles);
        Vector3 lookDirection = lookRotation * Vector3.forward;
        Vector3 lookPosition = focusPoint - lookDirection * distance;
        transform.SetPositionAndRotation(lookPosition, lookRotation);
    //    Debug.DrawLine(transform.position,focusPoint,Color.red);
    }
    
    void UpdateFocusPoint () {
        Vector3 targetPoint = focus.position;
        if (focusRadius > 0f) {
            float distance = Vector3.Distance(targetPoint, focusPoint);
            float t = 1f;
            if (distance > 0.01f && focusCentering > 0f) {
                t = Mathf.Pow(1f - focusCentering, Time.deltaTime);
            }
            if (distance > focusRadius) {
                //focusPoint = Vector3.Lerp(
                //	targetPoint, focusPoint, focusRadius / distance
                //);
                t = Mathf.Min(t, focusRadius / distance);
            }
            focusPoint = Vector3.Lerp(targetPoint, focusPoint, t);
        }
        else {
            focusPoint = targetPoint;
        }
    }
}
