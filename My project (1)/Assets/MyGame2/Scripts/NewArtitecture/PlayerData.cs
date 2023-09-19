using UnityEngine;

public class InputData
{
    public float MoveAxisForward;
    public float MoveAxisRight;
    public Quaternion CameraRotation;
    public bool JumpDown;
    public bool CrouchDown;
    public bool CrouchUp;
    public bool rush;
    public int  weapon;
    public bool shoot;
    public bool reload;
    public float rotatex;
    public float rotatey;
}

public class CharacterControllerData
{
    [Header("Stable Movement")]
    public float MaxStableMoveSpeed = 10f;
    public float StableMovementSharpness = 15;
    public float OrientationSharpness = 10;
    [SerializeField]
    public float JumpSpeed = 10f;
    [Header("Air Movement")]
    public float MaxAirMoveSpeed = 0.2f;
    public float AirAccelerationSpeed = 5f;
    public float Drag = 0.1f;

    #region MovePart
    public Vector3 moveInputVector;
    public Vector3 lookInputVector;
    public  Vector3 jumpAddVelocity=Vector3.zero;
    public Vector3 gravity = new Vector3(0, -9.8f, 0);
    #endregion
}

public class WeaponData
{
    public int nowWeapon;
    public WeaponNew[] weaponList;
    public int bulletInBag;
}
public class CameraData
{
    public Vector3 aimPoint;
}

public class PlayerData:MonoBehaviour {
    [SerializeField]
    public InputData inputData;
    public CharacterControllerData characterControllerData;
    public CameraData cameraData;
    public WeaponData weaponData;
    private void Awake()
    {
        inputData = new InputData();
        characterControllerData = new CharacterControllerData();
        cameraData = new CameraData();
        weaponData = new WeaponData();
    }

    private void Start()
    {
        
    }
}

