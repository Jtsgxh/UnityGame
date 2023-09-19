using System;
using MyGame2.Scripts.NewArtitecture;
using UnityEngine;
using UnityEngine.Rendering;

public class InputManager:MonoBehaviour
{
    private const string MouseXInput = "Mouse X";
    private const string MouseYInput = "Mouse Y";
    private const string MouseScrollInput = "Mouse ScrollWheel";
    private const string HorizontalInput = "Horizontal";
    private const string VerticalInput = "Vertical";
    private PlayerData playerData;
    public float rotateX;
    public float rotateY;
    public float rotateXX;
    public float rotateYY;
    public bool revertX;
    public bool revertY;
    private void Awake()
    {
        playerData = GetComponent<PlayerData>();
    }

    private void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;
    }

    private void Update()
    {
        var characterInputs = new InputData();
        HandleCharacterInput(characterInputs);
        HandleCameraInput(characterInputs);
        playerData.inputData = characterInputs;
    }

    private void HandleCharacterInput(InputData characterInputs)
    {
        // Build the CharacterInputs struct
                characterInputs.MoveAxisForward = Input.GetAxisRaw(VerticalInput);
                characterInputs.MoveAxisRight = Input.GetAxisRaw(HorizontalInput);
                characterInputs.rush= Input.GetKey(KeyCode.LeftShift);
                if (Input.GetKey(KeyCode.Alpha1))
                {
                    characterInputs.weapon = 1;
                }
                else if(Input.GetKey(KeyCode.V))
                {
                    characterInputs.weapon=0;
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
                playerData.inputData = characterInputs;
    }

    private void HandleCameraInput(InputData characterInputs)
    {
        float mouseLookAxisUp = Input.GetAxisRaw(MouseYInput);
        float mouseLookAxisRight = Input.GetAxisRaw(MouseXInput);
        rotateX += mouseLookAxisRight;
        rotateY += mouseLookAxisUp;
        rotateXX=rotateX;
        rotateYY=rotateY;
        //Vector3 lookInputVector = new Vector3(mouseLookAxisRight, mouseLookAxisUp, 0f);
        //rotate camera
        if (revertX)
        {
            rotateXX=-rotateX;
        }
        if(revertY)
        {
            rotateYY=-rotateY;
        }

        characterInputs.rotatex = rotateXX;
        characterInputs.rotatey = rotateYY;
        characterInputs.CameraRotation = Quaternion.Euler(rotateYY, rotateXX, 0);
    }
}
