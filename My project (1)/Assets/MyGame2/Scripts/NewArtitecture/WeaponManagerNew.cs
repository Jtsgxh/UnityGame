using System;
using UnityEngine;

public class WeaponManagerNew:MonoBehaviour
{
    public PlayerData playerData;
    public Transform leftHand;
    public Transform rightHand;
    
    public float lastReloadTime;
    public bool isReloading;
    public bool isLastPressShoot;
    public bool nowPressShoot;
    public bool isPressDown;
    public bool isPress;
    public float sinceLastShootTime;
    private void Awake()
    {
        playerData = GetComponent<PlayerData>();
        
    }

    private void Start()
    {
       InitWeaponList();
    }

    public void AddNewWeapon()
    {
        
    }

    public void InitWeaponList()
    {
         playerData.weaponData.weaponList = new WeaponNew[2];
         GameObject WaterPrefab =(GameObject) Resources.Load("WaterGun");
         var WaterGun = GameObject.Instantiate(WaterPrefab, rightHand);
         playerData.weaponData.weaponList[0] = WaterGun.GetComponent<WaterGun>();
         
    }
    public void Update()
    {


      //  SetShoot(playerData.inputData.shoot,Time.deltaTime);
        
        if (playerData.inputData.reload)
        {
            Reload();
        }
        if (playerData.inputData.weapon != playerData.weaponData.nowWeapon)
        {
            ChangeWeapon((int) playerData.inputData.weapon);
        }
    }

    public void Reload()
    {
        
    }

    public void ChangeWeapon(int weaponIndex)
    {
        playerData.weaponData.nowWeapon=weaponIndex;
    }

    public WeaponNew GetNowWeapon()
    {
        return playerData.weaponData.weaponList[playerData.weaponData.nowWeapon];
    }
    public void SetShoot(bool isShoot,float deltaTime)
    {
        if (isShoot)
        {
            isLastPressShoot = nowPressShoot;
            nowPressShoot = true;
            isPressDown = !isLastPressShoot && nowPressShoot;
            isPress = isLastPressShoot && nowPressShoot;
        }
        else
        {
            isLastPressShoot = nowPressShoot;
            nowPressShoot = false;
            isPressDown = false;
            isPress = false;
        }
        Shoot(deltaTime);
    }
    public void Shoot(float deltaTime)
    {
        var weapon = GetNowWeapon();
        sinceLastShootTime += deltaTime;
        var nowWeapon = GetNowWeapon();
        if (nowWeapon.bulletInMagazine<=0)
        {
            return;
        }
        if(sinceLastShootTime<nowWeapon.shootInterval) return;
        if (isPress && nowWeapon.weaponMode == WeaponNew.WeaponMode.auto)
        {
            Shoot(weapon);
            sinceLastShootTime = 0;
        }
        else if (isPressDown && nowWeapon.weaponMode == WeaponNew.WeaponMode.semi)
        {
            Shoot(weapon);
            sinceLastShootTime = 0;
        }
        else
        {
            return;
        }
        
        
    }

    private void Shoot(WeaponNew weapon)
    {
        var bullet = GameObject.CreatePrimitive(PrimitiveType.Sphere);
        bullet.transform.position = weapon.shootPoint.position;
        bullet.transform.localScale = new Vector3(0.1f,0.1f,0.1f);
        bullet.AddComponent<Rigidbody>();
        bullet.GetComponent<Rigidbody>().AddForce((playerData.cameraData.aimPoint- weapon.shootPoint.position).normalized*weapon.bulletSpeed,ForceMode.Impulse);
    }
}


