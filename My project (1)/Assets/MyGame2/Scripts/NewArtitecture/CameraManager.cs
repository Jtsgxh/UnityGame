using System;
using UnityEngine;

public class CameraManager:MonoBehaviour
{
    public Transform focus;
    public float distance;
    public Vector3 focusPoint;
    public PlayerData playerData;
    [SerializeField, Min(0f)]
    float focusRadius = 1f;
    [SerializeField, Range(0f, 1f)]
    float focusCentering = 0.5f;
    Vector2 orbitAngles = new Vector2(45f, 0f);
    private void Awake()
    {
        focusPoint = focus.position;
    }

    private void Start()
    {
        
    }

    private void Update()
    {
        RaycastHit hit;
        if (Physics.Raycast(transform.position, transform.forward, out hit, 100))
        {
            playerData.cameraData.aimPoint=hit.point;
        }
        else
        {
            playerData.cameraData.aimPoint = transform.position + transform.forward * 100;
        }
      //  GameObject.CreatePrimitive(PrimitiveType.Sphere).transform.position = playerData.cameraData.aimPoint;
      //  Debug.DrawLine(transform.position,transform.position+transform.forward*100,Color.red);
       // Debug.Log(playerData.cameraData.aimPoint);

    }

    private void LateUpdate()
    {   orbitAngles = new Vector2(playerData.inputData.rotatey, playerData.inputData.rotatex);
        UpdateFocusPoint();
        Quaternion lookRotation = Quaternion.Euler(orbitAngles);
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
