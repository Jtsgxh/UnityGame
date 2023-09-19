/*
using System;
using System.Collections;
using System.Collections.Generic;
using KinematicCharacterController.Examples;
using Unity.VisualScripting;
using UnityEngine;

public class Player : MonoBehaviour
{
    public struct PlayerCharacterInput
    {
        public float MoveAxisForward;
        public float MoveAxisRight;
        public Quaternion CameraRotation;
        public bool JumpDown;
        public bool CrouchDown;
        public bool CrouchUp;
        public bool rush;
        public Weapon.WeaponType  weapon;
        public bool shoot;
        public bool reload;
    }
    #region Private Variables
       private const string MouseXInput = "Mouse X";
       private const string MouseYInput = "Mouse Y";
       private const string MouseScrollInput = "Mouse ScrollWheel";
       private const string HorizontalInput = "Horizontal";
       private const string VerticalInput = "Vertical";
       #endregion

       public float rotateX;
       public float rotateY;
       public float rotateXX;
       public float rotateYY;
       public bool revertX;
       public bool revertY;
       public PlayerCharacterInput characterInputs;
       public Camera orbitCamera;
       public Transform cameraFollowPoint;
       public CharacterControllerLearn character;

       // Start is called before the first frame update
    void Start()
    {
        /*orbitCamera.SetFollowTransform(cameraFollowPoint);
        orbitCamera.IgnoredColliders.Clear();
        orbitCamera.IgnoredColliders.AddRange(character.GetComponentsInChildren<Collider>());#1#
        ManagerList.Instance.player = this;
    }

    // Update is called once per frame
    void Update()
    {
       /* if (Input.GetMouseButtonDown(0))
        {
            Cursor.lockState = CursorLockMode.Locked;
        }#1#

        HandleCharacterInput();
        HandleCameraInput();
    }

    private void LateUpdate()
    {
      //  HandleCameraInput();
    }

    private void HandleCameraInput()
    {
        // Create the look input vector for the camera
        float mouseLookAxisUp = Input.GetAxisRaw(MouseYInput);
        float mouseLookAxisRight = Input.GetAxisRaw(MouseXInput);
        rotateX += mouseLookAxisRight;
        rotateY+=mouseLookAxisUp;
        rotateXX=rotateX;
        rotateYY=rotateY;
        Vector3 lookInputVector = new Vector3(mouseLookAxisRight, mouseLookAxisUp, 0f);
        //rotate camera
        if (revertX)
        {
            rotateXX=-rotateX;
        }
        if(revertY)
        {
            rotateYY=-rotateY;
        }
        cameraFollowPoint.transform.rotation = Quaternion.Euler(rotateYY, rotateXX, 0);
        // Prevent moving the camera while the cursor isn't locked
        if (Cursor.lockState != CursorLockMode.Locked)
        {
            lookInputVector = Vector3.zero;
        }

        // Input for zooming the camera (disabled in WebGL because it can cause problems)
        float scrollInput = -Input.GetAxis(MouseScrollInput);
#if UNITY_WEBGL
        scrollInput = 0f;
#endif

        // Apply inputs to the camera
        /*orbitCamera.UpdateWithInput(Time.deltaTime, scrollInput, lookInputVector);

        // Handle toggling zoom level
        if (Input.GetMouseButtonDown(1))
        {
            orbitCamera.TargetDistance = (orbitCamera.TargetDistance == 0f) ? orbitCamera.DefaultDistance : 0f;
        }#1#
    }
    
    private void HandleCharacterInput()
    { 
        characterInputs = new PlayerCharacterInput();

        // Build the CharacterInputs struct
        characterInputs.MoveAxisForward = Input.GetAxisRaw(VerticalInput);
        characterInputs.MoveAxisRight = Input.GetAxisRaw(HorizontalInput);
        characterInputs.CameraRotation = orbitCamera.transform.rotation;
        characterInputs.rush= Input.GetKey(KeyCode.LeftShift);
        if (Input.GetKey(KeyCode.Alpha1))
        {
            characterInputs.weapon = Weapon.WeaponType.Rifle;
        }
        else if(Input.GetKey(KeyCode.V))
        {
            characterInputs.weapon=Weapon.WeaponType.None;
        }
        characterInputs.JumpDown = Input.GetKey(KeyCode.Space);
        if (Input.GetMouseButton(0))
        {
            characterInputs.shoot = true;
        }
        if (Input.GetKey(KeyCode.R))
        {
            characterInputs.reload = true;
        }
        // Apply inputs to character
        character.SetInputs(ref characterInputs);
    }
}
*/
