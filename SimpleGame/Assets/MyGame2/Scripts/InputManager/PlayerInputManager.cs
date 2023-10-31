using System;
using UnityEngine;

public class PlayerInputManager:MonoBehaviour,IPlayerInputManager
{
    public InputDataNew InputDataNew;
    
    public Button buttonA;
    public Button buttonS;
    public Button buttonD;
    public Button buttonW;

    private void Awake()
    {
        InputDataNew = GetComponent<InputDataNew>();
    }

    public void ChangeInputData(InputDataNew data)
    {
       
    }

    public InputDataNew GetInputData()
    {
        return this.InputDataNew;
    }

    private void Update()
    {
        ChangeInputData(this.InputDataNew);
    }
}
