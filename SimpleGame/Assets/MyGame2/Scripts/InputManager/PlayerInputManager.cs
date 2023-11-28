using System;
using UnityEngine;

public class PlayerInputManager:MonoBehaviour,IPlayerInputManager
{
    public InputDataNew InputDataNew;
    private const string MouseXInput = "Mouse X";
    private const string MouseYInput = "Mouse Y";
    private const string MouseScrollInput = "Mouse ScrollWheel";
    private const string HorizontalInput = "Horizontal";
    private const string VerticalInput = "Vertical";
    public float rotateX;
    public float rotateY;
    public float rotateXX;
    public float rotateYY;
    public bool revertX;
    public bool revertY;
    public Button buttonA;
    public Button buttonS;
    public Button buttonD;
    public Button buttonW;
    public Button space;
    public Button Mouse0;

    private void Awake()
    {
        InputDataNew = GetComponent<InputDataNew>();
        buttonA = new Button();
        buttonS = new Button();
        buttonD = new Button();
        buttonW = new Button();
        space = new Button();
        Mouse0 = new Button();
        space.RegisterOnPressed(delegate { InputDataNew.desiredJump = true; });
        space.RegisterOnHeld(delegate { InputDataNew.desiredClimb = true; });
        space.RegisterListenInput(delegate {
            if (Input.GetKey(KeyCode.Space))
            {
                space.Press(true);
            }
            else
            {
                space.Press(false);
            }
        });
        Mouse0.RegisterOnPressed(delegate { InputDataNew.shoot = true; });
        Mouse0.RegisterListenInput(delegate
        {
            if (Input.GetKey(KeyCode.Mouse0))
            {
                Mouse0.Press(true);
            }
            else
            {
                Mouse0.Press(false);
            }
        });
        buttonA.RegisterOnHeld(delegate { InputDataNew.MoveAxisRight = -1; });
        buttonA.RegisterListenInput(delegate
        {
            if (Input.GetKey(KeyCode.A))
            {
                buttonA.Press(true);
            }
            else
            {
                buttonA.Press(false);
            }
        });
        buttonS.RegisterOnHeld(delegate { InputDataNew.MoveAxisForward = -1; });
        buttonS.RegisterListenInput(delegate
        {
            if (Input.GetKey(KeyCode.S))
            {
                buttonS.Press(true);
            }
            else
            {
                buttonS.Press(false);
            }
        });
        buttonD.RegisterOnHeld(delegate { InputDataNew.MoveAxisRight = 1; });
        buttonD.RegisterListenInput(delegate
        {
            if (Input.GetKey(KeyCode.D))
            {
                buttonD.Press(true);
            }
            else
            {
                buttonD.Press(false);
            }
        });
        buttonW.RegisterOnHeld(delegate { InputDataNew.MoveAxisForward = 1; });
        buttonW.RegisterListenInput(delegate
        {
            if (Input.GetKey(KeyCode.W))
            {
                buttonW.Press(true);
            }
            else
            {
                buttonW.Press(false);
            }
        });
    }
    
    
    
    

    public InputDataNew GetInputData()
    {
        return this.InputDataNew;
    }

    private void Update()
    {
        
        HandleCameraInput(InputDataNew);
    }

    private void FixedUpdate()
    {
        InputDataNew.Clear();
        buttonA.Update();
        buttonS.Update(); 
        buttonD.Update();
        buttonW.Update();
        space.Update();
        Mouse0.Update();
    }


    private void HandleCameraInput(InputDataNew characterInputs)
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
