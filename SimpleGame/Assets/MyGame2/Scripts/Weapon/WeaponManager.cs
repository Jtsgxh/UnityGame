using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WeaponManager : MonoBehaviour
{
    public WeaponBagData BagData;
    public WeaponManageMethod weaponManageMethod;
    private InputDataNew InputDataNew;
    private Transform mainCamera;
    [SerializeField]
    private GunData GunData;
    //这里临时先通过这样获取相机和添加基础武器信息
    public void Awake()
    {
        BagData = GetComponent<WeaponBagData>();
        weaponManageMethod = new WeaponManageMethod01(this);
        InputDataNew = gameObject.GetComponent<InputDataNew>();
        mainCamera = Camera.main.transform;
    
    }

    private void Start()
    {
        var weaponInfo = weaponManageMethod.BuildWeapon(GunData);
        InitWeapon(weaponInfo);
    }


    private void Update()
    {
        if (InputDataNew.shoot)
        {
            weaponManageMethod.Shoot(mainCamera.forward);
        }
    }

    public WeaponInfo NowWeaponInfo
    {
        get
        {
            return BagData.weaponInfos[BagData.nowWeaponIndex];
        }
    }

    public void InitWeapon(WeaponInfo info)
    {
        weaponManageMethod.AddWeapon(info);
    }
    
   
}
